Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793163691;
	b=3YzS5Zs4F6bzKPX5URmMT9BniYPwn1nfG4eyRHiRazsfvxC4TCv25983SMYYMBpmlyaY
	 7TT0OzyI/clFVG/XdChq6aMwVh/ApyPjENgHvhZhXSupRinXkF9lc7yNySMqWC+jcl+X8
	 mz7gMzkq1BFj3fS4MLmz4QWl+N7cW18xZAlUtlTqMXMnbvByTKu3qfWLAWZ1/j/rBIaXq
	 jfJecp1NH3jGv6kRR3wYoQUSpWZbi0gtcb/R+0X+Wm1varuQeOL6YJ2kyRHFdks9Xwbw4
	 bJZk4DjvGIne0v5G1Ijn2Ov3s1DkoKMakqWZQuY5vi8GXN4VMuoMdJ/vsL016aoPFdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793163691;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4PPjtqMp1V58uGYejGtWodvU/HeeS5pvfYydRAC9x9I=;
	b=liwK4yvHqFByyd5/dlWuD+p751QeSRZlGUTOyQt1DgYKrKC6yjOnRRJQ1M+asp4nql/v
	 Kk21VchwsnWBi+U9f6jvKLPFMYhuGG9ykzlZa6lLIgNnmAr2e+m7Y1U6WZQfd6l+w8kVm
	 f346vEyYH5jUI4DMaVdXMHXv4kyiKPgcfaCWqe9Ee+NLUCgjiVzoUjDL5EO75ddIQN2CW
	 3gSShpZy6+BuOmP9P3BFnWXXqRtM2Kx28Qdm4xiKY0SD0ojyrxaH8v8UdSV/VdV4DDEHB
	 msEFeQd8PLB1gxWOhNzjAasv6B8mh7n0zpUSeLRXFbnV9jusR6x5FzWcBlA0nhM+csg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pl6yvyPc;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D12606A333
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 05:01:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1D12606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pl6yvyPc
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a215e64962so5554335e9.1
        for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 22:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793163689; x=1793768489; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4PPjtqMp1V58uGYejGtWodvU/HeeS5pvfYydRAC9x9I=;
        b=pl6yvyPcSvjyDxLq7xGFqVNnLRqr6eWzPG0Riz3DBymao0ArPEqzSLAjNyE8MmpnFA
         VEvOhv/bjSVPx00Q6S9nGA7wBX1N35sqQ/gLQ6Kz4VPAFhjZ+fvIVsd/MjdTLZCIw87p
         HUCtablQI/7guJonXrvBbd612GvgMFoGZk4GSYlMZXKLA/FWxHUaW9w0aWwnm/eZwLme
         v/Pg3AxnPBONUJicuYpeSkcqZd0xlgs/qVUIGjXceUMUOlQNSBUbn3Lp5/tYR8ZdFPky
         g+eDjBz10LBvttC3/uGFksPgs+Xn3SSnsC/zju84f/JLoSlPLwNLv0nxNqjiL6LwdpYl
         zaIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793163689; x=1793768489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4PPjtqMp1V58uGYejGtWodvU/HeeS5pvfYydRAC9x9I=;
        b=EOn2OdvmEwEGYDt5adp+Y+Fv5S6kL05ChunVGOAFdGmgbOD3sJJosZ+yLAqSu8FutZ
         zxNyTZgXfUl0V60yYs+38i1IQwK0I4PYinj4ri3iiV3tyyaiw3GyMSBKVtqAvxXClMy4
         5Ux+KhVinOqDADZCKQrYXYGy9vX3tR7CeVFvytav4S6chLfMRNUsVsD3azDdE5mHTkJU
         nU8MAZh60JqjUqBjHLVfU48AFWIKo3p2IEIIwS6tKqs0gJK8EqiXnk/xa+5rCBTQpgOR
         /bacCLTEHcxaVx5m99H6cdRmDxTLmfpgIbtjpTeAjzk5LxrLYG4SLkpCUUfES9eqwMqD
         GexA==
X-Forwarded-Encrypted: i=1; AKwUvBwl3WNVvBqs/5h2RzM7Xyj6acBVzSiwJ3Bqf9PQVqgJcjutI4NQ18m8jaieKJVsXBMK0Cvgppc=@lists.linux.dev
X-Gm-Message-State: AFq9FYIxro0i4VRftoTZkM+vYW8QKxQNbHdI5lkxpA/04mScJcKEymJy
	MtMbjFgJH04SdjIDpbppChTRJR+TCkUCa+UlX0A5YxkMBwS2lxkRbBcO
X-Gm-Gg: AYBFou1zMdgf+9woJwiRaMAXKh5pPajEP/Fbum1ATmV1lQXm+QYOYS5bqmPAxzmhfQU
	qwwFgXE5poYe/ppk1buIo1yznqGrTiDxd5T8c7cn1CmOcHO9s1sUIzlxlZcHoKU1dtgWzmuOHTI
	YSOkRGluFasyxFBbhm9dsQwQk89440r0X2WhELgtFtSxGEyKYeUI4R6dkUBEQmFiVIMKbAWMHEy
	320DKS0neTu/6pj3xnfhADG9zuReKgRKKjLtFHVn3KNi/1JaV1RipJ/Seo323pw6RyHv/Gl+6Xy
	gpnDN92P5IA7Okw81mBTmVOgJm94zbkBxPBiGCTGy8/uw0U+ijWUnORQR63QQ1gaQajd/N8wH2D
	g9IJ7JjVIDk9cQuMKa8kbkrf52+77hUebPezc/wVYaxGFyimfyOQbu4WxMswj7zElbc5ZklOr9O
	l2KKaQ6WQYexeUjRuVuIjSmud1H9MaE5K136RHQGmDdNr9rksEnBrLVxhwJtoIXoaLd32JzQUJf
	EUEzvi7HxwofjApO3N9A13nFqQaCudT/CbOmKl7TS91VDeGAhx9DGLTfotWSwkWVeFdAiieNOrC
	m19yWUBnQHa7oF+Pl2F9fDwFY6W+3SQ2rmWkxXFWGViCJqKBFVP/qb0PEL9QCQ86IhmlufU+jMx
	cCjtaxsrQ43Vh0JYV5qKZLtHEEzuztxTL5CE29A9PhfY7xyxBbstjBGM63GARytQT1qrm4X7xJE
	yFk5/nVgSbHYtlRsUxpQ5KRfopEmFicKgadLnDtQ==
X-Received: by 2002:a05:600c:154e:b0:4a1:7bd4:d07d with SMTP id 5b1f17b1804b1-4a967e8d5a3mr18553845e9.34.1793163689112;
        Tue, 27 Oct 2026 22:01:29 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a45b-7d01-5035-b393-698f-53f0.310.pool.telefonica.de. [2a02:3100:a45b:7d01:5035:b393:698f:53f0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a94eb8a60fsm13523365e9.3.2026.10.27.22.01.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 22:01:28 -0700 (PDT)
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
Subject: [PATCH v2 1/3] KVM: arm64: vgic-v2: Don't drop pending writes to active level IRQs
Date: Wed, 28 Oct 2026 06:01:11 +0100
Message-Id: <20261028050113.10046-2-kmehltretter@gmail.com>
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

A write to GICD_ISPENDR for an active level interrupt makes the
interrupt Active and Pending. It must be delivered again after it is
deactivated.

KVM loses the second pending state. vgic_v2_populate_lr() leaves
pending_latch set for a level interrupt, while vgic_v2_compute_lr()
keeps Pending and Active out of the same LR. vgic_v2_fold_lr() clears
the latch after the LR becomes empty. At that point it cannot tell the
original latch from one written while the interrupt was active, and
clears both.

Synchronize the target vCPU's LRs in vgic_mmio_write_spending() with
vgic_access_active_prepare() and vgic_access_active_finish() under
config_lock before setting pending_latch. When the interrupt is in an
LR on another vCPU, this folds any prior ack into the VGIC state before
the new pending state is recorded.

In vgic_v2_fold_lr(), clear the original latch when an LR populated for
an inactive interrupt no longer reports a pending state, and preserve a
latch written while the interrupt was active.

Fixes: 67b5b673ad4d ("KVM: arm/arm64: vgic: Disallow Active+Pending for level interrupts")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 arch/arm64/kvm/vgic/vgic-mmio.c | 76 +++++++++++++++++++--------------
 arch/arm64/kvm/vgic/vgic-v2.c   | 10 +++--
 2 files changed, 50 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index fddb9da0403d5..e42eb10d502b2 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -350,11 +350,54 @@ static void __set_pending(struct kvm_vcpu *vcpu, gpa_t addr, unsigned int len,
 	}
 }
 
+/*
+ * If we are fiddling with an IRQ's active state, we have to make sure the IRQ
+ * is not queued on some running VCPU's LRs, because then the change to the
+ * active state can be overwritten when the VCPU's state is synced coming back
+ * from the guest. Setting an IRQ pending also requires the target VCPU's LRs
+ * to be synced first so that any prior ack in the LR is folded
+ * before pending_latch is set.
+ *
+ * For shared interrupts as well as GICv3 private interrupts accessed from the
+ * non-owning CPU, we have to stop all the VCPUs because interrupts can be
+ * migrated while we don't hold the IRQ locks and we don't want to be chasing
+ * moving targets.
+ *
+ * For GICv2 private interrupts we don't have to do anything because
+ * userspace accesses to the VGIC state already require all VCPUs to be
+ * stopped, and only the VCPU itself can modify its private interrupts
+ * active state, which guarantees that the VCPU is not running.
+ */
+static void vgic_access_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
+{
+	if ((vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 &&
+	     vcpu != kvm_get_running_vcpu()) ||
+	    intid >= VGIC_NR_PRIVATE_IRQS)
+		kvm_arm_halt_guest(vcpu->kvm);
+}
+
+/* See vgic_access_active_prepare */
+static void vgic_access_active_finish(struct kvm_vcpu *vcpu, u32 intid)
+{
+	if ((vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 &&
+	     vcpu != kvm_get_running_vcpu()) ||
+	    intid >= VGIC_NR_PRIVATE_IRQS)
+		kvm_arm_resume_guest(vcpu->kvm);
+}
+
 void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val)
 {
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+
+	mutex_lock(&vcpu->kvm->arch.config_lock);
+	vgic_access_active_prepare(vcpu, intid);
+
 	__set_pending(vcpu, addr, len, val, false);
+
+	vgic_access_active_finish(vcpu, intid);
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
 }
 
 int vgic_uaccess_write_spending(struct kvm_vcpu *vcpu,
@@ -452,39 +495,6 @@ int vgic_uaccess_write_cpending(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-/*
- * If we are fiddling with an IRQ's active state, we have to make sure the IRQ
- * is not queued on some running VCPU's LRs, because then the change to the
- * active state can be overwritten when the VCPU's state is synced coming back
- * from the guest.
- *
- * For shared interrupts as well as GICv3 private interrupts accessed from the
- * non-owning CPU, we have to stop all the VCPUs because interrupts can be
- * migrated while we don't hold the IRQ locks and we don't want to be chasing
- * moving targets.
- *
- * For GICv2 private interrupts we don't have to do anything because
- * userspace accesses to the VGIC state already require all VCPUs to be
- * stopped, and only the VCPU itself can modify its private interrupts
- * active state, which guarantees that the VCPU is not running.
- */
-static void vgic_access_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
-{
-	if ((vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 &&
-	     vcpu != kvm_get_running_vcpu()) ||
-	    intid >= VGIC_NR_PRIVATE_IRQS)
-		kvm_arm_halt_guest(vcpu->kvm);
-}
-
-/* See vgic_access_active_prepare */
-static void vgic_access_active_finish(struct kvm_vcpu *vcpu, u32 intid)
-{
-	if ((vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 &&
-	     vcpu != kvm_get_running_vcpu()) ||
-	    intid >= VGIC_NR_PRIVATE_IRQS)
-		kvm_arm_resume_guest(vcpu->kvm);
-}
-
 static unsigned long __vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 					     gpa_t addr, unsigned int len)
 {
diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 7182f63fc9382..f3ba3177dd97b 100644
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
@@ -88,8 +89,11 @@ static void vgic_v2_fold_lr(struct kvm_vcpu *vcpu, u32 val)
 
 		/*
 		 * Clear soft pending state when level irqs have been acked.
+		 * A latch written while the irq was active is a new pending
+		 * state and was not represented in the LR, so preserve it.
 		 */
-		if (irq->config == VGIC_CONFIG_LEVEL && !(val & GICH_LR_STATE))
+		if (irq->config == VGIC_CONFIG_LEVEL &&
+		    !(val & GICH_LR_PENDING_BIT) && !was_active)
 			irq->pending_latch = false;
 
 		/* Handle resampling for mapped interrupts if required */
-- 
2.39.5 (Apple Git-154)

