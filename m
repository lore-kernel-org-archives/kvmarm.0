Return-Path: <SRS0=fzUG=OL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7DCC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 17:11:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 93393611CE
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 17:11:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 93393611CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 387964B089;
	Tue, 21 Sep 2021 13:11:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QZSeo1N7Jj5L; Tue, 21 Sep 2021 13:11:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 333FB4A7FD;
	Tue, 21 Sep 2021 13:11:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24D4649F6C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 13:11:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 03M4IcOBygmo for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 13:11:26 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4AFA9402DB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 13:11:26 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 z16-20020ac86b90000000b0029eec160182so219473351qts.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 10:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=jzWR7Fq+/HAR8FRZ5CmWSQlSyJSKtGaA1okeOYzuzGU=;
 b=SRNa1zbX4Hlo2D0JzsaExaDQ/o+xv5a3XVc2p1Ds3bUplbwmS3q6FzHFGfO6viO3tx
 UryxD6046QZNjR9r+69hcdSw2WNjndojahCKDtDMVFLbsnQLby9zo1kaKVVSvhYZ35Ab
 N1XuaLB9ymwxPiDzOqnDCatr7f+AnGBW/FZ8jw1+tXmchZcorWtKXb7X+iVDB6Lsnw+6
 Dr7bGpQ5U09p+edUYGyTkyxZocA6S25DGmN6ZVbyhQ5KMRM1oJBRrg5DQUDEyg2nDsTl
 TBLDdFnK5k+0atVZS7dXSqIDQ16oPe7jTkoMHF5iu43OgOpq3zC+jP+TJoPPbSPfsvgV
 l6yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=jzWR7Fq+/HAR8FRZ5CmWSQlSyJSKtGaA1okeOYzuzGU=;
 b=z/VS6zHUs6Wq8oVji3Q8Nf+HB6Jq8kv4/VRFFlPk8w4WqWkcST/2ARV4mT8RepZgE/
 hJdtA9eqMCLTkp/uQL67a9eYkipUBqm8z259NAdDKOrqvAVdHgY8xDSckH36yYHKzqAd
 xN2OQhjrmZ/sBykNoNMG/V7IudMEfoztjhb1OeKmK+g4s1jVMu/eY40GrB0SskyVTpR2
 xpSElYZpB3uw8IYP3o969cpm9yfc/TClPs53I9H2n59oeoy6P32POpZTGsB5RTgKzzsG
 YTTGo0AE7FrKn7+q1CNAjjApaj/fD0jUDuC48Ns7UCuttCzEi/BtoKyDjvHB3PGH8ema
 tn7Q==
X-Gm-Message-State: AOAM533gqWKfEeC5VYHZT3Tv/6IX0U4aLQz7Fq+1sXdgPYAaU2iEJs7k
 EOdLu4h8nVZky4h5YDYAwoYxsm23nGk=
X-Google-Smtp-Source: ABdhPJxTaVdhnf2NYKqOfGZMxyn1rqiFJZMJSy1HY3CHx0lbCdjT7xpbhLQC0Atg6HG9LiGEYTEt9oY+BH8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:eb0b:: with SMTP id
 d11mr37032784ybs.101.1632244285806; 
 Tue, 21 Sep 2021 10:11:25 -0700 (PDT)
Date: Tue, 21 Sep 2021 17:11:20 +0000
In-Reply-To: <20210921171121.2148982-1-oupton@google.com>
Message-Id: <20210921171121.2148982-2-oupton@google.com>
Mime-Version: 1.0
References: <20210921171121.2148982-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v2 1/2] selftests: KVM: Fix check for !POLLIN in
 demand_paging_test
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>
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

The logical not operator applies only to the left hand side of a bitwise
operator. As such, the check for POLLIN not being set in revents wrong.
Fix it by adding parentheses around the bitwise expression.

Fixes: 4f72180eb4da ("KVM: selftests: Add demand paging content to the demand paging test")
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index e79c1b64977f..10edae425ab3 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -179,7 +179,7 @@ static void *uffd_handler_thread_fn(void *arg)
 			return NULL;
 		}
 
-		if (!pollfd[0].revents & POLLIN)
+		if (!(pollfd[0].revents & POLLIN))
 			continue;
 
 		r = read(uffd, &msg, sizeof(msg));
-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
