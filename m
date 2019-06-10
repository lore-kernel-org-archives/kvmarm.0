Return-Path: <SRS0=ZPOc=UJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EEDEC282DD
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jun 2019 09:56:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8FBEC20833
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jun 2019 09:56:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FBEC20833
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1651F4A4F9;
	Mon, 10 Jun 2019 05:56:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2nWl-HxGRq0i; Mon, 10 Jun 2019 05:56:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C95704A504;
	Mon, 10 Jun 2019 05:56:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 456294A4F7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jun 2019 05:56:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IaoWSQOgKfNo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jun 2019 05:56:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D182B4A4EE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jun 2019 05:56:03 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61DC7344;
 Mon, 10 Jun 2019 02:56:03 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 204573F246;
 Mon, 10 Jun 2019 02:57:44 -0700 (PDT)
Date: Mon, 10 Jun 2019 10:56:00 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH V2] KVM: arm64: Implement vq_present() as a macro
Message-ID: <20190610095559.GL28398@e103592.cambridge.arm.com>
References: <7c2590c4d8cc95cd40bbb05c0d0c5e2b0735a16b.1560145715.git.viresh.kumar@linaro.org>
 <20190610090917.GK28398@e103592.cambridge.arm.com>
 <20190610095030.yurzajuyylyo57h2@vireshk-i7>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190610095030.yurzajuyylyo57h2@vireshk-i7>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Jun 10, 2019 at 03:20:30PM +0530, Viresh Kumar wrote:
> On 10-06-19, 10:09, Dave Martin wrote:
> > You could drop the extra level of indirection on vqs now.  The only
> > thing it achieves is to enforce the size of the array via type-
> > checkout, but the macro can't easily do that (unless you can think
> > of another way to do it).
> > 
> > Otherwise, looks good.
> 
> Below is what I wrote initially this morning and then moved to the
> current version as I wasn't sure if you would want that :)
> 
> -- 
> viresh
> 
> -------------------------8<-------------------------
> 
> From be823e68faffc82a6f621c16ce1bd45990d92791 Mon Sep 17 00:00:00 2001
> Message-Id: <be823e68faffc82a6f621c16ce1bd45990d92791.1560160165.git.viresh.kumar@linaro.org>
> From: Viresh Kumar <viresh.kumar@linaro.org>
> Date: Mon, 10 Jun 2019 11:15:17 +0530
> Subject: [PATCH] KVM: arm64: Implement vq_present() as a macro
> 
> This routine is a one-liner and doesn't really need to be function and
> can be implemented as a macro.
> 
> Suggested-by: Dave Martin <Dave.Martin@arm.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  arch/arm64/kvm/guest.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 3ae2f82fca46..ae734fcfd4ea 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -207,13 +207,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  
>  #define vq_word(vq) (((vq) - SVE_VQ_MIN) / 64)
>  #define vq_mask(vq) ((u64)1 << ((vq) - SVE_VQ_MIN) % 64)
> -
> -static bool vq_present(
> -	const u64 (*const vqs)[KVM_ARM64_SVE_VLS_WORDS],
> -	unsigned int vq)
> -{
> -	return (*vqs)[vq_word(vq)] & vq_mask(vq);
> -}
> +#define vq_present(vqs, vq) ((vqs)[vq_word(vq)] & vq_mask(vq))
>  
>  static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  {
> @@ -258,7 +252,7 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  
>  	max_vq = 0;
>  	for (vq = SVE_VQ_MIN; vq <= SVE_VQ_MAX; ++vq)
> -		if (vq_present(&vqs, vq))
> +		if (vq_present(vqs, vq))
>  			max_vq = vq;
>  
>  	if (max_vq > sve_vq_from_vl(kvm_sve_max_vl))
> @@ -272,7 +266,7 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	 * maximum:
>  	 */
>  	for (vq = SVE_VQ_MIN; vq <= max_vq; ++vq)
> -		if (vq_present(&vqs, vq) != sve_vq_available(vq))
> +		if (vq_present(vqs, vq) != sve_vq_available(vq))
>  			return -EINVAL;

I think I prefer this version:

Reviewed-by: Dave Martin <Dave.Martin@arm.com>

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
