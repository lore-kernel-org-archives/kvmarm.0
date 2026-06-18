Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E388231835
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 12:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781785007; cv=none; b=jfbgdE2WTia1iQK1Gb5RffHKWdcT2TqhIs6LtZM6E4AZN8BqBVUmPpUidmUpur/v9Gdt6lV0UusMtfMn+3rj7LfAAIjRVAolj2PKs9Cd4kbgT4pSf04Ry23jOBjtVHhpPcowilaAQcOzCdydrjU6GFIj4OhILRzpGAUoE/9Po5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781785007; c=relaxed/simple;
	bh=3rcFGBZNWTkuWnN08ogbAl7ZwPLkcK4Vdutd9VvI7gA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=O+TLmCttcDw6Ef+osHkUOTVF2HqnPxWPD0K8KRWU3leaokVBYM3tI+0chwPT1X5L5DNlxAogHMFdn+9DUs6fBCDCLRvGTf4FTj6ps1WCDBOxODdJt5Ysbu1+8BROe8r3sns4dqij5DclRjyGsBkNZ1j4h+Qo9jJQC99qXMGz5aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wkxChZVZ; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wkxChZVZ"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-462c1cf9003so865082f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 05:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781785005; x=1782389805; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hXhmL5CRl3+n80jeER5neBIkpa8f6Enzrvf/cmu79ZA=;
        b=wkxChZVZ8wFWZZp/dlr9i1M8WxD4OFWGaJs/eB7u61Sw8SRLdMCuPTW3ZlFS4Pl1JB
         YqSRA/Iat7mfCat6Vs/nvl2h9KUxRGqKnfn2rYlElfPLtp+OR5SNNTVdPw53I4TTZ1FM
         YnPPR9xBBRS4OWjq7mQ3/VIQAnXSYZGfSFK7mOMD1EBGAuZmhvLnTAngGsrfByHuBw/T
         iAJyP9lZuGb1BBt7sVKsvOSMsNAiU1WjqinGe3LScy7IHcIh3+YWgI3CNgtgDSSmA3tm
         FL6RtAagRsKN6a7RAeMeDNwMMejFzUBHktbB1RzDwW9Vmj5fLajlBRZH9K6n5RsVOipI
         /TbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781785005; x=1782389805;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hXhmL5CRl3+n80jeER5neBIkpa8f6Enzrvf/cmu79ZA=;
        b=BLG184fG8GvFUM1kxZzgDXG/EOXNXs70ameDBHUM1p8Gsx3EMLigZdYmqPF+owJxyJ
         vmpLhaaOamPcYKCDGLTcsDkkmGSEhxhQDY+jvo/uHvkHM5ejXwFygESxO2x6gQ6aoYXC
         1v8Ki4Gxu9XZFw4v7xYl7ThFOxNaLRPBHfhpXtaeEtZg4MtKaOKhAoVIRD2qrDYFO6sM
         pZl/NJdq3viRlZxNEsOreDgiJfOqYXH18rEkzsDYj0DN1+wo/JqmwXx5dAW62Yu+oSuB
         f/me/02GEse9+m3+nUN5viOVxkEszaTUde0VPFzY7g/myp0oqt09ssf3MYRLB8NBVLAH
         l4Yw==
X-Forwarded-Encrypted: i=1; AFNElJ/7lIMZ5/4NPpLfZG8kfU5iICm1j508YM5ieaSACw1yMJpv3ZxuxXfom1yxiMWevqj5WDxiOgA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSUvpqHTylZbW9HGJCvcezVDsXWbE9UzZxe5whJyAhTWOaRpa/
	CNdC/B18xb/KXCLLX60/DllANKexqieAx9INOhgh1JXjDNCGInfon+7IpcZ879mC8Gm5srZ1yo8
	SCw==
X-Received: from wrmd14.prod.google.com ([2002:adf:e88e:0:b0:44b:7bd5:1b9f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5449:0:b0:45e:de0a:1773
 with SMTP id ffacd0b85a97d-462412c71e6mr10667158f8f.33.1781785004608; Thu, 18
 Jun 2026 05:16:44 -0700 (PDT)
Date: Thu, 18 Jun 2026 13:16:36 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1189.g8c84645362-goog
Message-ID: <20260618121643.4105064-1-tabba@google.com>
Subject: [PATCH v2 0/7] KVM: arm64: Fix missing ESR_ELx.IL in syndrome injection
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sascha Bischoff <Sascha.Bischoff@arm.com>, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Hi folks,

After sashiko caught the missing IL bug [1], I did an audit of all ESR
syndrome construction sites in KVM/arm64 as Marc suggested. This series
is the result of that audit.

The ARM architecture mandates ESR_ELx.IL=1 for several exception
classes regardless of instruction length: EC=Unknown, Instruction
Aborts, Data Aborts with ISV=0, and SError. For FPAC (EC=0x1C), IL
reflects instruction length, but FPAC can only be generated by A64
instructions, so IL must also be 1.

Patch 1 is the bug sashiko found: inject_undef64() in the pKVM hyp (EL2)
path never set IL. Patch 2 makes the same fix to inject_undef64() in the
normal host path, where IL was derived from the triggering trap's
instruction length. No instruction that reaches undef injection has a
16-bit encoding, so patch 2 has no functional change today.
Patch 3 makes the matching fix to inject_abt64(). Unlike undef
injection, abort injection is reachable from a 16-bit T32 instruction (a
32-bit EL0 task under an AArch64 EL1 guest), so the old code there
injects an abort with IL=0.
Patch 4 fixes the FPAC syndrome constructed during nested ERET
emulation, which did not set IL.
Patches 5-6 fix SError injection in the emulated and nested paths,
neither of which set IL.
Patch 7 fixes a fake ESR used to exit to the host. The host does not
read IL there, so it is not guest-visible.

Changes since v1 [2]:
- Patch 4: keep IL by masking it through from the trapped ERET's ESR
  instead of OR-ing the bit in. The ERET trap (EC=0x1A) always reports
  IL=1, so this preserves the source syndrome rather than adding the
  bit unconditionally (Marc).
- Rebased on v7.1.

Cheers,
/fuad

[1] https://lore.kernel.org/all/87pl1t8q24.wl-maz@kernel.org/
[2] https://lore.kernel.org/all/20260614163336.3490925-1-tabba@google.com/

Signed-off-by: Fuad Tabba <tabba@google.com>

Fuad Tabba (7):
  KVM: arm64: Set ESR_ELx.IL for injected undefined exceptions at EL2
  KVM: arm64: Unconditionally set IL for injected undefined exceptions
  KVM: arm64: Unconditionally set IL for injected abort exceptions
  KVM: arm64: Set IL for injected FPAC exceptions during ERET emulation
  KVM: arm64: Set IL for emulated SError injection
  KVM: arm64: Set IL for nested SError injection
  KVM: arm64: Set IL in fake ESR for pKVM memory sharing exit

 arch/arm64/kvm/emulate-nested.c    |  4 ++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c     |  3 ++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c |  2 +-
 arch/arm64/kvm/inject_fault.c      | 18 +++++-------------
 4 files changed, 10 insertions(+), 17 deletions(-)

-- 
2.54.0.1189.g8c84645362-goog

