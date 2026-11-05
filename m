Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793876470;
	b=BL+gKPKGP7/N27Pq1/tLGfZVwe+eirLpMrZgbbxH1nyYYIicZxKvKctj+krhPNutVl2L
	 FszzvC8MxeY9UdoEehHaNZon9y6q6Z20RKjJKLR5IfNQl5Vl4cbmIHkc1lY1hEZ4hvrUs
	 4pyHxq5qaWPV194z2QziC2tP57nDTZ6PFmye7FokQAhmH4ISWC8ey5JSnTvxFiIFAjRuk
	 j1SQzepLpLQBfSfJmAgxjM/oQjU8bH5RlYHVL8bsSRmk81iMUZKVwYlMV/2q4VnhMzjUT
	 +AHRaoq6BA5vxM6DFZX8Mc9hoEIscVOTCqmyDXLhhYk6BKn1v4Q5zR9MbiYJRvtXx5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793876470;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=BcXeQjEFNSP/TApty++76xzI53xOj+syuhRwCG9rHxo=;
	b=sTa76aiiHbez1PGzrqRDpJUJRfKxp7IvjqdCPDD1fF9YseEhlM2WfEe3dw8s1nPX4ScD
	 PwpSzgpjwsBTie36+l0/V9AonnEcOktgnyzmL2YRlhivnJX+XpEsRhxCODjWw4BrmUOQh
	 /wgicZHyJDK2OrKEO2dMPR2muDk8PxoffLYCtZR4SciuX5Z+VNLlvpIuTuzoyoS0GhxsY
	 NKysbj3PQTmAPDVq86TwRR4SNFuRyOYedWLwFvV+xuYSSFf9pvG9FtEXy/gzsPdUncsZu
	 rM7/O86/r/cx5fmlFpnadPRNDOJZgCcE+am5LWB2gBWkZDOPCfo4NYfQc8CcevmtuzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="Gz8/8xRY";
	arc=none smtp.remote-ip=95.215.58.210
Received: from mta1.migadu.com (out-210.mta1.migadu.com [95.215.58.210])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB1C606A329
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 11:01:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FB1C606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Gz8/8xRY
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=pbHGj00Y/u34o5L+mmK1hpmWWttuOPLFGa9fwq0JKUI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793876467; v=1; x=1794481267;
 b=Gz8/8xRYZEcFoVAC+FDF5nMZGaKIJmHcjzNQdxS96DTPgJtqH4gAZ9BGBKCyA+qZRXQ++X+7
 DPFwW0JNcDYeqxzWaFEKDxgXZPQk6YDnqEN8A6l/l6Lp0eXiWodLk8GLbYK5ewnSsz1pUr5xlzk
 GAs+8RNK972RlnDpMWL1UL68=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id e418548e26965c89;
	Thu, 05 Nov 2026 11:01:07 +0000
X-Mizu-Trace-ID: e418548e26965c89
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
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: arm64: vgic-its: Don't read the pending table when mapping an LPI
Date: Thu,  5 Nov 2026 11:00:50 +0000
Message-ID: <20261105110050.1244525-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261105110050.1244525-1-fuad.tabba@linux.dev>
References: <20261105110050.1244525-1-fuad.tabba@linux.dev>
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

Mapping an LPI makes it pending if its bit in the target redistributor's
pending table is set. While the redistributor has LPIs enabled, KVM
doesn't keep that bit current. Saving the pending tables, as QEMU does
whenever it stops the VM, sets the bit of each pending LPI, and the bit
stays set once the guest has taken the LPI. Discarding the LPI and
mapping its INTID again makes it pending a second time.

MAPTI (IHI 0069H.b, 5.3.12) doesn't read the table, so stop reading it
when an LPI is created. Read it once the ITS tables are restored
instead, for each redistributor with LPIs enabled, as enabling LPIs
does (5.1.2). The documented restore order restores the redistributors
first.

The copy that commit b4c9f30194a4 ("KVM: arm64: vgic-v3: Don't drop a
pending LPI mapped with LPIs disabled") takes while LPIs are disabled
goes too, now that the save leaves that bit alone.

An LPI mapped after its redistributor enabled LPIs no longer picks up a
bit the table held at the enable. A GIC makes the LPI pending at the
enable, mapped or not (5.1.2). KVM has no pending state for an unmapped
INTID, and a bit the guest wrote is indistinguishable from one a save
left behind. Linux enables LPIs with a zeroed table.

Fixes: 06bd5359549d7 ("KVM: arm64: vgic-its: Read config and pending bit in add_lpi()")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 33 ++++++++++++++++--------
 arch/arm64/kvm/vgic/vgic-v3.c  | 46 ----------------------------------
 arch/arm64/kvm/vgic/vgic.h     |  1 -
 3 files changed, 23 insertions(+), 57 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 5ce485485a117..ede205e05dc04 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -142,7 +142,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	 * However we only have those structs for mapped IRQs, so we read in
 	 * the respective config data from memory here upon mapping the LPI.
 	 *
-	 * Should any of these fail, behave as if we couldn't create the LPI
+	 * Should that fail, behave as if we couldn't create the LPI
 	 * by dropping the refcount and returning the error.
 	 */
 	ret = update_lpi_config(kvm, irq, NULL, false);
@@ -151,12 +151,6 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		return ERR_PTR(ret);
 	}
 
-	ret = vgic_v3_lpi_sync_pending_status(kvm, irq);
-	if (ret) {
-		vgic_put_irq(kvm, irq);
-		return ERR_PTR(ret);
-	}
-
 	return irq;
 }
 
@@ -2710,6 +2704,9 @@ static int vgic_its_save_tables_v0(struct vgic_its *its)
  */
 static int vgic_its_restore_tables_v0(struct vgic_its *its)
 {
+	struct kvm *kvm = its->dev->kvm;
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
 	int ret;
 
 	ret = vgic_its_restore_collection_table(its);
@@ -2717,9 +2714,25 @@ static int vgic_its_restore_tables_v0(struct vgic_its *its)
 		return ret;
 
 	ret = vgic_its_restore_device_tables(its);
-	if (ret)
-		vgic_its_free_collection_list(its->dev->kvm, its);
-	return ret;
+	if (ret) {
+		vgic_its_free_collection_list(kvm, its);
+		return ret;
+	}
+
+	/* Enabling LPIs read the pending tables before these LPIs existed. */
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!vgic_lpis_enabled(vcpu))
+			continue;
+
+		ret = its_sync_lpi_pending_table(vcpu);
+		if (ret) {
+			vgic_its_free_device_list(kvm, its);
+			vgic_its_free_collection_list(kvm, its);
+			return ret;
+		}
+	}
+
+	return 0;
 }
 
 static void vgic_its_commit_v0(struct vgic_its *its)
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 9bbf11ddba92e..35e45479dfa42 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -517,52 +517,6 @@ void vcpu_set_ich_hcr(struct kvm_vcpu *vcpu)
 				      ICH_HCR_EL2_TC);
 }
 
-int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
-{
-	struct kvm_vcpu *vcpu;
-	int byte_offset, bit_nr;
-	gpa_t pendbase, ptr;
-	bool status;
-	u8 val;
-	int ret;
-	unsigned long flags;
-
-retry:
-	vcpu = irq->target_vcpu;
-	if (!vcpu)
-		return 0;
-
-	pendbase = GICR_PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
-
-	byte_offset = irq->intid / BITS_PER_BYTE;
-	bit_nr = irq->intid % BITS_PER_BYTE;
-	ptr = pendbase + byte_offset;
-
-	ret = kvm_read_guest_lock(kvm, ptr, &val, 1);
-	if (ret)
-		return ret;
-
-	status = val & (1 << bit_nr);
-
-	raw_spin_lock_irqsave(&irq->irq_lock, flags);
-	if (irq->target_vcpu != vcpu) {
-		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
-		goto retry;
-	}
-	irq->pending_latch = status;
-	vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
-
-	/* Enabling LPIs resets the latch from the table: leave the bit for it */
-	if (status && vgic_lpis_enabled(vcpu)) {
-		/* clear consumed data */
-		val &= ~(1 << bit_nr);
-		ret = vgic_write_guest_lock(kvm, ptr, &val, 1);
-		if (ret)
-			return ret;
-	}
-	return 0;
-}
-
 /*
  * The deactivation of the doorbell interrupt will trigger the
  * unmapping of the associated vPE.
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 71c481ddd98d6..c4407f69f3613 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -347,7 +347,6 @@ void vgic_v3_reset(struct kvm_vcpu *vcpu);
 void vgic_v3_enable_cpuif_traps(void);
 int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
-int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq);
 int vgic_v3_save_pending_tables(struct kvm *kvm);
 int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count);
 int vgic_register_redist_iodev(struct kvm_vcpu *vcpu);
-- 
2.47.3

