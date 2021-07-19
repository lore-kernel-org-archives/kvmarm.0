Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7A1DC07E9B
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 18:50:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 535BC6112D
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 18:50:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 535BC6112D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8D004B0CE;
	Mon, 19 Jul 2021 14:50:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v-55tINniQRm; Mon, 19 Jul 2021 14:50:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 185084B0CA;
	Mon, 19 Jul 2021 14:50:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60DCE4B087
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 14:50:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gxX3Df2hG5GR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 14:50:03 -0400 (EDT)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE6094B0B1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 14:50:02 -0400 (EDT)
Received: by mail-io1-f74.google.com with SMTP id
 p7-20020a6b63070000b029050017e563a6so13343621iog.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 11:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=GhOMvXrghMgrA5cJUDKp3N5lyADxOv1r/pHquF+79AY=;
 b=D/aYlVxo4gF+ngT2EhsxuBs4dLxMpsc59UY0ea+aZF7kV6yb0h6VJuouAJFhYN/W2V
 q67XWG04FbHwgm5fOnbL/VXz5mp4tx5GDfjliini9B8ijChsqmUhjZ+plrU/zmqfrx+3
 Au91AOJPy2VNvDdARpgsaAt7/h2+A1wxSiqW8VNqqvSmb5Cx6kbqFFiD8m64G7G+mRq5
 MZTaYqlzfxaS5qHKar7AkJnWiUZlVkVpnxfDOXBlmlYJBOcs5V2jE4ar1G1IsW/P/ehB
 zUn5sPy9uUJ1PCJcvTqOLbh9W52HkCfHG42kw4oiidiOsn4m4fz431A7RoIX8b4UZePK
 Tn/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=GhOMvXrghMgrA5cJUDKp3N5lyADxOv1r/pHquF+79AY=;
 b=gi5r73X43THxgpipAcq+HhP8mm5cpcXMivCKvRrpLpNNMoCE/5ueOMCKlXH2m06CtU
 w+OKBBElpGGFVuhwe780W8SzHo/mOyoXIKU7K5jOzftt9xGmGjXVPwBnmxF+JPoUEso1
 HcnybBZHjE+Ncjn9p0I1Zyh2wFN3IJgd7ieO1vKncCTZ3KHS+1g3+ejkyVssH9h6Xz2g
 hyPpCIYSR1KRjIuqlq/nGv7ueyEOqL2tqh5NKtoRFu8f1SAC9jA/+ZAhkSfxDMMfH61R
 RrgwqheetnYF930DHOmZO2QNMImdOncPyULwXTy4bClUIF9pDomjEfxNMvf3wL298OQK
 sbTA==
X-Gm-Message-State: AOAM5331uq8FjAw2fZeHJNX11+g9j7+Bt1+7pllsBkIBdLRpWebJQ1ZB
 1FoLX+GZn1Pjn5lARxvtt41uTjBWtuE=
X-Google-Smtp-Source: ABdhPJxhjeeV517I8G9SDrwYXwQAF4gak5x9fd2mxwZ6Dy0ItSFxpEA3vLF5SwT8/R+AMo1D7Kj5J29roqY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:5409:: with SMTP id
 i9mr17763897ilb.138.1626720602384; 
 Mon, 19 Jul 2021 11:50:02 -0700 (PDT)
Date: Mon, 19 Jul 2021 18:49:39 +0000
In-Reply-To: <20210719184949.1385910-1-oupton@google.com>
Message-Id: <20210719184949.1385910-3-oupton@google.com>
Mime-Version: 1.0
References: <20210719184949.1385910-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 02/12] KVM: x86: Refactor tsc synchronization code
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

Refactor kvm_synchronize_tsc to make a new function that allows callers
to specify TSC parameters (offset, value, nanoseconds, etc.) explicitly
for the sake of participating in TSC synchronization.

This changes the locking semantics around TSC writes. Writes to the TSC
will now take the pvclock gtod lock while holding the tsc write lock,
whereas before these locks were disjoint.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/locking.rst |  11 +++
 arch/x86/kvm/x86.c                 | 106 +++++++++++++++++------------
 2 files changed, 74 insertions(+), 43 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 35eca377543d..ac62e1c76694 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -30,6 +30,9 @@ On x86:
   holding kvm->arch.mmu_lock (typically with ``read_lock``, otherwise
   there's no need to take kvm->arch.tdp_mmu_pages_lock at all).
 
+- kvm->arch.tsc_write_lock is taken outside
+  kvm->arch.pvclock_gtod_sync_lock
+
 Everything else is a leaf: no other lock is taken inside the critical
 sections.
 
@@ -216,6 +219,14 @@ time it will be set using the Dirty tracking mechanism described above.
 :Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
 		migration.
 
+:Name:		kvm_arch::pvclock_gtod_sync_lock
+:Type:		raw_spinlock_t
+:Arch:		x86
+:Protects:	kvm_arch::{cur_tsc_generation,cur_tsc_nsec,cur_tsc_write,
+			cur_tsc_offset,nr_vcpus_matched_tsc}
+:Comment:	'raw' because updating the kvm master clock must not be
+		preempted.
+
 :Name:		kvm_arch::tsc_write_lock
 :Type:		raw_spinlock
 :Arch:		x86
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bff78168d4a2..580ba0e86687 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2441,13 +2441,73 @@ static inline bool kvm_check_tsc_unstable(void)
 	return check_tsc_unstable();
 }
 
+/*
+ * Infers attempts to synchronize the guest's tsc from host writes. Sets the
+ * offset for the vcpu and tracks the TSC matching generation that the vcpu
+ * participates in.
+ *
+ * Must hold kvm->arch.tsc_write_lock to call this function.
+ */
+static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
+				  u64 ns, bool matched)
+{
+	struct kvm *kvm = vcpu->kvm;
+	bool already_matched;
+	unsigned long flags;
+
+	lockdep_assert_held(&kvm->arch.tsc_write_lock);
+
+	already_matched =
+	       (vcpu->arch.this_tsc_generation == kvm->arch.cur_tsc_generation);
+
+	/*
+	 * We track the most recent recorded KHZ, write and time to
+	 * allow the matching interval to be extended at each write.
+	 */
+	kvm->arch.last_tsc_nsec = ns;
+	kvm->arch.last_tsc_write = tsc;
+	kvm->arch.last_tsc_khz = vcpu->arch.virtual_tsc_khz;
+
+	vcpu->arch.last_guest_tsc = tsc;
+
+	/* Keep track of which generation this VCPU has synchronized to */
+	vcpu->arch.this_tsc_generation = kvm->arch.cur_tsc_generation;
+	vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
+	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
+
+	kvm_vcpu_write_tsc_offset(vcpu, offset);
+
+	spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
+	if (!matched) {
+		/*
+		 * We split periods of matched TSC writes into generations.
+		 * For each generation, we track the original measured
+		 * nanosecond time, offset, and write, so if TSCs are in
+		 * sync, we can match exact offset, and if not, we can match
+		 * exact software computation in compute_guest_tsc()
+		 *
+		 * These values are tracked in kvm->arch.cur_xxx variables.
+		 */
+		kvm->arch.nr_vcpus_matched_tsc = 0;
+		kvm->arch.cur_tsc_generation++;
+		kvm->arch.cur_tsc_nsec = ns;
+		kvm->arch.cur_tsc_write = tsc;
+		kvm->arch.cur_tsc_offset = offset;
+		matched = false;
+	} else if (!already_matched) {
+		kvm->arch.nr_vcpus_matched_tsc++;
+	}
+
+	kvm_track_tsc_matching(vcpu);
+	spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
+}
+
 static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm *kvm = vcpu->kvm;
 	u64 offset, ns, elapsed;
 	unsigned long flags;
-	bool matched;
-	bool already_matched;
+	bool matched = false;
 	bool synchronizing = false;
 
 	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
@@ -2493,51 +2553,11 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 			offset = kvm_compute_l1_tsc_offset(vcpu, data);
 		}
 		matched = true;
-		already_matched = (vcpu->arch.this_tsc_generation == kvm->arch.cur_tsc_generation);
-	} else {
-		/*
-		 * We split periods of matched TSC writes into generations.
-		 * For each generation, we track the original measured
-		 * nanosecond time, offset, and write, so if TSCs are in
-		 * sync, we can match exact offset, and if not, we can match
-		 * exact software computation in compute_guest_tsc()
-		 *
-		 * These values are tracked in kvm->arch.cur_xxx variables.
-		 */
-		kvm->arch.cur_tsc_generation++;
-		kvm->arch.cur_tsc_nsec = ns;
-		kvm->arch.cur_tsc_write = data;
-		kvm->arch.cur_tsc_offset = offset;
-		matched = false;
 	}
 
-	/*
-	 * We also track th most recent recorded KHZ, write and time to
-	 * allow the matching interval to be extended at each write.
-	 */
-	kvm->arch.last_tsc_nsec = ns;
-	kvm->arch.last_tsc_write = data;
-	kvm->arch.last_tsc_khz = vcpu->arch.virtual_tsc_khz;
-
-	vcpu->arch.last_guest_tsc = data;
+	__kvm_synchronize_tsc(vcpu, offset, data, ns, matched);
 
-	/* Keep track of which generation this VCPU has synchronized to */
-	vcpu->arch.this_tsc_generation = kvm->arch.cur_tsc_generation;
-	vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
-	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
-
-	kvm_vcpu_write_tsc_offset(vcpu, offset);
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
-
-	spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
-	if (!matched) {
-		kvm->arch.nr_vcpus_matched_tsc = 0;
-	} else if (!already_matched) {
-		kvm->arch.nr_vcpus_matched_tsc++;
-	}
-
-	kvm_track_tsc_matching(vcpu);
-	spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
 }
 
 static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
