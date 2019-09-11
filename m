Return-Path: <SRS0=E7bu=XG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA39ECDE20
	for <kvmarm@archiver.kernel.org>; Wed, 11 Sep 2019 18:50:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 974242075C
	for <kvmarm@archiver.kernel.org>; Wed, 11 Sep 2019 18:50:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 974242075C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DF1E4A668;
	Wed, 11 Sep 2019 14:50:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eYFr+CmY5uM4; Wed, 11 Sep 2019 14:50:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A01044A67D;
	Wed, 11 Sep 2019 14:50:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 993AF4A594
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Sep 2019 14:50:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I7k8iaI7vqeO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Sep 2019 14:50:44 -0400 (EDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 584184A52E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Sep 2019 14:50:44 -0400 (EDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 11 Sep 2019 11:50:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; d="scan'208";a="196980896"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
 by orsmga002.jf.intel.com with ESMTP; 11 Sep 2019 11:50:41 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: James Hogan <jhogan@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
 Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 11/13] KVM: Ensure validity of memslot with respect to
 kvm_get_dirty_log()
Date: Wed, 11 Sep 2019 11:50:36 -0700
Message-Id: <20190911185038.24341-12-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190911185038.24341-1-sean.j.christopherson@intel.com>
References: <20190911185038.24341-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Joerg Roedel <joro@8bytes.org>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

Rework kvm_get_dirty_log() so that it "returns" the associated memslot
on success.  A future patch will rework memslot handling such that
id_to_memslot() can return NULL, returning the memslot makes it more
obvious that the validity of the memslot has been verified, i.e.
precludes the need to add validity checks in the arch code that are
technically unnecessary.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/powerpc/kvm/book3s_pr.c |  6 +-----
 arch/s390/kvm/kvm-s390.c     | 12 ++----------
 include/linux/kvm_host.h     |  2 +-
 virt/kvm/kvm_main.c          | 27 +++++++++++++++++++--------
 4 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 5368a5dbac22..f41a136d247f 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1860,7 +1860,6 @@ static int kvmppc_vcpu_run_pr(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 static int kvm_vm_ioctl_get_dirty_log_pr(struct kvm *kvm,
 					 struct kvm_dirty_log *log)
 {
-	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
 	struct kvm_vcpu *vcpu;
 	ulong ga, ga_end;
@@ -1870,15 +1869,12 @@ static int kvm_vm_ioctl_get_dirty_log_pr(struct kvm *kvm,
 
 	mutex_lock(&kvm->slots_lock);
 
-	r = kvm_get_dirty_log(kvm, log, &is_dirty);
+	r = kvm_get_dirty_log(kvm, log, &is_dirty, &memslot);
 	if (r)
 		goto out;
 
 	/* If nothing is dirty, don't bother messing with page tables. */
 	if (is_dirty) {
-		slots = kvm_memslots(kvm);
-		memslot = id_to_memslot(slots, log->slot);
-
 		ga = memslot->base_gfn << PAGE_SHIFT;
 		ga_end = ga + (memslot->npages << PAGE_SHIFT);
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 36d4de1b1409..074f0d7771b6 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -613,9 +613,8 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 {
 	int r;
 	unsigned long n;
-	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
-	int is_dirty = 0;
+	int is_dirty;
 
 	if (kvm_is_ucontrol(kvm))
 		return -EINVAL;
@@ -626,14 +625,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	if (log->slot >= KVM_USER_MEM_SLOTS)
 		goto out;
 
-	slots = kvm_memslots(kvm);
-	memslot = id_to_memslot(slots, log->slot);
-	r = -ENOENT;
-	if (!memslot->dirty_bitmap)
-		goto out;
-
-	kvm_arch_sync_dirty_log(kvm, memslot);
-	r = kvm_get_dirty_log(kvm, log, &is_dirty);
+	r = kvm_get_dirty_log(kvm, log, &is_dirty, &memslot);
 	if (r)
 		goto out;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index feb40a184847..049e20876b8f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -808,7 +808,7 @@ void kvm_arch_dirty_log_tlb_flush(struct kvm *kvm, struct kvm_memory_slot *slot)
 #else /* !CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log);
 int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
-		      int *is_dirty);
+		      int *is_dirty, struct kvm_memory_slot **memslot);
 #endif
 
 int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 85062477be90..11b130e9f223 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1123,31 +1123,42 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 }
 
 #ifndef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
-int kvm_get_dirty_log(struct kvm *kvm,
-			struct kvm_dirty_log *log, int *is_dirty)
+/**
+ * kvm_get_dirty_log - get a snapshot of dirty pages
+ * @kvm:	pointer to kvm instance
+ * @log:	slot id and address to which we copy the log
+ * @is_dirty:	set to '1' if any dirty pages were found
+ * @memslot:	set to the associated memslot, always valid on success
+ */
+int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
+		      int *is_dirty, struct kvm_memory_slot **memslot)
 {
 	struct kvm_memslots *slots;
-	struct kvm_memory_slot *memslot;
 	int i, as_id, id;
 	unsigned long n;
 	unsigned long any = 0;
 
+	*memslot = NULL;
+	*is_dirty = 0;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
 		return -EINVAL;
 
 	slots = __kvm_memslots(kvm, as_id);
-	memslot = id_to_memslot(slots, id);
-	if (!memslot->dirty_bitmap)
+	*memslot = id_to_memslot(slots, id);
+	if (!(*memslot)->dirty_bitmap)
 		return -ENOENT;
 
-	n = kvm_dirty_bitmap_bytes(memslot);
+	kvm_arch_sync_dirty_log(kvm, *memslot);
+
+	n = kvm_dirty_bitmap_bytes(*memslot);
 
 	for (i = 0; !any && i < n/sizeof(long); ++i)
-		any = memslot->dirty_bitmap[i];
+		any = (*memslot)->dirty_bitmap[i];
 
-	if (copy_to_user(log->dirty_bitmap, memslot->dirty_bitmap, n))
+	if (copy_to_user(log->dirty_bitmap, (*memslot)->dirty_bitmap, n))
 		return -EFAULT;
 
 	if (any)
-- 
2.22.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
