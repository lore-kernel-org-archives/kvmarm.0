From: Timur Tabi <timur@codeaurora.org>
Subject: Re: [PATCH v2 2/5] arm64: Work around Falkor erratum 1003
Date: Thu, 29 Dec 2016 17:02:40 -0600
Message-ID: <1dfdc578-e0f8-1320-d223-c9c55e70ca93@codeaurora.org>
References: <20161229224335.13531-1-cov@codeaurora.org>
 <20161229224335.13531-2-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F16F540199
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2016 18:01:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sochP9Y9fZXH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Dec 2016 18:01:16 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A9CC540197
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2016 18:01:16 -0500 (EST)
In-Reply-To: <20161229224335.13531-2-cov@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, shankerd@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 12/29/2016 04:43 PM, Christopher Covington wrote:
> -| Implementor    | Component       | Erratum ID      | Kconfig                 |
> -+----------------+-----------------+-----------------+-------------------------+
> -| ARM            | Cortex-A53      | #826319         | ARM64_ERRATUM_826319    |
> -| ARM            | Cortex-A53      | #827319         | ARM64_ERRATUM_827319    |
> -| ARM            | Cortex-A53      | #824069         | ARM64_ERRATUM_824069    |
> -| ARM            | Cortex-A53      | #819472         | ARM64_ERRATUM_819472    |
> -| ARM            | Cortex-A53      | #845719         | ARM64_ERRATUM_845719    |
> -| ARM            | Cortex-A53      | #843419         | ARM64_ERRATUM_843419    |
> -| ARM            | Cortex-A57      | #832075         | ARM64_ERRATUM_832075    |
> -| ARM            | Cortex-A57      | #852523         | N/A                     |
> -| ARM            | Cortex-A57      | #834220         | ARM64_ERRATUM_834220    |
> -| ARM            | Cortex-A72      | #853709         | N/A                     |
> -| ARM            | MMU-500         | #841119,#826419 | N/A                     |
> -|                |                 |                 |                         |
> -| Cavium         | ThunderX ITS    | #22375, #24313  | CAVIUM_ERRATUM_22375    |
> -| Cavium         | ThunderX ITS    | #23144          | CAVIUM_ERRATUM_23144    |
> -| Cavium         | ThunderX GICv3  | #23154          | CAVIUM_ERRATUM_23154    |
> -| Cavium         | ThunderX Core   | #27456          | CAVIUM_ERRATUM_27456    |
> -| Cavium         | ThunderX SMMUv2 | #27704          | N/A		       |
> -|                |                 |                 |                         |
> -| Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585     |
> +| Implementor   | Component       | Erratum ID      | Kconfig                  |
> ++---------------+-----------------+-----------------+--------------------------+
> +| ARM           | Cortex-A53      | #826319         | ARM64_ERRATUM_826319     |
> +| ARM           | Cortex-A53      | #827319         | ARM64_ERRATUM_827319     |
> +| ARM           | Cortex-A53      | #824069         | ARM64_ERRATUM_824069     |
> +| ARM           | Cortex-A53      | #819472         | ARM64_ERRATUM_819472     |
> +| ARM           | Cortex-A53      | #845719         | ARM64_ERRATUM_845719     |
> +| ARM           | Cortex-A53      | #843419         | ARM64_ERRATUM_843419     |
> +| ARM           | Cortex-A57      | #832075         | ARM64_ERRATUM_832075     |
> +| ARM           | Cortex-A57      | #852523         | N/A                      |
> +| ARM           | Cortex-A57      | #834220         | ARM64_ERRATUM_834220     |
> +| ARM           | Cortex-A72      | #853709         | N/A                      |
> +| ARM           | MMU-500         | #841119,#826419 | N/A                      |
> +|               |                 |                 |                          |
> +| Cavium        | ThunderX ITS    | #22375, #24313  | CAVIUM_ERRATUM_22375     |
> +| Cavium        | ThunderX ITS    | #23144          | CAVIUM_ERRATUM_23144     |
> +| Cavium        | ThunderX GICv3  | #23154          | CAVIUM_ERRATUM_23154     |
> +| Cavium        | ThunderX Core   | #27456          | CAVIUM_ERRATUM_27456     |
> +| Cavium        | ThunderX SMMUv2 | #27704          | N/A                      |
> +|               |                 |                 |                          |
> +| Freescale/NXP | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585      |
> +| Qualcomm      | Falkor v1       | E1003           | QCOM_FALKOR_ERRATUM_1003 |

Looks like you've made an unrelated whitespace change that affected the entire table,
not just the line you're adding.

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc.  Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
