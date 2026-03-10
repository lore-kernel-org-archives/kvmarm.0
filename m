Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABB43AF640
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 12:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773146992; cv=none; b=tZ+F77C1lG1TqkmSN2A+E9pmg3WH4jXo66w5JcR3V1MrrcXBWE/g8kmdymR+c4saAgh95bBb1p56y2F+dR8riElnISUzEGsZP3CAKzYmkFBCVhCBQChyiU6s2vYxFxKzT27ZdMGen5/iff+qNULaDMQtjCfH2gfhN0fgBV6ZAME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773146992; c=relaxed/simple;
	bh=BGZWw0pNpFUVe6fJJOqZpw/0eKKedefH/jfskrr/pLw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dS1K+eDkJiJOrw1ltoHkvXIkCZaO6kIg7+v8IOQ9gWSBowdKI33RJJ20atCcpP9MA4LJhilcxBosnn+aN52NuivCe3vtIPlckDeeI3yIY3AMRfWMtbxxn2pfan0+/Da1QR1RFzp2jr9MggC8S8226UmXkxDAYlcKdguIR1txiEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q16o+IOy; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q16o+IOy"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b9360e9f43bso1500939566b.3
        for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 05:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773146989; x=1773751789; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AuLKSluxKmhn480CzigIfSkaIIQucOGgq+FPielHBMw=;
        b=q16o+IOyuSt2qzHAZORsQvlRYgG1DNZcwJGzWyxFbgC1By/zWVOAquuV9oK/WJ7cUg
         y1a0Yn61+G/4DMgUymJOwx+PaAp/PWtMRFKHlpVefSO2uz9P895mWX3hCVaM1D921DmT
         DcCtkD7UfhoO18MKlAdkJd1RexxkZ7mrjwbIwkBh+ez9Fj61XR/OgdVHrpr+F4OTAag/
         wDoCjkJm4LxiRwOtM6oTT5xjt6KSI/ccgP1IgfOIP6M8FIYPr0m+iGt46It0f9RTfW/W
         8ai2Au1yYPxxLrohPXqHX4FOVXe5RRxbgwCNEIGqdfMMHwO6c9W/gSlylTwtZ+u4yOA7
         2blg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773146989; x=1773751789;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AuLKSluxKmhn480CzigIfSkaIIQucOGgq+FPielHBMw=;
        b=PCTRwTcJOlNwdfz8h3I1pNfxAFDaMPxEIymc+tlEr+3FT0rrG8i0VivuAPZaL3N6ow
         P70Cdf1KDCiB9PSYudHFnk5Uhm31b66h5lhEeAnJ1ojgI0UyHsC1htWwQLbhb8Wotxr9
         cbTL6yde8OBTK4mxSCmZQh3gFJdzgIo6CR3Ta7a1lm2JfvJc5hSHC81N0e0VxecG3ezR
         Y1WjIBqMkwvo0uPmzXCBSqejkRn6FDwPuHytxNHaoDKb7Pd3sffPhpMqKICiIis1fP4t
         XWJSG7RRqdul0eF5miYIFJPqTCc0SfCbrE64XZ87ZKoUmIZNHb0ADwloik4ErNzhi+6Q
         mRcQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdyCOHC69rFeQKyzFU4TGG0Tp8QxJ9t+JuDIQXfcHt+WQ+71EuO/Ht8mrsEijVBbgDvGMPXiI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwQBpF8HdYY1Q9/NQ4O6tcxbtwv8L+jbvyrXlpWsHpaNBcpvh0h
	Gno57GQvg6/cnLNpcXq/USH/Zhp4l/eO+PVfTTviQjAIsCR1AkKSEGw9kET5gpMKFke0Utkn3iz
	JznSi1NkMPzu7JLmYW8Zq6jUxwssTfw==
X-Received: from edfa4.prod.google.com ([2002:a50:9e84:0:b0:662:810d:badd])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:7290:b0:b8e:9a0:1bfb with SMTP id a640c23a62f3a-b942d58ea78mr829388866b.0.1773146989033;
 Tue, 10 Mar 2026 05:49:49 -0700 (PDT)
Date: Tue, 10 Mar 2026 12:49:25 +0000
In-Reply-To: <20260310124933.830025-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260310124933.830025-7-sebastianene@google.com>
Subject: [PATCH 06/14] KVM: arm64: Add infrastructure for ITS emulation setup
From: Sebastian Ene <sebastianene@google.com>
To: alexandru.elisei@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com
Cc: catalin.marinas@arm.com, dbrazdil@google.com, joey.gouly@arm.com, 
	kees@kernel.org, mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, 
	perlarsen@google.com, qperret@google.com, rananta@google.com, 
	sebastianene@google.com, smostafa@google.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@kernel.org, vdonnefort@google.com, bgrzesik@google.com, 
	will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Share the host command queue with the hypervisor. Donate
the original command queue memory to the hypervisor to ensure
host exclusion and trap accesses on GITS_CWRITE register.
On a CWRITER write, the hypervisor copies commands from the
host's queue to the protected queue before updating the
hardware register.
This ensures the hypervisor mediates all commands sent to
the physical ITS.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h             |   1 +
 arch/arm64/kvm/hyp/include/nvhe/its_emulate.h |  17 ++
 arch/arm64/kvm/hyp/nvhe/its_emulate.c         | 203 ++++++++++++++++++
 3 files changed, 221 insertions(+)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/its_emulate.h

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index ef00c1bf7d00..dc5ef2f9ac49 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -28,6 +28,7 @@ struct pkvm_protected_reg {
 	u64 start_pfn;
 	size_t num_pages;
 	pkvm_emulate_handler *cb;
+	void *priv;
 };
 
 extern struct pkvm_protected_reg kvm_nvhe_sym(pkvm_protected_regs)[];
diff --git a/arch/arm64/kvm/hyp/include/nvhe/its_emulate.h b/arch/arm64/kvm/hyp/include/nvhe/its_emulate.h
new file mode 100644
index 000000000000..6be24c723658
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/its_emulate.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __NVHE_ITS_EMULATE_H
+#define __NVHE_ITS_EMULATE_H
+
+
+#include <asm/kvm_pkvm.h>
+
+
+struct its_shadow_tables;
+
+int pkvm_init_gic_its_emulation(phys_addr_t dev_addr, void *priv_state,
+				struct its_shadow_tables *shadow);
+
+void pkvm_handle_gic_emulation(struct pkvm_protected_reg *region, u64 offset, bool write,
+			       u64 *reg, u8 reg_size);
+#endif /* __NVHE_ITS_EMULATE_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
index 0eecbb011898..4a3ccc90a1a9 100644
--- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
+++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
@@ -1,8 +1,75 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 #include <asm/kvm_pkvm.h>
+#include <linux/irqchip/arm-gic-v3.h>
+#include <nvhe/its_emulate.h>
 #include <nvhe/mem_protect.h>
 
+struct its_priv_state {
+	void *base;
+	void *cmd_hyp_base;
+	void *cmd_host_base;
+	void *cmd_host_cwriter;
+	struct its_shadow_tables *shadow;
+	hyp_spinlock_t its_lock;
+};
+
+struct its_handler {
+	u64 offset;
+	u8 access_size;
+	void (*write)(struct its_priv_state *its, u64 offset, u64 value);
+	void (*read)(struct its_priv_state *its, u64 offset, u64 *read);
+};
+
+DEFINE_HYP_SPINLOCK(its_setup_lock);
+
+static void cwriter_write(struct its_priv_state *its, u64 offset, u64 value)
+{
+	u64 cwriter_offset = value & GENMASK(19, 5);
+	int cmd_len, cmd_offset;
+	size_t cmdq_sz = its->shadow->cmdq_len;
+
+	if (cwriter_offset > cmdq_sz)
+		return;
+
+	cmd_offset = its->cmd_host_cwriter - its->cmd_host_base;
+	cmd_len = cwriter_offset - cmd_offset;
+	if (cmd_len < 0)
+		cmd_len = cmdq_sz - cmd_offset;
+
+	if (cmd_offset + cmd_len > cmdq_sz)
+		return;
+
+	memcpy(its->cmd_hyp_base + cmd_offset, its->cmd_host_cwriter, cmd_len);
+
+	its->cmd_host_cwriter = its->cmd_host_base +
+		(cmd_offset + cmd_len) % cmdq_sz;
+	if (its->cmd_host_cwriter == its->cmd_host_base) {
+		memcpy(its->cmd_hyp_base, its->cmd_host_base, cwriter_offset);
+
+		its->cmd_host_cwriter = its->cmd_host_base + cwriter_offset;
+	}
+
+	writeq_relaxed(value, its->base + GITS_CWRITER);
+}
+
+static void cwriter_read(struct its_priv_state *its, u64 offset, u64 *read)
+{
+	*read = readq_relaxed(its->base + GITS_CWRITER);
+}
+
+#define ITS_HANDLER(off, sz, write_cb, read_cb)	\
+{							\
+	.offset = (off),				\
+	.access_size = (sz),				\
+	.write = (write_cb),				\
+	.read = (read_cb),				\
+}
+
+static struct its_handler its_handlers[] = {
+	ITS_HANDLER(GITS_CWRITER, sizeof(u64), cwriter_write, cwriter_read),
+	{},
+};
 
 void pkvm_handle_forward_req(struct pkvm_protected_reg *region, u64 offset, bool write,
 			     u64 *reg, u8 reg_size)
@@ -21,3 +88,139 @@ void pkvm_handle_forward_req(struct pkvm_protected_reg *region, u64 offset, bool
 			writeq_relaxed(*reg, addr);
 	}
 }
+
+void pkvm_handle_gic_emulation(struct pkvm_protected_reg *region, u64 offset, bool write,
+			       u64 *reg, u8 reg_size)
+{
+	struct its_priv_state *its_priv = region->priv;
+	void __iomem *addr;
+	struct its_handler *reg_handler;
+
+	if (!its_priv)
+		return;
+
+	addr = its_priv->base + offset;
+	for (reg_handler = its_handlers; reg_handler->access_size; reg_handler++) {
+		if (reg_handler->offset > offset ||
+		    reg_handler->offset + reg_handler->access_size <= offset)
+			continue;
+
+		if (reg_handler->access_size & (reg_size - 1))
+			continue;
+
+		if (write && reg_handler->write) {
+			hyp_spin_lock(&its_priv->its_lock);
+			reg_handler->write(its_priv, offset, *reg);
+			hyp_spin_unlock(&its_priv->its_lock);
+			return;
+		}
+
+		if (!write && reg_handler->read) {
+			hyp_spin_lock(&its_priv->its_lock);
+			reg_handler->read(its_priv, offset, reg);
+			hyp_spin_unlock(&its_priv->its_lock);
+			return;
+		}
+
+		return;
+	}
+
+	pkvm_handle_forward_req(region, offset, write, reg, reg_size);
+}
+
+static struct pkvm_protected_reg *get_region(phys_addr_t dev_addr)
+{
+	int i;
+	u64 dev_pfn = dev_addr >> PAGE_SHIFT;
+
+	for (i = 0; i < PKVM_PROTECTED_REGS_NUM; i++) {
+		if (pkvm_protected_regs[i].start_pfn == dev_pfn)
+			return &pkvm_protected_regs[i];
+	}
+
+	return NULL;
+}
+
+static int pkvm_setup_its_shadow_cmdq(struct its_shadow_tables *shadow)
+{
+	int ret, i, num_pages;
+	u64 shadow_start_pfn, original_start_pfn;
+	void *cmd_shadow_va = kern_hyp_va(shadow->cmd_shadow);
+
+	shadow_start_pfn = hyp_virt_to_pfn(cmd_shadow_va);
+	original_start_pfn = hyp_virt_to_pfn(kern_hyp_va(shadow->cmd_original));
+	num_pages = shadow->cmdq_len >> PAGE_SHIFT;
+
+	for (i = 0; i < num_pages; i++) {
+		ret = __pkvm_host_share_hyp(shadow_start_pfn + i);
+		if (ret)
+			goto unshare_shadow;
+	}
+
+	ret = hyp_pin_shared_mem(cmd_shadow_va, cmd_shadow_va + shadow->cmdq_len);
+	if (ret)
+		goto unshare_shadow;
+
+	ret = __pkvm_host_donate_hyp(original_start_pfn, num_pages);
+	if (ret)
+		goto unpin_shadow;
+
+	return ret;
+
+unpin_shadow:
+	hyp_unpin_shared_mem(cmd_shadow_va, cmd_shadow_va + shadow->cmdq_len);
+
+unshare_shadow:
+	for (i = i - 1; i >= 0; i--)
+		__pkvm_host_unshare_hyp(shadow_start_pfn + i);
+
+	return ret;
+}
+
+int pkvm_init_gic_its_emulation(phys_addr_t dev_addr, void *host_priv_state,
+				struct its_shadow_tables *host_shadow)
+{
+	int ret;
+	struct its_priv_state *priv_state = kern_hyp_va(host_priv_state);
+	struct its_shadow_tables *shadow = kern_hyp_va(host_shadow);
+	struct pkvm_protected_reg *its_reg;
+
+	hyp_spin_lock(&its_setup_lock);
+	its_reg = get_region(dev_addr);
+	if (!its_reg)
+		return -ENODEV;
+
+	if (its_reg->priv)
+		return -EOPNOTSUPP;
+
+	ret = __pkvm_host_donate_hyp(hyp_virt_to_pfn(priv_state), 1);
+	if (ret)
+		return ret;
+
+	ret = __pkvm_host_donate_hyp(hyp_virt_to_pfn(shadow), 1);
+	if (ret)
+		goto err_with_state;
+
+	ret = pkvm_setup_its_shadow_cmdq(shadow);
+	if (ret)
+		goto err_with_shadow;
+
+	its_reg->priv = priv_state;
+
+	hyp_spin_lock_init(&priv_state->its_lock);
+	priv_state->shadow = shadow;
+	priv_state->base = __hyp_va(dev_addr);
+
+	priv_state->cmd_hyp_base = kern_hyp_va(shadow->cmd_original);
+	priv_state->cmd_host_base = kern_hyp_va(shadow->cmd_shadow);
+	priv_state->cmd_host_cwriter = priv_state->cmd_host_base;
+
+	hyp_spin_unlock(&its_setup_lock);
+
+	return 0;
+err_with_shadow:
+	__pkvm_hyp_donate_host(hyp_virt_to_pfn(shadow), 1);
+err_with_state:
+	__pkvm_hyp_donate_host(hyp_virt_to_pfn(priv_state), 1);
+	return ret;
+}
-- 
2.53.0.473.g4a7958ca14-goog

