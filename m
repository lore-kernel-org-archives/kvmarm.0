Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA58B2ECE91
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682113; cv=none; b=bL0VET1C7O/ue/I2Xi+vpSxOY0NGoLe4WApHb3sNANu25kpRy/cG/RZz0P+2b3a73H+0CC31YwePIQt6dgPm3j3H8ZaecJO6IgFCXcyBYzWOZ6g/O/iTW65HNFrCSIujOn/F2op6e48sjtcR5v9I3Nqf6BYSwi1RnvCVnpi2XPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682113; c=relaxed/simple;
	bh=dcr7IDmLmDNAS6afO+nTfTeJg/AHFl9bk+QccyO3URA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b/upVszT2VROeexc6l7b9oxLLkaWgIz8ZLdLHyI2oxi2krK3fXWkZR03AQc83tKVrtGuAFMzwnF8HwThwk1CDKScNCsvEPfk7+Wyn2Ih92kITLv7dY+B6I9vjKXIzhk9XNlxvtSigEFH1GVdfp4XGQATvyctyNlTfNcsMtVTEZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VC7cPXTc; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VC7cPXTc"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b26e6b84a31so127231a12.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682111; x=1750286911; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=y0ognzEJ7YTCwR3VXid30BiQbWyTOWaypqhwvcHXf3s=;
        b=VC7cPXTcB18KsLnDp5T55viG/oZEaJVsbllo4sCI/ol7iFy7IqHdRfpfv15h7psauQ
         GeB2j32kuKE9zYM53/43uaVTgNFOFAbeki2+4vVq70pUu+71bxmJcJuFd1X6J+67Xsd+
         JqTePFgdkRo65Xr3d4aHXDYwHwvc4VPsxZRLC0gzxo1Z/7TwBTBvFYE2hvOFpD+YepqK
         INn5Mgn7OGGrC/nb5eniFrUvJZv3pbZHctvAcwX+rk/Gbu8nUYLXbVO/lkYBZ1gN7agH
         PCM8l6AGcLL/Fc7WzUOIG/s0FgWgDPH2azPawS/M682op9UUj6eL3NwMjfXIcoM2orku
         av0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682111; x=1750286911;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y0ognzEJ7YTCwR3VXid30BiQbWyTOWaypqhwvcHXf3s=;
        b=Nk1thFEcpi+w2wZIlGtWB3aVy7OzHmQXIw+ra9g778HBmlCKxRNl0nRsZktFZ10DXP
         gA3s/XATIpA2lQEx1r1R1leRFRXggwtjdeaPUNXqmdYAaPJFWPVVyVgKfqOz+teP+cTb
         r3fwnnSJQnAZerPpyxtKTBIOFk72eU+i6K5ftAWYGgYcu2ZftqWHPTkErc0ru4HzvlD8
         9DK6KEtqFIGTn+DsIyyosncIGAPbaOm/Sc7dQjVwab6dowKdCNeTEyy1SXiDUhX2jJ/P
         /abfxqY7EbAbADSfv/+6zxss6pbCPlGlPHB7zolY3NYuTlO9bR8WbiQoaRFWgGLVBZHX
         xoGg==
X-Forwarded-Encrypted: i=1; AJvYcCUXGipFPdn6bnTFvl0PYUwcqVTbhVnc9CatRL5Qq9t0k4SCELmT3b58EMyztVPNSEb9NcCUgmk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxwgBArJzb4qOQRea5tRZ7vIjfyY6D0p8DuewX79fl5rP3dYBh9
	LioKrW8e10PHAkVYs4vuhVnbQAaG8vYKz5fomjDS09etFp7bYfAvbIE77QtbvZRMwRk8FWvPPTF
	OoWmEmw==
X-Google-Smtp-Source: AGHT+IFRdWwIjfXgF8mELaKVUoF9lDiiV8HL8783fqwQWOtpE70D1R2T9PRTPjRcVSy+irY7wjgYviQPM7o=
X-Received: from pjbsk13.prod.google.com ([2002:a17:90b:2dcd:b0:312:187d:382d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dcc:b0:311:f30b:c21
 with SMTP id 98e67ed59e1d1-313c08c831amr917024a91.26.1749682111071; Wed, 11
 Jun 2025 15:48:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:58 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-57-seanjc@google.com>
Subject: [PATCH v3 55/62] KVM: SVM: Use vcpu_idx, not vcpu_id, for GA log tag/metadata
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

Use a vCPU's index, not its ID, for the GA log tag/metadata that's used to
find and kick vCPUs when a device posted interrupt serves as a wake event.
Lookups on a vCPU index are O(fast) (not sure what xa_load() actually
provides), whereas a vCPU ID lookup is O(n) if a vCPU's ID doesn't match
its index.

Unlike the Physical APIC Table, which is accessed by hardware when
virtualizing IPIs, hardware doesn't consume the GA tag, i.e. KVM _must_
use APIC IDs to fill the Physical APIC Table, but KVM has free rein over
the format/meaning of the GA tag.

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index c55cbb0610b4..bb74705d6cfd 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -29,36 +29,39 @@
 #include "svm.h"
 
 /*
- * Encode the arbitrary VM ID and the vCPU's default APIC ID, i.e the vCPU ID,
- * into the GATag so that KVM can retrieve the correct vCPU from a GALog entry
- * if an interrupt can't be delivered, e.g. because the vCPU isn't running.
+ * Encode the arbitrary VM ID and the vCPU's _index_ into the GATag so that
+ * KVM can retrieve the correct vCPU from a GALog entry if an interrupt can't
+ * be delivered, e.g. because the vCPU isn't running.  Use the vCPU's index
+ * instead of its ID (a.k.a. its default APIC ID), as KVM is guaranteed a fast
+ * lookup on the index, where as vCPUs whose index doesn't match their ID need
+ * to walk the entire xarray of vCPUs in the worst case scenario.
  *
- * For the vCPU ID, use however many bits are currently allowed for the max
+ * For the vCPU index, use however many bits are currently allowed for the max
  * guest physical APIC ID (limited by the size of the physical ID table), and
  * use whatever bits remain to assign arbitrary AVIC IDs to VMs.  Note, the
  * size of the GATag is defined by hardware (32 bits), but is an opaque value
  * as far as hardware is concerned.
  */
-#define AVIC_VCPU_ID_MASK		AVIC_PHYSICAL_MAX_INDEX_MASK
+#define AVIC_VCPU_IDX_MASK		AVIC_PHYSICAL_MAX_INDEX_MASK
 
 #define AVIC_VM_ID_SHIFT		HWEIGHT32(AVIC_PHYSICAL_MAX_INDEX_MASK)
 #define AVIC_VM_ID_MASK			(GENMASK(31, AVIC_VM_ID_SHIFT) >> AVIC_VM_ID_SHIFT)
 
 #define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VM_ID_SHIFT) & AVIC_VM_ID_MASK)
-#define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
+#define AVIC_GATAG_TO_VCPUIDX(x)	(x & AVIC_VCPU_IDX_MASK)
 
-#define __AVIC_GATAG(vm_id, vcpu_id)	((((vm_id) & AVIC_VM_ID_MASK) << AVIC_VM_ID_SHIFT) | \
-					 ((vcpu_id) & AVIC_VCPU_ID_MASK))
-#define AVIC_GATAG(vm_id, vcpu_id)					\
+#define __AVIC_GATAG(vm_id, vcpu_idx)	((((vm_id) & AVIC_VM_ID_MASK) << AVIC_VM_ID_SHIFT) | \
+					 ((vcpu_idx) & AVIC_VCPU_IDX_MASK))
+#define AVIC_GATAG(vm_id, vcpu_idx)					\
 ({									\
-	u32 ga_tag = __AVIC_GATAG(vm_id, vcpu_id);			\
+	u32 ga_tag = __AVIC_GATAG(vm_id, vcpu_idx);			\
 									\
-	WARN_ON_ONCE(AVIC_GATAG_TO_VCPUID(ga_tag) != (vcpu_id));	\
+	WARN_ON_ONCE(AVIC_GATAG_TO_VCPUIDX(ga_tag) != (vcpu_idx));	\
 	WARN_ON_ONCE(AVIC_GATAG_TO_VMID(ga_tag) != (vm_id));		\
 	ga_tag;								\
 })
 
-static_assert(__AVIC_GATAG(AVIC_VM_ID_MASK, AVIC_VCPU_ID_MASK) == -1u);
+static_assert(__AVIC_GATAG(AVIC_VM_ID_MASK, AVIC_VCPU_IDX_MASK) == -1u);
 
 static bool force_avic;
 module_param_unsafe(force_avic, bool, 0444);
@@ -139,16 +142,16 @@ int avic_ga_log_notifier(u32 ga_tag)
 	struct kvm_svm *kvm_svm;
 	struct kvm_vcpu *vcpu = NULL;
 	u32 vm_id = AVIC_GATAG_TO_VMID(ga_tag);
-	u32 vcpu_id = AVIC_GATAG_TO_VCPUID(ga_tag);
+	u32 vcpu_idx = AVIC_GATAG_TO_VCPUIDX(ga_tag);
 
-	pr_debug("SVM: %s: vm_id=%#x, vcpu_id=%#x\n", __func__, vm_id, vcpu_id);
-	trace_kvm_avic_ga_log(vm_id, vcpu_id);
+	pr_debug("SVM: %s: vm_id=%#x, vcpu_idx=%#x\n", __func__, vm_id, vcpu_idx);
+	trace_kvm_avic_ga_log(vm_id, vcpu_idx);
 
 	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
 	hash_for_each_possible(svm_vm_data_hash, kvm_svm, hnode, vm_id) {
 		if (kvm_svm->avic_vm_id != vm_id)
 			continue;
-		vcpu = kvm_get_vcpu_by_id(&kvm_svm->kvm, vcpu_id);
+		vcpu = kvm_get_vcpu(&kvm_svm->kvm, vcpu_idx);
 		break;
 	}
 	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
@@ -785,7 +788,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		 */
 		struct amd_iommu_pi_data pi_data = {
 			.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
-					     vcpu->vcpu_id),
+					     vcpu->vcpu_idx),
 			.is_guest_mode = kvm_vcpu_apicv_active(vcpu),
 			.vapic_addr = avic_get_backing_page_address(to_svm(vcpu)),
 			.vector = vector,
-- 
2.50.0.rc1.591.g9c95f17f64-goog

