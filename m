Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A260C34031
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 21:08:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2E42724654
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 21:08:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E42724654
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B14D64AF95;
	Tue, 18 Feb 2020 16:08:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cX0QKt5gM2cu; Tue, 18 Feb 2020 16:08:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A738D4AFC0;
	Tue, 18 Feb 2020 16:07:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E3504AF18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 16:07:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PGzygH8y7K-I for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 16:07:53 -0500 (EST)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7A7714AF51
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 16:07:49 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 18 Feb 2020 13:07:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,457,1574150400"; d="scan'208";a="253856451"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by orsmga002.jf.intel.com with ESMTP; 18 Feb 2020 13:07:46 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v6 16/22] KVM: Ensure validity of memslot with respect to
 kvm_get_dirty_log()
Date: Tue, 18 Feb 2020 13:07:30 -0800
Message-Id: <20200218210736.16432-17-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218210736.16432-1-sean.j.christopherson@intel.com>
References: <20200218210736.16432-1-sean.j.christopherson@intel.com>
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

Rework kvm_get_dirty_log() so that it "returns" the associated memslot
on success.  A future patch will rework memslot handling such that
id_to_memslot() can return NULL, returning the memslot makes it more
obvious that the validity of the memslot has been verified, i.e.
precludes the need to add validity checks in the arch code that are
technically unnecessary.

To maintain ordering in s390, move the call to kvm_arch_sync_dirty_log()
from s390's kvm_vm_ioctl_get_dirty_log() to the new kvm_get_dirty_log().
This is a nop for PPC, the only other arch that doesn't select
KVM_GENERIC_DIRTYLOG_READ_PROTECT, as its sync_dirty_log() is empty.

Ideally, moving the sync_dirty_log() call would be done in a separate
patch, but it can't be done in a follow-on patch because that would
temporarily break s390's ordering.  Making the move in a preparatory
patch would be functionally correct, but would create an odd scenario
where the moved sync_dirty_log() would operate on a "different" memslot
due to consuming the result of a different id_to_memslot().  The
memslot couldn't actually be different as slots_lock is held, but the
code is confusing enough as it is, i.e. moving sync_dirty_log() in this
patch is the lesser of all evils.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/powerpc/kvm/book3s_pr.c |  6 +-----
 arch/s390/kvm/kvm-s390.c     | 12 ++----------
 include/linux/kvm_host.h     |  2 +-
 virt/kvm/kvm_main.c          | 27 +++++++++++++++++++--------
 4 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 71ae332b91c9..3bc2f5da8fa1 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1884,7 +1884,6 @@ static int kvmppc_vcpu_run_pr(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 static int kvm_vm_ioctl_get_dirty_log_pr(struct kvm *kvm,
 					 struct kvm_dirty_log *log)
 {
-	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
 	struct kvm_vcpu *vcpu;
 	ulong ga, ga_end;
@@ -1894,15 +1893,12 @@ static int kvm_vm_ioctl_get_dirty_log_pr(struct kvm *kvm,
 
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
index 2adbc2fde382..fb081c5715b2 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -611,9 +611,8 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 {
 	int r;
 	unsigned long n;
-	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
-	int is_dirty = 0;
+	int is_dirty;
 
 	if (kvm_is_ucontrol(kvm))
 		return -EINVAL;
@@ -624,14 +623,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
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
index 4588b988ebf1..f1501a08e7ac 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -828,7 +828,7 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
 #else /* !CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log);
 int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
-		      int *is_dirty);
+		      int *is_dirty, struct kvm_memory_slot **memslot);
 #endif
 
 int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d986168ee8b1..182b36115ba0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1202,31 +1202,42 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
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
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
