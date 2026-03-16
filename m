Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29E6327BFC
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773682532; cv=none; b=Qw+3bl7TVmohmgzui+GapQv87ULLa8zediGl+gnDdA8ouGfLMaKKH4ltdQ4/FftbD9N7M0OhRlpvyDH2mFaDjdwRoJzLlQt2sQR+0HaVbwxZoaGQeRd8H2l30Ra6hruQFEoubshVgmqur6USwVeCVv5gXDvP2tYv5hIBASMzv6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773682532; c=relaxed/simple;
	bh=F9LITpAhG3Sh5kqTgyGQmwJbl6xgJjwjQlWUJZA5m3Q=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jbNFHa+YAVj06CpvmkEAZzPiVGMQ+SaHrV/HMtau7Qzp7w/ZOrkZ877DdOpK9TKY/n6BpeIdPXaRMjyLppqO8B1LQlDdve4of590l29/HSearhp7ZmecaAnxvdVuH2NDy8IWcMU0xro+LM3hNIGQZPUco8zN1c29CMtp9jN+CpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q6/CvC0H; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q6/CvC0H"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4853b0af42aso72954445e9.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 10:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773682528; x=1774287328; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HpCcSOV6njoqt8AXcXZYXSoSkJ49sEAQqpokcgOqjA4=;
        b=q6/CvC0HbYAaUeOstujWYGOwXl99eecDw4j2ll8R05GQ+0EYNUlRij2W8NJ4ekKy+I
         j2z7138dtUS83AqSfm3R6FXyZBv+ZF1scR5iz4w1ApYkR6mEOsGGW4ysHZswjlDgwpwl
         c0MmDGNG3K5vGd3exCSP0zswoLDCJ2m3L7kiP+BAuPPjcSvLh9Z6zBYBi6GvtpflndT+
         c4TtdAC0e7RFjX/HymtakoYnjGLSjxcERMZ51nN2r8eGbNJ4Qx65Gqve//Bd15MA+n94
         yNvXxXZkqT5/ZgO966krkGApUOsuSCzXszRC4J5+DQE9hseaE5OAKH2BNIgOJf1A1osv
         9WIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773682528; x=1774287328;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HpCcSOV6njoqt8AXcXZYXSoSkJ49sEAQqpokcgOqjA4=;
        b=HXc8c4gYYh77zc0mIiQ5u+sTH4yHKU3isxvlcV+qpMwfCqWuQMO7iHTzAKG/cTGfvA
         mPK52wXR3yppW6z/vcmRdygx4TGrxVUG9BViXQaOoPyAlMj6ZqgM25otjtkBlf0zWCie
         1C+27v5Zb1zLps6i0EF7GiV7iXgi4p/3bgOXOWA8RnJjkQ/SBXIOO8rk+UtQUNMzSI3Q
         ZriLHNMgYagSh4EzN/Pmc4I2Fh5pOL5ksT3y+6/biVHu4S1h6MoPLnpVzD+3jahj4BJt
         mtt60G3N7f7tWuixEYXe5Wt6cIHEVZwYlDyCd1Jb77vUvJxAoWfkN4VuW5AkcPPJXtQo
         GAsg==
X-Forwarded-Encrypted: i=1; AJvYcCVgDiHQtyvs/HAZ8hZW17Fl20JcTuribH1hIfHY2lW5A6qndrI4weU9KIpi1ij4DudC3e82lno=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbSh25BPKCXN4cm5D7AvU0mTd6gyyhtPR/6ewx26AMa9ksdAqV
	Jz85bSOCl21+uXmJQYOSxiscttqLV1CETxlV4VPc2sm2OuHHBlx51yBhm7TH1qmt5miB7FHBdWq
	40A==
X-Received: from wmsu11-n2.prod.google.com ([2002:a05:600c:c3cb:20b0:485:3925:a795])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d0f:b0:485:3f38:3de3
 with SMTP id 5b1f17b1804b1-485566d2fc4mr232752095e9.3.1773682527900; Mon, 16
 Mar 2026 10:35:27 -0700 (PDT)
Date: Mon, 16 Mar 2026 17:35:21 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAFk/uGkC/x3MQQqAIBBA0avIrBNMwairRMSYYw1EhVYE4d2Tl
 m/x/wuJIlOCTrwQ6ebE+1ZQVwKmBbeZJPti0EpbZWorT3QOJa16nC+MXurQkAmobLAtlOqIFPj 5j/2Q8wd4MR/zYQAAAA==
X-Change-Id: 20260316-tabba-el2_guard-2f7e3fa06f69
X-Mailer: b4 0.14.3
Message-ID: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
Subject: [PATCH 00/10] KVM: arm64: Adopt scoped resource management (guard)
 for EL1 and EL2
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <linux-arm-kernel@lists.infradead.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <kvmarm@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Cc: Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi everyone,

I stumbled upon a lock leak while reviewing Sebastien's recent GIC Hardenin=
g
series [1] on an early error path. It reminded me that we've run into this =
exact
kind of bug pretty often while working on pKVM. Since we're going to be
hopefully upstream even more pKVM code soon, I'd like to try and fix this
pattern once and for all.

This series refactors a good chunk of KVM/arm64 codebase=E2=80=94covering b=
oth the host
at EL1 and the hypervisor at EL2=E2=80=94to use the guard() and scoped_guar=
d() macros
from <linux/cleanup.h>.

By tying our locks to the scope:
- We can safely use early returns (like return -EINVAL;) without accidental=
ly
  leaking locks.
- We can get rid of a lot of tangled goto exit labels.
- Reviewing patches gets a lot easier since we don't have to mentally track=
 lock
  states across giant functions.

A common concern with these RAII-style macros is that they might bloat the
generated assembly. However, looking at the compiled code, it actually does=
 the
opposite. As an example, looking at the EL2 object file
arch/arm64/kvm/hyp/nvhe/pkvm.nvhe.o before and after this series:
- Instruction count: Dropped by 39 lines of assembly.
- .text segment size: Shrank by 166 bytes.

This happens because the compiler no longer has to generate dedicated branc=
h
targets for exit blocks, nor the stack frame unwinding jumps just to call
hyp_spin_unlock. It just efficiently inlines the unlock instruction right w=
here
the return happens.

The series is split into two parts:
- Patches 1-5 (EL2): Adds the DEFINE_LOCK_GUARD_1 wrapper for hyp_spinlock =
and
  cleans up the nvhe/ directory.
- Patches 6-10 (EL1): Cleans up manual mutex_lock and spin_lock calls acros=
s the
  standard KVM host code (mmu.c, arm.c, psci.c, reset.c, pkvm.c).

There are definitely other parts of the KVM codebase that could benefit fro=
m
this (especially the vGIC), but I'm stopping here for now to see what every=
one
thinks of the approach before touching anything else.

Based on Linux 7.0-rc3.

Cheers,
/fuad

[1] https://lore.kernel.org/all/CA+EHjTy051kjdReuESmk3HpMsBEW=3Ds3DxhJXa8vQ=
JFHz--wG2Q@mail.gmail.com/

To:=20

---
Fuad Tabba (10):
      KVM: arm64: Add scoped resource management (guard) for hyp_spinlock
      KVM: arm64: Use guard(hyp_spinlock) in page_alloc.c
      KVM: arm64: Use guard(hyp_spinlock) in ffa.c
      KVM: arm64: Use guard(hyp_spinlock) in mm.c
      KVM: arm64: Use guard(hyp_spinlock) in pkvm.c
      KVM: arm64: Use guard(mutex) in mmu.c
      KVM: arm64: Use scoped resource management in arm.c
      KVM: arm64: Use guard(spinlock) in psci.c
      KVM: arm64: Use guard(spinlock) in reset.c
      KVM: arm64: Use guard(mutex) in pkvm.c

 arch/arm64/kvm/arm.c                       |  53 +++++--------
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h |   5 ++
 arch/arm64/kvm/hyp/nvhe/ffa.c              |  86 +++++++++-----------
 arch/arm64/kvm/hyp/nvhe/mm.c               |  37 +++------
 arch/arm64/kvm/hyp/nvhe/page_alloc.c       |  13 +--
 arch/arm64/kvm/hyp/nvhe/pkvm.c             | 122 ++++++++++++-------------=
----
 arch/arm64/kvm/mmu.c                       |  95 +++++++++-------------
 arch/arm64/kvm/pkvm.c                      |  19 ++---
 arch/arm64/kvm/psci.c                      |  19 ++---
 arch/arm64/kvm/reset.c                     |   8 +-
 10 files changed, 182 insertions(+), 275 deletions(-)
---
base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
change-id: 20260316-tabba-el2_guard-2f7e3fa06f69

Best regards,
--=20
Fuad Tabba <tabba@google.com>

