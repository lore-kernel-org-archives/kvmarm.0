Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B4C26FD93
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 15:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773415898; cv=none; b=OWaKUU9VU2UuQB5JOXr9r8pGnfUdDWh1eQBeZAAVjjG5d4mqPvAnJp2qX9hvbYOJe1FBhDq7dpKbeE8QIMMd6I+O8BuSnQUJkDeeTBAWDa5boQvS/RK/u4A324D0wZRVkv0mUeFN/ndzz3LKfo7n8MsLpezDH1WZFUdTaMfEASg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773415898; c=relaxed/simple;
	bh=pPfXjTJhArRNjYBdyeg1yydmvS04X2ArJfLoZXNLCiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KVDsnOA/v8Rlx17Q4kyixZqoFJ3/3ZvDSqydHMwtma+tyX1plEwufKxybfw6NsTI4DvLHipDCWGu3W10PHvRAus7NfPy8dbKLciJPP/3az1s8CynRcAbrjw+soBCmyinY+NTXzeT/t0k2/jSM1dszm8evljz0Xh15VSBOSH7u44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iAF3TiOC; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iAF3TiOC"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4852af55981so80375e9.0
        for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 08:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773415895; x=1774020695; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GlDoUZqv12CD3hXKENcdmNwTrtdAgu339Wi9YV5GI0A=;
        b=iAF3TiOCDNIkH/mpfuI3NCftvMP/QRKUsevjGWznBM0XqvPxUCz8LVidzEgPBIpDct
         VzmOhnzxBb4/e56JyWS4hEUeVzQcfoWlOdHjKja+gp5XwetudGFPtodiLMebrOeG3U8H
         HAZRwzhtMR/tUoL4NO1hbQ5evJc1Drqo9MUG4frFGxpwIJmlgKFL5/ymJc9Gdq/uOK03
         w3iiteQwZVziWBfPV5CnygtP8Itckzm/fY8P4gaB89iNujVevvnjUDsMy6VMBnveiSjr
         iJmsZc1qmOfm9fRR943nbhRB9g69w5zAFY7sSHfrnj6j+QTZcWI0XhIzxI2PpfaT9lnT
         aEOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773415895; x=1774020695;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GlDoUZqv12CD3hXKENcdmNwTrtdAgu339Wi9YV5GI0A=;
        b=nDy4sz7kEIgZRH0eAfnr4OMB3Ya5snka0RpxxxaQNebrsjzrUkzppM5yyvKBEigdj0
         V6cdXSBM69EioiLHdpuKk9U3ldiXFmjdhM2kSmFikJCEXAe0M0bLZjx7H8ZdpSRoV2Bw
         IWu8rgsNCTXc9ZKuyl9th87i6ANfWjKXdNwx2XqJEoFhNPY4alyrdwjtP//KE9Iug5YR
         Sd73oP4SS6vOq0bE7elYfxTtJUw/+PP2GpVd12KVnjX6DLtpV7H4grGl/nCf+0dJWP0y
         isJuoFurqX8vx3UoaYPewV8Fxg8x3nDQzRv1xSnprcMYAw44ewYDLkswArtgeee1k+fA
         JU6A==
X-Gm-Message-State: AOJu0YzcGrCy6fPWLKY/ouf13BWEd6jaon1eHGOHTZmOnIlkTOsmx9g8
	dryGwuivlpBDAVAdQ/gb9bUV/X8z7JvKa5uU105JwiaHMHHiPoCSiEkYOJxih+a10kSMNMI3aSl
	p5sedwQ==
X-Gm-Gg: ATEYQzxrdsbXWdQccDqrcWW0491dNsWNTbP27d4AQ6QKwPcoykIIkdUNWZqYhmiezCZ
	vy1ouoPoBXvlN/ha1IXm6G1TMrIyXWO/zf3HnRzTmPtNa25tpjkLwx6ug9irU6Uy+OheFDgndVO
	sM67c9jvhw1WTH6OpeSHmad0iLQOdJys7rGVP+VIXiPsAA+4mkjK/VKxtHgAomLDp0l9EAKj/tR
	m3F9068DZAhMaPOqWQ7dx5WOJnanTi8TJoyD7Sk5kJCMQoCrF4Ef3uNhm/fn+oqJeHovLp/ergO
	WGlP6qkUg0NeXMhw7IXn8r7vDLbcI3ES7nSFE7Z8mJK2f6tMl1aosmXd9sJA07etBo4C9OAhjyG
	OCMLCZUX1eKwAREJqpGpHP5mzqiw/YtJwdZGYB7xzC/5f0T5Wedr6k4kuy+PUKa4zzNtuPwMRtx
	oo3z6g1Rgr2lrRyGBFhUvtZeCPPcEF/hpJ/1JpUe5NbN30EI7CKAfE3d1l
X-Received: by 2002:a05:600c:4848:b0:47e:dbb0:fbcd with SMTP id 5b1f17b1804b1-4855670e6c5mr696295e9.6.1773415894813;
        Fri, 13 Mar 2026 08:31:34 -0700 (PDT)
Received: from google.com (54.95.38.34.bc.googleusercontent.com. [34.38.95.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe22e9ddsm15981754f8f.37.2026.03.13.08.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 08:31:34 -0700 (PDT)
Date: Fri, 13 Mar 2026 15:31:30 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH 00/30] KVM: arm64: Add support for protected guest memory
 with pKVM
Message-ID: <abQt0l8BjwGJqXe-@google.com>
References: <20260105154939.11041-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105154939.11041-1-will@kernel.org>

Hi Will,

On Mon, Jan 05, 2026 at 03:49:08PM +0000, Will Deacon wrote:
> Hi folks,
> 
> Although pKVM has been shipping in Android kernels for a while now,
> protected guest (pVM) support has been somewhat languishing upstream.
> This has partly been because we've been waiting for guest_memfd() but
> also because it hasn't been clear how to expose pVMs to userspace (which
> is necessary for testing) without getting everything in place beforehand.
> This has led to frustration on both sides of the fence [1] and so this
> patch series attempts to get things moving again by exposing pVM
> features in an incremental fashion based on top of anonymous memory,
> which is what we have been using in Android. The big difference between
> this series and the Android implementation is the graceful handling of
> host stage-2 faults arising from accesses made using kernel mappings.
> The hope is that this will unblock pKVM upstreaming efforts while the
> guest_memfd() work continues to evolve.
> 
> Specifically, this patch series implements support for protected guest
> memory with pKVM, where pages are unmapped from the host as they are
> faulted into the guest and can be shared back from the guest using pKVM
> hypercalls. Protected guests are created using a new machine type
> identifier and can be booted to a shell using the kvmtool patches
> available at [2], which finally means that we are able to test the pVM
> logic in pKVM. Since this is an incremental step towards full isolation
> from the host (for example, the CPU register state and DMA accesses are
> not yet isolated), creating a pVM requires a developer Kconfig option to
> be enabled in addition to booting with 'kvm-arm.mode=protected' and
> results in a kernel taint.
> 
> More information about what is and what isn't implemented is described
> in the pkvm.rst documentation added by this series. The intention is to
> update this file as we introduce additional protection features and
> ultimately to remove the taint.
> 
> The series is loosely structured as follows:
> 
>   Patch       1: A dependent pgtable fix that I sent out previously
>   Patches   2-8: Cleanups/fixes to the existing code to prepare for pVMs
>   Patches  9-14: Support for memory donation and reclaim
>   Patches 15-22: Handling of bad host accesses to protected memory
>   Patches 23-25: Support for SHARE and UNSHARE guest hypercalls
>   Patches 26-27: UAPI and developer documentation
>   Patches 28-30: Selftest additions for new page ownership transitions
> 
> Patches are based on v6.19-rc4 and are also available at [3].
> 
> All feedback welcome.
> 
> Cheers,
> 
> Will
> 
> [1] https://lore.kernel.org/all/aS9rmMgNna7I5g4F@kernel.org/
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/log/?h=pkvm
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/log/?h=kvm/protected-memory
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: Joey Gouly <joey.gouly@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Zenghui Yu <yuzenghui@huawei.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Quentin Perret <qperret@google.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Vincent Donnefort <vdonnefort@google.com>
> Cc: Mostafa Saleh <smostafa@google.com>
> 
> --->8
> 
> Fuad Tabba (1):
>   KVM: arm64: Expose self-hosted debug regs as RAZ/WI for protected
>     guests
> 
> Quentin Perret (2):
>   KVM: arm64: Refactor enter_exception64()
>   KVM: arm64: Inject SIGSEGV on illegal accesses
> 
> Will Deacon (27):
>   KVM: arm64: Invert KVM_PGTABLE_WALK_HANDLE_FAULT to fix pKVM walkers
>   KVM: arm64: Remove redundant 'pgt' pointer checks from MMU notifiers
>   KVM: arm64: Rename __pkvm_pgtable_stage2_unmap()
>   KVM: arm64: Don't advertise unsupported features for protected guests
>   KVM: arm64: Remove pointless is_protected_kvm_enabled() checks from
>     hyp
>   KVM: arm64: Ignore MMU notifier callbacks for protected VMs
>   KVM: arm64: Prevent unsupported memslot operations on protected VMs
>   KVM: arm64: Split teardown hypercall into two phases
>   KVM: arm64: Introduce __pkvm_host_donate_guest()
>   KVM: arm64: Hook up donation hypercall to pkvm_pgtable_stage2_map()
>   KVM: arm64: Handle aborts from protected VMs
>   KVM: arm64: Introduce __pkvm_reclaim_dying_guest_page()
>   KVM: arm64: Hook up reclaim hypercall to pkvm_pgtable_stage2_destroy()
>   KVM: arm64: Generalise kvm_pgtable_stage2_set_owner()
>   KVM: arm64: Introduce host_stage2_set_owner_metadata_locked()
>   KVM: arm64: Annotate guest donations with handle and gfn in host
>     stage-2
>   KVM: arm64: Introduce hypercall to force reclaim of a protected page
>   KVM: arm64: Reclaim faulting page from pKVM in spurious fault handler
>   KVM: arm64: Return -EFAULT from VCPU_RUN on access to a poisoned pte
>   KVM: arm64: Add hvc handler at EL2 for hypercalls from protected VMs
>   KVM: arm64: Implement the MEM_SHARE hypercall for protected VMs
>   KVM: arm64: Implement the MEM_UNSHARE hypercall for protected VMs
>   KVM: arm64: Allow userspace to create protected VMs when pKVM is
>     enabled
>   KVM: arm64: Add some initial documentation for pKVM
>   KVM: arm64: Extend pKVM page ownership selftests to cover guest
>     donation
>   KVM: arm64: Register 'selftest_vm' in the VM table
>   KVM: arm64: Extend pKVM page ownership selftests to cover forced
>     reclaim

I tested the patches on Lenovo ideacenter Mini X Gen 10 Snapdragon with
nvhe as for some reason I am facing issues with hvhe on this HW even
with upstream.

I can boot ToT Linux kernel as both protected and non-protected VMs using
the kvmtool version in here.

For reference, I am using:
- Config: defconfig + CONFIG_PROTECTED_VM_UAPI + CONFIG_ARM_PKVM_GUEST
- Run: ./lkvm-static run --irqchip gicv3 -k Image -d rootfs.ext2 --force-pci -c 1  --debug (--protected)

For the whole series:
Tested-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

> 
>  .../admin-guide/kernel-parameters.txt         |   4 +-
>  Documentation/virt/kvm/arm/index.rst          |   1 +
>  Documentation/virt/kvm/arm/pkvm.rst           | 101 ++++
>  arch/arm64/include/asm/kvm_asm.h              |   7 +-
>  arch/arm64/include/asm/kvm_emulate.h          |   5 +
>  arch/arm64/include/asm/kvm_host.h             |   7 +
>  arch/arm64/include/asm/kvm_pgtable.h          |  27 +-
>  arch/arm64/include/asm/kvm_pkvm.h             |   4 +-
>  arch/arm64/include/asm/virt.h                 |   6 +
>  arch/arm64/kvm/Kconfig                        |  10 +
>  arch/arm64/kvm/arm.c                          |   8 +-
>  arch/arm64/kvm/hyp/exception.c                | 100 ++--
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   9 +
>  arch/arm64/kvm/hyp/include/nvhe/memory.h      |   6 +
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   7 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  95 ++--
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 500 ++++++++++++++++--
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                | 223 +++++++-
>  arch/arm64/kvm/hyp/nvhe/switch.c              |   1 +
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c            |   8 +
>  arch/arm64/kvm/hyp/pgtable.c                  |  22 +-
>  arch/arm64/kvm/mmu.c                          | 122 ++++-
>  arch/arm64/kvm/pkvm.c                         | 149 +++++-
>  arch/arm64/mm/fault.c                         |  31 +-
>  include/uapi/linux/kvm.h                      |   5 +
>  25 files changed, 1249 insertions(+), 209 deletions(-)
>  create mode 100644 Documentation/virt/kvm/arm/pkvm.rst
> 
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 
