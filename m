Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DBA1A8F60
	for <kvmarm@lists.linux.dev>; Sun,  3 Aug 2025 06:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754201401; cv=none; b=JjAC/d/5B3wSHjauAeXp+X3gVfqA2gatABbrJseIWE2PECP5VzRqDkvPyYqSIM91nB4cC6fcAr7C2DBH8BDT5zgJE4kid1rM3p3nJdMxx91QMR8HIhRRhQtg2h6QiprMLxfVrfpqRUKH9JKHIQ1y0LT7QE4BwjtN6LqP9PEYYE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754201401; c=relaxed/simple;
	bh=gGyXq4pd6AFXNpOGh89Q2Q5IKdR6Ux6mxPJHDQCFFPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UVtB5bbskoZ9BuPtOTidXUNotu59k1yTQ9DTIRawnhujywqUyjEDYks6Eh2J1S16iqatyNYNZIW6MVX56HHOgovVadYB4dYgHkJ9YQjVtIBHQlgLcfuM/Q8ytlfswUe3K2M/wa+ywRLm16R6OAQitKDnYNutJMFQo8geMHRJvkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=froR79ZP; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="froR79ZP"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b390136ed88so2198452a12.2
        for <kvmarm@lists.linux.dev>; Sat, 02 Aug 2025 23:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1754201397; x=1754806197; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vEUnRTvQ08kI5I5Akg5OcMZWx7icrdrdgfCIPtytf6Y=;
        b=froR79ZPwgUkebWDfD2p/DEiKJUMbkcazesLwqNQLlZAEyVMrb7BLkL1YwMzmfkUX5
         733nUZ2VhiCUzyIj/WXUUdUjvZ/nEV/5EixUu99oFvFG0qlnZsovu+SpfQjIol0coZSe
         0NHVu9jDGBgpzPiPSHbzTmjrnQ3/rS0MmXs9/bD1HJtyIowhgXNiZK09YFEAlw3EHltY
         c1mBV7BgbWJVBbGvyHekQTKscCREgsk2limHNq04dMAVEKbC9jq5XKW1OdOpGAYrNYb/
         6htBUofE2yUGSuZwdVafl3TwxEVh1uOI3PobqbzX2p4QTjqppYhVkLxmnVa8449JPA4f
         nKmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754201397; x=1754806197;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vEUnRTvQ08kI5I5Akg5OcMZWx7icrdrdgfCIPtytf6Y=;
        b=tAMpsPxJprQTIYdmfOa8/XK4IGloJ0PDUCRK61dEkimBBjbpKDomUzc5I2DhI4XpLA
         bFZaxt/WAJANSv6r7+UGUNjdkzlp8CMwf478PwRItk5CBc2al8rgcieodLFWR5Hy/4ET
         SHEwnp8BMg3WZt2tr6e7jDdLOKGjULXMtvsFvtwZ9QaAQCcrCvmVsd9tP+l465OFEk09
         4Ul9kfsn+zu64QzfbdzEaKkvk4xkVrCuD7OCaOW+lHJHtdTnYJazaQlBrBOe6nJWSt/v
         UVlMdDTZ7u/jCXeONWSrszWYrzwvrFKdTblgK+y7iHlyyb/eQQQa0MB760chHizk5/2f
         BMQA==
X-Forwarded-Encrypted: i=1; AJvYcCXTojPY+1KOYu/v+uDe4xeCiRTh6wmPuUo2wt9PlJuUtL6NKRZYsJ+IZ2AXp05oU8Zn05GZNB0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yya6QSo8mzaAVaklyzwim9dTxt6KpKKARa++tsyyFIBb4ik5qZo
	F5v0jApukUTpkqRGVIyIsr8My91e45C2OQu+uiOcPP2y7xXlFA1fcAuNk7SBsN48SR0u1UkvK1f
	+1poxQV3QuwCHh5e7c6DlFh/ye4rbsZa1fv6iGI1Qda4K64+Zn5o=
X-Gm-Gg: ASbGncssCF9MScMPstYlO9fARONdWHC6dy1P3EC8xZ9k7lOy3Ef+SzknfqXDBgtKOSy
	XLSCkr+sj7FpCHpZdZ11JHMA0xYNSyufeR/lvdBXxJuTkT8o7GosbNHjQ/j68/9Nl8n3aDcajIM
	NaBtrBAcYB9E0oU+pLVtYNjnbPP5XEPolkw56outQ1JDYkslMsiyk1TZi0twicLyLg//ze71eZr
	axJY8u2Ejp+AL6NtjIzaA0+U2zhzMtDd4M4V7n0t7mlty7cT3kSNFXWOsH3mmJv9DcpCCoeyHYr
	dscPb5LInLHt8kZsTKKjn8PYBH4FHH9mY3Bc3aHtxVVoVBGZ+1RZ1flRnrutUKio3OTMlv1N6Rb
	aSQUvJ1QPf2gAf91rzb/CPdnQGK0fq5fPQnIbq1i+cQPxkHOqxiHHOPxZ3ThfdMJCsJuV394=
X-Google-Smtp-Source: AGHT+IFX2BKlJOxqOQLOCKoNLPbIsC/9RtXyDmT1nriD6O07Iw2g1QDl1QbnMj8/V1anMVtcYFA7gA==
X-Received: by 2002:a05:6a20:244a:b0:240:4d5:8fe1 with SMTP id adf61e73a8af0-24004d59411mr232493637.12.1754201397049;
        Sat, 02 Aug 2025 23:09:57 -0700 (PDT)
Received: from zenbook (1-162-100-196.dynamic-ip.hinet.net. [1.162.100.196])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b42306f1de3sm6304516a12.62.2025.08.02.23.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Aug 2025 23:09:56 -0700 (PDT)
Date: Sun, 3 Aug 2025 14:10:44 +0800
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, vdonnefort@google.com, qperret@google.com, 
	sebastianene@google.com, keirf@google.com, smostafa@google.com
Subject: Re: [PATCH v1 1/8] KVM: arm64: Rename pkvm.enabled to
 pkvm.is_protected
Message-ID: <szsqsx77mjo4kdawzcboud4eawuvz3sye4grmx5n74qzze26ap@xbfwc44ruetx>
References: <20250729120014.2799359-1-tabba@google.com>
 <20250729120014.2799359-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729120014.2799359-2-tabba@google.com>
X-Gm-Spam: 0
X-Gm-Phishy: 0

Hi Fuad,

I am reading some pKVM code and would like to ask for help on some
questions to make sure my understanding is correct:

While looking at the code I don't see pkvm.enabled, or now
pkvm.is_protected really assigned, is pkvm development going to add the
ability to let the user pick whether they want to start a protected VM
(host EL1 can't access VM memory and registers, mostly) or not (like
nVHE mode VMs) in the future?

Also, since when running pKVM (kvm-arm.mode=protected) the user can't
yet choose the VM to be protected or not, the current state is that all
VMs started by pKVM is protected, is that understanding correct?

Sorry if I missed anything.

Thanks,
Wei-Lin Chang

On Tue, Jul 29, 2025 at 01:00:06PM +0100, Fuad Tabba wrote:
> The 'pkvm.enabled' field in struct kvm_protected_vm is confusingly named.
> Its purpose is to indicate whether a VM is a pKVM protected VM, not
> whether the VM itself is enabled or running.
> 
> For a non-protected VM, the VM can be fully active, yet this field would
> be false. This ambiguity can lead to incorrect assumptions about the VM's
> operational state and makes the code harder to reason about.
> 
> Rename the field to 'is_protected' to make it unambiguous that the flag
> tracks the protected status of the VM.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 4 ++--
>  arch/arm64/kvm/hyp/nvhe/pkvm.c    | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 3e41a880b062..55dc7cd83e40 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -252,7 +252,7 @@ struct kvm_protected_vm {
>  	pkvm_handle_t handle;
>  	struct kvm_hyp_memcache teardown_mc;
>  	struct kvm_hyp_memcache stage2_teardown_mc;
> -	bool enabled;
> +	bool is_protected;
>  };
>  
>  struct kvm_mpidr_data {
> @@ -1522,7 +1522,7 @@ struct kvm *kvm_arch_alloc_vm(void);
>  
>  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
>  
> -#define kvm_vm_is_protected(kvm)	(is_protected_kvm_enabled() && (kvm)->arch.pkvm.enabled)
> +#define kvm_vm_is_protected(kvm)	(is_protected_kvm_enabled() && (kvm)->arch.pkvm.is_protected)
>  
>  #define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
>  
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 338505cb0171..6198c1d27b5b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -406,7 +406,7 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
>  	hyp_vm->host_kvm = host_kvm;
>  	hyp_vm->kvm.created_vcpus = nr_vcpus;
>  	hyp_vm->kvm.arch.mmu.vtcr = host_mmu.arch.mmu.vtcr;
> -	hyp_vm->kvm.arch.pkvm.enabled = READ_ONCE(host_kvm->arch.pkvm.enabled);
> +	hyp_vm->kvm.arch.pkvm.is_protected = READ_ONCE(host_kvm->arch.pkvm.is_protected);
>  	hyp_vm->kvm.arch.flags = 0;
>  	pkvm_init_features_from_host(hyp_vm, host_kvm);
>  }
> -- 
> 2.50.1.487.gc89ff58d15-goog
> 
