Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBB52C0307
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682081; cv=none; b=d3IyeB50yyyjp1utNmt1tKv/VYuyAzHsKkbVJGI2fH+GId+O0VyIcLyPbtm1rQ0UwIVf8O8Lr4uYfsye596d6Q13NDjG6T5vyET3cQxUiDMnF2jRlKU90KdKR1qUZ7F0w9Gj02ilk0pDAmqky04XxL6DnvGzwBUedCM3GeEhqMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682081; c=relaxed/simple;
	bh=RgmzZvbjCfA1K5gasv3IPOtqiGQBqzN7YP3Tbk95zwo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oLdV50YT+Kb2U+yQnVXNzOnKQ/TzwQ/muYj98a8t8aPRVPoh1BfT8BBaxdEsFld+tW7nLG6p10d4iZx3BlH/9xrtEuZu1rpURIH05M2Sn3sus8KMmvXED5ftOkZWRiUeSBNVP1t3KeVQJv2Q2GQeS62f7zzEthg9ymA3tNNvqnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lNE1HBwE; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lNE1HBwE"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747d143117eso252782b3a.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682079; x=1750286879; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=v1flKB2rjVjkv7C0HFQg1l92d+sykuVaruHJBCaF8LA=;
        b=lNE1HBwEDzGigM3kj+U1zqa7AxHiUaJRhBDMSODB811Cy/IfRACzKDkDdHcByngPcT
         xeeqXBN744D5fHVIej4yH9/OBbNTn5fVROSpJmkd9LTAinIxxjBgO94JkXi3IFybc7V4
         tn+os+HMFlR7IeQOs9YjmiH4nJudHc/xnA+d/O004Ay51qW8mPStn/n4wic5IEdSv0Ik
         /6MzFlGE3JF+XZe91k+Y7USWRxBJZ/9YWGPTT3euWPcNNCErNG++4/NBYsFnnf+e/pUm
         gjhfz3jD6nRKleOfAVdwSmj8MUYvy0+TJfp87JbteVtk7akFufqgiU5y81wWyVX4LlRs
         od7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682079; x=1750286879;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v1flKB2rjVjkv7C0HFQg1l92d+sykuVaruHJBCaF8LA=;
        b=Xen9bDDE4SD7X0/5l/jwQBUjbth+wsqdsBnb21Gggu/TnETtG2rcxBzKlU08CQwkYu
         PRKC7xR6xkGURhYorDY1VcK/3YOA0wg7leP1PgFoKeGBV85NlhaoWdf4dHhNYk/Eyo2N
         UAsenv90lSw9pkRYorRTGDuqXZWTbwKgV5QssopjvyQRyl/Rbs3rvBY3K3DY54tjJCyW
         R9bTK/O3oQcSgvn+kuVKMLzDJtRin/WhyRGm1nWy7EM4yHQ0kjxeqZ/XBLRYZY7oBdbf
         7eyc0snEunDkSnVj+Qpj9hVZo6/1WqLRXDu23l7zSRhTytg3HZW22CU0yGPCaTyLTN7K
         MDxg==
X-Forwarded-Encrypted: i=1; AJvYcCVsCmbcD8o/oVRzTw64IUosdbQ+vw3QzrnKV9UICz/77gXY9DNOhy4JVfgU2rdRLx9GwEEUvqg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwxK443SSwed2QW+OtS8d5Rs1bnd1X99b1mrdHSqZCKtwHI6a7Q
	4ucSo0coW1Ji8dIUNlZQp4lrU6Xgnpc/2aIXkHAaJKTVt+rXQMirJF8gFeNCB1jLRy5CESr263u
	RCgRKiw==
X-Google-Smtp-Source: AGHT+IHuGa3sQaIRlgIMVwUeJGMvQqMviqpQnF96PVE++cQNjn6g/w0sfScCYFw1komkaHU5/0t+EZgb2Qc=
X-Received: from pflc8.prod.google.com ([2002:a05:6a00:ac8:b0:746:1e60:660e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:14c3:b0:742:ae7e:7da8
 with SMTP id d2e1a72fcca58-7487e0f4792mr1105962b3a.8.1749682079546; Wed, 11
 Jun 2025 15:47:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:40 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-39-seanjc@google.com>
Subject: [PATCH v3 37/62] KVM: SVM: Revert IRTE to legacy mode if IOMMU
 doesn't provide IR metadata
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

Revert the IRTE back to remapping mode if the AMD IOMMU driver mucks up
and doesn't provide the necessary metadata.  Returning an error up the
stack without actually handling the error is useless and confusing.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 97b747e82012..f1e9f0dd43e8 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -769,16 +769,13 @@ static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)
 	spin_unlock_irqrestore(&to_svm(vcpu)->ir_list_lock, flags);
 }
 
-static int svm_ir_list_add(struct vcpu_svm *svm,
-			   struct kvm_kernel_irqfd *irqfd,
-			   struct amd_iommu_pi_data *pi)
+static void svm_ir_list_add(struct vcpu_svm *svm,
+			    struct kvm_kernel_irqfd *irqfd,
+			    struct amd_iommu_pi_data *pi)
 {
 	unsigned long flags;
 	u64 entry;
 
-	if (WARN_ON_ONCE(!pi->ir_data))
-		return -EINVAL;
-
 	irqfd->irq_bypass_data = pi->ir_data;
 
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
@@ -796,7 +793,6 @@ static int svm_ir_list_add(struct vcpu_svm *svm,
 
 	list_add(&irqfd->vcpu_list, &svm->ir_list);
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
-	return 0;
 }
 
 int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
@@ -833,6 +829,16 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		if (ret)
 			return ret;
 
+		/*
+		 * Revert to legacy mode if the IOMMU didn't provide metadata
+		 * for the IRTE, which KVM needs to keep the IRTE up-to-date,
+		 * e.g. if the vCPU is migrated or AVIC is disabled.
+		 */
+		if (WARN_ON_ONCE(!pi_data.ir_data)) {
+			irq_set_vcpu_affinity(host_irq, NULL);
+			return -EIO;
+		}
+
 		/**
 		 * Here, we successfully setting up vcpu affinity in
 		 * IOMMU guest mode. Now, we need to store the posted
@@ -840,7 +846,8 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		 * we can reference to them directly when we update vcpu
 		 * scheduling information in IOMMU irte.
 		 */
-		return svm_ir_list_add(to_svm(vcpu), irqfd, &pi_data);
+		svm_ir_list_add(to_svm(vcpu), irqfd, &pi_data);
+		return 0;
 	}
 	return irq_set_vcpu_affinity(host_irq, NULL);
 }
-- 
2.50.0.rc1.591.g9c95f17f64-goog

