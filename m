Return-Path: <SRS0=+NXu=QD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1001AC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 16 Nov 2021 16:04:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ABB0C61BFE
	for <kvmarm@archiver.kernel.org>; Tue, 16 Nov 2021 16:04:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org ABB0C61BFE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6394A4B176;
	Tue, 16 Nov 2021 11:04:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CT6dvE+bPa1k; Tue, 16 Nov 2021 11:04:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F06614B086;
	Tue, 16 Nov 2021 11:04:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C52274B14C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 11:04:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O-B70Q-w4Rxa for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Nov 2021 11:04:15 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 952724B0C5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 11:04:15 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D593061AA5;
 Tue, 16 Nov 2021 16:04:14 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mn0wP-005sTB-06; Tue, 16 Nov 2021 16:04:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, linux-mips@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linuxppc-dev@lists.ozlabs.org,
 Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 5/7] KVM: Convert the kvm->vcpus array to a xarray
Date: Tue, 16 Nov 2021 16:04:01 +0000
Message-Id: <20211116160403.4074052-6-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211116160403.4074052-1-maz@kernel.org>
References: <20211116160403.4074052-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-mips@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linuxppc-dev@lists.ozlabs.org,
 pbonzini@redhat.com, chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com,
 anup.patel@wdc.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
 david@redhat.com, imbrenda@linux.ibm.com, jgross@suse.com, npiggin@gmail.com,
 seanjc@google.com, paulus@samba.org, mpe@ellerman.id.au, f4bug@amsat.org,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Juergen Gross <jgross@suse.com>, Huacai Chen <chenhuacai@kernel.org>,
 Janosch Frank <frankja@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 Anup Patel <anup.patel@wdc.com>,
 =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>,
 kernel-team@android.com, Claudio Imbrenda <imbrenda@linux.ibm.com>
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

At least on arm64 and x86, the vcpus array is pretty huge (up to
1024 entries on x86) and is mostly empty in the majority of the cases
(running 1k vcpu VMs is not that common).

This mean that we end-up with a 4kB block of unused memory in the
middle of the kvm structure.

Instead of wasting away this memory, let's use an xarray instead,
which gives us almost the same flexibility as a normal array, but
with a reduced memory usage with smaller VMs.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/linux/kvm_host.h |  5 +++--
 virt/kvm/kvm_main.c      | 15 +++++++++------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9a8c997ff9bc..df1b2b183d94 100644
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
@@ -701,7 +702,7 @@ static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
 
 	/* Pairs with smp_wmb() in kvm_vm_ioctl_create_vcpu.  */
 	smp_rmb();
-	return kvm->vcpus[i];
+	return xa_load(&kvm->vcpu_array, i);
 }
 
 #define kvm_for_each_vcpu(idx, vcpup, kvm) \
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 73811c3829a2..9a7bce944427 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -458,7 +458,7 @@ void kvm_destroy_vcpus(struct kvm *kvm)
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		kvm_vcpu_destroy(vcpu);
-		kvm->vcpus[i] = NULL;
+		xa_erase(&kvm->vcpu_array, i);
 	}
 
 	atomic_set(&kvm->online_vcpus, 0);
@@ -1063,6 +1063,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	mutex_init(&kvm->slots_arch_lock);
 	spin_lock_init(&kvm->mn_invalidate_lock);
 	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
+	xa_init(&kvm->vcpu_array);
 
 	INIT_LIST_HEAD(&kvm->devices);
 
@@ -3658,7 +3659,10 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	}
 
 	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
-	BUG_ON(kvm->vcpus[vcpu->vcpu_idx]);
+	r = xa_insert(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, GFP_KERNEL_ACCOUNT);
+	BUG_ON(r == -EBUSY);
+	if (r)
+		goto unlock_vcpu_destroy;
 
 	/* Fill the stats id string for the vcpu */
 	snprintf(vcpu->stats_id, sizeof(vcpu->stats_id), "kvm-%d/vcpu-%d",
@@ -3668,15 +3672,14 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
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
