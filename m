Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 506ECC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 16:10:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BEC5B60FD7
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 16:10:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BEC5B60FD7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30C2E4B0C2;
	Mon, 27 Sep 2021 12:10:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5ae4ZcVGTAuQ; Mon, 27 Sep 2021 12:10:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8B284A19F;
	Mon, 27 Sep 2021 12:10:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEF7B4086D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 12:10:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 946Ok8ysRku3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 12:10:52 -0400 (EDT)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
 [209.85.221.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 99C8840630
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 12:10:52 -0400 (EDT)
Received: by mail-wr1-f47.google.com with SMTP id k7so996207wrd.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 09:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=tzYLDWLzrX157HH12ds8As0JD+WbAz+wC4M9zHAPsb0=;
 b=n0w9qX8LHDnB4PmprGBttwqCfsRmgViG9pnT1tI3UB/RLI5V7pij8YoHVV1N96Csx3
 5Oc3pgzbN1YsZLtwHhz7lHqpzGmUb1rlPFGT6EIyKQlmv9gzFIZa8Ey4Yn+R2LqrJJTI
 M+dcjV+aVR6gcSrrQNMAoxHr0QZwy/7gtFK6Q6z+I5Aev7Dvzg1gZrtMBUJ9U8Rv8Yaf
 KXKtquvuyLYSRk610QxpffujK0GUfZKg3WEdjTkao6KXksFMF/wPxw6L6SOpkaag1XWb
 Dz9Wt8S/mNzE+ojf1Cjv+Hs5wEogMohRrUI4EW5xYi89Pe8I2NiGwOWvMVjyFs6oBoPT
 78UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=tzYLDWLzrX157HH12ds8As0JD+WbAz+wC4M9zHAPsb0=;
 b=AcMMImaQCWtdoBJGKIJZEWMyGlnZ9KfcLGqJmjaqVebMilGgGxPuwsLac4ZQoRoBlH
 53oiOaQ0zXxpVk4VTDwYF6h8P5g0JVtC+fL6viYjfz7GY5XglxHmAVo4T/L5pcdieKYm
 AV+UHA9bjgQrawTWUo5heWe289OoObiEuWkNp4sY6hUjCQ0W6TxlukxnzllJekAlDHun
 H0jW+hBwXMt/UZJJ7PtL+/UpEyIGkY9dJ5YPStVMG4ok2DI5n0UhuXrxY57DrOUVJeJW
 2Oyea+gh1fTor2UGQJ1+Bh2sdnZInIh50Vnjw0t0gC5gv6Zyudk6RtEMTTREVop6ZbyG
 vwgA==
X-Gm-Message-State: AOAM532tmopld3hAjAiEENgLDKZwN0a2C+kI2RAHs6aZ+Jv/lHAB8YIc
 wXD+Dzp0LMQ95OHIZ5E+s/2p/Q==
X-Google-Smtp-Source: ABdhPJzK6sQGveEJG3lj86y73aLzjzcH6Iuz+0g1A3pJ41wIOKXBBXYwNJkzpO76TGfOUgstN+/AYw==
X-Received: by 2002:adf:dd42:: with SMTP id u2mr750952wrm.39.1632759051410;
 Mon, 27 Sep 2021 09:10:51 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:fa68:b369:184:c5a])
 by smtp.gmail.com with ESMTPSA id n14sm15314452wmc.38.2021.09.27.09.10.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Sep 2021 09:10:51 -0700 (PDT)
Date: Mon, 27 Sep 2021 17:10:48 +0100
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [RFC PATCH v1 10/30] KVM: arm64: Add accessors for hypervisor
 state in kvm_vcpu_arch
Message-ID: <YVHtCK22VYx4HVZM@google.com>
References: <20210924125359.2587041-1-tabba@google.com>
 <20210924125359.2587041-11-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210924125359.2587041-11-tabba@google.com>
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
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

On Friday 24 Sep 2021 at 13:53:39 (+0100), Fuad Tabba wrote:
> Some of the members of vcpu_arch represent state that belongs to
> the hypervisor. Future patches will factor these out into their
> own structure. To simplify the refactoring and make it easier to
> read, add accessors for the members of kvm_vcpu_arch that
> represent the hypervisor state.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 182 ++++++++++++++++++++++-----
>  arch/arm64/include/asm/kvm_host.h    |  38 ++++--
>  2 files changed, 181 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 7d09a9356d89..e095afeecd10 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -41,9 +41,14 @@ void kvm_inject_vabt(struct kvm_vcpu *vcpu);
>  void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
>  void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
>  
> +static __always_inline bool hyp_state_el1_is_32bit(struct vcpu_hyp_state *vcpu_hyps)
> +{
> +	return !(hyp_state_hcr_el2(vcpu_hyps) & HCR_RW);
> +}
> +
>  static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
>  {
> -	return !(vcpu_hcr_el2(vcpu) & HCR_RW);
> +	return hyp_state_el1_is_32bit(&hyp_state(vcpu));
>  }
>  
>  static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
> @@ -252,14 +257,19 @@ static inline bool vcpu_mode_priv(const struct kvm_vcpu *vcpu)
>  	return mode != PSR_MODE_EL0t;
>  }
>  
> +static __always_inline u32 kvm_hyp_state_get_esr(const struct vcpu_hyp_state *vcpu_hyps)
> +{
> +	return hyp_state_fault(vcpu_hyps).esr_el2;
> +}
> +
>  static __always_inline u32 kvm_vcpu_get_esr(const struct kvm_vcpu *vcpu)
>  {
> -	return vcpu_fault(vcpu).esr_el2;
> +	return kvm_hyp_state_get_esr(&hyp_state(vcpu));
>  }
>  
> -static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
> +static __always_inline u32 kvm_hyp_state_get_condition(const struct vcpu_hyp_state *vcpu_hyps)
>  {
> -	u32 esr = kvm_vcpu_get_esr(vcpu);
> +	u32 esr = kvm_hyp_state_get_esr(vcpu_hyps);
>  
>  	if (esr & ESR_ELx_CV)
>  		return (esr & ESR_ELx_COND_MASK) >> ESR_ELx_COND_SHIFT;
> @@ -267,111 +277,216 @@ static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
>  	return -1;
>  }
>  
> +static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
> +{
> +	return kvm_hyp_state_get_condition(&hyp_state(vcpu));
> +}
> +
> +static __always_inline phys_addr_t kvm_hyp_state_get_hfar(const struct vcpu_hyp_state *vcpu_hyps)
> +{
> +	return hyp_state_fault(vcpu_hyps).far_el2;
> +}
> +
>  static __always_inline unsigned long kvm_vcpu_get_hfar(const struct kvm_vcpu *vcpu)
>  {
> -	return vcpu_fault(vcpu).far_el2;
> +	return kvm_hyp_state_get_hfar(&hyp_state(vcpu));
> +}
> +
> +static __always_inline phys_addr_t kvm_hyp_state_get_fault_ipa(const struct vcpu_hyp_state *vcpu_hyps)
> +{
> +	return ((phys_addr_t) hyp_state_fault(vcpu_hyps).hpfar_el2 & HPFAR_MASK) << 8;
>  }
>  
>  static __always_inline phys_addr_t kvm_vcpu_get_fault_ipa(const struct kvm_vcpu *vcpu)
>  {
> -	return ((phys_addr_t) vcpu_fault(vcpu).hpfar_el2 & HPFAR_MASK) << 8;
> +	return kvm_hyp_state_get_fault_ipa(&hyp_state(vcpu));
> +}
> +
> +static __always_inline u32 kvm_hyp_state_get_disr(const struct vcpu_hyp_state *vcpu_hyps)
> +{
> +	return hyp_state_fault(vcpu_hyps).disr_el1;
>  }

Looks like kvm_hyp_state_get_disr() (as well as most of the
kvm_hyp_state_*() helpers below) are never used outside of their
kvm_vcpu_*() counterparts, so maybe let's merge them for now? This series
is really quite large, so I'm just hoping we can trim a bit the bits
that aren't strictly necessary :)

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
