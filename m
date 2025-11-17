Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8D633E35C
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405331; cv=none; b=KDhtoRt8scy3CxpFukzVwV7k1YU/hfuWUN2pz/uSVGzvwR4yluFJHNbx2hQQ+NX4t8UuirZPpGaAmHYhF38vJ2Y49Qwma3alHbGBwTZQ2gQmdSEwk2GwuGvSztTXkteNdXFRB7i9ZnzQ7+saH3O8lu3yRkU7trOA+5VaLXm71DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405331; c=relaxed/simple;
	bh=GwOPg6FlFCx/BY8EpD+/tKl7DeNEXmYEAlOuY72ewsg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mEv6mXoOuV7cwQxfLik8hKRtAuo9u+0xVDQ+cSLgNuuHGYnvg8ehIArDL1sN0RLljejpB33LUWAMMUSQlGAOzmWIx7sOw48hq7i5q+dpaz+sYnfE2+HDiaOT2Qe8H8pnMFgFTC6EbvQ4cxI6ASRpeLllsMv4ByDC57BcyFnPdtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bzn0dlcZ; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bzn0dlcZ"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6409f6d6800so6010310a12.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405325; x=1764010125; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KaEfzU6yZVtxcuFF1g0xre8mMX/xz4F/cTBqkb/2nDs=;
        b=Bzn0dlcZMpubphzMprEqC5D/JNCsPjvwDGeRE4QPQAOkS2Fw5CcZViU1Qh9UmmgB0s
         1HuJu2nQViCzGweqqC4yKAgU39rMcgnTcWJgTM9K+X0ezTBXjv0ab3i+0gxUcjsEqC1K
         a73fSib+dMRD1x7Rqc0qhI94V73GLxx2QWnDRgsUCY1nUJrrzvLvtr3JQz9EkofYMEpD
         IxqbdKz9b7f5MCJEv/Nqe0IVsRpbpck9cl+elGOEtmwXi56M3r4O9n4/GEmaNDdlhcNl
         qS/ihubpsU2Eg+n2ZxxKNVJnorWxfX7c6vlMi3i2nwKsSD7MPTyCRABgK1ZJDFeikoHa
         WeHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405325; x=1764010125;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KaEfzU6yZVtxcuFF1g0xre8mMX/xz4F/cTBqkb/2nDs=;
        b=g77+WcDb/gx0mJI1yE6+GEBhP7XoilHoEFK8OH4riLqj7jxZTH5Y6thA45DLIfQPKD
         4ngZcWbCQsgOTMhdjcpl45PM3AxGm1LbmRKLZuZNy8nN6l3uF5SLsx5+SadbPpRY4PXW
         SPyy8EqA20j1EfGXNT+y/PP2PFyCjSxfFWa/5blVEKQHZMk93Xr3ufB/fH87OjVy94F8
         evN6UR3UiBCaa+3F9offy3tuyLJrQO3iAVKKjgvNpe1nCIdcin1S5mhMK2x+Ps/helb5
         vjXH3bEAhL7gWMpoOLslmGOlhpitbIwKlaSuDh51HfzXF+0I3qzW/TgZPUVWuVNSMERf
         hz4w==
X-Forwarded-Encrypted: i=1; AJvYcCXlZk8pCHjqtVyAuhUrCtxQN07+xbRLEkVZiOBolCJdlkt2P05NCsLI5sVZ4hYbtJhBZiQ1BRQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxxqS22DhHqzHpbxABB5I57ZOqVZc4lvfrV03Bd5GQjUKHAR89h
	qMTwy7MNq5DSqIqGYYmH/OKcQwrqFCfgTwogNXHXeTm7cMfvcjAdewmTrfUlQK9tZ0/kqOGnUBv
	1jSG4EUMobbZP3A==
X-Google-Smtp-Source: AGHT+IGYWSQvx/vSf5yAHHEgbkBONoL9bq/wnyu6GlN5XLTrHCKyyCf6BcTG/d+4znbhK0TqerfxI9YTZPVTXA==
X-Received: from edh26.prod.google.com ([2002:a05:6402:505a:b0:641:8ac2:5031])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3489:b0:641:9e1c:ba89 with SMTP id 4fb4d7f45d1cf-64350dee91dmr12404365a12.7.1763405324917;
 Mon, 17 Nov 2025 10:48:44 -0800 (PST)
Date: Mon, 17 Nov 2025 18:48:06 +0000
In-Reply-To: <20251117184815.1027271-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251117184815.1027271-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-20-smostafa@google.com>
Subject: [PATCH v5 19/27] iommu/arm-smmu-v3-kvm: Shadow the command queue
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
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
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   |  16 +++
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 103 +++++++++++++++++-
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  |   8 ++
 3 files changed, 126 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iomm=
u/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index 1d72951b7b53..87376f615798 100644
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
@@ -71,6 +73,7 @@ static struct platform_driver smmuv3_nesting_driver;
 static int smmuv3_nesting_probe(struct platform_device *pdev)
 {
 	struct resource *res;
+	void *cmdq_base;
 	struct hyp_arm_smmu_v3_device *smmu =3D &kvm_arm_smmu_array[kvm_arm_smmu_=
cur];
=20
 	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -84,6 +87,19 @@ static int smmuv3_nesting_probe(struct platform_device *=
pdev)
 	if (of_dma_is_coherent(pdev->dev.of_node))
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
index f0dae94daf89..bcb3f99fdcd2 100644
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
@@ -21,6 +20,13 @@ struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus=
;
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
 /* Transfer ownership of memory */
 static int smmu_take_pages(u64 phys, size_t size)
 {
@@ -34,6 +40,35 @@ static void smmu_reclaim_pages(u64 phys, size_t size)
 	WARN_ON(__pkvm_hyp_donate_host(phys >> PAGE_SHIFT, size >> PAGE_SHIFT));
 }
=20
+/*
+ * CMDQ, STE host copies are accessed by the hypervisor, we share them to
+ * - Prevent the host from passing protected VM memory.
+ * - Having them mapped in the hyp page table.
+ */
+static int smmu_share_pages(phys_addr_t addr, size_t size)
+{
+	int i;
+	size_t nr_pages =3D PAGE_ALIGN(size) >> PAGE_SHIFT;
+
+	for (i =3D 0 ; i < nr_pages ; ++i)
+		WARN_ON(__pkvm_host_share_hyp((addr + i * PAGE_SIZE) >> PAGE_SHIFT));
+
+	return hyp_pin_shared_mem(hyp_phys_to_virt(addr), hyp_phys_to_virt(addr +=
 size));
+}
+
+static int smmu_unshare_pages(phys_addr_t addr, size_t size)
+{
+	int i;
+	size_t nr_pages =3D PAGE_ALIGN(size) >> PAGE_SHIFT;
+
+	hyp_unpin_shared_mem(hyp_phys_to_virt(addr), hyp_phys_to_virt(addr + size=
));
+
+	for (i =3D 0 ; i < nr_pages ; ++i)
+		WARN_ON(__pkvm_host_unshare_hyp((addr + i * PAGE_SIZE) >> PAGE_SHIFT));
+
+	return 0;
+}
+
 /* Put the device in a state that can be probed by the host driver. */
 static void smmu_deinit_device(struct hyp_arm_smmu_v3_device *smmu)
 {
@@ -94,6 +129,36 @@ static int smmu_probe(struct hyp_arm_smmu_v3_device *sm=
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
+	enum kvm_pgtable_prot prot =3D PAGE_HYP;
+
+	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
+		prot |=3D KVM_PGTABLE_PROT_NORMAL_NC;
+
+	ret =3D ___pkvm_host_donate_hyp(smmu->cmdq.base_dma >> PAGE_SHIFT,
+				      cmdq_nr_pages, prot);
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
 	int i, ret;
@@ -117,7 +182,13 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_dev=
ice *smmu)
 	if (ret)
 		goto out_ret;
 	hyp_spin_lock_init(&smmu->lock);
+
+	ret =3D smmu_init_cmdq(smmu);
+	if (ret)
+		goto out_ret;
+
 	return 0;
+
 out_ret:
 	smmu_deinit_device(smmu);
 	return ret;
@@ -154,6 +225,20 @@ static int smmu_init(void)
 	return ret;
 }
=20
+static void smmu_emulate_cmdq_enable(struct hyp_arm_smmu_v3_device *smmu)
+{
+	smmu->cmdq_host.llq.max_n_shift =3D smmu->cmdq_host.q_base & Q_BASE_LOG2S=
IZE;
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
@@ -175,6 +260,13 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_de=
vice *smmu,
 		break;
 	/* Passthrough the register access for bisectiblity, handled later */
 	case ARM_SMMU_CMDQ_BASE:
+		if (is_write) {
+			/* Not allowed by the architecture */
+			WARN_ON(is_cmdq_enabled(smmu));
+			smmu->cmdq_host.q_base =3D val;
+		}
+		mask =3D read_write;
+		break;
 	case ARM_SMMU_CMDQ_PROD:
 	case ARM_SMMU_CMDQ_CONS:
 	case ARM_SMMU_STRTAB_BASE:
@@ -183,6 +275,15 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_de=
vice *smmu,
 		mask =3D read_write;
 		break;
 	case ARM_SMMU_CR0:
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
 		WARN_ON(len !=3D sizeof(u32));
 		break;
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h b/drivers/iom=
mu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
index dfeaed728982..2fb4c0cab47c 100644
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
@@ -21,6 +23,9 @@
  * @pgsize_bitmap	Supported page sizes
  * @sid_bits		Max number of SID bits supported
  * @lock		Lock to protect SMMU
+ * @cmdq		CMDQ as observed by HW
+ * @cmdq_host		Host view of the CMDQ, only q_base and llq used.
+ * @cr0			Last value of CR0
  */
 struct hyp_arm_smmu_v3_device {
 	phys_addr_t		mmio_addr;
@@ -36,6 +41,9 @@ struct hyp_arm_smmu_v3_device {
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
2.52.0.rc1.455.g30608eb744-goog

