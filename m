Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795428353;
	b=THRI9AdS4DtpqAjoBqY6kC8oS2ul2pSqGiWtTX9GTuVNLSirytL2/U7iJDipAz2zW7l9
	 /WcNsOEJb5NDQIy8UbJjI/FRp4Wz2IlPs4YbnV/TfcFQAZh5Hy++t9DJxHsPxE210h8v4
	 Zfk2rV2gVLDDX1ZACT+9oedUulxBKQeosBPbi0/al01wHxaB1mmdjWhbPCacChaKuLsp1
	 /zViNzn59wZv6PRX5an8Her33R9m8mWyN1YUCDxZIa1GGuHEFShah6+qLBgMNYdv+dy59
	 c2qGrJ6vwAS2HWjgLZwj3u2JAU1dAGH9yGanIukFWfIs5AKKcJOY8Thor2uIsVFgJ5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795428353;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer;
	bh=Qxwqe8GUXMMOeGYRq6VI9SiKGnvgjX45C+Y5v/w1m2g=;
	b=RavEgW2aSYQVN6DOd5tEBekDYm3V9Dde0PQroX9MDGP2k/IQM66JmL2IAamPYBa9Qgze
	 d5pZrpp5VCgasJ094RCxgBZIknVCyV8I+tDmWYrxdnc+fBx6FZiAB7T1wwh4KnPPj1Li9
	 N+fcqd/Cd4AtRke9Lep0zgOyZ19OyT2sVdQla/ZlnVoTf/UfAlN327iJtrm9oI8bNYyiC
	 vJHW8Rc3kD7Uz4p3IsLvOoIq+GMwD5C0vxHx7+4FXrBicxdNbKcM3qbaHT9S+fDZizG45
	 LPyfQROVPDXsuTOR9sWuEmooT/jUezxqa8YCLxxixF9BzI0qrYg7CKBp/sGeObcaP4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=dqPkLPjQ;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E870606A31F
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 10:05:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E870606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=dqPkLPjQ
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-492f0a1b685so2128498f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 02:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795428351; x=1796033151; darn=lists.linux.dev;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Qxwqe8GUXMMOeGYRq6VI9SiKGnvgjX45C+Y5v/w1m2g=;
        b=dqPkLPjQktNfVnIXlw4TfRP8sJQUQzmujaQg29eiyzI+wAl+UCoE49Gokjt1BtbaXe
         uMEuEO5HBEnGz2Z25tOy92LAYgz5UwF3r28LPzLH6Zpfpr3qWyvZn3TD3gkSsGvikOLp
         pCc+RoeGu5m5kTXNOntk53OZ3APOImLS466+7abv767wX1AA2FVMfmSQysdePLVmv+H8
         9lmbhX0tSM4ty2vZyaoyxafvRNBx4y7jrD0B/PiyqJKi9xkr5FTobiH07dyEuLlrWHe0
         NJlGwwyZ96TAUiGczVOSZevJLLlOhvjgzLEfsyf3iCvmJILTrBmr+qaYEIseXGc0KhFU
         2Vtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795428351; x=1796033151;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Qxwqe8GUXMMOeGYRq6VI9SiKGnvgjX45C+Y5v/w1m2g=;
        b=r+qr5lkDtdfsYsklz7Jk1gGwRFjQAgw3FWjfLeGnD2lys2zeOhXEFsMtCh4RtEtb0L
         /I+7bCbfrhB8ehpI1HIWYGR6JpUkv83dIDlomwaLyihyaGvgW0lV4lMLkxVUxdxqsWxe
         wSLBXAcspxfefwUNuN67rg/fdB4QtIEcNSYfMoerEwphjRmN4JVEgxqjK1S3M3K9b0tg
         3+kotiCjAE0vcb97h3XTVrHx4hMPlwKoI3Ze8lDt6nAp9t16Pxx/SADTac/KPkpTur5x
         YVtvmTuYSJPJgFc8Pv2gYdk+OXmlfq+EnFupWnxafIKI2sGZq93ciFVQABhRDAwv21n3
         B4VQ==
X-Forwarded-Encrypted: i=1; AL+hErHZ8FmfkvrG0fvDBnbRrOL7o0XH+DAYLfp7cccdBO+9ZWlW4O5IN9ssBEDTdXcuncoflPZZmAw=@lists.linux.dev
X-Gm-Message-State: APuU4Z9dMMs71lGU6MX+bB0iNlEXxHqXT8PSwHnrcrm9Jr3Wu1GMgfrR
	NaWYLeq0zo1UabU1TJ/j/QaOMW8b+ceGxieIQ0/q14QrdVBxAz8O4G5/KtjOB3wl7l8=
X-Gm-Gg: AZFdTZcum9hsS1n/aU4kNx/8Dg986wUIyt6ezoDCwKDxDg0HOnId7Fm0Vh1o+VDDEML
	s9SvCwr+HJuGac/ySo++XRu4vVEPfAI97wM/4Bd4Zq0MGwTTwyXJmsY5T9YDj8oNhnb9gQdOQNt
	mMXRct/XqcDTHwIAHgGlpWbJgmoaokHvi3Comp3GyGW7POYXX/loDfYGkvhABhf1qkVNiBYHxVw
	3J5CVJrS6H5z3b8guCmIMNLW8L0eEM9XpDlzKd/0XMEQxK9TgvQMM8Fp3c0jyfPFrfLMCmvSFLg
	7+zqNDrlEXWxljXbwNPBfXDQo9PKvgdYn8J8yuwuJq+T1YE0RKjZou3r1Ur7xyfoZk4ErbEW90H
	AB3S0tpr3QilGy3NeyER5OSaaB2C2nqnbX4/YKq/06NztZ2r8DUAUprgwwvYDHApsr04fWOZ/vM
	3W+BKLkrJf7Nwf9Gp5Rb7/vqFtiZISauZwBeMIw9ZcsEWC7ka++Cz1x1Jm9qzH+ZYinhJ0ucsZ0
	Q8dJABCgAvFXZpnkFRgGrAnQYC2j33IsUGkATDoUOTyIxK/05CXe8wPXlGeTCLmnTsZLoEb8AIW
	Xty3YdDw4BKvT4wRKvI=
X-Received: by 2002:a5d:6f07:0:b0:4af:7577:65c0 with SMTP id ffacd0b85a97d-4af75776767mr11555729f8f.5.1795428351077;
        Mon, 23 Nov 2026 02:05:51 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6a67fe75sm23977561f8f.24.2026.11.23.02.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 02:05:50 -0800 (PST)
From: Dan Carpenter <dan@pereq.eu>
Date: Mon, 23 Nov 2026 13:05:17 +0300
Subject: [PATCH] KVM: arm64: nv: Re-inject a stored SError after the exit
 is handled
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261123-double_exception-v1-1-cd82b59a232d@pereq.eu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2WMywrCMBBFf6XM2kAnPhB/RaQkk6uNSFoyrRRK/
 91Ely7PfZyVFDlC6dKslPGOGodUgHcNSe/SAyaGwmRbe2K2rQnD7F/osAjGqYyN2x+CyNEy85n
 Kbcy4x+WrvN5+rLN/QqbqqQvvFMZnl6Sv0Z+x9rRtH/dilyqcAAAA
X-Change-ID: 20261120-double_exception-a34dcc521118
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>
Cc: Karthik Bhargavan <karthik@pereq.eu>, 
 =?utf-8?q?Cl=C3=A9ment_Blaudeau?= <clement@cryspen.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 stable@vger.kernel.org, Dan Carpenter <dan@pereq.eu>
X-Mailer: b4 0.16.0

KVM only has room for one pending exception or PC increment per vcpu.
If something is already pending and we try to add another through
kvm_pend_exception() or kvm_incr_pc(), it triggers a WARN().  If we add
an exception on top of an exception, the first one is lost.  If we add a
PC increment on top of an exception, the PC increment is lost and the
trapped instruction runs again.

Normally an exit handler records an exception or a PC increment, and
__kvm_adjust_pc() commits it before the next guest entry.  However, with
nested virtualization kvm_nested_sync_hwstate() can add an exception
before the exit handler runs.  It re-injects a stored SError after the
guest exits but before handle_exit(), which can pend the SError as an
exception.  The exit handler then records its own on top, for example an
HVC forwarded to the guest hypervisor, the FPAC for a failed ERETAA, or
the PC increment for a trapped instruction it has emulated.  This
triggers the WARN().

In this situation where we have two exceptions, the correct order is to
handle the exit first and then the SError.  Change the
kvm_nested_sync_hwstate() function to only store the SError.  Then
kvm_nested_flush_hwstate() uses __kvm_adjust_pc() to commit the exit
handler's exception or PC increment, re-injects the SError, and the
guest is entered.  The early re-injection was there so that a pending
SError wakes the vcpu from WFI, so kvm_arch_vcpu_runnable() now treats
a deliverable stored SError as a wakeup.

Fixes: 77ee70a07357 ("KVM: arm64: nv: Honor SError exception routing / masking")
Fixes: ce66109cec86 ("KVM: arm64: nv: Take "masked" aborts to EL2 when HCRX_EL2.TMEA is set")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
 arch/arm64/include/asm/kvm_emulate.h |  1 +
 arch/arm64/kvm/arm.c                 |  1 +
 arch/arm64/kvm/inject_fault.c        |  6 ++++++
 arch/arm64/kvm/nested.c              | 16 ++++++----------
 4 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 2d7c82cfb8a4..ab2ec9078b76 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -48,6 +48,7 @@ void kvm_skip_instr32(struct kvm_vcpu *vcpu);
 void kvm_inject_undefined(struct kvm_vcpu *vcpu);
 void kvm_inject_sync(struct kvm_vcpu *vcpu, u64 esr);
 int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr);
+bool kvm_nested_serror_deliverable(struct kvm_vcpu *vcpu);
 int kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr);
 int kvm_inject_dabt_excl_atomic(struct kvm_vcpu *vcpu, u64 addr);
 void kvm_inject_size_fault(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a148e80d0aef..2a2add60b72d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -966,6 +966,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 {
 	bool irq_lines = *vcpu_hcr(v) & (HCR_EL2_VI | HCR_EL2_VF | HCR_EL2_VSE);
 
+	irq_lines |= kvm_nested_serror_deliverable(v);
 	irq_lines |= (!irqchip_in_kernel(v->kvm) &&
 		      (kvm_timer_should_notify_user(v) ||
 		       kvm_pmu_should_notify_user(v)));
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index aa2011cc0d5a..05c98acb014c 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -357,6 +357,12 @@ static bool kvm_serror_undeliverable_at_el2(struct kvm_vcpu *vcpu)
 	return !(vcpu_el2_tge_is_set(vcpu) || vcpu_el2_amo_is_set(vcpu));
 }
 
+bool kvm_nested_serror_deliverable(struct kvm_vcpu *vcpu)
+{
+	return vcpu_get_flag(vcpu, NESTED_SERROR_PENDING) &&
+	       !(vcpu_is_el2(vcpu) && kvm_serror_undeliverable_at_el2(vcpu));
+}
+
 int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr)
 {
 	lockdep_assert_held(&vcpu->mutex);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 78d5b18dbd2d..f063c01c565a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -2213,8 +2213,11 @@ void kvm_nested_flush_hwstate(struct kvm_vcpu *vcpu)
 	if (!vcpu_has_nv(vcpu))
 		return;
 
-	if (unlikely(vcpu_test_and_clear_flag(vcpu, NESTED_SERROR_PENDING)))
+	if (unlikely(vcpu_test_and_clear_flag(vcpu, NESTED_SERROR_PENDING))) {
+		/* Commit the exit handler's exception first */
+		__kvm_adjust_pc(vcpu);
 		kvm_inject_serror_esr(vcpu, vcpu_get_vsesr(vcpu));
+	}
 
 	vgic_v3_nested_update_mi(vcpu);
 
@@ -2231,18 +2234,11 @@ void kvm_nested_sync_hwstate(struct kvm_vcpu *vcpu)
 
 	/*
 	 * We previously decided that an SError was deliverable to the guest.
-	 * Reap the pending state from HCR_EL2 and...
+	 * Reap the pending state from HCR_EL2, and re-inject it from
+	 * kvm_nested_flush_hwstate() once the exit has been handled.
 	 */
 	if (unlikely(__test_and_clear_bit(__ffs(HCR_EL2_VSE), hcr)))
 		vcpu_set_flag(vcpu, NESTED_SERROR_PENDING);
-
-	/*
-	 * Re-attempt SError injection in case the deliverability has changed,
-	 * which is necessary to faithfully emulate WFI the case of a pending
-	 * SError being a wakeup condition.
-	 */
-	if (unlikely(vcpu_test_and_clear_flag(vcpu, NESTED_SERROR_PENDING)))
-		kvm_inject_serror_esr(vcpu, vcpu_get_vsesr(vcpu));
 }
 
 /*

---
base-commit: adcad7f4e6332cff3d6d7165f41584899f598534
change-id: 20261120-double_exception-a34dcc521118

Best regards,
--  
Dan Carpenter <dan@pereq.eu>

