Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208809;
	b=CQ39zpG67oVBtvfQVOKwyTeepmxjoiWsYT0bKTyYXE9BK6cq/ky6WYSy4X6eAkRD9f/R
	 +5X56PWhpPGJBXq/cw3N76HJZGT62HRj2Z+CCAPh6tTx8scd8xHpCA2Vkxb9mGKt4yYGv
	 23UEDKqXZqyi5g5ja1Ld3XEIFqHG3XfmGaF+OlZOzkwshIh1/4xdvN3utAOWVzgIk9S8g
	 GTAK9qfULQGJD1O0M9657AcglQ70M2NoIjMji+l5rAT0kiB2CWmaGRP2W3pWVzAp9OOs9
	 lv2kZpRwGhHY2IoZLvd0D46JKEqjIYxdp0MzZoSrrTasQ+ndqGybWAl057aPU9urBzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208809;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=O9rfZ0Jd16n3nkrrXaqreL+BHcitQpk1LeDPhsNkX+I=;
	b=vGf+tq/Nu/Cnm9mugxwr78uhkzS6Y5gqkgTZWcnYuID+yRMCMcaiER908o/MkDNfdq48
	 Tj87U8+fs93N1kFgqqrpYZ8xLHU20fQIk38Yl/cV1A7dFy9VUHaoffqEMUwT+g0qmKXxJ
	 prVLw0kmkwK1lYKCKDBO+mH73iNJAsNZjO71q0sBcSetKWmTlXhzc8zDAgzl+sXX2YQzu
	 HKVafgn616B0kRjzeb3ZesbfbXyRWbXw/SHBMdCEx/O46X00aCQPve+wfRcz0TY90sFcJ
	 MI+DHnTYv7xQpCPxmXsqyNtO5r233PT3GYMQp8EjuXFiX35cf5psVHheoNS/pb5oMQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YlQYXeA+;
	arc=none smtp.remote-ip=95.215.58.92
Received: from mta1.migadu.com (out-92.mta1.migadu.com [95.215.58.92])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6BC606A31E
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 17:33:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F6BC606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YlQYXeA+
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=yzH4AdgVGm2MfoIvt0cfXKSp7A6q9PsvkvtvOKVlIks=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793208805; v=1; x=1793813605;
 b=YlQYXeA+FXvQn5/0qo5wxwK/k+KnPMXUywJ4MFyb6BAqWttR1hy6yZgF5zoj/j89osbfrcs4
 zRbbaGPdVZFCoXMknnt/NmtLzy6b153fddpB9QRprhrcDKsOfgB2dzz5DVWOdVshuibQOFpCm+X
 auN1YCpLlsSNM+u4yf8UZDtI=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 6625fb773fa39b9a;
	Wed, 28 Oct 2026 17:33:25 +0000
X-Mizu-Trace-ID: 6625fb773fa39b9a
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: arm64: vgic-its: LPI pending-state fixes for DISCARD and CLEAR
Date: Wed, 28 Oct 2026 17:33:17 +0000
Message-ID: <20261028173319.1807811-1-fuad.tabba@linux.dev>
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

Two follow-ups to my DISCARD fix [1], for LPI pending state that KVM
keeps after the guest has removed it. Hopefully in time for the next
fixes pull.

The first closes a window in that fix in which the guest can still take
the LPI it discarded.

The second does for CLEAR what that fix did for DISCARD. Without it,
the guest can take an LPI that it has cleared, and a racing CLEAR can
trip the WARN_ON() in vgic_v3_compute_lr().

In my reproducer, the guest takes the LPI after the CLEAR in every run
without the second, and doesn't in any run with it.

Based on kvm-arm64/cross-vcpu-sync as merged in kvmarm/fixes, which both
patches build on (e99ff76f4a02b; also applies to kvmarm/fixes
79f3724ca8913).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20261013081646.933312-3-fuad.tabba@linux.dev/

Fuad Tabba (2):
  KVM: arm64: vgic-its: Clear an unqueued LPI before dropping its lock
  KVM: arm64: vgic-its: Remove the pending state of a cleared LPI

 arch/arm64/kvm/vgic/vgic-its.c | 65 ++++++++++++++++++----------------
 1 file changed, 35 insertions(+), 30 deletions(-)


base-commit: e99ff76f4a02be8542e2c3ecc8843d7339a0200d
-- 
2.47.3

