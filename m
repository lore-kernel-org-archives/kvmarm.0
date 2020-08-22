Return-Path: <SRS0=YmwB=CA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B07DC433DF
	for <kvmarm@archiver.kernel.org>; Sat, 22 Aug 2020 02:45:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 15AB220732
	for <kvmarm@archiver.kernel.org>; Sat, 22 Aug 2020 02:45:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iaG6vUAz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15AB220732
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AB2D4C93D;
	Fri, 21 Aug 2020 22:45:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eNrtWHcpbEhx; Fri, 21 Aug 2020 22:45:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E61E4C946;
	Fri, 21 Aug 2020 22:45:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37C7D4C944
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Aug 2020 22:45:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ydEhBqbVdWZZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Aug 2020 22:45:18 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A4C84C93D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Aug 2020 22:45:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1598064318;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=aMzOQRaN2o5I6TArv6fJoe/1hFp9FqCYJbD+abMCtHc=;
 b=iaG6vUAzrJmYl/Vjo32jLCu6spun0ZGGWOjf1NMrPGtTSpRi8jHlFCcXGwzXEGhq11DOUI
 JM+rM4lD0dh85PDhO5dWnVOcHoq2kNRi+XeSbT6aTbtNe0RXpX36GsC1wE5J/lRGuBADjD
 2hNbDkjxvGfAQiOWekl42yXx8sGMzlg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-T9GQ_OSDOimbt6nXsLXPXA-1; Fri, 21 Aug 2020 22:45:15 -0400
X-MC-Unique: T9GQ_OSDOimbt6nXsLXPXA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6CEF8030DD;
 Sat, 22 Aug 2020 02:45:14 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-106.bne.redhat.com [10.64.54.106])
 by smtp.corp.redhat.com (Postfix) with ESMTP id D0E201014176;
 Sat, 22 Aug 2020 02:45:09 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH] arm64/kvm: Fix zapping stage2 page table wrongly
Date: Sat, 22 Aug 2020 12:44:44 +1000
Message-Id: <20200822024444.28132-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: redhat.com
Cc: shan.gavin@gmail.com, maz@kernel.org
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

Depending on the kernel configuration, PUD_SIZE could be equal to
PMD_SIZE. For example, both of them are 512MB with the following
kernel configuration. In this case, both PUD and PMD are folded
to PGD.

   CONFIG_ARM64_64K_PAGES   y
   CONFIG_ARM64_VA_BITS     42
   CONFIG_PGTABLE_LEVELS    2

With the above configuration, the stage2 PUD is used to backup the
512MB huge page when the stage2 mapping is built. During the mapping,
the PUD and its subordinate levels of page table entries are unmapped
if the PUD is present and not huge page sensitive in stage2_set_pud_huge().
Unfornately, the @addr isn't aligned to S2_PUD_SIZE and wrong page table
entries are zapped. It eventually leads to PUD's present bit can't be
cleared successfully and infinite loop in stage2_set_pud_huge().

This fixes the issue by checking with S2_{PUD, PMD}_SIZE instead of
{PUD, PMD}_SIZE to determine if stage2 PUD or PMD is used to back the
huge page. For this particular case, the stage2 PMD entry should be
used to backup the 512MB huge page with stage2_set_pmd_huge().

Fixes: 3c3736cd32bf ("KVM: arm/arm64: Fix handling of stage2 huge mappings")
Cc: stable@vger.kernel.org # v5.1+
Reported-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arch/arm64/kvm/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0121ef2c7c8d..deb1819ba9e2 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1964,7 +1964,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		(fault_status == FSC_PERM &&
 		 stage2_is_exec(mmu, fault_ipa, vma_pagesize));
 
-	if (vma_pagesize == PUD_SIZE) {
+	if (vma_pagesize == S2_PUD_SIZE) {
 		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);
 
 		new_pud = kvm_pud_mkhuge(new_pud);
@@ -1975,7 +1975,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			new_pud = kvm_s2pud_mkexec(new_pud);
 
 		ret = stage2_set_pud_huge(mmu, memcache, fault_ipa, &new_pud);
-	} else if (vma_pagesize == PMD_SIZE) {
+	} else if (vma_pagesize == S2_PMD_SIZE) {
 		pmd_t new_pmd = kvm_pfn_pmd(pfn, mem_type);
 
 		new_pmd = kvm_pmd_mkhuge(new_pmd);
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
