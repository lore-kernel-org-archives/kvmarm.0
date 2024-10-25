Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050E2214415
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 20:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729888283; cv=none; b=jY4k5J4SsuBfs6JObWp3jbW1XXndheQiQsbYYAp4It1ZS1+p3y8Q4b6TDEAHdaHC9f2lAH9Obz6dYB77Q2ZE/M7XOeMzeiSUCnSJkkSjK9jvjj9fBCw83DEFJZqYF/n7j/XOePReDKU5asBf8wA1z9+eYW6FSwlQcScKo3iNl9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729888283; c=relaxed/simple;
	bh=Iy493F+pzQg2fpvg0RRli4wvoJ+/KT35WSxY22GlUHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtsbiW80hhUgZGFyR7sPFeM4qdeV4iT4Gpo+1HnyFhdnJxSJ2boeEfQTqKtZm/0WZsz7ueULduiEjmmMZLXKesIctTmqdc/S5hgW/01XivGmfoYi0pqHj6Kcs6oneCkkqvqDyOMDcYuXhP7uULlTsZFauxNYFwXlKY0AgxI8vLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T+XFuLta; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T+XFuLta"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729888278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZhJ9ugIPIaGFFz5qM07CREOEip6QOw5dMQo4DWCePhE=;
	b=T+XFuLtaFh7Q3CDmqR5AnYLYTyL5Dpi/CNlxln+LiSJay+HZ5b8AlQ6ITmJIheQqZobzEp
	1lWXDgiy2oSimAJoWvAgbhqqVXivL8WNvSYulL7oyW2aNBlvT6dNR2Jok819O9DbUJiGNd
	o2G6Ijrcp+lS4ASv66nRuK/4ELdZZYM=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	stable@vger.kernel.org,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH v2 1/4] KVM: arm64: Don't retire aborted MMIO instruction
Date: Fri, 25 Oct 2024 20:31:03 +0000
Message-ID: <20241025203106.3529261-2-oliver.upton@linux.dev>
In-Reply-To: <20241025203106.3529261-1-oliver.upton@linux.dev>
References: <20241025203106.3529261-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Returning an abort to the guest for an unsupported MMIO access is a
documented feature of the KVM UAPI. Nevertheless, it's clear that this
plumbing has seen limited testing, since userspace can trivially cause a
WARN in the MMIO return:

  WARNING: CPU: 0 PID: 30558 at arch/arm64/include/asm/kvm_emulate.h:536 kvm_handle_mmio_return+0x46c/0x5c4 arch/arm64/include/asm/kvm_emulate.h:536
  Call trace:
   kvm_handle_mmio_return+0x46c/0x5c4 arch/arm64/include/asm/kvm_emulate.h:536
   kvm_arch_vcpu_ioctl_run+0x98/0x15b4 arch/arm64/kvm/arm.c:1133
   kvm_vcpu_ioctl+0x75c/0xa78 virt/kvm/kvm_main.c:4487
   __do_sys_ioctl fs/ioctl.c:51 [inline]
   __se_sys_ioctl fs/ioctl.c:893 [inline]
   __arm64_sys_ioctl+0x14c/0x1c8 fs/ioctl.c:893
   __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
   invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
   el0_svc_common+0x1e0/0x23c arch/arm64/kernel/syscall.c:132
   do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
   el0_svc+0x38/0x68 arch/arm64/kernel/entry-common.c:712
   el0t_64_sync_handler+0x90/0xfc arch/arm64/kernel/entry-common.c:730
   el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

The splat is complaining that KVM is advancing PC while an exception is
pending, i.e. that KVM is retiring the MMIO instruction despite a
pending synchronous external abort. Womp womp.

Fix the glaring UAPI bug by skipping over all the MMIO emulation in
case there is a pending synchronous exception. Note that while userspace
is capable of pending an asynchronous exception (SError, IRQ, or FIQ),
it is still safe to retire the MMIO instruction in this case as (1) they
are by definition asynchronous, and (2) KVM relies on hardware support
for pending/delivering these exceptions instead of the software state
machine for advancing PC.

Cc: stable@vger.kernel.org
Fixes: da345174ceca ("KVM: arm/arm64: Allow user injection of external data aborts")
Reported-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/mmio.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index cd6b7b83e2c3..ab365e839874 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -72,6 +72,31 @@ unsigned long kvm_mmio_read_buf(const void *buf, unsigned int len)
 	return data;
 }
 
+static bool kvm_pending_sync_exception(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu_get_flag(vcpu, PENDING_EXCEPTION))
+		return false;
+
+	if (vcpu_el1_is_32bit(vcpu)) {
+		switch (vcpu_get_flag(vcpu, EXCEPT_MASK)) {
+		case unpack_vcpu_flag(EXCEPT_AA32_UND):
+		case unpack_vcpu_flag(EXCEPT_AA32_IABT):
+		case unpack_vcpu_flag(EXCEPT_AA32_DABT):
+			return true;
+		default:
+			return false;
+		}
+	} else {
+		switch (vcpu_get_flag(vcpu, EXCEPT_MASK)) {
+		case unpack_vcpu_flag(EXCEPT_AA64_EL1_SYNC):
+		case unpack_vcpu_flag(EXCEPT_AA64_EL2_SYNC):
+			return true;
+		default:
+			return false;
+		}
+	}
+}
+
 /**
  * kvm_handle_mmio_return -- Handle MMIO loads after user space emulation
  *			     or in-kernel IO emulation
@@ -84,8 +109,11 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 	unsigned int len;
 	int mask;
 
-	/* Detect an already handled MMIO return */
-	if (unlikely(!vcpu->mmio_needed))
+	/*
+	 * Detect if the MMIO return was already handled or if userspace aborted
+	 * the MMIO access.
+	 */
+	if (unlikely(!vcpu->mmio_needed || kvm_pending_sync_exception(vcpu)))
 		return 1;
 
 	vcpu->mmio_needed = 0;
-- 
2.47.0.163.g1226f6d8fa-goog

