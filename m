Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.213
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793006900;
	b=a/wXaPV7xuEE/W77Xqda5zZmk0Rian/pK05NUtIP4yPG8pkiVu10I5nKQ3HtqPcFLmFu
	 4t2ZyMhm1bilXMrs38PZQ8PenXenvH5XJ1VL/PiSR4TjRsRFGk1SQBHxaqAeTzhqGG+bf
	 WICV3Km5NxK2YqIfChjcwEEFUSdKtzkl5YKlojPClMLrckuAZpr6QVvk5kGA9LPt+GH2v
	 XadmAJdgArV19TPnQrLvY6be472pODmKQe/Fibt2n5/o7lComLgn70jfgW/Grz1PSj14f
	 xju5sUA64+L7JAOUc1XX0HyJhte0yaUL5kQceJwI+omKpzLbLGukokrPD4oI7i6ISZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793006900;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=aaO1/o6pnxKsiPjftPSn0VyBdqvDP2CrGJI/wXBPKS8=;
	b=kN5Ubz/e6fb84IFFaOBwEEE8e1WMFnHT04m0orbhlA3eCruA6yQe3M+gsHZSNTvIa/ls
	 e/l0+Zbcj9SkN6C0dTClT1n3Um5AhfXJaurEOITjRx+Zreq1Q58eczHxdnyQzLzfo+J/i
	 AzhwqYysuZKLfY7taSSUaTuMHYB7N/St/BYSZwW+I64aBJjva3AVh1x4ydGYNDu/TMYxR
	 JvHTtrcB3QemAP/S28b3AC5OvI/u2pVbzoBry15rqK/T0glzlkLwNQ6H6R1AGVMhqGaT6
	 7BunTdU4DRfrgtdm6s26nWrPgl7Nfwt2mHoWKDNZZNIC1OtdvYPAXfU2pg7IjT3hfRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uLqcQBXJ;
	arc=none smtp.remote-ip=95.215.58.213
Received: from mta1.migadu.com (out-213.mta1.migadu.com [95.215.58.213])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B6D606A33F
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 09:28:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38B6D606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uLqcQBXJ
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=b7FM/+nMXV/x5ioStkPEzar8jxQ92kribfVG8dU4gAE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793006897; v=1; x=1793611697;
 b=uLqcQBXJ2QPsjIOQDYcaymoN6M+pgLDm4tM4utVuIqJokKREIhSQsfv3pD1ly1EAiY1HvRlU
 8RFnJ96rmxqQLnKu9Ew0VLYloFypfF38PLMmfhk1JApjaGWTQVp2USKmhSPC5az7UAHGYTr+D7G
 eDo2ejNwuGrm8g8kfTJLOvIo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4732a03f7734264c;
	Mon, 26 Oct 2026 09:28:13 +0000
X-Mizu-Trace-ID: 4732a03f7734264c
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
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
	Eric Auger <eric.auger@redhat.com>,
	Yuchao Zhang <ndaugoing@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: arm64: vgic-v3: Don't drop a pending LPI mapped with LPIs disabled
Date: Mon, 26 Oct 2026 09:28:02 +0000
Message-ID: <20261026092802.2636798-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261026092802.2636798-1-fuad.tabba@linux.dev>
References: <20261026092802.2636798-1-fuad.tabba@linux.dev>
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

When an LPI is mapped, or restored with the ITS tables,
vgic_v3_lpi_sync_pending_status() moves its bit in the target
redistributor's pending table into the LPI's pending latch. Enabling
LPIs on that redistributor resets the latch of every LPI that targets it
from the table (its_sync_lpi_pending_table()), which no longer has the
bit. So an LPI mapped while its redistributor has LPIs disabled loses
its pending state, and the guest never takes it.

While the redistributor has LPIs disabled, copy the bit into the latch
rather than move it, so that enabling LPIs reads it again from the
table. It's still copied into the latch, since saving the pending tables
would otherwise write the empty latch over the bit.

Fixes: 06bd5359549d7 ("KVM: arm64: vgic-its: Read config and pending bit in add_lpi()")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 346bacb3198f2..65b77fb35be37 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -552,7 +552,8 @@ int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
 	irq->pending_latch = status;
 	vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 
-	if (status) {
+	/* Enabling LPIs resets the latch from the table: leave the bit for it */
+	if (status && vgic_lpis_enabled(vcpu)) {
 		/* clear consumed data */
 		val &= ~(1 << bit_nr);
 		ret = vgic_write_guest_lock(kvm, ptr, &val, 1);
-- 
2.47.3

