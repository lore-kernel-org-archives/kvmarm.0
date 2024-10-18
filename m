Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4857205AA3
	for <kvmarm@lists.linux.dev>; Fri, 18 Oct 2024 19:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729280893; cv=none; b=MmmnbAMEiiXYKZvpGznoLGVWvwjjd8JzSNCfPh2IL8+AEQVoDNDlwQ3/A7WxOuosZkeJ0q2GTZK1ZijeNdwd1iAWEgIC5qQqE7mLR44dyYdUejrbOF/iYZZqxffOryPM1fEl4jqo5/ME9Jbdt+uGWeN/juSce2AjeQBOz8qfLMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729280893; c=relaxed/simple;
	bh=VipGcGsE6eFugFHvhCy1okIQAKNRT2jXtyvgwzcT1uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6xytQ2AovFR7EG1KnhvBrS4CedeW3VVoRQDAu+Bm1XZTtICFM/8GU+2qbjD2O+WsHdxoELRgHMUOGasP8/Jmt/lF7Al++4qC3paSgiGKm0/OvLwQCKzSfuA+xXKWPn3rM33T/dHotjlfARb0jPADu4o1VjxEsAihVJnAezKpTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XcacmeQ9; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XcacmeQ9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729280888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7LhwSIv2ZZ27y4I7vOtLM+Tu+r1WwT3gWljSeNEqcwY=;
	b=XcacmeQ9/TT3YQsjXvki8nJqgcyfOlMjfJNqX3BYsFarN5BRvrsXkra1FUWiTgXb7JTEFs
	fbsqWbtNs0wZBZTP/AHmeHNirC8W42sDuBqxFAU9IgcyVUOMYJXgvATOd1opAwnxp1FcgU
	6ilv7o+AUk8gYCheNdt1Pdkj9QTbDDo=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	stable@vger.kernel.org,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH 1/2] KVM: arm64: Don't retire aborted MMIO instruction
Date: Fri, 18 Oct 2024 19:47:56 +0000
Message-ID: <20241018194757.3685856-2-oliver.upton@linux.dev>
In-Reply-To: <20241018194757.3685856-1-oliver.upton@linux.dev>
References: <20241018194757.3685856-1-oliver.upton@linux.dev>
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
pending external abort. Womp womp.

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
 arch/arm64/include/asm/kvm_emulate.h | 25 +++++++++++++++++++++++++
 arch/arm64/kvm/mmio.c                |  7 +++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index a601a9305b10..1b229099f684 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -544,6 +544,31 @@ static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
 		vcpu_set_flag((v), e);					\
 	} while (0)
 
+static inline bool kvm_pending_sync_exception(struct kvm_vcpu *vcpu)
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
 #define __build_check_all_or_none(r, bits)				\
 	BUILD_BUG_ON(((r) & (bits)) && ((r) & (bits)) != (bits))
 
diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index cd6b7b83e2c3..0155ba665717 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -84,8 +84,11 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
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
2.47.0.rc1.288.g06298d1525-goog

