Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDB8C25B08
	for <kvmarm@archiver.kernel.org>; Fri,  5 Aug 2022 00:41:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BECE54ECF3;
	Thu,  4 Aug 2022 20:41:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZP9Cej8urqmr; Thu,  4 Aug 2022 20:41:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A738C4EA6D;
	Thu,  4 Aug 2022 20:41:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B9C64EA6C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2022 20:41:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TTuLr+DiIs31 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Aug 2022 20:41:42 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D08794E739
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2022 20:41:42 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 d3-20020a170902cec300b0016f04e2e730so711334plg.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Aug 2022 17:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
 bh=5EKWHCPcKyvB2oDUDYMnnI0e2YJH8ovBxDk66tsMekY=;
 b=RHtDQc8t2PlDEd10Af/hrqN3NkkFIZdVdAdRZAlzWPtEBOLrY0w9Zrntn+wo1iePNZ
 UOGW4olAVudsicWpDuyaHt5Wrhy5d8y1PmAVvEoaGxlU5Bt+Ug7QRxeG6QuGHm6vFbKS
 2/SS76WA9jAsRp/+wCmQdOPkitqTMIsUASzqhuy3FeHC/sRuQClGYJ1PUg627q4Fv81z
 NxZJNCPtaWAhw8pD7nXQhdODDAc3DRP4aJqZjhi+SdAttXMLUxBESRQ65dGTn3tJjbsC
 hWet9Xqd3rrDLXVa+C7WpNc/3NA25HPHc0luCbR9KE+dr9wisQG1kW+CkEBVr8NQu3Un
 NDVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
 :from:to:cc;
 bh=5EKWHCPcKyvB2oDUDYMnnI0e2YJH8ovBxDk66tsMekY=;
 b=BIUMN5QEoMNOvB8gEa7+Fx1x4gLRVpEIp+dUHKp68fJp99iD/Q1eZ9WpiN37Sd/LWc
 gUXN48XIbC/0tfA7SuS0/zgVEBA76tgO6MCOqopO71wjJkSylUEg/Vp294AQGjcLn1M8
 DRCzgT08/oP889U/9U5gHcp7HMPr3CgsTsfXCXzgaFClWGXDJfp8/MwY3ZGufxz6ujgo
 1jxrwSpypod3SkVUyfDVBAXEPjfE1vsrtfUDTkzuIPtKtAr9sJKgULJaj36s6jBk2e/l
 nKTB+q2mtu3h/WLu0xKHQ2QYodqMwgl+4sookahOsWSZerh7N+NZXs8YyJIyBilVUX5w
 qy3Q==
X-Gm-Message-State: ACgBeo0n/YudSW8PUVdVxJaGQOZpYyrBaLqvrmg8jOUKC/JkiW+52KRd
 iqeoS+tag6u1e295E4Eurf3OKC73tk99GQ==
X-Google-Smtp-Source: AA6agR6h3dEWT9aFoo84cpRjtu2lZnpAGw3llM2UEFtFeHEEzpJtybi6cBjqn2qCSJla6v7dKPIYdo9p/lxvBw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:2449:b0:528:3a29:e79d with SMTP
 id d9-20020a056a00244900b005283a29e79dmr4497987pfj.39.1659660101707; Thu, 04
 Aug 2022 17:41:41 -0700 (PDT)
Date: Thu,  4 Aug 2022 17:41:36 -0700
Message-Id: <20220805004139.990531-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v3 0/3] arm: pmu: Fixes for bare metal
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc: maz@kernel.org
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

There are some tests that fail when running on bare metal (including a
passthrough prototype).  There are three issues with the tests.  The
first one is that there are some missing isb()'s between enabling event
counting and the actual counting. This wasn't an issue on KVM as
trapping on registers served as context synchronization events. The
second issue is that some tests assume that registers reset to 0.  And
finally, the third issue is that overflowing the low counter of a
chained event sets the overflow flag in PMVOS and some tests fail by
checking for it not being set.

Addressed all comments from the previous version:
https://lore.kernel.org/kvmarm/20220803182328.2438598-1-ricarkol@google.com/T/#t
- adding missing isb() and fixed the commit message (Alexandru).
- fixed wording of a report() check (Andrew).

Thanks!
Ricardo

Ricardo Koller (3):
  arm: pmu: Add missing isb()'s after sys register writing
  arm: pmu: Reset the pmu registers before starting some tests
  arm: pmu: Check for overflow in the low counter in chained counters
    tests

 arm/pmu.c | 56 ++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 17 deletions(-)

-- 
2.37.1.559.g78731f0fdb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
