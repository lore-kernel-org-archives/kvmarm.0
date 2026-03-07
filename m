Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8462E156661
	for <kvmarm@lists.linux.dev>; Sat,  7 Mar 2026 12:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772884954; cv=none; b=mjWMlWitjgEfbg8Jm55Pe0ZKKFQxpgKBsMFQialmbb+pzmSE/U1yoeof12rDqzR+A0aRBc+pfVOeFJPeqQ81oHZ0fehjNzBPas6PztXW+XF95GwRkayUuCunm8HaFvZUW7gio9J3Y5JbmKz5XkxRCFjuLSnVPoAWJ3nFmiSCeFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772884954; c=relaxed/simple;
	bh=ZMGMoK71DW20ifGmPRAf0tsM9kerlbBDYGNdYE6Seuk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oExvUutxNPqItdrHBCNd1DjES50eM9ncgfngyaQA+qeP2y8hDclALpU5oWgpvbaFH5m5Yv7FDjCd4tFLCeCmZ7DZFWjkE+caJ57+seWSal8TshjmF98IGshKS8enM+8Pi7bAWzDvYreubG2fCywkGErvCnZ0HzdDcBVD0MIUWzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=UJB3qnuX; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="UJB3qnuX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1772884951;
	bh=ZMGMoK71DW20ifGmPRAf0tsM9kerlbBDYGNdYE6Seuk=;
	h=From:To:Cc:Subject:Date:From;
	b=UJB3qnuXI42oSBRk7xI1SOpFfXw381UJW+gSgAWuqkwXiXKeDrKfy5IB533dkr+xb
	 62gAw8gDof7m7vhVQLFudvWzXLXOqXc/QneNxxxnBN01O/nD+0f0rtkOA5lA1R3fA8
	 AHj+714VMoBUtxPXPMThbMrbPThEFnBqQG/uJMb3ZCaJMohZADOEWa+n5dLKXHOaqo
	 C+mnP80vwN0VOXMsQcOA2bFPVBoljmJW4UFsRFqQDZfpUJj9Mo5rPx6Q3ld1lhzvfO
	 5+1BXaZYyy4NMSYHggb5dNNimDURXiVkkB3sWqAeSFY+5RQGICdNM/glOw/YgAd+xg
	 GBD0YtA9JMjFQ==
Received: from thinkpad (20014C4E2782E40079F207E35B989CE7.dsl.pool.telekom.hu [IPv6:2001:4c4e:2782:e400:79f2:7e3:5b98:9ce7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: valentine)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 33A4317E12A2;
	Sat,  7 Mar 2026 13:02:31 +0100 (CET)
From: Valentine Burley <valentine.burley@collabora.com>
To: maz@kernel.org
Cc: tabba@google.com,
	broonie@kernel.org,
	Valentine Burley <valentine.burley@collabora.com>,
	stable@vger.kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	Sascha.Bischoff@arm.com,
	sebott@redhat.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: Skip interrupts in LRs during EOIcount replay
Date: Sat,  7 Mar 2026 12:59:50 +0100
Message-ID: <20260307115955.369455-1-valentine.burley@collabora.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 05984ba67eb6 ("KVM: arm64: Invert ap_list sorting to push active
interrupts out") allowed active interrupts to be evicted from LRs to
make room for pending ones.

When an evicted interrupt is deactivated by the guest, the GIC
increments EOIcount. KVM replays this by finding an active interrupt
in the ap_list to deactivate. However, the replay logic may pick an
interrupt that is currently residing in an LR, leading to a spurious
deactivation and leaving the actually finished interrupt active.
This results in interrupt storms and boot failures (seen in Cuttlefish
guests on Qualcomm SC7180).

Fix this by skipping interrupts that are currently assigned to an LR
during EOIcount replay.

This allows booting Android VMs in Cuttlefish again.

Fixes: 05984ba67eb6 ("KVM: arm64: Invert ap_list sorting to push active interrupts out")
Cc: stable@vger.kernel.org
Signed-off-by: Valentine Burley <valentine.burley@collabora.com>
---
 arch/arm64/kvm/vgic/vgic-v2.c | 14 ++++++++++++++
 arch/arm64/kvm/vgic/vgic-v3.c | 19 +++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 585491fbda80..821cf5bc30da 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -135,6 +135,20 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 			      irq->active))
 				continue;
 
+			bool was_in_lr = false;
+
+			for (int i = 0; i < cpuif->used_lrs; i++) {
+				u32 intid = cpuif->vgic_lr[i] & GICH_LR_VIRTUALID;
+
+				if (intid == irq->intid) {
+					was_in_lr = true;
+					break;
+				}
+			}
+
+			if (was_in_lr)
+				continue;
+
 			lr = vgic_v2_compute_lr(vcpu, irq) & ~GICH_LR_ACTIVE_BIT;
 		}
 
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 1d6dd1b545bd..00d9bc39bffb 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -179,6 +179,25 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 			      irq->active))
 				continue;
 
+			bool was_in_lr = false;
+
+			for (int i = 0; i < cpuif->used_lrs; i++) {
+				u32 intid;
+
+				if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
+					intid = cpuif->vgic_lr[i] & ICH_LR_VIRTUAL_ID_MASK;
+				else
+					intid = cpuif->vgic_lr[i] & GICH_LR_VIRTUALID;
+
+				if (intid == irq->intid) {
+					was_in_lr = true;
+					break;
+				}
+			}
+
+			if (was_in_lr)
+				continue;
+
 			lr = vgic_v3_compute_lr(vcpu, irq) & ~ICH_LR_ACTIVE_BIT;
 		}
 
-- 
2.51.0

