Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B69AC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jan 2022 15:22:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAC604B15B;
	Wed, 12 Jan 2022 10:22:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7edLrFX4ip9I; Wed, 12 Jan 2022 10:22:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 952D14B25B;
	Wed, 12 Jan 2022 10:22:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 673D54B215
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 10:22:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a-A-8BYtVklC for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Jan 2022 10:21:59 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0B0BA4B15B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 10:21:58 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 e16-20020a17090a119000b001b28f7b2a3bso3291161pja.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 07:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=bKysrhfTy6kWHqwLFxfvARORjI8IUbglOVOGzn5bU8w=;
 b=OAz6OE1lvLg5O8+mkLFMomjkDHU86EBeW3DRlFbIX8rD9SerLZgGYxSSM72K7AUMbA
 wZu41tCU8Kz8yZCC7AxhjcsrnxZ4grxwU2YfDTNYqBnTfxx8x3dc4XiYjZ5IrWpjEZaY
 LenMx8Iy+ZIxUafXik4YyXelKCwBClmItOpVoPdzNPs8d+76yw4+31GzjmKN4wOwiQYo
 vu83nWEnskuzrA+Y/CDJ/0c+8irujlzEXbk3FY440XIbqqOCKTBpcs3iRp+45h+X/I3e
 7jQA+prK9MmgPyox5sWptHL+ds2K4ZDryiAvpWvxa4gwFDyQmy/qtTvQswsnZ+S8reKt
 +Xfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=bKysrhfTy6kWHqwLFxfvARORjI8IUbglOVOGzn5bU8w=;
 b=IuRCZMk4gbxlol0gqNKSAdVjlnMvXSSogSnO+WPe23OZLdQAiYdbKp6uo0q70FYpi0
 rt6lian+9Ne7lknLTrrBbsa6zE4MAIxcqaz9EfCoCNrgdb7GNBZj5DJZ5INXynUW5xSu
 Ulo0LK9citQALYJbnqGYGM/bJZBBhECvPea4rLg2jGDsadu1LENPci1bdBM8hSlShgr4
 N0VdAtz6ENVhZZJhpPnaR7s2V2DIzTl7Q8stTxY6j3O4ISqoJV1vPTDiKT1HheDz3UMe
 TZUTzkAqn/ETVRmR9Hm1TjBYOmZB7hS+gVg/YKToe4ZcDetao3PE1aEHhBbyxQrSmEhk
 J5Yw==
X-Gm-Message-State: AOAM5317VKRAStWZrpmqCWOhH3feT6jWbLNKsuBi6iPLtZf7DkXuP5wD
 UkX/nDlEUH4qrfVDnPp12zhjrMngkAEekQ==
X-Google-Smtp-Source: ABdhPJyKO2HCZyV+MbxNEYxnAqVFC+kZ+aZoxQdpp3tIQVqrA/Er6Xg0tp8etPm7oJmP+QVLr/dbSqVjLnfqpw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:10d5:b0:4bc:a0eb:c6a0 with SMTP
 id d21-20020a056a0010d500b004bca0ebc6a0mr9743473pfu.70.1642000918116; Wed, 12
 Jan 2022 07:21:58 -0800 (PST)
Date: Wed, 12 Jan 2022 07:21:55 -0800
Message-Id: <20220112152155.2600645-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [kvm-unit-tests PATCH v2] arm64: debug: mark test_[bp, wp,
 ss] as noinline
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org
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

Clang inlines some functions (like test_ss) which define global labels
in inline assembly (e.g., ss_start). This results in:

    arm/debug.c:382:15: error: invalid symbol redefinition
            asm volatile("ss_start:\n"
                         ^
    <inline asm>:1:2: note: instantiated into assembly here
            ss_start:
            ^
    1 error generated.

Fix these functions by marking them as "noinline".

Cc: Andrew Jones <drjones@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
This applies on top of: "[kvm-unit-tests PATCH 0/3] arm64: debug: add migration tests for debug state"
which is in https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue.

 arm/debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arm/debug.c b/arm/debug.c
index 54f059d..e9f8056 100644
--- a/arm/debug.c
+++ b/arm/debug.c
@@ -264,7 +264,7 @@ static void do_migrate(void)
 	report_info("Migration complete");
 }
 
-static void test_hw_bp(bool migrate)
+static noinline void test_hw_bp(bool migrate)
 {
 	extern unsigned char hw_bp0;
 	uint32_t bcr;
@@ -310,7 +310,7 @@ static void test_hw_bp(bool migrate)
 
 static volatile char write_data[16];
 
-static void test_wp(bool migrate)
+static noinline void test_wp(bool migrate)
 {
 	uint32_t wcr;
 	uint32_t mdscr;
@@ -353,7 +353,7 @@ static void test_wp(bool migrate)
 	}
 }
 
-static void test_ss(bool migrate)
+static noinline void test_ss(bool migrate)
 {
 	extern unsigned char ss_start;
 	uint32_t mdscr;
-- 
2.34.1.575.g55b058a8bb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
