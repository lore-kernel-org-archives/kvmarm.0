Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A33CE3DFC7A
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774880677; cv=none; b=IkIyUv5g1bhuQWHsGmrtxaBpMUH3ZfsFL1wuW+2UaG9QLlnOK3ofT5W+a6y+LSQHlgSr9VoALPNAmdnykmPdVnWJBJnLTIQHO8ggXDfVJI2eiIduvPbHl9c+DsIXeXVWb/qao5PTnGkoWhv5YqPB4S98kLkGoTXnmYSDLdoixXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774880677; c=relaxed/simple;
	bh=nM7LKJkevkOMctRsGY6BgPVCW4ki3JK1AoyQ7rAkiQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhAbVLI8YJoyPCQ6NSO+HP0tB6mfkBpmhhLCSqBq5fY2aN6sWawYTza+zI374IUoURh2vTz660e6vK5dB4unCTCLmQk68JgG7KiuAjlrrtA7ZZRF5yRju7Bc1Pa8Y7H+khbkmEVO2J89JCZbbPSRrwQDfgfxZ4T7f+tT4PObOQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ssqi/RZT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ssqi/RZT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 59B3A451B;
	Mon, 30 Mar 2026 07:24:28 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8C90C3F915;
	Mon, 30 Mar 2026 07:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774880674; bh=nM7LKJkevkOMctRsGY6BgPVCW4ki3JK1AoyQ7rAkiQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ssqi/RZT5qzBhnQW2m1UhNFLk4Btv3Ezi9/3LlIiqIt7myD+H6fHFlMWf+u9m+Eg0
	 wOa0W3S79Z1HPWw241rJhWLVk8PzWOCRvsCVEjy7NdEsSkaeP1VkrWGqdF4ducxo9v
	 gAjuB8xndVjRuyjZ80sbl7tVaJSqs5MAgsdwqKsQ=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev,
	will@kernel.org
Cc: kvm@vger.kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	aneesh.kumar@kernel.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v7 12/17] arm64: psci: Implement CPU_SUSPEND
Date: Mon, 30 Mar 2026 15:23:29 +0100
Message-ID: <20260330142334.3309961-13-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260330142334.3309961-1-suzuki.poulose@arm.com>
References: <20260330142334.3309961-1-suzuki.poulose@arm.com>
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

