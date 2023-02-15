Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFF215AF
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 01:16:38 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-52f2445e802so78335617b3.10
        for <kvmarm@lists.linux.dev>; Tue, 14 Feb 2023 17:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fA0hO878IlXBSB4jC4+MvDA1z8jaFfYMhwWYQLmDel4=;
        b=bbl37QLKdxpOtLvT/k5zY+PC40bb+EIVGf2KQRCmQQcOBqrWCjj8cTHg9P1O53Wse2
         bugHioYaQtfHeLhjbFzDZE9Z4Fa/USJV4eXHrmrbY5/e7BEvJb6m5NimTEqAIoDNLGv8
         RtOK7ixEhdqBb/gNQRm1H7gBYrwBT6XIeMtAkg1qQqDWfkUKBzzu7SCyuYvIyksxF++X
         Nv7ghiPS6n8LZMTLXV3/bKHv/dxdos2e85WQnmo99BXYi+hjKs9IfwCYFDy7uGwwFOBQ
         v7/8wpH3p8RqxOLwBlALPfxSgRTzU9g1o9w1ljpVMqh6W+sHUEAGkNRAw/4vHz2gGRq/
         O75w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fA0hO878IlXBSB4jC4+MvDA1z8jaFfYMhwWYQLmDel4=;
        b=g0rwI2CwLO14AO3+8MRxwmkXlRKFAJp33cMZ9ixpy/slA3LDo/xqkA3HAkeQR8xTaO
         gsuJGBCHmLOQwJE285wlag76x5f9N2AgOJyvRugMAPQW678cE7zcN6DYSCatQu/S+Vnl
         YypfY5NFsPo5p844wxcVguUuWb+ktYdRmIV4IVWvVK8Lo8o31+Ce+2hSrkIOK++X7flW
         4+CYAnGYepPyI4p/OR9+3LdGb6WjzKMMr0OqBkWarHqHiG/pKjxwrT5F8z8N3jAg/2Yo
         03dfKHxXjy4KPG4JuvQBNoe8O4hHXIvad2A/6ZHJ3zazWGU8/FZAfXk4u5GwUvt0vf3o
         gJeQ==
X-Gm-Message-State: AO0yUKVMEPD4yexeIf6sea9Xr076+UpcgRolsiAvDZUPsezi24RuK2kh
	sqYOCSbEtAI1wlgAIR73JQ59+2aD0wbgEw==
X-Google-Smtp-Source: AK7set+HWJ0kZC5aOyt79tOmvB1HvKpMOid+UEBdsClpbT07t1SvqZT3R0AdeIWlivmxNpxwaLmCHdoiMduUIg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:9f90:0:b0:85d:3cec:46d7 with SMTP id
 u16-20020a259f90000000b0085d3cec46d7mr48855ybq.283.1676423798015; Tue, 14 Feb
 2023 17:16:38 -0800 (PST)
Date: Wed, 15 Feb 2023 01:16:13 +0000
In-Reply-To: <20230215011614.725983-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215011614.725983-8-amoorthy@google.com>
Subject: [PATCH 7/8] kvm/arm64: Implement KVM_CAP_MEM_FAULT_NOWAIT for arm64
From: Anish Moorthy <amoorthy@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>, Anish Moorthy <amoorthy@google.com>, 
	Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Just do atomic gfn_to_pfn_memslot when the cap is enabled. Since we
don't have to deal with async page faults, the implementation is even
simpler than on x86

Signed-off-by: Anish Moorthy <amoorthy@google.com>
Acked-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/kvm/arm.c |  1 +
 arch/arm64/kvm/mmu.c | 14 ++++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 698787ed87e92..31bec7866c346 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -220,6 +220,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
+	case KVM_CAP_MEM_FAULT_NOWAIT:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 01352f5838a00..964af7cd5f1c8 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1206,6 +1206,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	unsigned long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
+	bool mem_fault_nowait;
 
 	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
 	write_fault = kvm_is_write_fault(vcpu);
@@ -1301,8 +1302,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	smp_rmb();
 
-	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-				   write_fault, &writable, NULL);
+	mem_fault_nowait = memory_faults_enabled(vcpu->kvm);
+	pfn = __gfn_to_pfn_memslot(
+		memslot, gfn, mem_fault_nowait, false, NULL,
+		write_fault, &writable, NULL);
+
+	if (mem_fault_nowait && pfn == KVM_PFN_ERR_FAULT) {
+		vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
+		vcpu->run->memory_fault.gpa = gfn << PAGE_SHIFT;
+		vcpu->run->memory_fault.size = vma_pagesize;
+		return -EFAULT;
+	}
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
-- 
2.39.1.581.gbfd45094c4-goog

