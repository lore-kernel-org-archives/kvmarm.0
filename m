Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673B11A7F7D
	for <kvmarm@lists.linux.dev>; Wed, 31 Jul 2024 08:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722413500; cv=none; b=I2PulvJC0JuR2bzu7wbn6mKup8Bi3WlkaazT6rL7UvvNlZx4PwaTiWMyO5WWrigzNttqWIX3XN63EiyTGR8I4nVT8b7jzthn7Yiuh+DytrYaJrYW561Mk+CXWsGTtpBcWULzGFsFK/hsrzOzGNvOMCvMiPBf1+9IBJIKyU1qoSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722413500; c=relaxed/simple;
	bh=7y80z9vltmygihtb/PjFOov0Ly9Wsms87Ew+RYBWeW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kBCIp4rolCFjRruViqSDz5+kAvqhdwCUrJvZPGBnZr5EJ7lRGT46HNoOWh7edAHgbC6uC7w7QGBZfHwkGWtPaLSR8O8antj+uBcr+f31kL+ZxSvYJp9R28hv9F9Q+trfrqp9ndkWYcykYxdT3qFDFiCMzQ3bQ82IP1aeg4+HCDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=MKPdIWnw; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="MKPdIWnw"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a7ac469e4c4so124063466b.0
        for <kvmarm@lists.linux.dev>; Wed, 31 Jul 2024 01:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1722413496; x=1723018296; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1i19l7d1eZbhVp7fQ4bZoRAfF6lLDsSZcH8bPmRvWiA=;
        b=MKPdIWnwaI/BbtF1zT2mFH23/wge3S+ZXdu/6SEZuXz94eYJVdKYrnTXYdv9sEvOQb
         lS5K4OiGVc6eJvnNCWuzkxxBC1UixPlC+uR8jys8u2rHRdyjk9eAYDIsgArTYFtKdjt6
         MHpm6nmOVbDUPZ6BhsdF4j7gvXfN4gb0nmLeKTbsdfulie5YBAab8lWe2wZ6tbc2XJIR
         P/VEQeSB+i2dpvMio0m0ykqxHyNM1XLnuhPcLqZwNgH5jNjjHzO/RVQlkzQ8AeIJLW+P
         jm4JOCezZriRcFCRGGyds4DrL4wvDyn6YQ4AEyJ57GFrBJw/2L2/32+/bVv/LBkOa0W2
         VnsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722413496; x=1723018296;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1i19l7d1eZbhVp7fQ4bZoRAfF6lLDsSZcH8bPmRvWiA=;
        b=mZsRIL2a8fVmtdEh302KV0x+vzas0s84J8mQT9jdoPjHgsjd5PvpUlQwcn45HRWHJv
         3D6AmF9La9DYLf4GnxlC6YmpSf2R0ISV3XB1yHDilnLsKFauw0AcKu0NOHyCV6YKQf+3
         gdPiKqB3CCm8SFxD5PLwRCV9flLwtpJZejS0pp/BilbpFWkotdR/l8QdMBzHDzdsnehT
         LgOygvSXZU0yCg5IDRdNmTKMdP4whcZeASZBwd/bs2Md8nEx5N4QLTG5H5L5dYmOIloc
         iG5k4m8K0k4UKSepE4cXcz6MHKfGEjNhs+u3iUuwfnahUzIGe79Ya1LRLxaEcMI/HYCU
         89QA==
X-Forwarded-Encrypted: i=1; AJvYcCUhLjFsYNnLgvurXKSstfj22aE8LcDl99ERt8wEznlwcPACd7hiJgAxYmFtaVUI0zk09Ag5/LnWindo1vAFHjlipxHabOfr
X-Gm-Message-State: AOJu0Yz5mbNrqZfgSP/woub8yQGVdPM5zQP5lNHQeq8xBxaqTdhfLll6
	t3m+cKEcOqwr/hua0lhvMMXSZXTSgu2Aj7Pv+fapakAvX+KbwheZzKnp87aGfaZ0NRZmJqW9A6C
	+l5Y=
X-Google-Smtp-Source: AGHT+IEAM3rgFV5Nss1oeOJc4d0T/p6GjpLY5HpQ/UfV3bepvtCwNBml7jly3uQHrfiUKxZe0LrJkQ==
X-Received: by 2002:a17:907:60cb:b0:a7d:88c4:2897 with SMTP id a640c23a62f3a-a7d88c437b8mr269366466b.2.1722413495475;
        Wed, 31 Jul 2024 01:11:35 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7acadb8361sm734690366b.207.2024.07.31.01.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jul 2024 01:11:35 -0700 (PDT)
Date: Wed, 31 Jul 2024 10:11:34 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v12 56/84] KVM: RISC-V: Mark "struct page" pfns dirty iff
 a stage-2 PTE is installed
Message-ID: <20240731-0456655970f6ae99f907de43@orel>
References: <20240726235234.228822-1-seanjc@google.com>
 <20240726235234.228822-57-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240726235234.228822-57-seanjc@google.com>

On Fri, Jul 26, 2024 at 04:52:05PM GMT, Sean Christopherson wrote:
> Don't mark pages dirty if KVM bails from the page fault handler without
> installing a stage-2 mapping, i.e. if the page is guaranteed to not be
> written by the guest.
> 
> In addition to being a (very) minor fix, this paves the way for converting
> RISC-V to use kvm_release_faultin_page().
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/riscv/kvm/mmu.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index b63650f9b966..06aa5a0d056d 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -669,7 +669,6 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>  		goto out_unlock;
>  
>  	if (writable) {
> -		kvm_set_pfn_dirty(hfn);
>  		mark_page_dirty(kvm, gfn);
>  		ret = gstage_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
>  				      vma_pagesize, false, true);
> @@ -682,6 +681,9 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>  		kvm_err("Failed to map in G-stage\n");
>  
>  out_unlock:
> +	if ((!ret || ret == -EEXIST) && writable)
> +		kvm_set_pfn_dirty(hfn);
> +
>  	spin_unlock(&kvm->mmu_lock);
>  	kvm_set_pfn_accessed(hfn);
>  	kvm_release_pfn_clean(hfn);
> -- 
> 2.46.0.rc1.232.g9752f9e123-goog
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

