Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DEC0C00140
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 07:08:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 769104D593;
	Wed, 10 Aug 2022 03:08:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wThFZFLG4sZR; Wed, 10 Aug 2022 03:08:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E0984D595;
	Wed, 10 Aug 2022 03:08:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B38CA4D590
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 03:08:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dOYkr-zsZ-BZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 03:08:13 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8639F4D58F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 03:08:13 -0400 (EDT)
Date: Wed, 10 Aug 2022 02:08:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1660115292;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=16kqUglr1ishQgrJKlQFjUeIG4svmPIXYRWssIj916w=;
 b=kmhhSxS7uIccs/nrYdSWL3WpY7iLLfb086IQ2OPHv80z6GP87fiwDAqu5MhMZPTcJEhJFn
 IKWWEQTe2cyuaZo3J7bEjF7I+lJDWX/zwfntne4Qxoox02rZ2x4/mnYnYTdq7PegQzGnGB
 ylFovYXelsIAn9sU0BqHBUbbCHl/j4M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 7/9] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to be
 set from userspace
Message-ID: <YvNZVgMmFxrY4Nka@google.com>
References: <20220805135813.2102034-1-maz@kernel.org>
 <20220805135813.2102034-8-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220805135813.2102034-8-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On Fri, Aug 05, 2022 at 02:58:11PM +0100, Marc Zyngier wrote:
> Allow userspace to write ID_AA64DFR0_EL1, on the condition that only
> the PMUver field can be altered and be at most the one that was
> initially computed for the guest.

As DFR0_EL1 is exposed to userspace, isn't a ->set_user() hook required
for it as well?

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 55451f49017c..c0595f31dab8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1236,6 +1236,38 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> +			       const struct sys_reg_desc *rd,
> +			       u64 val)
> +{
> +	u8 pmuver, host_pmuver;
> +
> +	host_pmuver = kvm_arm_pmu_get_host_pmuver();
> +
> +	/*
> +	 * Allow AA64DFR0_EL1.PMUver to be set from userspace as long
> +	 * as it doesn't promise more than what the HW gives us. We
> +	 * don't allow an IMPDEF PMU though.
> +	 */
> +	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), val);
> +	if (pmuver == ID_AA64DFR0_PMUVER_IMP_DEF || pmuver > host_pmuver)
> +		return -EINVAL;
> +
> +	/* We already have a PMU, don't try to disable it... */
> +	if (kvm_vcpu_has_pmu(vcpu) && pmuver == 0)
> +		return -EINVAL;
> +
> +	/* We can only differ with PMUver, and anything else is an error */
> +	val ^= read_id_reg(vcpu, rd, false);
> +	val &= ~(0xFUL << ID_AA64DFR0_PMUVER_SHIFT);

nit: ~ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
