Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com [209.85.222.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49801C765
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 16:20:01 +0000 (UTC)
Received: by mail-qk1-f201.google.com with SMTP id af79cd13be357-75aff1596d3so342888585a.2
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 09:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722800; x=1688314800;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NmNcA4xrgkLcuCGWOYpC0PmEaXmJrDnJmM0yVjAGGFM=;
        b=0IIUK1mWMEG2R6N4d5epNpupo33pLP7t2ryHaqSkREVc7duxUDfOYqbEupeqxyxidc
         A7rZ95wvqt524EgYfMuqPFlV+xw2egXfhPMcz7dGPu1gAkNGZPENuPINAV6DC8a76ANF
         IQxKtqJAI7RbssURcnYAUR07XZZW1kvRP+GXvkk4wrMF49u+xAsb3v4me+WS8QuVbN87
         9UvfaTFppf5lxb3L2CfyH48+R84uevexSATlfBbRU6cOM3MEQsHpeasNIRBiThOu7PnC
         SV0YhLbsVRMUpHiAx6gpKJyQgBnP0fwcgc/StbmQCevxrEVqYp+57ivSKLZj1JG46c4Q
         XmIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722800; x=1688314800;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NmNcA4xrgkLcuCGWOYpC0PmEaXmJrDnJmM0yVjAGGFM=;
        b=d7vJGI4CA2S02/dJCw5Dr3to097ZWvAgEzEBCY6apbQWlUMR4siNQBDrdVaLZCBebo
         Ny3V+uQM96jiaECxv/Ro1sxzAj1hss+zmZG6T0Hvb7mGkNhUjoqOgq670vjMZHdi8Tc+
         5/vqiVE+lUfFXzjP5ix7r9dsCc7XGnksb+7aCAVhQLMuADkE+NYEg3EPMCryG6J4p4Rk
         nxMx3p7OT9V+0ggNq2rvRlVdWWGeN75PXJyIiHDocSXdKpUgVFtkgKfmk4KurRcscPJh
         tt2k/ZrWbjrP8NmQ3GrJrLpM0IIQzCG8lnv4bL62rkjfnmlgslCMH5II6A1tyccot9ux
         vqTw==
X-Gm-Message-State: AC+VfDwkHSnA2x7K6IijWP/Q6Ij6A/dRte306EXKQwdRMFgx8ue2ixgy
	dx4aHR5UUADBsdOBl4YfCs4c7g+6UWpdpw==
X-Google-Smtp-Source: ACHHUZ6bv1kbPvWMJXUXqPMgDp4g1CaZyD97JDkp7fAkdZjAvm6jS8/kc+tAuHTNuKRQ9BOzT/F7nAiehCTHeA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:620a:29cb:b0:75c:a6ff:3462 with SMTP
 id s11-20020a05620a29cb00b0075ca6ff3462mr3860470qkp.4.1685722800556; Fri, 02
 Jun 2023 09:20:00 -0700 (PDT)
Date: Fri,  2 Jun 2023 16:19:15 +0000
In-Reply-To: <20230602161921.208564-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602161921.208564-11-amoorthy@google.com>
Subject: [PATCH v4 10/16] KVM: x86: Implement KVM_CAP_NOWAIT_ON_FAULT
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, amoorthy@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"

When the memslot flag is enabled, fail guest memory accesses for which
fast-gup fails (ie, where resolving the page fault would require putting
the faulting thread to sleep).

Suggested-by: James Houghton <jthoughton@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst |  2 +-
 arch/x86/kvm/mmu/mmu.c         | 17 ++++++++++++-----
 arch/x86/kvm/x86.c             |  1 +
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9daadbe2c7ed..aa7b4024fd41 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7783,7 +7783,7 @@ bugs and reported to the maintainers so that annotations can be added.
 7.35 KVM_CAP_NOWAIT_ON_FAULT
 ----------------------------
 
-:Architectures: None
+:Architectures: x86
 :Returns: -EINVAL.
 
 The presence of this capability indicates that userspace may pass the
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cb71aae9aaec..288008a64e5c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4299,7 +4299,9 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true, NULL);
 }
 
-static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu,
+			     struct kvm_page_fault *fault,
+			     bool nowait)
 {
 	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
@@ -4332,9 +4334,12 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	}
 
 	async = false;
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
-					  fault->write, &fault->map_writable,
-					  &fault->hva);
+
+	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn,
+					  nowait, false,
+					  nowait ? NULL : &async,
+					  fault->write, &fault->map_writable, &fault->hva);
+
 	if (!async)
 		return RET_PF_CONTINUE; /* *pfn has correct page already */
 
@@ -4368,7 +4373,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	smp_rmb();
 
-	ret = __kvm_faultin_pfn(vcpu, fault);
+	ret = __kvm_faultin_pfn(vcpu, fault,
+				likely(fault->slot)
+					&& kvm_slot_nowait_on_fault(fault->slot));
 	if (ret != RET_PF_CONTINUE)
 		return ret;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d15bacb3f634..4fbe9c811cc7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4498,6 +4498,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_MEMORY_FAULT_INFO:
+	case KVM_CAP_NOWAIT_ON_FAULT:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
-- 
2.41.0.rc0.172.g3f132b7071-goog

