Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40284358D0E
	for <kvmarm@lists.linux.dev>; Fri, 27 Feb 2026 16:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772211593; cv=none; b=r2h/UxUUCBsy4rgFAhd8VwB5/CslYNKlvk8wZ5JDLTwe/sw+tcENyw9P6PcKhACmoZXmgPDEHPYN5MGczv7C/KUGyztFvvHFYqTfrUfc0+0Vid5QiNEJUZ2ExkepXh1z8TcWnWGo265y1t4cB4BHuBluwQbnAJZ8DhfXfkWjiPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772211593; c=relaxed/simple;
	bh=qGLvB00ZHRhBLyIPTlP+4u3c9g38wfqMl89bfux33vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lps0Q81Y4FzhxZ9B1erMBa5AysCoqY/Gsn46ZnkDyZwKcupcJyy8FEioJXBL26jjXa93mALeUkxNJ4ITMDyPurt9FNT5e56fYmnxGBWImEafgaKqitioB1TqDWqkdlqp9ToUWsoyWK6zunx/xHwuXGx7Pe4A1aFvlkjs5PDWdZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39F87176B;
	Fri, 27 Feb 2026 08:59:44 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 312583F73B;
	Fri, 27 Feb 2026 08:59:49 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	will@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH v6 08/17] arm64: Use KVM_SET_MP_STATE ioctl to power off non-boot vCPUs
Date: Fri, 27 Feb 2026 16:56:15 +0000
Message-ID: <20260227165624.1519865-9-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227165624.1519865-1-suzuki.poulose@arm.com>
References: <20260227165624.1519865-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

Using the POWER_OFF flag in kvm_vcpu_init gets in the way of resetting a
vCPU in response to a PSCI CPU_ON call, for obvious reasons. Drop the
flag in favor of using the KVM_SET_MP_STATE call for non-boot vCPUs.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm64/kvm-cpu.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
index 3d914112..c7286484 100644
--- a/arm64/kvm-cpu.c
+++ b/arm64/kvm-cpu.c
@@ -143,10 +143,6 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	if (vcpu->kvm_run == MAP_FAILED)
 		die("unable to mmap vcpu fd");
 
-	/* VCPU 0 is the boot CPU, the others start in a poweroff state. */
-	if (cpu_id > 0)
-		vcpu_init.features[0] |= (1UL << KVM_ARM_VCPU_POWER_OFF);
-
 	/* Set KVM_ARM_VCPU_PSCI_0_2 if available */
 	if (kvm__supports_extension(kvm, KVM_CAP_ARM_PSCI_0_2)) {
 		vcpu_init.features[0] |= (1UL << KVM_ARM_VCPU_PSCI_0_2);
@@ -201,6 +197,16 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	if (err || target->init(vcpu))
 		die("Unable to initialise vcpu");
 
+	/* VCPU 0 is the boot CPU, the others start in a poweroff state. */
+	if (cpu_id > 0) {
+		struct kvm_mp_state mp_state = {
+			.mp_state	= KVM_MP_STATE_STOPPED,
+		};
+
+		if (ioctl(vcpu->vcpu_fd, KVM_SET_MP_STATE, &mp_state))
+			die_perror("KVM_SET_MP_STATE failed");
+	}
+
 	coalesced_offset = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION,
 				 KVM_CAP_COALESCED_MMIO);
 	if (coalesced_offset)
-- 
2.43.0

