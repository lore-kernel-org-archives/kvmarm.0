Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793163688;
	b=S6mVCXC9F2bWyi8rH7iB5icFAltknJAxlw4httDTrPOE13vqbmyukxbIRZFM5bZeDZ/K
	 HwuxZw3EAo42E3VG3E1oSpTAJtM5gIhp+wGCk7WqzCPufl6f7pPryJsK9BDV0ru+HGM8f
	 7MMVTVdcdTTaK/WownJH30qaa+jUkB8ePXwOE9gIgcmlwUJbK7YMTfxCgRwdKqcF5vHGX
	 qZKPIpDiGZVyOT7f9MUdx83mmkvAyVbHidz28xe2vs6ty7dNJ5LtgzKMcN0JhD78mEjAw
	 8Jcyva990QF6PncI4ej1wGJuon45wcXOeZUzWr89JH91QstA/4Ckendo7ip441kfCvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793163688;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MsI8OZZh9dKz1v392dtfILjaERE3/nyinId1eBUI+OM=;
	b=lnfCfxJJhhEaKyJrvUf054NhBkzDpnVfF9oRtiyKDkd3EivtLUpWPd6IufncO9NIK00w
	 mIO0u8S+KZOefWjh3jsE1t0aYEpohwYwBHZUoOcVZaNjxdAPN3+10+D8XXFcNzfjYBM1V
	 hBt85XZmjzuC98oFOUT21YBhO7U45onD63pCW/JAfgWagjf/ZVWCmaMLVAbz1NXTnZXEC
	 pi6/NOa9bmy7/jkEmaihqwsndmKnfSYix31eIS4qyEQCLKYRDK2mUAQFLsAV7Utj1vIF/
	 QPXq48XQBigpm2bd8A1WUt1XcClAcIqqNFQ6gd3UviFn/HmrcNYPS1XzG/mZKWWTMKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="NbMBl/V4";
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E8E606A332
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 05:01:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00E8E606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NbMBl/V4
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a20bdaf39cso5139095e9.1
        for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 22:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793163686; x=1793768486; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MsI8OZZh9dKz1v392dtfILjaERE3/nyinId1eBUI+OM=;
        b=NbMBl/V4FDysNUu0wU0c3l2712XtuqDENyT8/u2BQ/0Hu/S5VfEoxFZUY3Pa+aVPaG
         zfaFQ4aU8xVIjJ9UV5Bj04n8Fe++vRBP/RG8La3B2nKAbLEMyvP7ZZm79++iwXonQhpr
         P93EQUptKFy/RCCMqR8SYcNewV237z5xFdRjrQagy5kNGOv1Aai7jFyq6qIX9pKcKOvS
         4biT2dPeBYTRWNd0MOVT8gaQTLCcIbxW2a4rK6ZeAfzSl7z9SEbCh3L/GMR45LHLd7XN
         Q7L00WHHU5JTy/iySLO3uDQq47468cEGTDjg6I7GsywyIG8O+Qo8o7qd3xrZsokSptW1
         qc5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793163686; x=1793768486;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MsI8OZZh9dKz1v392dtfILjaERE3/nyinId1eBUI+OM=;
        b=DMn3oc1yVz6BJzVJnNNyYV6Ot5/8k+HJO+IvC5P/WA5tEfp33BYC8GK0uHI6VdO+wO
         nRUXrL2Tiu94aFsdG5ojKJtYx36K1A34J2RZIx9O0HWhycsQx5r0MBnL4OxywBhRlaWl
         5La/rPoGhY8buxnLnIol/fsqtIwL4FPQB+IHFpuM/vFof514BYOrJPdNLceeUERdEekL
         fVS81TtcU0jn/mG3HYNkN16SoaSfKJTsIezEFFzc+jSmNQSzpIIHiZzPu3T5s6dyrYHL
         rcngjZCeIJmRrRX4nh+w61ExIVWQOBlwKvOyXcSsVR6F/YWYMUK5RD1Hq/0Z9cETK9yi
         xiuA==
X-Forwarded-Encrypted: i=1; AKwUvByx8yfqj9dgU2JCQ9WFtKvrSkQOBdrBjfQ+ROF8GJSdWq0Jjro1aNlKeT0tLXbtvWyRm0+aSqk=@lists.linux.dev
X-Gm-Message-State: AFq9FYJy+L8DSNctAgUOJLHQw65gnONWxk4mNPqt4hCv2TiTd7fWi5sL
	L62p5Q+quzDmw3tjnseBy6jb7xvr4mfYWtLHwMGpdO4omrAdnpQKCHAq
X-Gm-Gg: AYBFou2l1cPgBpXEKANw9BkQzj1SMhyb/LUhMunSBVv9iqb6P6qSvOyRyxgh5I3YRHf
	KT5RqazxH0q6HV16C73O63I+kqcHKdf4gADcAd00sCodjUPxlreiPjha0KKV3daMbbV9HrL1MKV
	5nW79XHmiR0iS0OUAzwBVc6EKklDxhf6QzodA9EhxYDoJ/ZNukhZuCaNopy8iMW4+0yUkULfyi9
	5usvUFNoZ086lzS8o4gOurb0LkAFC6SSnJnzXsapcnDlCjmCkQMLEJpHy/tuTW0ATfBfD36dcrQ
	EQZbEO/uO6g5ccv9vPQvQ0t1pOT+jEWDpGVBHLuO3jWCL0yO4de+8ycUvqNq41vKvFgo81as4lH
	G2k2uJBuriHPDDUdG+ss0weeG1H9u5ZwuMaTSLOqhlyC8vVdZiMVk+jClPjTLMxd/h1kzyeUXnI
	0egBJ/ziKvgcFdFLAO1Crht6DrDaIs2jHTrMvRo2R5xHFU4HBDB0tO5fS+GpuLdlb8ETlhNuyDg
	E0JE1B2IyvnkATWwIJxdyiw6YgxvMbG6TYTa/bTcRg2YSTq7inSTAunT3d0oXkE9tT7+7dSgeVO
	7zwBvNGzqri4MC+JNfcxpd4Nb+JSLAi0I8auLxRS0MwfLVfd7YnUuGNp5SIRChniSiirlJDlu4f
	ri/UbE/Rc4T/Y8COotns7YXThvp1Th5O6L1RQUEiF3XDe84/YGYMaQKinVG42dxEpRl0gIwBE1/
	NXE/8Fb2llCDfNJcaoFWw/9WPdgSt5mdyNS9Fv7A==
X-Received: by 2002:a05:600c:c117:b0:4a2:cbe:beac with SMTP id 5b1f17b1804b1-4a9672f814emr15602045e9.23.1793163686125;
        Tue, 27 Oct 2026 22:01:26 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a45b-7d01-5035-b393-698f-53f0.310.pool.telefonica.de. [2a02:3100:a45b:7d01:5035:b393:698f:53f0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a94eb8a60fsm13523365e9.3.2026.10.27.22.01.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 22:01:25 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] KVM: arm64: Preserve level IRQ re-pending
Date: Wed, 28 Oct 2026 06:01:10 +0100
Message-Id: <20261028050113.10046-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
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

A guest can set a level interrupt pending again while handling it. The
GIC records Active and Pending and delivers the interrupt after
deactivation. KVM instead drops the second pending state for both the
GICv2 and GICv3 backends.

The VGIC keeps software pending state outside the LR because commit
67b5b673ad4d stopped placing Pending and Active together for level
interrupts. When the LR is folded, KVM cannot distinguish the pending
state used to populate the LR from a later ISPENDR write.

Synchronize the target vCPU's LRs in vgic_mmio_write_spending() with
vgic_access_active_prepare() and vgic_access_active_finish() under
config_lock before setting pending_latch, as suggested by Oliver Upton.
When a vCPU writes its own GICR_ISPENDR0, this synchronization is a
no-op. For shared interrupts or remote redistributor writes, stopping
the guest folds any prior ack from the target vCPU's LRs before the
new pending state is recorded. In the v2 and v3 fold paths, clear
pending_latch when an LR populated for an inactive interrupt no longer
reports a pending state, and preserve a latch written while the
interrupt was active.

The last patch adds a two-vCPU GICv3 selftest covering same-vCPU and
cross-vCPU re-pending while active, as well as a cross-vCPU ISPENDR
write before the ack.

The issue was reproduced with Zephyr, NuttX and RT-Thread test harnesses
that configure an unused SPI as level-sensitive, pend it via
GICD_ISPENDR, and re-pend it once from the ISR before deactivation. On a
Raspberry Pi 400 host with a GIC-400, each GICv2 guest handled the SPI
once on the baseline and twice with the RFC fix. A native RT-Thread run
on the same GIC-400 also delivered the re-pended interrupt.

The v2 change was A/B tested with RT-Thread's direct and mailbox-pic
reproducers on Linux/KVM hosts running under QEMU TCG with GICv2 and
GICv3. The baseline lost the second event and v2 delivered it. The new
GICv3 selftest also passes in that setup. I do not have a physical GICv3
host, so the GICv3 testing is emulated.

Changes in v2:
- Synchronize target vCPU LRs in vgic_mmio_write_spending() via
  vgic_access_active_prepare() and vgic_access_active_finish() under
  config_lock instead of tracking on-LR writes with a separate
  latch_written flag (Oliver Upton).
- Extend the selftest to verify that a cross-vCPU GICD_ISPENDR write
  before the ack merges with the initial pending state without causing
  a second delivery.
- Drop RFC prefix.
- Link to v1: https://lore.kernel.org/r/20261022064628.4206-1-kmehltretter@gmail.com

Karl Mehltretter (3):
  KVM: arm64: vgic-v2: Don't drop pending writes to active level IRQs
  KVM: arm64: vgic-v3: Don't drop pending writes to active level IRQs
  KVM: selftests: arm64: Test pending writes to active level IRQs

 arch/arm64/kvm/vgic/vgic-mmio.c              |  76 +++++-----
 arch/arm64/kvm/vgic/vgic-v2.c                |  10 +-
 arch/arm64/kvm/vgic/vgic-v3.c                |  10 +-
 tools/testing/selftests/kvm/arm64/vgic_irq.c | 140 +++++++++++++++++++
 4 files changed, 197 insertions(+), 39 deletions(-)


base-commit: dd0bc00e3e9201fd49b62ff9cc07890c89003afe
-- 
2.39.5 (Apple Git-154)

