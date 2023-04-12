Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C911A93A
	for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 21:35:34 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-54f97aac3d0so30076787b3.15
        for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 14:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681335333; x=1683927333;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g4meCJ11bu24h/cx6LqrB3qAGYM0pv712osrkf0fzPk=;
        b=ksc3Uo2kb7fia25zCArzbWloYH/nh04oxzOH/JXw50ehdelb83OV7185J0dcX5CTUl
         SGpdnP8yVtEWCbN+YKQ1yw8N8CQUKFw5GeaZzxeaIm8mtKU8dAgwpAVgKJavw0O/BKRr
         aANPAgurlfqKrwO6NGZX4gGPSuyn7eKZfTRk38L/4yupoynBZqCFaqDAjRlkDb1iUMh5
         pC0nfYaS0kiBXS6IZr2a1LpJBUYMVii2A3gBADS7dpYAr1eW2Ktxxidq4/+TMOHkiSL7
         o8XlEyDWSf+taexDIlKlaYBbFOU+RE/VhORCsyo31dF0tN3prUOBff0E7D5keRnnyYrE
         Mj+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335333; x=1683927333;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g4meCJ11bu24h/cx6LqrB3qAGYM0pv712osrkf0fzPk=;
        b=ZiQvRnVYtmsUifPYAAjkvHVtFRFKs+3U/3VSkufAgl199ctrnGJll5bNGvJpa+AJmC
         INhG+xvvT87TFOcXwg7ReVAl5GLlNkUCb5oB7o3ZCXbc4Fq3y9vVKqGxv2Os0uSs0AyK
         VcBfND072RQ6bip6f0Ux4QxeSiRZKbO7HplZHa43Rt3U6CwwYqK90IISIjGX1CTqhT76
         JQ7uOOAcoI05u6gPBNRKV+DW8QoGLD6ngBXw8LcNHpc3eiJY59Lh4lrZSGk3JgoahCNU
         lHeK/DimyL5fFVlN6OIRLxQxXmTtxskmXDfv62JdydmEB04hENQre4sh3tsPVz/Zst2+
         PXfQ==
X-Gm-Message-State: AAQBX9dEVBm25sOXU58cHHqg+HT4FEyx/w/FaJPnPculS5Eu+/hEXpYB
	DoHoqetpEAQmFDtuylTNAfTvbJE7zDx0dw==
X-Google-Smtp-Source: AKy350ZG6iLC4X3Y7S8xfkDc/hZ3/74579TfJlfN5A+jNG8WvNeg+IGrAA5URu61LfHolsG/pk2OemadO/dyGw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:c94d:0:b0:54b:fd28:c5ff with SMTP id
 c13-20020a81c94d000000b0054bfd28c5ffmr2814728ywl.3.1681335333086; Wed, 12 Apr
 2023 14:35:33 -0700 (PDT)
Date: Wed, 12 Apr 2023 21:35:08 +0000
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412213510.1220557-21-amoorthy@google.com>
Subject: [PATCH v3 20/22] KVM: arm64: Implement KVM_CAP_ABSENT_MAPPING_FAULT
From: Anish Moorthy <amoorthy@google.com>
To: pbonzini@redhat.com, maz@kernel.org
Cc: oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com, 
	amoorthy@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Return -EFAULT from user_mem_abort when the memslot flag is enabled and
fast GUP fails to find a present mapping for the page.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst |  2 +-
 arch/arm64/kvm/arm.c           |  1 +
 arch/arm64/kvm/mmu.c           | 11 +++++++++--
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 452bbca800b15..47f728701aca4 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7712,7 +7712,7 @@ reported to the maintainers.
 7.35 KVM_CAP_ABSENT_MAPPING_FAULT
 ---------------------------------
 
-:Architectures: x86
+:Architectures: x86, arm64
 :Returns: -EINVAL.
 
 The presence of this capability indicates that userspace may pass the
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a932346b59f61..c9666d7c6c4ff 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -221,6 +221,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_PTP_KVM:
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 	case KVM_CAP_MEMORY_FAULT_INFO:
+	case KVM_CAP_ABSENT_MAPPING_FAULT:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d5ae636c26d62..26b9485557056 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1206,6 +1206,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	unsigned long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
+	bool exit_on_memory_fault = kvm_slot_fault_on_absent_mapping(memslot);
 
 	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
 	write_fault = kvm_is_write_fault(vcpu);
@@ -1301,8 +1302,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	smp_rmb();
 
-	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-				   write_fault, &writable, NULL);
+	pfn = __gfn_to_pfn_memslot(memslot, gfn, exit_on_memory_fault, false, NULL,
+					write_fault, &writable, NULL);
+
+	if (exit_on_memory_fault && pfn == KVM_PFN_ERR_FAULT) {
+		kvm_populate_efault_info(vcpu,
+				round_down(gfn * PAGE_SIZE, vma_pagesize), vma_pagesize);
+		return -EFAULT;
+	}
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
-- 
2.40.0.577.gac1e443424-goog

