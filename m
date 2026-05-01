Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8E53A0B2E
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634425; cv=none; b=pp3kcY7DMZCRys6J3CyOX+9dtDB/4g5sYRM6h/pbbtd1uyvXT2q4PpQhxkmLgzL6ITHQKutUbBULmrHew0jM9RG57X+ElbZ0++Jg5RxOugR1dqZRZ53PlenhupFlGgEA6Z+V8EjUvx9wMaUTa1V77zP6AzyXEd7aQbTsGP5sFSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634425; c=relaxed/simple;
	bh=+Qu6Xr8SZccDkGbo59oLqz3v9y141GWTZZp2UsNaiPg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OANzQJuQNqoOIagibvpFC1ino1ISkealVKfM406vn4qfhO3c/chn0sFA/yUkpDpzV8DJ/Z0LyABM5W4pykacL+EgEMPI8jsfvROCyrNw02cE8QoNMQt5v66Foi7VFsDbZPBQSFq5kDi51hVdJhPTsYCbiFERNoJxQrSSIiJYbeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YQSlxrAC; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YQSlxrAC"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-4411a1f9601so1370779f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634421; x=1778239221; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aHDjZzOY7Hx/XA6TloE0Km6NFJhjbYET1ob/3IzkCuE=;
        b=YQSlxrAC0jH1P8i5EFdj2LDFmomYZ80NY5w7kWBznpIoiV7N5/U0+GT2jDzWedPRrE
         dXLsYIuNdlPAMjFZWm5Twavza6UM+qM0X5czInLyqgag28vz4omId/otnnPqb/dieDDT
         aVE1iYIlOo3vixoWAXc6Xn95YQaiJMOGHq8afWNq+7//yRxyFJKZmA6xXgJtvb/7z0SP
         ob9pxBLmZcC2/O95XNHNK2i+xoVlKw7lOlveK1Fq7KfVh1bbf8m6APO0ZoEBfaaXfCg7
         ob4EUXdUXsNKZJS6WSgK5Nu15tFrlqpJEuenqkV29hPPNc0lK3n4XQ5JhxMBY5iVtxfA
         YfLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634421; x=1778239221;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aHDjZzOY7Hx/XA6TloE0Km6NFJhjbYET1ob/3IzkCuE=;
        b=gCn8c4B3CvBYhdqAuJSkgiCv1JbN8trKiD3kTDPspyf/n6hU8ocnGCBl7HDv2bqqa7
         +cgSnqB5Ug0mI36yh8DTuo6Rcd5DgemHBX0N6SHbzzARw5GlOkyeVNRr91kmrmAt/rQF
         tjMiyzT/hqNlrgqqHNJLteFVmj6T+/gocnO99spEeJfOExRN0XmcfXyfmDDrbj4IFEIq
         6BpyfLyyeLX2yxHRL+5UTyPRuxpYPnTzS91EhHerQMrGRHj40V6KL5I+mm4kfYyJ4Rz1
         ZX3EPRcmdQt2aDhBRieUC0T/a3fMuAe6bGjPPfbSz8TG42YPuKzffeJxZ6soLO37HM+g
         ff1Q==
X-Forwarded-Encrypted: i=1; AFNElJ/WG1qL+EhPwwVvUGbr4vkVmiTj3lRjbBi5A83rMoS5/+gdDeY8lZwl1cZ0U+cCS6oDNlJRG08=@lists.linux.dev
X-Gm-Message-State: AOJu0YwZZ0er6DO2KqTAcxM1AUfHEPiVfEySsAgjgYuRnuAu54cybb9n
	F/f4u27F5zCO96vpOjQU/2AVMVYKCo3H2/5+MkAJBLvt/0WmMfjOcoKDpu6osXFNRKDVqmQlKxP
	oygHISxJ3bSan9w==
X-Received: from wrxl7.prod.google.com ([2002:a05:6000:12c7:b0:43b:4453:39d8])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2212:b0:43d:3004:5fef with SMTP id ffacd0b85a97d-4493d7fa8ccmr10517288f8f.7.1777634420432;
 Fri, 01 May 2026 04:20:20 -0700 (PDT)
Date: Fri,  1 May 2026 11:19:17 +0000
In-Reply-To: <20260501111928.259252-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501111928.259252-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501111928.259252-16-smostafa@google.com>
Subject: [PATCH v6 15/25] iommu/arm-smmu-v3-kvm: Shadow the command queue
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	mark.rutland@arm.com, qperret@google.com, tabba@google.com, 
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

At boot allocate a command queue per SMMU which is used as a shadow
by the hypervisor.

The command queue size is 64K which is more than enough, as the
hypervisor would consume all the entries per a command queue prod
write, which means it can handle up to 4096 at a time.

Then, the host command queue needs to be pinned in a shared state, so
it can't be donated to VMs, and avoid tricking the hypervisor into
accessing them. This is done each time the command queue is enabled,
and undone each time the command queue is disabled.
The hypervisor won=E2=80=99t access the host command queue when it is disab=
led
from the host.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   |  25 ++++
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 122 +++++++++++++++++-
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  |   8 ++
 3 files changed, 154 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iomm=
u/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index 9765d3d636d7..fccbc34de087 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -15,6 +15,8 @@
 #include "arm-smmu-v3.h"
 #include "pkvm/arm_smmu_v3.h"
=20
+#define SMMU_KVM_CMDQ_ORDER				4
+
 extern struct kvm_iommu_ops kvm_nvhe_sym(smmu_ops);
=20
 static size_t				kvm_arm_smmu_count;
@@ -24,6 +26,15 @@ static size_t				kvm_arm_smmu_cur;
 static void kvm_arm_smmu_array_free(void)
 {
 	int order;
+	int i;
+
+	for (i =3D 0 ; i < kvm_arm_smmu_cur ; ++i) {
+		struct hyp_arm_smmu_v3_device *smmu =3D &kvm_arm_smmu_array[i];
+
+		if (smmu->cmdq.base_dma)
+			free_pages((unsigned long)phys_to_virt(smmu->cmdq.base_dma),
+				   SMMU_KVM_CMDQ_ORDER);
+	}
=20
 	order =3D get_order(kvm_arm_smmu_count * sizeof(*kvm_arm_smmu_array));
 	free_pages((unsigned long)kvm_arm_smmu_array, order);
@@ -70,6 +81,7 @@ static int smmuv3_nesting_probe(struct platform_device *p=
dev)
 	struct hyp_arm_smmu_v3_device *smmu =3D &kvm_arm_smmu_array[kvm_arm_smmu_=
cur];
 	struct device *dev =3D &pdev->dev;
 	struct resource *res;
+	void *cmdq_base;
=20
 	/* Only device tree, ACPI not supported. */
 	if (!dev->of_node)
@@ -95,6 +107,19 @@ static int smmuv3_nesting_probe(struct platform_device =
*pdev)
 	if (of_dma_is_coherent(dev->of_node))
 		smmu->features |=3D ARM_SMMU_FEAT_COHERENCY;
=20
+	/*
+	 * Allocate the shadow command queue, it doesn't have to be the same
+	 * size as the host.
+	 * Only populate base_dma and llq.max_n_shift, the hypervisor will init
+	 * the rest.
+	 */
+	cmdq_base =3D (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, SMMU_KVM_=
CMDQ_ORDER);
+	if (!cmdq_base)
+		return -ENOMEM;
+
+	smmu->cmdq.base_dma =3D virt_to_phys(cmdq_base);
+	smmu->cmdq.llq.max_n_shift =3D SMMU_KVM_CMDQ_ORDER + PAGE_SHIFT - CMDQ_EN=
T_SZ_SHIFT;
+
 	kvm_arm_smmu_cur++;
 	return 0;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iom=
mu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index cce5a51b4656..3b77796dafc7 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -11,7 +11,6 @@
 #include <nvhe/trap_handler.h>
=20
 #include "arm_smmu_v3.h"
-#include "../arm-smmu-v3.h"
=20
 size_t __ro_after_init kvm_hyp_arm_smmu_v3_count;
 struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
@@ -21,10 +20,68 @@ struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmu=
s;
 	     (smmu) !=3D &kvm_hyp_arm_smmu_v3_smmus[kvm_hyp_arm_smmu_v3_count]; \
 	     (smmu)++)
=20
+#define cmdq_size(cmdq)	((1 << ((cmdq)->llq.max_n_shift)) * CMDQ_ENT_DWORD=
S * 8)
+
+static bool is_cmdq_enabled(struct hyp_arm_smmu_v3_device *smmu)
+{
+	return FIELD_GET(CR0_CMDQEN, smmu->cr0);
+}
+
+/*
+ * CMDQ, STE host copies are accessed by the hypervisor, we share them to
+ * - Prevent the host from passing protected VM memory.
+ * - Having them mapped in the hyp page table.
+ */
+static int smmu_share_pages(phys_addr_t addr, size_t size)
+{
+	size_t nr_pages =3D PAGE_ALIGN(size + (addr & ~PAGE_MASK)) >> PAGE_SHIFT;
+	phys_addr_t base =3D addr & PAGE_MASK;
+	int i, ret;
+
+	for (i =3D 0 ; i < nr_pages ; ++i) {
+		if (__pkvm_host_share_hyp((base + i * PAGE_SIZE) >> PAGE_SHIFT)) {
+			while (i--)
+				__pkvm_host_unshare_hyp((base + i * PAGE_SIZE) >> PAGE_SHIFT);
+			return -EPERM;
+		}
+	}
+
+	ret =3D hyp_pin_shared_mem(hyp_phys_to_virt(base),
+				 hyp_phys_to_virt(base + nr_pages * PAGE_SIZE));
+	if (ret) {
+		for (i =3D 0 ; i < nr_pages ; ++i)
+			__pkvm_host_unshare_hyp((base + i * PAGE_SIZE) >> PAGE_SHIFT);
+	}
+
+	return ret;
+}
+
+static int smmu_unshare_pages(phys_addr_t addr, size_t size)
+{
+	size_t nr_pages =3D PAGE_ALIGN(size + (addr & ~PAGE_MASK)) >> PAGE_SHIFT;
+	phys_addr_t base =3D addr & PAGE_MASK;
+	int i, ret;
+
+	hyp_unpin_shared_mem(hyp_phys_to_virt(base),
+			     hyp_phys_to_virt(base + nr_pages * PAGE_SIZE));
+
+	for (i =3D 0 ; i < nr_pages ; ++i) {
+		ret =3D __pkvm_host_unshare_hyp((base + i * PAGE_SIZE) >> PAGE_SHIFT);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 /* Put the device in a state that can be probed by the host driver. */
 static void smmu_deinit_device(struct hyp_arm_smmu_v3_device *smmu)
 {
 	WARN_ON(__pkvm_hyp_donate_host_mmio(smmu->mmio_addr, smmu->mmio_size));
+
+	if (smmu->cmdq.base)
+		WARN_ON(__pkvm_hyp_donate_host(smmu->cmdq.base_dma >> PAGE_SHIFT,
+					       cmdq_size(&smmu->cmdq) >> PAGE_SHIFT));
 	smmu->base =3D NULL;
 }
=20
@@ -99,6 +156,31 @@ static int smmu_probe(struct hyp_arm_smmu_v3_device *sm=
mu)
 	return 0;
 }
=20
+/*
+ * The kernel part of the driver will allocate the shadow cmdq,
+ * and zero it. This function only donates it.
+ */
+static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
+{
+	size_t cmdq_nr_pages =3D cmdq_size(&smmu->cmdq) >> PAGE_SHIFT;
+	int ret;
+
+	ret =3D __pkvm_host_donate_hyp(smmu->cmdq.base_dma >> PAGE_SHIFT, cmdq_nr=
_pages);
+	if (ret)
+		return ret;
+
+	smmu->cmdq.base =3D hyp_phys_to_virt(smmu->cmdq.base_dma);
+	smmu->cmdq.prod_reg =3D smmu->base + ARM_SMMU_CMDQ_PROD;
+	smmu->cmdq.cons_reg =3D smmu->base + ARM_SMMU_CMDQ_CONS;
+	smmu->cmdq.q_base =3D smmu->cmdq.base_dma |
+			    FIELD_PREP(Q_BASE_LOG2SIZE, smmu->cmdq.llq.max_n_shift);
+	smmu->cmdq.ent_dwords =3D CMDQ_ENT_DWORDS;
+	writel_relaxed(0, smmu->cmdq.prod_reg);
+	writel_relaxed(0, smmu->cmdq.cons_reg);
+	writeq_relaxed(smmu->cmdq.q_base, smmu->base + ARM_SMMU_CMDQ_BASE);
+	return 0;
+}
+
 static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 {
 	unsigned long haddr;
@@ -117,7 +199,12 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_dev=
ice *smmu)
 	if (ret)
 		goto out_ret;
=20
+	ret =3D smmu_init_cmdq(smmu);
+	if (ret)
+		goto out_ret;
+
 	return 0;
+
 out_ret:
 	smmu_deinit_device(smmu);
 	return ret;
@@ -157,6 +244,22 @@ static int smmu_init(void)
 	return ret;
 }
=20
+static void smmu_emulate_cmdq_enable(struct hyp_arm_smmu_v3_device *smmu)
+{
+	u32 shift =3D smmu->cmdq_host.q_base & Q_BASE_LOG2SIZE;
+
+	smmu->cmdq_host.llq.max_n_shift =3D min(shift, 19);
+	smmu->cmdq_host.base_dma =3D smmu->cmdq_host.q_base & Q_BASE_ADDR_MASK;
+	WARN_ON(smmu_share_pages(smmu->cmdq_host.base_dma,
+				 cmdq_size(&smmu->cmdq_host)));
+}
+
+static void smmu_emulate_cmdq_disable(struct hyp_arm_smmu_v3_device *smmu)
+{
+	WARN_ON(smmu_unshare_pages(smmu->cmdq_host.base_dma,
+				   cmdq_size(&smmu->cmdq_host)));
+}
+
 static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 			     struct user_pt_regs *regs,
 			     u64 esr, u32 off)
@@ -180,6 +283,14 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_de=
vice *smmu,
 		break;
 	/* Passthrough the register access for bisectiblity, handled later */
 	case ARM_SMMU_CMDQ_BASE:
+		if (is_write) {
+			/* Not allowed by the architecture */
+			if (WARN_ON(is_cmdq_enabled(smmu)))
+				break;
+			smmu->cmdq_host.q_base =3D val;
+		}
+		mask =3D read_write;
+		break;
 	case ARM_SMMU_CMDQ_PROD:
 	case ARM_SMMU_CMDQ_CONS:
 	case ARM_SMMU_STRTAB_BASE:
@@ -190,6 +301,15 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_de=
vice *smmu,
 	case ARM_SMMU_CR0:
 		if (len !=3D sizeof(u32))
 			break;
+		if (is_write) {
+			bool last_cmdq_en =3D is_cmdq_enabled(smmu);
+
+			smmu->cr0 =3D val;
+			if (!last_cmdq_en && is_cmdq_enabled(smmu))
+				smmu_emulate_cmdq_enable(smmu);
+			else if (last_cmdq_en && !is_cmdq_enabled(smmu))
+				smmu_emulate_cmdq_disable(smmu);
+		}
 		mask =3D read_write;
 		break;
 	case ARM_SMMU_CR1: {
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h b/drivers/iom=
mu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
index 263b0fef262d..cc1ad4c19845 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
@@ -8,6 +8,8 @@
 #include <nvhe/spinlock.h>
 #endif
=20
+#include "../arm-smmu-v3.h"
+
 /*
  * Parameters from the trusted host:
  * @mmio_addr		base address of the SMMU registers
@@ -20,6 +22,9 @@
  * @pgsize_bitmap	Supported page sizes
  * @sid_bits		Max number of SID bits supported
  * @lock		Lock to protect SMMU
+ * @cmdq		CMDQ as observed by HW
+ * @cmdq_host		Host view of the CMDQ, only q_base and llq used.
+ * @cr0			Last value of CR0
  */
 struct hyp_arm_smmu_v3_device {
 	phys_addr_t		mmio_addr;
@@ -34,6 +39,9 @@ struct hyp_arm_smmu_v3_device {
 #else
 	u32			lock;
 #endif
+	struct arm_smmu_queue	cmdq;
+	struct arm_smmu_queue	cmdq_host;
+	u32			cr0;
 };
=20
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
--=20
2.54.0.545.g6539524ca2-goog

