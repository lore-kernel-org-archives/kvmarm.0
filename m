Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A68AC19F2A
	for <kvmarm@archiver.kernel.org>; Thu, 11 Aug 2022 18:52:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 863504E98D;
	Thu, 11 Aug 2022 14:52:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O+Mn63YTNpsF; Thu, 11 Aug 2022 14:52:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EBAB4E98E;
	Thu, 11 Aug 2022 14:52:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98FB64E98C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Aug 2022 14:52:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oNLtXDCyrth3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Aug 2022 14:52:15 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 45A9B4E984
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Aug 2022 14:52:15 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 t34-20020a634622000000b0041da2040110so4325621pga.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Aug 2022 11:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
 bh=PSMiDApMm9EJDwLSG0ujDeBYqk+k1GboNMnR6a9XYaU=;
 b=Z5yseo85kwVp4yp2VAQbZNNu4ewswLmT49gXoWDeE7tse+gvglBEe2hRUVE8dlS5y3
 pLkwV4JUOMAcQuTQcR2inLc0Mm+a1kYV70zLXAwALtOLUz/rvKaZahDeQqnQaZN5FvNw
 +4cJVa/HE/M7doCUx+zzhkI5iAITROzd0uZcmO6Ila4Hcu8FbNHxYf3+xbXP+e2G97Kf
 HxR68s4RykHvUoNs/0ItUusfi1rsyy4IsZdS1usEFLc5v18Etmp8gQYX7EIGpEoUOTOo
 aIHfFo24VTCKv/lI1dpeC0lxCz64fhC+RmYYg1++iG80Qg010bCevdaCF0cIm5CdMYDS
 FXsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
 :from:to:cc;
 bh=PSMiDApMm9EJDwLSG0ujDeBYqk+k1GboNMnR6a9XYaU=;
 b=ifLyUNnr2e8KGz11cFKla2qAwQL0T63f6RaAXb65a/6Hb1GYa54dApkoME40VkawXk
 1+oCdGnszFuLvsoIKHzS6eOLCbnjF/emHHjzdYxe2gYLMvTCQayhxwMF8kNvUzEA4/kU
 PofpBp1x8AEpjpz8ex/OgF2wofGJ29HsrCE3agwa7ih+gQ/5hLFntyVcV2DNGjCYfZz2
 wEPBDTKG88/JGpSwjN7R046XSp8jRIYVTTXkev3ab8VKaCKAAL90hmbwnC1FQ/HoI/zf
 JKzcPnY07WdPYUTopQdthkjnNgrQjne9stpgcL44KXzAataWlE+4JSHyb1NyPyVKXkZW
 huJQ==
X-Gm-Message-State: ACgBeo18BXazwJg+W8bh+qWgt0jdYr3sflhtmOB+erSAE7HWa+DhzHUt
 qeqPt+KCNEO6z3+SVgmklhEj3Y1r3ghDkg==
X-Google-Smtp-Source: AA6agR7cZjXJZ8N3M8FiN5R564eJNdzhrfbZUp0GkJIZHcrS3I5L++nZc/8L5kAWnrziyVDaGhY/dMnv3r2PJg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:f7c6:b0:16d:c795:d43e with SMTP
 id h6-20020a170902f7c600b0016dc795d43emr481372plw.162.1660243934081; Thu, 11
 Aug 2022 11:52:14 -0700 (PDT)
Date: Thu, 11 Aug 2022 11:52:06 -0700
Message-Id: <20220811185210.234711-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v4 0/4] arm: pmu: Fixes for bare metal
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
https://lore.kernel.org/kvmarm/YvPsBKGbHHQP+0oS@google.com/T/#mb077998e2eb9fb3e15930b3412fd7ba2fb4103ca
- add pmu_reset() for 32-bit arm [Andrew]
- collect r-b from Alexandru

Thanks!
Ricardo

Ricardo Koller (4):
  arm: pmu: Add missing isb()'s after sys register writing
  arm: pmu: Add reset_pmu() for 32-bit arm
  arm: pmu: Reset the pmu registers before starting some tests
  arm: pmu: Check for overflow in the low counter in chained counters
    tests

 arm/pmu.c | 72 ++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 55 insertions(+), 17 deletions(-)

-- 
2.37.1.559.g78731f0fdb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
