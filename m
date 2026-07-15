Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194F0353A7F
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784115081; cv=none; b=hsa8Xq23G8+zjRz7RpXxuHWSUfnqpJfIaXy8w3RYToe0AEyXuur82zmOvIfaqz+rlmcncXgOe1UQIAnGy0/eQ+LfADl9hUu24fKvP8lgpLIjK3NRpEAz2wYsuAHVOixPTqKZVm06b3Uc/3r55b+yqQeeEZ5u16+v1/tXpRUadI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784115081; c=relaxed/simple;
	bh=mYFt+p5c8uRMZe9Xo3qwxk50hzS/JwfoUzvNS7RCtJ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f/dfaceci+7rv8LCJCG+F4klDqGKDU9NURmF1Ozgj9b5QDKxf9plJu+HNBpEnOj5OhXeRRAVpvZ3lWdns3bjHNEW0cg16g7fVeFYqs03KBO8ioqN0PFCcU+5dkBjOJHWwcu8tqf6IllTSBvOUkipM0naoq71YJh/P33rbkExiZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FvusVPxR; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FvusVPxR"
X-Forwarded-Encrypted: i=1; AHgh+RrhYuDwmo0oCXWoppRl4vqbuBWNLsIWhfWVsnc4MsN53++gbq8ZkVyqQiYaLG0H9MTpLdr1+cc=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784115075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gxp3fXNq8XYNE/nkPh7KFYIhP3YHcDVUtPAtTd5Tryg=;
	b=FvusVPxRPvaZ7N/UegN2vx8ltoMrWsjq4lSS2/QkdnmpOfVut4Bn/E76feJ+s6+J2tZkZr
	uLLIvB2eIOYxaxnqOdXPINVWaaq4MfSQ12rx3YYPupGBCAQ6XMvBHuwOm/ni3zcyhn3OKU
	xKMdLxRjhfSZ9yDQo+biprfUq2o5/I8=
X-Gm-Message-State: AOJu0Yw9gqrLipz6NvraQ55Jt1lqK6rP38aGwxk+80lElU+eu/LNzQ/y
	CCllG53ZjeLV8OrRSLylNpJrA7lj1osLKKLOiUSSovqbAF98ScCaKY+7Ii29QN2Sd7+YWryD1r1
	eXen1WyjDCBdDqddK8gd9ofJ6oFxgxvoKWZvjDKfZ
X-Received: by 2002:a05:622a:4d:b0:51c:ba4f:9d19 with SMTP id
 d75a77b69052e-51d7bd752e0mr24873701cf.19.1784115061509; Wed, 15 Jul 2026
 04:31:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com> <20260706175415.2604046-13-vdonnefort@google.com>
In-Reply-To: <20260706175415.2604046-13-vdonnefort@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 15 Jul 2026 12:30:24 +0100
X-Gmail-Original-Message-ID: <CA+EHjTynPXq+h8z4U7kg6Vqh5+Jvi2dDY4w9eL_6YOW=yN=i-w@mail.gmail.com>
X-Gm-Features: AUfX_mxhMGLkpuT8Eh9JQ0ObVBlPYewUpp8cXDJp91EMiI7N1SswSQZWtF5PdKw
Message-ID: <CA+EHjTynPXq+h8z4U7kg6Vqh5+Jvi2dDY4w9eL_6YOW=yN=i-w@mail.gmail.com>
Subject: Re: [PATCH v2 12/18] KVM: arm64: Filter out non-kernel addresses in kern_hyp_va
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> kern_hyp_va() is idempotent for the hypervisor linear space. This is
> handy for nVHE hypervisor callers handling kvm_vcpu or kvm_arch
> pointers. Those pointers can originate from the hypervisor space (when
> protected mode is enabled, we don't trust the kernel and the hypervisor
> uses its own copy) or from the kernel space (we do trust the kernel in
> "non-protected" nVHE).
>
> This idempotence does not hold for addresses within the hypervisor
> private range, like the ones you get from the pKVM heap allocator
> (hyp_alloc()). To resolve this, filter out non-kernel addresses based on
> PAGE_OFFSET.
>
> Leave the assembly version untouched as it has no current users.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

>
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 6eae7e7e2a68..d60e5f2de10c 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -126,6 +126,9 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
>   * replace the instructions with `nop`s.
>   */
>  #ifndef __KVM_VHE_HYPERVISOR__
> +       if (!is_ttbr1_addr(v))
> +               return v;
> +
>         asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n"         /* mask with va_mask */
>                                     "ror %0, %0, #1\n"         /* rotate to the first tag bit */
>                                     "add %0, %0, #0\n"         /* insert the low 12 bits of the tag */
> --
> 2.55.0.rc2.803.g1fd1e6609c-goog
>
