Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.119
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793865380;
	b=mNzozOrPmD+9OlBWZJ+mtx53cAX6KF437/DpeqaQusgPSDAxyeS/teIKQOQrFDdVN6Ub
	 3uc3+VGZ+xo98uB2AGzaGbOC+vY+YmOD91nqP0uk5fByetSmt/6JeJCnL1aL78Xpzxe1f
	 Gxb2PUbuF90eag9VmcF5jOsSdGZ8gRj6MSpOdkvTeIbkqEau3W4c5mIMjtaEkdZlLxC8A
	 Us2zXdX5ZamMuGL/Rtar2LZVFm2B9h/VJY88AbalZo0tRT8p8oqBuGtzALGcSlpTUXr5G
	 LbuT9n3673VyOcY2dtq36IhX8ab8szcneK99Izyg5VMf+2mcjDPuhNvh5I4Q9qrr1Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793865380;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=WYKLhjZojkV/Tmsr5BGvWu2TVcuinj9/B2ZB1xR8yqQ=;
	b=aPC0mSFJv8AzBnrwIK+KdizlFcW3iBhA8ZcPeI0SCr3UoSp2YnB9CUZJWrJmaVbtQR9I
	 fFGojtYxxWzE8m4fESgUu9BClesgbbB1Xl6BzxlBdJGvyQ5gBrUKxFz/BSWme2KttbMrM
	 Tj1Z0R3eB/78hIsi+C0EoNnzTVU5VZRcV6HibCQGdFdI9wX6FQJxenZDdwqcCz8gI0/Wl
	 Hy0UB9a067V6t2ah2Qw1/ZwmMjwQ1X6e+9HHWWgRkrNlZcOa5mzTTWvZyOrXbVf2Yvkvj
	 +J/sRpueL5y+e2OI20+2eQsshF+l6EVeAqKG7/V8hPznpVlnLd8tJI48u5hfqWUBupw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fYBfivp2;
	arc=none smtp.remote-ip=95.215.58.119
Received: from mta1.migadu.com (out-119.mta1.migadu.com [95.215.58.119])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7991F606A32E
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 07:56:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7991F606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fYBfivp2
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=k9y24bW4jo8B40iHLCIlVJwO4M8UIaQgR1LB6bPJ2yc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793865371; v=1; x=1794470171;
 b=fYBfivp2nsHXnzHfCaZu2p4VvmARdAKyhzKpFcorw9fQJ3KMvFxuByEbdejQ7hQ/Qpo0G8sv
 PYz7ZtNuMQCFJ7li90DL/bjY1uO0fZDw+DJ4Ei2bgEdGR/bedx5bGdnwqqqaX/3Kt0bRMWwt+1o
 rA+7J/Y7hWrnG8kFnuThfOLY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 36aa00a02140456e;
	Thu, 05 Nov 2026 07:56:11 +0000
X-Mizu-Trace-ID: 36aa00a02140456e
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Martijn Bogaard <martijnbogaard@google.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] KVM: arm64: Honour KVM_VM_TYPE_ARM_IPA_SIZE under pKVM
Date: Thu,  5 Nov 2026 07:56:03 +0000
Message-ID: <20261105075606.367005-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Changes since v1 [1]:
  - Dropped v1's kvm_get_ipa_max() patch. EL2 checks the requested IPA
    size against a copy of the host's limit taken at init.
  - Added patch 2, which aligns the PGD of EL2's selftest VM.
  - Rebased on 7.4-rc1.

pKVM ignores KVM_VM_TYPE_ARM_IPA_SIZE: every VM gets the host's IPA
limit, and an out-of-range request is accepted. So the vgic_init
selftest fails on any pKVM host whose limit exceeds 40 bits.

With patch 3, a VM gets the IPA size its VMM requested, and EL2 rejects
one the host itself would reject.

Patch 1 rejects a PGD donation that isn't aligned to its size, which
crashes EL2 today. It's first because patch 3 lets the host choose
that size. Patch 2 aligns the PGD of EL2's own selftest VM under
CONFIG_NVHE_EL2_DEBUG.

A VMM that requests less than the host limit now gets that size. One
passing the default type gets 40 bits. On a host whose limit is below
40 bits the default type is rejected, as it is without pKVM. kvmtool
and QEMU request the size their memory map spans, and crosvm the host
limit, so none of them places anything beyond its request.

On QEMU, with 7.4-rc1 as a 64K/PA_BITS_48 pKVM host on a 52-bit part,
KVM_RUN fails on a 52-bit VM's first access to a memslot above 2^48.
With patch 3 the guest writes through it. The same kernel, with
CONFIG_NVHE_EL2_DEBUG, panics at pKVM init on cortex-a57, which patch 2
fixes.

On an M4, whose limit is 40 bits, pKVM now rejects a 44-bit request, as
the M4 does without pKVM. A protected kvmtool guest there boots with the
32 bits it requests.

Based on Linux 7.4-rc1 (6628e7d4c6b25).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260917091826.2639205-1-fuad.tabba@linux.dev/

Fuad Tabba (2):
  KVM: arm64: Align the pKVM selftest VM's stage-2 PGD
  KVM: arm64: Honour the requested IPA size under pKVM

Quentin Perret (1):
  KVM: arm64: Check PGD alignment when creating a pVM

 arch/arm64/include/asm/kvm_hyp.h      |  1 +
 arch/arm64/kvm/arm.c                  |  1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c        | 34 +++++++++++++++++++++------
 arch/arm64/kvm/mmu.c                  |  4 +---
 5 files changed, 31 insertions(+), 11 deletions(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.47.3

