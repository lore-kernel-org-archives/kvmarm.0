Return-Path: <SRS0=rr56=M3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D530C4320E
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:58:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0EB4B61004
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:58:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0EB4B61004
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B580840C88;
	Wed,  4 Aug 2021 04:58:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RaJXfORJMzyZ; Wed,  4 Aug 2021 04:58:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D60940856;
	Wed,  4 Aug 2021 04:58:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EF1240825
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id untavTDjY9cf for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Aug 2021 04:58:41 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9637F40629
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:38 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 p9-20020a92d2890000b02902221165b777so604835ilp.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Aug 2021 01:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=yT+nCrFmg471JgKctqrSQtIm1tfSoSdZEimBbuaP3hM=;
 b=I75O/UznjRurZ12yqjeSXM1uRHLtkMyqOHMPWxjHv7EqFHpdUtNM/q2lhH3rSJRXMi
 hmtx2v5DfPRntVTXd1HEnfhKFNm++uRppRctqQ9/tBN3y/qLQO6G3I2+zHRVMWwO1Qei
 zrOEuyl5E91LBxGmWuvw3x7WRXMvdLPIXIO7e3es+i3ueOVQhqmLhiWEr19ExFdGTomd
 tzU7TnghJPoMZ486oD2ZRvoEOyvto0wtqL/JmqdjzcDUWMzObugg/StxuiD9e42u0kek
 tBdoapOnjPK+cQ9upIllnUwqm+zBJQdTCWl7xwGMM/2Q+sZLNygYgEiJoxOxk2TjKJ7l
 qk2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=yT+nCrFmg471JgKctqrSQtIm1tfSoSdZEimBbuaP3hM=;
 b=GP3jJx8gCO4A6CUfb7FAnaZa2z7NkmYiXc1H2CWIeqvCloDh0Nn8/wbw0Qm+DkT6NP
 +Lf3EVtDePPTNwD1MmxAdUDpqEh6vGdipfkQ4lwYYdVE7laZuufYpPg/gV4pVN9dEOty
 +7OvgQkzLJISB5Ix6+hg4ha8S7X9H9QsHG6zvRFpE+zOjtNaRKtXxbzrxB5sHBzEwCkN
 VkY6hvIDHa1bOAzjB6/DUeDcyZ0T6vYdroNY4MZnGf+CAKX40vZWvR4tf8T24+KT1B9w
 w6kuh8CxRp9kuJw/Zea0Z7NopiMaOPSh3c4/q+HNS1+ICoSu8c2ky3uBBdtmJxLfpKlk
 AXKA==
X-Gm-Message-State: AOAM531/bJsaldBMCwTXt2ZwXlZiSxg81Rr45c4CvQmHamJ4mKYjW6f6
 WIPHZYFPIDyZcmvpPtSWn3C+1J8Qh78=
X-Google-Smtp-Source: ABdhPJxSOYTpnXMnEgvD536Lr//pppHFulfycmnTBjxZ233HWebGAqoEW5FBilAhV/Yot+rrAUs5jGbPkWM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:cf44:: with SMTP id
 c4mr262704ilr.11.1628067518129; 
 Wed, 04 Aug 2021 01:58:38 -0700 (PDT)
Date: Wed,  4 Aug 2021 08:58:01 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-4-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 03/21] KVM: x86: Take the pvclock sync lock behind the
 tsc_write_lock
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
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

A later change requires that the pvclock sync lock be taken while
holding the tsc_write_lock. Change the locking in kvm_synchronize_tsc()
to align with the requirement to isolate the locking change to its own
commit.

Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/locking.rst | 11 +++++++++++
 arch/x86/kvm/x86.c                 |  2 +-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 8138201efb09..0bf346adac2a 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -36,6 +36,9 @@ On x86:
   holding kvm->arch.mmu_lock (typically with ``read_lock``, otherwise
   there's no need to take kvm->arch.tdp_mmu_pages_lock at all).
 
+- kvm->arch.tsc_write_lock is taken outside
+  kvm->arch.pvclock_gtod_sync_lock
+
 Everything else is a leaf: no other lock is taken inside the critical
 sections.
 
@@ -222,6 +225,14 @@ time it will be set using the Dirty tracking mechanism described above.
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
index 26f1fa263192..93b449761fbe 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2529,7 +2529,6 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
 
 	kvm_vcpu_write_tsc_offset(vcpu, offset);
-	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
 	spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
 	if (!matched) {
@@ -2540,6 +2539,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 
 	kvm_track_tsc_matching(vcpu);
 	spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
+	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 }
 
 static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
