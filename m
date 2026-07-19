Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C69381B15;
	Sun, 19 Jul 2026 23:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784502703; cv=none; b=Im01xFwJwt56c+4p3hTTZz5UWv/dAbP3Bj0UE14K1nBn2brZw/i9iy4zvRDv+2dFG2MYGqexdkqEb6s3ALRyBjnXijbVouZyJ5eymuJ2KeNRcvdaHvn3KACsH6FoPmgIz/+If7JeI5FEObbLaFEmcVdE0CPHToe2VrS7WnB0meI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784502703; c=relaxed/simple;
	bh=OWLQ+fStXa0u76ZwF0nDRlLR1/mZJ3iEmSPjs0EDopk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Lij5N9da+pFjOpG2uG4yoF3O22AHqoTH2Fl3QOd0FAwvFaY7QLkpMMxGhguGIpdaYmHRA6nExBmefnELqpqNVDFA7V0INNVOLh90OURlHXHytI7z/Hrz3ZeRKfGKx6V2HXAxU9X7P5rCSGoZgF6vdL9Fc5P/RAX+chzHT6ckypA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OGKZQoaU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OGKZQoaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5D11F00A3A;
	Sun, 19 Jul 2026 23:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784502701;
	bh=cQTVOv3doodlzyRyF79rD7oVUshuooj7eTaIdQCTKvI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OGKZQoaUep5d5TFU6XJxsr1haz5wvHczP9UeXDlM+vSfVWIiTQUmoi6+oj2KHTByn
	 cJRljvUSxNQg2/US09cLUSIi6jz5dZJOpcdGmTWytRsn4vZuG/zva6VZL2lZnUm7Q0
	 J+9wGpnpPpEj0IyN5eCX0JIlSxbfIINYVSaWTieiQ13rZPkSLnvsDXH8pqLpJwEsDd
	 gzgHyO4/xm2qLqKtVqV0LsOjgNJB9MRmXil9tIMaqplOchIYMm4gPJKnOTvm3Ubynx
	 HBGowHclKwDEONT6zZ2BExOkc0hc/2Ojx1ndZEk0/boREE5ffPIM1SAvYkTh++ZL2p
	 RD4KbLA88TkzQ==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 20 Jul 2026 00:07:51 +0100
Subject: [PATCH v13 24/32] KVM: arm64: Expose SME specific state to
 userspace
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kvm-arm64-sme-v13-24-d9abd3ffa245@kernel.org>
References: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
In-Reply-To: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Jean-Philippe Brucker <jpb@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=9460; i=broonie@kernel.org;
 h=from:subject:message-id; bh=OWLQ+fStXa0u76ZwF0nDRlLR1/mZJ3iEmSPjs0EDopk=;
 b=owGbwMvMwMWocq27KDak/QLjabUkhqzYSKuKX4mN7Hp3J/55oHO4bJFJzMq+IOe5k+bY90/8y
 mbGtEask9GYhYGRi0FWTJFl7bOMVenhElvnP5r/CmYQKxPIFAYuTgGYiKAY+185b1cJy6bYpUeX
 3zx5iW3GA+WFUeI771q/3Fk/70PXFXZu94kO3Ep62uU6Kz+eTHU+evGNgFSLifgp496kX1ed5iV
 WV8u9XM8foP3l6kPBB2cM/yqo2ylH8nwJMNvGu0GOj+s364Nd8bF+ocmJUdPevHzEGMP6j+U1yz
 qGg37m56OuGu5h233HuTGi70FKgHq+gmHsirdvLZqfr3iakiotGlHe3Xbzu2TTBwHrRev/V7B5M
 c56pKH2deN81t6Dna6/qha6PmayfaXKr5p1RuCmpPlnQ6vMR0d1TfiSuXJYoh97dKjcK7zHm1R0
 7IN8ss5Zy2//m+UtHfgbm8w86uPFg/uMIj1VdCeF5bwEAA==
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

SME introduces two new registers, the ZA matrix register and the ZT0 LUT
register.  Both of these registers are only accessible when PSTATE.ZA is
set and ZT0 is only present if SME2 is enabled for the guest. Provide
support for configuring these from VMMs.

The ZA matrix is a single SVL*SVL register which is available when
PSTATE.ZA is set. We follow the pattern established by the architecture
itself and expose this to userspace as a series of horizontal SVE vectors
with the streaming mode vector length, using the format already established
for the SVE vectors themselves.

ZT0 is a single register with a refreshingly fixed size 512 bit register
which is like ZA accessible only when PSTATE.ZA is set. Add support for it
to the userspace API.

As is done in the architecture for both ZA and ZT0 the value will be
reset to 0 whenever PSTATE.ZA changes from 0 to 1 and the registers are
inaccessible when PSTATE.ZA is 0.

While there is currently only one ZT register the naming as ZT0 and the
instruction encoding clearly leave room for future extensions adding more
ZT registers. This encoding can readily support such an extension if one is
introduced.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/uapi/asm/kvm.h |  20 ++++
 arch/arm64/kvm/guest.c            | 186 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 204 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 15d53300914b..deccb034fce3 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -357,6 +357,26 @@ struct kvm_arm_counter_offset {
 /* SME registers */
 #define KVM_REG_ARM64_SME		(0x17 << KVM_REG_ARM_COPROC_SHIFT)
 
+#define KVM_ARM64_SME_VQ_MIN __SVE_VQ_MIN
+#define KVM_ARM64_SME_VQ_MAX 16
+
+/* ZA and ZTn occupy blocks at the following offsets within this range: */
+#define KVM_REG_ARM64_SME_ZA_BASE	0
+#define KVM_REG_ARM64_SME_ZT_BASE	0x600
+
+#define KVM_ARM64_SME_MAX_ZAHREG	(__SVE_VQ_BYTES * KVM_ARM64_SME_VQ_MAX)
+
+#define KVM_REG_ARM64_SME_ZAHREG(n, i)					\
+	(KVM_REG_ARM64 | KVM_REG_ARM64_SME | KVM_REG_ARM64_SME_ZA_BASE | \
+	 KVM_REG_SIZE_U2048 |						\
+	 (((n) & (KVM_ARM64_SME_MAX_ZAHREG - 1)) << 5) |		\
+	 ((i) & (KVM_ARM64_SVE_MAX_SLICES - 1)))
+
+#define KVM_REG_ARM64_SME_ZTREG_SIZE	(512 / 8)
+#define KVM_REG_ARM64_SME_ZTREG(n) \
+	(KVM_REG_ARM64 | KVM_REG_ARM64_SME | KVM_REG_ARM64_SME_ZT_BASE | \
+	 KVM_REG_SIZE_U512 | (n))
+
 /* Vector lengths pseudo-register: */
 #define KVM_REG_ARM64_SME_VLS		(KVM_REG_ARM64 | KVM_REG_ARM64_SME | \
 					 KVM_REG_SIZE_U512 | 0xfffe)
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 110cc7f7527a..1b85f0383628 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -598,22 +598,133 @@ static int set_sme_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return set_vec_vls(ARM64_VEC_SME, vcpu, reg);
 }
 
+#define ZAH_REG_SLICE_SHIFT	0
+#define ZAH_REG_SLICE_BITS	5
+#define ZAH_REG_ID_SHIFT	(ZAH_REG_SLICE_SHIFT + ZAH_REG_SLICE_BITS)
+#define ZAH_REG_ID_BITS		8
+
+#define ZAH_REG_SLICE_MASK					\
+	GENMASK(ZAH_REG_SLICE_SHIFT + ZAH_REG_SLICE_BITS - 1,	\
+		ZAH_REG_SLICE_SHIFT)
+#define ZAH_REG_ID_MASK							\
+	GENMASK(ZAH_REG_ID_SHIFT + ZAH_REG_ID_BITS - 1, ZAH_REG_ID_SHIFT)
+
+/*
+ * Validate SME register ID and get sanitised bounds for user/kernel SME
+ * register copy
+ */
+static int sme_reg_to_region(struct vec_state_reg_region *region,
+			     struct kvm_vcpu *vcpu,
+			     const struct kvm_one_reg *reg)
+{
+	/* reg ID ranges for ZA.H[n] registers */
+	unsigned int vq = vcpu_sme_max_vq(vcpu);
+	const u64 za_h_max = vq * __SVE_VQ_BYTES;
+	const u64 zah_id_min = KVM_REG_ARM64_SME_ZAHREG(0, 0);
+	const u64 zah_id_max = KVM_REG_ARM64_SME_ZAHREG(za_h_max - 1,
+							SVE_NUM_SLICES - 1);
+	unsigned int reg_num;
+
+	unsigned int reqoffset, reqlen; /* User-requested offset and length */
+	unsigned int maxlen; /* Maximum permitted length */
+
+	size_t sme_state_size;
+
+	reg_num = (reg->id & ZAH_REG_ID_MASK) >> ZAH_REG_ID_SHIFT;
+
+	if (reg->id >= zah_id_min && reg->id <= zah_id_max) {
+		if (!vcpu_has_sme(vcpu) || (reg->id & ZAH_REG_SLICE_MASK) > 0)
+			return -ENOENT;
+
+		if (!vcpu_za_enabled(vcpu))
+			return -EBUSY;
+
+		/* ZA is exposed as SVE vectors ZA.H[n] */
+		reqoffset = ZA_SIG_ZAV_OFFSET(vq, reg_num) -
+			ZA_SIG_REGS_OFFSET;
+		reqlen = KVM_SVE_ZREG_SIZE;
+		maxlen = SVE_SIG_ZREG_SIZE(vq);
+	} else if (reg->id == KVM_REG_ARM64_SME_ZTREG(0)) {
+		if (!kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, SME, SME2))
+			return -ENOENT;
+
+		if (!vcpu_za_enabled(vcpu))
+			return -EBUSY;
+
+		/* ZT0 is stored after ZA */
+		reqoffset = ZA_SIG_REGS_SIZE(vq);
+		reqlen = KVM_REG_ARM64_SME_ZTREG_SIZE;
+		maxlen = KVM_REG_ARM64_SME_ZTREG_SIZE;
+	} else {
+		return -EINVAL;
+	}
+
+	sme_state_size = vcpu_sme_state_size(vcpu);
+	if (WARN_ON(!sme_state_size))
+		return -EINVAL;
+
+	region->koffset = array_index_nospec(reqoffset, sme_state_size);
+	region->klen = min(maxlen, reqlen);
+	region->upad = reqlen - region->klen;
+
+	return 0;
+}
+
+/*
+ * ZA is exposed as an array of horizontal vectors with the same
+ * format as SVE, mirroring the architecture's LDR ZA[Wv, offs], [Xn]
+ * instruction.
+ */
+
 static int get_sme_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
+	int ret;
+	struct vec_state_reg_region region;
+	char __user *uptr = (char __user *)reg->addr;
+
 	/* Handle the KVM_REG_ARM64_SME_VLS pseudo-reg as a special case: */
 	if (reg->id == KVM_REG_ARM64_SME_VLS)
 		return get_sme_vls(vcpu, reg);
 
-	return -EINVAL;
+	/* Try to interpret reg ID as an architectural SME register... */
+	ret = sme_reg_to_region(&region, vcpu, reg);
+	if (ret)
+		return ret;
+
+	if (!kvm_arm_vcpu_vec_finalized(vcpu))
+		return -EPERM;
+
+	if (copy_to_user(uptr, (void *)vcpu->arch.sme_state + region.koffset,
+			 region.klen) ||
+	    clear_user(uptr + region.klen, region.upad))
+		return -EFAULT;
+
+	return 0;
 }
 
 static int set_sme_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
+	int ret;
+	struct vec_state_reg_region region;
+	char __user *uptr = (char __user *)reg->addr;
+
 	/* Handle the KVM_REG_ARM64_SME_VLS pseudo-reg as a special case: */
 	if (reg->id == KVM_REG_ARM64_SME_VLS)
 		return set_sme_vls(vcpu, reg);
 
-	return -EINVAL;
+	/* Try to interpret reg ID as an architectural SME register... */
+	ret = sme_reg_to_region(&region, vcpu, reg);
+	if (ret)
+		return ret;
+
+	if (!kvm_arm_vcpu_vec_finalized(vcpu))
+		return -EPERM;
+
+	if (copy_from_user((void *)vcpu->arch.sme_state + region.koffset, uptr,
+			   region.klen))
+		return -EFAULT;
+
+	return 0;
 }
 
 int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
@@ -694,6 +805,27 @@ static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static unsigned long num_sme_regs(const struct kvm_vcpu *vcpu)
+{
+	const unsigned int slices = vcpu_sve_slices(vcpu);
+	int regs;
+
+	if (!vcpu_has_sme(vcpu))
+		return 0;
+
+	/* Policed by KVM_GET_REG_LIST: */
+	WARN_ON(!kvm_arm_vcpu_vec_finalized(vcpu));
+
+	/* KVM_REG_ARM64_SME_VLS */
+	regs = 1;
+
+	/* ZA, and ZT0 if SME2 */
+	if (vcpu_za_enabled(vcpu))
+		regs += (slices * vcpu_sme_max_vl(vcpu)) + vcpu_has_sme2(vcpu);
+
+	return regs;
+}
+
 static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 				u64 __user *uindices)
 {
@@ -745,6 +877,50 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 	return num_regs;
 }
 
+static int copy_sme_reg_indices(const struct kvm_vcpu *vcpu,
+				u64 __user *uindices)
+{
+	const unsigned int slices = vcpu_sve_slices(vcpu);
+	u64 reg;
+	unsigned int i, n;
+	int num_regs = 0;
+
+	if (!vcpu_has_sme(vcpu))
+		return 0;
+
+	/* Policed by KVM_GET_REG_LIST: */
+	WARN_ON(!kvm_arm_vcpu_vec_finalized(vcpu));
+
+	/*
+	 * Enumerate this first, so that userspace can save/restore in
+	 * the order reported by KVM_GET_REG_LIST:
+	 */
+	reg = KVM_REG_ARM64_SME_VLS;
+	if (put_user(reg, uindices++))
+		return -EFAULT;
+	++num_regs;
+
+	if (vcpu_za_enabled(vcpu)) {
+		for (i = 0; i < slices; i++) {
+			for (n = 0; n < vcpu_sme_max_vl(vcpu); n++) {
+				reg = KVM_REG_ARM64_SME_ZAHREG(n, i);
+				if (put_user(reg, uindices++))
+					return -EFAULT;
+				num_regs++;
+			}
+		}
+
+		if (vcpu_has_sme2(vcpu)) {
+			reg = KVM_REG_ARM64_SME_ZTREG(0);
+			if (put_user(reg, uindices++))
+				return -EFAULT;
+			num_regs++;
+		}
+	}
+
+	return num_regs;
+}
+
 /**
  * kvm_arm_num_regs - how many registers do we present via KVM_GET_ONE_REG
  * @vcpu: the vCPU pointer
@@ -757,6 +933,7 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
 
 	res += num_core_regs(vcpu);
 	res += num_sve_regs(vcpu);
+	res += num_sme_regs(vcpu);
 	res += kvm_arm_num_sys_reg_descs(vcpu);
 	res += kvm_arm_get_fw_num_regs(vcpu);
 
@@ -784,6 +961,11 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 		return ret;
 	uindices += ret;
 
+	ret = copy_sme_reg_indices(vcpu, uindices);
+	if (ret < 0)
+		return ret;
+	uindices += ret;
+
 	ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
 	if (ret < 0)
 		return ret;

-- 
2.47.3

