Return-Path: <SRS0=jshR=CN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00091C28E83
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 10:46:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A53C720770
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 10:46:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="rUoZVg/I"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A53C720770
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 608094B365;
	Fri,  4 Sep 2020 06:46:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z-bonD7OWIhu; Fri,  4 Sep 2020 06:46:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 717B04B395;
	Fri,  4 Sep 2020 06:46:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E3264B387
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 06:46:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c8BI1LKaSnve for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2020 06:46:12 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA1134B371
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 06:46:07 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C5B5820C56;
 Fri,  4 Sep 2020 10:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599216366;
 bh=nCc55AZ3IGOEPrvp66HRc9DIbXCNXgxfLuV2k8RKjKk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=rUoZVg/IjoiVzDx4ku/+fP10lSWGwkW6n/0IGghZaq1Zamg67QAq/IMENy0PZZckW
 JOGO7ScY01EetEYlUnNOJHCHLkzXXtjX9f2Ba8YASKYcUR9+XHawtuzyodpq7NvZ3G
 diwah0+HwJcDfuPEbXoLLjrfMHbaqbx0C3l4gU2c=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kE9EL-0098oH-6W; Fri, 04 Sep 2020 11:46:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 9/9] KVM: arm64: Update page shift if stage 2 block mapping
 not supported
Date: Fri,  4 Sep 2020 11:45:30 +0100
Message-Id: <20200904104530.1082676-10-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200904104530.1082676-1-maz@kernel.org>
References: <20200904104530.1082676-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 drjones@redhat.com, eric.auger@redhat.com, gshan@redhat.com,
 steven.price@arm.com, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

From: Alexandru Elisei <alexandru.elisei@arm.com>

Commit 196f878a7ac2e (" KVM: arm/arm64: Signal SIGBUS when stage2 discovers
hwpoison memory") modifies user_mem_abort() to send a SIGBUS signal when
the fault IPA maps to a hwpoisoned page. Commit 1559b7583ff6 ("KVM:
arm/arm64: Re-check VMA on detecting a poisoned page") changed
kvm_send_hwpoison_signal() to use the page shift instead of the VMA because
at that point the code had already released the mmap lock, which means
userspace could have modified the VMA.

If userspace uses hugetlbfs for the VM memory, user_mem_abort() tries to
map the guest fault IPA using block mappings in stage 2. That is not always
possible, if, for example, userspace uses dirty page logging for the VM.
Update the page shift appropriately in those cases when we downgrade the
stage 2 entry from a block mapping to a page.

Fixes: 1559b7583ff6 ("KVM: arm/arm64: Re-check VMA on detecting a poisoned page")
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Link: https://lore.kernel.org/r/20200901133357.52640-2-alexandru.elisei@arm.com
---
 arch/arm64/kvm/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 16b8660ddbcc..f58d657a898d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1871,6 +1871,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	    !fault_supports_stage2_huge_mapping(memslot, hva, vma_pagesize)) {
 		force_pte = true;
 		vma_pagesize = PAGE_SIZE;
+		vma_shift = PAGE_SHIFT;
 	}
 
 	/*
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
