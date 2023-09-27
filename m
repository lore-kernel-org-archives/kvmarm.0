Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318E9208C3
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 09:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F338EC433CD;
	Wed, 27 Sep 2023 09:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695805760;
	bh=Q6YmAgCzAkuN6dZZT3kGjYw87vpIbmyT14KHiiho/d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbNbaSmloROzzFU5zeIiMxUOy4P5qCy0oApnA4+BkZcOA9YoCvzX2p36XP4fWn9UA
	 bveAlMT5A0tyc8vEb2mAK4/GjPCtRJrcXarvQrguexGB409Me7qG2stqrjk34s8Lnr
	 FldtCIMeRuiytbUbyK+AiYC7IW15HuYY748CR+yAgmhXCZ72UnurptiwvdnWXNm0w3
	 dQIC2fUz3vj8sdJmFMrlnK6xsLT8Vrn1F4iR5S3B8dgZVSyw2Axev5YIMVcPJwCT5L
	 rQuLZP19KuIsJScM5ghCcaIwLGiLOrkwwTojaaUQCC6bxyq2rRUF5z19fqRnXUCvFJ
	 UaMJVBICCxeBw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qlQXm-00GaLb-3X;
	Wed, 27 Sep 2023 10:09:18 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Xu Zhao <zhaoxu.35@bytedance.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 08/11] KVM: arm64: Build MPIDR to vcpu index cache at runtime
Date: Wed, 27 Sep 2023 10:09:08 +0100
Message-Id: <20230927090911.3355209-9-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230927090911.3355209-1-maz@kernel.org>
References: <20230927090911.3355209-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, shameerali.kolothum.thodi@huawei.com, zhaoxu.35@bytedance.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The MPIDR_EL1 register contains a unique value that identifies
the CPU. The only problem with it is that it is stupidly large
(32 bits, once the useless stuff is removed).

Trying to obtain a vcpu from an MPIDR value is a fairly common,
yet costly operation: we iterate over all the vcpus until we
find the correct one. While this is cheap for small VMs, it is
pretty expensive on large ones, specially if you are trying to
get to the one that's at the end of the list...

In order to help with this, it is important to realise that
the MPIDR values are actually structured, and that implementations
tend to use a small number of significant bits in the 32bit space.

We can use this fact to our advantage by computing a small hash
table that uses the "compression" of the significant MPIDR bits
as an index, giving us the vcpu index as a result.

Given that the MPIDR values can be supplied by userspace, and
that an evil VMM could decide to make *all* bits significant,
resulting in a 4G-entry table, we only use this method if the
resulting table fits in a single page. Otherwise, we fallback
to the good old iterative method.

Nothing uses that table just yet, but keep your eyes peeled.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Tested-by: Joey Gouly <joey.gouly@arm.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 28 ++++++++++++++++
 arch/arm64/kvm/arm.c              | 54 +++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index af06ccb7ee34..4b5a57a60b6a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -202,6 +202,31 @@ struct kvm_protected_vm {
 	struct kvm_hyp_memcache teardown_mc;
 };
 
+struct kvm_mpidr_data {
+	u64			mpidr_mask;
+	DECLARE_FLEX_ARRAY(u16, cmpidr_to_idx);
+};
+
+static inline u16 kvm_mpidr_index(struct kvm_mpidr_data *data, u64 mpidr)
+{
+	unsigned long mask = data->mpidr_mask;
+	u64 aff = mpidr & MPIDR_HWID_BITMASK;
+	int nbits, bit, bit_idx = 0;
+	u16 index = 0;
+
+	/*
+	 * If this looks like RISC-V's BEXT or x86's PEXT
+	 * instructions, it isn't by accident.
+	 */
+	nbits = fls(mask);
+	for_each_set_bit(bit, &mask, nbits) {
+		index |= (aff & BIT(bit)) >> (bit - bit_idx);
+		bit_idx++;
+	}
+
+	return index;
+}
+
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
@@ -248,6 +273,9 @@ struct kvm_arch {
 	/* VM-wide vCPU feature set */
 	DECLARE_BITMAP(vcpu_features, KVM_VCPU_MAX_FEATURES);
 
+	/* MPIDR to vcpu index mapping, optional */
+	struct kvm_mpidr_data *mpidr_data;
+
 	/*
 	 * VM-wide PMU filter, implemented as a bitmap and big enough for
 	 * up to 2^10 events (ARMv8.0) or 2^16 events (ARMv8.1+).
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9379a1227501..b02e28f76083 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -205,6 +205,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	if (is_protected_kvm_enabled())
 		pkvm_destroy_hyp_vm(kvm);
 
+	kfree(kvm->arch.mpidr_data);
 	kvm_destroy_vcpus(kvm);
 
 	kvm_unshare_hyp(kvm, kvm + 1);
@@ -578,6 +579,57 @@ static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
 	return vcpu_get_flag(vcpu, VCPU_INITIALIZED);
 }
 
+static void kvm_init_mpidr_data(struct kvm *kvm)
+{
+	struct kvm_mpidr_data *data = NULL;
+	unsigned long c, mask, nr_entries;
+	u64 aff_set = 0, aff_clr = ~0UL;
+	struct kvm_vcpu *vcpu;
+
+	mutex_lock(&kvm->arch.config_lock);
+
+	if (kvm->arch.mpidr_data || atomic_read(&kvm->online_vcpus) == 1)
+		goto out;
+
+	kvm_for_each_vcpu(c, vcpu, kvm) {
+		u64 aff = kvm_vcpu_get_mpidr_aff(vcpu);
+		aff_set |= aff;
+		aff_clr &= aff;
+	}
+
+	/*
+	 * A significant bit can be either 0 or 1, and will only appear in
+	 * aff_set. Use aff_clr to weed out the useless stuff.
+	 */
+	mask = aff_set ^ aff_clr;
+	nr_entries = BIT_ULL(hweight_long(mask));
+
+	/*
+	 * Don't let userspace fool us. If we need more than a single page
+	 * to describe the compressed MPIDR array, just fall back to the
+	 * iterative method. Single vcpu VMs do not need this either.
+	 */
+	if (struct_size(data, cmpidr_to_idx, nr_entries) <= PAGE_SIZE)
+		data = kzalloc(struct_size(data, cmpidr_to_idx, nr_entries),
+			       GFP_KERNEL_ACCOUNT);
+
+	if (!data)
+		goto out;
+
+	data->mpidr_mask = mask;
+
+	kvm_for_each_vcpu(c, vcpu, kvm) {
+		u64 aff = kvm_vcpu_get_mpidr_aff(vcpu);
+		u16 index = kvm_mpidr_index(data, aff);
+
+		data->cmpidr_to_idx[index] = c;
+	}
+
+	kvm->arch.mpidr_data = data;
+out:
+	mutex_unlock(&kvm->arch.config_lock);
+}
+
 /*
  * Handle both the initialisation that is being done when the vcpu is
  * run for the first time, as well as the updates that must be
@@ -601,6 +653,8 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (likely(vcpu_has_run_once(vcpu)))
 		return 0;
 
+	kvm_init_mpidr_data(kvm);
+
 	kvm_arm_vcpu_init_debug(vcpu);
 
 	if (likely(irqchip_in_kernel(kvm))) {
-- 
2.34.1

