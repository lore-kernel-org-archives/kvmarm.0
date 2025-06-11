Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0581425D1ED
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682028; cv=none; b=RKYwc9Gy+hujRpIeYb+SimgtG0ZAAhurbTVYEeO9Gpfk/PaXxjfYl5X4SxO6K6KBNYCGb09nVwfbB5dQ4IZ5XsT8W2FmSgDCzbFiqteZWV4INd9NjAT+bhO7hchcJSipCzW5vmqR5cqJhsGj7NxwOZWgkjJZxkg9CQrUevjbkFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682028; c=relaxed/simple;
	bh=uH3944HBJHuIB43VsoJQToz6i7ziH1mBJVH/nneF8+Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dzip4JgkdFEbdN1303iRiSyXZ38So+tmU2QAvAX0AQGirboYB2Wl5XJfiTMwu9D8JWxnZBLYW+//GDHzG07MWs7b+K/e90GUNf6JAQbjKwhhnp77tDJD+K4HkAHH/X55Z1FxI7hqfHRt/7Y++KpnViwanqVbcDkBWkCwZ3E9g+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t367ucqU; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t367ucqU"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-73bfc657aefso224643b3a.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682026; x=1750286826; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ul73Yg1mYpP2TE2GLk0RQV/vMJ7XUY0pYKrpo3kbkOY=;
        b=t367ucqUMAqe/DhnVeLq8IiyprnWxFZUjVBygzBuF+ga0t1FjhceqS1+TEU08BhCsP
         RG7KGzLsWUDFMH3n+t+Mu9EcES7c0RkZc87rR+PfdnQXdYJZps27C+7qTPuWmdFInP/1
         BLoJDeXpybiaKRWaWMx4N4zSLd3YYqC1qS95repkOuz9anb20MB55XOHVmyIOdKItaoP
         y21vUjLTX1a+bHUkAzg+m4fPsRRWt56yDULx5kPvUZZnmFG41q+cBCS/W8sh8Cg42QZJ
         cfPjy/2D6yWZGuNHtslinGHn5oLUHa6jyWUm2S5/E+2cjGPhVnZX9Ar//knm0vJ0oTkW
         CzwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682026; x=1750286826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ul73Yg1mYpP2TE2GLk0RQV/vMJ7XUY0pYKrpo3kbkOY=;
        b=SyO+j/Y6XN+VODGCbaE/9Qo0/fFr2fIVLPZ8eQ97Sdr2HDLSAlBS4dgWcSvn+trSP9
         Pzyj3wqX3kQtFIWLqSqOZRXQHliVo4/doeAO0KhrP30j9zUSD7lKTU2KnF/PUiE7Utou
         QBJF2nG8tus/XG/RLKXpNZqvsAmF7QOqK53VFICJ/kmLEFhynjERFdoHQ+OVlP70jMUx
         /FFjeEE/XYj9AoCCe6uTxVlr4YMmjj+53W/OH9k6SgJnm78ZaecjYAwedrRjb9fPDeX9
         WC4GOjLIpu4f1pzz/tHgFkEovG6Kn5cAk2uvTdniZwisNJ4J852QKqjh3IVvW9Pfv3td
         jjQA==
X-Forwarded-Encrypted: i=1; AJvYcCWOsImo7FrVtFNDbv7Ua+bJxFBGj0f02c4hNkdQgIsHcWf2FDeatUxCAqdrzO/Weo6pNQ/Z8j4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyN0JAySmBx1L147GU4zIqjf31BMa1ItXLqRMXvMx4Ps0oWBldX
	PcFaNxcJq1QL1YwNzaQ2vzR7TCylzfF7N+e5IqIQrx9igv4vJzT5ZRrXC0ZULSi0HqjgfDXVjb7
	p5OoKSQ==
X-Google-Smtp-Source: AGHT+IFnXBC/dw4RfxpNimXIzZIuT6MvY9BKC/MvZnHdhiI65erLZynkQdLm3L4jFFBDrmchy9AfkMLulyY=
X-Received: from pfbay26.prod.google.com ([2002:a05:6a00:301a:b0:746:223d:ebdc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:b4e:b0:742:a0c8:b5cd
 with SMTP id d2e1a72fcca58-7487e2bf8cdmr1044283b3a.19.1749682026328; Wed, 11
 Jun 2025 15:47:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:09 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-8-seanjc@google.com>
Subject: [PATCH v3 06/62] iommu/amd: KVM: SVM: Delete now-unused
 cached/previous GA tag fields
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

Delete the amd_ir_data.prev_ga_tag field now that all usage is
superfluous.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c             |  2 --
 drivers/iommu/amd/amd_iommu_types.h |  1 -
 drivers/iommu/amd/iommu.c           | 10 ----------
 include/linux/amd-iommu.h           |  2 +-
 4 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index ed7374f0bd5a..4e8380d2f017 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -938,9 +938,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		/**
 		 * Here, pi is used to:
 		 * - Tell IOMMU to use legacy mode for this interrupt.
-		 * - Retrieve ga_tag of prior interrupt remapping data.
 		 */
-		pi.prev_ga_tag = 0;
 		pi.is_guest_mode = false;
 		ret = irq_set_vcpu_affinity(host_irq, &pi);
 	}
diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 5089b58e528a..57a96f3e7b84 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -1060,7 +1060,6 @@ struct irq_2_irte {
 };
 
 struct amd_ir_data {
-	u32 cached_ga_tag;
 	struct amd_iommu *iommu;
 	struct irq_2_irte irq_2_irte;
 	struct msi_msg msi_entry;
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index f34209b08b4c..f23635b062f0 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3887,23 +3887,13 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
 	ir_data->cfg = irqd_cfg(data);
 	pi_data->ir_data = ir_data;
 
-	pi_data->prev_ga_tag = ir_data->cached_ga_tag;
 	if (pi_data->is_guest_mode) {
 		ir_data->ga_root_ptr = (pi_data->base >> 12);
 		ir_data->ga_vector = vcpu_pi_info->vector;
 		ir_data->ga_tag = pi_data->ga_tag;
 		ret = amd_iommu_activate_guest_mode(ir_data);
-		if (!ret)
-			ir_data->cached_ga_tag = pi_data->ga_tag;
 	} else {
 		ret = amd_iommu_deactivate_guest_mode(ir_data);
-
-		/*
-		 * This communicates the ga_tag back to the caller
-		 * so that it can do all the necessary clean up.
-		 */
-		if (!ret)
-			ir_data->cached_ga_tag = 0;
 	}
 
 	return ret;
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index 062fbd4c9b77..1f9b13d803c5 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -19,8 +19,8 @@ struct amd_iommu;
  */
 struct amd_iommu_pi_data {
 	u32 ga_tag;
-	u32 prev_ga_tag;
 	u64 base;
+
 	bool is_guest_mode;
 	struct vcpu_data *vcpu_data;
 	void *ir_data;
-- 
2.50.0.rc1.591.g9c95f17f64-goog

