Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA7D24EA85
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682119; cv=none; b=MDLsGUPijZEBnHJglweb1AB4upELaryvFuqlvR6ljHVaDv6FcPtCRtjZvpvXth6tYnOCqzAFDVWUpVU4kOgqsKeuam0MAI72amqNyTikv1c4jiQL4J7/QgL+wfiRDKBOytzH749StdkKE80/pGwaKBMTsX0G57gCWdm4uJOz/Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682119; c=relaxed/simple;
	bh=WeRv3qsDDbsHqZ7Lj+dTG4f6h8cg/1Q7VSdMcR5QYHw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o3kZlLlLl0C+xDw299Az1d/Q8O4z2IWBINfHPP/sTIbOPdY/Gq69c3sD6Wk8dho0HnxpKjS9K/MrIJ/tBrwMpPcTLN34DmokDaMGkTB2+ZXL6/FPXwkaI1uU6GixBKnp4WTVnZ7AhQvMwM+CtCQ1B6eoQkG94PW+BUsEdXTogwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T1V/vjOy; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T1V/vjOy"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-231d13ac4d4so3347895ad.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682116; x=1750286916; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FezZVwAIX27yOhkNPTycKKVEi5uWL2iUiKq6QlVZHOU=;
        b=T1V/vjOyKYa69cihqtNV4LZJ6jBs16pJuwlKX+tomQQgUyVefRWINNYD333rb7UuFl
         dX3uuxZ3B5Hzv1ugt/G+GSuJyNdzUCvueiGHTZ2TIjwPjO7CFq76DMw/ROu4k/gafW+M
         Sk1tNf1QuaH3PqskyPFUnegqpAZcg4a/eZY43BmF/hL+fkh4gIzcbl9EgiFn4gY5vDKz
         Vkw+0h1daNAlSAmSqP2r/Ic+V/3t3L0gjUD/aXEJvPWYOFdKvJrTcNiF5uL6oFOdhhKw
         fXJv5ODf93jcp8VXsD8wY5wsKjoHWaBpPYHjlmzC/WVc8+nq1UHDMsgh42cN9QZ9lq18
         LkmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682116; x=1750286916;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FezZVwAIX27yOhkNPTycKKVEi5uWL2iUiKq6QlVZHOU=;
        b=LBUOrZJMyZtwRtgmPDW9nQeHbzyROjOGRRbxiEIwQHyyWxEi6QDiF7Fk+CaYqevI98
         n2aJ0A5yTMwXpj9NH8h9CFyBlaZGXeTFoMK0HFKJu7mty5p0PgnlrK0D0tTRoyq2XvMe
         L2PC8sPDW4vSpfygAPfww2LSGz7his4cR1bUykLwxgic/cQxKebhbUn/oy68W6XwRpLt
         yh7xxjacBdAuL1+i/emvG4fCutLGXUoK12r/sbDjQiuFNOMY+p5SyI3g7PstgSsoh1uR
         xjxsns7LpFYfs5/WNY6c9B9kIOriGe2a8AQKSPcNb7uNPEKuM3rJCbH+Wrq0pggI3WYA
         Q2HA==
X-Forwarded-Encrypted: i=1; AJvYcCWyy8MnTSZ7Ah1350iSbTgbbFTqBcNcJaIxLMBrrl6cHhdDuDx/njYQCx++zg0efRpf7rm4Ra0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwyIah2zIL2rzW+FEdKyJKoP05JbiptO/pUFx1jESU0ONTUC9QB
	TTxy+RrqfAtkSZirBcVt8lFpII6LKLdnZHC2mDXFusZFbPlDInUBlBePmpqxDuDaBjnA7YDrRuT
	EHgWPEw==
X-Google-Smtp-Source: AGHT+IE0mnhzPmaGDjcFYBs1HKY/3aqg20RLoeGBLv7o8irQVmRVOs75AEwPqXs1TaFQwm4uFyelNA0uq7s=
X-Received: from pjbsg18.prod.google.com ([2002:a17:90b:5212:b0:311:ff32:a85d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4acb:b0:313:28f1:fc33
 with SMTP id 98e67ed59e1d1-313c06872aemr1120199a91.10.1749682116501; Wed, 11
 Jun 2025 15:48:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:46:01 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-60-seanjc@google.com>
Subject: [PATCH v3 58/62] KVM: SVM: Don't check vCPU's blocking status when
 toggling AVIC on/off
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

Don't query a vCPU's blocking status when toggling AVIC on/off; barring
KVM bugs, the vCPU can't be blocking when refreshing AVIC controls.  And
if there are KVM bugs, ensuring the vCPU and its associated IRTEs are in
the correct state is desirable, i.e. well worth any overhead in a buggy
scenario.

Isolating the "real" load/put flows will allow moving the IOMMU IRTE
(de)activation logic from avic_refresh_apicv_exec_ctrl() to
avic_update_iommu_vcpu_affinity(), i.e. will allow updating the vCPU's
physical ID entry and its IRTEs in a common path, under a single critical
section of ir_list_lock.

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 65 +++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 9ddec6f3ad41..1e6e5d1f6b4e 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -828,7 +828,7 @@ static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu)
 		WARN_ON_ONCE(amd_iommu_update_ga(cpu, irqfd->irq_bypass_data));
 }
 
-void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
@@ -844,16 +844,6 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (WARN_ON_ONCE(vcpu->vcpu_id * sizeof(entry) >= PAGE_SIZE))
 		return;
 
-	/*
-	 * No need to update anything if the vCPU is blocking, i.e. if the vCPU
-	 * is being scheduled in after being preempted.  The CPU entries in the
-	 * Physical APIC table and IRTE are consumed iff IsRun{ning} is '1'.
-	 * If the vCPU was migrated, its new CPU value will be stuffed when the
-	 * vCPU unblocks.
-	 */
-	if (kvm_vcpu_is_blocking(vcpu))
-		return;
-
 	/*
 	 * Grab the per-vCPU interrupt remapping lock even if the VM doesn't
 	 * _currently_ have assigned devices, as that can change.  Holding
@@ -888,31 +878,33 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 }
 
-void avic_vcpu_put(struct kvm_vcpu *vcpu)
+void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	/*
+	 * No need to update anything if the vCPU is blocking, i.e. if the vCPU
+	 * is being scheduled in after being preempted.  The CPU entries in the
+	 * Physical APIC table and IRTE are consumed iff IsRun{ning} is '1'.
+	 * If the vCPU was migrated, its new CPU value will be stuffed when the
+	 * vCPU unblocks.
+	 */
+	if (kvm_vcpu_is_blocking(vcpu))
+		return;
+
+	__avic_vcpu_load(vcpu, cpu);
+}
+
+static void __avic_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long flags;
-	u64 entry;
+	u64 entry = svm->avic_physical_id_entry;
 
 	lockdep_assert_preemption_disabled();
 
 	if (WARN_ON_ONCE(vcpu->vcpu_id * sizeof(entry) >= PAGE_SIZE))
 		return;
 
-	/*
-	 * Note, reading the Physical ID entry outside of ir_list_lock is safe
-	 * as only the pCPU that has loaded (or is loading) the vCPU is allowed
-	 * to modify the entry, and preemption is disabled.  I.e. the vCPU
-	 * can't be scheduled out and thus avic_vcpu_{put,load}() can't run
-	 * recursively.
-	 */
-	entry = svm->avic_physical_id_entry;
-
-	/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
-	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
-		return;
-
 	/*
 	 * Take and hold the per-vCPU interrupt remapping lock while updating
 	 * the Physical ID entry even though the lock doesn't protect against
@@ -932,7 +924,24 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 		WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
 
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
+}
 
+void avic_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Note, reading the Physical ID entry outside of ir_list_lock is safe
+	 * as only the pCPU that has loaded (or is loading) the vCPU is allowed
+	 * to modify the entry, and preemption is disabled.  I.e. the vCPU
+	 * can't be scheduled out and thus avic_vcpu_{put,load}() can't run
+	 * recursively.
+	 */
+	u64 entry = to_svm(vcpu)->avic_physical_id_entry;
+
+	/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
+	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
+		return;
+
+	__avic_vcpu_put(vcpu);
 }
 
 void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
@@ -973,9 +982,9 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 	avic_refresh_virtual_apic_mode(vcpu);
 
 	if (activated)
-		avic_vcpu_load(vcpu, vcpu->cpu);
+		__avic_vcpu_load(vcpu, vcpu->cpu);
 	else
-		avic_vcpu_put(vcpu);
+		__avic_vcpu_put(vcpu);
 
 	/*
 	 * Here, we go through the per-vcpu ir_list to update all existing
-- 
2.50.0.rc1.591.g9c95f17f64-goog

