Return-Path: <SRS0=oSDe=EA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B5EEC2D0A3
	for <kvmarm@archiver.kernel.org>; Sun, 25 Oct 2020 00:27:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BE0E1222EC
	for <kvmarm@archiver.kernel.org>; Sun, 25 Oct 2020 00:27:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cDxMjEOH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE0E1222EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E32E4B964;
	Sat, 24 Oct 2020 20:27:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fvol1BPX3G+y; Sat, 24 Oct 2020 20:27:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DEC84BA95;
	Sat, 24 Oct 2020 20:27:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B02B34B964
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Oct 2020 20:27:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PKkjW+d-1Ozj for <kvmarm@lists.cs.columbia.edu>;
 Sat, 24 Oct 2020 20:27:53 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E71AE4BA2A
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Oct 2020 20:27:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1603585673;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=+kiLTLWXvdvNLO/Lho7ZJ26fCsvANtnb1Y/54wg1w2o=;
 b=cDxMjEOH8xwIZKEP5DW/3O8Ma2rDwJXM7jANaAG7EUXD3iymmKqmkfHD5x2FSPo504Hnj8
 A9yEryww75wc0obsERq+Hpy/99a7ImeE6qjahH2900vVSJ1OBgsfM3ZH+4ThVPRDju3lQp
 LHjPfBtkpzoTSLml0udgnAKWJaRlung=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-qQd-4mqMPWSpf7hRneaOGA-1; Sat, 24 Oct 2020 20:27:51 -0400
X-MC-Unique: qQd-4mqMPWSpf7hRneaOGA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BBC1185A0D9;
 Sun, 25 Oct 2020 00:27:50 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-35.bne.redhat.com [10.64.54.35])
 by smtp.corp.redhat.com (Postfix) with ESMTP id D152D5C1DA;
 Sun, 25 Oct 2020 00:27:48 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 2/3] KVM: arm64: Don't map PUD huge page if it's not available
Date: Sun, 25 Oct 2020 11:27:38 +1100
Message-Id: <20201025002739.5804-3-gshan@redhat.com>
In-Reply-To: <20201025002739.5804-1-gshan@redhat.com>
References: <20201025002739.5804-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: will@kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org
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

PUD huge page isn't available when CONFIG_ARM64_4K_PAGES is disabled.
In this case, we needn't try to map the memory through PUD huge pages
to save some CPU cycles in the hot path.

This also corrects the code style issue, which was introduced by
commit <523b3999e5f6> ("KVM: arm64: Try PMD block mappings if PUD mappings
are not supported").

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a816cb8e619b..0f51585adc04 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -787,9 +787,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		vma_shift = PAGE_SHIFT;
 	}
 
+#ifdef CONFIG_ARM64_4K_PAGES
 	if (vma_shift == PUD_SHIFT &&
 	    !fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
-	       vma_shift = PMD_SHIFT;
+		vma_shift = PMD_SHIFT;
+#endif
 
 	if (vma_shift == PMD_SHIFT &&
 	    !fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
