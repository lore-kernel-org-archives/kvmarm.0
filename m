Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0E32E0B57
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682069; cv=none; b=ibfhdqNwlMgsIDWgvZr7PaccTkQsczr51hCSRwofN39iEM/GgmkKKKXKH3v2ndEpqpX46jhMJpTcRAnPqnt/bapa8vZ0bPUrp/N55RnS4T0UOD5m+F6Ta3y9bgN2TQs0Yj7mOWokogqhoB0fNk40/U9sp8AwbojUVWgsoYb0tK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682069; c=relaxed/simple;
	bh=qt8zb5uI4+X1TebyXBfKCY7Oiv/Cu3N97xLB9PqUJ80=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VG6RbtGvt3w09hoBomQjbqTnBriU+f5lpGbZVO2yPhG5Q0D3SwS3BWWbORqo3GvogPKYkPLQX9QY1DH8LGi6H0iyshSRJk5k5fQcELWZcYFZ8B2NZKsu9a2Pc1nCz760i2TQseoyoVRmoLiHrLDSXLmZcFWly5UVKsYo6Ps4RYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fwrDbLAO; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fwrDbLAO"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2eea1c2e97so154591a12.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682067; x=1750286867; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+DtVGJXTI5NZcLSNxUulZl3FS9wdQHA/Njni8dB9YZ8=;
        b=fwrDbLAOCVCp7ilNInFAIqmJ1G8B5lcfwO0GnH2tcpAyrJNj4NwIttWdGZC317Xbc0
         aezawjiEPAlkotrp25VDU43zO0uUInz/GHixRloCqtEWgOUciS3SWjtvb/RIfYEV/zFw
         hdZ25zWMB9JNlPeyoan7FAKbhrrjHwkVBCWX0tFIn2DYCZxXQdw4NPwr3hN627b2q2S+
         3aNh/x/Etc4LdsEUOhDybmKBAhUWvnKzDCAQUbaS9RbUo5QtVCfu91ggxDBiIUf1yB7h
         E2EswbxVVjQ0Od41nhSmVxPD8xS1cWGjAq9f4CuGuftUx+gTKd1ZcNCutpLxx+QUeKfx
         oCcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682067; x=1750286867;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+DtVGJXTI5NZcLSNxUulZl3FS9wdQHA/Njni8dB9YZ8=;
        b=RcQfiZ02/Dk3UlTZ8HcXQZxavprvg8Pds6Oz2up9hoXdgtXODFVRLwK7l1o1l4+NXz
         QbdgrlvtqCmTy03aZhqliPYs1ktXSnYK8UO9+TrTpgtrOZ+7Y0HYktvwC6j24uKc0ObF
         8cYgF6xYzMwvnGlK38NAMlwxO5P437sS9r72Cg//DBqfhPJ22UrIV46YJD7M6KiXa93S
         WmaOWGbchclQh0Ta+10gWiN99IyEitoAL0ONt0XzMC4EU48ana116GsZ1O2imSb8M8Zh
         rut1FmpwswsT2PN2xZfgT55hz+fSgl4DfDBuIhHC4eFCxjqkngMOvRGNQEzuqWFk4UAB
         LhXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAkoKrytGwEFL3bWqzPw48Q3keFXUw64VNrrT1yAJOmiLsOZ1KgAqv7sSCVNacbSX0S78rtVs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2OpAg2r0o4RHCaVtmc30cgluvSNzlnqH5e++k0/KQShhnXTrr
	LrZydEFJ/0LqDx++PL32O2B4zBc2zOYoyFGkqozE6yniQc9fWPtA/tgPB6HhKw4wkXei6XrdC6l
	YhWQ1yw==
X-Google-Smtp-Source: AGHT+IFyGDdeorUwj3sAfzICdRUEdg2fKYugNVe8KlRyB4tgk6PAyMC59w8WcXLbD69NI4qphVBoJu3KIY4=
X-Received: from pflc8.prod.google.com ([2002:a05:6a00:ac8:b0:746:1e60:660e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2589:b0:21f:53a9:b72c
 with SMTP id adf61e73a8af0-21f86754dbemr7156966637.38.1749682067486; Wed, 11
 Jun 2025 15:47:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:33 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-32-seanjc@google.com>
Subject: [PATCH v3 30/62] KVM: SVM: Clean up return handling in avic_pi_update_irte()
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

Clean up the return paths for avic_pi_update_irte() now that the
refactoring dust has settled.

Opportunistically drop the pr_err() on IRTE update failures.  Logging that
a failure occurred without _any_ context is quite useless.

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index d8d50b8f14bb..a0f3cdd2ea3f 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -807,8 +807,6 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			unsigned int host_irq, uint32_t guest_irq,
 			struct kvm_vcpu *vcpu, u32 vector)
 {
-	int ret = 0;
-
 	/*
 	 * If the IRQ was affined to a different vCPU, remove the IRTE metadata
 	 * from the *previous* vCPU's list.
@@ -838,8 +836,11 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			.is_guest_mode = true,
 			.vcpu_data = &vcpu_info,
 		};
+		int ret;
 
 		ret = irq_set_vcpu_affinity(host_irq, &pi);
+		if (ret)
+			return ret;
 
 		/**
 		 * Here, we successfully setting up vcpu affinity in
@@ -848,20 +849,9 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		 * we can reference to them directly when we update vcpu
 		 * scheduling information in IOMMU irte.
 		 */
-		if (!ret)
-			ret = svm_ir_list_add(to_svm(vcpu), irqfd, &pi);
-	} else {
-		ret = irq_set_vcpu_affinity(host_irq, NULL);
+		return svm_ir_list_add(to_svm(vcpu), irqfd, &pi);
 	}
-
-	if (ret < 0) {
-		pr_err("%s: failed to update PI IRTE\n", __func__);
-		goto out;
-	}
-
-	ret = 0;
-out:
-	return ret;
+	return irq_set_vcpu_affinity(host_irq, NULL);
 }
 
 static inline int
-- 
2.50.0.rc1.591.g9c95f17f64-goog

