Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792651603;
	b=iUtraBgQ4fdUnrcIHV2FCn31zIzFeyeKWpCnDOo3BlZeVLdhIx110JCey9J8mxQimtaT
	 21ueXaJ2dTdYWBwCM0jZuNKMwuUu9+J7bzQoovCIpkefhwercdba6Mgl2umkizA/d/TQI
	 3FIRw446VWC98YLMKyYgDFESDMnDB7L4/p6tLn70xhBU8mwKD0/eWjYjHjnqWDKe27enT
	 4ncHrxNUWJWTiTn2JU5W8KOwgMtasodjEcQhs0hC9mdawzeZ1DTk1j8k5G/EkMWyfdNQZ
	 nzw5YaT2nR4lnXJ7b/sa0COK5ahZpS6RGm1qp5YapfVT8oDtJUPyJnQw8teWp1pc2wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792651603;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6hyPiRO1YLgh5z7vpK+8rbMGtfzuaM8kNLxgiQL1q1o=;
	b=ptR56DtdEEYoIJO86KxcnIL4adrGCU58E/Ia9KfLaKJtRbMzCSsLR2LGNkz/1Z5/tVmL
	 8yN9clNc6oeWYcteIxDwFu6XZfynQywwsPF0HbVYTOwy9u1h6PZiVPin+o7Roh2BjnvZv
	 e00xeQgHAjdJbvpOgVyhX57fIfvza2phOJuf9q1sRRupiftVDIftrVZDge0eAaTtuBwyG
	 y4T54XrsG3xI5sydd1ToRGoeFhmxbbQYOSSGCSPRL/E0LsLOOBEoWiwnDfy5DdufAgUis
	 9CNdwl4OdCdZ8mrjl886waL5GiEWrwKWjTxYepHk7IJkia/J3TUmv9rGY/yWT6yJSrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="ai/gLSZM";
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2F5606A31B
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 06:46:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F2F5606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ai/gLSZM
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48dee593f18so1173766f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 23:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792651601; x=1793256401; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6hyPiRO1YLgh5z7vpK+8rbMGtfzuaM8kNLxgiQL1q1o=;
        b=ai/gLSZMFnaLbSr5NdxQ7a1xg3VM2re4uvBJsaD+8L5W61A3nmIGMfsRXINJ/PnU0X
         Ea1tWg6K9ZhQWjIVX5U5ahNk65qUDU75lvSrvJZPr6tW45f55g0TdmXcHj24zKFmkHut
         zDPFoB2RctHQ+y2fcjNSQO1WtUW5GG8dgKzmFtbMrkfFv0Y+ZPuzb87yGZCHxby/ntxP
         ibh7s1YTb+h59+aWfg8eSfy8K73kRhzngT162K5M5fscNHTe24KDGP7duCfTx0Ac0ulM
         ENo5iaMoPoLGVHZa1uXExSB9ULVja8JyKEXC4d5lGNb4UKE8k0yiA1FR+ewE+k9LZiLI
         R91A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792651601; x=1793256401;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6hyPiRO1YLgh5z7vpK+8rbMGtfzuaM8kNLxgiQL1q1o=;
        b=SjWmM9n+mg/cYwXgYx61i4FGGiWsRoUBnhuBTBiQLTn2Vmt8/9iPlkSbZ2Jm+vPpIb
         DqdapZ89yvEelJIQwyGMM9pjAz4pByKO+aaFmtUHFpudxQDp6EFH4KGbf0SYx8mw7c+5
         fheresbA62qto4UMrtnFen7FwswcsJSgZ5gVEnclK61CX3eB0fbg8yPtrmCTIO2TbTqN
         rDwugOv2qKAh9xYnDWvNUrADlBYMYJ9+cnZQ1FL/4rm9Q85xrQqKYV/hKdaWnAjGBqIE
         8QzKjF7ag2iTC0pVkHT8iWV0h9Kb18NufUntbSY37haybofr1u3aoplUu4FWpDOt6dSr
         m/Ng==
X-Forwarded-Encrypted: i=1; AKwUvBySOXv4Sk4994xr9hhFZKYX1pSFtsClde89xXaINu5ZywbhgFrr5zCiuGLSs1+1pWneezSrC24=@lists.linux.dev
X-Gm-Message-State: AFq9FYLLGSK4J0t2QeBtiYuudp2VgwoLZxwLIFXpZlMrZ9EuN6p5M4TK
	z/cURU4j1BTHg19Nsx69hZBEOGRFO/NZOqZeG1gRtJicX0uFYExI5v2b
X-Gm-Gg: AYBFou24jp8Q6i/enI2D8keX1Ho8lNCNMFcAWLnHSEZWfnS4TQiZgZa+4vwN73wRwSx
	0aXNx1LHmKJ6/JIgZVvT09v6iH2/qKBCQY/GMXB1OYS2b3zG6279Jp0XztHEnniWm7F2Eif7lHH
	vpko26EjN31dSUY+0oSTfMPoRtmfMaOAaauxSY+h8chgY9s/JVnHnMOtiSzed6PkZHmcF5gB2zD
	3Ig16pWjMVsUbzq+DWZ4aWpQUNFkJC5c1plFiPE8Shtk9+t2Ls9RLtiXYCkMJHSjFwXadJJeP0v
	PGz1EbWnMia98aRbZTL5yZaavi4M2VRZrWdSr9wjHPdD9OU+SzTuzfMLy+7zXIlm+NYf2WsLM2Q
	5PuGpuhawQOyAf8Pe+XEMAXAAManRB7QgGl2smaLkUiBWhANZvwdh94UhWTajaq6znXx7IlWVwR
	zjOy2uSyCBOqATW8O93Z30NlOY922LU9BesgFDRM4ht4oGo7cDXwiIXenR2eNa5P9kl+yZYgCew
	1tAYAii19p9kZIu/MhGm0HHosFmwEfgNy1GztTmbWwhsPtsanoqMC3GtD0zqwFTECOWRRvOgyu0
	JuDMAMVWAwAIQiX+jhPKL94F/dHW3DSy91L2P65v/hIFNm8eRES1YvS/YCYGxADl+VedDN2xO9U
	CPXy0RRE2xvlyJ8oREK6tp0klJCfXXTW+cmsmdcOmNO5BdFICcN20x/tRuZIsGHRq
X-Received: by 2002:a5d:64e4:0:b0:48b:118e:7454 with SMTP id ffacd0b85a97d-48e264bd971mr9315929f8f.31.1792651600585;
        Wed, 21 Oct 2026 23:46:40 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-ad43-d501-2c28-bb72-120d-420e.310.pool.telefonica.de. [2a02:3100:ad43:d501:2c28:bb72:120d:420e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25828cd1sm10215624f8f.22.2026.10.21.23.46.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Oct 2026 23:46:39 -0700 (PDT)
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
Subject: [RFC PATCH 0/3] KVM: arm64: Preserve level IRQ re-pending
Date: Thu, 22 Oct 2026 08:46:25 +0200
Message-Id: <20261022064628.4206-1-kmehltretter@gmail.com>
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
state used to populate the LR from a later ISPENDR write. This series
records the later write and preserves it across deactivation. The last
patch adds a two-vCPU GICv3 selftest.

The awkward case, and the reason for the RFC, is a write from another
vCPU while the interrupt remains in an LR. KVM cannot know whether the
write preceded or followed the guest ack. This series preserves the
write. A pre-ack write can therefore cause one extra delivery, while a
post-ack write is no longer lost.

The exact alternative is to stop and synchronize the target vCPU
before applying such a write, as the active-state accessors do. Is the
conservative replay acceptable here, or should ISPENDR pay that
synchronization cost?

The issue was reproduced with Zephyr, NuttX and RT-Thread guests. On a
Raspberry Pi 400 host with a GIC-400, each GICv2 guest handled the SPI
once before the fix and twice afterwards. A direct GIC-400 register
test also delivered the interrupt twice. With a QEMU TCG GICv3 host
running KVM, the new selftest failed before the fix and passed
afterwards. Existing vgic_irq and kvm-unit-tests GIC cases passed on
both versions. Those runtime tests used 8623551a424d.

The series applies without conflicts to kvmarm/next at dd0bc00e3e92.
The modified VGIC objects pass an arm64 GCC 14 W=1 build there, and the
selftest builds natively on arm64. GICv5 does not use the LR path
changed here. I have not tested a mapped physical interrupt or VFIO.

Karl Mehltretter (3):
  KVM: arm64: vgic-v2: Don't drop pending writes to active level IRQs
  KVM: arm64: vgic-v3: Don't drop pending writes to active level IRQs
  KVM: selftests: arm64: Test pending writes to active level IRQs

 arch/arm64/kvm/vgic/vgic-mmio.c              |   9 ++
 arch/arm64/kvm/vgic/vgic-v2.c                |  13 ++-
 arch/arm64/kvm/vgic/vgic-v3.c                |  13 ++-
 include/kvm/arm_vgic.h                       |   1 +
 tools/testing/selftests/kvm/arm64/vgic_irq.c | 101 +++++++++++++++++++
 5 files changed, 131 insertions(+), 6 deletions(-)


base-commit: dd0bc00e3e9201fd49b62ff9cc07890c89003afe
-- 
2.39.5 (Apple Git-154)

