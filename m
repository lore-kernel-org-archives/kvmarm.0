Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B06D29A309
	for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 16:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781454820; cv=none; b=U8RvtM+BoRAM1+DkB5gVkrbHTOctU/WiebWtnPArz4P2/07nRK6pREk/fHGhtaFid/WZemIWI7mCFiLT+cqMWNkhSvVfHn8FdA7MFVHlEdmAIT1bcF0ccPK3Wi0f4+fkDR0/4d5Eofcvcj+R+zOSg2UtXj9FGqZKeWnQK00Xya8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781454820; c=relaxed/simple;
	bh=iIjH5h06cGBmKEwS0baZNP6y+X5SmfaIo9y8hX3w30c=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YuNyYkw1JQ9178V5vMOE//t89+Gjl78ypDNWXiG8E6b5Ob0cJ42bO1u1r7gGr2btj8zxXe++A36ZJUHvwJXxfCiW5dvmyFqywvVDiipEoY7BMfQzr6VgJ3GG/jmiOpDNgBFS69GThQ6G1UpK2aonGtJLZLevEeK1dmuQtFP9fHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fVVlElHq; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fVVlElHq"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-45ef66cc579so1141788f8f.3
        for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 09:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781454818; x=1782059618; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wF52xqv2gt97ZmYG5q8RS9QpeTQBkGWbTxMLhSV4/qM=;
        b=fVVlElHq+D4p1RZBTAaD98Uu6HD0L6sFdpUvF3tlX+dzUYCIDcKOu2JUFAe0pqbCVX
         8oiy39S7EOE0s92alkgeXAXJDWi7mvtcQCOgL1r04ancBNqfQ1WIj1+PCS3BQJyjYcq2
         OIOx9jupWnsE2JefzuqkcV9JIzNeuZYzDcKffqsVhDHelpfk6iy8tVZLXvbIbTyWF9Dp
         uF4qdDqw0Ptx5UVHODHC1o3/uksddnIZqEZjaHr80bgSYurptHS4H91YA/sEORKJ+iMG
         2gqKKG9W6TBtJTDvPCUVSQNP72CEGgJUTS0yJ2oEBdNT5zkr9O2U2H90CPxG1P1iTbWh
         C8gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781454818; x=1782059618;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wF52xqv2gt97ZmYG5q8RS9QpeTQBkGWbTxMLhSV4/qM=;
        b=cbQkKm5Zbp9vBc4IUl17nO1FxsRz1/cKGA7WjfUNyz6e8A4q218gvU8ShqbENGRH/Q
         QN8nDRYLRDB+PlnxqptWyi4j3xCOarEXNWO3lQqu66nY/kqlYZrVt5F4YflpvX86/Rap
         Dm3KlT6lvXbV6Gwa9nzuQbZruCDlBFvaz/X1rp/wyb6RKtDHwxzPkEBvRQF+wobdBP6Y
         7xnKTKrZqlvaC7NtNfMcUAv3Vk4Rbcr0+ruphR2lMya3HOunT73o4Zrq1mIY0QrzwTHi
         0ZgGlDa7my+JIOcXMvmf4rkTAL9wHwRk5T1JgaA/Kv4tBZeO4QNXwKn9iwdBQcbeLXB2
         hQEg==
X-Forwarded-Encrypted: i=1; AFNElJ8kzhhhQVpfNPnkgKuP8jAMLJYbgi8/4rXvKYESNCPRDqxCr+Dfjox0690WnnFTIcsg/hmrTf8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxCV9sxuDRnOkhk8FIYW3tWtnR4unGv8igCe2aDV6QgMteFxIbR
	ODCOCWdqV2fro1a6QLvDCkrhZ3AJnlPUa8Unmy0NFm+lFJsyfPPIgIMB9KL9z9CoTc7WILarhN0
	wrw==
X-Received: from wrnv4.prod.google.com ([2002:adf:ebc4:0:b0:43d:733a:c37e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:6f1c:0:b0:448:7049:a6c9
 with SMTP id ffacd0b85a97d-4606da5a49dmr14309136f8f.5.1781454817370; Sun, 14
 Jun 2026 09:33:37 -0700 (PDT)
Date: Sun, 14 Jun 2026 17:33:29 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260614163336.3490925-1-tabba@google.com>
Subject: [PATCH 0/7] KVM: arm64: Fix missing ESR_ELx.IL in syndrome injection
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
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
path never set IL.
Patch 2 makes the same fix to inject_undef64() in the normal host path,
where IL was derived from the triggering trap's instruction length. No
instruction that reaches undef injection has a 16-bit encoding, so patch
2 has no functional change today.
Patch 3 makes the matching fix to inject_abt64(). Unlike undef injection,
abort injection is reachable from a 16-bit T32 instruction (a 32-bit EL0
task under an AArch64 EL1 guest), so the old code there injects an abort
with IL=0.
Patch 4 fixes the FPAC syndrome constructed during nested ERET
emulation, which did not set IL.
Patches 5-6 fix SError injection in the emulated and nested paths,
neither of which set IL.
Patch 7 fixes a fake ESR used to exit to the host. The host does not
read IL there, so it is not guest-visible.

Based on Linux 7.1-rc7

Cheers,
/fuad

[1] https://lore.kernel.org/all/87pl1t8q24.wl-maz@kernel.org/

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
2.54.0.1136.gdb2ca164c4-goog

