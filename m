Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC0530595B
	for <kvmarm@lists.linux.dev>; Mon, 22 Dec 2025 19:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766432076; cv=none; b=NnMmcQE8Vt5IP0Fur2xpKxxJ5ydWzTmraNFs92hRNpQMnHHdVO82cZrwHZpLWuJ8lN2aNHZZxp5nIzohKxDhYbh8VVfST2T+a62NVobJ7Vzasa1YM2YZx1fjsIAispDFA69yk29xIdtMAT/dDpfulI6G7kO5zNThOeV7lyLJUVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766432076; c=relaxed/simple;
	bh=KpG9CmoYJ0Jk+JBhdy0Qm8hAb3GQraE85CAdPJ/utdc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jh7awrywrHXH2C9b7gKhaJQN8uTHrWpYpmgmxBwt+OMMkDNtr0CkaIbGi44vtv6MGV80kAXcq5Iy4bItMiCz4DviTHu9kof5/jVr/6plDLuwftYkwJl98uAC1ysEdY14sj0SSp+523VaVTnOpfWCUwmiGAc+D8hR03eCJUo3cNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CoIfy9Oo; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CoIfy9Oo"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b9c91b814cso7302362b3a.2
        for <kvmarm@lists.linux.dev>; Mon, 22 Dec 2025 11:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766432074; x=1767036874; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AlYkI48R8rDAa0y9XkKvIFrYmbYd8scK8QFFTtIvgyc=;
        b=CoIfy9OorjD1fUb1pHzXN0elJQWtE0kKcxOCw9MWPfD2d4NR6QF37WqmlVtX6Wbu17
         bcoP/SkkEwMzxM07OtnkR1Q5Qe2Zff9RT3/XDg2YIHRk+Qt5DecX5oUjPe8VjsBfmmrP
         V04N9Xg9K57QOlXgewZbenY3hAd40A71+OSXVnxsnhwZ0yBL2DToCVBz4anymJKJKN4O
         1kqRrVHA9sIDLc9whqENXrnpc9c8qju/uYJJthltjfeCwnaoSgPxb0sIQjrZsotsJ3to
         ShD2xKjy+F/DJungwTvVC7yu3H8soEVDw9YupkO9zqqkpSZNfCxvsJa8LDiUYGXH7zYw
         eNYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766432074; x=1767036874;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AlYkI48R8rDAa0y9XkKvIFrYmbYd8scK8QFFTtIvgyc=;
        b=i9/3kqW9x2Akz0BPv0qGjmCY4TCfTylWutl4Bo1htYx7l1fgzwagdcJu1OYszzrowT
         mjYV4bN1QGhg6nRY5P4U//6ztCoKo8YPZNnZFPxLVosOvbzNnI/PleVJW/sSunllJqjw
         GJuLBioQPVwYHYI1KgX9HkHzF4Z6ZUukvpXun9jecO9OGXurb4UL/Z6493nRLCqyWVsn
         eqkKbD6outSOAzXNPGwn6GYLUJk/x0ZMtBNJO/vDVL0Ld8Jq7V0GVwr/DuptDEdEboV7
         jeH9Eo9nm1VCYsXU09pHyhbxtF0JYx5bPmcp/vp9Rd+SlbO1vSaDI7NQVS77FkENsFdl
         SKDg==
X-Forwarded-Encrypted: i=1; AJvYcCU+eBOqRdswqxGDIBuHWm7S/6wmd3E62EVD9jNSa7htlo7yBIsrQtHMLM0tS5/+Apzzc+2VWNw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwXrs8P/es0yYagcqW2j7zEY4ZlJWVldieIlRAYZN2C21kf+uP7
	dZe6mZTSfS5lXu4ioqj3UnN+jz254FzefBvkZ8bnl++UUahlD7sStSFgsvhjMJ9LUhbELJhwreD
	bWysZAQ==
X-Google-Smtp-Source: AGHT+IFQJqAuyHxNAigny9/MSevy2mpYeUMro9jWgsV9+9vQmlzsPQ5Fm6pbN/pdGRzYpAvVJGojsJA2mQE=
X-Received: from pjboa3.prod.google.com ([2002:a17:90b:1bc3:b0:34c:2f02:7f5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7f93:b0:366:14b0:1a31
 with SMTP id adf61e73a8af0-376aaefd515mr11821081637.63.1766432074363; Mon, 22
 Dec 2025 11:34:34 -0800 (PST)
Date: Mon, 22 Dec 2025 11:34:33 -0800
In-Reply-To: <42513cb3-3c2e-4aa8-b748-23b6656a5096@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com> <20250611224604.313496-40-seanjc@google.com>
 <njhjud3e6wbdftzr3ziyuh5bhyvc5ndt5qvmg7rlvh5isoop2l@f2uxctws2c7d> <42513cb3-3c2e-4aa8-b748-23b6656a5096@redhat.com>
Message-ID: <aUmdSb3d7Z5REMLk@google.com>
Subject: Re: possible deadlock due to irq_set_thread_affinity() calling into
 the scheduler (was Re: [PATCH v3 38/62] KVM: SVM: Take and hold ir_list_lock
 across IRTE updates in IOMMU)
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ankit Soni <Ankit.Soni@amd.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>, 
	Naveen Rao <Naveen.Rao@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 22, 2025, Paolo Bonzini wrote:
> On 12/22/25 10:16, Ankit Soni wrote:
> >    ======================================================
> >    WARNING: possible circular locking dependency detected
> >    6.19.0-rc2 #20 Tainted: G            E
> >    ------------------------------------------------------
> >    CPU 58/KVM/28597 is trying to acquire lock:
> >      ff12c47d4b1f34c0 (&irq_desc_lock_class){-.-.}-{2:2}, at: __irq_get_desc_lock+0x58/0xa0
> > 
> >      but task is already holding lock:
> >      ff12c49b28552110 (&svm->ir_list_lock){....}-{2:2}, at: avic_pi_update_irte+0x147/0x270 [kvm_amd]
> > 
> >      which lock already depends on the new lock.
> > 
> >    Chain exists of:
> >      &irq_desc_lock_class --> &rq->__lock --> &svm->ir_list_lock
> > 
> >    Possible unsafe locking scenario:
> > 
> >          CPU0                            CPU1
> >          ----                            ----
> >     lock(&svm->ir_list_lock);
> >                                        lock(&rq->__lock);
> >                                        lock(&svm->ir_list_lock);
> >     lock(&irq_desc_lock_class);
> > 
> >          *** DEADLOCK ***
> > 
> > So lockdep sees:
> > 
> >    &irq_desc_lock_class -> &rq->__lock -> &svm->ir_list_lock
> > 
> > while avic_pi_update_irte() currently holds svm->ir_list_lock and then
> > takes irq_desc_lock via irq_set_vcpu_affinity(), which creates the
> > potential inversion.
> > 
> >    - Is this lockdep warning expected/benign in this code path, or does it
> >      indicate a real potential deadlock between svm->ir_list_lock and
> >      irq_desc_lock with AVIC + irq_bypass + VFIO?
> 
> I'd treat it as a potential (if unlikely) deadlock:
> 
> (a) irq_set_thread_affinity triggers the scheduler via wake_up_process,
> while irq_desc->lock is taken
> 
> (b) the scheduler calls into KVM with rq_lock taken, and KVM uses
> ir_list_lock within __avic_vcpu_load/__avic_vcpu_put
> 
> (c) KVM wants to block scheduling for a while and uses ir_list_lock for
> that purpose, but then takes irq_set_vcpu_affinity takes irq_desc->lock.
> 
> I don't think there's an alternative choice of lock for (c); and there's
> no easy way to pull the irq_desc->lock out of the IRQ subsystem--in fact
> the stickiness of the situation comes from rq->rq_lock and
> irq_desc->lock being both internal and not leaf.
> 
> Of the three, the most sketchy is (a);

Maybe the most unnecessary, but I think there's a pretty strong argument that
(d) is the most sketchy:

  (d) KVM takes svm->ir_list_lock around the call to irq_set_vcpu_affinity()

> notably, __setup_irq() calls wake_up_process outside desc->lock.  Therefore
> I'd like so much to treat it as a kernel/irq/ bug; and the simplest (perhaps
> too simple...) fix is to drop the wake_up_process().  The only cost is extra
> latency on the next interrupt after an affinity change.

Alternatively, what if we rework the KVM<=>IOMMU exchange to decouple updating
the IRTE from binding the metadata to the vCPU?  KVM already has the necessary
exports to do "out-of-band" updates due to the AVIC architecture requiring IRTE
updates on scheduling changes.

It's a bit wonky (and not yet tested), but I like the idea of making
svm->ir_list_lock a leaf lock so that we don't end up with a game of whack-a-mole,
e.g. if something in the IRQ subsystem changes in the future.

---
 arch/x86/include/asm/irq_remapping.h |  3 --
 arch/x86/kvm/svm/avic.c              | 78 ++++++++++++++++++----------
 drivers/iommu/amd/iommu.c            | 24 +++------
 3 files changed, 57 insertions(+), 48 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 4e55d1755846..1426ecd09943 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -35,9 +35,6 @@ struct amd_iommu_pi_data {
 	u64 vapic_addr;		/* Physical address of the vCPU's vAPIC. */
 	u32 ga_tag;
 	u32 vector;		/* Guest vector of the interrupt */
-	int cpu;
-	bool ga_log_intr;
-	bool is_guest_mode;
 	void *ir_data;
 };
 
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6b77b2033208..0f4f353c7db6 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -868,6 +868,51 @@ static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)
 	raw_spin_unlock_irqrestore(&to_svm(vcpu)->ir_list_lock, flags);
 }
 
+static int avic_pi_add_irte(struct kvm_kernel_irqfd *irqfd, void *ir_data,
+			    struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	int r;
+
+	/*
+	 * Prevent the vCPU from being scheduled out or migrated until the IRTE
+	 * is updated and its metadata has been added to the list of IRQs being
+	 * posted to the vCPU, to ensure the IRTE isn't programmed with stale
+	 * pCPU/IsRunning information.
+	 */
+	guard(raw_spinlock_irqsave)(&svm->ir_list_lock);
+
+	if (kvm_vcpu_apicv_active(vcpu)) {
+		u64 entry = svm->avic_physical_id_entry;
+		bool ga_log_intr;
+		int cpu;
+
+		/*
+		 * Update the target pCPU for IOMMU doorbells if the vCPU is
+		 * running.  If the vCPU is NOT running, i.e. is blocking or
+		 * scheduled out, KVM will update the pCPU info when the vCPU
+		 * is awakened and/or scheduled in.  See also avic_vcpu_load().
+		 */
+		if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK) {
+			cpu = entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
+			ga_log_intr = false;
+		} else {
+			cpu = -1;
+			ga_log_intr = entry & AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR;
+		}
+		r = amd_iommu_activate_guest_mode(ir_data, cpu, ga_log_intr);
+	} else {
+		r = amd_iommu_deactivate_guest_mode(ir_data);
+	}
+
+	if (r)
+		return r;
+
+	irqfd->irq_bypass_data = ir_data;
+	list_add(&irqfd->vcpu_list, &svm->ir_list);
+	return 0;
+}
+
 int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			unsigned int host_irq, uint32_t guest_irq,
 			struct kvm_vcpu *vcpu, u32 vector)
@@ -888,36 +933,11 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		struct amd_iommu_pi_data pi_data = {
 			.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
 					     vcpu->vcpu_idx),
-			.is_guest_mode = kvm_vcpu_apicv_active(vcpu),
 			.vapic_addr = avic_get_backing_page_address(to_svm(vcpu)),
 			.vector = vector,
 		};
-		struct vcpu_svm *svm = to_svm(vcpu);
-		u64 entry;
 		int ret;
 
-		/*
-		 * Prevent the vCPU from being scheduled out or migrated until
-		 * the IRTE is updated and its metadata has been added to the
-		 * list of IRQs being posted to the vCPU, to ensure the IRTE
-		 * isn't programmed with stale pCPU/IsRunning information.
-		 */
-		guard(raw_spinlock_irqsave)(&svm->ir_list_lock);
-
-		/*
-		 * Update the target pCPU for IOMMU doorbells if the vCPU is
-		 * running.  If the vCPU is NOT running, i.e. is blocking or
-		 * scheduled out, KVM will update the pCPU info when the vCPU
-		 * is awakened and/or scheduled in.  See also avic_vcpu_load().
-		 */
-		entry = svm->avic_physical_id_entry;
-		if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK) {
-			pi_data.cpu = entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
-		} else {
-			pi_data.cpu = -1;
-			pi_data.ga_log_intr = entry & AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR;
-		}
-
 		ret = irq_set_vcpu_affinity(host_irq, &pi_data);
 		if (ret)
 			return ret;
@@ -932,9 +952,11 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			return -EIO;
 		}
 
-		irqfd->irq_bypass_data = pi_data.ir_data;
-		list_add(&irqfd->vcpu_list, &svm->ir_list);
-		return 0;
+		ret = avic_pi_add_irte(irqfd, pi_data.ir_data, vcpu);
+		if (WARN_ON_ONCE(ret))
+			irq_set_vcpu_affinity(host_irq, NULL);
+
+		return ret;
 	}
 	return irq_set_vcpu_affinity(host_irq, NULL);
 }
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 5d45795c367a..855c6309900c 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3970,7 +3970,6 @@ EXPORT_SYMBOL(amd_iommu_deactivate_guest_mode);
 
 static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *info)
 {
-	int ret;
 	struct amd_iommu_pi_data *pi_data = info;
 	struct amd_ir_data *ir_data = data->chip_data;
 	struct irq_2_irte *irte_info = &ir_data->irq_2_irte;
@@ -3993,25 +3992,16 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *info)
 
 	ir_data->cfg = irqd_cfg(data);
 
-	if (pi_data) {
-		pi_data->ir_data = ir_data;
+	if (!pi_data)
+		return amd_iommu_deactivate_guest_mode(ir_data);
 
-		ir_data->ga_root_ptr = (pi_data->vapic_addr >> 12);
-		ir_data->ga_vector = pi_data->vector;
-		ir_data->ga_tag = pi_data->ga_tag;
-		if (pi_data->is_guest_mode)
-			ret = amd_iommu_activate_guest_mode(ir_data, pi_data->cpu,
-							    pi_data->ga_log_intr);
-		else
-			ret = amd_iommu_deactivate_guest_mode(ir_data);
-	} else {
-		ret = amd_iommu_deactivate_guest_mode(ir_data);
-	}
-
-	return ret;
+	pi_data->ir_data = ir_data;
+	ir_data->ga_root_ptr = (pi_data->vapic_addr >> 12);
+	ir_data->ga_vector = pi_data->vector;
+	ir_data->ga_tag = pi_data->ga_tag;
+	return 0;
 }
 
-
 static void amd_ir_update_irte(struct irq_data *irqd, struct amd_iommu *iommu,
 			       struct amd_ir_data *ir_data,
 			       struct irq_2_irte *irte_info,

base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
--
