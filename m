Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0AC13D53B
	for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 08:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712737682; cv=none; b=iRNUGYkKuQybOhy/wlT6YD6OoHp3la9Lb+I5obRjwKS+EqLg9MzqFWYRGbRo3DyCq3b+0k1x0eFchKRSaZjUd0RLL0NanlzJYSjdRGmiDSUA7KLLaKo0hdo8cLcAqB5vkJYl0noY23YgQIbqyab/x0j6bpRAuSvYVBkzt8y31Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712737682; c=relaxed/simple;
	bh=kkuPA9LxaQ+TINL0zmJiUlzpNc4JChi60F/lcLNJ+/0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZuUb2YreDbgJKBksyxzgXcWXIGXQgodPJr8q0Pwx4e/DhULOfK00erDWcXqDCIgJY5/XoZZE6edpnkYC9+H/SB15YbWl0S0IMHBT4b85dzBDGvCM6gCeaIv7H5+wd+9Ko7SelU2guCrn+Fnocazh9Cgcw7N7Rk6PUWAzjdLqbFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QXRFFNlY; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QXRFFNlY"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-563cb3ba9daso6427674a12.3
        for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 01:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712737679; x=1713342479; darn=lists.linux.dev;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FXahQGtL2kR7RaZ5/ZHiSRpymPVFvDwsVVT/45XcUkI=;
        b=QXRFFNlYR1IHhEX0mZowho5JOgY0guTJrRPjB7XXkLtWUILQhrcOUREBs6z4Ny3jPz
         VibWIFTPh079AZnPr6Wt9EhSYUomBrMgu+uwU1jpe+TkY9dCMTwV1UB3zcfrgNdywkRO
         Pz4vkUAlgZObCmnusTn2BzZFMJu/FOAIgez+GK+ZxydGTByVKGy/S2plu9f7yTnoceDm
         f2oEUwJxH4z0D2rGdpSrDoaG2NZ7XhEMXWpxiljLUdAFgHiyyh6XAwFfb1eEJ/eCkKa4
         G/X/Sa51LHhLl5qrhpZ2JfuFjYaC477kdaczYQyN5PpPUGs02VhPPQAHSQ2tOm+10eYK
         aYZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712737679; x=1713342479;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FXahQGtL2kR7RaZ5/ZHiSRpymPVFvDwsVVT/45XcUkI=;
        b=PP1VX8SurmUm+NvHI897onw2qAa0Vr+LV6YSsFMLBcDBp3rMEY3v40A4Sc0bOPkfwx
         7JOfamsoS0Ojlqh6x8zmXZKk/fuGbseIroxFyHwB+cKr3QeXOC++cvtG2ruzb+Wz/0ID
         Vvx2086lqKvy32zgPPbczqyA1wAkmzPn51ggBo5nBCSExEisFuNLKEPiFFDVteKECNQC
         fx5EkOEjyMTafGCj0eP9j6W4Y8E5UWVpNj5SVADiSWsEzY+L52JhgzcYxHOmFx4uBvPf
         a5LOJwjO8CJlwNNiV7DpOGXGjtUGv58oyxSiy5fYavNkns9A+uI2Vzau7SLbRMa9AlMv
         wtQQ==
X-Gm-Message-State: AOJu0YwrrlyiAvIPwtw9yXyKn5yK1d2mTURDd+NEfkfyJv7FmRWPqnn0
	QyuAEqbDrHgzoRpjjB3rZVUlXScdHCYBexbtc/JQnhrUK7Yus2qeR5mVyNU1IlsU4EZGyXZSKLe
	mKg==
X-Google-Smtp-Source: AGHT+IGuwqYjsxdv8NyicLW4HPpH64SrOCoihZBd5dFprbj1OWTZUlHq52d4qC2EW/ed8P3sn92iCg==
X-Received: by 2002:a50:c35d:0:b0:56e:441:8a94 with SMTP id q29-20020a50c35d000000b0056e04418a94mr1493844edb.22.1712737678636;
        Wed, 10 Apr 2024 01:27:58 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id dj16-20020a05640231b000b0056fc1288faasm443672edb.56.2024.04.10.01.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 01:27:58 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:27:53 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v2 00/12] KVM: arm64: Add support for hypervisor kCFI
Message-ID: <oub2waaiejfpwj7x76v4uutrbboejl4xs6n2q66jaontvsywp3@qofhulpet5ny>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

CONFIG_CFI_CLANG ("kernel Control Flow Integrity") makes the compiler inject
runtime type checks before any indirect function call. On AArch64, it generates
a BRK instruction to be executed on type mismatch and encodes the indices of the
registers holding the branch target and expected type in the immediate of the
instruction. As a result, a synchronous exception gets triggered on kCFI failure
and the fault handler can retrieve the immediate (and indices) from ESR_ELx.

This feature has been supported at EL1 ("host") since it was introduced by
b26e484b8bb3 ("arm64: Add CFI error handling"), where cfi_handler() decodes
ESR_EL1, giving informative panic messages such as

  [   21.885179] CFI failure at lkdtm_indirect_call+0x2c/0x44 [lkdtm]
  (target: lkdtm_increment_int+0x0/0x1c [lkdtm]; expected type: 0x7e0c52a)
  [   21.886593] Internal error: Oops - CFI: 0 [#1] PREEMPT SMP

However, it is not or only partially supported at EL2: in nVHE (or pKVM),
CONFIG_CFI_CLANG gets filtered out at build time, preventing the compiler from
injecting the checks. In VHE, EL2 code gets compiled with the checks but the
handlers in VBAR_EL2 are not aware of kCFI and will produce a generic and
not-so-helpful panic message such as

  [   36.456088][  T200] Kernel panic - not syncing: HYP panic:
  [   36.456088][  T200] PS:204003c9 PC:ffffffc080092310 ESR:f2008228
  [   36.456088][  T200] FAR:0000000081a50000 HPFAR:000000000081a500 PAR:1de7ec7edbadc0de
  [   36.456088][  T200] VCPU:00000000e189c7cf

To address this,

- [01/12] fixes an existing bug where the ELR_EL2 was getting clobbered on
  synchronous exceptions, causing the wrong "PC" to be reported by
  nvhe_hyp_panic_handler() or __hyp_call_panic(). This is particularly limiting
  for kCFI, as it would mask the location of the failed type check.
- [02/12] & [03/12] (resp.) fix and improve __pkvm_init_switch_pgd for kCFI
- [04/12] to [06/12] prepare nVHE for CONFIG_CFI_CLANG and [10/12] enables it
- [12/12] improves kCFI error messages by saving then parsing the CPU context
- [09/12] adds a kCFI test module for VHE and [11/12] extends it to nVHE & pKVM

As a result, an informative kCFI panic message is printed by or on behalf of EL2
giving the expected type and target address (possibly resolved to a symbol) for
VHE, nVHE, and pKVM (iff CONFIG_NVHE_EL2_DEBUG=y).

Note that kCFI errors remain fatal at EL2, even when CONFIG_CFI_PERMISSIVE=y.

Changes in v2:
  - Added 2 commits implementing a test module for hyp kCFI;
  - For __kvm_hyp_host_vector, dropped changes to the sync EL2t handler and kept
    the SP overflow checks;
  - Used the names __guest_exit_restore_elr_and_panic, esr_brk_comment;
  - Documented the use of SYM_TYPED_FUNC_START for __pkvm_init_switch_pgd;
  - Fixed or clarified commit messages.

Pierre-Clément Tosi (12):
  KVM: arm64: Fix clobbered ELR in sync abort/SError
  KVM: arm64: Fix __pkvm_init_switch_pgd C signature
  KVM: arm64: Pass pointer to __pkvm_init_switch_pgd
  KVM: arm64: nVHE: Simplify __guest_exit_panic path
  KVM: arm64: nVHE: Add EL2h sync exception handler
  KVM: arm64: nVHE: gen-hyprel: Skip R_AARCH64_ABS32
  KVM: arm64: VHE: Mark __hyp_call_panic __noreturn
  arm64: Move esr_comment() to <asm/esr.h>
  KVM: arm64: VHE: Add test module for hyp kCFI
  KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at EL2
  KVM: arm64: nVHE: Support test module for hyp kCFI
  KVM: arm64: Improve CONFIG_CFI_CLANG error message


 arch/arm64/include/asm/esr.h            |  11 ++
 arch/arm64/include/asm/kvm_asm.h        |   3 +
 arch/arm64/include/asm/kvm_cfi.h        |  38 +++++++
 arch/arm64/include/asm/kvm_hyp.h        |   4 +-
 arch/arm64/kernel/asm-offsets.c         |   1 +
 arch/arm64/kernel/debug-monitors.c      |   4 +-
 arch/arm64/kernel/traps.c               |   8 +-
 arch/arm64/kvm/Kconfig                  |  20 ++++
 arch/arm64/kvm/Makefile                 |   3 +
 arch/arm64/kvm/handle_exit.c            |  39 ++++++-
 arch/arm64/kvm/hyp/cfi.c                |  37 +++++++
 arch/arm64/kvm/hyp/entry.S              |  43 +++++++-
 arch/arm64/kvm/hyp/hyp-entry.S          |   4 +-
 arch/arm64/kvm/hyp/include/hyp/cfi.h    |  47 +++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |   5 +-
 arch/arm64/kvm/hyp/nvhe/Makefile        |   7 +-
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c    |   6 ++
 arch/arm64/kvm/hyp/nvhe/host.S          |  20 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-init.S      |  18 +++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  19 ++++
 arch/arm64/kvm/hyp/nvhe/setup.c         |   6 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        |   7 ++
 arch/arm64/kvm/hyp/vhe/Makefile         |   1 +
 arch/arm64/kvm/hyp/vhe/switch.c         |  34 +++++-
 arch/arm64/kvm/hyp_cfi_test.c           |  75 +++++++++++++
 arch/arm64/kvm/hyp_cfi_test_module.c    | 135 ++++++++++++++++++++++++
 26 files changed, 553 insertions(+), 42 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_cfi.h
 create mode 100644 arch/arm64/kvm/hyp/cfi.c
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/cfi.h
 create mode 100644 arch/arm64/kvm/hyp_cfi_test.c
 create mode 100644 arch/arm64/kvm/hyp_cfi_test_module.c

-- 
2.44.0.478.gd926399ef9-goog


-- 
Pierre
