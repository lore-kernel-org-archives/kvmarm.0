Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE74247143C
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 11:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789039532; cv=none; b=V+CG+t3ON/Iso5bH4Rhqh86HPxKq3JP9y/hVfJXHfT6eLej3qEkSjPdhUTDcs7N3NSbQqb0m9gKzC1c3OiTWPT7ihrqA3/FmVVOA+0eqbH3n6Da7VdJrhIze89lKDYIrJb3Wukf+xOm2eMmpFQMorvCVfmjzPA4g6xrK2W9tX9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789039532; c=relaxed/simple;
	bh=DzaaWZMUxb/8rJWyFS7HLbxklJPbE9+saYd1xLzHX/Q=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=t6qrxCUVivwvc00mgyMEz1Z22BcXhElOBF7C9ULs1nBt06fUTDJBkIs4uD+Sa+aXBXYBN/y03oANLCYb9ApF9zMVYt4hGJKbAfBqYdX178chb6LO5W5S8VVnTZAUniJ9GxbeZ84Nr9R7tuMftQKgv3mLhfGgCJfs3Brw3SvW2lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MG9EBu0t; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MG9EBu0t"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-4b28df1f600so5353317b6e.2
        for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 04:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789039529; x=1789644329; darn=lists.linux.dev;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=rKoYJ3dn9mRGunMRInGIver5jTSz1tQREqhFgol67GU=;
        b=MG9EBu0tatx/SYAcM7QvVppc9CR0ElykTp4fQ1+84MEzasDTmYl2psllBvJNDf/oDp
         SjzIhhgpW9hcrKnccQMoFwcl7ocZ3/nM0X+PMnbN7GAUH6Tr8kG7cpLaEJevKBOUFZCx
         dZDAjmL/0UJunHBFat7nFi0mbWmDsLXjMskTN9oEdMdWLtboTI2DVaN70WRw+29KBVul
         GCKv6D4R4MOiTjboIfxPdloFc8ETCO+SQM35enS7Kga6ULAFRsMT/JgOhWRw0tBxAwxS
         Qmw+sJe7WqNu/NPnsFqEVFY1uunpawsO4OqVxCLX1taJmigOA+W1pvpOWZ3PKM2mOu7v
         ulRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789039529; x=1789644329;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rKoYJ3dn9mRGunMRInGIver5jTSz1tQREqhFgol67GU=;
        b=gPjM740os9cERJGGj1+Gr0M3HOOs8cxmCOHQz/KZTYPs3xtqvv+xZ9+tfIZGc0D1KG
         8tB3qpDB+DIu5nmSPyzIcxPi1HQdBhrNTL13NK9H3vlBrBWNQXKfXwUJaaQVe7mMA28p
         EmnmAftWKT2nq6Bu56s161h019TNPtes8sxxOdXSfNx4NdafCQ+PGAoE86HPYpgJFOl7
         sfns1/zb1HjVgJUmNfBP3+6rb7o6GnZuKQ/7ueBt/Vr3ATVR/i8+Y1nMXyINERq3urWZ
         hG07o6iuaokwZ1mtgbFHWHcvuMH0mU+0OZEhADubUiGPAtxdnAGJcB7joCJTsIFw3QEj
         WEaw==
X-Forwarded-Encrypted: i=1; AKwUvBx6o96lE+3QyntLFAk0kkJ/Y7d6bgq7TKsWXtH0Drsxi+z3UbtxaEQZ526d6jVbWCqMSWLCTU8=@lists.linux.dev
X-Gm-Message-State: AFuF++nPJknYIfBNDTsFhGr4aJpGkG10fxlNkrmQ5wFoEgg/csXc1PqH
	K+JgrU0L0+YxENUcD0NXcZZEluPErjwADFGMAQwljKUfsftnFfxfLDcr
X-Gm-Gg: AYBFou1tfMzXUeOYRr1RgzvLiRv2SsjnFKj+X+GLhLORGm1w7KwbkwkC+fdQcAhv7zY
	nrj5rD1r3i95G+9EEMIkfJTZ+MegRYUlAmUz9JJtGAD41pJb9hcfc/hmDu1N4GPlw1+tS2XsEfr
	NbPOdfT+cZqUy9pV/AbzssF1gudyPK/hN0pW4DsdURF7jFGN3DXKqEJMm1HT+El7oWNDzZbP7TA
	XYrDIyVItezJqwEWDByE0rJUunJXwcyQBRk4UMJ6/DNuBZbJCSWzw4yX/tMZV9SZrqbYfBxE5iE
	7aeJDHMxhgmBXKx18473XLXd4ypVww3fUNuFEqQWVbbnQcAGqryFerXyyGrm/Tjl9j7Tlt36/kk
	wmMmKe3+YMBo+02UIcT1dGckHOFhLTsCzt33NQOOevFPlX6GOJmSQIfRlrFmCScAJCNoIDAZoqP
	v7wIVTUmXbL6FBWhcn836bw5P2vzcXWuMVElBDiE8S95ZUP2zk8w3M++3HNFOAmi76SjtWqS9qI
	kfv6Icjp1YQpN4zEWrKgLHqEnF6+i3qOd2xuLMSTGCaJEQ8jQm1JTc=
X-Received: by 2002:a05:6808:bca:b0:4b9:e6ab:d086 with SMTP id 5614622812f47-4b9e6abd362mr23531944b6e.38.1789039529448;
        Thu, 10 Sep 2026 04:25:29 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1435c2ae6b5sm6444309c88.1.2026.09.10.04.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 04:25:28 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Atish Patra <atish.patra@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 12/20] KVM: selftests: Add APIs to override memory region types with custom memslots
In-Reply-To: <20260902164123.2546762-13-seanjc@google.com>
Date: Thu, 10 Sep 2026 16:48:26 +0530
Message-ID: <5x0d1hj1.ritesh.list@gmail.com>
References: <20260902164123.2546762-1-seanjc@google.com> <20260902164123.2546762-13-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Sean Christopherson <seanjc@google.com> writes:

> Add and use APIs to override memory region types instead of open coding the
> logic in tests, partly to dedup test code, but mostly to add some amount of
> protection against conflicting overrides.  This will allow converting more
> tests to override memory regions without taking on too much risk of bugs in
> the long term, e.g. due to silently overriding a region multiple times.
>
> Deliberately "unroll" the loops in __vm_create() and the CMMA test's
> create_main_memslot() to avoid filling all memslots in anticipation of
> adding an "extra" memslot that is for test use and *only* test use, i.e.
> shouldn't be configured by core library code.
>
> Converting tests to overriding memory regions will allow taking the region
> type instead of the raw memslot in the physical page allocator APIs.
>

May I suggest few changes in the naming of these APIs:

static inline void vm_override_mem_region(struct kvm_vm *vm,
					      enum kvm_mem_region_type type,
					      u32 slot)
{
	TEST_ASSERT(vm->memslots[type] == KVM_INVALID_MEMSLOT,
		    "Memory region type '%u' was already overridden with slot=%u",
		    type, vm->memslots[type]);

	vm->memslots[type] = slot;
}

static inline void vm_override_add_mem_region_flags(struct kvm_vm *vm,
					    enum kvm_mem_region_type type,
					    enum vm_mem_backing_src_type src_type,
					    gpa_t gpa, u32 slot, u64 npages,
					    u32 flags)
{
	vm_override_mem_region(vm, type, slot);
	vm_userspace_mem_region_add(vm, src_type, gpa, slot, npages, flags);
}

static inline void vm_override_add_mem_region(struct kvm_vm *vm,
					  enum kvm_mem_region_type type,
					  enum vm_mem_backing_src_type src_type,
					  gpa_t gpa, u32 slot, u64 npages)
{
	vm_override_add_mem_region_flags(vm, type, src_type, gpa, slot, npages, 0);
}

Those "_add_" and "_flags" in the function names easily gives away
the difference in the APIs, rather than differentiating via "__".

However, logically the change looks good - so feel free to add:

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

