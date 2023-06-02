Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296351C750
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 16:20:02 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-ba8337ade1cso3117343276.2
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 09:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722802; x=1688314802;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jB6mZ6+sZkvbswM4H6nQ7omw8CujCnjIDUHOjQN9Lak=;
        b=WzG81VZ+IOZZWpA5d8GyyFB+GNO5rd59XBOMZDWSQkbTFSpgSDMeCniff6+7OHEij5
         6hoTs84id29QOXjOw8EHoZcr4T/0ZYFYEFe944xT/JJ+tF9azU/Cuirs/Pg7/Q2L7Xpt
         Hq8OKt/J6F5RePSKWMF5TvjkErofFJ4JT6hlxyRWSfFhkQLu+zptKjem6S1xudWoMoSO
         G7hp297qXl4sRDf1NkyFEEZysCmJrGxmUW4a79PFknUySCy8Dm2g/bW4ST5IKz9IXg/M
         jBH17KffIsGU6XV+UNRoQBPgrqaSlxHp1aoOr9WN04DdPMDQTnEZoiXXPrCCrrMOMWbA
         mYgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722802; x=1688314802;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jB6mZ6+sZkvbswM4H6nQ7omw8CujCnjIDUHOjQN9Lak=;
        b=ZIkzufGNdhQ0BN7KJZocfMrWJ1MuaGfRrqVUDAJ7axvkFH5O+Bou8IZ45kBtANHujZ
         kg4HpafFQQxxg0PoXDlXLvLeG8bSvfliLN9wwxpTBXROs/qLkSF1MzGVGqzP1iwJ1DbT
         QjY+fZX7VpPzqcyX6iEfQotw0xTd0UPAHhRfhVK/48tYm9gr4UY3Nb1hFHiiFDfzU9Ce
         5QpwwGPTKLm4ZTOicsmARberKgJuVHBYFKNKXWIvPblFCcLSavL9HtEK5J/ENcXXRMj0
         CRUunlnI/EO5nZ+PxWMAxZiH7KsYolg7080UT6+OwMqvdPulvQlxiS/lwJlo+I0kO0Wk
         2maA==
X-Gm-Message-State: AC+VfDxypzXWiejGa7wVzsK+j5hRc6pzV6nBqc4QcZiWc/IEttz4Fx8z
	+ilv1xcV+3x3deoIAOsIWtA2/sYaK2elwA==
X-Google-Smtp-Source: ACHHUZ5CZs2sEm/aP6c7Rto4UGYg7s6RPhTIofLLjydHszjo7abjQfyJ+FalU2Ytv3XZVw4SIwBatK59S9rkfQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:e706:0:b0:bac:5d2c:844b with SMTP id
 e6-20020a25e706000000b00bac5d2c844bmr1317036ybh.8.1685722802127; Fri, 02 Jun
 2023 09:20:02 -0700 (PDT)
Date: Fri,  2 Jun 2023 16:19:16 +0000
In-Reply-To: <20230602161921.208564-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602161921.208564-12-amoorthy@google.com>
Subject: [PATCH v4 11/16] KVM: arm64: Implement KVM_CAP_NOWAIT_ON_FAULT
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, amoorthy@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"

Return -EFAULT from user_mem_abort when the memslot flag is enabled and
fast GUP fails to find a present mapping for the page.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst |  2 +-
 arch/arm64/kvm/arm.c           |  1 +
 arch/arm64/kvm/mmu.c           | 16 +++++++++++++++-
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aa7b4024fd41..8a1205f7c271 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7783,7 +7783,7 @@ bugs and reported to the maintainers so that annotations can be added.
 7.35 KVM_CAP_NOWAIT_ON_FAULT
 ----------------------------
 
-:Architectures: x86
+:Architectures: x86, arm64
 :Returns: -EINVAL.
 
 The presence of this capability indicates that userspace may pass the
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b34cf0cedffa..46a09c4db901 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -235,6 +235,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_COUNTER_OFFSET:
 	case KVM_CAP_MEMORY_FAULT_INFO:
+	case KVM_CAP_NOWAIT_ON_FAULT:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 3b9d4d24c361..5451b712b0ac 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1232,6 +1232,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
+	bool exit_on_memory_fault = kvm_slot_nowait_on_fault(memslot);
+	uint64_t memory_fault_flags;
 
 	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
 	write_fault = kvm_is_write_fault(vcpu);
@@ -1325,8 +1327,20 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
-	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
+	pfn = __gfn_to_pfn_memslot(memslot, gfn, exit_on_memory_fault, false, NULL,
 				   write_fault, &writable, NULL);
+
+	if (exit_on_memory_fault && pfn == KVM_PFN_ERR_FAULT) {
+		memory_fault_flags = 0;
+		if (write_fault)
+			memory_fault_flags |= KVM_MEMORY_FAULT_FLAG_EXEC;
+		if (exec_fault)
+			memory_fault_flags |= KVM_MEMORY_FAULT_FLAG_EXEC;
+		kvm_populate_efault_info(vcpu,
+					 round_down(gfn * PAGE_SIZE, vma_pagesize), vma_pagesize,
+					 memory_fault_flags);
+		return -EFAULT;
+	}
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
-- 
2.41.0.rc0.172.g3f132b7071-goog

