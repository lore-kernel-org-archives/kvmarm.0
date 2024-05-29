Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513CB184132
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 21:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717019489; cv=none; b=Y1DYrhtZQ6bGO9mShn6KRR3/VJH+cplr3h2FJeYwiwxIM9UfDbRPiq6neEsT6GAMcY+hKeTEKNWZQ/OEy5jAJSj41rrna3NG1RPaTbvJtqP86vrIuRpDOjE9r7BeAanskVOGFfM4nFVbbYWn8H/KJhPaduXpoYxlrwY28w67bhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717019489; c=relaxed/simple;
	bh=lKMYQD65eNFrkDU5H9syEgOM26afIR7DCV4zcHP/8AQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HjXFnGbfMbsxEntkbdZ8FQPbKvNMnVqjLe6tLLlkVHr1+elxCYEbcX5ES6Il/zOnylJjewrNtoPujRecPcDWTqImcRA9ivdhX3VHK7GrkXcOiBVDSTHPUOIkoNbrw4IwO843zuzy0/04A470erFJM4/OZA2mGUUFTX13bWiB76c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cAlZ32mN; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cAlZ32mN"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-df52a2535d5so332129276.0
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 14:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717019486; x=1717624286; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HZEwQSuDxXsJBbCguZar5+VKzM/izfp4n/7bUq7QabM=;
        b=cAlZ32mNtYsph7YMfn8JJ/1Qv0ec95I43KJ9HndwAPhHDUAHfTHVDi7Y5EZgXfFTdU
         /Rsjar5ck60R6hxrZ+/qqinhUXFrkDvqMqjCmKOmx+43m/QeciBBiJs9fSbExopCH+A2
         xibI+OS7dOqTR/7d4XsjK9k8KvbTzxHIJL/wKV86A38Ojl/A2od2iw1PDxxtqzIeAk1Q
         K2IkLfy2oq8T6niQKfWKzbxw9FEFDHZANB7uK7HZ/dTe7l6C7Fkr00G3Q/9fch3rU7MW
         c4Kx1Jp3X8W3hDyNEdaxPDFhE/+Pvg8FGrcYuA5v4LUtz0Xo4xYeW+2Bo7ax01itiACB
         K4fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717019486; x=1717624286;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HZEwQSuDxXsJBbCguZar5+VKzM/izfp4n/7bUq7QabM=;
        b=jfqzqEYEgqf8Jtds5WXim/oAbjALNAzhjn0Q1rDT7OzxMDQ9LVuTbNitFop63l6ee0
         /uq2PhJ3Tjq4PEL+ECHPsoNYQ1ETo6HGG2fvL8MNhk8Yn5qtwAYNe00dmy0qi2hv+EGk
         Mb7evwCFnfl6p8n7J3I+T01+10MBDl23aMdSlcw6Kugd0YdJR/x+L6v4XYAEzGjVTHlM
         60BLfTNDfEPTw1TRWOqK9E/pfcP0LKcykDpdm1IVwmdgaZG1E/qI4mgqt1ifhvXFQg0h
         yhxBubegTykEMuyVY6mvbHsbPUhCVoliu4rj/OgrcofYaf4nAOl9voPoXRJ7+PrFCfLx
         v7hg==
X-Forwarded-Encrypted: i=1; AJvYcCXugZymUnbYte/dl3ULQIZ3033NDTool9eQlmoomQ9p0Y+uLADLmhtKELC777Uhjj+DOiFM9HGgqCd4oM1wri7cO12J2oTi
X-Gm-Message-State: AOJu0YytnNQ9cF06TtY3dI20WkrD+utxhzCilNXNkfJRdaXooDUc2jFI
	+QX2wQKHo4OvRAiMh1qFj2MXtuK7gtpshp7hNqR16r7mhZiOe1z8aBh3W0OhCzkxlQG9Ox/AEPH
	0Sg==
X-Google-Smtp-Source: AGHT+IGqNZ2BbD8cAo2AnWXa3Pi0tfvxVmoPgtWnywK5+NXQgcmpZ6RBn86fT+8nIYtd+ZPLip7+OZUjHdQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:188e:b0:df7:8889:4795 with SMTP id
 3f1490d57ef6-dfa5a407dc6mr54800276.0.1717019486318; Wed, 29 May 2024 14:51:26
 -0700 (PDT)
Date: Wed, 29 May 2024 14:51:24 -0700
In-Reply-To: <20240529180510.2295118-4-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240529180510.2295118-1-jthoughton@google.com> <20240529180510.2295118-4-jthoughton@google.com>
Message-ID: <ZlejXCYIuJ7_DlwL@google.com>
Subject: Re: [PATCH v4 3/7] KVM: Add lockless memslot walk to KVM
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Ankit Agrawal <ankita@nvidia.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Bibo Mao <maobibo@loongson.cn>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Huacai Chen <chenhuacai@kernel.org>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, May 29, 2024, James Houghton wrote:
> @@ -686,10 +694,12 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
>  	return __kvm_handle_hva_range(kvm, &range).ret;
>  }
>  
> -static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn,
> -							 unsigned long start,
> -							 unsigned long end,
> -							 gfn_handler_t handler)
> +static __always_inline int kvm_handle_hva_range_no_flush(
> +		struct mmu_notifier *mn,
> +		unsigned long start,
> +		unsigned long end,
> +		gfn_handler_t handler,
> +		bool lockless)

Unnecessary and unwanted style change.

>  {
>  	struct kvm *kvm = mmu_notifier_to_kvm(mn);
>  	const struct kvm_mmu_notifier_range range = {
> @@ -699,6 +709,7 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
>  		.on_lock	= (void *)kvm_null_fn,
>  		.flush_on_ret	= false,
>  		.may_block	= false,
> +		.lockless	= lockless,

Why add @lockess to kvm_handle_hva_range_no_flush()?  Both callers immediately
pass %false, and conceptually, locking is always optional for a "no flush" variant.

>  	};
>  
>  	return __kvm_handle_hva_range(kvm, &range).ret;
> @@ -889,7 +900,8 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
>  	 * cadence. If we find this inaccurate, we might come up with a
>  	 * more sophisticated heuristic later.
>  	 */
> -	return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn);
> +	return kvm_handle_hva_range_no_flush(mn, start, end,
> +					     kvm_age_gfn, false);
>  }
>  
>  static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
> @@ -899,7 +911,7 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
>  	trace_kvm_test_age_hva(address);
>  
>  	return kvm_handle_hva_range_no_flush(mn, address, address + 1,
> -					     kvm_test_age_gfn);
> +					     kvm_test_age_gfn, false);
>  }
>  
>  static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
> -- 
> 2.45.1.288.g0e0cd299f1-goog
> 
