# ALTAS Workflow 流程图集

> 本文件存放 ALTAS Workflow 的所有 Mermaid 流程图，供需要可视化参考时查阅。

---

## 1. 架构总览图

```mermaid
%%{init: {'theme':'base'}}%%
graph TB
    subgraph "规模评估"
        A["接收任务"] --> B{"复杂度评估?"}
        B -->|"typo/<10行"| C["Size XS"]
        B -->|"1-2文件"| D["Size S"]
        B -->|"3-10文件"| E["Size M"]
        B -->|"跨模块/>500行"| F["Size L"]
    end

    C --> G1["直接执行"]
    D --> G2["micro-spec"]
    G2 --> H2["批准"]
    H2 --> I2["执行"]
    I2 --> J2["回写"]
    E --> G3["Research"]
    G3 --> H3["Plan"]
    H3 --> I3["Execute TDD"]
    I3 --> J3["Review三轴"]
    F --> G4["Research"]
    G4 --> H4["Innovate"]
    H4 --> I4["Plan"]
    I4 --> J4["Execute TDD"]
    J4 --> K4["Subagent"]
    K4 --> L4["Review三轴"]
    L4 --> M4["Archive"]

    G1 --> Z["验证/summary"]
    J2 --> Z
    J3 --> Z
    M4 --> Z
```

---

## 2. 阶段流程图 (Size M/L)

```mermaid
flowchart LR
    subgraph 输入准备
        PR[PRE-RESEARCH / create_codemap / build_context_bundle]
    end

    subgraph 核心阶段
        R[RESEARCH / 目标对齐 / 事实依据 / 未知标注] --> I[INNOVATE / 方案对比 / Pros/Cons/Risks]
        I --> P[PLAN / Checklist拆解 / File Changes / Signatures]
        P --> E[EXECUTE / RED→GREEN→REFACTOR / TDD循环]
        E --> RV[REVIEW / 三轴评审 / Spec/代码/质量]
    end

    subgraph 收尾
        RV --> AR[ARCHIVE / human版 / llm版]
    end

    PR --> R
    RV -.->|失败| R
    RV -.->|失败| P
```

---

## 3. 铁律与门禁图

```mermaid
flowchart TB
    subgraph 铁律约束
        direction TB
        L1["1. No Spec, No Code"]:::warning
        L2["2. No Approval, No Execute"]:::warning
        L3["3. Spec is Truth"]:::warning
        L4["4. Reverse Sync"]:::warning
        L5["5. Evidence First"]:::warning
        L6["6. No Root Cause, No Fix"]:::warning
        L7["7. TDD Iron Law"]:::warning
        L8["8. Resume Ready"]:::warning
        
        L1 --> L2 --> L3 --> L4 --> L5 --> L6 --> L7 --> L8
    end
    
    subgraph 执行门禁
        direction TB
        E1[Research 完成] --> E2{事实有据？<br/>未知已标？}
        E2 -->|通过 | E3[Plan 完成]
        E3 --> E4{"[Approved]?"}
        E4 -->|通过 | E5[Execute TDD]
        E5 --> E6{Review 三轴}
        
        E6 -->|"轴 1/轴 2 FAIL"| R1[回到 Research/Plan]
        E6 -->|"轴 3 高风险"| R2[回到 Plan]
        E6 -->|"全部 PASS"| E7[完成/Archive]
    end
    
    classDef warning stroke:#333,stroke-width:2px,font-size:14px
    classDef default font-size:14px
```

---

## 4. Review三轴评审图

```mermaid
flowchart TB
    subgraph 三轴评审
        A1[轴1: Spec质量与需求达成 / Goal/In-Scope/Acceptance] --> R1{PASS?}
        A2[轴2: Spec-代码一致性 / 文件/签名/Checklist/行为] --> R2{PASS?}
        A3[轴3: 代码内在质量 / 正确性/鲁棒性/可维护性/测试] --> R3{高风险?}
    end
    
    R1 -->|"FAIL"| BACK1[回到Research/Plan]
    R2 -->|"FAIL"| BACK1
    R3 -->|"有高风险未解决"| BACK2[回到Plan]
    
    R1 -->|"PASS"| NEXT[进入下一步/Archive]
    R2 -->|"PASS"| NEXT
    R3 -->|"无高风险"| NEXT
```

---

## 5. Size L工作流甘特图

```mermaid
gantt
    title ALTAS Workflow Size L 阶段规划
    dateFormat X
    axisFormat %s
    
    section PRE-RESEARCH
    create_codemap           :done, p1, 0, 5
    build_context_bundle     :done, p2, 3, 8
    
    section 核心阶段
    Research                 :active, r1, 8, 25
    Innovate方案对比          :active, i1, 20, 35
    Plan                     :active, pl1, 30, 45
    Execute TDD循环          :active, e1, 45, 120
    Subagent驱动             :active, s1, 60, 110
    Review三轴评审           :active, rv1, 115, 130
    
    section 收尾
    Archive知识沉淀           :active, a1, 125, 140
```

---

## 6. TDD执行循环图

```mermaid
flowchart LR
    subgraph TDD循环
        R[RED / 写失败测试] --> G[GREEN / 通过最小代码]
        G --> RF[REFACTOR / 重构优化]
        RF -->|继续| R
    end

    E[Execute] -->|"逐步执行"| T{TDDCycle}
    T -->|批量| B[全部执行]
    B --> Z[验证→summary]
```

---

## 7. 特殊模式总览图

```mermaid
flowchart TB
    subgraph 特殊模式
        F[FAST模式 / >>前缀/FAST/快速]
        D[DEBUG模式 / DEBUG/排查]
        M[MULTI模式 / 多项目协作]
        DC[DOC模式 / 文档专家]
    end
    
    F --> F1[跳过Research/Plan]
    F --> F2[直接执行]
    F --> F3[事后同步Spec]
    
    D --> D1[诊断模式 / 日志+Spec+代码三角定位]
    D --> D2[验证模式 / 日志证据vs Spec验收]
    
    M --> M1[自动发现子项目]
    M --> M2[CROSS跨项目协作]
    
    DC --> DC1[Absorb提取上下文]
    DC --> DC2[Outline大纲]
    DC --> DC3[Author撰写]
    DC --> DC4[Fact-Check验证]
```

---

## 8. 参考资料索引图

```mermaid
mindmap
    root((参考资料))
        Spec驱动开发
            spec-template.md
            commands.md
            workflow-quickref.md
            usage-examples.md
            multi-project.md
            archive-template.md
            sdd-riper-one-protocol.md
        Checkpoint驱动
            modules.md
            conventions.md
            spec-lite-template.md
        Superpowers
            brainstorming
            writing-plans
            test-driven-development
            systematic-debugging
            subagent-driven-development
            verification-before-completion
            executing-plans
            requesting-code-review
            receiving-code-review
        协议
            RIPER-5
            SDD-RIPER-DUAL-COOP
            RIPER-DOC
        方法论
            从传统到大模型
            团队落地指南
            手把手教程
            AI原生研发范式
```

---

## 9. 上下文装配层级图

```mermaid
flowchart TB
    subgraph 上下文层级
        H[Hot每轮 / phase/approval/Spec路径 / Goal/Scope/Checklist]
        W[Warm阶段切换 / 研究发现/Plan签名 / 验证结果]
        C[Cold按需 / 完整ChangeLog / 历史Research/CodeMap]
    end
    
    H -->|每轮加载| R[执行对话]
    W -->|阶段切换时| T[Research→Plan / Plan→Execute / Execute→Review]
    C -->|冲突/不确定| X[从磁盘重读Spec]
    
    R --> T
    T -.->|门禁触发| X
```

---

## 10. 触发词与模式映射图

```mermaid
flowchart TB
    subgraph 触发词
        T1["FAST/快速/>>"]:::fast --> F[极速通道]
        T2["DEEP"]:::deep --> DL[Size L 深度]
        T3["MAP/链路梳理"]:::map --> CM[功能级 CodeMap]
        T4["PROJECT MAP"]:::map --> PM[项目级 CodeMap]
        T5["MULTI/多项目"]:::multi --> ML[多项目模式]
        T6["DEBUG/排查"]:::debug --> DB[DEBUG 系统化排查]
        T7["REVIEW SPEC"]:::review --> RS[计划评审]
        T8["REVIEW EXECUTE"]:::review --> RE[代码评审]
        T9["ARCHIVE/归档"]:::archive --> AR[知识沉淀]
        T10["DOC/写文档"]:::doc --> DC[DOC 文档专家]
    end
    
    classDef fast stroke:#333,stroke-width:2px,font-size:14px
    classDef deep stroke:#333,stroke-width:2px,font-size:14px
    classDef map stroke:#333,stroke-width:2px,font-size:14px
    classDef multi stroke:#333,stroke-width:2px,font-size:14px
    classDef debug stroke:#333,stroke-width:2px,font-size:14px
    classDef review stroke:#333,stroke-width:2px,font-size:14px
    classDef archive stroke:#333,stroke-width:2px,font-size:14px
    classDef doc stroke:#333,stroke-width:2px,font-size:14px
    classDef default font-size:14px
```

---

## 11. 完整工作流时序图

```mermaid
sequenceDiagram
    participant U as 用户
    participant AI as ALTAS
    
    Note over U,AI: 接收任务
    U->>AI: 描述任务
    AI->>AI: 规模评估 (XS/S/M/L)
    
    alt Size XS
        AI->>AI: 直接执行
        AI->>U: 验证结果 + 1行summary
    end
    
    alt Size S
        AI->>AI: 写micro-spec
        AI->>U: 等待批准
        U->>AI: [Approved]
        AI->>AI: 执行
        AI->>AI: 回写
        AI->>U: 完成
    end
    
    alt Size M
        AI->>AI: Research → 用户确认
        AI->>AI: Plan → 用户批准
        loop TDD循环
            AI->>AI: RED → GREEN → REFACTOR
        end
        AI->>AI: Review三轴评审
        AI->>U: 完成
    end
    
    alt Size L
        AI->>AI: Research → 用户确认
        AI->>AI: Innovate方案对比 → 用户选定
        AI->>AI: Plan → 用户批准
        loop TDD + Subagent
            AI->>AI: RED → GREEN → REFACTOR
        end
        AI->>AI: Review三轴评审
        AI->>AI: Archive知识沉淀
        AI->>U: 完成
    end
```
