Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7766739EF20
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 14:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790087673; cv=none; b=ZhtNEPolurYSzTJtdPX9umqi/SJwhf+G8oplXq01ZeLbm6t2NaXuaAAlrF93YNERwATyNeHoMMbdsiEth7sseMjizfUsE2WbYUzJGXHMbOfDY+hgiD7LqaZVhimGDiHfjgbGGlmebkCGo520meC4f8l/E07+Yf2sDZ/oYZeHMoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790087673; c=relaxed/simple;
	bh=OSpr8vZBZSILiOyuY44tAAoQRF+Mre7i03lUP3vPqEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e5/Ex58ZY8PkSmoQRiLwds9CbsUky3iwUHNrJt88cTXw91VVIV7gm4xobkIDbYyYcGLfn1RGqC2Dk/PCmEtfvPYZliBe3bBt1WZFgd8fyy/9CHmMQADpKESA0tTzsPdyzhW+0ayfTx7+a7WqemrY9ZNgH3ISjPBAoZIOqI9qBfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e2DsXUcP; arc=none smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e2DsXUcP"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b5e4f13d77so4803068e87.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 07:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790087668; x=1790692468; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=r0HTz7i0csHEzPxGHorQVXPbwITXujz+YYUQK1Bj5/w=;
        b=e2DsXUcPQau0AJPpoyCJKa3RzkPV//Gwc2/AoRdCqkcPHUURqjS14HAVvYbSiO1xMq
         MAbQ7ekc6ePL+GJ8vGeff/lNvr0Xi5X8xJLuWec08W/G6x6PPRxAUg2+l8Bg4VzyDnEo
         QYtPFykuozw8GWwqpO7EnEDGhLXT04kDHlPCN+GwNeLXOmZF+y/r9qVYf6abWRkz5b3l
         RngP4kXPoH1bCEEL5+smIhEMCVPo79C6nURm+tb9cTmnaOtS0td83OMqKIc3JifpBwHy
         SSHI3HKgu+u+BRs5YsbdamziHdBnp48m/29uuYsT3/PUh3AbKc0xLyZwrFrs9BWm17T+
         x1Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790087668; x=1790692468;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r0HTz7i0csHEzPxGHorQVXPbwITXujz+YYUQK1Bj5/w=;
        b=kVJFJed5+9jdavqXX4BaPEP/E6fmrohgKvwPiwai1qqGyliaPsK6p+PDPLHKv3NehQ
         VnpHheIRycQEHJz6ixZD+tk1iH1ph8r/DR3NFwmpd1wRpKmo2RzIiXKEGva+uxhafLov
         uLUj6LHrYDQCm/YU67c4Syz1+uonEmqjeP4l9m7SizJco+tWy2CQOrFHiynePZelAq6+
         38VqUjVTyQewpIemr4669CaoF/F85ShRHVQ9k8xVL8k1p1KrmzUalvu0G2bUODO/esDs
         I8/L2e01GuKxmsTa6lF1RAFHM3k6goIyVzD4igexfCC4Le8YzgYoxGpAXWTGOWiEobUP
         XJJw==
X-Forwarded-Encrypted: i=1; AKwUvBweITAGiIytqFKF696LuWTIr+q4SgGqxRE/PRUWaUUEMrDuA/3nqqfh7Y7eiN0u2U4pzE2M+sI=@lists.linux.dev
X-Gm-Message-State: AFuF++k4+9alA1AnHf50Kj+6TPIWYXC3Do7bxp8/VpU2h9A3g33wVrB2
	B2ouz3RLF2YPdpqHWcyIpHOqOUBXHauLYtypNeu1Hcl8tgvlYijn75xUI5XscwZ48g==
X-Gm-Gg: AYBFou3m+4qZbWtbtPBzWuE7w3jRLK4uFffjyz/blg3sE6vG69LwcQArd8seBheKPox
	UNwIyl7ZDTc5+8CZlABM69toPaRTritFN8UlnhxXyjFvOb6q8stekh3xla0a0cEtK8DkkXFJnlK
	PYtkGSHtiPZCqZmfEmZjkA8gucIvQ+lhKvxEs3bvY0RuNX05aijrQ1HhKF/eLfMGJjtYzon44lp
	qa+GcqL2V5GF/E1FDWKlnUPHW/7UuflTMkjOViR4rcqlODWAMXIWz4VYbB4Qfka5rMLEcolsy8D
	RZaA1kC9IklWksmoE33slAcYetq1iaPUjZNOFKroLHPLkhhx11L/x9kUZS5PuXXp+Mc51wA8o/u
	eCXru+YCuj5eZZdiRaq6qd1jpE4+HFvbLMt99w45WCsz1iCJaY7cGTnVpt/8OLNFqCyOL3JqdTR
	kGmjOHMXJCFM9xnj3DPbi7Q1G43GWvEfA2OTnZSeu7QSZESd1EO3G4/rG4AZfnKzRXybVHPx9S9
	zmX352SoeycPL4km/YW96d8ZW7tx6o4DEvULpfFT0ZfJb+dYx36IA==
X-Received: by 2002:a05:6512:3e1b:b0:5b6:1a7c:21 with SMTP id 2adb3069b0e04-5b8c184e320mr4889993e87.36.1790087667742;
        Tue, 22 Sep 2026 07:34:27 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d46e871dsm604660e87.60.2026.09.22.07.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 07:34:27 -0700 (PDT)
Date: Tue, 22 Sep 2026 15:34:22 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	mark.rutland@arm.com, steven.price@arm.com, qperret@google.com,
	tabba@google.com
Subject: Re: [PATCH v3 04/18] KVM: arm64: Disable steal time for protected VMs
Message-ID: <arKR7gJaeCpWqA5j@google.com>
References: <20260914113338.159227-1-fuad.tabba@linux.dev>
 <20260914113338.159227-5-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914113338.159227-5-fuad.tabba@linux.dev>

On Mon, Sep 14, 2026 at 12:33:24PM +0100, Fuad Tabba wrote:
> pKVM doesn't support steal time for protected guests, and
> KVM_CAP_STEAL_TIME already reads 0 for them on the VM file descriptor,
> but kvm_arm_pvtime_supported() doesn't know the VM, so the host still
> accepts the KVM_ARM_VCPU_PVTIME_CTRL attribute, whose IPA would point
> kvm_update_stolen_time() at the guest's private memory on every vCPU
> load. Pass the VM in and return false for a protected one, so the
> attribute returns -ENXIO as it does where steal time isn't implemented.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  arch/arm64/include/asm/kvm_host.h |  2 +-
>  arch/arm64/kvm/arm.c              |  2 +-
>  arch/arm64/kvm/pvtime.c           | 10 +++++-----
>  3 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 27fe0cd5b2d7a..286489a69dff5 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1346,7 +1346,7 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
>  gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu);
>  void kvm_update_stolen_time(struct kvm_vcpu *vcpu);
>  
> -bool kvm_arm_pvtime_supported(void);
> +bool kvm_arm_pvtime_supported(struct kvm *kvm);
>  int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
>  			    struct kvm_device_attr *attr);
>  int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8b080804bc90b..db36815630790 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -447,7 +447,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		r = system_supports_mte();
>  		break;
>  	case KVM_CAP_STEAL_TIME:
> -		r = kvm_arm_pvtime_supported();
> +		r = kvm_arm_pvtime_supported(kvm);
>  		break;
>  	case KVM_CAP_ARM_EL1_32BIT:
>  		r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);
> diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
> index 4ceabaa4c30bd..053fe831fa541 100644
> --- a/arch/arm64/kvm/pvtime.c
> +++ b/arch/arm64/kvm/pvtime.c
> @@ -67,9 +67,9 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
>  	return base;
>  }
>  
> -bool kvm_arm_pvtime_supported(void)
> +bool kvm_arm_pvtime_supported(struct kvm *kvm)
>  {
> -	return !!sched_info_on();
> +	return !!sched_info_on() && (!kvm || !kvm_vm_is_protected(kvm));
>  }
>  
>  int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
> @@ -81,7 +81,7 @@ int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
>  	int ret = 0;
>  	int idx;
>  
> -	if (!kvm_arm_pvtime_supported() ||
> +	if (!kvm_arm_pvtime_supported(kvm) ||
>  	    attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
>  		return -ENXIO;
>  
> @@ -110,7 +110,7 @@ int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
>  	u64 __user *user = (u64 __user *)attr->addr;
>  	u64 ipa;
>  
> -	if (!kvm_arm_pvtime_supported() ||
> +	if (!kvm_arm_pvtime_supported(vcpu->kvm) ||
>  	    attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
>  		return -ENXIO;
>  
> @@ -126,7 +126,7 @@ int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
>  {
>  	switch (attr->attr) {
>  	case KVM_ARM_VCPU_PVTIME_IPA:
> -		if (kvm_arm_pvtime_supported())
> +		if (kvm_arm_pvtime_supported(vcpu->kvm))
>  			return 0;
>  	}
>  	return -ENXIO;
> -- 
> 2.39.5
> 

-- 
Vincent
