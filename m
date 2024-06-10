Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB7B10A22
	for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 06:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718001184; cv=none; b=Lf+AS3UU3Oc8Qoxsi1IFp1z9tJwminOWhafZxSBkTzTqjamTq2dkm/DK3zlRkLEkrA6n0urmdnWdcmFl8Pkhwk+BEjdoz1nKLnQC+kU4tA8WV68DokppmbiwSi9LGHUEQHZII+w1yFYxw44X7mkuljWuk3fDuoh7zfD4k3NNp54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718001184; c=relaxed/simple;
	bh=l6jcF5i3o/hkbbqIKOzIl1s31HyokNVDBcYJZK46IiE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=vAt9nlOthQ6B652VnVHDPj0S2JwBxLdRMzwzguInZuOTLHvEm9k5P8z42zQwLQknWOPa6n4f+tToSFR9KRqT5WrHQ0iZG5SMjD+0Ttd51Nv8rAcSLeLLpSOZrc1lzOPL3HCzjhipj9lcWXK1xm05p2v8f8grtlNxKeJB963KczQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VbzIS7xD; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VbzIS7xD"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dfa84f6a603so7011374276.3
        for <kvmarm@lists.linux.dev>; Sun, 09 Jun 2024 23:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718001181; x=1718605981; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SV3VpUvUuZUDCnIEJtnyIJokYqwm61smGNoJPs2Ev1g=;
        b=VbzIS7xDELDddCRYUG+IkWXkm9JOtZZrInFk9puWTlWDD02xfuAUsOLNdii+c27Gky
         r/zdRQsghtYKVAjTQrhboS8pdtyVxk9yMbQ1ltcrBmeL7+t3jbBfdU/7aKC4XgF/6GE3
         j4/5BrsGg1+RuSqHGC/Y+NBiJx/aOYD2JTiR4aiv26jum3ESTINExeAl+NCpIgG2C0SV
         rBBNv9WcksN8Vk8vKAKHxwD+6s12HMNXE5CQQvlSHuEUgcUnqGjIm0OOJKj4p4DNNjto
         wBSuL71+dTWokAFNW2BW/3+FR6jXQydCYhg0DZVnti8m5gNWUVvomkrNcsDrXdwiYDja
         CR1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718001181; x=1718605981;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SV3VpUvUuZUDCnIEJtnyIJokYqwm61smGNoJPs2Ev1g=;
        b=Hj/MATOC3vGWxiwWiMIsChUGcRI4ZiXSNiSOuyVSLJjW5JkKNE9dSOxOeXcqy1tQQb
         IBcv9CFBw7aHAqrvhFVg8yrfIW1r7ejuZAP0d2aUjVHjSGg63flUWiCYUikJYKzTySx6
         CUoCJBMNOzA0BrZ6zYQXe3v28ubg8OsEqg7Auwb0b2aBuWarfACPqTu+347K5TYs80N4
         kQXPW/WjZZ+Szg7YI6x+ZeunXuaQKqyAF561rdBLcFxXQBwDqcvC5XexEZFlbLd/m6+W
         Dt1pfxcJqnksfszvR4zWGkBTv9hQDPn4ojG2chbSn4SIlHLHLrIQfEDvtQ7syI/wDnsC
         0Oog==
X-Gm-Message-State: AOJu0YyryHShaWcA2hU3OlLmJVup8PdZ9gPtu5lUrFu+MosoDjYprFXq
	yMdMASvghrnSOCNpKK9sK8vpAZberya1px1qhv43aKnHn70RAuoo67xIoxoyI2K3obkvwa6A9Bj
	VwamxUTFE9jeX++B0zhzTSizh4u/oUw6BjGumsMS/BgrX6tU6jVuIDrMnB1EimC7QBiXqQxMNQw
	EFg+/CZH5knRkiPNh1RiP99tqiu18=
X-Google-Smtp-Source: AGHT+IE7ukTgtkKT05jf5+K94IJiuvYTmDsAiB90Z4RAIq7icQqVtEUXErqkuzjcjiRo2zRoJ8jUu5/EZw==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6902:10c3:b0:dfb:1c1c:ac11 with SMTP id
 3f1490d57ef6-dfb1c1cb10emr174664276.13.1718001181056; Sun, 09 Jun 2024
 23:33:01 -0700 (PDT)
Date: Mon, 10 Jun 2024 07:32:29 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240610063244.2828978-1-ptosi@google.com>
Subject: [PATCH v5 0/8] KVM: arm64: Add support for hypervisor kCFI
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
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

However, it is not supported at EL2 in nVHE (or pKVM), as CONFIG_CFI_CLANG =
gets
filtered out at build time, preventing the compiler from injecting the chec=
ks.

To address this,

- [1/8] fixes an existing bug where the ELR_EL2 was getting clobbered on
  synchronous exceptions, causing the wrong "PC" to be reported by
  nvhe_hyp_panic_handler() or __hyp_call_panic(). This is particularly limi=
ting
  for kCFI, as it would mask the location of the failed type check.
- [2/8] fixes a minor C/asm ABI mismatch which would trigger a kCFI failure
- [3/8]-[7/8] prepare nVHE for CONFIG_CFI_CLANG and [8/8] enables it

Note that kCFI errors remain fatal at EL2, even when CONFIG_CFI_PERMISSIVE=
=3Dy.

Changes in v5 (addressed Will's comments on v4):
  - Dropped the patch making the handlers report the kCFI target & expected=
 type
  - Dropped the hypervisor kCFI test module
  - Dropped the patch introducing handler for EL2h sync exceptions
  - Dropped the patch renaming __guest_exit_panic
  - Made invalid_host_el2_vect branch unconditionally to hyp_panic
  - Changed SP type in __pkvm_init_switch_pgd signature to unsigned long
  - Changed which registers __pkvm_init_switch_pgd used for intermediates
  - Fixed typo in commit message about esr_brk_comment()
  - Fixed mistake in commit message about context of invalid_host_el2_vect

Pierre-Cl=C3=A9ment Tosi (8):
  KVM: arm64: Fix clobbered ELR in sync abort/SError
  KVM: arm64: Fix __pkvm_init_switch_pgd call ABI
  KVM: arm64: nVHE: Simplify invalid_host_el2_vect
  KVM: arm64: nVHE: gen-hyprel: Skip R_AARCH64_ABS32
  KVM: arm64: VHE: Mark __hyp_call_panic __noreturn
  arm64: Introduce esr_brk_comment, esr_is_cfi_brk
  KVM: arm64: Introduce print_nvhe_hyp_panic helper
  KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at EL2

 arch/arm64/include/asm/esr.h            | 11 +++++++++
 arch/arm64/include/asm/kvm_hyp.h        |  4 ++--
 arch/arm64/kernel/asm-offsets.c         |  1 +
 arch/arm64/kernel/debug-monitors.c      |  4 +---
 arch/arm64/kernel/traps.c               |  8 +++----
 arch/arm64/kvm/handle_exit.c            | 24 +++++++++++++++-----
 arch/arm64/kvm/hyp/entry.S              |  8 +++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  5 +++--
 arch/arm64/kvm/hyp/nvhe/Makefile        |  6 ++---
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c    |  6 +++++
 arch/arm64/kvm/hyp/nvhe/host.S          |  6 -----
 arch/arm64/kvm/hyp/nvhe/hyp-init.S      | 30 +++++++++++++++----------
 arch/arm64/kvm/hyp/nvhe/setup.c         |  4 ++--
 arch/arm64/kvm/hyp/vhe/switch.c         |  3 +--
 14 files changed, 78 insertions(+), 42 deletions(-)

--=20
2.45.2.505.gda0bf45e8d-goog

