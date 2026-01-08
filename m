Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 954FA2EB856
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 17:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767895166; cv=none; b=N4qf9Q9oGgK5NvDvquz8Gi125wLr0K99DCUfAlhkLSU3FLRtslEnWk8QW5E6AC2TUIjzUvXHAF8RYOGkFByJvWD8/yrPRazHwwP3SOVa1r9vmx4ibpAVsRUdmN/Gq5cgYTCtNX9oqGznhKo+rQuLgjit1stUxR9/qUE79tzXqNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767895166; c=relaxed/simple;
	bh=nM7LKJkevkOMctRsGY6BgPVCW4ki3JK1AoyQ7rAkiQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCMKYJoNFPyJtBuD0mrJ62LCyyoa/xe5RmY5Ui3Naw0yYdSHgXn/7VMQqINFfmB8YhzcKW/An0BdhGEyehbIJwEGhTb99dUPAuCwcGgu3j6unDEZ7SicfwKpZWFb9ZF4xa+TWVbOiUOatvo26+1MerU4oPwzXe4f69LXKPInFCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5843D1688;
	Thu,  8 Jan 2026 09:59:11 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 482C23F5A1;
	Thu,  8 Jan 2026 09:59:15 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	maz@kernel.org,
	will@kernel.org,
	oupton@kernel.org,
	aneesh.kumar@kernel.org,
	steven.price@arm.com,
	linux-kernel@vger.kernel.org,
	alexandru.elisei@arm.com,
	tabba@google.com,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH v5 10/15] arm64: psci: Implement CPU_SUSPEND
Date: Thu,  8 Jan 2026 17:57:48 +0000
Message-ID: <20260108175753.1292097-11-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260108175753.1292097-1-suzuki.poulose@arm.com>
References: <20260108175753.1292097-1-suzuki.poulose@arm.com>
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

