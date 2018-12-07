From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v5 4/4] arm64: KVM: Enable support for :G/:H perf event
 modifiers
Date: Fri, 7 Dec 2018 14:24:24 +0000
Message-ID: <261f418f-ff68-069c-51e3-1f630786d88f@arm.com>
References: <1544023815-16958-1-git-send-email-andrew.murray@arm.com>
 <1544023815-16958-5-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B20434A2FB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Dec 2018 09:24:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jwmVLCN04RAn for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Dec 2018 09:24:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 841664A1F2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Dec 2018 09:24:28 -0500 (EST)
In-Reply-To: <1544023815-16958-5-git-send-email-andrew.murray@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Murray <andrew.murray@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 05/12/2018 15:30, Andrew Murray wrote:
> Enable/disable event counters as appropriate when entering and exiting
> the guest to enable support for guest or host only event counting.
> 
> For both VHE and non-VHE we switch the counters between host/guest at
> EL2. EL2 is filtered out by the PMU when we are using the :G modifier.
> 
> The PMU may be on when we change which counters are enabled however
> we avoid adding an isb as we instead rely on existing context
> synchronisation events: the isb in kvm_arm_vhe_guest_exit for VHE and
> the eret from the hvc in kvm_call_hyp.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>   arch/arm64/kvm/hyp/switch.c | 38 ++++++++++++++++++++++++++++++++++++++
>   1 file changed, 38 insertions(+)
> 

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
