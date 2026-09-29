Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF1E3B774F
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 09:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790674603; cv=none; b=ifHjbwU/hkpKCW4Fskl3RvkraLFEmMRfXw+GrqdQc+O6tbFO9EI1fBXCEZqZ3tQ//bDci5zt+6DlPNWRXidXTiFUSaFK6y7y7/KrMWQQbQ0NyBi+i4k5DTdeLt1wc1mJmNjKa817tt4srfRHvQTepa2nK6uWqydfX3KqY+bVXiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790674603; c=relaxed/simple;
	bh=ZUzKKwU0YAxlWagHD0FGZ7pRYjHLzYO3NJ/fvPY4mLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQmp9fgK6T/ERZxDwYCinkX1vRHAYsIF56eJlnDxLXEa2vNiPRLlG4krFnJbL8+xt3FXrzSV887U7MB7yoDRwA7JvaPh0y7vD8xGZVTYC7428ENjNsmmKEMKHJZsB6FKKkRkI7PU2eTrHrHD/XXSpqkR6AyTJlqV0i43aDDIpc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VhAvCZga; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VhAvCZga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30121F0089E;
	Tue, 29 Sep 2026 09:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790674601;
	bh=761I7A620DIiMivjhpQoI4k8SlHoZoMAd4PeC0PUiQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VhAvCZgaZ+hxSfL4kW9OW17OZ6HiMNStPbgmA6T8ivGGw5MTLYLLf7+7e05253tMP
	 1qkWplQao5PfupNnzAB2fObV4Nc8oSp5GZyY2a0wHC+FQs7h7RodKkTlR7NNZA5jfC
	 +flTlDXKa/EP7ZaJt36wsime9lIUCwiY234B/fRun3gQTzT8u9RwrYespqm7QetDOo
	 hB2c5ZcI2xu6l4AFZgNzlbZuD/btv8Ch6pw+zqJtvJT3pCiIAdAm9wFTSVF1u+CiCk
	 3gnWRKN7rOEoHkxjpL/ZuBLWJpJCMP28HKTxUcGG2k1JCa+fB0BWEQbh6MhZQ8/LHa
	 6e2OLal1GrU1A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xBUGN-0000000ElEa-49M2;
	Tue, 29 Sep 2026 09:36:40 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Yuchao Zhang <ndaugoing@gmail.com>
Subject: [PATCH v2 7/7] KVM: arm64: vgic-its: Stop the VM when handling MOVALL
Date: Tue, 29 Sep 2026 10:35:48 +0100
Message-ID: <20260929093548.3598547-8-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260929093548.3598547-1-maz@kernel.org>
References: <20260929093548.3598547-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev, ndaugoing@gmail.com
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
index cc02d9b62bd95..094eede267e54 100644
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

