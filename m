Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387A6A936
	for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 21:35:32 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id v200-20020a252fd1000000b00b8f548a72bbso862274ybv.9
        for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 14:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681335331; x=1683927331;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oBWUDJru52jdEOiurtVr+EjXu6VveYkIMdfENGYuqF4=;
        b=5Ov5+ZRfva2c/yhjYr6uvNwVs19NXcF+87yc5OV+Twmw1QDkz0RDskvnZST3sAoaOa
         2DLJh3OJcPj62W7lWGXrhBgFBBN2ym5EzdxJy5WNiNWrRhDCQ7O9J4sD3IdsSDHkNkXH
         IlWrqpFtk2bhPyl/fjbcuDlyAw9LBNJtjlC4/XKTUmyPx+21UfU5rIDVX+W5CyqAo7OS
         gCrK6y4+iCGyxDx3qAIagEau4i7Q7ALYo2KpLBHy09J7o1/ugwnLzj5u7JBFxpuMMCcF
         35wLNLvY8wChWZBVKEsf6irGy49x6q/APUlPlzGWacJC0sJ+CAjiGjEWDZ7ty6c3fUT1
         QQRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335331; x=1683927331;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oBWUDJru52jdEOiurtVr+EjXu6VveYkIMdfENGYuqF4=;
        b=UY4hP4I+wa5/pdSLngnmA+19y2/jJ+0ePqgnA0dsI9RZiMPD2X93I8Sr6Y1MwOTjPY
         ieNkiP4W4g7kjIpwmuSol8z/tfDZ/bmlng8S1hGAzKsmNs+c/FTksaZ/MINL70Q4WvBs
         nixBqSw1LvmxYZhboxS96QgipZRTaSNmz35TaHfnaly1groGVThNO0P+eUzVNxVNTf+D
         ivX6+bo6nKTzwIRmeTpPm6dGce9FvXZ9//112+JRwoTVghn7Pzd9sjV4hNkrZLroPOI3
         S4D+5NFB7Aup04tSNyLJn/0xf/AbDRHRk3Tw3jcJJt6vV0v7DGrdCaQeynp9jU9JqZ4s
         VeXA==
X-Gm-Message-State: AAQBX9cUXrhmc3WWMPCSsY4aG870ymeCoaxHIRA6ScpbOII8gvYA7GOb
	vViYBFDrN3lcBA9Uln7BhT8inRzbZOXDhA==
X-Google-Smtp-Source: AKy350Z1Hz16awnvahWD8mb/lMbNByADtMsMOxZyj1zA+7AE5/pqJYBUSB/Hd6Gwg+5ip516oAEqf4bZn9oW7Q==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:ae1d:0:b0:54f:84c0:93ff with SMTP id
 m29-20020a81ae1d000000b0054f84c093ffmr3294464ywh.5.1681335331269; Wed, 12 Apr
 2023 14:35:31 -0700 (PDT)
Date: Wed, 12 Apr 2023 21:35:06 +0000
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412213510.1220557-19-amoorthy@google.com>
Subject: [PATCH v3 18/22] KVM: x86: Implement KVM_CAP_ABSENT_MAPPING_FAULT
From: Anish Moorthy <amoorthy@google.com>
To: pbonzini@redhat.com, maz@kernel.org
Cc: oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com, 
	amoorthy@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

When the memslot flag is enabled, fail guest memory accesses for which
fast-gup fails (ie, for which the mappings are not present).

Suggested-by: James Houghton <jthoughton@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst |  2 +-
 arch/x86/kvm/mmu/mmu.c         | 17 ++++++++++++-----
 arch/x86/kvm/x86.c             |  1 +
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7967b9909e28b..452bbca800b15 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7712,7 +7712,7 @@ reported to the maintainers.
 7.35 KVM_CAP_ABSENT_MAPPING_FAULT
 ---------------------------------
 
-:Architectures: None
+:Architectures: x86
 :Returns: -EINVAL.
 
 The presence of this capability indicates that userspace may pass the
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d83a3e1e3eff9..4aef79b97c985 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4218,7 +4218,9 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true, NULL);
 }
 
-static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu,
+				struct kvm_page_fault *fault,
+				bool fault_on_absent_mapping)
 {
 	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
@@ -4251,9 +4253,12 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	}
 
 	async = false;
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
-					  fault->write, &fault->map_writable,
-					  &fault->hva);
+
+	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn,
+						fault_on_absent_mapping, false,
+						fault_on_absent_mapping ? NULL : &async,
+						fault->write, &fault->map_writable, &fault->hva);
+
 	if (!async)
 		return RET_PF_CONTINUE; /* *pfn has correct page already */
 
@@ -4287,7 +4292,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	smp_rmb();
 
-	ret = __kvm_faultin_pfn(vcpu, fault);
+	ret = __kvm_faultin_pfn(vcpu, fault,
+				likely(fault->slot)
+					&& kvm_slot_fault_on_absent_mapping(fault->slot));
 	if (ret != RET_PF_CONTINUE)
 		return ret;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3e9deab31e1c8..bc465cde7acf6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4433,6 +4433,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 	case KVM_CAP_MEMORY_FAULT_INFO:
+	case KVM_CAP_ABSENT_MAPPING_FAULT:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
-- 
2.40.0.577.gac1e443424-goog

