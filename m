Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792651607;
	b=vZQHIDwTFhfH0gVGfjbKCm+ZuCZa9r6YCsoC0/VTJWzG7DRYqUy3DNPnVkIYLIGI/nMX
	 qer7bIODAl3LzNEV+khrVnzHL3J3wol5AKMzfvGR8bd7sYgFbVheWQdV58C3K/nwkkq4j
	 Nd8Sc0tpJMJ1m8QpXoa8fswiiZYq+iA48UB8nFh/ATtzU5Y50bx75rjfaRBNPagLIxvki
	 ieCrBMeqGpvUUDPtgSJuMGusktuZTWCkdcH/zImLwWKRC7zgHZ78UP1iMVNz5G/6Y2gV8
	 tMezMx8+48TNllFn2+reuNfO85Wr/lEVzx7nt1qXTJgwX/vkjoR3IilgeBtNJkhH0Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792651607;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M/mYu7fYt3Nnrov1PUQgYA1NNwSASs0rt/VgYt7AiFM=;
	b=a1ifQbMwLJ9UNrt6mdEM9LUwO5RRDJStWo7hu5Opn19bLP1uJpklaRS8HJ80vdn9lJUK
	 jwiTPOCK8GIuAw5RSXVF+V05vnfEyittMIhk/Jsg9vA55xgZQAcAxH+RBU7NmcOSuI7Jr
	 OFcAnOkfQKwB3rNKb6x3hUabNjxEoMx8FFsqG7b5knjjsNtMVdRZiI5G8Vbw6ZnucQ3AA
	 cnDGsjR4JzkjmTPkushW0/NPbr3vlW34Wo2hjJdULS3j/0XhIXsU6daidRMy+o4v83NMp
	 vklHCc/uFPxbaCJiJ7HVPnaaPjV8+gd/CkVeb4K95LDElYOb8nhM+76W79gI3M5ng4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=S1viNSDw;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20612606A319
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 06:46:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20612606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=S1viNSDw
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-487049569b6so966432f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 23:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792651604; x=1793256404; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M/mYu7fYt3Nnrov1PUQgYA1NNwSASs0rt/VgYt7AiFM=;
        b=S1viNSDwnKe9fifTeOKVNIWXBn29ea6kaAwZBGo6cmz0O1drSYhC4KDfR/2gntZzGp
         XGAld1zA+4KOBG4iDZ2ZHk0D8QuOxfFtI/jPUOEvoPhxuMDPzkqJlV/siv3FhuZv2M76
         V19ZVU8JnSilmoWbXkaedmOUXcVH8WrMtDlu3lGy6zf0iOjReyACAhXEm1NIOGcRadtn
         7fDeJbS1ODXbnqSzBwhvrMtws5bDe6KRdveZzoTL7d4Ds4DXx0rLkhLunOEfvNgnsBUs
         QHXT/VsAhfei9bMcb8TOu8wNzW+DxcYk5gEY0m+qoossZNZdRI85OqArsYX2Lq8WRmuP
         A6Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792651604; x=1793256404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M/mYu7fYt3Nnrov1PUQgYA1NNwSASs0rt/VgYt7AiFM=;
        b=LI6MGtn65dvptflwLi0PEa5AubyFuGmlLtXKND0XhWfzs3tMApwBv7g3zB42hgSBUR
         Lh32uHym0Heh2j/fpwcC7QgyQREhqW5/DP7RU11CDbAgFDqW0Izot2LCRlENBKte+vk4
         Rv3kjZegkJxqfV+WkFJT1BnmQkNZDpEt0S8hJw7hL6kYX6YMfYddJS+XojHBFfnQ9MDC
         xRd+1BOotfzYFaBbahsGBEMHyTZqCjWwWdZsasEuZK1j3+xgaY3xfww4NflA64veDhwh
         swKBHWNOI1d57LsUYwxoTt8Qsij/zqhMsx+/kpV0gN7Tqv+q1q7FYXhRXZInqrRxyg5K
         sT9A==
X-Forwarded-Encrypted: i=1; AKwUvByHae+qZMRFBGBGmftliGZ/Fq6g4YvVFhs9uHPDRaADWlvA3iyQdogBsPVwAbfj2tPwaqYV10g=@lists.linux.dev
X-Gm-Message-State: AFq9FYKtkjAgnyAl7ckYUBE3U2r8F8VlKaz/zhjXJQqjg9oSZUSxY2di
	x9qVFUf0BhIlXrlbbkvPR9c6q8Lx5bfl94T6SAmgWImZMHHIefNVpuNv
X-Gm-Gg: AYBFou0WJ2J3W2tiiccJeQxcUuuYwGTXs8B57DzVIYtFtzOORE9V77BbAB1xGtGnIOt
	ncMSe3VI9eBdbZAHvw58aasN1sPaeN73jKBkBxHz3NFILV23H/J8eQZr+hwBhsDxG7FJZ2n6rdc
	6cEBJfg0CA1CsXODuWZIyJc6owBT6yJiPLEIOJBYgA3GhWKp1owcy55RdbhzvxAojB29FixMIu7
	pMNvzK24ooEX1kkrdTpQgCKq2wcbz2N7YJtNl3tYDJHO/oPcvBKDJv38Sj7nilHwW0RwQYEnHf3
	0USys9EdrQAiC6c6SFOhX63Pr1pZo5hTl0z2FoMdOlhy5KdpimhWNVOtDAjFOt+XW6kLaG/JE+Z
	v0bVx0wX5HFmaf2EYlmEh8OqghCfdd2gj3CARJ3ONAxJCjSXsIj7K6c20LHMu5u6z9m4ugyjy8a
	kxhmVVNBiyoLQeSLtxsgvfG4U9sA2k1qmJYHc/EARbQZg0qQhz8WS/pmUh6JBZrR+VDs0fSqUOQ
	u83FA+uq6HsxFyBy7clrz+zpZOvpgb489NFA++AV3Bs1wZGDz0LbuaOyQ6BtiBFokeTiBrXqUOc
	fc/npKVDad+OWqPOq6PF0Kc9U/BlQeje05w9GrAlyYQdVOYmy4sZJM+lbOM33MGiY5mEpHMsj/X
	Kc2FCjCnCVFVrDECRfNX8gBOdCl6mtk51V9YB6db21pdzfyo9lU3HJ4xasR1Htm9W
X-Received: by 2002:a05:6000:1111:b0:48d:fed0:ccbd with SMTP id ffacd0b85a97d-48e264caa01mr6437578f8f.34.1792651604419;
        Wed, 21 Oct 2026 23:46:44 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-ad43-d501-2c28-bb72-120d-420e.310.pool.telefonica.de. [2a02:3100:ad43:d501:2c28:bb72:120d:420e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25828cd1sm10215624f8f.22.2026.10.21.23.46.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Oct 2026 23:46:44 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/3] KVM: arm64: vgic-v3: Don't drop pending writes to active level IRQs
Date: Thu, 22 Oct 2026 08:46:27 +0200
Message-Id: <20261022064628.4206-3-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261022064628.4206-1-kmehltretter@gmail.com>
References: <20261022064628.4206-1-kmehltretter@gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The GICv3 backend also loses a level interrupt set pending through
GICD_ISPENDR or GICR_ISPENDR0 while it is active. Its LR handling has
the same split between pending_latch and an Active-only LR as GICv2,
and clears the new pending state after deactivation.

Apply the GICv2 bookkeeping to vgic_v3_fold_lr(). Clear the old latch
when the LR reports that the interrupt has been acknowledged, and
preserve a latch which was not represented in the LR.

GICv3 permits an implementation to clear register-set pending state on
ack. Doing so matches the GICv2 backend and makes a later ISPENDR write
a distinct pending state.

Fixes: 67b5b673ad4d ("KVM: arm/arm64: vgic: Disallow Active+Pending for level interrupts")
Assisted-by: LLM
---
 arch/arm64/kvm/vgic/vgic-v3.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 726e20a1da6e7..8009dc6df00db 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -75,7 +75,7 @@ static void vgic_v3_fold_lr(struct kvm_vcpu *vcpu, u64 val)
 {
 	struct vgic_irq *irq;
 	bool is_v2_sgi = false;
-	bool deactivated;
+	bool deactivated, was_active;
 	u32 intid;
 
 	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
@@ -93,7 +93,8 @@ static void vgic_v3_fold_lr(struct kvm_vcpu *vcpu, u64 val)
 		/* Always preserve the active bit for !LPIs, note deactivation */
 		if (irq->intid >= VGIC_MIN_LPI)
 			val &= ~ICH_LR_ACTIVE_BIT;
-		deactivated = irq->active && !(val & ICH_LR_ACTIVE_BIT);
+		was_active = irq->active;
+		deactivated = was_active && !(val & ICH_LR_ACTIVE_BIT);
 		irq->active = !!(val & ICH_LR_ACTIVE_BIT);
 
 		/* Edge is the only case where we preserve the pending bit */
@@ -103,9 +104,15 @@ static void vgic_v3_fold_lr(struct kvm_vcpu *vcpu, u64 val)
 
 		/*
 		 * Clear soft pending state when level irqs have been acked.
+		 * A latch written while the irq was active is a new pending
+		 * state. A write while the irq was in the LR may also have
+		 * followed the ack, so preserve it too.
 		 */
-		if (irq->config == VGIC_CONFIG_LEVEL && !(val & ICH_LR_STATE))
+		if (irq->config == VGIC_CONFIG_LEVEL &&
+		    !(val & ICH_LR_PENDING_BIT) &&
+		    !was_active && !irq->latch_written)
 			irq->pending_latch = false;
+		irq->latch_written = false;
 
 		if (is_v2_sgi) {
 			u8 cpuid = FIELD_GET(GICH_LR_PHYSID_CPUID, val);
-- 
2.39.5 (Apple Git-154)

