Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793648732;
	b=XXhnqEO+qMWDTSIYT/khb+1UIESZ2rRN2n9Um+2NfXOuxy83zLBp8l2i6E5o+t9HezNK
	 nMYoLx0dna5D+QJLI+win0ATslgqGX+DjYKjFyQPMva74ptxaXsMa+0GhhLgd7DS8yTpr
	 tNTMQ4hQR1GNtRxBlCxxqnI8NpGcPm0xDQYE/814n7pnr4FGHWp37zgJOoFilEXpGbPLB
	 Wfn8EDDGoI/BykkG5Kv2q4bXDcPMGOvymNVhJcnCVpEH+78Mv+6Sg1odmZjoPVScETXYs
	 Mnoq9CZft+CMP/T7x1w13VWATGwHktVRseJs9Aj3yfXQvbsr+k5HUB+/4sNi0OG8Olw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793648732;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7OCfOUEx0Br8tfKSpqFKVJ7ZdvWw/X/1CTSfzzbiOck=;
	b=kagjRoVpDBYG9eqcvy+iWubMV+PXyp7ycWCZqla3gXkzJraMvtUCQWJANWBEbhWz6nyV
	 0Wt7seKTutlLfa/gV439esZAP00djwTpME3D3VoZuwgs5QEptA7NPsREEFH0ToiHd4xnG
	 BLz3SKUS6un8i8cAMEhAJ+JD9iufQWYiPRe8SJ8ZBTP6vAUV8Zz9Sd4ejbwGRQd08L+Pq
	 nEtQGQCI9JyYsGka1NGMA/+qfipAwUQLaMvDi9/mPmuTb3MDv+Q1Bg+C7KCVev+9z+R3X
	 LL/3vQz7HxkM6sNUxa9ZpEO1zLManR54jVHFGgYASkVNIwt6ftmFEIhUiQb5jE8kVEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=iTfFqXHL;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B6F6606EE8B
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 19:45:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B6F6606EE8B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=iTfFqXHL
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A7A901FC4;
	Mon,  2 Nov 2026 11:45:27 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D05AA3F673;
	Mon,  2 Nov 2026 11:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793648730; bh=2fojq97uKWhxXsg47OHSJR82Zke5O85KVvFOhx9iSO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iTfFqXHLol4fep9pbr+la50Phz4FW9MrTsQ8z1UNHQosJu5FPe5AZhugIv7Adn00g
	 52GSnLiTyoywXaSP4vEZmSWhH01W6cs0G2ELTEnqybjMj1rH2GRpLxBBC0RYsCusZV
	 +t4Loch0CwgZvi7om7GDRa89TbOcHpvZWcgKxC6U=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	peter.maydell@linaro.org,
	lpieralisi@kernel.org,
	timothy.hayes@arm.com,
	fuad.tabba@linux.dev
Subject: [PATCH v2 06/16] KVM: arm64: gic-v5: Add ITS MMIO state emulation
Date: Mon,  2 Nov 2026 19:44:44 +0000
Message-Id: <20261102194454.4086911-7-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261102194454.4086911-1-sascha.bischoff@arm.com>
References: <20261102194454.4086911-1-sascha.bischoff@arm.com>
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

In order to expose a virtual GICv5 ITS to the guest, KVM needs to
emulate the ITS CONFIG_FRAME and its translation-control registers.
Replace the placeholder ITS IODEV region with the GICv5 ITS register
layout and handlers for the architected MMIO state.

Provide read/write emulation for the ITS ID registers, IIDR, AIDR,
CR0, CR1, DT_BASER, DT_CFGR, DIDR, EIDR, invalidation registers,
READ_EVENT, GEN_EVENT, status registers, and the RAZ/WI MMIO
registers that KVM does not implement. Reuse the shared CoreSight
identification-register helper so the ITS reports the same component
identification values as the IRS.

At this stage the translation-triggering registers only record state.
Walking the guest's DT/ITT, generating READ_EVENT results, and
injecting GEN_EVENT LPIs are added by later commits.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-its-v5.c | 415 +++++++++++++++++++++++++++++-
 include/kvm/arm_vgic.h            |  77 ++++++
 2 files changed, 490 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic-its-v5.c
index 5790b029f09b6..f04161c315b78 100644
--- a/arch/arm64/kvm/vgic/vgic-its-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
@@ -6,19 +6,286 @@
 #include <linux/kvm_host.h>
 #include <linux/slab.h>
 
+#include <asm/kvm_arm.h>
 #include <asm/kvm_mmu.h>
 
 #include <kvm/arm_vgic.h>
 
+#include <linux/irqchip/arm-gic-v5.h>
+
 #include "vgic.h"
 #include "vgic-mmio.h"
 
+#define VITS_V5_DEVICE_ID_BITS		16
+#define VITS_V5_EVENT_ID_BITS		16
+
+static unsigned long vgic_v5_mmio_read_its_misc(struct kvm *kvm, void *dev,
+						gpa_t addr, unsigned int len)
+{
+	struct vgic_v5_its *its = dev;
+	u64 value = 0;
+	size_t offset = addr & (SZ_64K - 1);
+
+	guard(mutex)(&its->its_lock);
+
+	switch (offset) {
+	case GICV5_ITS_IDR0:
+		value = FIELD_PREP(GICV5_ITS_IDR0_ITSID, its->idr0.its_id);
+		value |= FIELD_PREP(GICV5_ITS_IDR0_SWE, its->idr0.swe);
+		value |= FIELD_PREP(GICV5_ITS_IDR0_MPAM, its->idr0.mpam);
+		value |= FIELD_PREP(GICV5_ITS_IDR0_MEC, its->idr0.mec);
+		value |= FIELD_PREP(GICV5_ITS_IDR0_PA_RANGE,
+				    its->idr0.pa_range);
+		value |= FIELD_PREP(GICV5_ITS_IDR0_DOM, its->idr0.domain);
+		break;
+	case GICV5_ITS_IDR1:
+		value = FIELD_PREP(GICV5_ITS_IDR1_L2SZ, its->idr1.l2sz);
+		value |= FIELD_PREP(GICV5_ITS_IDR1_ITT_LEVELS,
+				    its->idr1.itt_levels);
+		value |= FIELD_PREP(GICV5_ITS_IDR1_DT_LEVELS,
+				    its->idr1.dt_levels);
+		value |= FIELD_PREP(GICV5_ITS_IDR1_DEVICEID_BITS,
+				    its->idr1.device_id_bits);
+		break;
+	case GICV5_ITS_IDR2:
+		value = FIELD_PREP(GICV5_ITS_IDR2_XDMN_EVENTS,
+				   its->idr2.xdmn_events);
+		value |= FIELD_PREP(GICV5_ITS_IDR2_EVENTID_BITS,
+				    its->idr2.event_id_bits);
+		break;
+	case GICV5_ITS_IIDR:
+		value = FIELD_PREP(GICV5_ITS_IIDR_PRODUCT_ID, PRODUCT_ID_KVM);
+		value |= FIELD_PREP(GICV5_ITS_IIDR_VARIANT, 0);
+		value |= FIELD_PREP(GICV5_ITS_IIDR_REVISION, 0);
+		value |= FIELD_PREP(GICV5_ITS_IIDR_IMPLEMENTER,
+				    IMPLEMENTER_ARM);
+		break;
+	case GICV5_ITS_AIDR:
+		value = FIELD_PREP(GICV5_ITS_AIDR_COMPONENT,
+				   GICV5_AIDR_COMPONENT_ITS);
+		value |= FIELD_PREP(GICV5_ITS_AIDR_ARCHMAJORREV,
+				    GICV5_AIDR_ARCH_MAJ_REV_V5);
+		value |= FIELD_PREP(GICV5_ITS_AIDR_ARCHMINORREV,
+				    GICV5_AIDR_ARCH_MIN_REV_V0);
+		break;
+	case GICV5_ITS_CR0:
+		value = GICV5_ITS_CR0_IDLE;
+		value |= FIELD_PREP(GICV5_ITS_CR0_ITSEN, its->enabled);
+		break;
+	case GICV5_ITS_CR1:
+		value = FIELD_PREP(GICV5_ITS_CR1_ITT_RA, its->cr1.itt_ra);
+		value |= FIELD_PREP(GICV5_ITS_CR1_DT_RA, its->cr1.dt_ra);
+		value |= FIELD_PREP(GICV5_ITS_CR1_IC, its->cr1.ic);
+		value |= FIELD_PREP(GICV5_ITS_CR1_OC, its->cr1.oc);
+		value |= FIELD_PREP(GICV5_ITS_CR1_SH, its->cr1.sh);
+		break;
+	default:
+		return 0;
+	}
+
+	return value;
+}
+
+static void vgic_v5_mmio_write_its_misc(struct kvm *kvm, void *dev, gpa_t addr,
+					unsigned int len, unsigned long val)
+{
+	struct vgic_v5_its *its = dev;
+	size_t offset = addr & (SZ_64K - 1);
+
+	guard(mutex)(&its->its_lock);
+
+	switch (offset) {
+	case GICV5_ITS_CR0:
+		its->enabled = FIELD_GET(GICV5_ITS_CR0_ITSEN, val);
+		return;
+	case GICV5_ITS_CR1:
+		its->cr1.sh = FIELD_GET(GICV5_ITS_CR1_SH, val);
+		its->cr1.oc = FIELD_GET(GICV5_ITS_CR1_OC, val);
+		its->cr1.ic = FIELD_GET(GICV5_ITS_CR1_IC, val);
+		its->cr1.dt_ra = FIELD_GET(GICV5_ITS_CR1_DT_RA, val);
+		its->cr1.itt_ra = FIELD_GET(GICV5_ITS_CR1_ITT_RA, val);
+		return;
+	default:
+		return;
+	}
+}
+
+static void vgic_v5_write_its_dt_reg(struct vgic_v5_its *its, size_t offset,
+				     unsigned long val)
+{
+	switch (offset) {
+	case GICV5_ITS_DT_CFGR:
+		its->dt_cfgr.device_id_bits =
+			FIELD_GET(GICV5_ITS_DT_CFGR_DEVICEID_BITS, val);
+		its->dt_cfgr.l2sz =
+			FIELD_GET(GICV5_ITS_DT_CFGR_L2SZ, val);
+		its->dt_cfgr.structure =
+			FIELD_GET(GICV5_ITS_DT_CFGR_STRUCTURE, val);
+		return;
+	case GICV5_ITS_DT_BASER:
+		its->dt_baser.addr =
+			FIELD_GET(GICV5_ITS_DT_BASER_ADDR_MASK, val)
+			<< GICV5_ITS_DT_BASER_ADDR_SHIFT;
+		return;
+	}
+}
+
+static u64 vgic_v5_read_its_dt_baser(struct vgic_v5_its *its)
+{
+	return FIELD_PREP(GICV5_ITS_DT_BASER_ADDR_MASK,
+			  its->dt_baser.addr >> GICV5_ITS_DT_BASER_ADDR_SHIFT);
+}
+
+static unsigned long vgic_v5_mmio_read_its_dt_itt(struct kvm *kvm, void *dev,
+						  gpa_t addr, unsigned int len)
+{
+	struct vgic_v5_its *its = dev;
+	u64 value = 0;
+	size_t offset = addr & (SZ_64K - 1);
+
+	guard(mutex)(&its->its_lock);
+
+	switch (offset) {
+	case GICV5_ITS_DT_CFGR:
+		value = FIELD_PREP(GICV5_ITS_DT_CFGR_STRUCTURE,
+				   its->dt_cfgr.structure);
+		value |= FIELD_PREP(GICV5_ITS_DT_CFGR_L2SZ,
+				    its->dt_cfgr.l2sz);
+		value |= FIELD_PREP(GICV5_ITS_DT_CFGR_DEVICEID_BITS,
+				    its->dt_cfgr.device_id_bits);
+		break;
+	case GICV5_ITS_DT_BASER:
+	case GICV5_ITS_DT_BASER + 4:
+		value = vgic_v5_read_its_dt_baser(its);
+		return extract_bytes(value, offset & 4, len);
+	case GICV5_ITS_DIDR:
+	case GICV5_ITS_DIDR + 4:
+		value = FIELD_PREP(GICV5_ITS_DIDR_DEVICEID,
+				   its->didr.device_id);
+		return extract_bytes(value, offset & 4, len);
+	case GICV5_ITS_EIDR:
+		value = FIELD_PREP(GICV5_ITS_EIDR_EVENTID,
+				   its->eidr.event_id);
+		break;
+	case GICV5_ITS_STATUSR:
+		value = GICV5_ITS_STATUSR_IDLE;
+		break;
+	case GICV5_ITS_SYNC_STATUSR:
+		value = GICV5_ITS_SYNC_STATUSR_IDLE;
+		break;
+	case GICV5_ITS_READ_EVENT_DATAR:
+	case GICV5_ITS_READ_EVENT_DATAR + 4:
+		value = FIELD_PREP(GICV5_ITS_READ_EVENT_DATAR_VIRT,
+				   its->read_event_datar.virt);
+		value |= FIELD_PREP(GICV5_ITS_READ_EVENT_DATAR_VM_ID,
+				    its->read_event_datar.vm_id);
+		value |= FIELD_PREP(GICV5_ITS_READ_EVENT_DATAR_VALID,
+				    its->read_event_datar.valid);
+		value |= FIELD_PREP(GICV5_ITS_READ_EVENT_DATAR_LPI_ID,
+				    its->read_event_datar.lpi_id);
+		return extract_bytes(value, offset & 4, len);
+	case GICV5_ITS_GEN_EVENT_EIDR:
+		value = FIELD_PREP(GICV5_ITS_GEN_EVENT_EIDR_EVENTID,
+				   its->gen_event_eidr.event_id);
+		break;
+	case GICV5_ITS_GEN_EVENT_DIDR:
+	case GICV5_ITS_GEN_EVENT_DIDR + 4:
+		value = FIELD_PREP(GICV5_ITS_GEN_EVENT_DIDR_DEVICEID,
+				   its->gen_event_didr.device_id);
+		return extract_bytes(value, offset & 4, len);
+	case GICV5_ITS_GEN_EVENT_STATUSR:
+		value = GICV5_ITS_GEN_EVENT_STATUSR_IDLE;
+		break;
+	default:
+		return 0;
+	}
+
+	return value;
+}
+
+static void vgic_v5_mmio_write_its_dt_itt(struct kvm *kvm, void *dev,
+					  gpa_t addr, unsigned int len,
+					  unsigned long val)
+{
+	struct vgic_v5_its *its = dev;
+	size_t offset = addr & (SZ_64K - 1);
+
+	guard(mutex)(&its->its_lock);
+
+	switch (offset) {
+	case GICV5_ITS_DT_CFGR:
+		if (!its->enabled)
+			vgic_v5_write_its_dt_reg(its, offset, val);
+		return;
+	case GICV5_ITS_DT_BASER:
+	case GICV5_ITS_DT_BASER + 4:
+		if (!its->enabled) {
+			u64 baser = vgic_v5_read_its_dt_baser(its);
+
+			baser = update_64bit_reg(baser, offset & 4, len, val);
+			vgic_v5_write_its_dt_reg(its, GICV5_ITS_DT_BASER,
+						 baser);
+		}
+		return;
+	case GICV5_ITS_INV_DEVICER:
+		its->inv_devicer.l1 =
+			FIELD_GET(GICV5_ITS_INV_DEVICER_L1, val);
+		its->inv_devicer.event_id_bits =
+			FIELD_GET(GICV5_ITS_INV_DEVICER_EVENTID_BITS, val);
+		its->inv_devicer.i =
+			FIELD_GET(GICV5_ITS_INV_DEVICER_I, val);
+		return;
+	case GICV5_ITS_DIDR:
+	case GICV5_ITS_DIDR + 4:
+		if (offset & 4)
+			return;
+		its->didr.device_id = FIELD_GET(GICV5_ITS_DIDR_DEVICEID, val);
+		return;
+	case GICV5_ITS_EIDR:
+		its->eidr.event_id = FIELD_GET(GICV5_ITS_EIDR_EVENTID, val);
+		return;
+	case GICV5_ITS_INV_EVENTR:
+		its->inv_eventr.l1 =
+			FIELD_GET(GICV5_ITS_INV_EVENTR_L1, val);
+		its->inv_eventr.itt_l2sz =
+			FIELD_GET(GICV5_ITS_INV_EVENTR_ITT_L2SZ, val);
+		its->inv_eventr.i = FIELD_GET(GICV5_ITS_INV_EVENTR_I, val);
+		return;
+	case GICV5_ITS_SYNCR:
+	case GICV5_ITS_READ_EVENTR:
+		return;
+	case GICV5_ITS_GEN_EVENT_EIDR:
+		its->gen_event_eidr.event_id =
+			FIELD_GET(GICV5_ITS_GEN_EVENT_EIDR_EVENTID, val);
+		return;
+	case GICV5_ITS_GEN_EVENT_DIDR:
+	case GICV5_ITS_GEN_EVENT_DIDR + 4:
+		if (offset & 4)
+			return;
+		its->gen_event_didr.device_id =
+			FIELD_GET(GICV5_ITS_GEN_EVENT_DIDR_DEVICEID, val);
+		return;
+	case GICV5_ITS_GEN_EVENTR:
+		return;
+	default:
+		return;
+	}
+}
+
 static unsigned long vgic_v5_mmio_read_its_raz(struct kvm *kvm, void *dev,
 					       gpa_t addr, unsigned int len)
 {
 	return 0;
 }
 
+static unsigned long vgic_v5_its_coresight_read(struct kvm *kvm, void *dev,
+						gpa_t addr, unsigned int len)
+{
+	u32 offset = addr & (SZ_64K - 1);
+
+	return vgic_v5_handle_guest_coresight_idreg_read(offset);
+}
+
 static void vgic_v5_mmio_write_its_wi(struct kvm *kvm, void *dev, gpa_t addr,
 				      unsigned int len, unsigned long val)
 {
@@ -31,11 +298,153 @@ static void vgic_v5_mmio_write_its_wi(struct kvm *kvm, void *dev, gpa_t addr,
 	}
 
 static const struct vgic_register_region vgic_v5_its_registers[] = {
-	REGISTER_ITS_V5_DESC(0, vgic_v5_mmio_read_its_raz,
-			     vgic_v5_mmio_write_its_wi, KVM_VGIC_V5_ITS_SIZE,
+	REGISTER_ITS_V5_DESC(GICV5_ITS_IDR0, vgic_v5_mmio_read_its_misc,
+			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_IDR1, vgic_v5_mmio_read_its_misc,
+			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_IDR2, vgic_v5_mmio_read_its_misc,
+			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_IIDR, vgic_v5_mmio_read_its_misc,
+			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_AIDR, vgic_v5_mmio_read_its_misc,
+			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_CR0, vgic_v5_mmio_read_its_misc,
+			     vgic_v5_mmio_write_its_misc, 4, VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_CR1, vgic_v5_mmio_read_its_misc,
+			     vgic_v5_mmio_write_its_misc, 4, VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_DT_BASER,
+			     vgic_v5_mmio_read_its_dt_itt,
+			     vgic_v5_mmio_write_its_dt_itt, 8,
+			     VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_DT_CFGR,
+			     vgic_v5_mmio_read_its_dt_itt,
+			     vgic_v5_mmio_write_its_dt_itt, 4,
+			     VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_DIDR, vgic_v5_mmio_read_its_dt_itt,
+			     vgic_v5_mmio_write_its_dt_itt, 8,
+			     VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_EIDR, vgic_v5_mmio_read_its_dt_itt,
+			     vgic_v5_mmio_write_its_dt_itt, 4,
+			     VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_INV_EVENTR, vgic_v5_mmio_read_its_raz,
+			     vgic_v5_mmio_write_its_dt_itt, 4,
+			     VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_INV_DEVICER, vgic_v5_mmio_read_its_raz,
+			     vgic_v5_mmio_write_its_dt_itt, 4,
+			     VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_READ_EVENTR, vgic_v5_mmio_read_its_raz,
+			     vgic_v5_mmio_write_its_dt_itt, 4,
+			     VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_READ_EVENT_DATAR,
+			     vgic_v5_mmio_read_its_dt_itt,
+			     vgic_v5_mmio_write_its_wi, 8,
+			     VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_STATUSR, vgic_v5_mmio_read_its_dt_itt,
+			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_SYNCR, vgic_v5_mmio_read_its_raz,
+			     vgic_v5_mmio_write_its_dt_itt, 4,
+			     VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_SYNC_STATUSR,
+			     vgic_v5_mmio_read_its_dt_itt,
+			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_GEN_EVENT_DIDR,
+			     vgic_v5_mmio_read_its_dt_itt,
+			     vgic_v5_mmio_write_its_dt_itt, 8,
+			     VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_GEN_EVENT_EIDR,
+			     vgic_v5_mmio_read_its_dt_itt,
+			     vgic_v5_mmio_write_its_dt_itt, 4,
+			     VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_GEN_EVENTR, vgic_v5_mmio_read_its_raz,
+			     vgic_v5_mmio_write_its_dt_itt, 4,
+			     VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_GEN_EVENT_STATUSR,
+			     vgic_v5_mmio_read_its_dt_itt,
+			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_MEC_IDR, vgic_v5_mmio_read_its_raz,
+			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_MEC_MECID_R, vgic_v5_mmio_read_its_raz,
+			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_MPAM_IDR, vgic_v5_mmio_read_its_raz,
+			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_MPAM_PARTID_R,
+			     vgic_v5_mmio_read_its_raz,
+			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_SWERR_STATUSR, vgic_v5_mmio_read_its_raz,
+			     vgic_v5_mmio_write_its_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_SWERR_SYNDROMER0,
+			     vgic_v5_mmio_read_its_raz,
+			     vgic_v5_mmio_write_its_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_SWERR_SYNDROMER1,
+			     vgic_v5_mmio_read_its_raz,
+			     vgic_v5_mmio_write_its_wi, 8,
+			     VGIC_ACCESS_64bit),
+	REGISTER_ITS_V5_DESC(GICV5_ITS_MPAM_PMGR, vgic_v5_mmio_read_its_raz,
+			     vgic_v5_mmio_write_its_wi, 8, VGIC_ACCESS_64bit),
+	/* Split the ranges so KVM_HAS_DEVICE_ATTR only reports actual registers. */
+	REGISTER_ITS_V5_DESC(GICV5_CORESIGHT_DEVARCH,
+			     vgic_v5_its_coresight_read,
+			     vgic_v5_mmio_write_its_wi, 4,
+			     VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC(GICV5_CORESIGHT_PIDR4,
+			     vgic_v5_its_coresight_read,
+			     vgic_v5_mmio_write_its_wi,
+			     GICV5_CORESIGHT_PIDR_CIDR_SIZE,
 			     VGIC_ACCESS_32bit),
 };
 
+static void vgic_v5_its_reset(struct vgic_v5_its *its)
+{
+	u64 mmfr0;
+
+	its->enabled = false;
+
+	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
+	its->idr0.pa_range = cpuid_feature_extract_unsigned_field(
+		mmfr0, ID_AA64MMFR0_EL1_PARANGE_SHIFT);
+	its->idr0.domain = GICV5_ITS_IDR0_DOMAIN_NON_SECURE;
+	its->idr0.mec = 0;
+	its->idr0.mpam = 0;
+	its->idr0.swe = 0;
+	its->idr0.its_id = 0;
+
+	its->idr1.dt_levels = 1;
+	its->idr1.itt_levels = 1;
+	its->idr1.l2sz = 0;
+	its->idr2.xdmn_events = 0;
+
+	its->cr1.sh = 0;
+	its->cr1.oc = 0;
+	its->cr1.ic = 0;
+	its->cr1.dt_ra = false;
+	its->cr1.itt_ra = false;
+
+	its->idr1.device_id_bits = VITS_V5_DEVICE_ID_BITS;
+	its->idr2.event_id_bits = VITS_V5_EVENT_ID_BITS;
+
+	its->dt_cfgr.device_id_bits = 0;
+	its->dt_cfgr.l2sz = 0;
+	its->dt_cfgr.structure = false;
+	its->dt_baser.addr = 0;
+
+	its->inv_devicer.l1 = false;
+	its->inv_devicer.event_id_bits = 0;
+	its->inv_devicer.i = false;
+	its->didr.device_id = 0;
+	its->eidr.event_id = 0;
+	its->inv_eventr.l1 = false;
+	its->inv_eventr.itt_l2sz = 0;
+	its->inv_eventr.i = false;
+
+	its->read_event_datar.lpi_id = 0;
+	its->read_event_datar.valid = false;
+	its->read_event_datar.vm_id = 0;
+	its->read_event_datar.virt = false;
+	its->gen_event_eidr.event_id = 0;
+	its->gen_event_didr.device_id = 0;
+
+}
+
 static int vgic_v5_its_create(struct kvm_device *dev, u32 type)
 {
 	struct vgic_v5_its *its;
@@ -60,6 +469,8 @@ static int vgic_v5_its_create(struct kvm_device *dev, u32 type)
 	its->vgic_v5_its_base = VGIC_ADDR_UNDEF;
 	its->dev = dev;
 
+	vgic_v5_its_reset(its);
+
 	dev->kvm->arch.vgic.msis_require_devid = true;
 	dev->kvm->arch.vgic.its_model = KVM_DEV_TYPE_ARM_VGIC_V5;
 	dev->private = its;
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4f9909d6c5b11..53aa5c857e295 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -507,6 +507,83 @@ struct vgic_v5_its {
 	struct vgic_io_device iodev;
 	struct kvm_device *dev;
 
+	bool enabled;
+
+	/* ITS state - used for registers etc */
+	struct its_idr0 {
+		u8 domain;
+		u8 pa_range;
+		bool mec;
+		bool mpam;
+		bool swe;
+		u16 its_id;
+	} idr0;
+
+	struct its_idr1 {
+		u8 device_id_bits;
+		u8 dt_levels;
+		u8 itt_levels;
+		u8 l2sz;
+	} idr1;
+
+	struct its_idr2 {
+		u8 event_id_bits;
+		u8 xdmn_events;
+	} idr2;
+
+	struct its_cr1 {
+		u8 sh;
+		u8 oc;
+		u8 ic;
+		bool dt_ra;
+		bool itt_ra;
+	} cr1;
+
+	struct its_dt_cfgr {
+		u8 device_id_bits;
+		u8 l2sz;
+		bool structure;
+	} dt_cfgr;
+
+	struct its_dt_baser {
+		u64 addr;
+	} dt_baser;
+
+	struct its_inv_devicer {
+		bool l1;
+		u8 event_id_bits;
+		bool i;
+	} inv_devicer;
+
+	struct its_didr {
+		u32 device_id;
+	} didr;
+
+	struct its_eidr {
+		u16 event_id;
+	} eidr;
+
+	struct its_inv_eventr {
+		bool l1;
+		u8 itt_l2sz;
+		bool i;
+	} inv_eventr;
+
+	struct its_read_event_datar {
+		u32 lpi_id;
+		bool valid;
+		u16 vm_id;
+		bool virt;
+	} read_event_datar;
+
+	struct its_gen_event_eidr {
+		u16 event_id;
+	} gen_event_eidr;
+
+	struct its_gen_event_didr {
+		u32 device_id;
+	} gen_event_didr;
+
 	/* Protects the device in general */
 	struct mutex		its_lock;
 };
-- 
2.34.1

