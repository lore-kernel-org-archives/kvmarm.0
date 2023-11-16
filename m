Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA96E48796
	for <kvmarm@lists.linux.dev>; Thu, 16 Nov 2023 21:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vEbuygiY"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-da0737dcb26so1735806276.3
        for <kvmarm@lists.linux.dev>; Thu, 16 Nov 2023 13:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700168424; x=1700773224; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pcg1jHOi88FLN7hCqkcZwcR8zkGGhGMDTBufXRqyOok=;
        b=vEbuygiYrc9xFnNCy/Xp3lYKMJ5/z1yHoPng1uF2OmkSBMR5mpwj1jLjxg7sEPVfEN
         kN6EtZ5BuA7iRar51pCmk11Y1aRh85Fc6trYhHNp1pVCMwWgRJOHga819M/F6W04WEbY
         H0Kr6/YMvEsHhnlV/w7wLZX763GITvbOqwdwm+nlE1kRQsyo4/piUXRkn62AoogZAp+9
         0IIzyJxYW2NAOvS9k37IepcvXJSDk0rKxvKf2s49I8413eurMj1AIKa9m+3UIBbhvhgv
         cEQOINl9XfTtE1MDGaZ8m6I5DakKyrGaQ6KGif7K9sC5Bki0bXavrjMZg3gNRGnT/O4Z
         WqeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700168424; x=1700773224;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pcg1jHOi88FLN7hCqkcZwcR8zkGGhGMDTBufXRqyOok=;
        b=BahQxvLrfgRZPz23jD0Kwj2wEdBTNKaksGIx8NX+VwrOkPfBY95TfRzBIASIIlY93p
         6e93/SID86HfyoXKwtS4CtlM42gVm8EuBoRE7wj/kmiM/+hSKWw2qLu3dTFG3ixNX9SM
         oQA1VhEldUY8NGVv/p7kEEU9dC5GXB1Gs2oZgLdUhkkpfJPc2ahZ0ZgkkytkejmwfLCj
         vVO999LrB6ERmbi+znbHF4fp/yPragCZib4b0q2NUKgq3cb9T8q7hMxmwDNmL6fdXgc2
         ocXXV8oGbaMp65rNyf+yn5JngFdOCX5+iQDcvg7oTOgT41mO7OJJym0zA3BE05KZ6BMn
         07kQ==
X-Gm-Message-State: AOJu0YxQbLvHN05pvKwK67uw2RAbrfOayp6GeyrSdhqL06yqxDLcmUz1
	f/qYRlSFkUprLaWNdHLnuyyzc2TUVXT/mfJafA==
X-Google-Smtp-Source: AGHT+IERExc4D+qrt27go/xYBPrtoAORZdvfQFtSO07pMqMqSuTLQB8wBOPMZT1riqPUGW5/Jxx9EA2kvlBTv30QyA==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a25:7644:0:b0:da3:a4ae:1525 with SMTP
 id r65-20020a257644000000b00da3a4ae1525mr393167ybc.5.1700168424573; Thu, 16
 Nov 2023 13:00:24 -0800 (PST)
Date: Thu, 16 Nov 2023 21:00:22 +0000
In-Reply-To: <20231105163040.14904-33-pbonzini@redhat.com> (message from Paolo
 Bonzini on Sun,  5 Nov 2023 17:30:35 +0100)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <diqzfs15o1ll.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH 32/34] KVM: selftests: Add basic selftest for guest_memfd()
From: Ackerley Tng <ackerleytng@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, tabba@google.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	qperret@google.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com
Content-Type: text/plain; charset="UTF-8"

Paolo Bonzini <pbonzini@redhat.com> writes:

> <snip>
>
> +static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
> +{
> +	size_t page_size = getpagesize();
> +	uint64_t flag;
> +	size_t size;
> +	int fd;
> +
> +	for (size = 1; size < page_size; size++) {
> +		fd = __vm_create_guest_memfd(vm, size, 0);
> +		TEST_ASSERT(fd == -1 && errno == EINVAL,
> +			    "guest_memfd() with non-page-aligned page size '0x%lx' should fail with EINVAL",
> +			    size);
> +	}
> +
> +	for (flag = 1; flag; flag <<= 1) {

Since transparent hugepage support is no longer officially part of this
series, 

> +		uint64_t bit;

this declaration of bit can be removed.

> +
> +		fd = __vm_create_guest_memfd(vm, page_size, flag);
> +		TEST_ASSERT(fd == -1 && errno == EINVAL,
> +			    "guest_memfd() with flag '0x%lx' should fail with EINVAL",
> +			    flag);
> +

This loop can also be removed,

> +		for_each_set_bit(bit, &valid_flags, 64) {
> +			fd = __vm_create_guest_memfd(vm, page_size, flag | BIT_ULL(bit));
> +			TEST_ASSERT(fd == -1 && errno == EINVAL,
> +				    "guest_memfd() with flags '0x%llx' should fail with EINVAL",
> +				    flag | BIT_ULL(bit));
> +		}

otherwise this won't compile because valid_flags is not declared.

These lines will have to be added back when adding transparent hugepage
support.

> +	}
> +}

Tested-by: Ackerley Tng <ackerleytng@google.com>
