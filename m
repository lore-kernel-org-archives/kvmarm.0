Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E011DC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 31 Mar 2022 21:38:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E3C84B1D4;
	Thu, 31 Mar 2022 17:38:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lIHqIMHmLUI9; Thu, 31 Mar 2022 17:38:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED7FF4291D;
	Thu, 31 Mar 2022 17:38:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C27540BDC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 17:38:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Oc1VNI4kcL2f for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Mar 2022 17:38:52 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A3D94078F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 17:38:52 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 x1-20020a056e020f0100b002c98fce9c13so637517ilj.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 14:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=EBvLSPzxeZwoRgmfMBjBkf8t4T2CICbfEAFJBAeKCK0=;
 b=N1oCH65ejmsf2GfWQpfX392jUH9OvfYS363sYxEwWMmHjXJjiHar2RSx7zoUsw9h1C
 3JQYsfnRK55SWEmEeCFwU5uSoMCc5HhDBo8STMMNf3fF2uNsuVk1Ze/I5oq70ddPB/mv
 KbSsqTWnzMmheLREHqpfPHneXzqE4v0MBJ5BgWyOKCwg7OWLquQ0eHfMM0X18RfTRsqy
 XD9kDTye3NDaPYLMYIkwHM2qtOq33WbTXyCpdxnrBhp7BAfzehYfwmZf8mMW8k8trjCO
 lp0yWS7Xepe9s9f6KRXhfSVs0LHpMDqE7c8L75d4bwR++OQsOqq1u8RA0dwoBq3Z7JjX
 /Qxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=EBvLSPzxeZwoRgmfMBjBkf8t4T2CICbfEAFJBAeKCK0=;
 b=gjGzfe31CpoZmUPYawbY4UewaleS/eWvTKSFazHztJOiJ16uHdtbBdovLX0rZ65n5q
 P8xDb+uwglKUVoF7Nx0CX/bcJ6czFiYO+zi2HSxCGb+WuX6g3YQWem4D59fRyE4rscNT
 PhhO/S05Sph9aoXVxN8WVS2F5Er4t5V6nfFjMJQHchosQJ5QlI5nPrTF0Kr5IUo7eai5
 coZZJXowGfxWwxp0Qzr/JJB0TdVjMRLNcKx3iGpcLLcePYGXh86l7Z6OyewS63uUgKC/
 NfZwppVcpT2m624rHI5xoLGthlB82/aPkuV0MmeX/fgRY5/tuBgKl/bnHD2aCXWnWlA5
 lZDw==
X-Gm-Message-State: AOAM532fXk9E9qigJdQchuNFzELbQEgXNe83chRlJyuytoTYHpriDt3U
 eYVA6W0ruvoahDCCNGy+tEhjZ8/2ezUoEc6QTVNuEESJOppZKBdywc1sHS6WFIF6emDrep9L048
 6qQqdEeZTyjH06UD57Qt0QGL1NLohtfCdmx9z+FGGmwa2e4nOpJ5jarOhpJUR+S64NfWKYg==
X-Google-Smtp-Source: ABdhPJyWD5Z8mog1lrNmFeB3Sj9lloObcBlu4DMRGN5AyclNoy+a82Sff9gvBtxPsYrcjqqbU4Xa8wmxPiA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:1494:b0:649:5967:e7c7
 with SMTP id
 a20-20020a056602149400b006495967e7c7mr15590609iow.49.1648762731335; Thu, 31
 Mar 2022 14:38:51 -0700 (PDT)
Date: Thu, 31 Mar 2022 21:38:44 +0000
Message-Id: <20220331213844.2894006-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH] KVM: arm64: Don't split hugepages outside of MMU write lock
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

It is possible to take a stage-2 permission fault on a page larger than
PAGE_SIZE. For example, when running a guest backed by 2M HugeTLB, KVM
eagerly maps at the largest possible block size. When dirty logging is
enabled on a memslot, KVM does *not* eagerly split these 2M stage-2
mappings and instead clears the write bit on the pte.

Since dirty logging is always performed at PAGE_SIZE granularity, KVM
lazily splits these 2M block mappings down to PAGE_SIZE in the stage-2
fault handler. This operation must be done under the write lock. Since
commit f783ef1c0e82 ("KVM: arm64: Add fast path to handle permission
relaxation during dirty logging"), the stage-2 fault handler
conditionally takes the read lock on permission faults with dirty
logging enabled. To that end, it is possible to split a 2M block mapping
while only holding the read lock.

The problem is demonstrated by running kvm_page_table_test with 2M
anonymous HugeTLB, which splats like so:

  WARNING: CPU: 5 PID: 15276 at arch/arm64/kvm/hyp/pgtable.c:153 stage2_map_walk_leaf+0x124/0x158

  [...]

  Call trace:
  stage2_map_walk_leaf+0x124/0x158
  stage2_map_walker+0x5c/0xf0
  __kvm_pgtable_walk+0x100/0x1d4
  __kvm_pgtable_walk+0x140/0x1d4
  __kvm_pgtable_walk+0x140/0x1d4
  kvm_pgtable_walk+0xa0/0xf8
  kvm_pgtable_stage2_map+0x15c/0x198
  user_mem_abort+0x56c/0x838
  kvm_handle_guest_abort+0x1fc/0x2a4
  handle_exit+0xa4/0x120
  kvm_arch_vcpu_ioctl_run+0x200/0x448
  kvm_vcpu_ioctl+0x588/0x664
  __arm64_sys_ioctl+0x9c/0xd4
  invoke_syscall+0x4c/0x144
  el0_svc_common+0xc4/0x190
  do_el0_svc+0x30/0x8c
  el0_svc+0x28/0xcc
  el0t_64_sync_handler+0x84/0xe4
  el0t_64_sync+0x1a4/0x1a8

Fix the issue by only acquiring the read lock if the guest faulted on a
PAGE_SIZE granule w/ dirty logging enabled. Since it is possible for the
faulting IPA to get collapsed into a larger block mapping until the read
lock is acquired, retry the faulting instruction any time that the fault
cannot be fixed by relaxing permissions. In so doing, the fault handler
will acquire the write lock for the subsequent fault on a larger
PAGE_SIZE mapping and split the block safely behind the write lock.

Fixes: f783ef1c0e82 ("KVM: arm64: Add fast path to handle permission relaxation during dirty logging")
Cc: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---

Applies cleanly to kvmarm/fixes at the following commit:

  8872d9b3e35a ("KVM: arm64: Drop unneeded minor version check from PSCI v1.x handler")

Tested the patch by running KVM selftests. Additionally, I did 10
iterations of the kvm_page_table_test with 2M anon HugeTLB memory.

It is expected that this patch will cause fault serialization in the
pathological case where all vCPUs are faulting on the same granule of
memory, as every vCPU will attempt to acquire the write lock. The only
safe way to cure this contention is to dissolve pages eagerly outside of
the stage-2 fault handler (like x86).

 arch/arm64/kvm/mmu.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0d19259454d8..9384325bf3df 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1079,7 +1079,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
-	bool logging_perm_fault = false;
+	bool use_read_lock = false;
 	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
 	unsigned long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
@@ -1114,7 +1114,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (logging_active) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
-		logging_perm_fault = (fault_status == FSC_PERM && write_fault);
+		use_read_lock = (fault_status == FSC_PERM && write_fault &&
+				 fault_granule == PAGE_SIZE);
 	} else {
 		vma_shift = get_vma_page_shift(vma, hva);
 	}
@@ -1218,7 +1219,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * logging dirty logging, only acquire read lock for permission
 	 * relaxation.
 	 */
-	if (logging_perm_fault)
+	if (use_read_lock)
 		read_lock(&kvm->mmu_lock);
 	else
 		write_lock(&kvm->mmu_lock);
@@ -1267,10 +1268,24 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	if (fault_status == FSC_PERM && vma_pagesize == fault_granule) {
 		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
-	} else {
+	} else if (!use_read_lock) {
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
 					     memcache);
+
+	/*
+	 * The read lock is taken if the FSC indicates that the guest faulted on
+	 * a PAGE_SIZE granule. It is possible that the stage-2 fault raced with
+	 * a map operation that collapsed the faulted address into a larger
+	 * block mapping.
+	 *
+	 * Since KVM splits mappings down to PAGE_SIZE when dirty logging is
+	 * enabled, it is necessary to hold the write lock for faults where
+	 * fault_granule > PAGE_SIZE. Retry the faulting instruction and acquire
+	 * the write lock on the next exit.
+	 */
+	} else {
+		ret = -EAGAIN;
 	}
 
 	/* Mark the page dirty only if the fault is handled successfully */
@@ -1280,7 +1295,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 out_unlock:
-	if (logging_perm_fault)
+	if (use_read_lock)
 		read_unlock(&kvm->mmu_lock);
 	else
 		write_unlock(&kvm->mmu_lock);
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
