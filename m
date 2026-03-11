Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDDE3D8110
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 15:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773243699; cv=none; b=OE9N12y33r6Ry4mkRsclSHqlF+NTX9gB0QNEOKU9AfgCqwhMuQGBDk0TxXh+BoLrG+WO2MUwTDGGFpuB5VMKKuOtlpWvSPU3N7/284Q+yZ3rcXSmURRX4SfbJRHjP38v/300HKuw5Rf2NmOSdprdz+mGHOytp9S05TIWdHBvX3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773243699; c=relaxed/simple;
	bh=QZ5pu5E9puC75RqWeO1qpn1x2JX1gJSYp5wDjIplri0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZgXoEhMoBOHgPhhFibS2XEixmCEseFgaPNubIxJnMM+AeJuRAhQBqUEP/FpOsT9QcHbMwIjwdyVYvzCMOXDhCG5e/wUT928/G4/0NNn/v7ScYwnGRrGDRR+p94C4dq4DKeBXRlvOYK1neldaxcA9YTtbeMnwXnamgV5q8RUoEZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cNHw/0fo; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cNHw/0fo"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-485317b6bd0so73825e9.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 08:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773243697; x=1773848497; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KQt+CoV07J8tIqkpQRNCsaPJxxDfRM/yGjNi47TlBAQ=;
        b=cNHw/0fo5zeJipkuxMAWOQJKxuR4nvf8tSyGyj9k/yvxjswptt/tK3dNkfVdJSiF14
         0DAfEGAirx9uhaNPcWH5JjLWV8CjvUwifV7gpSJ1/lm+BEldcTDc+9uivKCN5U3rAV1g
         FBUqfaSCaRYsQQJNMXOMURKz6cNQSBk0MyXYBDIYS5nKee2XRkuTMyAhC6fr4C7LupWv
         RqSBTnGZ76m4ev0CiKnkvgCOJ5TJCWnwTtpgO46AH490ByQNyb5VZAVeRwijS0tCBO2x
         qU/2oz2p2r2b6fBs8ow8qMKBJsZM/ZYjmua7pR8K5DtyEgdF5w0VnVFENnYTV2Cnv7Q2
         YdnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773243697; x=1773848497;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KQt+CoV07J8tIqkpQRNCsaPJxxDfRM/yGjNi47TlBAQ=;
        b=tjHQk/K127sKrJG+wJM/5Q5f+Chf8xeRuRUdXZhBsl0/o8TMwEf62ASz++cFWyi1lZ
         O2K62hlXwisQSMrghxTEGCnnT34Ua/2vVZnQPC5cDLZpab1Psw7LnITrMAD0POGyvdoU
         h2XQ/uuhVZp4Ce28mWJF+XKbwao3e18132489PMgh/y/imrNfIcxsBpgcV+S/cI/9DO1
         ggk37WUTVScULhA1AbEpj5clo0pJGNZrCy1Jg2KqBj75k4cc09llzMy/kwt6V5bqOUbx
         OypJSSAkncWQ606wEONrDk1iaNur5hDuXfF+r+kP70e1MC7H6ZqrqcyUvXSJT76sDgH6
         Zwxw==
X-Forwarded-Encrypted: i=1; AJvYcCVJ5hIitU50TCts44fFJh3/l5sGbb5Npl64/QzQL49OjEZBNw9E0MuxQ8kTuXV1RfpUDOVYOm4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWZKRHVWmPb/+GUbSXRI/hA++uqOOULCeHFdKz2Fjk39pgR0sT
	l2PUAYCWNVkPoeDgwpuLn04A9NtrpUW5o0MFQ/Hqd7u5ykNEn3j4EOdx/DZ/z55CrA==
X-Gm-Gg: ATEYQzyW7nU5Nxypqza5qLqy/fQgN3vtKOlF8LMe9lPXfPZSGTW1T4gTMyfheloKPvj
	zJAwj+h+3tqIYUOKsMvYaJAtdLeZ8NB4TyW6Rs+JS7DZWKTr7hb4nC5/dNrB8gsFSxjuCVeWLwA
	gOUekzHAgxmX4U9q4vTpmxGP2azKqGFxAOI2CvCJHaJTUfcGBcy13iDkqdWgpKoR8UVBhT7PE4N
	s8cIaXsybczuGgDAVpEzkuoZiQXzVmcMSUgxjbJddBFKXWz9hhB9pfScTtRtTGX0UvG75ey0lGz
	SP+pCIok/WgbIZBfex8CQuqjmWK6gGIBTlOae3oZOeLSfkUH0vgRD8lUjCElxLg1w4H9/QghlZI
	AWSdKqtkTGsHPg4ekAd8bRcHGpI+LLG7txFQ265JKw4o4V29sJkwh8ePCgdjS430RYonsvu2Bvi
	hwADPQZSHtCjIIcSx0lX1kT38ecmxH0u5WIW5iW5QNcSYkbR4cow1AMzyPZat5ln72soU=
X-Received: by 2002:a05:600c:5593:b0:485:4f11:aac5 with SMTP id 5b1f17b1804b1-4854f11ac78mr81425e9.15.1773243696310;
        Wed, 11 Mar 2026 08:41:36 -0700 (PDT)
Received: from google.com (209.13.205.35.bc.googleusercontent.com. [35.205.13.209])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe1abf84sm50479f8f.14.2026.03.11.08.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 08:41:35 -0700 (PDT)
Date: Wed, 11 Mar 2026 15:41:32 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH RESEND 2/2] KVM: arm64: nv: Expose shadow page tables in
 debugfs
Message-ID: <abGNLOfKLcNGYcxh@google.com>
References: <20260308231829.864983-1-weilin.chang@arm.com>
 <20260308231829.864983-3-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260308231829.864983-3-weilin.chang@arm.com>

On Sun, Mar 08, 2026 at 11:18:29PM +0000, Wei-Lin Chang wrote:
> Exposing shadow page tables in debugfs improves the debugability and
> testability of NV. With this patch a new directory "nested" is created
> for each VM created if the host is NV capable. Within the directory each
> valid s2 mmu will have its shadow page table exposed as a readable file
> with the file name formatted as 0x<vttbr>-0x<vtcr>-s2-{en,dis}abled. The
> creation and removal of the files happen at the points when an s2 mmu
> becomes valid, or the context it represents change. In the future the
> "nested" directory can also hold other NV related information.
> 
> This is gated behind CONFIG_PTDUMP_STAGE2_DEBUGFS.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  7 +++++++
>  arch/arm64/include/asm/kvm_mmu.h  |  4 ++++
>  arch/arm64/kvm/nested.c           |  6 +++++-
>  arch/arm64/kvm/ptdump.c           | 27 +++++++++++++++++++++++++++
>  4 files changed, 43 insertions(+), 1 deletion(-)

Hi,

> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 5d5a3bbdb95e..f88f6c4d646e 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -217,6 +217,10 @@ struct kvm_s2_mmu {
>  	 */
>  	bool	nested_stage2_enabled;
>  
> +#ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
> +	struct dentry *shadow_pt_debugfs_dentry;
> +#endif
> +
>  	/*
>  	 * true when this MMU needs to be unmapped before being used for a new
>  	 * purpose.
> @@ -405,6 +409,9 @@ struct kvm_arch {
>  	 * the associated pKVM instance in the hypervisor.
>  	 */
>  	struct kvm_protected_vm pkvm;
> +
> +	/* Nested virtualization info */
> +	struct dentry *debugfs_nv_dentry;
>  };
>  
>  struct kvm_vcpu_fault_info {
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index d968aca0461a..01e9c72d6aa7 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -393,8 +393,12 @@ static inline bool kvm_supports_cacheable_pfnmap(void)
>  
>  #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
>  void kvm_s2_ptdump_create_debugfs(struct kvm *kvm);
> +void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu);
> +void kvm_nested_s2_ptdump_remove_debugfs(struct kvm_s2_mmu *mmu);
>  #else
>  static inline void kvm_s2_ptdump_create_debugfs(struct kvm *kvm) {}
> +static inline void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu) {}
> +static inline void kvm_nested_s2_ptdump_remove_debugfs(struct kvm_s2_mmu *mmu) {}
>  #endif /* CONFIG_PTDUMP_STAGE2_DEBUGFS */
>  
>  #endif /* __ASSEMBLER__ */
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index eeea5e692370..31d74ed8449e 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -730,8 +730,10 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
>  	kvm->arch.nested_mmus_next = (i + 1) % kvm->arch.nested_mmus_size;
>  
>  	/* Make sure we don't forget to do the laundry */
> -	if (kvm_s2_mmu_valid(s2_mmu))
> +	if (kvm_s2_mmu_valid(s2_mmu)) {
> +		kvm_nested_s2_ptdump_remove_debugfs(s2_mmu);
>  		s2_mmu->pending_unmap = true;
> +	}
>  
>  	/*
>  	 * The virtual VMID (modulo CnP) will be used as a key when matching
> @@ -745,6 +747,8 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
>  	s2_mmu->tlb_vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
>  	s2_mmu->nested_stage2_enabled = vcpu_read_sys_reg(vcpu, HCR_EL2) & HCR_VM;
>  
> +	kvm_nested_s2_ptdump_create_debugfs(s2_mmu);
> +
>  out:
>  	atomic_inc(&s2_mmu->refcnt);
>  
> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> index 98763b291956..3a70f633fc8b 100644
> --- a/arch/arm64/kvm/ptdump.c
> +++ b/arch/arm64/kvm/ptdump.c
> @@ -10,6 +10,7 @@
>  #include <linux/kvm_host.h>
>  #include <linux/seq_file.h>
>  
> +#include <asm/cpufeature.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/kvm_pgtable.h>
>  #include <asm/ptdump.h>
> @@ -277,6 +278,29 @@ static const struct file_operations kvm_pgtable_levels_fops = {
>  	.release	= kvm_pgtable_debugfs_close,
>  };
>  
> +void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu)
> +{
> +	struct dentry *dent;
> +	/* format: 0x<vttbr>-0x<vtcr>-s2-{en, dis}abled\0 */
> +	char file_name[2 + 16 + 1 + 2 + 16 + 4 + 3 + 6];

Can you hide the size of this definition behind a macro ?

> +
> +	snprintf(file_name, sizeof(file_name), "0x%llx-0x%llx-s2-%sabled",
> +		 mmu->tlb_vttbr,
> +		 mmu->tlb_vtcr,
> +		 mmu->nested_stage2_enabled ? "en" : "dis");
> +
> +	dent = debugfs_create_file(file_name, 0400,
> +				   mmu->arch->debugfs_nv_dentry, mmu,
> +				   &kvm_ptdump_guest_fops);
> +
> +	mmu->shadow_pt_debugfs_dentry = dent;
> +}
> +
> +void kvm_nested_s2_ptdump_remove_debugfs(struct kvm_s2_mmu *mmu)
> +{
> +	debugfs_remove(mmu->shadow_pt_debugfs_dentry);
> +}
> +
>  void kvm_s2_ptdump_create_debugfs(struct kvm *kvm)
>  {
>  	debugfs_create_file("stage2_page_tables", 0400, kvm->debugfs_dentry,
> @@ -285,4 +309,7 @@ void kvm_s2_ptdump_create_debugfs(struct kvm *kvm)
>  			    &kvm->arch.mmu, &kvm_pgtable_range_fops);
>  	debugfs_create_file("stage2_levels", 0400, kvm->debugfs_dentry,
>  			    &kvm->arch.mmu, &kvm_pgtable_levels_fops);
> +	if (cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
> +		kvm->arch.debugfs_nv_dentry =
> +			debugfs_create_dir("nested", kvm->debugfs_dentry);
>  }

Other than that this looks good to me, thanks
Reviewed-by: Sebastian Ene <sebastianene@google.com>

> -- 
> 2.43.0
> 
