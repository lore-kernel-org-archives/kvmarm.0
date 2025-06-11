Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313112F2C51
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682124; cv=none; b=Y7cK2XOolsf0jcTK+AIfpluvXvKlBK/YCbhgVel7PG6HkrxKbmd5iVzodH7YWbYnL2LrFQxbsobtLKLcPLbZEX+xal6daRnZqeTd6Z2QJV5lpfoNi0dfXkOTeS7ngH9kvERqUra0l6HFsah+b1ijvUsq74CMVYDgz6TBbDluyhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682124; c=relaxed/simple;
	bh=hau5k6KEMoISG8sknKRCDqOugaQby2DDkVbYq43crGc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jIMzLOtGsL9l1T8Tk82qSNTAsvpWXJD7p2FZWSk2gCoGMx+L5bNF3OHXz+BKowjNEDhrhzb2mlyGe4MA5KEDDulEuj2Qe2FYBbJGOQJFeCHjlevZmEIR2HQdKg3bFbbbrlmDQwlgfXubmxiP8OHOtQymG3uMgM1h1F65H8UDa8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=agGzTuJX; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="agGzTuJX"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2fa1a84565so123474a12.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682121; x=1750286921; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hmfB8lOX2q4C1Qfnb9hUYc3blCs/E2S3R9OL4z8QP30=;
        b=agGzTuJXGgw3JmcYaIEgKZPupzcgpWdAckPeiV6ePD/DCUw4kbLw+ylSpQXI1aLVGJ
         rbEbuBliGiFlaJ+YUCpAOD2b1FO3Ps0SxGMNSSbBZLVyUDxj+HEbSKXMx1ZfH1Mn/Yc8
         ixA8w9/0xIOuRP9EfyEEPzeeZoXfe11s7uZfSeDj68YDs8nhMJeMs71FxabrmpuA0FX4
         tgs1eTW70r1F8AeywWu94VEYl0OApj9BMHVMPz6Fe+JqMhF0xp0IPZmfwkK1msQAZeco
         2jQWLSCFk+hmUZF1m6F4Oi1eBh7xA79bJGGHkENXoTDso1JME5GwStRbJlOOC2yAbrrj
         q0Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682121; x=1750286921;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hmfB8lOX2q4C1Qfnb9hUYc3blCs/E2S3R9OL4z8QP30=;
        b=btfGmL7li7F5kQ1BKVb16luOKRQRQSUBZb7yGwdgl2sNRzT3p9IUHDuK6tylHLPEDt
         8B2P+KNTSQIK5lUXSShxgtcvqngwGWvvMPp9GrLFThOARKhDDyXhV/2o9k4pj+cjUHE3
         FuDm07DhOAgefcg8bvfM34c0Ka3n4Dm/7yadn3CJsOp9j31G+xdUPrPR+vRauNxQzbb3
         wM+bXbsK7sOxsZYCIP5DXdIpkSRSewNnOR/U18WRxa1rhGOlrq2u7T8lk4H5+y0V4tKV
         UYKmoSiEaC6Ogfqq6LHtK6Tydd5vsoLVyf/tTzCM/kBDQyXKXHvfZh6VSe9+YlSab5gC
         2deg==
X-Forwarded-Encrypted: i=1; AJvYcCVEFXPdQudZKVl9kt36iAsuBwUZsHmQtfOV8aJdFXq2KSG7PU9cKtUq1geqq71N7J6AawKxQvw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyl5mA0in9ArHQqkljkns3OJl7ZlACZJ4/Kofmj0SBwEFKn7VVR
	tLJECErFfZuniL+Xl4zXtHSSsoeQlkRIwkWPQiA9Pf9iC70y0KA6AWQ+OtuRyB4VXNZN+rktmTx
	4//jLqg==
X-Google-Smtp-Source: AGHT+IH5h0j7VRVfcXIPqKoozM0Dd+19ZFrZA3sJjyCkhp4wpaWauQxaF+akeAplYxcFuLxUbJfK933sl3c=
X-Received: from pgjp8.prod.google.com ([2002:a63:e648:0:b0:b2c:3a2e:ac7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:d704:b0:215:dfd0:fd24
 with SMTP id adf61e73a8af0-21f978aeb8cmr2433515637.31.1749682121591; Wed, 11
 Jun 2025 15:48:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:46:04 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-63-seanjc@google.com>
Subject: [PATCH v3 61/62] KVM: SVM: Generate GA log IRQs only if the
 associated vCPUs is blocking
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Configure IRTEs to GA log interrupts for device posted IRQs that hit
non-running vCPUs if and only if the target vCPU is blocking, i.e.
actually needs a wake event.  If the vCPU has exited to userspace or was
preempted, generating GA log entries and interrupts is wasteful and
unnecessary, as the vCPU will be re-loaded and/or scheduled back in
irrespective of the GA log notification (avic_ga_log_notifier() is just a
fancy wrapper for kvm_vcpu_wake_up()).

Use a should-be-zero bit in the vCPU's Physical APIC ID Table Entry to
track whether or not the vCPU's associated IRTEs are configured to
generate GA logs, but only set the synthetic bit in KVM's "cache", i.e.
never set the should-be-zero bit in tables that are used by hardware.
Use a synthetic bit instead of a dedicated boolean to minimize the odds
of messing up the locking, i.e. so that all the existing rules that apply
to avic_physical_id_entry for IS_RUNNING are reused verbatim for
GA_LOG_INTR.

Note, because KVM (by design) "puts" AVIC state in a "pre-blocking"
phase, using kvm_vcpu_is_blocking() to track the need for notifications
isn't a viable option.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/svm.h |  7 +++++
 arch/x86/kvm/svm/avic.c    | 63 ++++++++++++++++++++++++++++++--------
 2 files changed, 58 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 36f67c69ea66..ffc27f676243 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -252,6 +252,13 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
 #define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
 
+/*
+ * GA_LOG_INTR is a synthetic flag that's never propagated to hardware-visible
+ * tables.  GA_LOG_INTR is set if the vCPU needs device posted IRQs to generate
+ * GA log interrupts to wake the vCPU (because it's blocking or about to block).
+ */
+#define AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR		BIT_ULL(61)
+
 #define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	GENMASK_ULL(11, 0)
 #define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	GENMASK_ULL(51, 12)
 #define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index e61ecc3514ea..e4e1d169577f 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -788,7 +788,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			pi_data.cpu = entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
 		} else {
 			pi_data.cpu = -1;
-			pi_data.ga_log_intr = true;
+			pi_data.ga_log_intr = entry & AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR;
 		}
 
 		ret = irq_set_vcpu_affinity(host_irq, &pi_data);
@@ -825,16 +825,25 @@ enum avic_vcpu_action {
 
 	/*
 	 * No unique action is required to deal with a vCPU that stops/starts
-	 * running, as IRTEs are configured to generate GALog interrupts at all
-	 * times.
+	 * running.  A vCPU that starts running by definition stops blocking as
+	 * well, and a vCPU that stops running can't have been blocking, i.e.
+	 * doesn't need to toggle GALogIntr.
 	 */
 	AVIC_START_RUNNING	= 0,
 	AVIC_STOP_RUNNING	= 0,
+
+	/*
+	 * When a vCPU starts blocking, KVM needs to set the GALogIntr flag
+	 * int all associated IRTEs so that KVM can wake the vCPU if an IRQ is
+	 * sent to the vCPU.
+	 */
+	AVIC_START_BLOCKING	= BIT(1),
 };
 
 static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu,
 					    enum avic_vcpu_action action)
 {
+	bool ga_log_intr = (action & AVIC_START_BLOCKING);
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_kernel_irqfd *irqfd;
 
@@ -851,9 +860,9 @@ static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu,
 		void *data = irqfd->irq_bypass_data;
 
 		if (!(action & AVIC_TOGGLE_ON_OFF))
-			WARN_ON_ONCE(amd_iommu_update_ga(data, cpu, true));
+			WARN_ON_ONCE(amd_iommu_update_ga(data, cpu, ga_log_intr));
 		else if (cpu >= 0)
-			WARN_ON_ONCE(amd_iommu_activate_guest_mode(data, cpu, true));
+			WARN_ON_ONCE(amd_iommu_activate_guest_mode(data, cpu, ga_log_intr));
 		else
 			WARN_ON_ONCE(amd_iommu_deactivate_guest_mode(data));
 	}
@@ -888,7 +897,8 @@ static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu,
 	entry = svm->avic_physical_id_entry;
 	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
-	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
+	entry &= ~(AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK |
+		   AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR);
 	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
 	entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 
@@ -949,12 +959,26 @@ static void __avic_vcpu_put(struct kvm_vcpu *vcpu, enum avic_vcpu_action action)
 
 	avic_update_iommu_vcpu_affinity(vcpu, -1, action);
 
+	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR);
+
+	/*
+	 * Keep the previous APIC ID in the entry so that a rogue doorbell from
+	 * hardware is at least restricted to a CPU associated with the vCPU.
+	 */
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
-	svm->avic_physical_id_entry = entry;
 
 	if (enable_ipiv)
 		WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
 
+	/*
+	 * Note!  Don't set AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR in the table as
+	 * it's a synthetic flag that usurps an unused should-be-zero bit.
+	 */
+	if (action & AVIC_START_BLOCKING)
+		entry |= AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR;
+
+	svm->avic_physical_id_entry = entry;
+
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 }
 
@@ -969,11 +993,26 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	 */
 	u64 entry = to_svm(vcpu)->avic_physical_id_entry;
 
-	/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
-	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
-		return;
+	/*
+	 * Nothing to do if IsRunning == '0' due to vCPU blocking, i.e. if the
+	 * vCPU is preempted while its in the process of blocking.  WARN if the
+	 * vCPU wasn't running and isn't blocking, KVM shouldn't attempt to put
+	 * the AVIC if it wasn't previously loaded.
+	 */
+	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)) {
+		if (WARN_ON_ONCE(!kvm_vcpu_is_blocking(vcpu)))
+			return;
 
-	__avic_vcpu_put(vcpu, AVIC_STOP_RUNNING);
+		/*
+		 * The vCPU was preempted while blocking, ensure its IRTEs are
+		 * configured to generate GA Log Interrupts.
+		 */
+		if (!(WARN_ON_ONCE(!(entry & AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR))))
+			return;
+	}
+
+	__avic_vcpu_put(vcpu, kvm_vcpu_is_blocking(vcpu) ? AVIC_START_BLOCKING :
+							   AVIC_STOP_RUNNING);
 }
 
 void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
@@ -1039,7 +1078,7 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
 	 * CPU and cause noisy neighbor problems if the VM is sending interrupts
 	 * to the vCPU while it's scheduled out.
 	 */
-	__avic_vcpu_put(vcpu, AVIC_STOP_RUNNING);
+	__avic_vcpu_put(vcpu, AVIC_START_BLOCKING);
 }
 
 void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
-- 
2.50.0.rc1.591.g9c95f17f64-goog

