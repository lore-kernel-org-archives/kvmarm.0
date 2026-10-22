Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792651605;
	b=cRjkJzIdJw8FVq5azaoe8aP/4Qa/JQeYGqYau3Vj4PlSbYQFdqiUUc2W4LDA5d65+8Us
	 Rfo13NkjkD4KcP0n5ksD66OPJgmbowxVO8t+iCQGXUgVVJZkVmhv9VqavIcRKb3aS8yey
	 MMjxmyPKCN7Elx/Et4aiUn5we6RXBmHbBY4ATGtXzhbIzEXygXtzUUCE9zSkLRlYruX+T
	 99o8aq9Ni60OKhJFXvl9k94E7GU6AavliAyZH/HAuWMZafiMh430axU/cxT/H/IFtFPoe
	 JdzsYYRo/+mwB8MWpe11E8JD59MShFLKnnpXlDcYt3MBpDLA6Z4+3kOdiYntmdhiE1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792651605;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JINO212XZqoHkVZMBAnF93gGUq9jJ54l6n4NWOl1V5Y=;
	b=ASmeI46/+IWHerSGQEKTQK5IdsfQfzel5aG6D1rTwcUxx+FUmF3MSYwtisMe61ceBAoN
	 brYOu2jxQhw/tD7yKLyQiQxusasOTEzzNpS73QUF/UMG+1QUFH8wa5sFh3Zr6eqvQ2lbV
	 NsANZakDO0Y8T+y5SBQYoZ4PWbNsHtWMVHtgLXujNJgSmNo1zb2BtlzGGnth2/t0kBrlu
	 juzn3sq3wI+jSvZY416rbyrSCgQLlyNj2vbNLfNz1ClImINh18TrEe9a4Dknq6V/Gvf76
	 0pV+tPNZfm6Ia/lMHATsaww7L33mDBpX4+VTAKTAtDd6+vtgfo6+YcvXWSgVRLq1CNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PqQdL9WV;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DD6606A319
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 06:46:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94DD6606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PqQdL9WV
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48afcfc4bf5so1317983f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 23:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792651603; x=1793256403; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JINO212XZqoHkVZMBAnF93gGUq9jJ54l6n4NWOl1V5Y=;
        b=PqQdL9WVGGBffqw9oFGM82uL5Cb+xC8Goljd0/iq4Gu5auTTI+gzsSkM+Rol4NsMQq
         UBSOLiCKK6VdX8Yi5/hiOJPs/h7a5ERlOPLmbfD0YNGnNNQvsn6XCWrLcOcZl49iyXKt
         d9ylxodzPGOKLdsV/5iI/IcYUUWBGMFkE6+4sTms7WAtgQzZLj9IgKrtUtTnx0IUwc9u
         QpUJCJaRaKfgfA3tekzgpnU/2Y1LIRxq0nyTynpiD4z5evXwuxwh2ZLIAhaHzg3TMrdl
         Y1mBil0CvOBCS25WVYnkw9OLDxbQ5MobSCIxhDdRloTqPYaUUFwaOj0iAUvsP1ug5+ra
         mCVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792651603; x=1793256403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JINO212XZqoHkVZMBAnF93gGUq9jJ54l6n4NWOl1V5Y=;
        b=KnCSPs8Ej5FNUwCEMv3jtwrlTK766wtvNBBe0Dh08Q/vFLvb7y8y1aBx5NINXUz45r
         9tOcXrY+zHv5Tx92zm1HIIrHmsiXrLevyvtmF6KbFEm0OUDBIrnUl45EKXrd+kbYvHro
         L4JF4WJBKLdDdDGKaOCALQpu7qRMDChSP2GvMySZaz1DDcs6pp167dXLHht+0CYCEcBp
         YLmxwzAPG++9FaoDgumasaWKrg/btX0DcYpoLK9Ro2SUdgS8eo0Zvd3vxK4oziElx86+
         r37Um/IWzWRypJ6ruPdy8dv5H/C6CM3hyEqN7AZxZmD3YVClE2g9Oi4cNgsaKkZd8jK1
         m32g==
X-Forwarded-Encrypted: i=1; AKwUvBzNZ7qOkWCncJ/Dlx9Tb5J1q3sSA0W+zjOIuAjPYqhb3CCxrnQgDw0ygMWz7RFYh5MZsuffW4o=@lists.linux.dev
X-Gm-Message-State: AFq9FYIrHgc+pLKKutd17IWN272K1ooECGCTPW2AGUw6lj9fc/EoDBTb
	BElSpwc0dm52GqMuJKnwLb5SgHTy2fj+pZTsALtUU6dOyIl6eliq0yvi
X-Gm-Gg: AYBFou3DX/na30/VAi8/uuqmXfCNgvZlpZApxO0lT40vqTodinEE+B4VYSKFzvp/hI2
	WWmfGnVZRD/PUY41YsC49YRVTGevszcdrJHgcjJm7CiR+v5mtb3S4g6ZDMBW7mrYF0Ls8HjXEeZ
	KVFiJIveBm8aZO27qpn6/e2GHV0Z0yIIpiV5Ppd/0gVqm46A+dEqmob/aci3vY/vSBvRa5xevlD
	7ik7tlzhEurYo+d1X7/kYge/aV30lkFMDEupydsMR10xX8KO+I8pJc6g0cajuhTrbfbzU46qx46
	dSxVKr+qWNKh1VMaY9AWHc4XbgYj5XTIxKtn4J4yW7EsXOMapo1wAyR2bW18edpgcHJx4czkos6
	MQx5Pd3Z4+L8UDORBIBlAJRPNZOeJDM3EMv/gHh8fADhvFS+8otMCw2LHq0vg6XkSIL7qH+3mmX
	/wy33XSLirZt93YgTaHMUEqvZUSiAP18qcjF3+sUyli1IPPVuswBunfwIyzypDaFE1qRdDgAQXZ
	O/dDHoy0DmL7HQBo7RmtKn9cLIkKnp8xZ9OiXp5reeA7DnhgTpW0kGrbabp0ykzzM6i6wYmTb9p
	we615AHu62Uv3aI23ZO7BgVoRWWuwhnHrVGtI+YVM8YZn/S0vR99TmKvQWkOQLR01/GHb2saOyY
	kHbhi2vXWESlDw1Dca2kkQ2v4Li/0lh6B4J8tk2KBw7wznwY96j3NUb+mLTlGe5fQ
X-Received: by 2002:a05:6000:26c5:b0:48c:8126:a260 with SMTP id ffacd0b85a97d-48e26427bd6mr9490490f8f.6.1792651602673;
        Wed, 21 Oct 2026 23:46:42 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-ad43-d501-2c28-bb72-120d-420e.310.pool.telefonica.de. [2a02:3100:ad43:d501:2c28:bb72:120d:420e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25828cd1sm10215624f8f.22.2026.10.21.23.46.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Oct 2026 23:46:42 -0700 (PDT)
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
Subject: [RFC PATCH 1/3] KVM: arm64: vgic-v2: Don't drop pending writes to active level IRQs
Date: Thu, 22 Oct 2026 08:46:26 +0200
Message-Id: <20261022064628.4206-2-kmehltretter@gmail.com>
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

A write to GICD_ISPENDR for an active level interrupt makes the
interrupt Active and Pending. It must be delivered again after it is
deactivated.

KVM loses the second pending state. vgic_v2_populate_lr() leaves
pending_latch set for a level interrupt, while vgic_v2_compute_lr()
keeps Pending and Active out of the same LR. vgic_v2_fold_lr() clears
the latch after the LR becomes empty. At that point it cannot tell the
original latch from one written while the interrupt was active, and
clears both.

Clear the original latch when the LR first reports no pending state.
Keep a latch which was not represented in the LR, either because the
interrupt was already active or because the guest wrote ISPENDR while
the interrupt was in an LR. Clear the marker together with the latch
on an ICPENDR write.

A remote ISPENDR write can race with the guest ack. KVM cannot tell
which happened first without synchronizing the target vCPU. Preserve
the write, which may cause one extra delivery if it preceded the ack
but avoids losing a write that followed it.

Fixes: 67b5b673ad4d ("KVM: arm/arm64: vgic: Disallow Active+Pending for level interrupts")
Assisted-by: LLM
---
 arch/arm64/kvm/vgic/vgic-mmio.c |  9 +++++++++
 arch/arm64/kvm/vgic/vgic-v2.c   | 13 ++++++++++---
 include/kvm/arm_vgic.h          |  1 +
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index fddb9da0403d5..1728c78f99cfd 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -341,6 +341,13 @@ static void __set_pending(struct kvm_vcpu *vcpu, gpa_t addr, unsigned int len,
 			continue;
 		}
 
+		/*
+		 * The guest may already have acked what is in the LR,
+		 * in which case this is a new pending state.
+		 */
+		if (irq->on_lr)
+			irq->latch_written = true;
+
 		irq->pending_latch = true;
 		if (irq->hw && !is_user)
 			vgic_irq_set_phys_active(irq, true);
@@ -427,6 +434,8 @@ static void __clear_pending(struct kvm_vcpu *vcpu,
 			continue;
 		}
 
+		irq->latch_written = false;
+
 		if (irq->hw && !is_user)
 			vgic_hw_irq_cpending(vcpu, irq);
 		else
diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 7182f63fc9382..37474ea2431c5 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -57,7 +57,7 @@ static void vgic_v2_fold_lr(struct kvm_vcpu *vcpu, u32 val)
 {
 	u32 cpuid, intid = val & GICH_LR_VIRTUALID;
 	struct vgic_irq *irq;
-	bool deactivated;
+	bool deactivated, was_active;
 
 	/* Extract the source vCPU id from the LR */
 	cpuid = FIELD_GET(GICH_LR_PHYSID_CPUID, val) & 7;
@@ -71,7 +71,8 @@ static void vgic_v2_fold_lr(struct kvm_vcpu *vcpu, u32 val)
 
 	scoped_guard(raw_spinlock, &irq->irq_lock) {
 		/* Always preserve the active bit, note deactivation */
-		deactivated = irq->active && !(val & GICH_LR_ACTIVE_BIT);
+		was_active = irq->active;
+		deactivated = was_active && !(val & GICH_LR_ACTIVE_BIT);
 		irq->active = !!(val & GICH_LR_ACTIVE_BIT);
 
 		if (irq->active && vgic_irq_is_sgi(intid))
@@ -88,9 +89,15 @@ static void vgic_v2_fold_lr(struct kvm_vcpu *vcpu, u32 val)
 
 		/*
 		 * Clear soft pending state when level irqs have been acked.
+		 * A latch written while the irq was active is a new pending
+		 * state. A write while the irq was in the LR may also have
+		 * followed the ack, so preserve it too.
 		 */
-		if (irq->config == VGIC_CONFIG_LEVEL && !(val & GICH_LR_STATE))
+		if (irq->config == VGIC_CONFIG_LEVEL &&
+		    !(val & GICH_LR_PENDING_BIT) &&
+		    !was_active && !irq->latch_written)
 			irq->pending_latch = false;
+		irq->latch_written = false;
 
 		/* Handle resampling for mapped interrupts if required */
 		vgic_irq_handle_resampling(irq, deactivated, val & GICH_LR_PENDING_BIT);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 7be81b936bf10..28ed27d982dfc 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -292,6 +292,7 @@ struct vgic_irq {
 	bool active:1;
 	bool hw:1;			/* Tied to HW IRQ */
 	bool on_lr:1;			/* Present in a CPU LR */
+	bool latch_written:1;		/* Level only: latch set while on_lr */
 	refcount_t refcount;		/* Used for LPIs */
 	u32 hwintid;			/* HW INTID number */
 	unsigned int host_irq;		/* linux irq corresponding to hwintid */
-- 
2.39.5 (Apple Git-154)

