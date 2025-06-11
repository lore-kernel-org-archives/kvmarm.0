Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670F12C3279
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682045; cv=none; b=DB7QXO3q99gZQGvSaT2Owt3nMBG54ThaZ5j5RPHyp/vxr2Y7geHicaohXWmBv2sP3dsU495m5IDn2jYuuLq1BqEQyqCXU9pZGIKAP4TbnyNh18Hm2m/Tvdmx0j504ce6Oe1G5fFTgANQUJs6+qFSdTmyG2ns8KkCzRv9x7pkgAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682045; c=relaxed/simple;
	bh=+hv/L1bIbXZPSlj1hiWZXItfDwwPTIV42fY47pjIvko=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=elwcYtauDeyL9aIfyVQUJ9FpkfI3k3/aeMVZ9jnZPOISKTDtPsUuqSEOLuZyL7b/GD385aEasiKnRLMOpGPMX7lmAxUO7NeftPE7EjSVfgSnpbkbum7oHNl1r8RJiaOeq5F7tfKs4mkseRzXdqZllKki+9nB3mtD9wcMQDAdjeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lChituJy; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lChituJy"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747af0bf0ebso257993b3a.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682042; x=1750286842; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uVzEHyBaRiJNDQh5a5Dx7H8kv7wjszZU3WXvYcKHvtU=;
        b=lChituJy53z0q8QT77d3LweI9x4nP2g8/lZ2XGhGV5du0wldwwJSZL6yfGaU8SgL9g
         7kaen133+0DEVO5KbrF7OFuy1n/aCRkeznwnayV0aobTl7xAmSYDtev/G2PFrIShsgD5
         pmwwn9ZbvPL6Onzy6irZiScRnUhEimvasgANB9jdk2cg15XDdqxNnJYsNj5N2ilo2+Ce
         CIRAcdk/FX9RwabpY200Y+FV44cb04PXuCQVnH3x97NqgFnozyRpvlfNmcToYmVnpAoz
         4kLdzX15YRXjU1OqPhttf9eW6GT1MxTrl+ELfJavZpcrh2q5ARdlV2mZy/Osl5zP0wUC
         t7YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682042; x=1750286842;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uVzEHyBaRiJNDQh5a5Dx7H8kv7wjszZU3WXvYcKHvtU=;
        b=BR7pzyFF3pNBUXJ1lEc+7DCgyyAgo1CdCfOZeZEXyYOJigEXHFNMQfNMY9gymE9w1A
         oJkpTEQWGcIzeAod1PxrtCPhDHlFcxALPzyD3G38j9JHpyigluNzZH6WynxG+Gtxva9e
         pe3CgyZs8IbCG6jvEwK3klwPnCUDHt6DtFWxIxCEmmEMaHDS7RLj7QIjIkVrZUuthyGh
         2/xAijeJqX6eZfueUcuaSUxbHFYLvOJep0834rhGG9C7LUumE53f3bmwuusxkRts4XXo
         knw/aDRMy4SGyLNljswVr5hfMPaJm+6S+gtVtyrqOHJY7oFDDnl5V571hplUIH/+4Koo
         HdBw==
X-Forwarded-Encrypted: i=1; AJvYcCVGp7lrgFW9qC6SUU1eXp/ELpVgIrYuj08hQ4iJgYa2kTexphyDChStOyv9SGmvYselPtVlkf0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3JYQdFfzjU//p6c0uYRUK4x4dzlM7cgnJOBUF/2HTzmmisNQa
	JT4AxaporTyGLflCmbjQiZcGXIg+wUb7Dbqpi8jxcBfdLuoTT2ihh7j48Txhjjuv/5g0C4OwjBv
	W0ORPkA==
X-Google-Smtp-Source: AGHT+IFakcvyKnqCueAUeZlAT109XlS9YCn8fDNscX2Sisdyt0t4bYMkEX6AxhE9x+pXQlvyQldIB86adbU=
X-Received: from pfnx17.prod.google.com ([2002:aa7:84d1:0:b0:746:27ff:87f8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:72a1:b0:210:1c3a:6804
 with SMTP id adf61e73a8af0-21f9bbb2da4mr712401637.31.1749682042326; Wed, 11
 Jun 2025 15:47:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:18 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-17-seanjc@google.com>
Subject: [PATCH v3 15/62] KVM: SVM: Drop superfluous "cache" of AVIC Physical
 ID entry pointer
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

Drop the vCPU's pointer to its AVIC Physical ID entry, and simply index
the table directly.  Caching a pointer address is completely unnecessary
for performance, and while the field technically caches the result of the
pointer calculation, it's all too easy to misinterpret the name and think
that the field somehow caches the _data_ in the table.

No functional change intended.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 27 +++++++++++++++------------
 arch/x86/kvm/svm/svm.h  |  1 -
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index bf18b0b643d9..0c0be274d29e 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -294,8 +294,6 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 		    AVIC_PHYSICAL_ID_ENTRY_VALID_MASK;
 	WRITE_ONCE(kvm_svm->avic_physical_id_table[id], new_entry);
 
-	svm->avic_physical_id_cache = &kvm_svm->avic_physical_id_table[id];
-
 	return 0;
 }
 
@@ -770,13 +768,16 @@ static int svm_ir_list_add(struct vcpu_svm *svm,
 			   struct kvm_kernel_irqfd *irqfd,
 			   struct amd_iommu_pi_data *pi)
 {
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
 	unsigned long flags;
 	u64 entry;
 
 	if (WARN_ON_ONCE(!pi->ir_data))
 		return -EINVAL;
 
-	irqfd->irq_bypass_vcpu = &svm->vcpu;
+	irqfd->irq_bypass_vcpu = vcpu;
 	irqfd->irq_bypass_data = pi->ir_data;
 
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
@@ -787,7 +788,7 @@ static int svm_ir_list_add(struct vcpu_svm *svm,
 	 * will update the pCPU info when the vCPU awkened and/or scheduled in.
 	 * See also avic_vcpu_load().
 	 */
-	entry = READ_ONCE(*(svm->avic_physical_id_cache));
+	entry = READ_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id]);
 	if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
 		amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
 				    true, pi->ir_data);
@@ -964,17 +965,18 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	u64 entry;
+	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long flags;
+	u64 entry;
 
 	lockdep_assert_preemption_disabled();
 
 	if (WARN_ON(h_physical_id & ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
 		return;
 
-	if (WARN_ON_ONCE(!svm->avic_physical_id_cache))
+	if (WARN_ON_ONCE(vcpu->vcpu_id * sizeof(entry) >= PAGE_SIZE))
 		return;
 
 	/*
@@ -996,14 +998,14 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	 */
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
 
-	entry = READ_ONCE(*(svm->avic_physical_id_cache));
+	entry = READ_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id]);
 	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
 	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
 	entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 
-	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
+	WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
 	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
 
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
@@ -1011,13 +1013,14 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 void avic_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	u64 entry;
+	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long flags;
+	u64 entry;
 
 	lockdep_assert_preemption_disabled();
 
-	if (WARN_ON_ONCE(!svm->avic_physical_id_cache))
+	if (WARN_ON_ONCE(vcpu->vcpu_id * sizeof(entry) >= PAGE_SIZE))
 		return;
 
 	/*
@@ -1027,7 +1030,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	 * can't be scheduled out and thus avic_vcpu_{put,load}() can't run
 	 * recursively.
 	 */
-	entry = READ_ONCE(*(svm->avic_physical_id_cache));
+	entry = READ_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id]);
 
 	/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
 	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
@@ -1046,7 +1049,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
-	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
+	WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
 
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ec5d77d42a49..f225d0bed152 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -306,7 +306,6 @@ struct vcpu_svm {
 
 	u32 ldr_reg;
 	u32 dfr_reg;
-	u64 *avic_physical_id_cache;
 
 	/*
 	 * Per-vCPU list of irqfds that are eligible to post IRQs directly to
-- 
2.50.0.rc1.591.g9c95f17f64-goog

