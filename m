Return-Path: <SRS0=rJEk=G7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03EF6C43381
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 10:47:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6937E64DCC
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 10:47:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6937E64DCC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E50CD4B0D7;
	Thu, 28 Jan 2021 05:47:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id itbMy5FUUHgY; Thu, 28 Jan 2021 05:47:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B53E74B1CC;
	Thu, 28 Jan 2021 05:47:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8572F4B1DB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 01:05:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DGweEXym6bZ3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Jan 2021 01:05:36 -0500 (EST)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 701B84B09F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 01:05:36 -0500 (EST)
Received: by mail-pf1-f170.google.com with SMTP id 11so3322475pfu.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jan 2021 22:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=UygKOqEf59SFJHMhhfR+HLz4CGF5Uv9S4hRfcJbt+yk=;
 b=Qh8VODAieLH4894A4MDu3uPPXE5kLO4XxZpYmBxJ82EmJjvCd38+PvJXeC7WfYCIBI
 64aPWxpI+2Wuja2TEV1w1O7J/k/33st78VPhJvOw7GI1Ov6clXkA1iu5LQJ5MR4dUH8V
 v91cI0vNifEcoZnWwsn/8BSJmyZEYnqUhOWFg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=UygKOqEf59SFJHMhhfR+HLz4CGF5Uv9S4hRfcJbt+yk=;
 b=qTgXRVOvOyT/UbCKR6oROsu+EmBHC1m8W4q37gH1SzQAx+L/HxWQW9kQymjwf1SD1e
 MgvsnbNASlyz4ddqk4bOPOS1VIv18T+uXMqYScdNIgYfQK4Sp8kDyxZMint+yXsjtCF2
 KpoGj4Ozffjt43hcyf2Cqzhf7OEH9xIGffNUuIBb77YZwLbFCcYrUf9AfkGd1zNZH/n/
 v6Nj7J8kv30LOwOtLEiYqzZFNRNcTJPE51i0peiAWxeP7skGMOtv3ZNjtaWjeptfQiH3
 +ksUGqr9oRTz+bNYSSMWuAegqBAsjs2exCReNFbF7FjSaI3DULjfuxFtQ9PW8sy8598Q
 xDjA==
X-Gm-Message-State: AOAM532bB3x9ilqlIRbEzMQzRHCqmpsY9vUyxycixVCi5VM8PDxjyv2c
 x2OpEQBsG6q/3CgDiKK1fsmpWg==
X-Google-Smtp-Source: ABdhPJx6bZB3eesMD+UMxqDOEfHH1P0CPHJvUJWhsABLqESuXZOj3BsZQpCR3iBz434VwICAw3KJ+g==
X-Received: by 2002:a62:bd05:0:b029:1ab:6d2:5edf with SMTP id
 a5-20020a62bd050000b02901ab06d25edfmr14361887pff.32.1611813935673; 
 Wed, 27 Jan 2021 22:05:35 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:919f:d6:7815:52bc])
 by smtp.gmail.com with ESMTPSA id s73sm4388027pgc.46.2021.01.27.22.05.31
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 27 Jan 2021 22:05:35 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: [PATCH v3 1/2] KVM: x86/mmu: Skip mmu_notifier check when handling
 MMIO page fault
Date: Thu, 28 Jan 2021 15:05:14 +0900
Message-Id: <20210128060515.1732758-2-stevensd@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
In-Reply-To: <20210128060515.1732758-1-stevensd@google.com>
References: <20210128060515.1732758-1-stevensd@google.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Thu, 28 Jan 2021 05:47:29 -0500
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

From: Sean Christopherson <seanjc@google.com>

Don't retry a page fault due to an mmu_notifier invalidation when
handling a page fault for a GPA that did not resolve to a memslot, i.e.
an MMIO page fault.  Invalidations from the mmu_notifier signal a change
in a host virtual address (HVA) mapping; without a memslot, there is no
HVA and thus no possibility that the invalidation is relevant to the
page fault being handled.

Note, the MMIO vs. memslot generation checks handle the case where a
pending memslot will create a memslot overlapping the faulting GPA.  The
mmu_notifier checks are orthogonal to memslot updates.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 2 +-
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d16481aa29d..9ac0a727015d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3725,7 +3725,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 	r = RET_PF_RETRY;
 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
+	if (!is_noslot_pfn(pfn) && mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
 	r = make_mmu_pages_available(vcpu);
 	if (r)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 50e268eb8e1a..ab54263d857c 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -869,7 +869,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 
 	r = RET_PF_RETRY;
 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
+	if (!is_noslot_pfn(pfn) && mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
 
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
-- 
2.30.0.280.ga3ce27912f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
