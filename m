From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH v2 2/5] arm64: Work around Falkor erratum 1003
Date: Fri, 6 Jan 2017 10:39:45 -0500
Message-ID: <fd82e2bf-5259-2fda-c931-1996387d779f@codeaurora.org>
References: <20161229224335.13531-1-cov@codeaurora.org>
 <20161229224335.13531-2-cov@codeaurora.org>
 <1dfdc578-e0f8-1320-d223-c9c55e70ca93@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1dfdc578-e0f8-1320-d223-c9c55e70ca93@codeaurora.org>
Sender: linux-doc-owner@vger.kernel.org
To: Timur Tabi <timur@codeaurora.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, shankerd@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 12/29/2016 06:02 PM, Timur Tabi wrote:
> On 12/29/2016 04:43 PM, Christopher Covington wrote:
>> -| Implementor    | Component       | Erratum ID      | Kconfig                 |
>> -+----------------+-----------------+-----------------+-------------------------+
>> -| ARM            | Cortex-A53      | #826319         | ARM64_ERRATUM_826319    |
>> -| ARM            | Cortex-A53      | #827319         | ARM64_ERRATUM_827319    |
>> -| ARM            | Cortex-A53      | #824069         | ARM64_ERRATUM_824069    |
>> -| ARM            | Cortex-A53      | #819472         | ARM64_ERRATUM_819472    |
>> -| ARM            | Cortex-A53      | #845719         | ARM64_ERRATUM_845719    |
>> -| ARM            | Cortex-A53      | #843419         | ARM64_ERRATUM_843419    |
>> -| ARM            | Cortex-A57      | #832075         | ARM64_ERRATUM_832075    |
>> -| ARM            | Cortex-A57      | #852523         | N/A                     |
>> -| ARM            | Cortex-A57      | #834220         | ARM64_ERRATUM_834220    |
>> -| ARM            | Cortex-A72      | #853709         | N/A                     |
>> -| ARM            | MMU-500         | #841119,#826419 | N/A                     |
>> -|                |                 |                 |                         |
>> -| Cavium         | ThunderX ITS    | #22375, #24313  | CAVIUM_ERRATUM_22375    |
>> -| Cavium         | ThunderX ITS    | #23144          | CAVIUM_ERRATUM_23144    |
>> -| Cavium         | ThunderX GICv3  | #23154          | CAVIUM_ERRATUM_23154    |
>> -| Cavium         | ThunderX Core   | #27456          | CAVIUM_ERRATUM_27456    |
>> -| Cavium         | ThunderX SMMUv2 | #27704          | N/A               |
>> -|                |                 |                 |                         |
>> -| Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585     |
>> +| Implementor   | Component       | Erratum ID      | Kconfig                  |
>> ++---------------+-----------------+-----------------+--------------------------+
>> +| ARM           | Cortex-A53      | #826319         | ARM64_ERRATUM_826319     |
>> +| ARM           | Cortex-A53      | #827319         | ARM64_ERRATUM_827319     |
>> +| ARM           | Cortex-A53      | #824069         | ARM64_ERRATUM_824069     |
>> +| ARM           | Cortex-A53      | #819472         | ARM64_ERRATUM_819472     |
>> +| ARM           | Cortex-A53      | #845719         | ARM64_ERRATUM_845719     |
>> +| ARM           | Cortex-A53      | #843419         | ARM64_ERRATUM_843419     |
>> +| ARM           | Cortex-A57      | #832075         | ARM64_ERRATUM_832075     |
>> +| ARM           | Cortex-A57      | #852523         | N/A                      |
>> +| ARM           | Cortex-A57      | #834220         | ARM64_ERRATUM_834220     |
>> +| ARM           | Cortex-A72      | #853709         | N/A                      |
>> +| ARM           | MMU-500         | #841119,#826419 | N/A                      |
>> +|               |                 |                 |                          |
>> +| Cavium        | ThunderX ITS    | #22375, #24313  | CAVIUM_ERRATUM_22375     |
>> +| Cavium        | ThunderX ITS    | #23144          | CAVIUM_ERRATUM_23144     |
>> +| Cavium        | ThunderX GICv3  | #23154          | CAVIUM_ERRATUM_23154     |
>> +| Cavium        | ThunderX Core   | #27456          | CAVIUM_ERRATUM_27456     |
>> +| Cavium        | ThunderX SMMUv2 | #27704          | N/A                      |
>> +|               |                 |                 |                          |
>> +| Freescale/NXP | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585      |
>> +| Qualcomm      | Falkor v1       | E1003           | QCOM_FALKOR_ERRATUM_1003 |
> 
> Looks like you've made an unrelated whitespace change that affected the entire table,
> not just the line you're adding.

I'm making space for "QCOM_FALKOR_ERRATUM_1003".

Cov

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code
Aurora Forum, a Linux Foundation Collaborative Project.
