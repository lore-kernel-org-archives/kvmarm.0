Received: from out-225.mta1.migadu.com (out-225.mta1.migadu.com [95.215.58.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF3323D0
	for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 18:33:38 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695234816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=urpT7DYpWddYyOHkqJREBoJa3eM7v1IrFVmDElQJ+38=;
	b=V7L6oEiCgCORxt6iI7stNxS+OSFysXI7vYfE4hQ2s+WpFJZcfwBrYbWD9w7cPDu6gjuvsy
	YuMpDro2OWf28aoWTWVz3RVpjt3MY2izniGqXQ6VXb8JiTXb+bHlAMjIL7Y83WUvE0p6Ox
	z0Zdg1OA+lODgyNdMEWSvs6Mv0gvM00=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Cornelia Huck <cohuck@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Jing Zhang <jingzhangos@google.com>
Subject: [PATCH v10 06/12] KVM: arm64: Allow userspace to change ID_AA64ISAR{0-2}_EL1
Date: Wed, 20 Sep 2023 18:33:03 +0000
Message-ID: <20230920183310.1163034-7-oliver.upton@linux.dev>
In-Reply-To: <20230920183310.1163034-1-oliver.upton@linux.dev>
References: <20230920183310.1163034-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Almost all of the features described by the ISA registers have no KVM
involvement. Allow userspace to change the value of these registers with
a couple exceptions:

 - MOPS is not writable as KVM does not currently virtualize FEAT_MOPS.

 - The PAuth fields are not writable as KVM requires both address and
   generic authentication be enabled.

 - Override the kernel's handling of BC to LOWER_SAFE.

Co-developed-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 42 ++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 10e3e6a736dc..71664bec2808 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1225,6 +1225,10 @@ static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits *ftrp,
 			break;
 		}
 		break;
+	case SYS_ID_AA64ISAR2_EL1:
+		if (kvm_ftr.shift == ID_AA64ISAR2_EL1_BC_SHIFT)
+			kvm_ftr.type = FTR_LOWER_SAFE;
+		break;
 	case SYS_ID_DFR0_EL1:
 		if (kvm_ftr.shift == ID_DFR0_EL1_PerfMon_SHIFT)
 			kvm_ftr.type = FTR_LOWER_SAFE;
@@ -1851,11 +1855,14 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
  * from userspace.
  */
 
-/* sys_reg_desc initialiser for known cpufeature ID registers */
-#define ID_SANITISED(name) {			\
+#define ID_DESC(name)				\
 	SYS_DESC(SYS_##name),			\
 	.access	= access_id_reg,		\
-	.get_user = get_id_reg,			\
+	.get_user = get_id_reg			\
+
+/* sys_reg_desc initialiser for known cpufeature ID registers */
+#define ID_SANITISED(name) {			\
+	ID_DESC(name),				\
 	.set_user = set_id_reg,			\
 	.visibility = id_visibility,		\
 	.reset = kvm_read_sanitised_id_reg,	\
@@ -1864,15 +1871,22 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
 #define AA32_ID_SANITISED(name) {		\
-	SYS_DESC(SYS_##name),			\
-	.access	= access_id_reg,		\
-	.get_user = get_id_reg,			\
+	ID_DESC(name),				\
 	.set_user = set_id_reg,			\
 	.visibility = aa32_id_visibility,	\
 	.reset = kvm_read_sanitised_id_reg,	\
 	.val = 0,				\
 }
 
+/* sys_reg_desc initialiser for writable ID registers */
+#define ID_WRITABLE(name, mask) {		\
+	ID_DESC(name),				\
+	.set_user = set_id_reg,			\
+	.visibility = id_visibility,		\
+	.reset = kvm_read_sanitised_id_reg,	\
+	.val = mask,				\
+}
+
 /*
  * sys_reg_desc initialiser for architecturally unallocated cpufeature ID
  * register with encoding Op0=3, Op1=0, CRn=0, CRm=crm, Op2=op2
@@ -1894,9 +1908,7 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
  * RAZ for the guest.
  */
 #define ID_HIDDEN(name) {			\
-	SYS_DESC(SYS_##name),			\
-	.access = access_id_reg,		\
-	.get_user = get_id_reg,			\
+	ID_DESC(name),				\
 	.set_user = set_id_reg,			\
 	.visibility = raz_visibility,		\
 	.reset = kvm_read_sanitised_id_reg,	\
@@ -2075,9 +2087,15 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(5,7),
 
 	/* CRm=6 */
-	ID_SANITISED(ID_AA64ISAR0_EL1),
-	ID_SANITISED(ID_AA64ISAR1_EL1),
-	ID_SANITISED(ID_AA64ISAR2_EL1),
+	ID_WRITABLE(ID_AA64ISAR0_EL1, ~ID_AA64ISAR0_EL1_RES0),
+	ID_WRITABLE(ID_AA64ISAR1_EL1, ~(ID_AA64ISAR1_EL1_GPI |
+					ID_AA64ISAR1_EL1_GPA |
+					ID_AA64ISAR1_EL1_API |
+					ID_AA64ISAR1_EL1_APA)),
+	ID_WRITABLE(ID_AA64ISAR2_EL1, ~(ID_AA64ISAR2_EL1_RES0 |
+					ID_AA64ISAR2_EL1_MOPS |
+					ID_AA64ISAR2_EL1_APA3 |
+					ID_AA64ISAR2_EL1_GPA3)),
 	ID_UNALLOCATED(6,3),
 	ID_UNALLOCATED(6,4),
 	ID_UNALLOCATED(6,5),
-- 
2.42.0.515.g380fc7ccd1-goog

