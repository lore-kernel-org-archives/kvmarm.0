Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4DE4EA378;
	Thu, 15 Oct 2026 10:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792058748; cv=none; b=I00BTLPYiMgIOKNL4GtD6zJUXgGoMTLNEmSGgofatGLGq0BmLy0gP9bHiQ+1fCTXuXqeF4Dr9+/2I0uiVI0e3porcfsNGYhxcOh4Pk/eL98VI38wfo7GpRxq+lIQIJ7j2EWHYNHK/AdtD3UyALRB/cETIG7T3EQCdIZyWNGcmqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792058748; c=relaxed/simple;
	bh=U27namRpi4/wWGns8pSG7CCZ4YSukfA4vitqil/Y4bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDJVuaZcTWmlhEdD+uhJyR0ju5fR25GsmZw1sWJnktTrVwlYwYMWXwlgeHt8HPBLaIYVmeoEreizX8Fq2qkzCwpgi7lvOhzwusUTWM4KfUl8HaFEoK03AuNgiHzz9VAo6H0Ac/t+4RWrCvOS/eYgdylZ4sfchONa2YWKkXMgOt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OsjQ35gk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OsjQ35gk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EE01F000CB;
	Thu, 15 Oct 2026 10:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792058745;
	bh=XYZtliE6jqQGjnSKE/8fS++RZfkDgdjeis6gl9kgVeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OsjQ35gkeRZ6hw66X+lFuG/J1fzbOQ9ia5uYS9ENSDH96RiRkuLoew1zqU4HTx9hy
	 7m/jxCXLO42Q1jtblaUFUv5KH8tCYfsBjElCDEy1TCoNRWizLIOxGkk7SEf8u+FLZ3
	 QKNkbWOxEteOd/jG0mCINpgrxcwh4ej97RrRJdlg8JRCrWH9wRhuBxvs2qEsNXcXNl
	 JHgaTc4DrlIf+guByYrzpRQ8mOjh3mjuyy6muVpsrRat0h/54hc/wVMkv+K8ES23mH
	 9naYX4ZsgAcVIHRBnf56dqx76EmWGMkitYkjb1PwE6QUsJaZgbWHrDbzNZ75PV5/+J
	 JIq7yngDAmocQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xHILI-00000003EfK-0Vlu;
	Thu, 15 Oct 2026 10:05:44 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH 7/7] KVM: arm64: vgic-its: Stop the VM when handling MOVALL
Date: Thu, 15 Oct 2026 11:05:39 +0100
Message-ID: <20261015100539.1011760-8-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261015100539.1011760-1-maz@kernel.org>
References: <20261015100539.1011760-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

MOVALL is a royal pain, as it requires us to iterate over all the LPIs
and move them around if they are on the correct source vcpu, and
requiring locking for each of them.

This locking can result in contention for vcpus that enter and exit
the guest, and hinders forward progress. In order to make sure such
process is not contended, just stop the VM altogether.

Nobody in their right mind uses MOVALL anyway, as this is a rather
braindead aspect of the GICv3 architecture.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index c10a11373e106..a9949ab4e4133 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1382,6 +1382,15 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 	if (vcpu1 == vcpu2)
 		return 0;
 
+	/*
+	 * Bulk operations such as MOVALL are a pain, as they can clash
+	 * badly locking-wise with other vcpus entering and exiting the
+	 * guest, should they be affected by it. Stopping the guest is a
+	 * safer bet to ensure uncontended access and ultimately forward
+	 * progress. Yeah...
+	 */
+	kvm_arm_halt_guest(kvm);
+
 	xa_for_each(&dist->lpi_xa, intid, irq) {
 		irq = vgic_get_irq(kvm, intid);
 		if (!irq)
@@ -1394,6 +1403,8 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 
 	vgic_its_invalidate_cache(its);
 
+	kvm_arm_resume_guest(kvm);
+
 	return 0;
 }
 
-- 
2.47.3

