Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CB861350E3
	for <kvmarm@lists.linux.dev>; Thu, 21 Mar 2024 16:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711040271; cv=none; b=UuLVNhk6Z64enW8GbdcojW297DHudC0REALyaW9zGIP+rIzPT3nUGnavWUH7s10BJH/Gq7VOXPP4HauBCCey+FyUi3nQN0ZIXCuvnhhRRG8Bth0Esrr/7dUbj5LABKMack5QGK3+5iu1SMw0QUlbGoUfdKBdvDyET4RcFfZJpfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711040271; c=relaxed/simple;
	bh=h2KkuNiGokWzYHQwRX5D7mazAYct7VTLqgn8S8tV2Bk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UyF4U3rj2DaD2Eg1pYqApn8SdfCzfSPclaoT5sGCtby0As2qZ14TyDj1HRELI6WMGxm4Rch0e872+OmGvb23+tL9HDhw0RERR+JSCO08vFrImIV4W0w8cQVQrVtDVWsGfU0xl0A+7BxcxbRB9UxnfhoAjv1FanjXzfkjxAGaE8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D10941691;
	Thu, 21 Mar 2024 09:58:23 -0700 (PDT)
Received: from merodach.members.linode.com (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 406E83F67D;
	Thu, 21 Mar 2024 09:57:48 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jing Zhang <jingzhangos@google.com>,
	James Morse <james.morse@arm.com>
Subject: [PATCH v3 4/6] KVM: arm64: Disable MPAM visibility by default and ignore VMM writes
Date: Thu, 21 Mar 2024 16:57:26 +0000
Message-Id: <20240321165728.31907-5-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240321165728.31907-1-james.morse@arm.com>
References: <20240321165728.31907-1-james.morse@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 011e5f5bf529f ("arm64/cpufeature: Add remaining feature bits in
ID_AA64PFR0 register") exposed the MPAM field of AA64PFR0_EL1 to guests,
but didn't add trap handling. A previous patch supplied the missing trap
handling.

Existing VMs that have the MPAM field of ID_AA64PFR0_EL1 set need to
be migratable, but there is little point enabling the MPAM CPU
interface on new VMs until there is something a guest can do with it.

Clear the MPAM field from the guest's ID_AA64PFR0_EL1 and on hardware
that supports MPAM, politely ignore the VMMs attempts to set this bit.

Guests expossed to this bug have the sanitised value of the MPAM field,
so only the correct value needs to be ignored. This means the field
can continue to be used to block migration to incompatible hardware
(between MPAM=1 and MPAM=5), and the VMM can't rely on the field
being ignored.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d6afb21849de..56d70a90c965 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1685,6 +1685,13 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 
 	val &= ~ID_AA64PFR0_EL1_AMU_MASK;
 
+	/*
+	 * MPAM is disabled by default as KVM also needs a set of PARTID to
+	 * program the MPAMVPMx_EL2 PARTID remapping registers with. But some
+	 * older kernels let the guest see the ID bit.
+	 */
+	val &= ~ID_AA64PFR0_EL1_MPAM_MASK;
+
 	return val;
 }
 
@@ -1795,6 +1802,29 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	return set_id_reg(vcpu, rd, val);
 }
 
+static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *rd, u64 user_val)
+{
+	u64 hw_val = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+	u64 mpam_mask = ID_AA64PFR0_EL1_MPAM_MASK;
+
+	/*
+	 * Commit 011e5f5bf529f ("arm64/cpufeature: Add remaining feature bits
+	 * in ID_AA64PFR0 register") exposed the MPAM field of AA64PFR0_EL1 to
+	 * guests, but didn't add trap handling. KVM doesn't support MPAM and
+	 * always returns an UNDEF for these registers. The guest must see 0
+	 * for this field.
+	 *
+	 * But KVM must also accept values from user-space that were provided
+	 * by KVM. On CPUs that support MPAM, permit user-space to write
+	 * the santisied value to ID_AA64PFR0_EL1.MPAM, but ignore this field.
+	 */
+	if ((hw_val & mpam_mask) == (user_val & mpam_mask))
+		user_val &= ~ID_AA64PFR0_EL1_MPAM_MASK;
+
+	return set_id_reg(vcpu, rd, user_val);
+}
+
 /*
  * cpufeature ID register user accessors
  *
@@ -2291,7 +2321,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_ID_AA64PFR0_EL1),
 	  .access = access_id_reg,
 	  .get_user = get_id_reg,
-	  .set_user = set_id_reg,
+	  .set_user = set_id_aa64pfr0_el1,
 	  .reset = read_sanitised_id_aa64pfr0_el1,
 	  .val = ~(ID_AA64PFR0_EL1_AMU |
 		   ID_AA64PFR0_EL1_MPAM |
-- 
2.39.2

