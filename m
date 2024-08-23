Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21ABD7D401
	for <kvmarm@lists.linux.dev>; Fri, 23 Aug 2024 21:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724448449; cv=none; b=GT4IQvscvRkWBvWFIlidrgNp1+8vAnBoS+t6ke0rP1ZdWf5xy0Q07WLOIU8utA7wvbBCKaLiPizHDYGRxDsO+BZUWpBS205iH7aTf/2SjoxcETRWqEb0M8TfvOSerRBLlP59ydKMBWSn1BJpdzRGR9xv1Gr7LSEuxE+g4/mbu4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724448449; c=relaxed/simple;
	bh=x54+ubmuzgP2h2GJRtZ3f21Kt7vaQNnCxDQLK33lXy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieClPxMEPAGt6YxcegmZAZFtKxnITyxW00PpXpn23fYPaqm6PPWifZE8xbiVaLw1VxvsH58mvwkzByGwJofBQSHlOhzrqxdRr1LxL+bdswKbmUPZ8tb+KOMT7frDa8aLKum+28MAOtBgShdKcSbF0PTR0FgSFffTNGvZpfbgcgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jLa9Z7Sf; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jLa9Z7Sf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724448443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gTE+zxUzrq/JZZh+bn+Zlnz7t23jXQbhz9NjeCh6Tqs=;
	b=jLa9Z7SfLnB3RjVxCvXYB9t7PvpJxmqowiE1HSr2JUBLQCvdjMvN92FXmaMzO/u1QFe8Qt
	uVblk6LSj7qraCYtiaa+72DtesbmREbuNb5f079memfEcUmaZdObzNjbU+Nmc5a97Beokd
	u799DOVGpzRFKnzER3HajTPPpqMXGc0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/3] KVM: arm64: nv: Leave vPE nonresident in nested vgic state
Date: Fri, 23 Aug 2024 21:27:01 +0000
Message-ID: <20240823212703.3576061-2-oliver.upton@linux.dev>
In-Reply-To: <20240823212703.3576061-1-oliver.upton@linux.dev>
References: <20240823212703.3576061-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Nested VGIC support hasn't taken shape upstream yet, although one thing
that's already clear is KVM will not virtualize GICv4 for the guest
hypervisor. Nope. Nada. Maybe we can revisit the topic for the next GIC
architecture.

Leave the vPE unloaded in nested state and document why we do it. This
has been spun off from the nested VGIC patch that Marc has been carrying
as part of the NV series.

Co-developed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 15 ++++++++++++++-
 include/kvm/arm_vgic.h        |  5 +++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index ed6e412cd74b..27b42664bb1c 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -727,7 +727,14 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 	if (has_vhe())
 		__vgic_v3_activate_traps(cpu_if);
 
-	WARN_ON(vgic_v4_load(vcpu));
+	/*
+	 * KVM does not virtualize GICv4 for the guest hypervisor, so there's no
+	 * vPE to load when in a nested state. The L1 vPE remains nonresident
+	 * so the GIC will generate a doorbell when a vLPI/vSGI becomes pending
+	 * for the L1.
+	 */
+	if (!vgic_is_nested_state(vcpu))
+		WARN_ON(vgic_v4_load(vcpu));
 }
 
 void vgic_v3_put(struct kvm_vcpu *vcpu)
@@ -735,6 +742,12 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
 	kvm_call_hyp(__vgic_v3_save_vmcr_aprs, cpu_if);
+
+	/*
+	 * The vPE may already be nonresident if we're blocking (i.e. already
+	 * called vgic_v4_put()) or in a nested state. Calling vgic_v4_put() on
+	 * an already nonresdent vCPU is benign.
+	 */
 	WARN_ON(vgic_v4_put(vcpu));
 
 	if (has_vhe())
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index f5172549f9ba..0b1b7b706227 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -434,6 +434,11 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
 
+static inline bool vgic_is_nested_state(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 /* CPU HP callbacks */
 void kvm_vgic_cpu_up(void);
 void kvm_vgic_cpu_down(void);
-- 
2.46.0.295.g3b9ea8a38a-goog

