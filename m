Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB461756F
	for <kvmarm@lists.linux.dev>; Mon,  5 Feb 2024 10:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707129292; cv=none; b=iuTZG6FSOnibRQYyYX3MAI9EAVM/aq++bfdDFAXQLDABFmkdW8UOKjbBUkr69OPRkVIQnL8Bb5bCe/p2vWCOkxJArLCpQZQXiJpbOcXKoJ4YAEMrgB3QrXUTt2JPahwTXZritLXGGIfyzsxEKVDYEtkRGm9O5aEZBrYFmcVYucs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707129292; c=relaxed/simple;
	bh=tdA+RanhlYc1Yzx3TK/PJ3PZV8qD9pzS60GTK2Epn1I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ryezJ7dZKlV1Z+Okf4kCwSHlV/f2TjSMRlm0HgUOc06wzwJh3Fsh3nMy7KxEPVUlmzZMAfduejmEPSOQt1hr0xMB8ZF0iOp3/wgd8C6IwGBXuwdJW7g/G4mmZ/dGF7DJoMMVrrOo3gQyTJykz7LpL9tr57Izl4k7vpyG9nk5+rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gvqmj2t7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gvqmj2t7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26ACFC433C7;
	Mon,  5 Feb 2024 10:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707129292;
	bh=tdA+RanhlYc1Yzx3TK/PJ3PZV8qD9pzS60GTK2Epn1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gvqmj2t7LpR1H1reJFBzrDhrR1flerLzhqofwwr7n3aXr/L9xzNUs7cr0t5qiYNnw
	 4wRpVmkFyhRVZl+WjAjFbM7BNqYdU43QNpENMc6vgrNZ8GB8rU1LwYZIRyVv8Zt2Qw
	 +UvmCzQwN878T17Sv5m8l9RbJVZ8z3ETlL0jTamX2R2ZBG1deXN255h6ydfWpv3G/Z
	 5nQ8HFhPYGnFXsThTGBbv/q+vC4vYTmS5ijNJNPjtJorrWnaqCKkqhh1R6CeGzpAn5
	 wC9cv53Esre/UiYoIGb0KNoZHLtPR7ACqkX+dN9onxX7JhL0O2kBLP0DMt9Qw2fFcz
	 wuWTSD2hCemRw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rWwJO-000Nc3-A8;
	Mon, 05 Feb 2024 10:34:50 +0000
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
Subject: [PATCH v3 26/26] KVM: arm64: Add debugfs file for guest's ID registers
Date: Mon,  5 Feb 2024 10:34:31 +0000
Message-Id: <20240205103431.1104133-27-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240205103431.1104133-1-maz@kernel.org>
References: <20240205103431.1104133-1-maz@kernel.org>
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
index 3feabde9c926..181fef12e8e8 100644
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
index b5335e5a6e6e..e3faedc8b7a3 100644
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
@@ -3422,6 +3423,81 @@ static bool emulate_sys_reg(struct kvm_vcpu *vcpu,
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
@@ -3441,6 +3517,11 @@ static void kvm_reset_id_regs(struct kvm_vcpu *vcpu)
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

