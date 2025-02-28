Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2701230BDA
	for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 19:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740771895; cv=none; b=oT0snxY5NbAwAr9Ag2xEFV29xHcsX+EMjOpcwOEQMfz8XcSCQWtHL7gfJjDlgKK0QI0/u7x/KjjZ/FhXr2AS7VCSVFnRSlyk+mDYMArYQabJdBC10tVHiehsrlLMPbfsPbyAiKcQ0p/2yR4o14eYX7CP+dANEhHflwsuiWpLCjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740771895; c=relaxed/simple;
	bh=u9IIQkzUQEGboqOAA4jL0YNDhIcYZQ2UdKipOy/Sj3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QEYXPztVdKSkJx0q5y0sty3OdQTKtw9dy0fhB6kewGWUU2Ai6V0E6yYSroenwuTjyHocnJ6Z0hNcvHR+eEEms69Ks3NATxqYWIbuhKwRxXwbpSmVmw9yjYtWP/eXRW+dHWxfIlmy+9EqUWR4jm+8Jlwwd5pJg+FNHQn1/QwHsTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tq5hAZn3; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tq5hAZn3"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-abbda4349e9so348564466b.0
        for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 11:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740771892; x=1741376692; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GrxfhSQDPSEzY9FwMiMP3kLRUycgWmI45Gcv8VcIec8=;
        b=tq5hAZn3lcDXC8/jhcf2Psiur1lk5MtNrwwYXDicqHwN5O34QNAyj6YUCNNEP/nEb9
         aAvpQaTRs35OeveGcB09gEpbCQha47Wqsm8JSlpiGKjgHm85j5MNS0GzIrA7tXL+2SUx
         OrQaSRFR6H8zhm/U9ssd5DzkufCy30ujqsejvSeY0UIEY0zySEGENDrrpT6SLALFFtNn
         D34QEFiEn5stFszYenVV3A4XL4q6DDdXr4TX5xOnjtJunYI0BOHVLJAHIqmLkeFpes5K
         JqMIJGQCRwZVfM45DyJY6lGHYBHBbhNS8O0vMSkSBybdYiYgAO4R7hQrriw+l5VL97fQ
         UScw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740771892; x=1741376692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GrxfhSQDPSEzY9FwMiMP3kLRUycgWmI45Gcv8VcIec8=;
        b=vxAnfac8JwkfyKdSGu4E0DinTmHga+me2wC6M4pJV5wnRtwbXAQWqSevf1ExJr+b7t
         L4M+QDWznUv+q1bKo28mmoODSFtQ5nrFnnW1wY2UvthU7W4oRubO3tudvsmBITAoHkJ+
         jr6aQyC1DUHmIKa2gj/FDGZo2nyWbam67v6LmS1lkFONvPlsUgsTfQjhi5THs84p3Bwu
         3RK3exRvs96CiknxI7yqrNYzxUjE5O197NuuME7B6WTMseArZUDJmWu81GXowlFjdA6I
         dtFqtg8z56Tg754BY5Dh8h+K1WJqDNoqbIT7pfc9eXk3B1c9u/qP1jJjuJ9Qc3OecDp7
         Dw1A==
X-Gm-Message-State: AOJu0Ywu5p7KN4qT5/2bJ4fOjOPHfeZ87Si8kCYjPS6lPjaNUqvcIBka
	tQUvj7fdKH47r9zel/qfXiAzr23FFS7EHUtvmYibgh3yFEpg/+F+xYTzwB4tkQ==
X-Gm-Gg: ASbGncvnyE7WxMB80/MTwdWx391LppAxBJbTEOugD446GlnFHo1jSkR/riU/jEt7s+v
	A2uk+P+bYRv0BtyrLFRCkFlT41HbDwc/Ha+u05GnYvjXn/1e6p1v1tz2Wygi11/EEa6GT5vaTGK
	3L8vrTMNZnuK5OZpxjX/F3fGCwCUMA3C1s4OHjuH4zOWG7OCyRighMoBZy9p1teJhqWJYzStkwD
	800vE0x5DkrZe9Qn4LpBw7EQbpBL/Mj7enxc0LpbBNdwWNOIicxnmQzpTPbMP9jpqqrJZYXnsC9
	APO2LdFGaKbWocrhk51Eq9GkBTud2g2gC8J2niB2LmgmLuTJIUUnu1c5kkSDZzk=
X-Google-Smtp-Source: AGHT+IHTdYieiZ2Aj4ze6pa8HY7tXwIhYVqJDu+daMOyke7B6a6VZw8tHVhi3y8YmBfQzTjNAAk15w==
X-Received: by 2002:a17:907:9484:b0:abb:b136:a402 with SMTP id a640c23a62f3a-abf26424829mr475325566b.18.1740771891977;
        Fri, 28 Feb 2025 11:44:51 -0800 (PST)
Received: from google.com (229.112.91.34.bc.googleusercontent.com. [34.91.112.229])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c7c18a3sm335218866b.185.2025.02.28.11.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 11:44:51 -0800 (PST)
Date: Fri, 28 Feb 2025 19:44:47 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, mark.rutland@arm.com,
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org,
	vdonnefort@google.com
Subject: Re: [PATCH v2 3/4] KVM: arm64: Factor out pKVM hyp vcpu creation to
 separate function
Message-ID: <Z8ISLxQRcsx2uuHw@google.com>
References: <20250226215520.1759218-1-tabba@google.com>
 <20250226215520.1759218-4-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226215520.1759218-4-tabba@google.com>

On Wednesday 26 Feb 2025 at 21:55:19 (+0000), Fuad Tabba wrote:
>  static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
>  {
> -	size_t pgd_sz, hyp_vm_sz, hyp_vcpu_sz;
> +	size_t pgd_sz, hyp_vm_sz;
>  	struct kvm_vcpu *host_vcpu;
> -	pkvm_handle_t handle;
>  	void *pgd, *hyp_vm;
>  	unsigned long idx;
>  	int ret;
> @@ -161,33 +178,12 @@ static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
>  	if (ret < 0)
>  		goto free_vm;
>  
> -	handle = ret;
> +	WRITE_ONCE(host_kvm->arch.pkvm.handle, ret);

What's the reason to make this a WRITE_ONCE? Does it mean we should
update the readers to be READ_ONCE()?

> -	host_kvm->arch.pkvm.handle = handle;
> -
> -	/* Donate memory for the vcpus at hyp and initialize it. */
> -	hyp_vcpu_sz = PAGE_ALIGN(PKVM_HYP_VCPU_SIZE);
>  	kvm_for_each_vcpu(idx, host_vcpu, host_kvm) {
> -		void *hyp_vcpu;
> -
> -		/* Indexing of the vcpus to be sequential starting at 0. */
> -		if (WARN_ON(host_vcpu->vcpu_idx != idx)) {
> -			ret = -EINVAL;
> -			goto destroy_vm;
> -		}
> -
> -		hyp_vcpu = alloc_pages_exact(hyp_vcpu_sz, GFP_KERNEL_ACCOUNT);
> -		if (!hyp_vcpu) {
> -			ret = -ENOMEM;
> -			goto destroy_vm;
> -		}
> -
> -		ret = kvm_call_hyp_nvhe(__pkvm_init_vcpu, handle, host_vcpu,
> -					hyp_vcpu);
> -		if (ret) {
> -			free_pages_exact(hyp_vcpu, hyp_vcpu_sz);
> +		ret = __pkvm_create_hyp_vcpu(host_vcpu);
> +		if (ret)
>  			goto destroy_vm;
> -		}
>  	}
>  
>  	return 0;
> -- 
> 2.48.1.711.g2feabab25a-goog
> 
