Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D584C30569F
	for <kvmarm@lists.linux.dev>; Sat, 19 Sep 2026 12:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789821116; cv=none; b=r4+UBT5l0Vy4Tfu3cVrUP/CJ/vjAAQwlXWCfwWZFTPEdqjc6dJwAbVP7gqamiNW3O5TUJalHZm8XNj2YAOa9u9qRxPQ1B05nIvTBvNQs7ddU7W/ZOwOPbYebqn7vfqH3vhMIvjYpGHbgqy6uugstrtm9bkq6EgjeyNUr2AoAeK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789821116; c=relaxed/simple;
	bh=VWN+2+MqriYYrdZWtL+5vM/PUAUMQphVaOxndkNS0h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7LH04IKm2d58OOH2+3PjTg/8U6oo3te8mz3daJTEIxVtOW9HUJm+b+z54PxHXPnWe81sisrJnUb4i+1rKYGZbhswrsC9Gt+7FKwzdKjNWtEg8vE7mboVYWOkF1RSVjXJpjikHrOrdVfFWNd8Z3nWMiDguxuyMmWjNXErT9OlQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OJwB1mZG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OJwB1mZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8EE1F0089B;
	Sat, 19 Sep 2026 12:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789821115;
	bh=xdU6io/hRJ66f3mSnZH2JasywPl3rJU2sHZr8MAb3MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJwB1mZGlmiD14uHL6wkrimerKGtUfsGCMAK1GxjlJqOg/H1egC+i/4P6cTx+zE2D
	 zF4xr4gjOWlPaJ3IBkW74RM7AR+9uPrPuPGU75aIGCSgbNeIk7PWKfHYrxDDxX5jem
	 9t1PgKBCXyXi6irqHx7MuVvqdiiDq7EA23JhXxrZ18OXu1FIDVHgWCoXqsXOIhXNyp
	 oVNeP2VVQGwxPMVvMU+5i3OTCtfk/ccY4T08Zsvcn3qGkGSKCpd4WPVK5pCSgOzyHp
	 wuLHbj3Z7LJOBjl1QXBbA9aHRq7L9RnvP/dqCeqV5OnXfClgZu/1AMONP5ulaaDzoy
	 nm8O4sXykMUAw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x7uET-0000000AwvV-3BF9;
	Sat, 19 Sep 2026 12:31:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH 3/4] KVM: arm64: vgic-v5: Tidy-up programming of vpe descriptor address
Date: Sat, 19 Sep 2026 13:31:49 +0100
Message-ID: <20260919123150.3283606-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260919123150.3283606-1-maz@kernel.org>
References: <20260919123150.3283606-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Assigning an address calculation to a vpe_entry is poor practice, and
results in sparse moaning loudly. Tidy things up by computing the
physical address as such, and performing the cpu_to_le64() on that.

Whilst at it, simplify the computing of that address, avoiding the
shifting back and forth, and kill the pointless GICV5_VPED_ADDR_SHIFT
definition.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v5-tables.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgic-v5-tables.c
index d7196ed5d1bfd..2c8d0f360506c 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -63,7 +63,6 @@ static DEFINE_XARRAY(vm_info);
 /* Virtual PE Table Entry */
 #define GICV5_VPE_VALID			BIT_ULL(0)
 /* Note that there is no shift for the address by design. */
-#define GICV5_VPED_ADDR_SHIFT		3ULL
 #define GICV5_VPED_ADDR			GENMASK_ULL(55, 3)
 
 /* L2 Interrupt State Table Entry */
@@ -725,7 +724,7 @@ int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu)
 	u32 vm_id = vgic_v5_vm_id(vcpu->kvm);
 	u16 vpe_id = vgic_v5_vpe_id(vcpu);
 	struct vgic_v5_vm_info *vmi;
-	vpe_entry tmp, *vpet_base;
+	vpe_entry *vpet_base;
 	void *vped;
 
 	/* Make sure we're not over what the hardware supports */
@@ -751,10 +750,9 @@ int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu)
 	vped = (u8 *)vmi->vped_base +
 		(size_t)vcpu->vcpu_idx * vmt_info->vped_size;
 
-	tmp = FIELD_PREP(GICV5_VPED_ADDR, virt_to_phys(vped) >> GICV5_VPED_ADDR_SHIFT);
-
 	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
-		WRITE_ONCE(vpet_base[vpe_id], cpu_to_le64(tmp));
+		phys_addr_t paddr = virt_to_phys(vped) & GICV5_VPED_ADDR;
+		WRITE_ONCE(vpet_base[vpe_id], cpu_to_le64(paddr));
 		vgic_v5_clean_inval(vpet_base + vpe_id, sizeof(vpe_entry));
 	}
 
-- 
2.47.3

