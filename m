Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C860C25FA2D
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682033; cv=none; b=tAsaO0jekViPh8vGX+gvNu6yJLY9L3zpAomi+y9pBzdREOCqVLzm02TTcIgHiNvJiOSE68MwyoNqxsxj5B3bfH0e+EJC6UvQY94TDYuThadBtbXEfg4GhMzMK4D99ZCRWpUzbWBRArRg4JVspCDQ/HjniHeglF068y3R51Oexyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682033; c=relaxed/simple;
	bh=7dV5E2YpVOyJ/Kux4msTi4WlqyseKzQyRpwCMdx1kug=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jjvUhoeyr5xpIv/Lt0x91+8WXgy/RyxOsRgCYJHcrVmi3DZtW+Pw2atiktpJjK80OhPf7TLuID+hYl7tbFDWv++Mujp5SMTV+pZjkQE1Pg+eWaL2VMJ04s0ZMGkPmSmv5eeeKEz7UJHXO/usc3ryEbVhROMzvjbMa37sQcHr5CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JUdD3Np8; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JUdD3Np8"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747d84fe5f8so176740b3a.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682030; x=1750286830; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bQMxbahOoMV/Ka2zZMRG3HjDjex4nqWH9a70Z5WrrOc=;
        b=JUdD3Np88xNj9XI2w5NqPbc2SEbmmCx+sAl1SmWYkp6KWx5kHZEx2tBj8s0ZDbi/dd
         ZoFLk4yQZgkk8gGOfxQ3Vd9/VD8jIdqIvYfKCFMHK8ioxrJ2AxKvv+iExK3SlZxIQr1T
         Z8m7CQBKjgkGchwHtmx0wFhoGjW1GCuwDVfZhTUt6HK73OEnCH//riZIcPR7x24FMNyl
         OoPPbbUONMwO0upYxEmmrC5hlt9sf9VO2WT2g1LagbOr9FcekQg+zGM6F+oVA8bN6SMy
         8GhV3gptMSBcGE6nO0l4bLRpo+n1kBgEYUS9YMGUfRHhWfLTSN4PYOmm7aw5yQvmw28C
         MhCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682030; x=1750286830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bQMxbahOoMV/Ka2zZMRG3HjDjex4nqWH9a70Z5WrrOc=;
        b=TklULTy6g94B6IeVae1mDQyyVFxYl5Mkr1knWwb/pTX+SWoN/0vV9XAqlCF1/jcGJu
         DpinZtGN6zX6oqg3kmHWrPpb4J3nuugTwz7cZSqBH7WDZVF99X0HEWJ6Qx0kQ0CkbyGK
         lXWEG0woZ/rCWrUnHWgQ4NRwDP8RmxBJpOSw02zheiUc0PoPB+qB5+oG8Gg0HfbFIWUZ
         yqjhkJHEGIAwbXJ3H2LEc0TTXk/vIEDb1TUHMoIDYb9U+1hrJYdakMMDmKqG6E2PJU4B
         GJ3zpDVUYziwNPfs5pXgw3SKl33DRolPCgj7mzMM42OlZ8JsvYjbiuXC+y/eAVXR4FEs
         fYmA==
X-Forwarded-Encrypted: i=1; AJvYcCWRx/v95F3LC+QjVqVgB1RaxmOOUHX8sfy6OBiX1XZeQReHudb1t/xRXhr4C8Z8J9Bj8vkc3Xc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yww6Kj9sb9bsAy7MORkSzX9GMLaypBp6bhFvZwBr0YjnKWCqDQ/
	Xfc3x6uHySdQtylxPcLtL1VHtVmUGhRIDHLxslEf4yrQDJhz24zfF50YUV8RdvQKoxtin9b5OVY
	kyleL3A==
X-Google-Smtp-Source: AGHT+IHU4UK6dAUOCbwJWWrdH0PtCWdxR/jj188N0b0b6EvIJsVmByJnhGgC9nFYnYfLkqG3Y4MI9nywi44=
X-Received: from pgar4.prod.google.com ([2002:a05:6a02:2e84:b0:b2c:4ef2:ca0e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7d9a:b0:21c:faa4:9ab9
 with SMTP id adf61e73a8af0-21f866f2d2cmr7405522637.22.1749682030084; Wed, 11
 Jun 2025 15:47:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:11 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-10-seanjc@google.com>
Subject: [PATCH v3 08/62] KVM: SVM: Drop pointless masking of default APIC
 base when setting V_APIC_BAR
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

Drop VMCB_AVIC_APIC_BAR_MASK, it's just a regurgitation of the maximum
theoretical 4KiB-aligned physical address, i.e. is not novel in any way,
and its only usage is to mask the default APIC base, which is 4KiB aligned
and (obviously) a legal physical address.

No functional change intended.

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/svm.h | 2 --
 arch/x86/kvm/svm/avic.c    | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ad954a1a6656..89a666952b01 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -260,8 +260,6 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 
 #define AVIC_DOORBELL_PHYSICAL_ID_MASK			GENMASK_ULL(11, 0)
 
-#define VMCB_AVIC_APIC_BAR_MASK				0xFFFFFFFFFF000ULL
-
 #define AVIC_UNACCEL_ACCESS_WRITE_MASK		1
 #define AVIC_UNACCEL_ACCESS_OFFSET_MASK		0xFF0
 #define AVIC_UNACCEL_ACCESS_VECTOR_MASK		0xFFFFFFFF
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index c981ce764b45..5344ae76c590 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -244,7 +244,7 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
 	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
 	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
 	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
-	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
+	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE;
 
 	if (kvm_apicv_activated(svm->vcpu.kvm))
 		avic_activate_vmcb(svm);
-- 
2.50.0.rc1.591.g9c95f17f64-goog

