Return-Path: <SRS0=DlSC=3K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB905C33CB8
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 22:32:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5572924655
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 22:32:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5572924655
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 608584AEDA;
	Tue, 21 Jan 2020 17:32:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id skm6w6SF6b51; Tue, 21 Jan 2020 17:32:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F3A644AED1;
	Tue, 21 Jan 2020 17:32:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CE754AE94
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 17:32:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V6XqxKe3skLq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 17:32:04 -0500 (EST)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF6D54A534
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 17:32:03 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 21 Jan 2020 14:32:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,347,1574150400"; d="scan'208";a="244845098"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by orsmga002.jf.intel.com with ESMTP; 21 Jan 2020 14:32:02 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v5 01/19] KVM: x86: Allocate new rmap and large page tracking
 when moving memslot
Date: Tue, 21 Jan 2020 14:31:39 -0800
Message-Id: <20200121223157.15263-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200121223157.15263-1-sean.j.christopherson@intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
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

Reallocate a rmap array and recalcuate large page compatibility when
moving an existing memslot to correctly handle the alignment properties
of the new memslot.  The number of rmap entries required at each level
is dependent on the alignment of the memslot's base gfn with respect to
that level, e.g. moving a large-page aligned memslot so that it becomes
unaligned will increase the number of rmap entries needed at the now
unaligned level.

Not updating the rmap array is the most obvious bug, as KVM accesses
garbage data beyond the end of the rmap.  KVM interprets the bad data as
pointers, leading to non-canonical #GPs, unexpected #PFs, etc...

  general protection fault: 0000 [#1] SMP
  CPU: 0 PID: 1909 Comm: move_memory_reg Not tainted 5.4.0-rc7+ #139
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:rmap_get_first+0x37/0x50 [kvm]
  Code: <48> 8b 3b 48 85 ff 74 ec e8 6c f4 ff ff 85 c0 74 e3 48 89 d8 5b c3
  RSP: 0018:ffffc9000021bbc8 EFLAGS: 00010246
  RAX: ffff00617461642e RBX: ffff00617461642e RCX: 0000000000000012
  RDX: ffff88827400f568 RSI: ffffc9000021bbe0 RDI: ffff88827400f570
  RBP: 0010000000000000 R08: ffffc9000021bd00 R09: ffffc9000021bda8
  R10: ffffc9000021bc48 R11: 0000000000000000 R12: 0030000000000000
  R13: 0000000000000000 R14: ffff88827427d700 R15: ffffc9000021bce8
  FS:  00007f7eda014700(0000) GS:ffff888277a00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f7ed9216ff8 CR3: 0000000274391003 CR4: 0000000000162eb0
  Call Trace:
   kvm_mmu_slot_set_dirty+0xa1/0x150 [kvm]
   __kvm_set_memory_region.part.64+0x559/0x960 [kvm]
   kvm_set_memory_region+0x45/0x60 [kvm]
   kvm_vm_ioctl+0x30f/0x920 [kvm]
   do_vfs_ioctl+0xa1/0x620
   ksys_ioctl+0x66/0x70
   __x64_sys_ioctl+0x16/0x20
   do_syscall_64+0x4c/0x170
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x7f7ed9911f47
  Code: <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 21 6f 2c 00 f7 d8 64 89 01 48
  RSP: 002b:00007ffc00937498 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
  RAX: ffffffffffffffda RBX: 0000000001ab0010 RCX: 00007f7ed9911f47
  RDX: 0000000001ab1350 RSI: 000000004020ae46 RDI: 0000000000000004
  RBP: 000000000000000a R08: 0000000000000000 R09: 00007f7ed9214700
  R10: 00007f7ed92149d0 R11: 0000000000000246 R12: 00000000bffff000
  R13: 0000000000000003 R14: 00007f7ed9215000 R15: 0000000000000000
  Modules linked in: kvm_intel kvm irqbypass
  ---[ end trace 0c5f570b3358ca89 ]---

The disallow_lpage tracking is more subtle.  Failure to update results
in KVM creating large pages when it shouldn't, either due to stale data
or again due to indexing beyond the end of the metadata arrays, which
can lead to memory corruption and/or leaking data to guest/userspace.

Note, the arrays for the old memslot are freed by the unconditional call
to kvm_free_memslot() in __kvm_set_memory_region().

Fixes: 05da45583de9b ("KVM: MMU: large page support")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4c30ebe74e5d..1953c71c52f2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9793,6 +9793,13 @@ int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 {
 	int i;
 
+	/*
+	 * Clear out the previous array pointers for the KVM_MR_MOVE case.  The
+	 * old arrays will be freed by __kvm_set_memory_region() if installing
+	 * the new memslot is successful.
+	 */
+	memset(&slot->arch, 0, sizeof(slot->arch));
+
 	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
 		struct kvm_lpage_info *linfo;
 		unsigned long ugfn;
@@ -9867,6 +9874,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
 				enum kvm_mr_change change)
 {
+	if (change == KVM_MR_MOVE)
+		return kvm_arch_create_memslot(kvm, memslot,
+					       mem->memory_size >> PAGE_SHIFT);
+
 	return 0;
 }
 
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
