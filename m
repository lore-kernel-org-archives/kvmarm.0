Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB6116DC12
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 09:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734427592; cv=none; b=bUM0IJa8nYPuD5ahMbSoSzvGSFniuftDnzUk2QuU4YKAe4CDfUcCKTrLc78xSyUsO6BgRw2qYnv4gxRiLnEgIwIu+44KjSa8xqBOwqyqhvi3QAlBZJ99eQ0/QTfz8MUj96RZ546FM8qtA92CgcZPwxLEGhoVoVbdWqvMNVFMVG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734427592; c=relaxed/simple;
	bh=MkCvDfZY2gI+DvSvK0wAZtFbE6IQgsCVp2l2r8TiB8c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HmgSBSWyNwHXy0d7Xo3AjXhuhVK2dwZ64jKm4kEP1a95LSO9ey3IbWRNWQlzzVoEbiwO4kbTESL6343VTe6s7CdZtD6cnwMPjnu0Q9MMNiNnNNBVbEbTtWQYl6oB9FVojK5Izk5Oe+UgrjpvBb8wVGyWzfIXE9qCZFysh9BMZgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=11qS8Exp; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="11qS8Exp"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43622893c3cso28705e9.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 01:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734427589; x=1735032389; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=q8ZMjen1yJSy70yGnNt9th+OC1qo4iE/tlrHQsp3QRY=;
        b=11qS8Expw4QAe4vwjxDmM6NSlrb0qfnJ+x2xIGfBS006iUYiY/BlZgJDS50ednyuZx
         sqbLgqFhIlKAbRthe3fUsZO0VTIRA0m56czI51BHDpNoJVYRMKLl6TvXhssNY2G9mSYW
         4XG2RMxYfU7WaWkOq3nneW1DJVWQlniSRg3KtfoziVjHZPZ6H8/HLXT9RIuaPjMHIUCR
         CviNJDh7QfsMLzOZDiw22b3xamgyj5CjILujPk8DycNMJpW4teNpdF2TPfHRzAlPDOa7
         3PBAadGrhRViUceLdT0CMAlTxjtKZd2C4/ye7lX6FGMC5cItazJfIB0Cq/rs/W3q2/+z
         UJBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734427589; x=1735032389;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q8ZMjen1yJSy70yGnNt9th+OC1qo4iE/tlrHQsp3QRY=;
        b=ah9aFeI4rgUHtzhN9HZPfbVzbx3mvfYw8kSHTdrE9gPNWrwtG4KKq4NQSzBorPVJVr
         wO8f4gdRn454xTnjgQrm0LwWmuLyQqgiY6tAEkx/k2GwvzSVmVfkLiEl09hUOWbjqP4c
         NbLOnU/A+drOzWQ6fWV/xtGwcaRFBxhaFAkENMNPqTu0G5qPLkqX/LsrORbyISSSi/EM
         HdZBCusyIVqDL4jG1Ux5nOnmNHJ2OZ+AW1hWzWoInlXQseJe2HCLkHppa92WrhFn5Rfh
         S2qGTa8wAs9TSHx83GY7fqSCPf8sXMvw3gMufDH9G1UB/15bFIDlNVnWQUaWTVkJcxbO
         4pZA==
X-Forwarded-Encrypted: i=1; AJvYcCUvWenuW+n7nHh7M9Lv7IYnkV8xs+/AVH91hAMf0jb6eVArYEELa1jIpZtJqrKJezDFlbNvCoc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwFx5P388U1LsRcWOtJrVS5lLYGYvrPZamBySU6ZVaVvUu0sYHO
	j9gdIc5q90ZycsEKBy5gDYKeuG9WuJKgRo8CvA+015lI/foePj7zYJoZzy/T/4VWiPRuKOy7Ni4
	0fQJ4ub6vUi4Y0O1O3LDopX12HzZSPUmxJowl
X-Gm-Gg: ASbGnctDRBEbbd18UG6RoVlV9fErIplAsm6PiTXbSpUyE4DJCymIPlkakibwZjrDnDC
	vzJ0NMLDZtjXPIG3rqa/NaKh5UoEi5cL3NGPhUtFNipC5s41Am4s2IhgnKj/QZjVyRAk=
X-Google-Smtp-Source: AGHT+IFF7byMDFVKlnmrBQvmNiNhFFA27+GN/MTPR1DNEbChmzax4aYAFvAEK6reIllga6gOu5vl+393+8r9UxeqysA=
X-Received: by 2002:a05:600c:3205:b0:436:4e4c:7bae with SMTP id
 5b1f17b1804b1-4364e4c7d7cmr388185e9.1.1734427589053; Tue, 17 Dec 2024
 01:26:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com>
In-Reply-To: <20241216175803.2716565-1-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Dec 2024 09:25:52 +0000
Message-ID: <CA+EHjTz7=dRz5X-CjjniJgwd87Q4DQbRdXzi0on4C21urYnhOQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/18] KVM: arm64: Non-protected guest stage-2 support
 for pKVM
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Dec 2024 at 17:58, Quentin Perret <qperret@google.com> wrote:
>
> Hi all,
>
> This is the v3 of the series adding support for non-protected guests
> stage-2 to pKVM. Please refer to v1 for all the context:

For the series:

Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



>
>   https://lore.kernel.org/kvmarm/20241104133204.85208-1-qperret@google.com/
>
> The series is organized as follows:
>
>  - Patches 01 to 04 move the host ownership state tracking from the
>    host's stage-2 page-table to the hypervisor's vmemmap. This avoids
>    fragmenting the host stage-2 for shared pages, which is only needed
>    to store an annotation in the SW bits of the corresponding PTE. All
>    pages mapped into non-protected guests are shared from pKVM's PoV,
>    so the cost of stage-2 fragmentation will increase massively as we
>    start tracking that at EL2. Note that these patches also help with
>    the existing sharing for e.g. FF-A, so they could possibly be merged
>    separately from the rest of the series.
>
>  - Patches 05 to 07 implement a minor refactoring of the pgtable code to
>    ease the integration of the pKVM MMU later on.
>
>  - Patches 08 to 16 introduce all the infrastructure needed on the pKVM
>    side for handling guest stage-2 page-tables at EL2.
>
>  - Patches 17 and 18 plumb the newly introduced pKVM support into
>    KVM/arm64.
>
> Patches based on 6.13-rc3, tested on Pixel 6 and Qemu.
>
> Changes in v3:
>  - Rebased on 6.13-rc3
>  - Applied Marc's rework of the for_each_mapping_in_range() macro mess
>  - Removed mappings_lock in favor the mmu_lock
>  - Dropped BUG_ON() from pkvm_mkstate()
>  - Renamed range_is_allowed_memory() and clarified the comment inside it
>  - Explicitly bail out when using host_stage2_set_owner_locked() on
>    non-memory regions
>  - Check PKVM_NOPAGE state as an equality rather than a bitwise
>    operator
>  - Reworked __pkvm_host_share_guest() to return -EPERM in case of
>    illegal multi-sharing
>  - Added get_np_pkvm_hyp_vm() to simplify HVC error handling in
>    hyp-main.c
>  - Cosmetic changes and improved coding consitency thoughout the series
>
> Changes in v2:
>  - Rebased on 6.13-rc1 (small conflicts with 2362506f7cff ("KVM: arm64:
>    Don't mark "struct page" accessed when making SPTE young") in
>    particular)
>  - Fixed kerneldoc breakage for __unmap_stage2_range()
>  - Fixed pkvm_pgtable_test_clear_young() to use correct HVC
>  - Folded guest_get_valid_pte() into __check_host_unshare_guest() for
>    clarity
>
> Thanks,
> Quentin
>
> Marc Zyngier (1):
>   KVM: arm64: Introduce __pkvm_vcpu_{load,put}()
>
> Quentin Perret (17):
>   KVM: arm64: Change the layout of enum pkvm_page_state
>   KVM: arm64: Move enum pkvm_page_state to memory.h
>   KVM: arm64: Make hyp_page::order a u8
>   KVM: arm64: Move host page ownership tracking to the hyp vmemmap
>   KVM: arm64: Pass walk flags to kvm_pgtable_stage2_mkyoung
>   KVM: arm64: Pass walk flags to kvm_pgtable_stage2_relax_perms
>   KVM: arm64: Make kvm_pgtable_stage2_init() a static inline function
>   KVM: arm64: Add {get,put}_pkvm_hyp_vm() helpers
>   KVM: arm64: Introduce __pkvm_host_share_guest()
>   KVM: arm64: Introduce __pkvm_host_unshare_guest()
>   KVM: arm64: Introduce __pkvm_host_relax_guest_perms()
>   KVM: arm64: Introduce __pkvm_host_wrprotect_guest()
>   KVM: arm64: Introduce __pkvm_host_test_clear_young_guest()
>   KVM: arm64: Introduce __pkvm_host_mkyoung_guest()
>   KVM: arm64: Introduce __pkvm_tlb_flush_vmid()
>   KVM: arm64: Introduce the EL1 pKVM MMU
>   KVM: arm64: Plumb the pKVM MMU in KVM
>
>  arch/arm64/include/asm/kvm_asm.h              |   9 +
>  arch/arm64/include/asm/kvm_host.h             |   4 +
>  arch/arm64/include/asm/kvm_mmu.h              |  16 +
>  arch/arm64/include/asm/kvm_pgtable.h          |  38 ++-
>  arch/arm64/include/asm/kvm_pkvm.h             |  23 ++
>  arch/arm64/kvm/arm.c                          |  23 +-
>  arch/arm64/kvm/hyp/include/nvhe/gfp.h         |   6 +-
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  38 +--
>  arch/arm64/kvm/hyp/include/nvhe/memory.h      |  42 ++-
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  16 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 201 ++++++++++-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 320 ++++++++++++++++--
>  arch/arm64/kvm/hyp/nvhe/page_alloc.c          |  14 +-
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                |  68 ++++
>  arch/arm64/kvm/hyp/nvhe/setup.c               |   7 +-
>  arch/arm64/kvm/hyp/pgtable.c                  |  13 +-
>  arch/arm64/kvm/mmu.c                          | 113 +++++--
>  arch/arm64/kvm/pkvm.c                         | 198 +++++++++++
>  arch/arm64/kvm/vgic/vgic-v3.c                 |   6 +-
>  19 files changed, 1010 insertions(+), 145 deletions(-)
>
> --
> 2.47.1.613.gc27f4b7a9f-goog
>
