Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463F0219A89
	for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 08:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756284246; cv=none; b=MqCvNlpJkn2hM0HDqyTjWbJkf7ZTjO78d2AHSuocsMdZxvWPvxdJWELKTLarB8nTcpsQxy2AKtjTB4wp8Qa2b2XGMVb58BZP5xu8sSTY7SgriWME1dX5gInERoUa26BOfDDmk3i89U+qUq+MnmnL+mlPKwOCFp3TvajjK+vg+RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756284246; c=relaxed/simple;
	bh=0xUyTZo1Vxu2SKNX0OEGiXGPuNc8xSp3W99eSmBS3ZI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CMKJ60iNDP+n6csaS+o1Bmf63sv2ZzcLRlwSgu7KJj+if2FaZyApJ7Px/G1H26wcq0iF+sN6N8ADUeXAZkFkWnrFZKyGehRRkMY5diwCF8nZsZ+y3Ja3lUXW+PYWLJiEOAouSXBd+8J5QMuVLtFPcFNHG7FhPJ8+LipFsXhL9ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W8me0m6c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W8me0m6c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756284242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IZGxaNmOeSdGHHP71FOt2lqKswNba8+C9FVEuuymca4=;
	b=W8me0m6ciSv6oe5Z2EfW5YZkBbtjJBO6qM1GuK50sf14IIvQcPJTjRniZ44JKX5njnmOrb
	1/XvzeH8OlnhZBEp40NvVtvKdKWKpNSkcYkJe0jlvWubVdKGqoJEbf4DF/bQ8eSICq0FaI
	1MJhqLhzDYjeRUKZTGaSqwnv+u4KfZk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459--AnuIUtfMHCa2iT1g8hrxA-1; Wed, 27 Aug 2025 04:44:00 -0400
X-MC-Unique: -AnuIUtfMHCa2iT1g8hrxA-1
X-Mimecast-MFC-AGG-ID: -AnuIUtfMHCa2iT1g8hrxA_1756284239
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0ccb6cso32324605e9.3
        for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 01:44:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756284239; x=1756889039;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IZGxaNmOeSdGHHP71FOt2lqKswNba8+C9FVEuuymca4=;
        b=PjEwDMbuSxHG2LhAQLCX39p6f8zgDjM3z073I5pH7Kdbm6/H4O9BDDUbjqr4nXFMp1
         lRWQIdRb5Y2mJ2FeHWuvIa+cBm8c4OGExdzduLrD5+PgTQ3LM9U1zYdTSzMrrEouCZCY
         0OehPUxd21tSR4z51lIKbAzQxUz52vZ6RKkLZqp/bLYDiC/29UdX7UveSWH/gt/6hcLI
         ia5JL6wTJjr5LNb4YBLDovUsV0SMgXr3RY3yM/n6U5oWx6H4udHqEfOnZmvS6vLX7l5D
         j/V4MTpFutnS9B0rWfWmj1iXRB+oTR8SOkDs8Ij5eS6J05ET46d3HlZRMjkkcJgcnLMb
         wmrA==
X-Forwarded-Encrypted: i=1; AJvYcCV3dCeOw6aAJybn+pV/A81ZP4XRBTKi/7D6JM9PjPzISzZb4nfJjkTZUMjPXOk1JUvQz6zhbpM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxq7h9OQltwGsCVRWFwwMcxYmHpod2cxt1IwGPtkBuv0jOYVg3t
	+4NPFyrNTbfj8Gn7cPM3CpYyT1NBT1jiB3U2F+Usx34ZlnTGEBvbYb1tPDfyLKrBEFAFLvLUNSU
	vAxl/bikubmzMoyut4ZwQBckRQnH2KJMdNb2fuQV4wkeQDg4nN2S9C0NPlg==
X-Gm-Gg: ASbGnctG7zoUATngVm+pc/HRLgKqrfGub90QXwHLX5kIz0cSHBb6/fzM2h7943K7YFl
	eVPSz5Gvhxlms40X5sU0NDZf9fLrOABos7K4QL2Bjs4IyFHjUzxBcl6GH3B0DGvaCws53cO7G86
	CNAh1l9mUYnzbJSmwIscQYw34fGmcZL/pHPYus201BxfbAwHQN8lQLr37QQ3UQltScG2d1+HAhC
	NN33GSMnqyb4OUgbpW9QJEiZK9mottwgUO1er5XUBZ6b0eWU5GgKJuGDY6swDOSIEfyb1soSLxH
	JNqCSyc7dI2WO6XyHy1OIpsUYvGJZBt3MKUtPtb/Lxp7aDdmNyImbQ8eEMFQ2n6cNYKyERWYsS9
	kTs9FfRKTnYmFixiGqfr8jonLIzh7qFbUBtSro4DCwVo=
X-Received: by 2002:a05:600c:4f02:b0:45b:6275:42cc with SMTP id 5b1f17b1804b1-45b6275481cmr64897935e9.28.1756284239391;
        Wed, 27 Aug 2025 01:43:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEHrI5MM5SoEnSBg3O8NCL4GssULf2lMxECXsDSF1mGPL8r1uAZx+y3W0mqCZFKDVyGDdh3nQ==
X-Received: by 2002:a05:600c:4f02:b0:45b:6275:42cc with SMTP id 5b1f17b1804b1-45b6275481cmr64897615e9.28.1756284238834;
        Wed, 27 Aug 2025 01:43:58 -0700 (PDT)
Received: from [10.163.96.123] ([151.95.56.250])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-45b6f0d78b4sm22013625e9.7.2025.08.27.01.43.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 01:43:57 -0700 (PDT)
Message-ID: <87b10d94-dca2-4ecb-a86f-b38c5c90e0cf@redhat.com>
Date: Wed, 27 Aug 2025 10:43:54 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 00/24] KVM: Enable mmap() for guest_memfd
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>,
 Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>,
 Xiaoyao Li <xiaoyao.li@intel.com>, David Hildenbrand <david@redhat.com>,
 Fuad Tabba <tabba@google.com>, Ackerley Tng <ackerleytng@google.com>,
 Tao Chan <chentao@kylinos.cn>, James Houghton <jthoughton@google.com>
References: <20250729225455.670324-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: a12qseJeX3nEtA1l2uxA5RqHUsaNXl1fYbZi5dxlUJI_1756284239
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/25 00:54, Sean Christopherson wrote:
> Paolo,
> 
> The arm64 patches have been Reviewed-by Marc, and AFAICT the x86 side of
> things is a go.  Barring a screwup on my end, this just needs your approval.
> 
> Assuming everything looks good, it'd be helpful to get this into kvm/next
> shortly after rc1.  The x86 Kconfig changes in particular create semantic
> conflicts with in-flight series.
> 
> 
> Add support for host userspace mapping of guest_memfd-backed memory for VM
> types that do NOT use support KVM_MEMORY_ATTRIBUTE_PRIVATE (which isn't
> precisely the same thing as CoCo VMs, since x86's SEV-MEM and SEV-ES have
> no way to detect private vs. shared).
> 
> mmap() support paves the way for several evolving KVM use cases:
> 
>   * Allows VMMs like Firecracker to run guests entirely backed by
>     guest_memfd [1]. This provides a unified memory management model for
>     both confidential and non-confidential guests, simplifying VMM design.
> 
>   * Enhanced Security via direct map removal: When combined with Patrick's
>     series for direct map removal [2], this provides additional hardening
>     against Spectre-like transient execution attacks by eliminating the
>     need for host kernel direct maps of guest memory.
> 
>   * Lays the groundwork for *restricted* mmap() support for guest_memfd-backed
>     memory on CoCo platforms [3] that permit in-place
>     sharing of guest memory with the host.
> 
> Based on kvm/queue.

Applied to kvm/next, thanks!

Paolo

> [1] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
> [2] https://lore.kernel.org/all/20250221160728.1584559-1-roypat@amazon.co.uk
> [3] https://lore.kernel.org/all/20250328153133.3504118-1-tabba@google.com
> 
> v17:
>   - Collect reviews. [Xiaoyao, David H.]
>   - Write a better changelog for the CONFIG_KVM_GENERIC_PRIVATE_MEM =>
>     CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE rename. [Xiaoyao]
>   - Correctly gmem_max_mapping_level()'s '0' return in the right patch. [Xiaoyao]
>   - Replace call to kvm_gmem_get_pfn() with a WARN_ONCE() in the hugepage
>     recovery path. [Ackerley]
>   - Add back "KVM: x86/mmu: Handle guest page faults for guest_memfd with
>     shared memory". [Ackerley]
>   - Rework the selftest flags testcase to query MMAP support for a given VM
>     type instead of hardcoding expectations in the test. [Sean]
>   - Add a testcase to verify KVM can map guest_memfd memory into the guest
>     even if the userspace address in the memslot isn't (properly) mmap'd. [Sean]
> 
> v16:
>   - https://lore.kernel.org/all/20250723104714.1674617-1-tabba@google.com
>   - Rework and simplify Kconfig selection and dependencies.
>   - Always enable guest_memfd for KVM x86 (64-bit) and arm64, which
>     simplifies the enablement checks.
>   - Based on kvm-x86/next: commit 33f843444e28 ("Merge branch 'vmx'").
> 
> v15:
>   - https://lore.kernel.org/all/20250717162731.446579-1-tabba@google.com
>   - Removed KVM_SW_PROTECTED_VM dependency on KVM_GENERIC_GMEM_POPULATE
>   - Fixed some commit messages
> 
> v14:
>   - https://lore.kernel.org/all/20250715093350.2584932-1-tabba@google.com
>   - Fixed handling of guest faults in case of invalidation in arm64
>   - Handle VNCR_EL2-triggered faults backed by guest_memfd (arm64 nested
>     virt)
>   - Applied suggestions from latest feedback
>   - Rebase on Linux 6.16-rc6
> 
> Ackerley Tng (2):
>    KVM: x86/mmu: Rename .private_max_mapping_level() to
>      .gmem_max_mapping_level()
>    KVM: x86/mmu: Handle guest page faults for guest_memfd with shared
>      memory
> 
> Fuad Tabba (15):
>    KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GUEST_MEMFD
>    KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
>      CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
>    KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
>    KVM: Fix comments that refer to slots_lock
>    KVM: Fix comment that refers to kvm uapi header path
>    KVM: x86: Enable KVM_GUEST_MEMFD for all 64-bit builds
>    KVM: guest_memfd: Add plumbing to host to map guest_memfd pages
>    KVM: guest_memfd: Track guest_memfd mmap support in memslot
>    KVM: arm64: Refactor user_mem_abort()
>    KVM: arm64: Handle guest_memfd-backed guest page faults
>    KVM: arm64: nv: Handle VNCR_EL2-triggered faults backed by guest_memfd
>    KVM: arm64: Enable support for guest_memfd backed memory
>    KVM: Allow and advertise support for host mmap() on guest_memfd files
>    KVM: selftests: Do not use hardcoded page sizes in guest_memfd test
>    KVM: selftests: guest_memfd mmap() test when mmap is supported
> 
> Sean Christopherson (7):
>    KVM: x86: Have all vendor neutral sub-configs depend on KVM_X86, not
>      just KVM
>    KVM: x86: Select KVM_GENERIC_PRIVATE_MEM directly from
>      KVM_SW_PROTECTED_VM
>    KVM: x86: Select TDX's KVM_GENERIC_xxx dependencies iff
>      CONFIG_KVM_INTEL_TDX=y
>    KVM: x86/mmu: Hoist guest_memfd max level/order helpers "up" in mmu.c
>    KVM: x86/mmu: Enforce guest_memfd's max order when recovering
>      hugepages
>    KVM: x86/mmu: Extend guest_memfd's max mapping level to shared
>      mappings
>    KVM: selftests: Add guest_memfd testcase to fault-in on !mmap()'d
>      memory
> 
>   Documentation/virt/kvm/api.rst                |   9 +
>   arch/arm64/kvm/Kconfig                        |   1 +
>   arch/arm64/kvm/mmu.c                          | 203 +++++++++++----
>   arch/arm64/kvm/nested.c                       |  41 ++-
>   arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
>   arch/x86/include/asm/kvm_host.h               |   6 +-
>   arch/x86/kvm/Kconfig                          |  26 +-
>   arch/x86/kvm/mmu/mmu.c                        | 142 ++++++-----
>   arch/x86/kvm/mmu/mmu_internal.h               |   2 +-
>   arch/x86/kvm/mmu/tdp_mmu.c                    |   2 +-
>   arch/x86/kvm/svm/sev.c                        |   6 +-
>   arch/x86/kvm/svm/svm.c                        |   2 +-
>   arch/x86/kvm/svm/svm.h                        |   4 +-
>   arch/x86/kvm/vmx/main.c                       |   7 +-
>   arch/x86/kvm/vmx/tdx.c                        |   5 +-
>   arch/x86/kvm/vmx/x86_ops.h                    |   2 +-
>   arch/x86/kvm/x86.c                            |  11 +
>   include/linux/kvm_host.h                      |  38 +--
>   include/uapi/linux/kvm.h                      |   2 +
>   tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>   .../testing/selftests/kvm/guest_memfd_test.c  | 236 ++++++++++++++++--
>   virt/kvm/Kconfig                              |  15 +-
>   virt/kvm/Makefile.kvm                         |   2 +-
>   virt/kvm/guest_memfd.c                        |  81 +++++-
>   virt/kvm/kvm_main.c                           |  12 +-
>   virt/kvm/kvm_mm.h                             |   4 +-
>   26 files changed, 648 insertions(+), 214 deletions(-)
> 
> 
> base-commit: beafd7ecf2255e8b62a42dc04f54843033db3d24

