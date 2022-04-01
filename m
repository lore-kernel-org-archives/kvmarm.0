Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B267AC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 19:47:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CA554B265;
	Fri,  1 Apr 2022 15:47:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UThw+RbCUp4n; Fri,  1 Apr 2022 15:47:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86B3B4B206;
	Fri,  1 Apr 2022 15:47:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93D614B206
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 15:47:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1I400oGu9WUi for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 15:47:04 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 241554B202
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 15:47:04 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 q6-20020a056e0215c600b002c2c4091914so2434037ilu.14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2022 12:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=sGASyLBse2klm//8WmPcxLcR/0G/i4NUGrOkS5QfPwU=;
 b=p0I9TS+BxRlThc6cRuQsH+gXHlKHv9krEacz1VjAY7yKZldMuM5KnvSIVJAQtqZWIS
 ms13dhQL/oagduEMMikCqjI8fe0Il26LNT4mfIaDFyCY8UQ4wcJpW8wMXaYxc3WuQIvM
 mdupkhdVzZsef3F/9BV50VLdItdtPFVndfUr8B7o+MvldUqTjvZbRKJ4tsw9C7RhnT0p
 tGTUvq4GpmepsRjB3Z/NSlhaV+un8Bv1yvLJDUlr7lbjuUIICAFyOhRIeFBAwVHssCcM
 Q9rHvYe8T5j5uPcJ8tt3uaaz+/fFeykQyO7tsCryee8WEis3fkdBS6GJ/JuEmEt1u6Fi
 TtSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=sGASyLBse2klm//8WmPcxLcR/0G/i4NUGrOkS5QfPwU=;
 b=6qcCQFXDgk1/By2858qeH8lPUC9enD9rD9rVSM4g5+KhLu7hR0hzz2ojN69Bn4uR6+
 2fIchuYEPJ0MkyxBnZDG1bU7G0jS0Ce91n5u6hse4rTqmqua5XK0qsDlyMz6N0MdOqDB
 veaN2Tsw+7v6Hst/995j1NytdIkDny1Saue3yuj5/k2lI0PWW5ATTTtDPVQpJZIV1jdv
 +uKr0CCKFNjq6e/IqiEwYKnXDWmmSiZuMBb3K+OxM2HvD9f+25wxuVDYJqXqD4vzp9jS
 TXmd/+oPIDz0C78k+qaVQh4wQUrqw7y6tdBZmvRmcPCEhNln38HPDpUaTGBmN2i0Bggi
 E4vQ==
X-Gm-Message-State: AOAM532cv0vpx2QNI/aqmfnmBArUFN4BeNRGJ2N3UdZ2QGCuSR9u2y18
 fD8JCnG74Bfa0AFcUYck+jUJF+TXeuwAAucXOlVft0n9R0Hn0zKGQ+Vvn3DDFVLsvQdOuXBXzOR
 6Rxc1/BtUWiLcs6AamDi1ZfiWqDJd1iZcm79puua5FnPRM+MS1aPh09vqBkTxM/FDtzzEZw==
X-Google-Smtp-Source: ABdhPJzdy78X78ccSq0ir+N3gnYKV5tuuxTZVy7a3oFEuCUTAisBEAFvByvYnHiaUoeXiQdHX+wqwT+YhWE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1c46:b0:2c9:f0a8:2d32
 with SMTP id
 d6-20020a056e021c4600b002c9f0a82d32mr641920ilg.54.1648842423330; Fri, 01 Apr
 2022 12:47:03 -0700 (PDT)
Date: Fri,  1 Apr 2022 19:46:52 +0000
Message-Id: <20220401194652.950240-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v2] KVM: arm64: Don't split hugepages outside of MMU write lock
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-arm-kernel@lists.infradead.org
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
PAGE_SIZE granule w/ dirty logging enabled. Add a WARN to catch locking
bugs in future changes.

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

v1: https://lore.kernel.org/kvmarm/20220331213844.2894006-1-oupton@google.com/

v1 -> v2:
 - Drop impossible check for !use_read_lock before
   kvm_pgtable_stage2_map() (Reiji)
 - Codify the requirement to hold the write lock to call
   kvm_pgtable_stage2_map() with a WARN

 arch/arm64/kvm/mmu.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0d19259454d8..53ae2c0640bc 100644
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
@@ -1268,6 +1269,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (fault_status == FSC_PERM && vma_pagesize == fault_granule) {
 		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
 	} else {
+		WARN_ONCE(use_read_lock, "Attempted stage-2 map outside of write lock\n");
+
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
 					     memcache);
@@ -1280,7 +1283,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
