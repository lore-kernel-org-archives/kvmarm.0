Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A28C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 15:49:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F9204D3DF;
	Mon, 18 Jul 2022 11:49:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X7bQ1Ldo2Vuq; Mon, 18 Jul 2022 11:49:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FB854D465;
	Mon, 18 Jul 2022 11:49:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B37EA4D3AB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 11:49:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WJ3K-Yi6btjh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 11:49:14 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C11F4D3A8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 11:49:14 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 l6-20020a25bf86000000b00668c915a3f2so8911128ybk.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 08:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=8hwXAbTV7Qa4wgHWw/mu6mOGF7/qMo3iMN2FISfVMjY=;
 b=tDbu/3n2A7sX0LInLF6tQ2mZSs3mTOiAz4QgK4s4r7Fc3GLZoH8VInfZWm7NPNXzMA
 xSYhoBx7dSyl5/U6tDUfmYKVDVfFwZ20vVWr4oSKwrOXnQl0yxnlK5v5ztb+T3uMxBhC
 HZc+U45bxGDItNRDTapkcybXZxmfFM4Sn8NPuWszObhLyL5qJGKAhfJAJuBYIOboxE/Q
 /SXu0XpAgSPU1Zi8fjFZ/p3u2/7h09X+G4MJF7+MfGMLvMpEN5O6/Mv/QSDl6vJ6wGl0
 e4aukyv6SY+6N/qFj8PJiPPmWFIIW6AvnL9e/VANyuaqFAAxYWWvjf+UQ7V1CYQFZuAP
 5Xbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=8hwXAbTV7Qa4wgHWw/mu6mOGF7/qMo3iMN2FISfVMjY=;
 b=te25Szj7UaohZDXNk/Z6lk8yZ05kf6/cNNOQk1sOGYZ3KxuxIvG5AVzHR/k2IwNmj+
 hF2G4UK2LfNMG5zKagMMz+VyLcYoMrU+gnb4USDo1FTDfm28Pha29Vm41Rpn8qzy1Fpx
 Q9yI0GYYuGXdLS4pQmrYnVrk4qocwLpgdY7v6z4CB2CCssYLoHW6hEEJUoRVtzamd7yD
 ZXAAv5xRtInY1HynNe9+WVB6eiRbkoML7EHL1ANKav7NAjhDBsnj0VjEqoVtAbem+MFc
 yT5uILzFcAtKBS1pgrJCoeQjnv4T7gjC1TexH5F/cm9+6a18EJqx9Wj+1zuHluyOomwf
 X+Vw==
X-Gm-Message-State: AJIora+I6JLosfZek9gp/8gKk+n9MnYKKWmQoA5Z1+H3c/cMSaq+FocI
 JkzBHdKfk2MmbRGNclj1wzphAshP7kxnHA==
X-Google-Smtp-Source: AGRyM1vYCzHqQ4m9m06B9lipyzRO7s1S5GtcnbcPAzNt/vma4+jdr/NVmOw55dp+b6E8SRtUqkY7rsVys0SByQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a81:1257:0:b0:31c:97fe:e416 with SMTP id
 84-20020a811257000000b0031c97fee416mr31830689yws.34.1658159354110; Mon, 18
 Jul 2022 08:49:14 -0700 (PDT)
Date: Mon, 18 Jul 2022 08:49:07 -0700
Message-Id: <20220718154910.3923412-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [kvm-unit-tests PATCH 0/3] arm: pmu: Fixes for bare metal
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, oliver.upton@linux.dev
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

I believe the third fix also requires a KVM change, but would like to
double check with others first.  The only reference I could find in the
ARM ARM is the AArch64.IncrementEventCounter() pseudocode (DDI 0487H.a,
J1.1.1 "aarch64/debug") that unconditionally sets the PMOVS bit on
overflow.

Ricardo Koller (3):
  arm: pmu: Add missing isb()'s after sys register writing
  arm: pmu: Reset the pmu registers before starting some tests
  arm: pmu: Remove checks for !overflow in chained counters tests

 arm/pmu.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
