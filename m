Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB7C2D0625
	for <kvmarm@lists.linux.dev>; Sun,  7 Jun 2026 13:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780839412; cv=none; b=RgyWFjy8i3w5NGGsOStgR/SDDJ/pM35OOR/l7wqHSbLyDyNbCtDpVAVfPz9SQmOmsBwdmEx9JjPRt73zh67BxpuN3dlt0s2LceguEtzHSF0VQxtUeBhwMDMTTVHZ5EQVQp+RmsgKxBduGup3Xip2ql+eXMdOQ7sqCuTbwnyJKIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780839412; c=relaxed/simple;
	bh=LbM6T+zcPB9TuEqpBitzZbpJyQLPAnq13MuBfNn1pt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=krVHoDXTl92Q9hGDUM0tbINBTHGmPRGQu5yGCGWqOsZ+QXamJiQkXp6QE3cXriPEvxz300eG98v4xFYhMGLArYEw00aciC3cfygt7aobg7iorCLxoyIHFktmM9GvR/lrpWvM91+Q7oag743C1WWacfYhFmbBDUgvLLtjoJasOw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K8Lu07Gn; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K8Lu07Gn"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-842264dde84so2185991b3a.0
        for <kvmarm@lists.linux.dev>; Sun, 07 Jun 2026 06:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780839410; x=1781444210; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nomoDwC9apKbvhbkrNN8KmZTKGsxkb/dhs8zbSF9x9M=;
        b=K8Lu07Gnot49x7kYWcWC4UM1jFwX4WTg1iuvqNhnGyXF6Covc13fryj6ilB7ZY22WN
         uJeLPVIsUkra6ydItNhlQtDsaMjQikIWV49thw++zt9i5AeUz5Q1H2MCfL/d+gSCaR18
         3p0awVg/Xw1PROGRHKjQPJF7HHPVxv/f+rCps+x886C29rd0xhPB8EOsLMACKhQKXo4F
         9fxlZMg+ptJuWFp6IerjqYFngNVX/wuUT0J85LxKw6Xa3LDvrQ8e73m2FycdUzY/F88Z
         nLcg5PjAlG3Q/9Kk2DuLO0vVCyS81sr0Sg4+2/PIYcGSrDMrQpYn8zXhwQonhsC3kOOr
         uTuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780839410; x=1781444210;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nomoDwC9apKbvhbkrNN8KmZTKGsxkb/dhs8zbSF9x9M=;
        b=jY/110+hpyto/XUpDmVAdVntZiLH/2i75mgYGVXhHp3ITnO3npJkwXs0oHqPtsJBDz
         Iqi2/zGeodFzxk4j4oo8v1EVHlYqBYSsPEuycr1VFfuMwuWAC/AQ2K4oR6K6T+A/yBOa
         XvAe4OxTvMYmt/nU8LEdvpziNlA19CRNRBTvnDZVtmGPbRGv1oQXPEXE2wiAijVRoJle
         mkNd22dnl6pSI/+l8+ynT+W094YXoEMhF06yyBzcJ5YuGVIIksUWMee+lEnBriGnVxm9
         Potyml2IVDRitNQjf/7yhQ8+P7HNAyJJKSk+Rnh7Yp20EkRTbjKFPVn0Hgnwq1f73QRO
         0uYA==
X-Forwarded-Encrypted: i=1; AFNElJ9RfPr6a6VsGqwI3uwZnJfqrKMtXLqVqROeeAjaaDkIm1Bp8nez/WXZu/rm7iFnHwYSz7ypZ0s=@lists.linux.dev
X-Gm-Message-State: AOJu0YwpomXPcbOPN8zCL+b/yvuqdi31p+62tNMgdcgDVK7cSczOSYch
	RdbWvbMNw6S6rv8HrJbmYjk8OH+2863kIYsjMniyHIweR9pZkuugSQGi
X-Gm-Gg: Acq92OHPqjh8S/ykHxZsdGisSI1y/+JRPwM6pbH3e1vVovZHd9FUAvhGoFLAObW++kb
	rAmKPTeWNCBMemJ9zPQK8sptkjWRtQE8jU8Rc/uBcN9BuF+N6djADJqum6sw5aI+F2L46S7I4Ek
	ZkBeYEI0vw37Y3pdyQ9RUUWrfmwm0hl2BHOM+8rtP0bRR6CHt47q5P33ZZ25Uv3AXpS6htJcC5D
	d6V20sxffs2UKvPC1pIggyWYf3HAcaPXFTPPVm7MQRlBqJD41UgxzYktLgmaUYPpM2TwSoGb+IH
	hebArkT6JcqpQkZ89+3xZ48mF9d7O7JL3SgntNsqV4pX7coCvkNw+M4/2dv+RuiDWPshsZPEb1w
	GC1BdlLD5QlbgmRn061QOy+41NEnAz/Vupg8gbAC/wyfZxZhYB9WD3l3DanBdrNNuI1tygVtlip
	r2W/VBGiRo9hfCPXFrFR43hqsPPA+ksuMDWsGEMcGSUK5hoSqImosfXdakntlwi53o
X-Received: by 2002:a05:6a00:1405:b0:842:3841:fdb9 with SMTP id d2e1a72fcca58-842b6823968mr8665149b3a.31.1780839409910;
        Sun, 07 Jun 2026 06:36:49 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84282375f2dsm16053596b3a.19.2026.06.07.06.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 06:36:48 -0700 (PDT)
Date: Sun, 7 Jun 2026 22:36:44 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	imv4bel@gmail.com
Subject: Re: [PATCH] KVM: arm64: nv: Skip vCPUs without a pseudo-TLB in
 invalidate_vncr_va()
Message-ID: <aiVz7O_FIpY2k2bV@v4bel>
References: <aiUvSbrWndQeUPc8@v4bel>
 <8733yya4ch.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8733yya4ch.wl-maz@kernel.org>

On Sun, Jun 07, 2026 at 02:05:02PM +0100, Marc Zyngier wrote:
> On Sun, 07 Jun 2026 09:43:53 +0100,
> Hyunwoo Kim <imv4bel@gmail.com> wrote:
> > 
> > vncr_tlb is not allocated before a vCPU runs for the first time, so
> > vcpu->arch.vncr_tlb is NULL for a vCPU that has been created but not yet
> > run. Code that iterates over every vCPU's pseudo-TLB must skip those.
> > 
> > invalidate_vncr_va() iterates over the vCPUs with kvm_for_each_vcpu() and
> > dereferences vt->valid without checking whether vncr_tlb is NULL.
> > 
> > While iterating, skip vCPUs whose pseudo-TLB has not been allocated.
> >
> > Fixes: 4ffa72ad8f37 ("KVM: arm64: nv: Add S1 TLB invalidation primitive for VNCR_EL2")
> > Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> > ---
> >  arch/arm64/kvm/nested.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index 6f7bc9a9992e..063e079d1d1a 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -969,6 +969,10 @@ static void invalidate_vncr_va(struct kvm *kvm,
> >  		struct vncr_tlb *vt = vcpu->arch.vncr_tlb;
> >  		u64 va_start, va_end, va_size;
> >  
> > +		/* Skip vCPUs whose pseudo-TLB hasn't been allocated yet */
> > +		if (!vt)
> > +			continue;
> > +
> >  		if (!vt->valid)
> >  			continue;
> >  
> 
> This looks correct and matches what we already have for
> invalidate_vncr_ipa().
> 
> But I think this misses the opportunity to squash a whole class of
> similar bugs, should we ever have the need for another function that
> iterates over all *valid* VNCR pseudo-TLBs.
> 
> Since I'm on a train and have nothing better to do, I've written the
> following hack.
> 
> Thoughts?

Looks like a good direction to me. I confirmed it fixes the issue (as
expected).

How about you submit this patch yourself?

> 
> 	M.
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 38f672e940878..f0a9f81a08302 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -897,9 +897,21 @@ static void invalidate_vncr(struct vncr_tlb *vt)
>  		clear_fixmap(vncr_fixmap(vt->cpu));
>  }
>  
> +/*
> + * VNCR TLB invalidation occurs from MMU notifiers or TLBI instructions, and
> + * either can race against a vcpu not being onlined yet (no pseudo-TLB
> + * allocated). Similarly, the TLB might be invalid.  Skip those, as they
> + * obviously don't participate in the invalidation at this stage.
> + */
> +#define kvm_for_each_vncr_tlb(idx, vcpup, tlbp, kvm)	\
> +	kvm_for_each_vcpu(idx, vcpu, kvm)		\

Maybe vcpu -> vcpup?

> +		if (((tlbp) = vcpu->arch.vncr_tlb) &&	\
> +		    (tlbp)->valid)
> +
>  static void kvm_invalidate_vncr_ipa(struct kvm *kvm, u64 start, u64 end)
>  {
>  	struct kvm_vcpu *vcpu;
> +	struct vncr_tlb *vt;
>  	unsigned long i;
>  
>  	lockdep_assert_held_write(&kvm->mmu_lock);
> @@ -907,24 +919,9 @@ static void kvm_invalidate_vncr_ipa(struct kvm *kvm, u64 start, u64 end)
>  	if (!kvm_has_feat(kvm, ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY))
>  		return;
>  
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		struct vncr_tlb *vt = vcpu->arch.vncr_tlb;
> +	kvm_for_each_vncr_tlb(i, vcpu, vt, kvm) {
>  		u64 ipa_start, ipa_end, ipa_size;
>  
> -		/*
> -		 * Careful here: We end-up here from an MMU notifier,
> -		 * and this can race against a vcpu not being onlined
> -		 * yet, without the pseudo-TLB being allocated.
> -		 *
> -		 * Skip those, as they obviously don't participate in
> -		 * the invalidation at this stage.
> -		 */
> -		if (!vt)
> -			continue;
> -
> -		if (!vt->valid)
> -			continue;
> -
>  		ipa_size = ttl_to_size(pgshift_level_to_ttl(vt->wi.pgshift,
>  							    vt->wr.level));
>  		ipa_start = vt->wr.pa & ~(ipa_size - 1);
> @@ -954,17 +951,14 @@ static void invalidate_vncr_va(struct kvm *kvm,
>  			       struct s1e2_tlbi_scope *scope)
>  {
>  	struct kvm_vcpu *vcpu;
> +	struct vncr_tlb *vt;
>  	unsigned long i;
>  
>  	lockdep_assert_held_write(&kvm->mmu_lock);
>  
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		struct vncr_tlb *vt = vcpu->arch.vncr_tlb;
> +	kvm_for_each_vncr_tlb(i, vcpu, vt, kvm) {
>  		u64 va_start, va_end, va_size;
>  
> -		if (!vt->valid)
> -			continue;
> -
>  		va_size = ttl_to_size(pgshift_level_to_ttl(vt->wi.pgshift,
>  							   vt->wr.level));
>  		va_start = vt->gva & ~(va_size - 1);
> 
> -- 
> Jazz isn't dead. It just smells funny.


Best regards,
Hyunwoo Kim
