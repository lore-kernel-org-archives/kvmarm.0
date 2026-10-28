Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214182;
	b=mR58LLhgmiwebfGCN19qs9FzqU7wu5QU/2hMGF+pbvmyc2oCkSh9FaGiMCQrB9imKTqp
	 ETnejyJqWzgkfKgkkQQupuv1vRxg0nhPzSLfdXQF7LQv1zCgrbvypYOCGlnumHSikxyY6
	 a6eO2EScCpdhg9O6dGwdQoLsHgGaPBthX+M4Pn3/65KsEccNibM42CYlMPqLCu9H8Ssgl
	 JZPZZgrYmQtI2WkRfV5FAjQtGOo39hiHbENHxcv7KZlLS8XwSmwiK1HgPQuf2b9GBH/Cp
	 VxLIEdPAxiDGQqseao6AvfFqnSNyzbGktvs0jN3CRKUCpVR+vRgKncsGdzAnJl+d6XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214182;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Reply-To:Date:
	 Mime-Version:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=HbuVr5an123e2WdNsh7qTkraPx2QUzUAuDpOvbvX5g4=;
	b=mhEZVTUMIyXIRD7TkehnZfBbSH9uYcGtE9oGNTvvRl1RA7EjWeBSeeD2lfYCwItUPB+Q
	 /PNkwoMBy6TSt4a3HDIERIOWLsixyyKldB0u0jOicvIYdvpvxmBpHgBnGM/SI3fK8rwj4
	 5NcO5IAG+VfCnKyjf4QWJ4V9gUSszne26qIntO6CMLeYKB3xyL6dDqOcIxSDaIajAmsUN
	 o/+rohjuu4tC/KnK8nR04ozuui7kqyRlw4aV/wAySl+eRz4FecyIa0Zl9DzgrMF5fVbDU
	 FmJECmi0M6gJAycbyGhadjhvQYIcb0a1tCvn6aYoyqVGSoSIKIqlg7GVuu7a65ylZLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=S0XXU36Y;
	arc=none smtp.remote-ip=209.85.210.200
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9FE606A329
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 19:03:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B9FE606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=S0XXU36Y
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-89fb6a45c48so1719934b3a.1
        for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 12:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793214182; x=1793818982; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :reply-to:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HbuVr5an123e2WdNsh7qTkraPx2QUzUAuDpOvbvX5g4=;
        b=S0XXU36YJ0PKSDNLSoAOdfdIB0OvsA3GolFMAqDrNe1aS3aKfY4nkIPca88v1JoJ9K
         kKxd+NlQnCA8SFB92QaUpivngoBBnB/Rb5WlLnnKjyv32yEtRS2YqWV2D7u6Kx1XHORT
         VbtkUsE9xMr62O1pwWfju7tly/YKWeTy9FvMEkrhxQ9BjOhl9WzZTIwbYuBCfhD7DOXm
         p1nAt8dRV6lwDkvCvssfpREyDDtvLtUhObWgDNsKPCtUv8oEsCmrWXTXB43fdmDLTzEe
         RmBcHlQZtFHCyOl0Wu0g4HX2j9GWDkHIQqMTcYMfHYU80MXpdjfL4Mna57gVvHG+JO2F
         a13w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793214182; x=1793818982;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=HbuVr5an123e2WdNsh7qTkraPx2QUzUAuDpOvbvX5g4=;
        b=JwVtwzDH8vDtcXBsSU24i+olqJzsfjA0bCKGHpuzQnPU/HanNnCLghvCTZaSe7e/pX
         0gplaRQ9kKU07P5092XvGnZL0EqvJHTgarBJKu4X2dTUPNHLfAjAEj8nTvKk6DcUuJ6g
         Df0yty8Pn1ZUICmbWKasnWxrIPehWsCE+TDgxPAkupEJ13AhMsELaXOrPmi9ItCJmal5
         k3DzQkJzWLRe/cubShnYGIwtGYR5CQdw+i/7T+71UWL+zr6a3WGVYV3ZW7L3m2500E8H
         F2Fo8zXjK7Sh9cHWThl2xlikf8cp+vC+MEjiKdEGMgCorzGx8F5iwkoxyhnzDWOJOAxB
         qGLA==
X-Forwarded-Encrypted: i=1; AKwUvBw9fpVcDVTIyFT8pdnYvO73G6zWqsSIen5ld4qJiNcMjLNhEwSARnFQymwIfroXRvnuhmopiw0=@lists.linux.dev
X-Gm-Message-State: AFq9FYJAAst+ogER8kJIrjzIgYcwvoxD0asVYfLV7WuYi8TGOiPoUy2C
	zcWcUbM7npFGMGT5Wt2eCqlcQyB9MxppBlCNHT8szBlS8G6l51DtcOLOwVoxT5knZQUS5Nz7HUH
	JVVt8ZQ==
X-Received: from pfog22.prod.google.com ([2002:aa7:8756:0:b0:8a0:7e84:9992])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:18a8:b0:899:55e9:880b
 with SMTP id d2e1a72fcca58-8a6e72dc7admr2727923b3a.14.1793214181492; Wed, 28
 Oct 2026 12:03:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Oct 2026 12:02:52 -0700
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028190259.1819571-1-seanjc@google.com>
Subject: [PATCH 0/7] KVM: Ensure WAIT requests actually wait
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Atish Patra <atish.patra@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Stefan Teodorescu <fane@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix a bug in where kvm_make_request_and_kick() won't actually wait if the
kick races without another non-waiting kick.  The issue is that all of the
conditional kvm_arch_vcpu_should_kick() implementations are missing this code:

	if (req & KVM_REQUEST_WAIT)
		return mode != OUTSIDE_GUEST_MODE;

Thankfully, kvm_request_needs_ipi() does the right thing, so this doesn't
affect kvm_make_all_cpus_request() or kvm_make_vcpus_request_mask(), i.e. it's
limited to x86 SNP's used of kvm_make_request_and_kick().

To fix, address this TODO:

  /* TODO: merge with kvm_arch_vcpu_should_kick */

and purge kvm_arch_vcpu_should_kick().  As usual, PPC makes that difficult
because it has wonky code that is poorly documented.  For reasons unknown,
kvm_vcpu_kick() unconditionally returns true on (most flavors of) PPC.  To
preserve that behavior, add a compatibility wrapper in PPC, along with a
@force param to __kvm_vcpu_kick().

This series would ideally go into 7.4, even though it's obviously not small,
as guest_memfd in-place conversion massively widens the window where a missed
kick+wait can lead to the host trying to reclaim an in-use VMSA page, which
is generally fatal to the host.

Sean Christopherson (7):
  KVM: s390: Drop unused and unreachable kvm_arch_vcpu_should_kick()
  KVM: Add a @force param to __kvm_vcpu_kick() for PPC backwards
    compatibility
  KVM: PPC: Explicitly force IPIs when directly kicking vCPUs
  KVM: MIPS: Rework kvm_arch_vcpu_should_kick() to use standard
    implementation
  KVM: Move kvm_arch_vcpu_should_kick() to common code as
    kvm_vcpu_should_kick()
  KVM: Plumb the full request into __kvm_vcpu_kick()
  KVM: Drop kvm_vcpu_should_kick() and use kvm_request_needs_ipi()

 arch/arm64/kvm/arm.c               |  5 -----
 arch/loongarch/kvm/vcpu.c          |  5 -----
 arch/mips/kvm/mips.c               |  5 -----
 arch/powerpc/include/asm/kvm_ppc.h | 13 ++++++++++++-
 arch/powerpc/kvm/book3s.c          |  4 ++--
 arch/powerpc/kvm/book3s_pr.c       |  2 +-
 arch/powerpc/kvm/booke.c           |  6 +++---
 arch/powerpc/kvm/e500_emulate.c    |  2 +-
 arch/powerpc/kvm/powerpc.c         |  7 +------
 arch/riscv/kvm/vcpu.c              |  5 -----
 arch/s390/kvm/s390/s390.c          |  7 -------
 arch/x86/kvm/x86.c                 |  5 -----
 include/linux/kvm_host.h           |  7 +++----
 virt/kvm/kvm_main.c                | 28 ++++++++++++++++------------
 14 files changed, 39 insertions(+), 62 deletions(-)


base-commit: 7e60162b16f9da0d2fa83da5c1723b6853a0ac1d
-- 
2.56.0.313.g2479322e68-goog

