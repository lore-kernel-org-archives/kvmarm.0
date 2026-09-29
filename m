Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE78D4E2F08
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 21:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790717373; cv=none; b=DkARy5Hsb+nXrfTRYyjbWzMRDLD4K3es4wfvhwF8srAXJBfrg7hQZ8jecSD5nL3e9nokCmQUXzEaft/fJsQ81zAFWEAETJC1xKQaKg1DDei7xsF2Nd3HMSzLbQJYX6fy9WCzJXWuBdaiZYVeHPdSjrwk4NQhqlCkKPclFNTwpTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790717373; c=relaxed/simple;
	bh=YhKzDImeloyssti3qJDEqAn+VZe6uGShVZ2cTBoH4yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCsKJEx7E6sDJhrkukePPvPKpQmnT+C0iyWYMGhxauQuJoCvXpytLqhBOcQBsonPAerDFkZaNApG5eM1kOjW6kb8Kn+gFaTGe9bSSr3qVwoO7OqZKaSDTsxEPI6AU5DGbeQhUDdqwKojPxnUqMrvsTrzfLjhelc3rLp8MOzPU7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N36Xm1ay; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N36Xm1ay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FFF1F008A0;
	Tue, 29 Sep 2026 21:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790717371;
	bh=SN5lEZCsQDogXTUu1c62Zc9g2B7igAnydWoBbxd4h2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N36Xm1ayAgwWf9qd0z/I2JcCkJAI0JKsqbiMq0QLy6MLBUGSCIPDxeLcuL/6s9Yrj
	 xlz+Uc9JgSfOyeebYd/DRYwz0E6Eftv8SlfRmvKrrHuhpBIKpSbvojQo6LnvYlRX9h
	 BlsarqwgXh5WZfijmtHLOqD7qsKInUkEIZzQkPCUa0p2zdjnq5vPcPrOGlbM8eHedD
	 WRPA48x97dxLqql/OtiSbJA/FPMQfe9NIi5VvZVPAyvodFO4i0qAyrAq3MRbVZPDcB
	 31Z0Hs2j+uwyuTQux7WkDc8cYLIKyvo7IpTmNZcmw9j/6HlwmLp+BNB3UwifehfL/1
	 nlh69Qyfo3RLQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 4/4] KVM: arm64: vgic-v3: Pause the source vCPU when processing MOVALL cmd
Date: Tue, 29 Sep 2026 14:29:25 -0700
Message-ID: <20260929212925.31775-5-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260929212925.31775-1-oupton@kernel.org>
References: <20260929212925.31775-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We currently pause the VM to process a MOVALL command to avoid
undesirable contention on the AP list with guest entry/exit. This is no
longer quite as big of an issue, as the migrations of active/pending
IRQs no longer happens in vgic_prune_ap_list().

To cope with this, vgic_update_lpi_affinity() may pause the source vCPU
internally for a pending LPI to remove it from the AP list. Since
keeping the vCPU paused for the duration of the MOVALL command can
reduce the overhead, relax (but preserve) the VM pause to only pause the
source vCPU.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 585df69d1ffe..4e4970944ee0 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1382,11 +1382,11 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 	/*
 	 * Bulk operations such as MOVALL are a pain, as they can clash
 	 * badly locking-wise with other vcpus entering and exiting the
-	 * guest, should they be affected by it. Stopping the guest is a
-	 * safer bet to ensure uncontended access and ultimately forward
-	 * progress. Yeah...
+	 * guest, should they be affected by it. Stopping the source vCPU
+	 * is a safer bet to ensure uncontended access and ultimately
+	 * forward progress. Yeah...
 	 */
-	kvm_arm_halt_guest(kvm);
+	kvm_pause_vcpu(vcpu1);
 
 	xa_for_each(&dist->lpi_xa, intid, irq) {
 		irq = vgic_get_irq(kvm, intid);
@@ -1400,7 +1400,7 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 
 	vgic_its_invalidate_cache(its);
 
-	kvm_arm_resume_guest(kvm);
+	kvm_resume_vcpu(vcpu1);
 
 	return 0;
 }
-- 
2.47.3

