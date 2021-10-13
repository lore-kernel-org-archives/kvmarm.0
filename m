Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600C9C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:59:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 134D5611CB
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:59:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 134D5611CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B92844B132;
	Wed, 13 Oct 2021 11:59:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WJwibW2sAGqs; Wed, 13 Oct 2021 11:59:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95A294B15C;
	Wed, 13 Oct 2021 11:59:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 434AF4B132
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:59:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m-EKWteVnuOB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 11:59:05 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7AB484B176
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:59:04 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 hf12-20020a0562140e8c00b00382cdfe644eso2919126qvb.23
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=DEoxdh+qQqNfn4kriXOPtuGm5/KezrtRJAuAEOvIIEc=;
 b=TpLWDDRB66gNFtTO9H4DRYs+65J/g5K+vn3S4IswImh0cKDwKxr4tBSjZcRccVl/Gl
 PA7nAXYwmNvaJhrKw46Ts3VNmjOrJZAny7BGVWCNErEuHLrCRinaJt33ySp3tdu1rhlU
 ObF8iMNmln/oDydOezVDr5M8tvVtysJpT8v+dFboU9XBwY12v9a9YJdoISKQDzlPyc89
 gwxqYq45K+oRmNXwFvSb/RgfedaC9VADqHJA3tsa8lwe9+sahvN4PIU9zbtzmjuqi1TS
 TY2B5+x2nY3sIMBjjwqLbn3F5AEhqAsehabz6sua9uKu7eipWBEh68yQaYKn6biu+OzM
 jw3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=DEoxdh+qQqNfn4kriXOPtuGm5/KezrtRJAuAEOvIIEc=;
 b=au8m2DqQs+d+dH0o529hHDaDIU6tkbDh+VUxUCHYPPJFrwQlVJEUrcF589VK43iDeg
 P/48kyAlTN1qY+HRr600+wc/QDkuRJ+IJ5vGFBszUsUX+FJmiTn3E0ODwXvaQkXchkcV
 cvPzLdMXku7Wb3wX0D0fZ3LmEQj5gD8sG6StvvZqjHTydvcL6vGginVLcANrJIlergMa
 mf00dzRGU9MnKpolgORY6gI3djs94belgtkP7OJV9qJM31igUyNdSK3SQdd8js0emTGt
 bK9zxHBnJIHsDl50cWtixqtm1nLwg5/LmABZW78GtW7NEJb254eXTTQyRog7HfzRQIxA
 6/GA==
X-Gm-Message-State: AOAM532r6UPb/u6YKMqCyHhGeyEo+sczcS9M36WLxXBucXmEfUj+nUUB
 0EBb2oO1w9/Q9kxCKI6ciLn+jfQRnZlb
X-Google-Smtp-Source: ABdhPJxxY5hYqLzNoNmIsVUGeAsrdYoGroAg6GyRP+fKCKJAdv6jBH4kuWvly/Nv7EL03M4qWkxiLE/AW3NG
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:65b5:73d3:1558:b9ae])
 (user=qperret job=sendgmr) by 2002:ac8:5385:: with SMTP id
 x5mr73629qtp.105.1634140744121; Wed, 13 Oct 2021 08:59:04 -0700 (PDT)
Date: Wed, 13 Oct 2021 16:58:28 +0100
In-Reply-To: <20211013155831.943476-1-qperret@google.com>
Message-Id: <20211013155831.943476-14-qperret@google.com>
Mime-Version: 1.0
References: <20211013155831.943476-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 13/16] KVM: arm64: Move double-sharing logic into hyp-specific
 function
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, David Brazdil <dbrazdil@google.com>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

From: Will Deacon <will@kernel.org>

Strictly speaking, double-sharing a page is an invalid transition and
should be rejected, however we allow this in order to simplify the
book-keeping when KVM metadata (such as vcpu structures) co-exists in
the same page.

Given that double-sharing is only required for pages shared with the
hypervisor by the host, move the handling into a hyp-specific function
to check incoming shares, therefore preventing double-sharing outside
of this particular transition.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 57 +++++++++++++++++++--------
 1 file changed, 41 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 909e60f71b06..3378117d010c 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -536,6 +536,33 @@ static int ack_share(struct pkvm_page_share_ack *ack,
 	}
 }
 
+static int hyp_check_incoming_share(struct pkvm_page_req *req,
+				    struct pkvm_page_share_ack *ack,
+				    enum pkvm_component_id initiator,
+				    enum kvm_pgtable_prot prot)
+{
+	/*
+	 * We allow the host to share the same page twice, but that means we
+	 * have to check that the states really do match exactly.
+	 */
+	if (initiator != PKVM_ID_HOST)
+		return -EPERM;
+
+	if (req->initiator.state != PKVM_PAGE_SHARED_OWNED)
+		return -EPERM;
+
+	if (ack->completer.state != PKVM_PAGE_SHARED_BORROWED)
+		return -EPERM;
+
+	if (ack->completer.phys != req->phys)
+		return -EPERM;
+
+	if (ack->completer.prot != prot)
+		return -EPERM;
+
+	return 0;
+}
+
 /*
  * Check that the page states in the initiator and the completer are compatible
  * for the requested page-sharing operation to go ahead.
@@ -544,6 +571,8 @@ static int check_share(struct pkvm_page_req *req,
 		       struct pkvm_page_share_ack *ack,
 		       struct pkvm_mem_share *share)
 {
+	struct pkvm_mem_transition *tx = &share->tx;
+
 	if (!addr_is_memory(req->phys))
 		return -EINVAL;
 
@@ -552,25 +581,22 @@ static int check_share(struct pkvm_page_req *req,
 		return 0;
 	}
 
-	if (req->initiator.state != PKVM_PAGE_SHARED_OWNED)
-		return -EPERM;
-
-	if (ack->completer.state != PKVM_PAGE_SHARED_BORROWED)
-		return -EPERM;
-
-	if (ack->completer.phys != req->phys)
-		return -EPERM;
-
-	if (ack->completer.prot != share->prot)
+	switch (tx->completer.id) {
+	case PKVM_ID_HYP:
+		return hyp_check_incoming_share(req, ack, tx->initiator.id,
+						share->prot);
+	default:
 		return -EPERM;
-
-	return 0;
+	}
 }
 
 static int host_initiate_share(struct pkvm_page_req *req)
 {
 	enum kvm_pgtable_prot prot;
 
+	if (req->initiator.state == PKVM_PAGE_SHARED_OWNED)
+		return 0;
+
 	prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, PKVM_PAGE_SHARED_OWNED);
 	return host_stage2_idmap_locked(req->initiator.addr, PAGE_SIZE, prot);
 }
@@ -595,6 +621,9 @@ static int hyp_complete_share(struct pkvm_page_req *req,
 	void *start = (void *)req->completer.addr, *end = start + PAGE_SIZE;
 	enum kvm_pgtable_prot prot;
 
+	if (req->initiator.state == PKVM_PAGE_SHARED_OWNED)
+		return 0;
+
 	prot = pkvm_mkstate(perms, PKVM_PAGE_SHARED_BORROWED);
 	return pkvm_create_mappings_locked(start, end, prot);
 }
@@ -653,10 +682,6 @@ static int do_share(struct pkvm_mem_share *share)
 		if (ret)
 			break;
 
-		/* Allow double-sharing by skipping over the page */
-		if (req.initiator.state == PKVM_PAGE_SHARED_OWNED)
-			continue;
-
 		ret = initiate_share(&req, share);
 		if (ret)
 			break;
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
