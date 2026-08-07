Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2160E47986D
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 16:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121031; cv=none; b=Ri69SqXLN0CCADd28fcxKRr8p8Ec4bc0nr/+WQrH5weBFaUoGixfMoZavD8kB301mPNkMpEDqe35cRM1WKxXVLtlq49ZMJ0Pmz4/FIEmB2HVTVUfDfVc48w6dlUateCSYUUsN5K54CBgBy8WE1ZlekUzaxESJtHU0wFb7re1/Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121031; c=relaxed/simple;
	bh=FZjb20JofCESqDsnXMWtIjjk7phaXd3uuOYdnUvuix4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J5wo7Ew36QsN3NbBvSkw9uzEV0WMHaUibXqL3COKf8urbVEK4YJPXC2kC3K7CMDDdVWbLhyAXD2TDY3S0Mt3oU1Dy2uKsyMKGDRaeA5cO7F1CsGu8gD/wvXTWaplfoGEFg/EteV9OU0KJOHRGYcRHOC03BCbr78sfzykzrCRh0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bOB0PU7t; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bOB0PU7t"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4956c1655c3so19491965e9.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Aug 2026 09:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786121027; x=1786725827; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ZQn1FQ7zxmEvhT55im1AaHwQn9RplPZn28ifPmSEdaY=;
        b=bOB0PU7tTGj/ZI6yo5aDMnL72r532LaiK0BhtQ4IJCZZ+jk/UAWiqXDRIDt4FQkXRc
         PI24QlDTNDOgVujoYj1JCOE+YZ1TK54kFXCL2k4fyQLyZioQn7jDmxRA7d53MeOqEmoV
         FyOWA03ONnGjcYFa8J60oiv1n6QQAIWIadVTcYt+0V4WGvgS8Gib5qEDQRCjs2C6bbSA
         rHLNPJN7qyWlg07vp/LKIxODx6aSk4bZH5qtK/k342fEZidjubvUKg5t6n7hzaQDe4cc
         fk7NARU8snGwNOrZ0/kHtCLCIvIZlLgBVr1jSyBlP6Es0DCMj4vUf+iU9S3DHRfa8aSH
         XxoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786121027; x=1786725827;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZQn1FQ7zxmEvhT55im1AaHwQn9RplPZn28ifPmSEdaY=;
        b=szufj9tST8/JZmSGwUad5Mb/Ipbvw8QB9MTnoKpJ+/Apbd7lFLx3gDoZTxyypAg0Vr
         ikLpBmIEhPnPzEn1hxtQyKjh/kKDRF1j5NuLk4jveCaeOsiUm6ZSrrkHlbbopCMAdgnb
         9igX+J6mO69/6jfH8hr1c3JZtMZ96zBq6fKBVuS/6qztXqsPnZcwkj4WMlKowZk/Z/jm
         UTIjZgG8lFIQdiqf2LHjoa4ULa8+DjH+F43D48Zo6sLLrITJgFZaSRyUDnAeyO8aBReN
         Rx/MYtXZ19awC+XXWT6e04+wl/EjIbhLenU4pD0t21ntCMYBllXAP3yIyR02QxnAS6Wk
         PHDg==
X-Gm-Message-State: AOJu0YyGFtnrx1qs+xfjlxOyi2eIANPiBlJodq8HVLqU5J4nrk7pfb7R
	dURW27xFwU+iQLLwbKJ2YY2cCOYp4kx0/U9dd6USog4F+holRTkHmhSLdWs+mGvCb1+uM0iay6m
	R5mKPDEAuL1Q+nIrdIndiOJkn2sewPA==
X-Received: from wmol19.prod.google.com ([2002:a05:600c:47d3:b0:493:bdba:620b])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b51:b0:495:6b55:f938 with SMTP id 5b1f17b1804b1-4994e7ba99emr358910455e9.10.1786121026918;
 Fri, 07 Aug 2026 09:43:46 -0700 (PDT)
Date: Fri,  7 Aug 2026 16:43:16 +0000
In-Reply-To: <20260807164322.2970811-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260807164322.2970811-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260807164322.2970811-8-sebastianene@google.com>
Subject: [PATCH v2 06/13] KVM: arm64: Shadow the ITS command queue and setup emulation
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, fuad.tabba@linux.dev, joey.gouly@arm.com, 
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, rananta@google.com, 
	Sascha.Bischoff@arm.com, suzuki.poulose@arm.com, will@kernel.org
Cc: kvmarm@lists.linux.dev, android-kvm@google.com, bgrzesik@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	nathan@kernel.org, perlarsen@google.com, sebastianene@google.com, 
	seiden@linux.ibm.com, smostafa@google.com, tglx@kernel.org, 
	vdonnefort@google.com, vladimir.murzin@arm.com, yuzenghui@huawei.com, 
	zenghui.yu@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Expose two functions that will be used to setup the entry point into the
pKVM ITS emulation. One will be called from an hvc to setup the ITS
structures and the other one will be called from a data abort to handle
the emulation. The later one will be stored in a pkvm_protected_reg as
part of the register_its_emulated_region once the command emulation is in
place.

Donate two memory regions as part of the emulation setup phase. One
holds GIC ITS driver state information and the other is used to store
private state information for the emulation and it is zeroed out.
Shadow the command queue by sharing a copy of it from the GIC ITS driver
and donate the original queue to the hypervisor. The host will use a
copy, while the emulation will use the original queue programmed in
hardware. This makes sure that the original queue is not accessible to
the host.
When the GIC ITS driver writes a command, the emulation will trap the
access to the CWRITER register and it will validate the
command before copying it to the original queue.

Re-use some of the definitions for command format and move them
from the GIC ITS driver to the public header.

Co-authored-by: Bart=C5=82omiej Grzesik <bgrzesik@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h             |   1 +
 arch/arm64/kvm/hyp/include/nvhe/its_emulate.h |  14 +
 arch/arm64/kvm/hyp/nvhe/its_emulate.c         | 285 ++++++++++++++++++
 drivers/irqchip/irq-gic-v3-its.c              |  12 -
 include/linux/irqchip/arm-gic-v3.h            |  12 +
 5 files changed, 312 insertions(+), 12 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/its_emulate.h

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm=
_pkvm.h
index 370225f0e72c..78597210a53c 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -27,6 +27,7 @@ struct pkvm_protected_reg {
 	u64 pfn;
 	u64 nr_pages;
 	pkvm_emulate_handler *cb;
+	void *priv;
 };
=20
 extern struct pkvm_protected_reg kvm_nvhe_sym(pkvm_protected_regs)[];
diff --git a/arch/arm64/kvm/hyp/include/nvhe/its_emulate.h b/arch/arm64/kvm=
/hyp/include/nvhe/its_emulate.h
new file mode 100644
index 000000000000..29429feb30a9
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/its_emulate.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __NVHE_ITS_EMULATE_H
+#define __NVHE_ITS_EMULATE_H
+
+#include <asm/kvm_pkvm.h>
+
+struct its_host_state;
+
+int pkvm_its_emulate_setup(phys_addr_t dev_addr, struct its_host_state *ho=
st_state, void *priv,
+			   size_t priv_num_pages);
+void pkvm_its_emulate_handler(struct pkvm_protected_reg *region, u64 offse=
t, bool write, u64 *reg,
+			      u8 reg_size);
+#endif /* __NVHE_ITS_EMULATE_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvh=
e/its_emulate.c
index 63a42f520ed2..e943ab972aa5 100644
--- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
+++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
@@ -2,6 +2,9 @@
=20
 #include <asm/kvm_pkvm.h>
 #include <nvhe/mem_protect.h>
+#include <nvhe/its_emulate.h>
+
+#include <linux/irqchip/arm-gic-v3.h>
=20
 void its_emulate_forward_req(struct pkvm_protected_reg *region, u64 offset=
, bool write, u64 *reg,
 			     u8 reg_size)
@@ -35,3 +38,285 @@ void its_emulate_forward_req(struct pkvm_protected_reg =
*region, u64 offset, bool
 		break;
 	}
 }
+
+struct its_handler {
+	u64	offset;
+	u8	access_size;
+	void	(*write)(struct pkvm_protected_reg *region, u64 offset, u64 value);
+	void	(*read)(struct pkvm_protected_reg *region, u64 offset, u64 *read);
+};
+
+#define ITS_HANDLER(off, sz, write_cb, read_cb)		\
+{							\
+	.offset =3D (off),				\
+	.access_size =3D (sz),				\
+	.write =3D (write_cb),				\
+	.read =3D (read_cb),				\
+}
+
+struct its_priv_state {
+	/* The location of the ITS in the hypervisor VA */
+	void __iomem	*base;
+
+	/* ITS command queue use by the hardware */
+	void		*cmd_original;
+	void		*cmd_host_copy;
+	u64		cmd_offset;
+	bool		needs_flush;
+	hyp_spinlock_t	its_lock;
+
+	struct its_host_state	*host_state;
+};
+
+#define GITS_CWRITER_RETRY	BIT_ULL(0)
+#define GITS_CWRITER_OFFSET	GENMASK_ULL(19, 5)
+
+#define GITS_CREADR_STALLED	BIT_ULL(0)
+#define GITS_CREADR_OFFSET	GENMASK_ULL(19, 5)
+
+static int submit_single_cmd(struct its_priv_state *its, bool retry)
+{
+	size_t cmdq_sz =3D its->host_state->cmdq_len;
+	u64 timeout =3D 1000;
+	u64 offset, cwriter, creadr;
+
+	offset =3D (its->cmd_offset + sizeof(struct its_cmd_block)) % cmdq_sz;
+
+	cwriter =3D offset & GITS_CWRITER_OFFSET;
+	cwriter |=3D FIELD_PREP(GITS_CWRITER_RETRY, retry);
+	writeq_relaxed(cwriter, its->base + GITS_CWRITER);
+
+	while (its->cmd_offset !=3D offset) {
+		creadr =3D readq_relaxed(its->base + GITS_CREADR);
+
+		/* Command failed. */
+		if (FIELD_GET(GITS_CREADR_STALLED, creadr))
+			return -EIO;
+
+		its->cmd_offset =3D creadr & GITS_CREADR_OFFSET;
+		if (its->cmd_offset =3D=3D offset)
+			return 0;
+
+		/*
+		 * We can't spin here forever and we can't roll back
+		 * the cmd queue pointer. Let's revert the cmd effects in the
+		 * emulation layer and then go back to the driver to let it
+		 * decide what to do next.
+		 */
+		if (!timeout--)
+			return -EBUSY;
+	}
+
+	return 0;
+}
+
+static int process_cmd(struct its_priv_state *its, struct its_cmd_block *c=
md,
+		       bool rollback)
+{
+	/* Passthrough everything for now */
+	return 0;
+}
+
+static void cwriter_write(struct pkvm_protected_reg *region, u64 offset, u=
64 value)
+{
+	struct its_priv_state *its =3D region->priv;
+	struct its_cmd_block cmd, raw;
+	u64 new_offset;
+	bool retry;
+	int i;
+
+	new_offset =3D value & GITS_CWRITER_OFFSET;
+	if (new_offset >=3D its->host_state->cmdq_len)
+		return;
+
+	retry =3D FIELD_GET(GITS_CWRITER_RETRY, value);
+	while (its->cmd_offset !=3D new_offset) {
+		memcpy(&raw, its->cmd_host_copy + its->cmd_offset, sizeof(raw));
+
+		for (i =3D 0; i < ARRAY_SIZE(cmd.raw_cmd); i++)
+			cmd.raw_cmd[i] =3D le64_to_cpu(raw.raw_cmd_le[i]);
+
+		if (process_cmd(its, &cmd, /* rollback */ false))
+			return;
+
+		memcpy(its->cmd_original + its->cmd_offset, &raw, sizeof(struct its_cmd_=
block));
+
+		if (its->needs_flush)
+			gic_flush_dcache_to_poc(its->cmd_original + its->cmd_offset, sizeof(cmd=
));
+		else
+			dsb(ishst);
+
+		if (submit_single_cmd(its, retry)) {
+			WARN_ON(process_cmd(its, &cmd, /* rollback */ true));
+			return;
+		}
+	}
+}
+
+static void cwriter_read(struct pkvm_protected_reg *region, u64 offset, u6=
4 *read)
+{
+	struct its_priv_state *its =3D region->priv;
+	*read =3D readq_relaxed(its->base + GITS_CWRITER);
+}
+
+static struct its_handler its_handlers[] =3D {
+	ITS_HANDLER(GITS_CWRITER, sizeof(u64), cwriter_write, cwriter_read),
+	{},
+};
+
+void pkvm_its_emulate_handler(struct pkvm_protected_reg *region, u64 offse=
t, bool write, u64 *reg,
+			      u8 reg_size)
+{
+	struct its_priv_state *priv =3D region->priv;
+	struct its_handler *reg_handler;
+
+	if (!priv || !IS_ALIGNED(offset, reg_size))
+		return;
+
+	for (reg_handler =3D its_handlers; reg_handler->access_size; reg_handler+=
+) {
+		if (reg_handler->offset > offset ||
+		    reg_handler->offset + reg_handler->access_size <=3D offset)
+			continue;
+
+		if (reg_handler->access_size < reg_size)
+			return;
+
+		if (write && reg_handler->write) {
+			hyp_spin_lock(&priv->its_lock);
+			reg_handler->write(region, offset, *reg);
+			hyp_spin_unlock(&priv->its_lock);
+			return;
+		}
+
+		if (!write && reg_handler->read) {
+			hyp_spin_lock(&priv->its_lock);
+			reg_handler->read(region, offset, reg);
+			hyp_spin_unlock(&priv->its_lock);
+			return;
+		}
+
+		return;
+	}
+
+	its_emulate_forward_req(region, offset, write, reg, reg_size);
+}
+
+static int pkvm_setup_its_shadow_cmdq(struct its_host_state *host_state)
+{
+	u64 start_pfn, num_pages, i;
+	int ret;
+
+	start_pfn =3D hyp_virt_to_pfn(host_state->cmd_host_copy);
+	num_pages =3D host_state->cmdq_len >> PAGE_SHIFT;
+
+	for (i =3D 0; i < num_pages; i++) {
+		ret =3D __pkvm_host_share_hyp(start_pfn + i);
+		if (ret)
+			goto unshare_cmd_host;
+	}
+
+	ret =3D hyp_pin_shared_mem(host_state->cmd_host_copy,
+				 host_state->cmd_host_copy + host_state->cmdq_len);
+	if (ret)
+		goto unshare_cmd_host;
+
+	ret =3D __pkvm_host_donate_hyp(hyp_virt_to_pfn(host_state->cmd_original),=
 num_pages);
+	if (ret) {
+		hyp_unpin_shared_mem(host_state->cmd_host_copy,
+				     host_state->cmd_host_copy + host_state->cmdq_len);
+		goto unshare_cmd_host;
+	}
+
+	return ret;
+unshare_cmd_host:
+	if (i =3D=3D 0)
+		return ret;
+
+	for (i =3D i - 1; i >=3D 0; i--)
+		__pkvm_host_unshare_hyp(start_pfn + i);
+	return ret;
+}
+
+static struct pkvm_protected_reg *get_region(phys_addr_t dev_addr)
+{
+	int i;
+
+	for (i =3D 0; i < num_protected_reg; i++) {
+		if (PFN_PHYS(pkvm_protected_regs[i].pfn) =3D=3D dev_addr)
+			return &pkvm_protected_regs[i];
+	}
+
+	return NULL;
+}
+
+DEFINE_HYP_SPINLOCK(its_setup_lock);
+
+int pkvm_its_emulate_setup(phys_addr_t dev_addr, struct its_host_state *ho=
st_state, void *priv,
+			   size_t priv_num_pages)
+{
+	struct pkvm_protected_reg *its_reg;
+	struct its_priv_state *priv_state;
+	int ret;
+
+	if (!PAGE_ALIGNED(host_state) || !PAGE_ALIGNED(priv) || !priv_num_pages)
+		return -EINVAL;
+
+	host_state =3D kern_hyp_va(host_state);
+	priv =3D kern_hyp_va(priv);
+
+	hyp_spin_lock(&its_setup_lock);
+	its_reg =3D get_region(dev_addr);
+	if (!its_reg) {
+		ret =3D -ENODEV;
+		goto err_unlock;
+	}
+
+	if (its_reg->priv) {
+		ret =3D -EOPNOTSUPP;
+		goto err_unlock;
+	}
+
+	ret =3D __pkvm_host_donate_hyp(hyp_virt_to_pfn(priv), priv_num_pages);
+	if (ret)
+		goto err_unlock;
+
+	priv_state =3D priv;
+	memset(priv_state, 0, priv_num_pages << PAGE_SHIFT);
+
+	ret =3D __pkvm_host_donate_hyp(hyp_virt_to_pfn(host_state), 1);
+	if (ret)
+		goto err_with_priv;
+
+	host_state->cmd_original =3D kern_hyp_va(host_state->cmd_original);
+	host_state->cmd_host_copy =3D kern_hyp_va(host_state->cmd_host_copy);
+
+	ret =3D pkvm_setup_its_shadow_cmdq(host_state);
+	if (ret)
+		goto err_with_host_state;
+
+	hyp_spin_lock_init(&priv_state->its_lock);
+
+	priv_state->host_state =3D host_state;
+	priv_state->base =3D (void __iomem *)__hyp_va(dev_addr);
+	priv_state->cmd_original =3D host_state->cmd_original;
+	priv_state->cmd_host_copy =3D host_state->cmd_host_copy;
+
+	priv_state->cmd_offset =3D readq_relaxed(priv_state->base + GITS_CREADR) =
&
+		GITS_CREADR_OFFSET;
+	priv_state->needs_flush =3D
+		(readq_relaxed(priv_state->base + GITS_CBASER) & GITS_CBASER_SHAREABILIT=
Y_MASK) !=3D
+		GITS_CBASER_InnerShareable;
+
+	its_reg->priv =3D priv_state;
+
+	hyp_spin_unlock(&its_setup_lock);
+
+	return 0;
+err_with_host_state:
+	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(host_state), 1));
+err_with_priv:
+	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(priv_state), 1));
+err_unlock:
+	hyp_spin_unlock(&its_setup_lock);
+	return ret;
+}
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-=
its.c
index e74ae9220af5..4736e49e3f2d 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -121,8 +121,6 @@ static DEFINE_PER_CPU(struct its_node *, local_4_1_its)=
;
 #define is_v4_1(its)		(!!((its)->typer & GITS_TYPER_VMAPP))
 #define device_ids(its)		(FIELD_GET(GITS_TYPER_DEVBITS, (its)->typer) + 1)
=20
-#define ITS_ITT_ALIGN		SZ_256
-
 /* The maximum number of VPEID bits supported by VLPI commands */
 #define ITS_MAX_VPEID_BITS						\
 	({								\
@@ -515,16 +513,6 @@ struct its_cmd_desc {
 	};
 };
=20
-/*
- * The ITS command block, which is what the ITS actually parses.
- */
-struct its_cmd_block {
-	union {
-		u64	raw_cmd[4];
-		__le64	raw_cmd_le[4];
-	};
-};
-
 #define ITS_CMD_QUEUE_SZ		SZ_64K
 #define ITS_CMD_QUEUE_NR_ENTRIES	(ITS_CMD_QUEUE_SZ / sizeof(struct its_cmd=
_block))
=20
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm=
-gic-v3.h
index b75f82cef4bf..7f72632115b8 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -524,6 +524,8 @@
 #define GITS_CMD_VSGI			GITS_CMD_GICv4(3)
 #define GITS_CMD_INVDB			GITS_CMD_GICv4(0xe)
=20
+#define ITS_ITT_ALIGN		SZ_256
+
 /*
  * ITS error numbers
  */
@@ -686,6 +688,16 @@ struct its_host_state {
 	size_t			cmdq_len;
 };
=20
+/*
+ * The ITS command block, which is what the ITS actually parses.
+ */
+struct its_cmd_block {
+	union {
+		u64	raw_cmd[4];
+		__le64	raw_cmd_le[4];
+	};
+};
+
 /*
  * Callback used to initialize the emulation. It is expected to allocate m=
emory for the private
  * state of the emulation and receive as arguments copy of the host ITS dr=
iver state along
--=20
2.55.0.654.g21b8a5bc05-goog

