Return-Path: <SRS0=/4wP=NK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C202C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 22:37:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E8A56610A5
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 22:37:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E8A56610A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CFDE4B087;
	Thu, 19 Aug 2021 18:37:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G64hNzZ0ge1z; Thu, 19 Aug 2021 18:37:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BFE64B147;
	Thu, 19 Aug 2021 18:36:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 195FD4B10B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 18:36:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JwIsW6m5ld8w for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Aug 2021 18:36:56 -0400 (EDT)
Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com
 [209.85.210.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6BF1C4B11C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 18:36:49 -0400 (EDT)
Received: by mail-ot1-f73.google.com with SMTP id
 c21-20020a0568301af500b0051af51e2a5bso416757otd.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 15:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=JGqmcJ19wJcSqhtx+3fJtVk+a96fkXkWZoUWYMFazps=;
 b=ncZZlSQt7wFBsfTBRMD0PoGEeGTmX3k2OhH6AlxdOWQrM0lk86yvo6KCvyS+aHyXZh
 4qDVW2mi11CgONQrBgIZ1APYQcnqSy86DZwkzdHvfVC+V6B4SwPf3+yH4q/GS4QU3ljU
 Rccs0M8PyPJp95Yt1I4mLIim27HqRQkqzDfBjlR9ZIGm75uLuFtY7w39kSTp6sizOV+r
 3Wq+I4rDvpqrgf91TvKvNxALCOAvhpu/jPVepZ6t4/IB0uX7fM0gGHKQwkqgXEFDW9wz
 pLcUYttvedIR7jsuxxhXkwcO930SkllyMoV+2JgcimR4cCuUZOqX0YhWh4mkYkybQzt6
 +PEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=JGqmcJ19wJcSqhtx+3fJtVk+a96fkXkWZoUWYMFazps=;
 b=PfbMmclByEbH4T+1+gT/MTpO61eVrjJSMY6PW9HZnrQTH1ekNuZN+CAk11Cg1ALunH
 iO68gNrf/HVCvANd7c1CiIEw7jsM74oAPQKCX+zJCMjXc081sZig9H4s5IbhigTcjPP6
 3NXrOF+SIWIU2BL3/zI04Nl2goP+ywjWzPG2h98Z8420fadmsbzRTwkbTbxo6EwYpOK0
 y630Ysefv+AEFpdun9b3gv0mXo8Iy08ATi7ow4kwrUO3E5qhXvVqvVgIQSGDnRm4o2gl
 2LushFtOY5NhZ5wBj4I8P0pCM5Du6CBUIea5euEwnGuglS0ET7hQpKHYXQXQlBYcljbP
 v1yQ==
X-Gm-Message-State: AOAM533UFAKlh5VTUuOg7IQoAaOIFaQQyha/HER6JcEKPgWASce/XZE3
 EayCfbedQtkczvG6IsKW2P6oCF7thN0=
X-Google-Smtp-Source: ABdhPJyCGOfK+n259Nrhhm5N9CusHqhw6pA25R66y29TOnm3as1HrzFW519Mnir52OpQDk02U59cIhj6WaM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6808:aa8:: with SMTP id
 r8mr736557oij.171.1629412608962; Thu, 19 Aug 2021 15:36:48 -0700 (PDT)
Date: Thu, 19 Aug 2021 22:36:39 +0000
In-Reply-To: <20210819223640.3564975-1-oupton@google.com>
Message-Id: <20210819223640.3564975-6-oupton@google.com>
Mime-Version: 1.0
References: <20210819223640.3564975-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 5/6] selftests: KVM: Promote PSCI hypercalls to asm volatile
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Raghavendra Rao Anata <rananta@google.com>
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

Prevent the compiler from reordering around PSCI hypercalls by promoting
to asm volatile.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/aarch64/psci_cpu_on_test.c     | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
index 018c269990e1..9c22374fc0f5 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
@@ -31,10 +31,10 @@ static uint64_t psci_cpu_on(uint64_t target_cpu, uint64_t entry_addr,
 	register uint64_t x2 asm("x2") = entry_addr;
 	register uint64_t x3 asm("x3") = context_id;
 
-	asm("hvc #0"
-	    : "=r"(x0)
-	    : "r"(x0), "r"(x1), "r"(x2), "r"(x3)
-	    : "memory");
+	asm volatile("hvc #0"
+		     : "=r"(x0)
+		     : "r"(x0), "r"(x1), "r"(x2), "r"(x3)
+		     : "memory");
 
 	return x0;
 }
@@ -46,10 +46,10 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
 	register uint64_t x1 asm("x1") = target_affinity;
 	register uint64_t x2 asm("x2") = lowest_affinity_level;
 
-	asm("hvc #0"
-	    : "=r"(x0)
-	    : "r"(x0), "r"(x1), "r"(x2)
-	    : "memory");
+	asm volatile("hvc #0"
+		     : "=r"(x0)
+		     : "r"(x0), "r"(x1), "r"(x2)
+		     : "memory");
 
 	return x0;
 }
-- 
2.33.0.rc2.250.ged5fa647cd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
