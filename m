From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v2 1/9] arm64: KVM: PMU: Refactor pmu_*_el0_disabled
Date: Mon, 27 Mar 2017 18:03:39 +0100
Message-ID: <e1ad349e-a14c-328a-83ea-4f939c49beb5@arm.com>
References: <20170327160345.12402-1-marc.zyngier@arm.com>
 <20170327160345.12402-2-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7F3840C2E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 13:01:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 160jWgV2upvX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 13:01:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7184F40A6A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 13:01:45 -0400 (EDT)
In-Reply-To: <20170327160345.12402-2-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Shannon Zhao <shannon.zhao@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 27/03/17 17:03, Marc Zyngier wrote:
> There is a lot of duplication in the pmu_*_el0_disabled helpers,
> and as we're going to modify them shortly, let's move all the
> common stuff in a single function.
>
> No functionnal change.

nit: s/functionnal/functional

>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 25 +++++++++++--------------
>  1 file changed, 11 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 0e26f8c2b56f..7e1d673304d5 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -460,35 +460,32 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  	vcpu_sys_reg(vcpu, PMCR_EL0) = val;
>  }
>
> -static bool pmu_access_el0_disabled(struct kvm_vcpu *vcpu)
> +static bool check_disabled(struct kvm_vcpu *vcpu, u64 flags)

minor nit: check_disabled sounds too generic for a helper which checks for
something specific to pmuserenr_el0 register in a file where we deal with
lot of system registers. check_pmu_access_disabled()  ?

Suzuki
