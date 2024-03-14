Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A465571741
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 20:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710447788; cv=none; b=AAaZNkl0Mr3MVUvhB1EpqMJ3kHVi2vmfk+26PRYNQWcj8ayLP9cVNbsOys6Gm2mupP1NRXhc0eLTocdeFh9IXjS9ypcd6wLcgBKGE2injgmioTJbTGxf9Y5N5+g4hK7yxjuVt4rP8gb4EuPvykGsNl5ImyfXHs6dlTR8mWlreA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710447788; c=relaxed/simple;
	bh=Es0A1CWvnUyhC/wcE9t/V1zJ0tGF5MsSskGQY/bA+Zo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nw+atSeYRV0H09eWzswfU2g9pvYvTiY6UhFENzdXdAAGOJA+AYjPTdbtPWqrcbnRWgcCSR6NzEXOrgHBoZKmCc86DSX+DqIlyAg/9W3ky2EN+SBnhR2lk5C+//v5WfAGCJ7510+Z2x5L5ZWTi4nN16L24nYtInkJwD8Ry1BeQh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P2ZOg3C4; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P2ZOg3C4"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-56890b533aaso1661305a12.3
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 13:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710447785; x=1711052585; darn=lists.linux.dev;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HGzKh07BEWjrakKuGgA7dSnfa62MUh7NaFhZ8iSDfO0=;
        b=P2ZOg3C4DgpuoBrdq6m6wu7Ne5vaJ7uhRKm/+ZTuwDhPKpprkBr2GjgijLjWJO38f4
         /H0rYsui8OlIFVp6OJYaadxOpn/mLTC0UQmQnw4Qm4s8aOryw1AqNbKa5HiGTVN+1h0O
         7cJ7FRbi6ogZudexK696I14PevG0wP9TH87mA8BEPYFYAK0tvbAC3Kdp7C7VGQGyKATM
         wTNNXqJfBxe9bzPlZZtk9gnDbuL7gpHaMis+FtG14YvrUH/NrLNps4FqXvnQXjL5y/Dp
         lbxUWsW/sxGprFagRifZ/3/ePV/lbgrwdwHCF67fC+iVsrA8v0UPzmhsN06FaCgptjYA
         hqmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710447785; x=1711052585;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HGzKh07BEWjrakKuGgA7dSnfa62MUh7NaFhZ8iSDfO0=;
        b=kYNNcFvqJvW0bqzmZuhbMKk6IZCaZiFslohv80tWZovKlE1LsMkKRQVo40rAwbfON3
         Tm4Cw07ReLwob9OlEdjeLKUkWHljLR+g0uYcDya74cPZOU/zdyHh151xBGrIvAYJ76Pa
         6WFrcfGUzriAa7i/vK8fyGbRENaZ0f7m8JApmAFtT1/090+JkEHYqBVS7GpBbO7XR2oe
         CfDIy+c4olw01itTCTXaW+bvymuFvflGC7WYjPredofIN7V1dngeLYaCyCc23Tevlr5b
         wtb/4Xg/xvx1d0UfTNdl9HPCCxnC7dY1nlW1pOcxct8T4H//lMfD7HmYR3S4E6jmjRgP
         phVw==
X-Gm-Message-State: AOJu0YwJcOrGK0/2BOi1VMwRYi3BFNuqCwAKSVS9Z7nDESZGfZ+Ivc6W
	l6V55HR78/pZtuCMqcYSdL9qx4Jw0C6V/YoeiAc0QD8bD8Zh/JBsza2FHYKugOo59FN2l5cqnGq
	BNEhX
X-Google-Smtp-Source: AGHT+IFKAaxhbx2F42VMc8P+jVQLNZM8zQDsShOoa/ppQez6OHZy7OgV3iEioiFJNpKQ1MttakLqog==
X-Received: by 2002:a05:6402:1ccd:b0:566:c167:4ac1 with SMTP id ds13-20020a0564021ccd00b00566c1674ac1mr2132851edb.26.1710447784699;
        Thu, 14 Mar 2024 13:23:04 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id o1-20020aa7dd41000000b00568830944f9sm1012487edw.19.2024.03.14.13.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 13:23:04 -0700 (PDT)
Date: Thu, 14 Mar 2024 20:23:00 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 00/10] KVM: arm64: Add support for hypervisor kCFI
Message-ID: <cover.1710446682.git.ptosi@google.com>
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
injecting the checks. In VHE (or hVHE), EL2 code gets compiled with the checks
but the handlers in VBAR_EL2 are not aware of kCFI and will produce a generic
and not-so-helpful panic message such as

  [   36.456088][  T200] Kernel panic - not syncing: HYP panic:
  [   36.456088][  T200] PS:204003c9 PC:ffffffc080092310 ESR:f2008228
  [   36.456088][  T200] FAR:0000000081a50000 HPFAR:000000000081a500 PAR:1de7ec7edbadc0de
  [   36.456088][  T200] VCPU:00000000e189c7cf

To address this,

- [01/10] fixes an existing bug where the ELR_EL2 was getting clobbered on
  synchronous exceptions, causing the wrong "PC" to be reported by
  nvhe_hyp_panic_handler() or __hyp_call_panic(). This is particularly limiting
  for kCFI, as it would mask the location of the failed type check.
- [02/10] & [03/10] (resp.) fix and improve __pkvm_init_switch_pgd for kCFI
- [04/10] to [06/10] prepare nVHE for CONFIG_CFI_CLANG and [09/10] enables it
- [10/10] improves kCFI error messages by saving then parsing the CPU context

As a result, an informative kCFI panic message is printed by or on behalf of EL2
giving the expected type and target address (possibly resolved to a symbol) for
VHE/hVHE, nVHE, and pKVM (iff CONFIG_NVHE_EL2_DEBUG=y).

Note that kCFI errors remain fatal at EL2, even when CONFIG_CFI_PERMISSIVE=y.

Pierre-Clément Tosi (10):
  KVM: arm64: Fix clobbered ELR in sync abort
  KVM: arm64: Fix __pkvm_init_switch_pgd C signature
  KVM: arm64: Pass pointer to __pkvm_init_switch_pgd
  KVM: arm64: nVHE: Simplify __guest_exit_panic path
  KVM: arm64: nVHE: Add EL2 sync exception handler
  KVM: arm64: nVHE: gen-hyprel: Skip R_AARCH64_ABS32
  KVM: arm64: VHE: Mark __hyp_call_panic __noreturn
  arm64: Move esr_comment() to <asm/esr.h>
  KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at EL2
  KVM: arm64: Improve CONFIG_CFI_CLANG error message

 arch/arm64/include/asm/esr.h            | 11 +++++++
 arch/arm64/include/asm/kvm_hyp.h        |  4 +--
 arch/arm64/kernel/asm-offsets.c         |  1 +
 arch/arm64/kernel/debug-monitors.c      |  4 +--
 arch/arm64/kernel/traps.c               |  2 --
 arch/arm64/kvm/handle_exit.c            | 39 +++++++++++++++++++++-
 arch/arm64/kvm/hyp/entry.S              | 43 ++++++++++++++++++++++---
 arch/arm64/kvm/hyp/hyp-entry.S          |  4 +--
 arch/arm64/kvm/hyp/include/hyp/switch.h |  6 ++--
 arch/arm64/kvm/hyp/nvhe/Makefile        |  6 ++--
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c    |  6 ++++
 arch/arm64/kvm/hyp/nvhe/host.S          | 19 ++++++-----
 arch/arm64/kvm/hyp/nvhe/hyp-init.S      | 11 ++++---
 arch/arm64/kvm/hyp/nvhe/setup.c         |  6 ++--
 arch/arm64/kvm/hyp/vhe/switch.c         | 27 ++++++++++++++--
 15 files changed, 149 insertions(+), 40 deletions(-)

-- 
Pierre
