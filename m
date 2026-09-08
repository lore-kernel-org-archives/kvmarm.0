Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E83F572660;
	Tue,  8 Sep 2026 16:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788884629; cv=none; b=Az0JmT4sktcpVoNjVmNNjQnj/TVQzIx7I1aNUY6oPgtkFmiFvYucT3roFExArQ3bsDJw3qW42aE5b8Zg91ZJVe/n/SL//cCLqt4NR25W+gCaArJ7jlHGc2gtCh2krS3Z7ey3T/XqpACJlR6gTIXjFzywm2HRkYFhVcVUqMNFiPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788884629; c=relaxed/simple;
	bh=S77v1BDbvfQaK2gnhv9ZUvhfNvS6strceig1vPocSBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8pkx5vYcWHceQ01Res59sJR7A65bGZNubZgwKTeeudeioQtWo7Uac11n9SJNqpZThJv8dcu6i7+y6Mh6Gur/kYasGDXUOLRE+UXEUA4vXAghBbymyaM1/IkMbwcgLyEC793j9SxMMrOg1lB9TLWNWuOmY4cYx3zfQGNf2ZW/HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZrgX2Fl8; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZrgX2Fl8"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0828E1C01;
	Tue,  8 Sep 2026 09:23:43 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 491C43F7B4;
	Tue,  8 Sep 2026 09:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788884626; bh=S77v1BDbvfQaK2gnhv9ZUvhfNvS6strceig1vPocSBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZrgX2Fl8MhqU/CcGK6RgBT06B4x2UojJLSg1+Vkgu/tAthB79yuNwIXm1/DqfWxH5
	 fhKk9UEMmYwCf567408u6vmM4aLe2J/mJudjrcgCqqcvPRVnf4CWLNOP4PyTZV6Gyb
	 1hw/OQ9/PF09AoSuwAK8nzqxCa1lG7Dij9B6I+UA=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v17 16/20] KVM: arm64: CCA: Provide register list for unfinalized RECs
Date: Tue,  8 Sep 2026 17:22:19 +0100
Message-ID: <20260908162223.1683432-17-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260908162223.1683432-1-suzuki.poulose@arm.com>
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

KVM_GET_REG_LIST should not be called before SVE is finalized. The ioctl
handler currently returns -EPERM in this case. But because it uses
kvm_arm_vcpu_is_finalized(), it now also rejects the call for
unfinalized REC even though finalizing the REC can only be done late,
after Realm descriptor creation.

Move the check to copy_sve_reg_indices(). One adverse side effect of
this change is that a KVM_GET_REG_LIST call that only probes for the
array size will now succeed even if SVE is not finalized, but that seems
harmless since the following KVM_GET_REG_LIST with the full array will
fail.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kvm/arm.c   | 14 +++++++++++++-
 arch/arm64/kvm/guest.c | 10 +++++-----
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fbb4d6651ab51..3fe5a4f77738e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1980,6 +1980,18 @@ static int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 	return __kvm_arm_vcpu_set_events(vcpu, events);
 }
 
+/*
+ * Realm VCPUs can be finalized after the Realm descriptor is created.
+ * Allow the register list for RECs before the VCPUs are finalized, but
+ * after the SVE is finalized.
+ */
+static bool kvm_arm_vcpu_reg_list_allowed(struct kvm_vcpu *vcpu)
+{
+	if (kvm_arm_vcpu_is_finalized(vcpu))
+		return true;
+	return vcpu_is_rec(vcpu);
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -2035,7 +2047,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 			break;
 
 		r = -EPERM;
-		if (!kvm_arm_vcpu_is_finalized(vcpu))
+		if (!kvm_arm_vcpu_reg_list_allowed(vcpu))
 			break;
 
 		r = -EFAULT;
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index b01d6622b8720..c3ca369882273 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -598,8 +598,8 @@ static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
 	if (!vcpu_has_sve(vcpu))
 		return 0;
 
-	/* Policed by KVM_GET_REG_LIST: */
-	WARN_ON(!kvm_arm_vcpu_sve_finalized(vcpu));
+	if (!kvm_arm_vcpu_sve_finalized(vcpu))
+		return 1; /* KVM_REG_ARM64_SVE_VLS */
 
 	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */)
 		+ 1; /* KVM_REG_ARM64_SVE_VLS */
@@ -616,9 +616,6 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 	if (!vcpu_has_sve(vcpu))
 		return 0;
 
-	/* Policed by KVM_GET_REG_LIST: */
-	WARN_ON(!kvm_arm_vcpu_sve_finalized(vcpu));
-
 	/*
 	 * Enumerate this first, so that userspace can save/restore in
 	 * the order reported by KVM_GET_REG_LIST:
@@ -628,6 +625,9 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 		return -EFAULT;
 	++num_regs;
 
+	if (!kvm_arm_vcpu_sve_finalized(vcpu))
+		return num_regs;
+
 	for (i = 0; i < slices; i++) {
 		for (n = 0; n < SVE_NUM_ZREGS; n++) {
 			reg = KVM_REG_ARM64_SVE_ZREG(n, i);
-- 
2.43.0

