Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793163692;
	b=n6cvSfC3sYQ/iRO2UFchAa+0ovO8k0ocVzt176tUEV3W86M/yMMa5UTiFVQYa584/a4k
	 4jR6qPFro/9lERP/KIZgl5WJHYElR1gDSpGqXO8pXdio3q7XB+u67D5dOzDkwyRozemGc
	 PeFJoPw6c+Wo94PfupQ/5Se33Izi/XdVWWNiQgbqIVSEPCdzeGByRfjY2ZAECQEGGYGfK
	 hKbfFNjz14pFbALTcIORrhhn5QiHz0XuWtbv3hxczLoy+tVtuQF+z2YnDoohEGoIXkhAb
	 jV9BBqG6S3Ou5Oy/+MEzGHMxXKHv6obFrI2gi2TVlq1xAqqGYQWzSh6xAQTVKTaWIEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793163692;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R107460VN/9Lpa+clFPqIU2LdqoiAh3lsBpjR3ojfMo=;
	b=MlmGICC38aI8cAkmb4eeBh4Y32R3VmxyazTb1v3CZDe1sQsLWsVmUkq6PGeNrFn310N/
	 Vavm6RkVfMb17an/E99odZd+mV9HN9rJv1FDexD4ZlPIRA/wU5vA4cLwOQJZP9jZlhkKg
	 +uSkkXd7sTn9cB1Z/GA1Gs5vW/2lDXOSLmt199XSz4ddyQwVpwm9sSOBRROECR7kWmBDD
	 OB0jESFHmA1FZnINScbP9IQQunoPJkLaHnevUkz0jr01X3Pej/SpbEhvUWJEnE5T7Vm8r
	 /dgZcg3EGP18wJv9amfORp/48Daby+HXxa3QAz9Q9ktZiAIJwevPCU9188XoDsfmsbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TiIn5xyD;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C7360A3827
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 05:01:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76C7360A3827
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TiIn5xyD
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48e0d885929so385295f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 22:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793163691; x=1793768491; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R107460VN/9Lpa+clFPqIU2LdqoiAh3lsBpjR3ojfMo=;
        b=TiIn5xyDK6AdXZxhk1Hyu3Aw3qXh8QcI6qwr0/a6Mop2smy7+o4YNcGfl+wjtAWaWD
         w8J6ppXL8qTywA5Qpny8d0CTKRA0GKicEB6gvBNNAwmWnDOFb4+rcyAGm2BRi4XZ+oic
         hIowP4iTmhGaxHh6OzUGEjLurchvSYvm1htn+LmvbF4Cb0BSfWj6+2ZUJAb9BtdopCGA
         ALzFI1m1F+a+BbqnRDGmqo8LrthYerFm9a94ouDmgVQFe7YBqgXUMDe839+MxLn6jLV9
         PdVR1cYB6N5YUz+WY+5o86w2v3aZjVbcUL8wkCaVNaEc7Jg6y4tZk7qQM8Tz6tk4XV0s
         s18g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793163691; x=1793768491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R107460VN/9Lpa+clFPqIU2LdqoiAh3lsBpjR3ojfMo=;
        b=pszpaWC4+nQ5wpETD2TxQbkz1yUokd5ErgaasitBFCRFRpwYUuj4As99AVLBC9D5gh
         8vwCgkTwvG4+90hT8/HfhaU/hbaTQom/0ZGdUkvPIOSyDvoFd6y6msSJ8tk7c6u0Y40S
         Ge1xEfxPiA9FnM1+PgXdWCnXpEh+iA+OpLYdLrKmaPoOxV4hAMMWot8ucn/685kHhQ/M
         YCRWO10iAI+CUXbPp3NvkUjtIssIhTfsW6uRwQigzoTSKp08/hBQFP4l4vpSnZi8lHZY
         OGEch0VhY17ZgVlJQo4yYaFYvL7OfCgBmVFT7qN2rpcIvA3h9PykVzlly4MmPa9Yi1uC
         5TPA==
X-Forwarded-Encrypted: i=1; AKwUvBxe9ddQW6oFJ8Ouwy0PrHhSqeg0z38oVvKeDGxiPBO5i3yuTf6cpm9sBwzkyexfoV/7RHorz6E=@lists.linux.dev
X-Gm-Message-State: AFq9FYKrwwVCH7LXBBQDFv1N6gXwwXXmm5fCaUevlHMPkjHRAoXcsM3D
	h7RF0Sz69MMWABWOHmHvjttjdrwQtf3vZEJDfidwjxC23YQEJNND1Xc8
X-Gm-Gg: AYBFou1LVhWByWnlpyLfG7QSRyZtr/529fe8RMIKF52CRnx1T4kKGsDIFMRVaX86Pgn
	clY8lpmd0XUmyMLfuzre75s1NcCGqdXY/nsAIYgI6f7AxLPvwBDdGQDplUn0euTv7r4YDv7mW/h
	AjE60SVknpsIHAwfDIzlc/pPEnvNko/18yPfebifNphHGpreHiHTaaho7ldYEdvUFtiU7d1/JyB
	Q1HYEjH8vIdnHLvF3o3M8D41TYPRYiELpnFYuzVcPLNbDqXnyWTGLNIB3zIp+TgNDl/DQ9ilDoa
	8PEvRNATvLTLla30rWNrb4iuqh+l+0mXDsoo/ssSvMU2Cf6eF2d8NZyeldN40bVTw/LYM35o66u
	5dhTVLMIaNLkGK0ntlXISW6fISsTB+Yhe0uJpvCpBp2wAfZPh3lltQMTynWohK/EujKwGA0TpQm
	vwSMoG/eNbr9i67+01iExjoeqEUJwAsKz5VSfeJ2hUKhhWyqsVkCs7Op/gd9/HZE+i0TNdNG7KL
	t7JevIzB1moEGnrywPhGdNc+3fg1ooIsPowiL2FpWjE8FobkDE5a+qgM5d/OEtx9ip8UY5BDrf0
	ApPeF/1Nm0DLeZwMEffzdvqTri18f+4F3GWa/zGi4+lItg4Z7ZZW2mGGrIhs/GxpoE/UIwMPSm5
	Z/oZJqI+iyQxAPF5yD906k1IGcbQGPDS8Mu+ov4mwgHHNL6+Ih3IZ898EZb3oLq21+kx+y7T3AI
	JyUyM8IIEE2XPnNy6S9/cB9O+K4wGv2IUAq64Hh//issC6PI+lwYANia+tl44=
X-Received: by 2002:a05:600c:4e03:b0:4a7:7d22:c50c with SMTP id 5b1f17b1804b1-4a963ffcf87mr21560375e9.2.1793163690594;
        Tue, 27 Oct 2026 22:01:30 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a45b-7d01-5035-b393-698f-53f0.310.pool.telefonica.de. [2a02:3100:a45b:7d01:5035:b393:698f:53f0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a94eb8a60fsm13523365e9.3.2026.10.27.22.01.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 22:01:30 -0700 (PDT)
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
Subject: [PATCH v2 2/3] KVM: arm64: vgic-v3: Don't drop pending writes to active level IRQs
Date: Wed, 28 Oct 2026 06:01:12 +0100
Message-Id: <20261028050113.10046-3-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261028050113.10046-1-kmehltretter@gmail.com>
References: <20261028050113.10046-1-kmehltretter@gmail.com>
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

With vgic_mmio_write_spending() synchronizing the target vCPU's LRs
before setting pending_latch (which is a no-op when a vCPU writes its
own GICR_ISPENDR0), apply the GICv2 fold rule to vgic_v3_fold_lr().
Clear the old latch when an LR populated for an inactive interrupt
reports that the interrupt has been acknowledged, and preserve a latch
written while the interrupt was active.

GICv3 permits an implementation to clear register-set pending state on
ack. Doing so matches the GICv2 backend and makes a later ISPENDR write
a distinct pending state.

Fixes: 67b5b673ad4d ("KVM: arm/arm64: vgic: Disallow Active+Pending for level interrupts")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 726e20a1da6e7..4d802fc9c6dd5 100644
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
@@ -103,8 +104,11 @@ static void vgic_v3_fold_lr(struct kvm_vcpu *vcpu, u64 val)
 
 		/*
 		 * Clear soft pending state when level irqs have been acked.
+		 * A latch written while the irq was active is a new pending
+		 * state and was not represented in the LR, so preserve it.
 		 */
-		if (irq->config == VGIC_CONFIG_LEVEL && !(val & ICH_LR_STATE))
+		if (irq->config == VGIC_CONFIG_LEVEL &&
+		    !(val & ICH_LR_PENDING_BIT) && !was_active)
 			irq->pending_latch = false;
 
 		if (is_v2_sgi) {
-- 
2.39.5 (Apple Git-154)

