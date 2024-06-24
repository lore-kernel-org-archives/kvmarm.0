Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B522D13D628
	for <kvmarm@lists.linux.dev>; Mon, 24 Jun 2024 15:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719244138; cv=none; b=TE8O1X2GxumNppvsVGeG2dkkP5Qy//KeyKYnY+9OI1F/PqcR3NRJOzr+81MgY4uN/rLdgrhwZqJn0UAQGTtBvXpmQvwulO1tXrc5s6h1+w35fpR1EDVyGEkR0B/PQRXqBNbvTOx/K07Y29BuBahmYGIjrabRIn82GXH44hzMKXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719244138; c=relaxed/simple;
	bh=GqaP3vGD7gvrzGgNXX4qO07+i06y1ReV6MZ9SSpLyZk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LBMhPp1hBKTUBZZKUwUhy9XE7g2NMY1O9fZY0sRATmaJXfQrAVUH8yCsi1KhJQRgudKSkWxiyYi05r5Hq5AZRVnkZ6BAbDzjOPF5OaB83Z40aOxyTRBKUQuRNafSODc3w5HS5pxVNaZ/t7j28vrDOqQ/TuxrNNdSeNNZ9cY7D3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HtCxv0vb; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HtCxv0vb"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df771b5e942so8320937276.2
        for <kvmarm@lists.linux.dev>; Mon, 24 Jun 2024 08:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719244136; x=1719848936; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w0TfFi1A5eAUOELglH+ORGjDb5xIqjGuRnaKSa2m3Gs=;
        b=HtCxv0vbBmY2+9yHlwyieFyCkaAmqt2tbYogLDk8re7kiKFsyQ3BXCdCqrnkaq8wDc
         E/ELxBH6x7+TC6aGQeTh1eyZO0SRrQN5kxSa25v2QsAOhml4dyMJLcd9oU5PSJMFubvL
         yp3+o++UUNWn+gyFlYIBL3MfkJfcAxstrU0HFfewfM6/TpD3gGyJIZNqL4mEzh31Wmi6
         buWAqJoDAxA6sSDuEy+BXLuO43Ou5z8Wfc9TJTKmjhbsvI4pLk1/tEehdequ6XkkmnJ3
         YMxlFmFx/FzzIqyNMH3Ue1Md+yiUWpV+isZ8Bhpi1QBYZU0Qsx5RpnZpEUvCM4jTb+ca
         D2mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719244136; x=1719848936;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w0TfFi1A5eAUOELglH+ORGjDb5xIqjGuRnaKSa2m3Gs=;
        b=oMc7dnJP40rXrfap+SvOU1vanQOxtX6ipc1sv/g638kYVF6hydyufVrtr7Yf+6QrFo
         sH4lWJUX/eLwDkeHPabCuxf8DY1Mst05JkAd/8xMQhtHAJhZGzuiRE/umWfhQ3Ji3Ccy
         BQS4SWSmSgXVxyDH3rRvSJc96bPSSbLHnXFvWFdauLwERMKuT/vjKI3JQnQttTQgJb6I
         glaHZ86m6vrYraZc+iMPGGBCraM8OjaN8FNtnbbdo8a9sXYC0rNnvOLkvby7Nt2a9q7I
         SdGyLmN5Iv5539SJSQ3ogYVL5tlnQ2MroYg9ad6vPRk6KG4ePG6l4e1TeiuRrmuc+q4D
         Ss8g==
X-Gm-Message-State: AOJu0YxylNlBDUPM1DWvL5TyyoaHsO3h9u3HBdv1+BohZHySqOcf3hcY
	gyq5161k1eCcn6H6bmcOiUI8wCCbWoD1npG67VAneKSs6navfjZ8mmtKlmKGJNCYNzYIp5R7p28
	4nA==
X-Google-Smtp-Source: AGHT+IF8kv5cg7jBtfLj5KChqQb0E4AVt+N3NAFysUC46dBIyhEpZe/ChMcBWGfHF7p7NpzSNPuuniqMZ0A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:705:b0:df4:8ecb:ae57 with SMTP id
 3f1490d57ef6-e030108f81cmr16300276.10.1719244135814; Mon, 24 Jun 2024
 08:48:55 -0700 (PDT)
Date: Mon, 24 Jun 2024 08:48:54 -0700
In-Reply-To: <20240208151837.35068-2-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com> <20240208151837.35068-2-shameerali.kolothum.thodi@huawei.com>
Message-ID: <ZnmVZo8awnuFdQjz@google.com>
Subject: Re: [RFC PATCH v2 1/7] KVM: Add generic infrastructure to support
 pinned VMIDs
From: Sean Christopherson <seanjc@google.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, iommu@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com, 
	kevin.tian@intel.com, jgg@ziepe.ca, alex.williamson@redhat.com, 
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, robin.murphy@arm.com, 
	jean-philippe@linaro.org, jonathan.cameron@huawei.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 08, 2024, Shameer Kolothum wrote:
> Provide generic helper functions to get/put pinned VMIDs if the arch
> supports it.

IMO, this has no business being in generic KVM.  Multiple architectures have
constructs that are _similar_ ARM's VMID, but AFAICT the exact semantics are very
ARM specific.  I.e. odds are very good that the only thing that can actually use
kvm_pinned_vmid_get() is the SMMU, because the concept won't fit any other
architecture.

The other issue is that other architectures support building KVM as a module,
which makes it much more difficult to guarantee the safety of these hooks.

> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  include/linux/kvm_host.h | 18 ++++++++++++++++++
>  virt/kvm/Kconfig         |  3 +++
>  virt/kvm/kvm_main.c      | 23 +++++++++++++++++++++++
>  3 files changed, 44 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7e7fd25b09b3..610e239bea46 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2311,6 +2311,24 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
>  }
>  #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
>  
> +#ifdef CONFIG_HAVE_KVM_PINNED_VMID
> +int kvm_arch_pinned_vmid_get(struct kvm *kvm);
> +void kvm_arch_pinned_vmid_put(struct kvm *kvm);
> +#endif
> +
> +#ifdef CONFIG_HAVE_KVM_PINNED_VMID
> +int kvm_pinned_vmid_get(struct kvm *kvm);
> +void kvm_pinned_vmid_put(struct kvm *kvm);
> +#else
> +static inline int kvm_pinned_vmid_get(struct kvm *kvm)
> +{
> +	return -EINVAL;
> +}
> +
> +static inline void kvm_pinned_vmid_put(struct kvm *kvm)
> +{
> +}
> +#endif
>  /*
>   * If more than one page is being (un)accounted, @virt must be the address of
>   * the first page of a block of pages what were allocated together (i.e
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 184dab4ee871..a3052c8e3ac4 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -108,3 +108,6 @@ config KVM_GENERIC_PRIVATE_MEM
>         select KVM_GENERIC_MEMORY_ATTRIBUTES
>         select KVM_PRIVATE_MEM
>         bool
> +
> +config HAVE_KVM_PINNED_VMID
> +       bool
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 10bfc88a69f7..f84d6da5f464 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3918,6 +3918,29 @@ bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_wake_up);
>  
> +#ifdef CONFIG_HAVE_KVM_PINNED_VMID
> +int kvm_pinned_vmid_get(struct kvm *kvm)
> +{
> +	int ret;
> +
> +	if (!kvm_get_kvm_safe(kvm))
> +		return -ENOENT;
> +	ret  = kvm_arch_pinned_vmid_get(kvm);
> +	if (ret < 0)
> +		kvm_put_kvm(kvm);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(kvm_pinned_vmid_get);
> +
> +void kvm_pinned_vmid_put(struct kvm *kvm)
> +{
> +	kvm_arch_pinned_vmid_put(kvm);
> +	kvm_put_kvm(kvm);
> +}
> +EXPORT_SYMBOL_GPL(kvm_pinned_vmid_put);
> +#endif
> +
>  #ifndef CONFIG_S390
>  /*
>   * Kick a sleeping VCPU, or a guest VCPU in guest mode, into host kernel mode.
> -- 
> 2.34.1
> 
