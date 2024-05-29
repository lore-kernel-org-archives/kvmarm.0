Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317B3180A7B
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 12:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984805; cv=none; b=i65/hv9qQQ+kqBi0VFUwCTQVRkNI80gvw22iYUuSBuyIBqgI67pmX7NDxLPITcKawLExqEWF3kprxR9IZEEHBF8eguAlaoaF/ZY5OKOfLx71TKuJCx37ACsWgNF85YMsOAGKjnyAvV6p9yHCFfXu6K+97F7+hq68DXXKG5cNja8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984805; c=relaxed/simple;
	bh=+wFh6bAVdNhTd6MTyo642Dh+uNhSgGr7/zbHJwACshw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=gI2F6V9JR3YPMhPa2i2mhdxO5TSfdzLV26MR3VkcbYtIikKy4rzDm2MmcJOFtcM1kpegzjdj8gIvk3rkCUgdsTxuP+sO60jg6o02+WITtfhYm+nyw9v/UddTUhuU2TGaPpX/DZhvMqYHjaxboSkx5IGrAvv8ANmYRIXpS3ABa8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PRnBk5sB; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PRnBk5sB"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-579c4641702so1174917a12.0
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 05:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984802; x=1717589602; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KHM4hvPISZ5Fqfl4GlcTR57oUno+i9soKGwTyex86bs=;
        b=PRnBk5sBVm57ttW+eiwxL85sHSOpQHWknz8H4Fk8flvSvfYiTolU31u298l81D+4aX
         YRtBE9zhv2QDQ83Qlnqz1NtxwkPJw0hRTGny+/WIJc4jtv4BSfWG1gB5gOUkeT143A24
         mnkmtncKGOKDa68ApXyXzEWYIhmQd2TTWShsaJ5IiByq8uPai4gbfcLeZPKjlcSo2XMu
         23h599nTblzsUlI+pWlzD70TzknWY3zHxDDJ9IsJGc5PTIhMqSEfjtOZHNuG3BlVfai2
         wI8TWkalesdLilbzw60OAMKCmzKt049IJ2Pf4yfc0Kd+sl08UVRnu2eLuUtd9Bgcz2Hc
         9dxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984802; x=1717589602;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KHM4hvPISZ5Fqfl4GlcTR57oUno+i9soKGwTyex86bs=;
        b=MHuo0NjP9P3Cvd5t43kkfIIDCRTIIrMzGst1Bnm8uI1Z8KF7kiH7jXsj2MQmDckpFL
         rhEvTTh2pjj29Wo+iB4hypC4c3zw8jOrsQH3EVcTJiteEhi3oNSurEbSHmgDSb4hcEl7
         DKF9ANLUGh4yTW7no4jWV9jxGISqAeQ36WXqf46Ues2g1ChdNtxnJKWnGseyzF582L8A
         o4TqmYehLkRI+UZCfkKB2QnSNLbYcY90YSMVLe0n5UZk9SoErLLgKVYcCZKuhiuGgXc9
         uyric+s/LS1e3q6CZYiyFvUOoFTobkX9hm0RUpCMVA5yRYVkVtCxw/uLcGN2u8r+2Kie
         0Clg==
X-Gm-Message-State: AOJu0YzWARcu0T6CPOklwa1DDHM+ZWaDjiBxgUbSCsI6OeRYEDyZssUt
	ZKw58HraCRh5xVIORb/KYB9xLt9dYL63ndJe+8Vh22Nd62PSsqhGx3dACjDmiL7JCe7s+D802l8
	1bA0/WICkL8/Z3IM16H0jlSnKe7UeDLoTwKPEOMOZWsiDL19p2ygw3FxVq3tKcpIv5usAW23fyM
	rjyOOEL21k2x4LRF2OT8/a31SBPDs=
X-Google-Smtp-Source: AGHT+IGy4WL2CP5PklvEqxujQTD6yc2fhlZRBTpxJ6g4wgBAaDOJBrprVoBIpT2DiBPtsVpg198JthWjYw==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6402:3884:b0:578:242b:aac4 with SMTP id
 4fb4d7f45d1cf-57a03f586cdmr2540a12.2.1716984801909; Wed, 29 May 2024 05:13:21
 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:06 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-1-ptosi@google.com>
Subject: [PATCH v4 00/13] KVM: arm64: Add support for hypervisor kCFI
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

- [01/13] fixes an existing bug where the ELR_EL2 was getting clobbered on
  synchronous exceptions, causing the wrong "PC" to be reported by
  nvhe_hyp_panic_handler() or __hyp_call_panic(). This is particularly limi=
ting
  for kCFI, as it would mask the location of the failed type check.
- [02/13] fixes a minor C/asm ABI mismatch which would trigger a kCFI failu=
re
- [03/13] to [09/13] prepare nVHE for CONFIG_CFI_CLANG and [10/13] enables =
it
- [11/13] improves kCFI error messages by saving then parsing the CPU conte=
xt
- [12/13] adds a kCFI test module for VHE and [13/13] extends it to nVHE & =
pKVM

As a result, an informative kCFI panic message is printed by or on behalf o=
f EL2
giving the expected type and target address (possibly resolved to a symbol)=
 for
VHE, nVHE, and pKVM (iff CONFIG_NVHE_EL2_DEBUG=3Dy).

Note that kCFI errors remain fatal at EL2, even when CONFIG_CFI_PERMISSIVE=
=3Dy.

Changes in v4:
  - Addressed Will's comments on v3:
  - Removed save/restore of x0-x1 & used __guest_exit_panic ABI for new rou=
tines
  - Reworked __pkvm_init_switch_pgd new API with separate args
  - Moved cosmetic changes (renaming to __hyp_panic) into dedicated commit
  - Further clarified the commit message regarding R_AARCH64_ABS32
  - early_brk64() uses esr_is_cfi_brk() (now introduced along esr_brk_comme=
nt())
  - Added helper to display nvHE panic banner
  - Moved the test module to the end of the series

Pierre-Cl=C3=A9ment Tosi (13):
  KVM: arm64: Fix clobbered ELR in sync abort/SError
  KVM: arm64: Fix __pkvm_init_switch_pgd call ABI
  KVM: arm64: nVHE: Simplify __guest_exit_panic path
  KVM: arm64: nVHE: Add EL2h sync exception handler
  KVM: arm64: Rename __guest_exit_panic __hyp_panic
  KVM: arm64: nVHE: gen-hyprel: Skip R_AARCH64_ABS32
  KVM: arm64: VHE: Mark __hyp_call_panic __noreturn
  arm64: Introduce esr_comment() & esr_is_cfi_brk()
  KVM: arm64: Introduce print_nvhe_hyp_panic helper
  KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at EL2
  KVM: arm64: Improve CONFIG_CFI_CLANG error message
  KVM: arm64: VHE: Add test module for hyp kCFI
  KVM: arm64: nVHE: Support test module for hyp kCFI

 arch/arm64/include/asm/esr.h            |  11 ++
 arch/arm64/include/asm/kvm_asm.h        |   3 +
 arch/arm64/include/asm/kvm_cfi.h        |  38 +++++++
 arch/arm64/include/asm/kvm_hyp.h        |   3 +-
 arch/arm64/kernel/asm-offsets.c         |   1 +
 arch/arm64/kernel/debug-monitors.c      |   4 +-
 arch/arm64/kernel/traps.c               |   8 +-
 arch/arm64/kvm/Kconfig                  |  20 ++++
 arch/arm64/kvm/Makefile                 |   3 +
 arch/arm64/kvm/handle_exit.c            |  50 ++++++++-
 arch/arm64/kvm/hyp/cfi.c                |  37 +++++++
 arch/arm64/kvm/hyp/entry.S              |  34 +++++-
 arch/arm64/kvm/hyp/hyp-entry.S          |   4 +-
 arch/arm64/kvm/hyp/include/hyp/cfi.h    |  47 +++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |   5 +-
 arch/arm64/kvm/hyp/nvhe/Makefile        |   7 +-
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c    |   6 ++
 arch/arm64/kvm/hyp/nvhe/host.S          |  21 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-init.S      |  23 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  19 ++++
 arch/arm64/kvm/hyp/nvhe/setup.c         |   4 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        |   7 ++
 arch/arm64/kvm/hyp/vhe/Makefile         |   1 +
 arch/arm64/kvm/hyp/vhe/switch.c         |  34 +++++-
 arch/arm64/kvm/hyp_cfi_test.c           |  75 +++++++++++++
 arch/arm64/kvm/hyp_cfi_test_module.c    | 135 ++++++++++++++++++++++++
 26 files changed, 553 insertions(+), 47 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_cfi.h
 create mode 100644 arch/arm64/kvm/hyp/cfi.c
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/cfi.h
 create mode 100644 arch/arm64/kvm/hyp_cfi_test.c
 create mode 100644 arch/arm64/kvm/hyp_cfi_test_module.c

--=20
2.45.1.288.g0e0cd299f1-goog

