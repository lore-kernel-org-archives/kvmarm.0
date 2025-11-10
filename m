Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B009921E098
	for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 15:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762789394; cv=none; b=D1h2d/tOUO4g3JfLgUekanjjR2vdgUfgy300gRo3GHRRkwP5CrvkU3ydKKzGyQetM+yr6o/xevFTD5oO8ZixgkbT3a2higOEWBZ5ugPkxuJL5QqAsGed0UQn4z62tO+4TNNNqzBGdXIfe8z3Oo0HrC4oT1kyL1ZEXYMeOApgK7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762789394; c=relaxed/simple;
	bh=Z6QBCawmA0V88I7dtIc6ikzQytNDqs3gMMcaJjnYR/s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NELnuwqPBi/WODUAIhKmfiCPmhhdZfFYRXiIgzslt3sZWkOQB5hr63cNOHvL+Atn0yyk/vYqlDDihE3l2KFpq1YX9oddzp8r1KAC2Uz/POIrq+yHVt7vDUFHmndJMG8sLOf94Pz8RTLfh3RrH+vG9JqQQX98c+OXtzoe0wMW6qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gf+BmCKf; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gf+BmCKf"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340bc4ef67fso3669419a91.3
        for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 07:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762789392; x=1763394192; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=87FfliXTeIYU4Ti4q0mlK1AlR2N3oXTPIRkcYWMY8TY=;
        b=Gf+BmCKfmAIBCtqgl8CWC2KVDJZAvbomroByBQC5cr1Zp/X763KCNZ2J/v8m1pMSC3
         x0VXBddqEzzRHGHEaCzZypmq5jIXJIBXZH56vextlwdj68mCm6VroxnLwrG1Ctdm/F5e
         rrl8OjolbddSAcA3KwEcWxGB6jQpcHgRFash3YAX7lkdBJJZ9Wj7xhhmXxl9a5eh+eop
         foiKf3XvvAFdVyMrxgHEDPamjl64lLHJGoo2i+5GPMam6WyG/SCqiVqrLnsxX9U+Zs6H
         5aYHTW7LC/HxGheUxKHQTxZboT19gwHwEl3vrDwxwm7FL+bb2iqcrur4upT4t3JXgkhG
         ltdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762789392; x=1763394192;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=87FfliXTeIYU4Ti4q0mlK1AlR2N3oXTPIRkcYWMY8TY=;
        b=UQg0jroOeBlfCr3MEbhFPt1s2+tCE+c4M1EM15yJmRTpyiGqJ7A+lOw9qQPjXrQULv
         cGdszt0GpcA9UzVRVLNv3tXhnop08Cyazsa1loW9A9OLnZZgtAPsuyM33IZhLxejdQzX
         +wLJ34ZVDjDADGbcg3ml4vSp992DDOIb/9o1FfRl+7HHIcxYAQnkI29v4s0eyOpJSJKj
         6RGLbcrFx48nKnwf+OpFuKvM/1IN7SOECnqbrQgH+7ICR5FNEZgAOl12xWWfC0fuTtXq
         +1j715DpHwghCxdClvdV/r/kW/OixVGd9U5X/XORf9cC0GLIi4LcAoFQuzVizn+NJN2I
         fZkA==
X-Forwarded-Encrypted: i=1; AJvYcCUidtmUEWPmGj2LCeP8GvswPrXu3f5ZjnDcEaXLUAI8LLGcrM1v3vPh7KZlh/+0BTEPUoiqpjU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1+1/jfHRqDkviKJw92DJvvkbgAsxDygOiB6p/UdXnGjHGpQ/o
	VU9tKvBNjfER3tSxBuNGbc+Y0tiS16tLZl+K2C2mVkvBQIMMc0xeLY1XFjTdJcBeMFR1GN6TnYw
	TiabAsA==
X-Google-Smtp-Source: AGHT+IGU2QqcHJOpKVyUh8wnC6DXg/rmfR5MmGRMoX3raYINDU0h+4Ytj4+FRCcbgxWr/CiKwQo1uRnxIsY=
X-Received: from pjbdw16.prod.google.com ([2002:a17:90b:950:b0:343:6849:31ae])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a10:b0:341:124f:474f
 with SMTP id 98e67ed59e1d1-3436cd0c3e9mr10428985a91.32.1762789392114; Mon, 10
 Nov 2025 07:43:12 -0800 (PST)
Date: Mon, 10 Nov 2025 07:37:29 -0800
In-Reply-To: <20251030200951.3402865-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <176278827443.918905.17609380057567446021.b4-ty@google.com>
Subject: Re: [PATCH v4 00/28] KVM: x86/mmu: TDX post-populate cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 30 Oct 2025 13:09:23 -0700, Sean Christopherson wrote:
> Non-x86 folks, as with v3, patches 1 and 2 are likely the only thing of
> interest here.  They make kvm_arch_vcpu_async_ioctl() mandatory and then
> rename it to kvm_arch_vcpu_unlocked_ioctl().
> 
> As for the x86 side...
> 
> Clean up the TDX post-populate paths (and many tangentially related paths) to
> address locking issues between gmem and TDX's post-populate hook[*], and
> within KVM itself (KVM doesn't ensure full mutual exclusivity between paths
> that for all intents and purposes the TDX-Module requires to be serialized).
> 
> [...]

Applied to kvm-x86 tdx, with fixups for the various typos.  Thanks for all the
reviews and testing!

Other KVM arch maintainers, please holler if you want a stable tag for the
kvm_arch_vcpu_async_ioctl() changes (they're based directly on v6.18-rc4).

[01/28] KVM: Make support for kvm_arch_vcpu_async_ioctl() mandatory
        https://github.com/kvm-x86/linux/commit/0a0da3f92118
[02/28] KVM: Rename kvm_arch_vcpu_async_ioctl() to kvm_arch_vcpu_unlocked_ioctl()
        https://github.com/kvm-x86/linux/commit/50efc2340a59
[03/28] KVM: TDX: Drop PROVE_MMU=y sanity check on to-be-populated mappings
        https://github.com/kvm-x86/linux/commit/5294a4b93e07
[04/28] KVM: x86/mmu: Add dedicated API to map guest_memfd pfn into TDP MMU
        https://github.com/kvm-x86/linux/commit/3ab3283dbb2c
[05/28] KVM: x86/mmu: WARN if KVM attempts to map into an invalid TDP MMU root
        https://github.com/kvm-x86/linux/commit/c1f173fb3389
[06/28] Revert "KVM: x86/tdp_mmu: Add a helper function to walk down the TDP MMU"
        https://github.com/kvm-x86/linux/commit/fe7413e39810
[07/28] KVM: x86/mmu: Rename kvm_tdp_map_page() to kvm_tdp_page_prefault()
        https://github.com/kvm-x86/linux/commit/6de2fb089bb2
[08/28] KVM: TDX: Drop superfluous page pinning in S-EPT management
        https://github.com/kvm-x86/linux/commit/ce7b5695397b
[09/28] KVM: TDX: Return -EIO, not -EINVAL, on a KVM_BUG_ON() condition
        https://github.com/kvm-x86/linux/commit/e6348c90dda9
[10/28] KVM: TDX: Fold tdx_sept_drop_private_spte() into tdx_sept_remove_private_spte()
        https://github.com/kvm-x86/linux/commit/b836503300dc
[11/28] KVM: x86/mmu: Drop the return code from kvm_x86_ops.remove_external_spte()
        https://github.com/kvm-x86/linux/commit/7139c8606505
[12/28] KVM: TDX: WARN if mirror SPTE doesn't have full RWX when creating S-EPT mapping
        https://github.com/kvm-x86/linux/commit/b9d5cf6de0b6
[13/28] KVM: TDX: Avoid a double-KVM_BUG_ON() in tdx_sept_zap_private_spte()
        https://github.com/kvm-x86/linux/commit/24adff397052
[14/28] KVM: TDX: Use atomic64_dec_return() instead of a poor equivalent
        https://github.com/kvm-x86/linux/commit/af96d5452e5e
[15/28] KVM: TDX: Fold tdx_mem_page_record_premap_cnt() into its sole caller
        https://github.com/kvm-x86/linux/commit/b4b2b6eda5af
[16/28] KVM: TDX: ADD pages to the TD image while populating mirror EPT entries
        https://github.com/kvm-x86/linux/commit/6b5b71ffabf9
[17/28] KVM: TDX: Fold tdx_sept_zap_private_spte() into tdx_sept_remove_private_spte()
        https://github.com/kvm-x86/linux/commit/14c9938619be
[18/28] KVM: TDX: Combine KVM_BUG_ON + pr_tdx_error() into TDX_BUG_ON()
        https://github.com/kvm-x86/linux/commit/597d7068702f
[19/28] KVM: TDX: Derive error argument names from the local variable names
        https://github.com/kvm-x86/linux/commit/55560b6be5bc
[20/28] KVM: TDX: Assert that mmu_lock is held for write when removing S-EPT entries
        https://github.com/kvm-x86/linux/commit/2ff14116982c
[21/28] KVM: TDX: Add macro to retry SEAMCALLs when forcing vCPUs out of guest
        https://github.com/kvm-x86/linux/commit/3d626ce5a8cc
[22/28] KVM: TDX: Add tdx_get_cmd() helper to get and validate sub-ioctl command
        https://github.com/kvm-x86/linux/commit/59d5c1ed6df2
[23/28] KVM: TDX: Convert INIT_MEM_REGION and INIT_VCPU to "unlocked" vCPU ioctl
        https://github.com/kvm-x86/linux/commit/94428e3ba325
[24/28] KVM: TDX: Use guard() to acquire kvm->lock in tdx_vm_ioctl()
        https://github.com/kvm-x86/linux/commit/0b76e827b29d
[25/28] KVM: TDX: Don't copy "cmd" back to userspace for KVM_TDX_CAPABILITIES
        https://github.com/kvm-x86/linux/commit/f26061fe2c25
[26/28] KVM: TDX: Guard VM state transitions with "all" the locks
        https://github.com/kvm-x86/linux/commit/15945e9ec195
[27/28] KVM: TDX: Bug the VM if extending the initial measurement fails
        https://github.com/kvm-x86/linux/commit/ad44aa4c5d3f
[28/28] KVM: TDX: Fix list_add corruption during vcpu_load()
        https://github.com/kvm-x86/linux/commit/1e3a825c9ec9

--
https://github.com/kvm-x86/linux/tree/next
