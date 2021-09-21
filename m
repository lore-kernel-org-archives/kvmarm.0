Return-Path: <SRS0=fzUG=OL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF00C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 01:01:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0415B60249
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 01:01:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0415B60249
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEC3C4B11B;
	Mon, 20 Sep 2021 21:01:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Rkc4o+NzRUE4; Mon, 20 Sep 2021 21:01:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BE654B0E1;
	Mon, 20 Sep 2021 21:01:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5653C4A4C0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 21:01:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pUvFrDLw3z8z for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Sep 2021 21:01:38 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 79A234A3BF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 21:01:38 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 d2-20020a0caa02000000b003784ba308f1so204753119qvb.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 18:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=PESbKZ13iPjl74hV0V0Oma6w2P6tLvn6iQL7mqbwGgo=;
 b=ppmJDLMbBlM4yiFlfHYiHNu77wvNXXA5sAEzTiwCbSu7h70G6OjhKF2mjh7FFO64Dq
 mi/BbW0+YbeqFEz87n2vqvzvrplY76fKT4uwCsAlhywV3hvoAJ/pxkM09kbB72YYNAbQ
 LaFiePNwjkwukIs52aik3fTBq2pZaR4bVRx6FpWsM/XuLeVz1+umhLvvcoo93cB9I+Cz
 PGPoF2Lf8eyERDt6eMuXk81Tfae2XfL7oQUY6eeugG7Ye+GCZRe/lRb1GD0M4Nr7N8tJ
 6i4ErXIQdOXEzvwvJtl7l5OxjvuFpswh2FxB18zrh0B9Tk4FzxAGLy7m1yMlGk+RGE9u
 ryYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=PESbKZ13iPjl74hV0V0Oma6w2P6tLvn6iQL7mqbwGgo=;
 b=4zZNy1Ga5tMgWEimmB72SdlSplbzovu5c5JTEmLZAm1V0YrdRs6crYlQQCDvlVvRWa
 wq5XI88bIh4G8057JzoLPrLSdvJlk5S9otgO25KUlUBIQ1QmnbqKrhSL2u2ynK0opycN
 HoVF/z0znf+af2Sg0+0rR4lycWxgAyXQBZdqhBrPnyyky3CB50zMOq+oIyXsjKu4A+Xp
 9Kk8GHiVMwVTPG9vYBi5ROnxmPsfNqYsFNmv9sKkIpUGxD3Ws9HPHR3shfxxJiuxQ2X8
 0Oumi0CEW5PUPx+XzIsfKjfesXHDvzOhVEXwPTUAa5+P18jTVw5Vs3XkcyUtxR0+TGa1
 jHuA==
X-Gm-Message-State: AOAM530RNx7GfCltz71x1hi6IwB6VcWco5Jqmh585l4ibzMatKLxUnmi
 zXLAX5G3Zw/1+ZMPAUvtHDvQxUrQ6hg=
X-Google-Smtp-Source: ABdhPJxxD5Psn8NbnOGzgjmoMwHo/NRrqGL/Hz5g2R/wXaxij8FsuN33N5paHz3bIg3BU/k6S4n92x/nUM4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:122e:: with SMTP id
 p14mr28597769qvv.37.1632186098021; Mon, 20 Sep 2021 18:01:38 -0700 (PDT)
Date: Tue, 21 Sep 2021 01:01:19 +0000
In-Reply-To: <20210921010120.1256762-1-oupton@google.com>
Message-Id: <20210921010120.1256762-2-oupton@google.com>
Mime-Version: 1.0
References: <20210921010120.1256762-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH 1/2] selftests: KVM: Fix compiler warning in demand_paging_test
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

Building demand_paging_test.c with clang throws the following warning:

>> demand_paging_test.c:182:7: error: logical not is only applied to the left hand side of this bitwise operator [-Werror,-Wlogical-not-parentheses]
                  if (!pollfd[0].revents & POLLIN)

Silence the warning by placing the bitwise operation within parentheses.

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
