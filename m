Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B535217109E
	for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 11:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340441; cv=none; b=bvSEwhXn7ikZF7oFQYEpvNGbiC/cWWy3zTsouin3JFIYyoBV/e/BJTMlImDHgc7gpQD0u9sbsrXfS8OtD1/PhO7EwqYpG930MxEiHVWMFMRh+jhpIG9hQtWnWxwM2HTfHDcGDE2IGsgz2CwTF2guMmaFDcxJ+HB2ujTGQJ1dKNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340441; c=relaxed/simple;
	bh=W1srijuSTb7jeqkogw773MDhdMTTGhTLI4r93emG8so=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YncGJy82lbYqWf1eBlE7Pd1sjtlrwV+dFyWsUhg4oaO8E+ZBlLgKrqDSgkr8O7wLj7Ul61duBLWQ3BZX4aJoj2gD9P9XBCkwFDOhEUZUYkyHJFkj6DFkwTbpByoLQLZAK7eXsjkdR+sQRrjZGrPSCKTgNUImO6KbzioPREWUtPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J+NtSIZg; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J+NtSIZg"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dee5f035dd6so25119276.0
        for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 04:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715340438; x=1715945238; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GeTpsY//IUL3F2M4pGNF9LnkrFBIxs/L6CWJHc93UMI=;
        b=J+NtSIZgCh84Jyb8vX0mvuAPYQjCzUJVqFyWMGSyhgA0+VvgbtMU10PsBszdApk0ie
         L+QGiqmOSu3zyZYiD7qpWqkozFPbuM39OxrfUV/C5xB63HQ2/yyTX0k5JgQzOtb0zblx
         c7n4Xge1rH5iDqOT+JwX+GdZpRuPx7w2D3UvzhcYJ0o/t5LQ9lMv46R6d22UWUU2K4pD
         vKCR9XtFYG9TaQkBYm78lDhH4T1ZRK3yXGJgI+n+XXRjmeQsF3iObHeZSB1rOdIDhxr8
         zfQ4KRhdYNgRACSwjs308rCk6ETfxfJiGSmmBpdRQLvkuW3TQFrf6TmBwRzTeDuAfZ87
         HCdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715340438; x=1715945238;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GeTpsY//IUL3F2M4pGNF9LnkrFBIxs/L6CWJHc93UMI=;
        b=B1wlzV7UIm2Ly/KjBgq9EeTY3crPW3epdh3srDeYNlWqUk3QnqWwyrx/EoZN42DDtK
         L1apPotUbAkH3H9hW1ZVioDCN0AL01GdM3A/gbdq/Tt9hP0LKnt0XPZHQgKeyacCScah
         EJwTCLOI+gpYv/6LCs6q1x4W42V8GCKqGsWAzJP3RVhhD2S9DsZv99kKcx8Hl119ElEF
         GA7g3f+aabrSFuL3/ZkCt2z8Xv9kxYFuYuaWHJF8xA/1wzbaBLZkC9K27H8/gOATcS8e
         RMAkTySsDampYP7sG5cRNea/A2XtaQdTga4hoWHAC4JTtewLDhDL9WLTN2zHrUoxfAL/
         Ae/Q==
X-Gm-Message-State: AOJu0YwcIQtki691ZuDUsh4jDPH2qWbeIl19V/BhTTNxPGLMFYpfDZQw
	awfiFVgmoSBMjSYcnviTO4oz+ZJ1XdvSsO+kllZZIoq85t+Ijy36Uot0IM+oDYVAlrkEKWVsKNZ
	hC1wUHc0Mm7wBpZCOHvf131OxXsSsnGaxhtwGaA/ZBFVq+ImHgBR6DCXYDOXX7aNzdM29BxRBYb
	r9Ri97CLeNLpHbJqMzUljLSjg+k7E=
X-Google-Smtp-Source: AGHT+IH8LcT7Mlvj6sPM9cJjFdpOx3dU6FNulJiXugTsKM/5ei+quZrDmLQDkQIioDTzRKYsUovHynihLw==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6902:100f:b0:dee:5d43:a0f3 with SMTP id
 3f1490d57ef6-dee5d43c91fmr54501276.6.1715340437656; Fri, 10 May 2024 04:27:17
 -0700 (PDT)
Date: Fri, 10 May 2024 12:26:29 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510112645.3625702-1-ptosi@google.com>
Subject: [PATCH v3 00/12] KVM: arm64: Add support for hypervisor kCFI
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

CONFIG_CFI_CLANG ("kernel Control Flow Integrity") makes the compiler injec=
t
runtime type checks before any indirect function call. On AArch64, it gener=
ates
a BRK instruction to be executed on type mismatch and encodes the indices o=
f the
registers holding the branch target and expected type in the immediate of t=
he
instruction. As a result, a synchronous exception gets triggered on kCFI fa=
ilure
and the fault handler can retrieve the immediate (and indices) from ESR_ELx=
.

This feature has been supported at EL1 ("host") since it was introduced by
b26e484b8bb3 ("arm64: Add CFI error handling"), where cfi_handler() decodes
ESR_EL1, giving informative panic messages such as

  [   21.885179] CFI failure at lkdtm_indirect_call+0x2c/0x44 [lkdtm]
  (target: lkdtm_increment_int+0x0/0x1c [lkdtm]; expected type: 0x7e0c52a)
  [   21.886593] Internal error: Oops - CFI: 0 [#1] PREEMPT SMP

However, it is not or only partially supported at EL2: in nVHE (or pKVM),
CONFIG_CFI_CLANG gets filtered out at build time, preventing the compiler f=
rom
injecting the checks. In VHE, EL2 code gets compiled with the checks but th=
e
handlers in VBAR_EL2 are not aware of kCFI and will produce a generic and
not-so-helpful panic message such as

  [   36.456088][  T200] Kernel panic - not syncing: HYP panic:
  [   36.456088][  T200] PS:204003c9 PC:ffffffc080092310 ESR:f2008228
  [   36.456088][  T200] FAR:0000000081a50000 HPFAR:000000000081a500 PAR:1d=
e7ec7edbadc0de
  [   36.456088][  T200] VCPU:00000000e189c7cf

To address this,

- [01/12] fixes an existing bug where the ELR_EL2 was getting clobbered on
  synchronous exceptions, causing the wrong "PC" to be reported by
  nvhe_hyp_panic_handler() or __hyp_call_panic(). This is particularly limi=
ting
  for kCFI, as it would mask the location of the failed type check.
- [02/12] & [03/12] (resp.) fix and improve __pkvm_init_switch_pgd for kCFI
- [04/12] to [06/12] prepare nVHE for CONFIG_CFI_CLANG and [10/12] enables =
it
- [12/12] improves kCFI error messages by saving then parsing the CPU conte=
xt
- [09/12] adds a kCFI test module for VHE and [11/12] extends it to nVHE & =
pKVM

As a result, an informative kCFI panic message is printed by or on behalf o=
f EL2
giving the expected type and target address (possibly resolved to a symbol)=
 for
VHE, nVHE, and pKVM (iff CONFIG_NVHE_EL2_DEBUG=3Dy).

Note that kCFI errors remain fatal at EL2, even when CONFIG_CFI_PERMISSIVE=
=3Dy.

Change in v3:
  - Reworked the commit message of [04/12]
  - (no code changes since v2, questions on v1 remain open)

Changes in v2:
  - Added 2 commits implementing a test module for hyp kCFI;
  - For __kvm_hyp_host_vector, dropped changes to the sync EL2t handler and=
 kept
    the SP overflow checks;
  - Used the names __guest_exit_restore_elr_and_panic, esr_brk_comment;
  - Documented the use of SYM_TYPED_FUNC_START for __pkvm_init_switch_pgd;
  - Fixed or clarified commit messages.

Pierre-Cl=C3=A9ment Tosi (12):
  KVM: arm64: Fix clobbered ELR in sync abort/SError
  KVM: arm64: Fix __pkvm_init_switch_pgd C signature
  KVM: arm64: Pass pointer to __pkvm_init_switch_pgd
  KVM: arm64: nVHE: Remove __guest_exit_panic path
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

--=20
2.45.0.118.g7fe29c98d7-goog

