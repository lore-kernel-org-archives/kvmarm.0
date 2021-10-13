Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FF17C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:59:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C168C611B0
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:59:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C168C611B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 758834B103;
	Wed, 13 Oct 2021 11:59:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OJpApeP-k-0L; Wed, 13 Oct 2021 11:59:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0CD24B153;
	Wed, 13 Oct 2021 11:59:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 470814B14C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:59:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GAQ3xeo42Ig6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 11:59:07 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E2C84A5A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:59:07 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 75-20020adf82d1000000b00160cbb0f800so2323197wrc.22
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=5BoaM6D6gNLK4spf2rCygUFZYyg82caSdHjxEWdrlQU=;
 b=lCYZR0Kok1ZJ/F1Bc4qnzND5K7Zjs/qag8dPQUKLfKY1Vuju+0hrk97PbxTbLFIE92
 dhF98EBgTqhqQt92nIfoE7GMC2K4/ghR4OjSzZq65MJp4AT7ibXNQwUHSePHfSjriq+s
 qj1OBYf3ab/2GRzkKLmCCNN9sNsIntPaQklJ6mwQ/XKR3fKPsRo3EWTXDVVPSTrHWBVD
 1rD/QwOnSIbGCAAkjEKSTIRdQXrNpoLM7Rs+deBDWlZEA49xNVEQoxCXD+YunfwM3WR5
 9SFni/ujR7WAYzyn4Pom8B/djSepucfAa3KiUobigruMi97cJGEedWHGkG8p0udLt1y2
 BQTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=5BoaM6D6gNLK4spf2rCygUFZYyg82caSdHjxEWdrlQU=;
 b=CiwPhHfaB8Q4BvVpeCsDsFStFviUGB3+PjyehZ0y4CcAQFy8oYtwCRX4V7EoQFvI2A
 naMjCRGk0vkYTXbdCxL0AaLa8YBz13FhbNj+dF6QQGaTx+EAuj6xkGUqdFhYxNm0LYds
 wb/NSviZGnYU3Zxd0NHoSvUG1neUhq8BopdKnDUfV7cEfbzkxGUMvCrYXaLGpQ31HG10
 sQBY/2Nv7gzQKdpvYIkg7rHKwnG0B+dqQZPVM7RrCQXzY+jMetwmdyHBqkWymDZ6d195
 xK5GKLbbcsSyrBLX1j2witGHZ0HLULvdISIe9UOP2mNJqiwzMsQcPVE4jt/N8YPYd5Me
 rw5Q==
X-Gm-Message-State: AOAM532HZ/vuSgJMJjbH9Gk983j8JjbW+1DyDB+kE/qZwabdure/u1CX
 wGtgPI84wtJGMx1qHEwiR0fWtgkIQ5yY
X-Google-Smtp-Source: ABdhPJycAkElHpHQ2AGMbSwm3DR+JicypQn/HrqmtGvR6c4BW8hrAjG63/uNsstYDVBkOL0PzEyul2i7qtoG
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:65b5:73d3:1558:b9ae])
 (user=qperret job=sendgmr) by 2002:a7b:cd90:: with SMTP id
 y16mr93339wmj.146.1634140746365; Wed, 13 Oct 2021 08:59:06 -0700 (PDT)
Date: Wed, 13 Oct 2021 16:58:29 +0100
In-Reply-To: <20211013155831.943476-1-qperret@google.com>
Message-Id: <20211013155831.943476-15-qperret@google.com>
Mime-Version: 1.0
References: <20211013155831.943476-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 14/16] KVM: arm64: Refcount shared pages at EL2
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

We currently allow double sharing of pages from the hypervisor to the
host, but don't track how many times each page is shared. In order to
prepare the introduction of an unshare operation in the hypervisor,
refcount the physical pages which the host shares more than once.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 3378117d010c..cad76bc68e53 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -560,6 +560,9 @@ static int hyp_check_incoming_share(struct pkvm_page_req *req,
 	if (ack->completer.prot != prot)
 		return -EPERM;
 
+	if (WARN_ON(!hyp_phys_to_page(req->phys)->refcount))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -619,13 +622,22 @@ static int hyp_complete_share(struct pkvm_page_req *req,
 			      enum kvm_pgtable_prot perms)
 {
 	void *start = (void *)req->completer.addr, *end = start + PAGE_SIZE;
+	struct hyp_page *page = hyp_phys_to_page(req->phys);
 	enum kvm_pgtable_prot prot;
+	int ret = 0;
 
-	if (req->initiator.state == PKVM_PAGE_SHARED_OWNED)
+	if (req->initiator.state == PKVM_PAGE_SHARED_OWNED) {
+		hyp_page_ref_inc(page);
 		return 0;
+	}
 
 	prot = pkvm_mkstate(perms, PKVM_PAGE_SHARED_BORROWED);
-	return pkvm_create_mappings_locked(start, end, prot);
+	ret = pkvm_create_mappings_locked(start, end, prot);
+
+	if (!ret)
+		hyp_set_page_refcounted(page);
+
+	return ret;
 }
 
 /* Update the completer's page-table for the page-sharing request */
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
