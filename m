Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5592E7644
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682083; cv=none; b=TWUd2V6TuRn1f/oyJ93DP7ReyHnipdNDTIwTEa1nIeAj6eU5S0aV83TJvuZpcAWGpi4YB06mIMrqd0bVWYaokynZE3qxdhkwbUJGqiyW/NgeKgA+fLSVHf1HLAPcsAUgQUkT6w87J5mFfhbEXpT5qVe0p1hWImgvQMKTif5bNxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682083; c=relaxed/simple;
	bh=WraQrAhKy40fzLj9OcdqnlOGw8M2B9DE9LsghuQ3E1E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NJdRfi0ud5B/qPbWoTOFnGXeYu6ArW+UyeRtiZ7iXwqA8TG3xG6iywfzZhK5eG+U9l3pJ7O2orBX3y0NqFXSL6mhJKDrBPSAjvhpO9Pnj4R3dcPsOnf+NqLQU9BzDTrmFrvs4YMeymQ3+e8dmJx0Cyjl1HZHmaHzNXeuE+LsFPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MiDj0/rY; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MiDj0/rY"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-747dd44048cso284387b3a.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682081; x=1750286881; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UuyKkic3LG8prk2hzqTBzKdxaSLkUa8zFIKnG1Vnzms=;
        b=MiDj0/rYEnOUIAu+1+vY77ozkscG+7f1ggxG1BTjCI3TGSjFMU8wFEay4R+aiu6yF5
         mIsQWnM0OxXNfTGF9jJ4IfTADMZ29RPFOcVF5J1aD2wT8rzhCLyIizM8vBDtvK/QrFqD
         EKLpxVlhyrR9bGCS6rESQx2/LL4H7Mrz6CQrUuh5T4lToFjdCYrAIi5enxEWVkVDhDQ2
         TaB4X4ARpbUuKiSJCu5p7M24OGQlQ69tCd6ofzKT2LtXgcmkRJ0t9IqRkHCjH56kJDWr
         u1CUh1P+9UyhQVarf80SLLlwxrqGkS6lxBSFAc1SKfawKZDnNpVGE3qItRP6UADVIo4R
         AiEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682081; x=1750286881;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UuyKkic3LG8prk2hzqTBzKdxaSLkUa8zFIKnG1Vnzms=;
        b=rwVrn3yME+D4cEKnmtqjMFV19MDVBgK6clb5uf3WKaUQWl4K4gMp9WuLE0sPIhDcaX
         xFnQZNjC1Rul2A1ekORFGLzH3iVQCl30LiTxT6FMs/PyjWbQMTpwpxiVrj3/HsDPTTcO
         /MDExqa/2GwChEZiNXdmgljBuOHA9yB4ocxehpVsHipdJ4W5jXvaI6u4jUeJnIUFQyNz
         myapmXL6kLR5b993J5vqHSVi3f/l7OvfBbo2W+yCh2lIAqse5H6ZLtVcBR0hQG5LMDYv
         IgdI5gF9T0kjtngTj/sJjTLUHWaAXo+Qryx8/Y7TU0PtBGpe2XREtCUI/mnZj8Dma0Un
         vUsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyB3QrtXsGgYfhF/M+tOTfS2sqJAUqXFzbMSavqTJNqSZFD/YnNgYMDYHESck4pzhCjh84leM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxdF75Tp6NTWIVFG6/310+RBf1wvgbl0rY/0C/O88GbVeNh6SN2
	jrEYRUcDMdphnMEgRv7yjdFJANOfKZ39CSG8fGAXy5WX9ErJKhpwO8gPYDrvl67g979I6HM5m0f
	YU/4jlg==
X-Google-Smtp-Source: AGHT+IH6Bg4QxP54+67PeSK08rS7fAvMkGbt5o6MmB1679Zom5LQy5Ttbbd7/GIAhTEMvGP3EkZo+NqlUao=
X-Received: from pfbhe19.prod.google.com ([2002:a05:6a00:6613:b0:746:19fc:f077])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:b90:b0:1f5:7eb5:72dc
 with SMTP id adf61e73a8af0-21f97752d70mr2227346637.3.1749682081378; Wed, 11
 Jun 2025 15:48:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:41 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-40-seanjc@google.com>
Subject: [PATCH v3 38/62] KVM: SVM: Take and hold ir_list_lock across IRTE
 updates in IOMMU
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

Now that svm_ir_list_add() isn't overloaded with all manner of weird
things, fold it into avic_pi_update_irte(), and more importantly take
ir_list_lock across the irq_set_vcpu_affinity() calls to ensure the info
that's shoved into the IRTE is fresh.  While preemption (and IRQs) is
disabled on the task performing the IRTE update, thanks to irqfds.lock,
that task doesn't hold the vCPU's mutex, i.e. preemption being disabled
is irrelevant.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 55 +++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index f1e9f0dd43e8..4747fb09aca4 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -769,32 +769,6 @@ static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)
 	spin_unlock_irqrestore(&to_svm(vcpu)->ir_list_lock, flags);
 }
 
-static void svm_ir_list_add(struct vcpu_svm *svm,
-			    struct kvm_kernel_irqfd *irqfd,
-			    struct amd_iommu_pi_data *pi)
-{
-	unsigned long flags;
-	u64 entry;
-
-	irqfd->irq_bypass_data = pi->ir_data;
-
-	spin_lock_irqsave(&svm->ir_list_lock, flags);
-
-	/*
-	 * Update the target pCPU for IOMMU doorbells if the vCPU is running.
-	 * If the vCPU is NOT running, i.e. is blocking or scheduled out, KVM
-	 * will update the pCPU info when the vCPU awkened and/or scheduled in.
-	 * See also avic_vcpu_load().
-	 */
-	entry = svm->avic_physical_id_entry;
-	if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
-		amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
-				    true, pi->ir_data);
-
-	list_add(&irqfd->vcpu_list, &svm->ir_list);
-	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
-}
-
 int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			unsigned int host_irq, uint32_t guest_irq,
 			struct kvm_vcpu *vcpu, u32 vector)
@@ -823,8 +797,18 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			.vapic_addr = avic_get_backing_page_address(to_svm(vcpu)),
 			.vector = vector,
 		};
+		struct vcpu_svm *svm = to_svm(vcpu);
+		u64 entry;
 		int ret;
 
+		/*
+		 * Prevent the vCPU from being scheduled out or migrated until
+		 * the IRTE is updated and its metadata has been added to the
+		 * list of IRQs being posted to the vCPU, to ensure the IRTE
+		 * isn't programmed with stale pCPU/IsRunning information.
+		 */
+		guard(spinlock_irqsave)(&svm->ir_list_lock);
+
 		ret = irq_set_vcpu_affinity(host_irq, &pi_data);
 		if (ret)
 			return ret;
@@ -839,14 +823,19 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			return -EIO;
 		}
 
-		/**
-		 * Here, we successfully setting up vcpu affinity in
-		 * IOMMU guest mode. Now, we need to store the posted
-		 * interrupt information in a per-vcpu ir_list so that
-		 * we can reference to them directly when we update vcpu
-		 * scheduling information in IOMMU irte.
+		/*
+		 * Update the target pCPU for IOMMU doorbells if the vCPU is
+		 * running.  If the vCPU is NOT running, i.e. is blocking or
+		 * scheduled out, KVM will update the pCPU info when the vCPU
+		 * is awakened and/or scheduled in.  See also avic_vcpu_load().
 		 */
-		svm_ir_list_add(to_svm(vcpu), irqfd, &pi_data);
+		entry = svm->avic_physical_id_entry;
+		if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
+			amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
+					    true, pi_data.ir_data);
+
+		irqfd->irq_bypass_data = pi_data.ir_data;
+		list_add(&irqfd->vcpu_list, &svm->ir_list);
 		return 0;
 	}
 	return irq_set_vcpu_affinity(host_irq, NULL);
-- 
2.50.0.rc1.591.g9c95f17f64-goog

