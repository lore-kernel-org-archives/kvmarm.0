Return-Path: <SRS0=kePE=PC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D138C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 14 Oct 2021 09:04:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B4B1A61167
	for <kvmarm@archiver.kernel.org>; Thu, 14 Oct 2021 09:04:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B4B1A61167
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25FF74B090;
	Thu, 14 Oct 2021 05:04:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q2TJoZ3bQGBr; Thu, 14 Oct 2021 05:04:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 853004B0C2;
	Thu, 14 Oct 2021 05:04:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6381E4B099
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Oct 2021 05:04:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4R7keW8ucPPa for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Oct 2021 05:04:19 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3715F4B090
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Oct 2021 05:04:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1634202258;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ArdfMWNbuG02n1OQKPEk6jS02d/uCbdT+PSDgFpbJqI=;
 b=LF7bvSHoknqF+JSYUNePj96nlYI7g0qGvQmEAFIRo9Mn+eoF0mmLD3Uk9uhFIBqtG6SykU
 ugrNA+WdAZU0SD5r9fVqDb5P710o12f4p15hdGob2ojhS+Qj9zYilSCH1BnP8w8J6BbLJl
 +CflZcIFO42gZcxnz/Cr1mQq5Yu8+SY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-jCu3vYMfMtO6hIBHj9Civg-1; Thu, 14 Oct 2021 05:04:15 -0400
X-MC-Unique: jCu3vYMfMtO6hIBHj9Civg-1
Received: by mail-ed1-f71.google.com with SMTP id
 i7-20020a50d747000000b003db0225d219so4675414edj.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Oct 2021 02:04:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ArdfMWNbuG02n1OQKPEk6jS02d/uCbdT+PSDgFpbJqI=;
 b=zrzY0spoJg2u9GdRAoEt6aqTF1BCvetiJaDqY0xgXA/yWORF05r9XGoeuN6XEDSR8h
 8vNkx1gM95m+jniiU9FpbDi5gmK7skzylv2vJfg4As/jMpFMXZLiopWTgCWsl/FmINMZ
 ABd6J00PcNq6+wMiv8PqmtvbBTFrMGv0ByaouV5HdKF4yrr1QnJz/NYqlpm4lr84+yQf
 RGCBi0kvpn7XA1GycREbR3ToDuyN5Ix3GslejnDymcdri5mliaTXK5tkUDM1lBHdkclW
 00/vf+Bn19FYD/SOSfU1bC93+Gyg2mjOFEOTuYakA4V6ggnBLerUGi5fmZag7DCqX64y
 fnqA==
X-Gm-Message-State: AOAM53196BdB2R4EOLGL0ljURUWgjlAf9GeBfXz5Ijo9ERgp3xPzAuKd
 Jmjr0zclPpwRgbRkVhmD0MJmjQqt+zrpxYc96ZxV9H+FvcYcVBbpEifOlhT0i8cg7dYqcqS+KM1
 qkBY34ITGfjBc/x7wqgiE6hnN
X-Received: by 2002:a17:906:480a:: with SMTP id
 w10mr2449888ejq.262.1634202254375; 
 Thu, 14 Oct 2021 02:04:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx51QMjFB9Vzo1OSOWMnnTw0zDmc+1WIxFwXo1jS+FtYBu1RisLoBxSR9VmCwx+bPBhBVyTMQ==
X-Received: by 2002:a17:906:480a:: with SMTP id
 w10mr2449861ejq.262.1634202254160; 
 Thu, 14 Oct 2021 02:04:14 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id ke12sm1431541ejc.32.2021.10.14.02.04.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Oct 2021 02:04:13 -0700 (PDT)
Date: Thu, 14 Oct 2021 11:04:11 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v9 13/22] KVM: arm64: pkvm: Use a single function to
 expose all id-regs
Message-ID: <20211014090411.dk2whm76hwsems6j@gator.home>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
 <20211013120346.2926621-3-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211013120346.2926621-3-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kernel-team@android.com, kvm@vger.kernel.org, pbonzini@redhat.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Wed, Oct 13, 2021 at 01:03:37PM +0100, Marc Zyngier wrote:
> Rather than exposing a whole set of helper functions to retrieve
> individual ID registers, use the existing decoding tree and expose
> a single helper instead.
> 
> This allow a number of functions to be made static, and we now
> have a single entry point to maintain.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/sys_regs.h | 14 +-------
>  arch/arm64/kvm/hyp/nvhe/pkvm.c             | 10 +++---
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c         | 37 ++++++++++++----------
>  3 files changed, 26 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/sys_regs.h b/arch/arm64/kvm/hyp/include/nvhe/sys_regs.h
> index 3288128738aa..8adc13227b1a 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/sys_regs.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/sys_regs.h
> @@ -9,19 +9,7 @@
>  
>  #include <asm/kvm_host.h>
>  
> -u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64pfr1(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64zfr0(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64dfr0(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64dfr1(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64afr0(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64afr1(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64isar0(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64isar1(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64mmfr0(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64mmfr1(const struct kvm_vcpu *vcpu);
> -u64 get_pvm_id_aa64mmfr2(const struct kvm_vcpu *vcpu);

This is nice.

> -
> +u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
>  bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
>  int kvm_check_pvm_sysreg_table(void);
>  void inject_undef64(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 633547cc1033..62377fa8a4cb 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -15,7 +15,7 @@
>   */
>  static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
>  {
> -	const u64 feature_ids = get_pvm_id_aa64pfr0(vcpu);
> +	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
>  	u64 hcr_set = HCR_RW;
>  	u64 hcr_clear = 0;
>  	u64 cptr_set = 0;
> @@ -62,7 +62,7 @@ static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
>   */
>  static void pvm_init_traps_aa64pfr1(struct kvm_vcpu *vcpu)
>  {
> -	const u64 feature_ids = get_pvm_id_aa64pfr1(vcpu);
> +	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR1_EL1);
>  	u64 hcr_set = 0;
>  	u64 hcr_clear = 0;
>  
> @@ -81,7 +81,7 @@ static void pvm_init_traps_aa64pfr1(struct kvm_vcpu *vcpu)
>   */
>  static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
>  {
> -	const u64 feature_ids = get_pvm_id_aa64dfr0(vcpu);
> +	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
>  	u64 mdcr_set = 0;
>  	u64 mdcr_clear = 0;
>  	u64 cptr_set = 0;
> @@ -125,7 +125,7 @@ static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
>   */
>  static void pvm_init_traps_aa64mmfr0(struct kvm_vcpu *vcpu)
>  {
> -	const u64 feature_ids = get_pvm_id_aa64mmfr0(vcpu);
> +	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64MMFR0_EL1);
>  	u64 mdcr_set = 0;
>  
>  	/* Trap Debug Communications Channel registers */
> @@ -140,7 +140,7 @@ static void pvm_init_traps_aa64mmfr0(struct kvm_vcpu *vcpu)
>   */
>  static void pvm_init_traps_aa64mmfr1(struct kvm_vcpu *vcpu)
>  {
> -	const u64 feature_ids = get_pvm_id_aa64mmfr1(vcpu);
> +	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
>  	u64 hcr_set = 0;
>  
>  	/* Trap LOR */
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> index 6bde2dc5205c..f125d6a52880 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -82,7 +82,7 @@ static u64 get_restricted_features_unsigned(u64 sys_reg_val,
>   * based on allowed features, system features, and KVM support.
>   */
>  
> -u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
>  {
>  	const struct kvm *kvm = (const struct kvm *)kern_hyp_va(vcpu->kvm);
>  	u64 set_mask = 0;
> @@ -103,7 +103,7 @@ u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
>  	return (id_aa64pfr0_el1_sys_val & allow_mask) | set_mask;
>  }
>  
> -u64 get_pvm_id_aa64pfr1(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64pfr1(const struct kvm_vcpu *vcpu)
>  {
>  	const struct kvm *kvm = (const struct kvm *)kern_hyp_va(vcpu->kvm);
>  	u64 allow_mask = PVM_ID_AA64PFR1_ALLOW;
> @@ -114,7 +114,7 @@ u64 get_pvm_id_aa64pfr1(const struct kvm_vcpu *vcpu)
>  	return id_aa64pfr1_el1_sys_val & allow_mask;
>  }
>  
> -u64 get_pvm_id_aa64zfr0(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64zfr0(const struct kvm_vcpu *vcpu)
>  {
>  	/*
>  	 * No support for Scalable Vectors, therefore, hyp has no sanitized
> @@ -124,7 +124,7 @@ u64 get_pvm_id_aa64zfr0(const struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -u64 get_pvm_id_aa64dfr0(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64dfr0(const struct kvm_vcpu *vcpu)
>  {
>  	/*
>  	 * No support for debug, including breakpoints, and watchpoints,
> @@ -134,7 +134,7 @@ u64 get_pvm_id_aa64dfr0(const struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -u64 get_pvm_id_aa64dfr1(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64dfr1(const struct kvm_vcpu *vcpu)
>  {
>  	/*
>  	 * No support for debug, therefore, hyp has no sanitized copy of the
> @@ -144,7 +144,7 @@ u64 get_pvm_id_aa64dfr1(const struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -u64 get_pvm_id_aa64afr0(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64afr0(const struct kvm_vcpu *vcpu)
>  {
>  	/*
>  	 * No support for implementation defined features, therefore, hyp has no
> @@ -154,7 +154,7 @@ u64 get_pvm_id_aa64afr0(const struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -u64 get_pvm_id_aa64afr1(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64afr1(const struct kvm_vcpu *vcpu)
>  {
>  	/*
>  	 * No support for implementation defined features, therefore, hyp has no
> @@ -164,12 +164,12 @@ u64 get_pvm_id_aa64afr1(const struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -u64 get_pvm_id_aa64isar0(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64isar0(const struct kvm_vcpu *vcpu)
>  {
>  	return id_aa64isar0_el1_sys_val & PVM_ID_AA64ISAR0_ALLOW;
>  }
>  
> -u64 get_pvm_id_aa64isar1(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64isar1(const struct kvm_vcpu *vcpu)
>  {
>  	u64 allow_mask = PVM_ID_AA64ISAR1_ALLOW;
>  
> @@ -182,7 +182,7 @@ u64 get_pvm_id_aa64isar1(const struct kvm_vcpu *vcpu)
>  	return id_aa64isar1_el1_sys_val & allow_mask;
>  }
>  
> -u64 get_pvm_id_aa64mmfr0(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64mmfr0(const struct kvm_vcpu *vcpu)
>  {
>  	u64 set_mask;
>  
> @@ -192,22 +192,19 @@ u64 get_pvm_id_aa64mmfr0(const struct kvm_vcpu *vcpu)
>  	return (id_aa64mmfr0_el1_sys_val & PVM_ID_AA64MMFR0_ALLOW) | set_mask;
>  }
>  
> -u64 get_pvm_id_aa64mmfr1(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64mmfr1(const struct kvm_vcpu *vcpu)
>  {
>  	return id_aa64mmfr1_el1_sys_val & PVM_ID_AA64MMFR1_ALLOW;
>  }
>  
> -u64 get_pvm_id_aa64mmfr2(const struct kvm_vcpu *vcpu)
> +static u64 get_pvm_id_aa64mmfr2(const struct kvm_vcpu *vcpu)
>  {
>  	return id_aa64mmfr2_el1_sys_val & PVM_ID_AA64MMFR2_ALLOW;
>  }
>  
> -/* Read a sanitized cpufeature ID register by its sys_reg_desc. */
> -static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> -		       struct sys_reg_desc const *r)
> +/* Read a sanitized cpufeature ID register by its encoding */
> +u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
>  {
> -	u32 id = reg_to_encoding(r);
> -
>  	switch (id) {
>  	case SYS_ID_AA64PFR0_EL1:
>  		return get_pvm_id_aa64pfr0(vcpu);
> @@ -245,6 +242,12 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> +		       struct sys_reg_desc const *r)
> +{
> +	return pvm_read_id_reg(vcpu, reg_to_encoding(r));
> +}
> +
>  /*
>   * Accessor for AArch32 feature id registers.
>   *
> -- 
> 2.30.2
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
