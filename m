Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F4371B49
	for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 20:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706647551; cv=none; b=lwC3mfVm6P3JN97+SUZ3Z3uPZRbEjWF1KPgaeuXNV1W75g1Ds0ouNrrDGdNoijw0NiZfrBb00FVQ2Gjxs03Wjgc5+U7Yl2ooK+3mvdofGIwT57OEQu2n6DrpMePwQYOrg5/pRCCaZK9yFxFPgLbECywCz552T03Hhadjvs7ENSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706647551; c=relaxed/simple;
	bh=X9HRIoz3kgvhZ5nGDGscpLYIIFhYLJlYgdmtg53Di4Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IPmklq5NKfQczv3JRZR9cW/CnPP3pRJqNDBbvCpFUPWq6bgOji67KmluZPrf2JARI7oJCy0qFTIAZKaqzVUx4dkyRclsQl+5toXXj88zdEQKvD+T6b9cTxCkq8wIFpToU/hwpvVNsaU4cEdwZx5+X30fGkHrS60CVjLh3cfL+5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mBEZbAgU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mBEZbAgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F004C43399;
	Tue, 30 Jan 2024 20:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706647551;
	bh=X9HRIoz3kgvhZ5nGDGscpLYIIFhYLJlYgdmtg53Di4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBEZbAgUzdBTgITPYvHgFCpAeTq2eDO8aCuWZeCYIltWlqnHTJYr46bxJK+1AxuYL
	 cFMi5P0a8C2uQA9jVuZ5m9kEmNYnIgF4tRXfMONUKqs83IiTbXp0iLjxb1kks6RPfd
	 ESWUZfr+PZeTiHIPp3pOLDtv8pj7fzLJUNSyK+UkDmeydAdYea8gq+RgTkFSAQEUd9
	 ajyckQItmG9b0qqaQbN4ZTSqXu4N5uFvQFZPLhPWjSgTh19PMo0F9zIuUVZrWyvVRh
	 q8bnwnBEo12CzsmK+KR1m9ly43IKzLBEHnl+jgbObxfIuflTFaUKQYNcUUz+cJGAVi
	 l6GETx00vSouw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rUuzN-00GNsE-TD;
	Tue, 30 Jan 2024 20:45:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 25/25] KVM: arm64: Add debugfs file for guest's ID registers
Date: Tue, 30 Jan 2024 20:45:32 +0000
Message-Id: <20240130204533.693853-26-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240130204533.693853-1-maz@kernel.org>
References: <20240130204533.693853-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Debugging ID register setup can be a complicated affair. Give the
kernel hacker a way to dump that state in an easy to parse way.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kvm/sys_regs.c         | 81 +++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 50a122d42587..ea8acc1914aa 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -319,6 +319,9 @@ struct kvm_arch {
 	/* PMCR_EL0.N value for the guest */
 	u8 pmcr_n;
 
+	/* Iterator for idreg debugfs */
+	u8	idreg_debugfs_iter;
+
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 	struct maple_tree smccc_filter;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2cb69efac1dc..d08d67e2d441 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -12,6 +12,7 @@
 #include <linux/bitfield.h>
 #include <linux/bsearch.h>
 #include <linux/cacheinfo.h>
+#include <linux/debugfs.h>
 #include <linux/kvm_host.h>
 #include <linux/mm.h>
 #include <linux/printk.h>
@@ -3421,6 +3422,81 @@ static bool emulate_sys_reg(struct kvm_vcpu *vcpu,
 	return false;
 }
 
+static void *idregs_debug_start(struct seq_file *s, loff_t *pos)
+{
+	struct kvm *kvm = s->private;
+	u8 *iter;
+
+	mutex_lock(&kvm->arch.config_lock);
+
+	iter = &kvm->arch.idreg_debugfs_iter;
+	if (*iter == (u8)~0) {
+		*iter = *pos;
+		if (*iter >= KVM_ARM_ID_REG_NUM)
+			iter = NULL;
+	} else {
+		iter = ERR_PTR(-EBUSY);
+	}
+
+	mutex_unlock(&kvm->arch.config_lock);
+
+	return iter;
+}
+
+static void *idregs_debug_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct kvm *kvm = s->private;
+
+	(*pos)++;
+
+	if ((kvm->arch.idreg_debugfs_iter + 1) < KVM_ARM_ID_REG_NUM) {
+		kvm->arch.idreg_debugfs_iter++;
+
+		return &kvm->arch.idreg_debugfs_iter;
+	}
+
+	return NULL;
+}
+
+static void idregs_debug_stop(struct seq_file *s, void *v)
+{
+	struct kvm *kvm = s->private;
+
+	if (IS_ERR(v))
+		return;
+
+	mutex_lock(&kvm->arch.config_lock);
+
+	kvm->arch.idreg_debugfs_iter = ~0;
+
+	mutex_unlock(&kvm->arch.config_lock);
+}
+
+static int idregs_debug_show(struct seq_file *s, void *v)
+{
+	struct kvm *kvm = s->private;
+	const struct sys_reg_desc *desc;
+
+	desc = first_idreg + kvm->arch.idreg_debugfs_iter;
+
+	if (!desc->name)
+		return 0;
+
+	seq_printf(s, "%20s:\t%016llx\n",
+		   desc->name, IDREG(kvm, IDX_IDREG(kvm->arch.idreg_debugfs_iter)));
+
+	return 0;
+}
+
+static const struct seq_operations idregs_debug_sops = {
+	.start	= idregs_debug_start,
+	.next	= idregs_debug_next,
+	.stop	= idregs_debug_stop,
+	.show	= idregs_debug_show,
+};
+
+DEFINE_SEQ_ATTRIBUTE(idregs_debug);
+
 static void kvm_reset_id_regs(struct kvm_vcpu *vcpu)
 {
 	const struct sys_reg_desc *idreg = first_idreg;
@@ -3440,6 +3516,11 @@ static void kvm_reset_id_regs(struct kvm_vcpu *vcpu)
 		id = reg_to_encoding(idreg);
 	}
 
+	kvm->arch.idreg_debugfs_iter = ~0;
+
+	debugfs_create_file("idregs", 0444, kvm->debugfs_dentry, kvm,
+			    &idregs_debug_fops);
+
 	set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
 }
 
-- 
2.39.2

