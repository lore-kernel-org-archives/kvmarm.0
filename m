Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9F9AC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 18 Jan 2022 01:57:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3ACD040FAB;
	Mon, 17 Jan 2022 20:57:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id frdJBA-9ZVVU; Mon, 17 Jan 2022 20:57:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE11D49E3F;
	Mon, 17 Jan 2022 20:57:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30F7749E49
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 20:57:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pfBAro6p8S-i for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Jan 2022 20:57:12 -0500 (EST)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D82249E46
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 20:57:11 -0500 (EST)
Received: by mail-pg1-f202.google.com with SMTP id
 j186-20020a636ec3000000b00340c5f3a0cbso8589755pgc.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 17:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=FFJ0LKVBXmV+PQlVXimlN+9PR3R1f2e8LV1lWAds9CU=;
 b=pfvIFT7tUQ/lfy5xV/tlxtndZnM0AlSEqqjfbmpgRPXnF0D+BHDAvTalj9NsO+HEPq
 mSksHH9PCLFVenOrrjwk6g8CIKYlWCpf9xvEq5H+TgteXC37n+OXomLW9LvYHuVof9Qp
 5jwBfAvBbhY+qMSlMX6ss1g6P4zYIh/ismtJXFIyHek36v9da2fltoPoiR0rKUfnfn9t
 aeqqWj6NxMnvm8p32CgwWtSYBMmmYiq6jJwtYk/7oLFqm74Xlx8QJJAq+4W3o65Sb3or
 aN6CWExuC6Og1Jt6whszPn/rwoquDJpfo/DNmcTzJ9LCsmHsOEIhVmi+X/HpN69Dfufm
 j/eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=FFJ0LKVBXmV+PQlVXimlN+9PR3R1f2e8LV1lWAds9CU=;
 b=j+qUodbqL+uHpTJBVxf4eRt90BSDeejmzHBG67yh7ZxY3u/q8YXyxstvzW3eRXrMq4
 OK6P7TiTzPljZQjIHP8bwMMnwtF3nSRV+n2/tGkeg2uqJy753C6Uhdgn6Grr9WfltpJv
 +c7hH+5clc3gryOY/GW/1RqRqExiMYSx7v/EAByTEANDBmuGrj/nDk+P9gCJqtA/rVWa
 Zb9msxwgOagQdLv1iD29olfm92thKZYQl0rWH9DAyRbrsXRdxKwLTmwrFKNNLu6JUSF8
 LYzHvVsml9Vhvcz3QVdF5LxmKGQIy9cKOzyWJcEW6jdXSqipaRp8axezCleIXezLlYw6
 doyQ==
X-Gm-Message-State: AOAM5339RiS62mwl8KhWZ4e2cIPBb+zWBcLDnTTIdQF3jPQDQXpDdclr
 uoL8INO0YFpf53e9Kldam5hpyyBD8EcdnYCbkA==
X-Google-Smtp-Source: ABdhPJxhGRe+V900JEd7wGouyItkJhnzMy8lso2rLIVPW2lAzYzOWPMFZVPT+b8tM61zC+Z0DPCs4S/OSQ9SimggFw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90b:3a89:: with SMTP id
 om9mr7859711pjb.103.1642471030415;
 Mon, 17 Jan 2022 17:57:10 -0800 (PST)
Date: Tue, 18 Jan 2022 01:57:02 +0000
In-Reply-To: <20220118015703.3630552-1-jingzhangos@google.com>
Message-Id: <20220118015703.3630552-3-jingzhangos@google.com>
Mime-Version: 1.0
References: <20220118015703.3630552-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 2/3] KVM: arm64: Add fast path to handle permission
 relaxation during dirty logging
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>, 
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, 
 David Matlack <dmatlack@google.com>, Oliver Upton <oupton@google.com>, 
 Reiji Watanabe <reijiw@google.com>, Ricardo Koller <ricarkol@google.com>, 
 Raghavendra Rao Ananta <rananta@google.com>
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

To reduce MMU lock contention during dirty logging, all permission
relaxation operations would be performed under read lock.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/mmu.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index cafd5813c949..10df5d855d54 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1080,6 +1080,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
+	bool logging_perm_fault = false;
 	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
 	unsigned long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
@@ -1114,6 +1115,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (logging_active) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
+		logging_perm_fault = (fault_status == FSC_PERM && write_fault);
 	} else {
 		vma_shift = get_vma_page_shift(vma, hva);
 	}
@@ -1212,7 +1214,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault && device)
 		return -ENOEXEC;
 
-	write_lock(&kvm->mmu_lock);
+	/*
+	 * To reduce MMU contentions and enhance concurrency during dirty
+	 * logging dirty logging, only acquire read lock for permission
+	 * relaxation.
+	 */
+	if (logging_perm_fault)
+		read_lock(&kvm->mmu_lock);
+	else
+		write_lock(&kvm->mmu_lock);
 	pgt = vcpu->arch.hw_mmu->pgt;
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		goto out_unlock;
@@ -1271,7 +1281,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 out_unlock:
-	write_unlock(&kvm->mmu_lock);
+	if (logging_perm_fault)
+		read_unlock(&kvm->mmu_lock);
+	else
+		write_unlock(&kvm->mmu_lock);
 	kvm_set_pfn_accessed(pfn);
 	kvm_release_pfn_clean(pfn);
 	return ret != -EAGAIN ? ret : 0;
-- 
2.34.1.703.g22d0c6ccf7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
