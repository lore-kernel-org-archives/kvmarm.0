Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.73
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208814;
	b=xFyWgeS6bqHNZiKoI3aMSF9BU9mbOjDcsm9K3cfdFHkkXmpsy6EdmJ5zcsa0PNkWJ5N+
	 8H0MowdWubB4dpR3jQpQAlTLaRpdjwa362OvvYz+nujPmiah2bZvekXtvKdTrQcc7pZLH
	 neSKK4UGwswdm+Z/J+MJl9txj15kcddm7tWorXy4HGoYcMHvPRojrO8n+4o5DSPAJrA/g
	 GM4PWpeWORnh9M9XLxRYYcMt+yLSACi5SoaeJ9EJ+D1nDFnmonqHdyt3gU0mf44DEHCTB
	 bCkk+IJYXDjGpNxwvU5fbNVEp+j1/0W5uRAwm3vT/9RcjmvzQEXZkuGP8ceuyoUDkVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208814;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dNmOFP2cirQx+YDQEQMQpytQ7cOmuEPmcGGZd0DDSf0=;
	b=jzkUQrL1EQ5Yy9Ddyuz6kXUn2QZHPtxyX5WQK3Y8zRaUJaKftTnv0R5vUiJvtq0GQ18g
	 Bz9QGSQjgmC1y1BP1PVDXzBbUwp0/IvN3JXKryKzSW+ZYjySaJwesJ/JHcYgxUO+HwRCx
	 BoCOljnpV/h4pNSJpnthlZwKfw3wj6fOGVwFTfY/ezufVnUlo3Nf1blVzCQJZxf95JHTz
	 kDLnmkif3D/HkfK9btvxdDk6Cyresoo1O6+/DHiumEGoJgI6ZsGhHUTJ07mhbWOgYa8pL
	 XPvdssmhopxZYDUHiUTRDvtMK5jgAP0yxE1VcS5Irija716xKreSx91ZEK2SFYHPKZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=siSl1Hy3;
	arc=none smtp.remote-ip=91.218.175.73
Received: from mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D4B606A32F
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 17:33:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01D4B606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=siSl1Hy3
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=BTGGQc4FPmp0Xx9SreLWs1ULHPHd2vAigHga5ye70II=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793208811; v=1; x=1793813611;
 b=siSl1Hy3Cwsxg40/OJDoYSjJpFes5gt8chCTV0GO4pMSayCuyMok4eG3NgMyPrP59zJl0NV5
 2y1vrzBIJprMVWchPdoQHYoO+8T6kKuukG0f90BMbGJMV5IsRINV4z8yWSHQ4Oyw7p1xzah/tBe
 odDrPKg+Ue0dV2+WHT9WAG2I=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d53de949a052cfc7;
	Wed, 28 Oct 2026 17:33:31 +0000
X-Mizu-Trace-ID: d53de949a052cfc7
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
Subject: [PATCH 1/2] KVM: arm64: vgic-its: Clear an unqueued LPI before dropping its lock
Date: Wed, 28 Oct 2026 17:33:18 +0000
Message-ID: <20261028173319.1807811-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028173319.1807811-1-fuad.tabba@linux.dev>
References: <20261028173319.1807811-1-fuad.tabba@linux.dev>
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

DISCARD reads which vCPU's AP list holds the LPI, drops the irq lock to
pause that vCPU, and takes the lock again to clear the pending state.
When no list holds the LPI there's nothing to pause, yet the lock is
still dropped. In between, vgic_queue_irq_unlock() can list the LPI (for
an MSI that had already made it pending, or a GICR_INVLPIR write
enabling it while latched) and its vCPU can load it into a list
register. The guest then takes an LPI it has discarded.

Clear an LPI that no list holds before dropping the lock.

Fixes: e99ff76f4a02b ("KVM: arm64: vgic-its: Remove the pending state of a discarded LPI")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 37059d1338406..42dc71495ad98 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -842,22 +842,24 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 		 * Only an LPI on a vCPU's AP list can be in its list registers,
 		 * which the exit path folds back, and that exit moves the LPI
 		 * to its target vCPU if the target has changed: pause both.
+		 * Clear an LPI on no AP list before dropping the lock, so that
+		 * nothing can put it in a list register first.
 		 */
 		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
 			vcpu = irq->vcpu;
 			target = irq->target_vcpu;
+			if (!vcpu)
+				irq->pending_latch = false;
 		}
 
 		if (vcpu) {
 			if (target != vcpu)
 				kvm_pause_vcpu(target);
 			kvm_pause_vcpu(vcpu);
-		}
 
-		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
-			irq->pending_latch = false;
+			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+				irq->pending_latch = false;
 
-		if (vcpu) {
 			kvm_resume_vcpu(vcpu);
 			if (target != vcpu)
 				kvm_resume_vcpu(target);
-- 
2.47.3

