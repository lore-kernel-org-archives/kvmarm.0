Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC2A3C4578
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 10:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773223716; cv=pass; b=BglGjTd1cb8KpHn8/MOWIiUFyuQWvY0H0RXchWM85gaUuijafMXaZ/s969AprCdcP/0tMacWa3avpraQcVyqVnSXHpEPH3pu1XMBOS3A97x4SEQdh7kHKNXtJJPcrAdn3SgeLKl4da6OQJ46e2vcdTIcvzuPS6Ox4pr8InEgoTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773223716; c=relaxed/simple;
	bh=2uPit/1pxNLEi573aTazjG9JRFF26OFZvqJUwe1H/pE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HwJ9jOkQB0X4TmMs8ifyNv1y+u8k+m64DVrsuXUbEXpcpHPFf2OB4aA+UkotH7Mymd+8XgrRAfR8uDKoSCErFGGNhzlf3/BIijd9Lg1dSmjW2ipHgiw5ggMb2tmohKIaCldhxB5o3bn6OYr2N/nm2Re4dZ1WZOoJ6xVyu+T5TIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bmHnAW8X; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bmHnAW8X"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-509062d829dso407441cf.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 03:08:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773223714; cv=none;
        d=google.com; s=arc-20240605;
        b=R3suESrM6AGIVtVTUl5f+ZzbAacChirw7qCA/UtnNVIN/3PxSYacDcQhlYxEYXYGYW
         wuHVfHO5JnPmbZ99/qvXK4LijZJICv8Duspx0KbPOiuKyZh+EdgrqGZbHBWf2XW4Q54m
         K5IKe26aUVjhJ9G9y2VFptPzgQsr6JyqH8Y6IU+L+L5X9FkkS+PlE/yqJ6D+mqCNAeqp
         e1cBDkHio7KalLDvaAPAhjm+zOZ2kmxBpPqvSf2pqC7v2or7rxAmchiTYTM9kDwEj9bw
         xxsjNynRj++h+jRnpJgMizwjALkszHLhINQ2++VKxU9zW7rkQaalJKUh6FDHZxkoswCX
         elDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=g1+J3NqZXQBkyhheWX7UG+xf0a4O/Xa45DXcaC0RyAk=;
        fh=Jxzwzg3laewSUvCA2a09gOOd6H1o1mMdzeS5XgaaAVk=;
        b=bnXycrlrdm1aFK+4pBBG64mbNB9HfFtCoSXHf2MHGuhF5/rxvA3wpbsV7Yye5BAsqk
         EA8ZzvasC4YsjK4Ox3ufCNx4YmztAu8ELdIULDYiZAv3IfGFuJdny4myfaCkDRVLfF95
         KRXCwvP1/LZmtny2WYme4DF8lD7d+zw2BV6sjX7lKDsqE3nBJzOVKS0I5D6ocdDjyyP/
         kxVBCogSR/wDQN84Yp8z1z3mMrzQ7WUUnA2H0tarW9TH9pevVlN9nH+PqKa/xoqEmx9V
         8EQsRnaXx8NcWocKtBZwuhdxuuzGteqPMIxDW/aHbC4ovSFtYdYd0Z+nSl078pPlLFYe
         mlhg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773223714; x=1773828514; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=g1+J3NqZXQBkyhheWX7UG+xf0a4O/Xa45DXcaC0RyAk=;
        b=bmHnAW8XNwJ9FgeHD5FdsdR8xWdwpwGhHpMh+eRtljNQQom4joAW7RHLi40xHpokjv
         p45dsQvqdXIlWHpLqLpbPFtLgi2Ga6nLcnGQIOO7SRrEJ1up8mMkNtNBfQqpeNZPhd7g
         vZ/UPuRMD46dQ4CA6sArCxM3SUd1MmIKqPNgRXKBQ70lTnacJBn8CyQUGS6RzvsY7n1f
         S3QF4Si7oLVLVc/Ar/7lbgLKs+BjboL6tPuQm/p3Yo8GpePQARf1/QUrR4PhDyGZqzx7
         A6zTSzfGL+aoHtgfYkiL5cBsWvcKr652IBpDcEYYp4+He+qIzSqoOBaIz9MVcO8asRQn
         rTAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773223714; x=1773828514;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g1+J3NqZXQBkyhheWX7UG+xf0a4O/Xa45DXcaC0RyAk=;
        b=wy8cYvf3IVCObG+AVXlEPe6W7gAjYN2Qfpn4hPbkWHco9yqLKnp/tQknWkdoF6A5GU
         cHSQkSnBPte1DZ7D9tvvTviC3Suzb6c+BNLbwSk1IH9dbYVcIgU6ZjQgOhcELZI5JXQB
         dgkpuY1pnWR5BkWz7HTM2/JewTniHzW6wc2fqDvLClHIC9yma/jqHGLYXJz8m8UUUVCS
         xfOwr1vndxg+Dmo9Pd8/xxqocMleKTt22d1Bnq2qWtSAc2FE1edWYxxSaBp0u+wpANxH
         C7T/NceGnHg8KOJJBF7Gq+MGg/cftKnUEWlM0mAOa59a5DTf55BlplsVhI/QGxiQhFWe
         7jlA==
X-Gm-Message-State: AOJu0YwtK05Itxn2uQEfIiZiJP20E0/Id2051Ajs6y1anZ2Mx6zyXbz9
	snK/4gZ0+LyYCY/H8A0mp4bAqHop2nOriz/C6o7gqPp3mfCwDkXf9bSL1D8BMuxvMGV1MiOCxk6
	r/zO8yGVGN3FcyNZSF0EhBJ3CRNoULSvbp8BUBgMU
X-Gm-Gg: ATEYQzxhrtEb4LrEnsFc9h2bmU7Gh41QHn436NP9yNSM1CBJ3eqnhOEzJndspfBh3mi
	KdAz6Y5agxvGhykKU7JKnA30mHvcw7OBSRj2e+EPpXkFS/waHj03Pm/m0IqpUdt2HNR5z0Jk3Vg
	+i6n+7YCjTWeShArent/EhpQaXyZ9CJaMs7z4X3uAODZ2WDyIQMOEYgXtrieHwT5U4qq3wO2iiE
	5ZuYx1KUYsF6eLbIcYFX2Wr0wkD0q5wjqLJERoRd/+rJCnbtPFi5fOH+0xOM0i9rO1fLx5+uzX7
	LT02LyUQw9sBvZgh20uJb4cHDw+x2AhffQT0eA==
X-Received: by 2002:a05:622a:649:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-5093801c297mr11736091cf.0.1773223713491; Wed, 11 Mar 2026
 03:08:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260305144351.17071-1-will@kernel.org>
In-Reply-To: <20260305144351.17071-1-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Mar 2026 10:07:56 +0000
X-Gm-Features: AaiRm52TzX3ZonIXvaz3nCHskmbhiqVjVB_l366ofCqzpHAmP4-UKzbQ1mMmDh4
Message-ID: <CA+EHjTxfufq6kD1JZCryHeWM=eHODJck9KzRLWcZ37SbhH5rKA@mail.gmail.com>
Subject: Re: [PATCH v3 00/36] KVM: arm64: Add support for protected guest
 memory with pKVM
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Will,

On Thu, 5 Mar 2026 at 14:44, Will Deacon <will@kernel.org> wrote:
>
> Hi everyone,
>
> Here's v3 of the patches previously posted here:
>
>   v1: https://lore.kernel.org/kvmarm/20260105154939.11041-1-will@kernel.org/
>   v2: https://lore.kernel.org/kvmarm/20260119124629.2563-1-will@kernel.org/
>
> Changes since v2 include:
>
>   * Rebased onto v7.0-rc2
>   * Rework of the way that exceptions are injected into the host,
>     building on top of Fuad's work that landed in the recent merge
>     window.
>   * Some renaming and comment additions.
>
> As before, I've pushed an updated branch with this series:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/log/?h=kvm/protected-memory
>
> and the kvmtool patches are available at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/log/?h=pkvm

For both the kvmtool patches and this series:

Tested-by: Fuad Tabba <tabba@google.com>

Thanks!
/fuad

> Cheers,
>
> Will
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
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
>
> --->8
>
> Fuad Tabba (1):
>   KVM: arm64: Expose self-hosted debug regs as RAZ/WI for protected
>     guests
>
> Quentin Perret (1):
>   KVM: arm64: Inject SIGSEGV on illegal accesses
>
> Will Deacon (34):
>   KVM: arm64: Don't leak stage-2 page-table if VM fails to init under
>     pKVM
>   KVM: arm64: Move handle check into pkvm_pgtable_stage2_destroy_range()
>   KVM: arm64: Rename __pkvm_pgtable_stage2_unmap()
>   KVM: arm64: Don't advertise unsupported features for protected guests
>   KVM: arm64: Remove is_protected_kvm_enabled() checks from hypercalls
>   KVM: arm64: Ignore MMU notifier callbacks for protected VMs
>   KVM: arm64: Prevent unsupported memslot operations on protected VMs
>   KVM: arm64: Ignore -EAGAIN when mapping in pages for the pKVM host
>   KVM: arm64: Split teardown hypercall into two phases
>   KVM: arm64: Introduce __pkvm_host_donate_guest()
>   KVM: arm64: Hook up donation hypercall to pkvm_pgtable_stage2_map()
>   KVM: arm64: Handle aborts from protected VMs
>   KVM: arm64: Introduce __pkvm_reclaim_dying_guest_page()
>   KVM: arm64: Hook up reclaim hypercall to pkvm_pgtable_stage2_destroy()
>   KVM: arm64: Factor out pKVM host exception injection logic
>   KVM: arm64: Support translation faults in inject_host_exception()
>   KVM: arm64: Avoid pointless annotation when mapping host-owned pages
>   KVM: arm64: Generalise kvm_pgtable_stage2_set_owner()
>   KVM: arm64: Introduce host_stage2_set_owner_metadata_locked()
>   KVM: arm64: Change 'pkvm_handle_t' to u16
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
>   KVM: arm64: Extend pKVM page ownership selftests to cover guest hvcs
>   KVM: arm64: Rename PKVM_PAGE_STATE_MASK
>
>  .../admin-guide/kernel-parameters.txt         |   4 +-
>  Documentation/virt/kvm/arm/index.rst          |   1 +
>  Documentation/virt/kvm/arm/pkvm.rst           | 103 +++
>  arch/arm64/include/asm/kvm_asm.h              |  31 +-
>  arch/arm64/include/asm/kvm_host.h             |   9 +-
>  arch/arm64/include/asm/kvm_pgtable.h          |  45 +-
>  arch/arm64/include/asm/kvm_pkvm.h             |   4 +-
>  arch/arm64/include/asm/virt.h                 |   9 +
>  arch/arm64/kvm/Kconfig                        |  10 +
>  arch/arm64/kvm/arm.c                          |  12 +-
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   9 +
>  arch/arm64/kvm/hyp/include/nvhe/memory.h      |  12 +-
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   7 +-
>  .../arm64/kvm/hyp/include/nvhe/trap_handler.h |   2 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 184 +++---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 585 ++++++++++++++++--
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                | 224 ++++++-
>  arch/arm64/kvm/hyp/nvhe/switch.c              |   1 +
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c            |   8 +
>  arch/arm64/kvm/hyp/pgtable.c                  |  33 +-
>  arch/arm64/kvm/mmu.c                          | 114 +++-
>  arch/arm64/kvm/pkvm.c                         | 154 ++++-
>  arch/arm64/mm/fault.c                         |  33 +-
>  include/uapi/linux/kvm.h                      |   5 +
>  24 files changed, 1374 insertions(+), 225 deletions(-)
>  create mode 100644 Documentation/virt/kvm/arm/pkvm.rst
>
> --
> 2.53.0.473.g4a7958ca14-goog
>
