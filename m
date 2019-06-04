Return-Path: <SRS0=jSi8=UD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB784C28CC3
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 09:23:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 624CB245F5
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 09:23:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 624CB245F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD54C4A4E6;
	Tue,  4 Jun 2019 05:23:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gIIxxbciWsJY; Tue,  4 Jun 2019 05:23:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 874194A4A4;
	Tue,  4 Jun 2019 05:23:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFEA04A36B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 05:23:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2WIzHoJiALHm for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jun 2019 05:23:11 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D1E6E4A332
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 05:23:11 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id C49D930C3194;
 Tue,  4 Jun 2019 09:23:05 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 90BE7619C3;
 Tue,  4 Jun 2019 09:23:03 +0000 (UTC)
Date: Tue, 4 Jun 2019 11:23:01 +0200
From: Andrew Jones <drjones@redhat.com>
To: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH] KVM: arm64: Filter out invalid core register IDs in
 KVM_GET_REG_LIST
Message-ID: <20190604092301.26vbijfoapl4whp6@kamzik.brq.redhat.com>
References: <1559580727-13444-1-git-send-email-Dave.Martin@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1559580727-13444-1-git-send-email-Dave.Martin@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.40]); Tue, 04 Jun 2019 09:23:10 +0000 (UTC)
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu,
 stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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

On Mon, Jun 03, 2019 at 05:52:07PM +0100, Dave Martin wrote:
> Since commit d26c25a9d19b ("arm64: KVM: Tighten guest core register
> access from userspace"), KVM_{GET,SET}_ONE_REG rejects register IDs
> that do not correspond to a single underlying architectural register.
> 
> KVM_GET_REG_LIST was not changed to match however: instead, it
> simply yields a list of 32-bit register IDs that together cover the
> whole kvm_regs struct.  This means that if userspace tries to use
> the resulting list of IDs directly to drive calls to KVM_*_ONE_REG,
> some of those calls will now fail.
> 
> This was not the intention.  Instead, iterating KVM_*_ONE_REG over
> the list of IDs returned by KVM_GET_REG_LIST should be guaranteed
> to work.
> 
> This patch fixes the problem by splitting validate_core_offset()
> into a backend core_reg_size_from_offset() which does all of the
> work except for checking that the size field in the register ID
> matches, and kvm_arm_copy_reg_indices() and num_core_regs() are
> converted to use this to enumerate the valid offsets.
> 
> kvm_arm_copy_reg_indices() now also sets the register ID size field
> appropriately based on the value returned, so the register ID
> supplied to userspace is fully qualified for use with the register
> access ioctls.

Ah yes, I've seen this issue, but hadn't gotten around to fixing it.

> 
> Cc: stable@vger.kernel.org
> Fixes: d26c25a9d19b ("arm64: KVM: Tighten guest core register access from userspace")
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> 
> ---
> 
> Changes since v3:

Hmm, I didn't see a v1-v3.

> 
>  * Rebased onto v5.2-rc1.
> 
>  * Tested with qemu by migrating from one qemu instance to another on
>    ThunderX2.

One of the reasons I was slow to fix this is because QEMU doesn't care
about the core registers when it uses KVM_GET_REG_LIST. It just completely
skips all core reg indices, so it never finds out that they're invalid.
And kvmtool doesn't use KVM_GET_REG_LIST at all. But it's certainly good
to fix this.

> 
> ---
>  arch/arm64/kvm/guest.c | 53 +++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 40 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 3ae2f82..6527c76 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -70,10 +70,8 @@ static u64 core_reg_offset_from_id(u64 id)
>  	return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
>  }
>  
> -static int validate_core_offset(const struct kvm_vcpu *vcpu,
> -				const struct kvm_one_reg *reg)
> +static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
>  {
> -	u64 off = core_reg_offset_from_id(reg->id);
>  	int size;
>  
>  	switch (off) {
> @@ -103,8 +101,7 @@ static int validate_core_offset(const struct kvm_vcpu *vcpu,
>  		return -EINVAL;
>  	}
>  
> -	if (KVM_REG_SIZE(reg->id) != size ||
> -	    !IS_ALIGNED(off, size / sizeof(__u32)))
> +	if (!IS_ALIGNED(off, size / sizeof(__u32)))
>  		return -EINVAL;
>  
>  	/*
> @@ -115,6 +112,21 @@ static int validate_core_offset(const struct kvm_vcpu *vcpu,
>  	if (vcpu_has_sve(vcpu) && core_reg_offset_is_vreg(off))
>  		return -EINVAL;
>  
> +	return size;
> +}
> +
> +static int validate_core_offset(const struct kvm_vcpu *vcpu,
> +				const struct kvm_one_reg *reg)
> +{
> +	u64 off = core_reg_offset_from_id(reg->id);
> +	int size = core_reg_size_from_offset(vcpu, off);
> +
> +	if (size < 0)
> +		return -EINVAL;
> +
> +	if (KVM_REG_SIZE(reg->id) != size)
> +		return -EINVAL;
> +
>  	return 0;
>  }
>  
> @@ -453,19 +465,34 @@ static int copy_core_reg_indices(const struct kvm_vcpu *vcpu,
>  {
>  	unsigned int i;
>  	int n = 0;
> -	const u64 core_reg = KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE;
>  
>  	for (i = 0; i < sizeof(struct kvm_regs) / sizeof(__u32); i++) {
> -		/*
> -		 * The KVM_REG_ARM64_SVE regs must be used instead of
> -		 * KVM_REG_ARM_CORE for accessing the FPSIMD V-registers on
> -		 * SVE-enabled vcpus:
> -		 */
> -		if (vcpu_has_sve(vcpu) && core_reg_offset_is_vreg(i))
> +		u64 reg = KVM_REG_ARM64 | KVM_REG_ARM_CORE | i;
> +		int size = core_reg_size_from_offset(vcpu, i);
> +
> +		if (size < 0)
> +			continue;
> +
> +		switch (size) {
> +		case sizeof(__u32):
> +			reg |= KVM_REG_SIZE_U32;
> +			break;
> +
> +		case sizeof(__u64):
> +			reg |= KVM_REG_SIZE_U64;
> +			break;
> +
> +		case sizeof(__uint128_t):
> +			reg |= KVM_REG_SIZE_U128;
> +			break;
> +
> +		default:
> +			WARN_ON(1);
>  			continue;
> +		}
>  
>  		if (uindices) {
> -			if (put_user(core_reg | i, uindices))
> +			if (put_user(reg, uindices))
>  				return -EFAULT;
>  			uindices++;
>  		}
> -- 
> 2.1.4
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

I've also tested this using a kvm selftests test I wrote. I haven't posted
that test yet because it needs some cleanup and I planned on getting back
to that when getting back to fixing this issue. Anyway, before this patch
every other 64-bit core reg index is invalid (because its indexing 32-bits
but claiming a size of 64), all fp regs are invalid, and we were even
providing a couple indices that mapped to struct padding. After this patch
everything is right with the world.

Tested-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
