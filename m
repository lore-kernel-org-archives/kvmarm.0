Return-Path: <SRS0=WrEh=O4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 324B2C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 15:58:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BA4976101E
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 15:58:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BA4976101E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 551814B11A;
	Fri,  8 Oct 2021 11:58:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JvRLVOXvYa2F; Fri,  8 Oct 2021 11:58:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC4824B14C;
	Fri,  8 Oct 2021 11:58:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAC734B11A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 11:58:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NEe1REilIlJJ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 11:58:40 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E6BC34B0DE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 11:58:39 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 p12-20020adfc38c000000b00160d6a7e293so5177972wrf.18
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 08:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=2yxyszH2o0l7PmvxhJ6rJ+q2kN5pLUdYHnvLPGFqiZk=;
 b=J7ojB2L/g6easuNtOb22T/bQnMBxvkq3yUNrthr9utdVDUVUQvrpyTfNFPqwVu2eNS
 4fvbnv3QwvHgJJCEN1reAisHNn3uROCmL4+zKkTv1zf/x431NyReyFWKolpcKmG85ExA
 1DGKgEJQ3md+BSdcLbo8Bx5UHXABjwMwPbkgsY7SEGMRiI7YcbLHUg7GqzxbzoJ8BiW4
 dK0x+od77qfQ6LvIMcXTTaXtjqeDwOTPItHT+czA5cDDunOoXl6VicpvULiF55DuXn2h
 to/la/+v+M1gJThoSI6bKe3P2gBDxju2tQGS71CmPsvK+uhxXyofScxX0HQlMT13zeWy
 kACA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=2yxyszH2o0l7PmvxhJ6rJ+q2kN5pLUdYHnvLPGFqiZk=;
 b=L0x2MLuNzEiKDy0pdBGRlPvQCxbOxBbpMwR7EebMPPps7cz2NFly2Vlv6tVBjDPhsf
 XOVYrbI1+dbTUyz+NKH7vpmwFQ2wHjyx6ThzO8Im4KS2JexXUEQ9CFC7GnF6FMa6xSSc
 LRmFCpA/QPUNJamYgaaljC5XQFiRT7WSStM6N2e2Jox/WgtH9eC8O47PHHqEiklt2ROG
 kdeoEyOX2X7yPxzLFLfN5A1ktIugnNgjsUMPgBJxKr5zGmvpleYBR5H4sXiXktBL764m
 0sLl9I3U/yHgg6fduOI8xKH5tpBrUaMfgSLOI1hZFr48E9+mTOQumSTu4kNMsxYhIKL9
 7NDw==
X-Gm-Message-State: AOAM532yNc7NlP6Ef+xe6+m2pdQV1rHZUsOG4bRJjS4XxO7Ck6uklNzM
 /xD8JsOBi7kXxSpKpfTQB1b1+oC5+7FZebSb8WshAG/zK55sumkYNkU3by4Ian6Rdzp23FXdZwL
 TTYGbK3hHK3Zt1PwfWLsHipXu5Dg9jYczkyKA5O0UyI4nGJe9udASI+Vy+e0Cc6q81uU=
X-Google-Smtp-Source: ABdhPJyu2z910e5hVmwkJoNrLtH1WXLkELfPaK2bV3KGfSoooZdoGdTRArUTVIRMq5kDX+ZAV2ffP5h4Dg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:e906:: with SMTP id
 q6mr4515684wmc.126.1633708718952; 
 Fri, 08 Oct 2021 08:58:38 -0700 (PDT)
Date: Fri,  8 Oct 2021 16:58:23 +0100
In-Reply-To: <20211008155832.1415010-1-tabba@google.com>
Message-Id: <20211008155832.1415010-3-tabba@google.com>
Mime-Version: 1.0
References: <20211008155832.1415010-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v7 02/11] KVM: arm64: Don't include switch.h into
 nvhe/kvm-main.c
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

From: Marc Zyngier <maz@kernel.org>

hyp-main.c includes switch.h while it only requires adjust-pc.h.
Fix it to remove an unnecessary dependency.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2da6aa8da868..8ca1104f4774 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -4,7 +4,7 @@
  * Author: Andrew Scull <ascull@google.com>
  */
 
-#include <hyp/switch.h>
+#include <hyp/adjust_pc.h>
 
 #include <asm/pgtable-types.h>
 #include <asm/kvm_asm.h>
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
