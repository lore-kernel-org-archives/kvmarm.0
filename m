Return-Path: <SRS0=hs0s=PY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B036FC433EF
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 19:21:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4F1BE61052
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 19:21:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4F1BE61052
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECCE04B18A;
	Fri,  5 Nov 2021 15:21:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F9oqG+OT52YJ; Fri,  5 Nov 2021 15:21:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CC3A4B1C7;
	Fri,  5 Nov 2021 15:21:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F6924B0F7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Nov 2021 15:21:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nmPtZRuU1QPw for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Nov 2021 15:21:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 804564B15B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Nov 2021 15:21:32 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C91E761263;
 Fri,  5 Nov 2021 19:21:31 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mj4mH-003ig2-Ut; Fri, 05 Nov 2021 19:21:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, linux-mips@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 5/5] KVM: Convert the kvm->vcpus array to a xarray
Date: Fri,  5 Nov 2021 19:21:01 +0000
Message-Id: <20211105192101.3862492-6-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211105192101.3862492-1-maz@kernel.org>
References: <20211105192101.3862492-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-mips@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linuxppc-dev@lists.ozlabs.org,
 chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, anup.patel@wdc.com,
 atish.patra@wdc.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
 david@redhat.com, imbrenda@linux.ibm.com, pbonzini@redhat.com, jgross@suse.com,
 npiggin@gmail.com, seanjc@google.com, paulus@samba.org, mpe@ellerman.id.au,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Juergen Gross <jgross@suse.com>, Huacai Chen <chenhuacai@kernel.org>,
 Janosch Frank <frankja@linux.ibm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Anup Patel <anup.patel@wdc.com>, David Hildenbrand <david@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>, Atish Patra <atish.patra@wdc.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>,
 Paolo Bonzini <pbonzini@redhat.com>, kernel-team@android.com,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
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

At least on arm64 and x86, the vcpus array is pretty huge (512 entries),
and is mostly empty in most cases (running 512 vcpu VMs is not that
common). This mean that we end-up with a 4kB block of unused memory
in the middle of the kvm structure.

Instead of wasting away this memory, let's use an xarray instead,
which gives us almost the same flexibility as a normal array, but
with a reduced memory usage with smaller VMs.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/linux/kvm_host.h |  5 +++--
 virt/kvm/kvm_main.c      | 15 +++++++++------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 36967291b8c6..3933d825e28b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -29,6 +29,7 @@
 #include <linux/refcount.h>
 #include <linux/nospec.h>
 #include <linux/notifier.h>
+#include <linux/xarray.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -552,7 +553,7 @@ struct kvm {
 	struct mutex slots_arch_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
-	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
+	struct xarray vcpu_array;
 
 	/* Used to wait for completion of MMU notifiers.  */
 	spinlock_t mn_invalidate_lock;
@@ -693,7 +694,7 @@ static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
 
 	/* Pairs with smp_wmb() in kvm_vm_ioctl_create_vcpu.  */
 	smp_rmb();
-	return kvm->vcpus[i];
+	return xa_load(&kvm->vcpu_array, i);
 }
 
 #define kvm_for_each_vcpu(idx, vcpup, kvm) \
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d83553eeea21..4c18d7911fa5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -461,7 +461,7 @@ void kvm_destroy_vcpus(struct kvm *kvm)
 
 	mutex_lock(&kvm->lock);
 	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
-		kvm->vcpus[i] = NULL;
+		xa_erase(&kvm->vcpu_array, i);
 
 	atomic_set(&kvm->online_vcpus, 0);
 	mutex_unlock(&kvm->lock);
@@ -1066,6 +1066,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	mutex_init(&kvm->slots_arch_lock);
 	spin_lock_init(&kvm->mn_invalidate_lock);
 	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
+	xa_init(&kvm->vcpu_array);
 
 	INIT_LIST_HEAD(&kvm->devices);
 
@@ -3661,7 +3662,10 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	}
 
 	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
-	BUG_ON(kvm->vcpus[vcpu->vcpu_idx]);
+	r = xa_insert(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, GFP_KERNEL_ACCOUNT);
+	BUG_ON(r == -EBUSY);
+	if (r)
+		goto unlock_vcpu_destroy;
 
 	/* Fill the stats id string for the vcpu */
 	snprintf(vcpu->stats_id, sizeof(vcpu->stats_id), "kvm-%d/vcpu-%d",
@@ -3671,15 +3675,14 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	kvm_get_kvm(kvm);
 	r = create_vcpu_fd(vcpu);
 	if (r < 0) {
+		xa_erase(&kvm->vcpu_array, vcpu->vcpu_idx);
 		kvm_put_kvm_no_destroy(kvm);
 		goto unlock_vcpu_destroy;
 	}
 
-	kvm->vcpus[vcpu->vcpu_idx] = vcpu;
-
 	/*
-	 * Pairs with smp_rmb() in kvm_get_vcpu.  Write kvm->vcpus
-	 * before kvm->online_vcpu's incremented value.
+	 * Pairs with smp_rmb() in kvm_get_vcpu.  Store the vcpu
+	 * pointer before kvm->online_vcpu's incremented value.
 	 */
 	smp_wmb();
 	atomic_inc(&kvm->online_vcpus);
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
