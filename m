Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4537C19F28
	for <kvmarm@archiver.kernel.org>; Wed,  3 Aug 2022 18:23:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D8E94FB09;
	Wed,  3 Aug 2022 14:23:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ENdasDyyICFm; Wed,  3 Aug 2022 14:23:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E303B4FB03;
	Wed,  3 Aug 2022 14:23:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 715D54FAFC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Aug 2022 14:23:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0L-NjgHUh32o for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Aug 2022 14:23:33 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D99874FAE5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Aug 2022 14:23:32 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 q82-20020a632a55000000b0041bafd16728so4885821pgq.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Aug 2022 11:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
 bh=YQIObxgEKoiOHzKfKo2AOIGfQ9Eupxnu81toWwxoZR4=;
 b=QeMfWWZncT1VWOX8Gvcg1x8qqYdPHVwfF2K5uiXxur+fewrj/KVIsLcAxh8mMB+IH2
 DxXBrmpwbAXNhoGQ4KhITnOjleIbwpvfPmRng4XexmbU9Of4oQ1vWFdHT+cl7KtDqvu2
 GK7opw+mxhaYJxS4CmtiMTkmZItZoNLl2MNDYCCmt3qVg1qRNpM12fi6h57SJVUhRiYb
 2EsjGEmEFdKRaFfCdoxnq39ob05gSGCqzg55xwoCSevdUuVC/4P1BWu/H+ZWxMuzT4cq
 SeX99TTrEEBFtsd1Qtg8FhLIY6P0rtCgmrQjlaQH9PzVaYtQwuc8FVLbvvOzdf3y1rIv
 7QCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
 :from:to:cc;
 bh=YQIObxgEKoiOHzKfKo2AOIGfQ9Eupxnu81toWwxoZR4=;
 b=dapt6ng5aqeh9ztOj3jPHdQR8Wq5P0KSyc8raMtG4IF410alT9lFYI2AAUhYQgaZpx
 PnuQEK1EAHMC7UnZkuJ7nZ4d1vnqL7ljl0vutTp4A3g3SAU6GK0xrBbc+qHAlb8hwUYV
 3c9S0nQ1PoyYaSOHc3x1JKdWISE/yKhXNlQRSqS3RkNGqiYAlqGeSoQtJRm89bTUDv2e
 +KmAlm8oYikUmuQ8D/QdsASAHaoJ/G9WZmxNon8sRklAWhoRyy+mvhEw13W/7EXBMsJs
 xTqBRwoVWpcgXg8nMatnqBUdHR4I9BEcE4xOpmDr+GqI3uJ20oqXQLpzpZcNrUsU6WSs
 8x/Q==
X-Gm-Message-State: ACgBeo2woqWLwubte/94r9Ecmv+j51X0hs9i7zHcl5QvY8DwHnof8TvW
 PYgVjn+DU7YwKAXPUiFU3wYIMQdS8YZDtQ==
X-Google-Smtp-Source: AA6agR4FwE9hS4KohCiAsjYwbvYrx4JkPYgmajmF2QzZT1bykc75fpeD1HwhmcfUtOiW9J97fyaVFCpay2hpxQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:7e47:b0:16c:7115:84d6 with SMTP
 id a7-20020a1709027e4700b0016c711584d6mr27971478pln.93.1659551011679; Wed, 03
 Aug 2022 11:23:31 -0700 (PDT)
Date: Wed,  3 Aug 2022 11:23:25 -0700
Message-Id: <20220803182328.2438598-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [kvm-unit-tests PATCH v2 0/3] arm: pmu: Fixes for bare metal
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
- added some isb()'s as suggested by Alexandru.
- fixed a couple of confusing comments (Alexandru).
- check for overflow in the low counter in the interrupt_overflow test (Marc).

Thanks!
Ricardo

Ricardo Koller (3):
  arm: pmu: Add missing isb()'s after sys register writing
  arm: pmu: Reset the pmu registers before starting some tests
  arm: pmu: Check for overflow in the low counter in chained counters
    tests

 arm/pmu.c | 55 ++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 17 deletions(-)

-- 
2.37.1.455.g008518b4e5-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
