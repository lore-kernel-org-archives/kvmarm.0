Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C4A30D3F5;
	Mon, 15 Jun 2026 18:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781547402; cv=none; b=n7EIYIfgFZV1fgQNYOAY5FzScm10w8ptr4u+rFVIm3vjl01fOaP8ZAuYy8J0/iSJg6yVEcZDz7UQotVFFr7ifPpwi1GHRTvaInoHke6Mm0sXlLa9XNYbUq+Lo64MK79UmmGjwyCooiBYjqaOWOOeODj1YNcZUNQw/6ZcrYVVcxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781547402; c=relaxed/simple;
	bh=uWwIAy6pbKPxk96H+YT+8V2yQBj3yOvAXCuDZgzcMg0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EK25YpOjgSst58ZSOhhZpyvXjeLVlraxbNPX79qI4i1CKwo0linFTKpywi7vOuLmrWoayp/9IWtzxoTisWwB33nXq0poDRpwwV2HL0GIECwQ0z+RDeV+ZuAutYsmyrv5I/Dca250UgZYCw0BDJDGvM25yVU5SD5RYqBs0/L5Nhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UvnOPzvN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UvnOPzvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423E81F000E9;
	Mon, 15 Jun 2026 18:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781547401;
	bh=n1eaaaLhHfOFbxAJagGnDrxVIWvFH1LsKNYnm8c+v3M=;
	h=From:To:Cc:Subject:Date;
	b=UvnOPzvN76/moeBApU72HK7x5mIN+qxqSJRw6nO6E20ymNPinnLpqicky+C69tMmr
	 a0l2Vd3YpJRp4NR3W2O0m/cpiWK8pgt7OrVksP6uR6LF7Bbk4cZRWN9i0JX5xQE6ik
	 WIjAHYK2Hbmv8WPl9xBbehG8xKP7gPXwV2X/WM/KVW92UY/eD75gv4oIs/t0pA7SUc
	 fXZs06tsBvbOdAvOz9GnU5+zr4n1LBKghy7j3xPcx5bEcVc/7xv4hhh74BuTz2/M1x
	 TPZtqN6QBhJcNlWXqN/25Ep69tfLS3NlkX6OVPxGaS0AVjtQlQLu3RtqRB15U9cr8n
	 wi9epXyovYl8Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wZBrS-0000000D2dy-33YN;
	Mon, 15 Jun 2026 18:16:38 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Hyunwoo Kim <imv4bel@gmail.com>
Subject: [PATCH] KVM: arm64: Handle race between interrupt affinity change and LPI disabling
Date: Mon, 15 Jun 2026 19:16:25 +0100
Message-ID: <20260615181625.3029352-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, imv4bel@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Hyunwoo Kim reports some really bad races should the following
situation occur:

- LPI-I is pending in vcpu-B's AP list
- vcpu-A writes to vcpu-B's RD to disable its LPIs
- vcpu-C moves I from B to C

If the last two race nicely enough, vgic_prune_ap_list() can drop
the irq and AP list locks, reacquire them, and in the interval
the irq has been freed. UAF follows.

The fix is two-fold:

- Before dropping the irq and ap_list locks, take a reference on
  the irq

- Do not try to handle migration of the pending bit: there is no
  expectation that this state is retained, as per the architecture

With that, we're sure that the interrupt is still around, and we
safely remove it from the AP list as it has no target at this
stage (unless another interrupt fires, but that's another story).

Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Tested-by: Hyunwoo Kim <imv4bel@gmail.com>
Link: https://lore.kernel.org/r/ailsCnyoS82r_QRz@v4bel
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 5a4768d8cd4f3..70a161383e5a6 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -203,6 +203,7 @@ void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
 		if (irq_is_lpi(vcpu->kvm, irq->intid)) {
 			raw_spin_lock(&irq->irq_lock);
+			irq->pending_latch = false;
 			list_del(&irq->ap_list);
 			irq->vcpu = NULL;
 			raw_spin_unlock(&irq->irq_lock);
@@ -792,7 +793,11 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 			continue;
 		}
 
-		/* This interrupt looks like it has to be migrated. */
+		/*
+		 * This interrupt looks like it has to be migrated,
+		 * make sure it is kept alive while locks are dropped.
+		 */
+		vgic_get_irq_ref(irq);
 
 		raw_spin_unlock(&irq->irq_lock);
 		raw_spin_unlock(&vgic_cpu->ap_list_lock);
@@ -836,6 +841,8 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		raw_spin_unlock(&vcpuB->arch.vgic_cpu.ap_list_lock);
 		raw_spin_unlock(&vcpuA->arch.vgic_cpu.ap_list_lock);
 
+		deleted_lpis |= vgic_put_irq_norelease(vcpu->kvm, irq);
+
 		if (target_vcpu_needs_kick) {
 			kvm_make_request(KVM_REQ_IRQ_PENDING, target_vcpu);
 			kvm_vcpu_kick(target_vcpu);
-- 
2.47.3

