Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE544E1C8D
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 21:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790717372; cv=none; b=ZA5N0XTQ43wFufo9qosyj+5ceJlp7srvVeOBAv+AXLtFTsC2GQCmRvKvPWdVO0+QyF5T03iUpbACGVjorDZQpxJ1ko7Fv2taQenjAuAO9lbdfC9Z1c40bEosHwJXVCR2wsQMnTs4fIbUk3NVJcj5cHZFBpRWINIBEgYT6pDBclc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790717372; c=relaxed/simple;
	bh=565+joGrnggxYZJIBenJZARgOjTPlKqhEjyKO+y99vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=im36jwI3YKQOX3U3PDQBBrr4Idihtr2bpQQ+4nwgu/7m4cBVwQkxLzAYDxZZX/uoPK9EEO9pu4zgy2hy0sNvnXujwq8BFBDCPO02YCJ+DGnnRjhwpQX+31qeYnOEQGezcScVVcC0xqBtoH2r1mcYkcQFJbqhrNeAIeM3q/LsqKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WJ3a+84U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WJ3a+84U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EE11F00899;
	Tue, 29 Sep 2026 21:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790717370;
	bh=VsUsZUeWbFLLAabT9q9aEPJmFY1dC/HL7jDFhHdRNoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WJ3a+84UOiz7CKMfdf0I+laogoLbTks0tI79IttiyLec0JCS18HR1Ca2oEGeyH+ht
	 d42wWR6Wzj00IMZCz8/WlD7vqCyjC4CUV8hM+mtzBfKKjCtp6DthrOW2evHyMO/ixP
	 LmASVr917PQ2mA/VDaIMRLUcwlZC/BX7UPOtKypisEb1iPcs7tf2OFA0HzknWQmn8I
	 /ZJaamxSm3c2IvibuKnKEZebTgxby+50PJSQJwVUvzEbvdsbw+2w3nnUUOvOPVxC1/
	 flbS/SnbMbbyAGC2JJeNMIe1GyBFo8ypYFFRuUub+Yhc/figMe1zXoOr6z9VVqr8Wi
	 NNURJOuRA182A==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 1/4] KVM: arm64: Add helpers to halt a vCPU
Date: Tue, 29 Sep 2026 14:29:22 -0700
Message-ID: <20260929212925.31775-2-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260929212925.31775-1-oupton@kernel.org>
References: <20260929212925.31775-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently we pause the entire VM when modifying VGIC state that requires
state to be synchronized back from hardware. This is perfectly fine for
heavyweight operations but not ideal for 'simple' things like migrating
an active/pending IRQ.

Add helpers for halting a single vCPU such that they can be used to
manipulate the AP list remotely.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              | 18 ++++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 66ea2372f987..48f536968a7d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1254,6 +1254,8 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
+void kvm_pause_vcpu(struct kvm_vcpu *vcpu);
+void kvm_resume_vcpu(struct kvm_vcpu *vcpu);
 
 #define vcpu_has_run_once(vcpu)	(!!READ_ONCE((vcpu)->pid))
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index bbcaca8b36fb..9cf9b11a6457 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1023,15 +1023,25 @@ void kvm_arm_halt_guest(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_SLEEP);
 }
 
+void kvm_pause_vcpu(struct kvm_vcpu *vcpu)
+{
+	atomic_inc(&vcpu->arch.pause);
+	kvm_make_request_and_kick(KVM_REQ_SLEEP, vcpu);
+}
+
+void kvm_resume_vcpu(struct kvm_vcpu *vcpu)
+{
+	if (atomic_dec_and_test(&vcpu->arch.pause))
+		__kvm_vcpu_wake_up(vcpu);
+}
+
 void kvm_arm_resume_guest(struct kvm *kvm)
 {
 	unsigned long i;
 	struct kvm_vcpu *vcpu;
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (atomic_dec_and_test(&vcpu->arch.pause))
-			__kvm_vcpu_wake_up(vcpu);
-	}
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_resume_vcpu(vcpu);
 }
 
 static void kvm_vcpu_sleep(struct kvm_vcpu *vcpu)
-- 
2.47.3

