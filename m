Return-Path: <SRS0=9WlX=NH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1861FC432BE
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:11:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9D35061378
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:11:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9D35061378
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43CC74B0EE;
	Sun, 15 Aug 2021 20:11:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TK19-qyQle-m; Sun, 15 Aug 2021 20:11:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95C624B107;
	Sun, 15 Aug 2021 20:11:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C03404B0E0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:11:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pYsxd8wy8-MA for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Aug 2021 20:11:41 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 048704B0F3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:11:39 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 p71-20020a25424a0000b029056092741626so14935315yba.19
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 17:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=kyk+rbWBkERQd/V+m5Ky7yGxQv7VTu6C8mlmv2dRF6E=;
 b=eUHubHDxtjyylPDdc7bFedowojWI9zLrQ6psYgTsmP3GTPLnhTiyG3JkHUedJyRGuV
 2eC7QcQGo03/1Q1arzvIjJknUW+aRLXuYxOvgHebRDZQ+7hdr2FgzaxHCH/W37K8ExbY
 9uhaQUa0ugMkV3wHWqJYNohGT7pEbAs0kvTvoALG1Idd6riRwTK8ubVHttvqg6pDcmgY
 R1VdJ2k/NjLhzNLeWBJXngB3Qv5y1wbhHQFfsF/Ri1L5Yh2n58lKXFT3Y2CGEQAj+riK
 Fl5HPuvhjJMALXNobtZyVFmABCcoh04VnbuWQBWv7Lpu4R2JoEVIcnsrmG4ADhqIYrQA
 rhBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=kyk+rbWBkERQd/V+m5Ky7yGxQv7VTu6C8mlmv2dRF6E=;
 b=SfP/dowPt2qeRvhame2bmOHRai941uRc+Xl4+59e1CLRPVZKdaUsyp1wqcmXFF9Oka
 PjzYhzEiWeeUcOb541MPDcvUomFxXbWf9qYKfqOzrEZwi/Liyw+n27+PP9I5cXWbK99x
 MFTfuEjEDBO6dmpkbLpVr/s6N2xlDs7I1NZ/rmTRg5YRftQDkM4hf2RwqAkuZ0IZjQbT
 idAVEVC+3JCxVSfEQX63QTNT3cmwfX2c16r2eTLHvbvOeeG7/5xs9689BbsPfhQkPVcv
 Uk551AH3XGImKhaWwWDavnKHfHSHur4jf8WP9O5Veof3zEbobX19uDBy1+S8iIYVqmSc
 cU8w==
X-Gm-Message-State: AOAM5315hJIeCjgalF28+nq8E0QanWB5SAj6UFtsFWzMBWwbxN876rkk
 SqMU+hWD5qzsLrkltQZUiXuKL6bVAa4=
X-Google-Smtp-Source: ABdhPJyMH3Sq1NjbgLuSEifGRtyldSI+jrBmr/Nsj225QWnfzIp+Bgns1yDUBBrraJg58Tk3MfA7ngTcz3A=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:7a04:: with SMTP id
 v4mr17335731ybc.261.1629072698596; 
 Sun, 15 Aug 2021 17:11:38 -0700 (PDT)
Date: Mon, 16 Aug 2021 00:11:28 +0000
In-Reply-To: <20210816001130.3059564-1-oupton@google.com>
Message-Id: <20210816001130.3059564-5-oupton@google.com>
Mime-Version: 1.0
References: <20210816001130.3059564-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 4/6] KVM: x86: Take the pvclock sync lock behind the
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
index b1e9a4885be6..f1434cd388b9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2533,7 +2533,6 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
 
 	kvm_vcpu_write_tsc_offset(vcpu, offset);
-	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
 	spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
 	if (!matched) {
@@ -2544,6 +2543,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 
 	kvm_track_tsc_matching(vcpu);
 	spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
+	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 }
 
 static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
