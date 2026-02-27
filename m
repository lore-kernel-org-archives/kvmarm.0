Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33AC9356A2B
	for <kvmarm@lists.linux.dev>; Fri, 27 Feb 2026 16:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772211598; cv=none; b=EOaGz2GDtxkO8RkJBzesxNH8n8KNNBE/udCHouv5iZuSwIapb4RZkL4rgDw6z8+YC9uijxHCXYfhMC0yiVG249imRZqPgOyUirpu31Q8sUSK+RMj8z5J8teySBGz2EKecdZtxXINgBzrTNqOMFazsncnHCDMquX7jXYSUPtUSsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772211598; c=relaxed/simple;
	bh=nM7LKJkevkOMctRsGY6BgPVCW4ki3JK1AoyQ7rAkiQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KO7bJv2oIVLajrj5qhL6tvtikqf/9DnQ52b/l/Oyg5iMWDcVJdsbH2zrth+O2knyArZ6vucb4/uL9qEfYA8cnP1pVNp/Ln1ZW0J1ELM4753qERj+CFxBqnNCjhEIatQmT76n7m7/3lHlOk1GKJ1oU1vIsCn4zxsY+I9ro61IFGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E3AB14BF;
	Fri, 27 Feb 2026 08:59:50 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8B28F3F73B;
	Fri, 27 Feb 2026 08:59:55 -0800 (PST)
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
Subject: [kvmtool PATCH v6 12/17] arm64: psci: Implement CPU_SUSPEND
Date: Fri, 27 Feb 2026 16:56:19 +0000
Message-ID: <20260227165624.1519865-13-suzuki.poulose@arm.com>
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

Implement support for PSCI CPU_SUSPEND, leveraging in-kernel suspend
emulation (i.e. a WFI state). Eagerly resume the vCPU for any wakeup
event.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 kvm-cpu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kvm-cpu.c b/kvm-cpu.c
index 7362f2e9..d718ef60 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -143,6 +143,16 @@ void kvm_cpu__run_on_all_cpus(struct kvm *kvm, struct kvm_cpu_task *task)
 	mutex_unlock(&task_lock);
 }
 
+static void handle_wakeup(struct kvm_cpu *vcpu)
+{
+	struct kvm_mp_state mp_state = {
+		.mp_state = KVM_MP_STATE_RUNNABLE,
+	};
+
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_MP_STATE, &mp_state))
+		die_perror("KVM_SET_MP_STATE failed");
+}
+
 int kvm_cpu__start(struct kvm_cpu *cpu)
 {
 	sigset_t sigset;
@@ -236,6 +246,9 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
 				 */
 				kvm__reboot(cpu->kvm);
 				goto exit_kvm;
+			case KVM_SYSTEM_EVENT_WAKEUP:
+				handle_wakeup(cpu);
+				break;
 			};
 			break;
 		default: {
-- 
2.43.0

