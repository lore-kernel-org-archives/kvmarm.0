Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794933432;
	b=orLBYKxkgjZLDVc7gHAlNhGqkFG0i6Kp5ZQvLc4Q+OsCHwglpW/I+zEoZgYJLHf44foq
	 T4wV1gXcJAVxRORdHlHP3jddY89HPgUhY0W4ZS6ZT3MPvMu3/NqXild8Fj+ix81tfvaur
	 l256QC1JPwLwpIwk9D9qj4oebsJ5U65hhZLuYvFuhMtwdr4XfMPEzwfvLuUCIkKf00Q84
	 DBwo7vaOjLxN9WdJSiYebBZpBa7EbP2v5gLA3Ry9sM1IZRZxHs7EouqejVkVZhrPY5kC0
	 J6gxZ6cwqHYJCJ2qnD5UxIsY5tDvr/TLPN5M2AsL3DnT+hAQdEbeJ/lWpD6Rf9tXAdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794933432;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=AuJAo5sXOKJqP6dr35P+8qt11I9icgfuipOCWrKlAKc=;
	b=aIgR4QUv4QGr+S/3zC0HjuOv24Yb3IF12qZ6u8hzVtqSteIpLD412R62g0eerUhwHnic
	 vZ0Czux2SbMPhylfgvlC557hlyEQAn9hyyH8BreZKm/kfjFwX3oSlBv5eiECRu+V/mRzw
	 uKLt1kodudsgxea76tTv9nAm43YAkR5AXpGaLEF04z5TZizBZkbLTRM3VXZob/IwuVw79
	 rcW5xOdi7IzlFWfMeV5riOodxKV1344NZTNIIxdJwF0caBGDkF2k8zjxlHhewYOv4+hOI
	 7gDZYMZFfjsSicGkkiES+zsQrcxLIJkYFD7GoptIuH9FMFGfbkBV25osHa8PhbIjYcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GbGAPRQd;
	arc=none smtp.remote-ip=95.215.58.48
Received: from mta1.migadu.com (out-48.mta1.migadu.com [95.215.58.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207D6606A32A
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 16:37:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 207D6606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GbGAPRQd
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=YdLYpWBKlUKagfnJowyll08aWW+OkxhrNMtlF8HSUF0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794933429; v=1; x=1795538229;
 b=GbGAPRQd7NsoKxEq3lu7fJK0tHJas4EO3nBA0WT82x5ByQ1r7HXsO7tTD7WDySDW8g7UKa+g
 XFSdvfRXIEs3iTqqVvKiEI2Q6o2tIxR2PY6bf+8pU6ub3GjPyXL9kp50ld99dHadS0HEkkj+OLH
 j4j0mess7B+aeX9zKohK7aIo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id adf884b6486dea4a;
	Tue, 17 Nov 2026 16:37:08 +0000
X-Mizu-Trace-ID: adf884b6486dea4a
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] KVM: arm64: Fixes for the host SMCs that pKVM forwards to firmware
Date: Tue, 17 Nov 2026 16:36:59 +0000
Message-ID: <20261117163702.1678277-1-fuad.tabba@linux.dev>
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
  - New patch 1, which stops forwarding the host's SDEI calls.
  - Don't run a protected vCPU on a CPU where the firmware Spectre-v4
    mitigation is disabled, instead of re-enabling it from EL2. (Marc)
  - Track the host's ARCH_WORKAROUND_2 calls with a kvm_host_data flag
    instead of a new per-CPU variable. (Marc)
  - Handle the calls in default_host_smc_handler(). (Marc)

Two fixes for the host SMCs that EL2 forwards in protected mode, which
reach firmware as calls from EL2.

The first stops forwarding the host's SDEI calls. With TF-A, the host
could otherwise register an event handler that runs at EL2.

The second is the v1 fix, redone as Marc suggested. It tracks the
firmware Spectre-v4 mitigation state from the host's ARCH_WORKAROUND_2
calls, and relies on the first patch because firmware restores that
state when an SDEI event completes.

Tested on QEMU with TF-A v2.15 and test-only host changes. When SDEI is
built into TF-A, the host's SDEI calls succeed without the first patch
and get NOT_SUPPORTED with it. With TF-A patched to advertise the
dynamic Spectre-v4 workaround on the Cortex-A57 that QEMU models, a
protected vCPU runs with the mitigation disabled, and the second patch
stops it from running.

Based on Linux 7.4-rc2 (7475ea8b58616; also applies to Linux 7.4-rc3
aebb727447640).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20261113081934.1715497-1-fuad.tabba@linux.dev/

Fuad Tabba (2):
  KVM: arm64: Don't forward the host's SDEI calls to firmware
  KVM: arm64: Don't run a pVM with firmware Spectre-v4 mitigation
    disabled

 arch/arm64/include/asm/kvm_host.h  |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 30 ++++++++++++++++++++++++++++--
 2 files changed, 29 insertions(+), 2 deletions(-)


base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.47.3

