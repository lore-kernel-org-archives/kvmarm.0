Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 866DDC10F1B
	for <kvmarm@archiver.kernel.org>; Mon, 19 Dec 2022 18:53:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D12354B919;
	Mon, 19 Dec 2022 13:53:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 709lFaYuhbgQ; Mon, 19 Dec 2022 13:53:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2D074B90A;
	Mon, 19 Dec 2022 13:53:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 792AD4B8F8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 13:53:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oCbKGt8+gde4 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Dec 2022 13:53:33 -0500 (EST)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 499974B8B9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 13:53:33 -0500 (EST)
Received: by mail-io1-f74.google.com with SMTP id
 y24-20020a5ec818000000b006e2c0847835so4453458iol.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 10:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
 :date:message-id:reply-to;
 bh=wppcRybhsa1D+MJGf2QRd6LwePVql2vPJWBF38NpA2o=;
 b=qEwnyZz/kHeIYiGoGUWihIfAToGNVAmjadbU4bRC9mw4aGqSfL51V6XugfXpXYo2vL
 oxv7EX2Ogam4Gb0R00I1vlGmkyzrgvo9ryON4vAYxur3cKetpUvv2SZgFLIKPfZIX9jE
 HJR4CweyC4G5TIcV47oDdUmpLgYkl4f8PgRfcm5q3a88Nb+Rpi/F2IFzJ3JDSu6JdodJ
 RB2m8JkCFTUsQymEBF4VSWEtM1taphQm4hAd5N6XtTzKQaNT9HlMIQhNbZwH6F7M+03O
 VZJeDM0gorwOIg14NJA7faq5RiMOwPWQyqBjkDN1zRqhjI1yTa/8XGpP6v/am6jepacJ
 1NCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=wppcRybhsa1D+MJGf2QRd6LwePVql2vPJWBF38NpA2o=;
 b=yEuZPQvL3mA+WtiBBV16Hmr+BpwVogcEZD5mpJNGgXIHqkK/QxBBPqW6F5SRaKWiq2
 Lhkfjc8d7t/75UvMeiuKEdHkVIeXvWJj1jzLz1JlAxOJ4isKF9Dd1GzjQiXjq+e2jFyy
 XmrH2HMOq2UAToLUaQNOvY3hSvCUtj88wMS5zGbLIDwb3M1gBxvdRNsaXtcgnVDOES4M
 CQxeR1E1aPFvjLHNWMYJsy1Meff+IZFnXJrsVbaXvGLHUOkM8rn2QfIM7NflYVrIL7z/
 NMIT5REKrGj3GkXQh8+9WJxHlc28qFpYrh/8nSBPA8y4NlDOpgFBd1D2xupWrrnSVdyq
 UVOQ==
X-Gm-Message-State: ANoB5pmKFvYmZf/vE9BYVyzCYMEZxmFooaBiGyYZQ9drKQf7I/MRXvBm
 tMSBK3MsA2opyvbz29evnvVbbwSZzAkV0GCJ+A==
X-Google-Smtp-Source: AA0mqf7DiaNp0GrKsEOujv+Oe9vnA2Oz5I9BmoWs05G430VgNfQjwF62tfkDu6k1XPiRniP1sus+oHYjvW02y7EWFg==
X-Received: from coltonlewis-kvm.c.googlers.com
 ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:1901:b0:389:d4f3:216f with
 SMTP id p1-20020a056638190100b00389d4f3216fmr30745147jal.92.1671476012739;
 Mon, 19 Dec 2022 10:53:32 -0800 (PST)
Date: Mon, 19 Dec 2022 18:52:50 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221219185250.631503-1-coltonlewis@google.com>
Subject: [kvm-unit-tests PATCH] arm: Remove MAX_SMP probe loop
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc: maz@kernel.org, Colton Lewis <coltonlewis@google.com>
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

This loop logic is broken for machines with a number of CPUs that
isn't a power of two. A machine with 8 CPUs will test with MAX_SMP=8
but a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 2 ==
6. This can, in rare circumstances, lead to different test results
depending only on the number of CPUs the machine has.

The loop is safe to remove with no side effects. It has an explanitory
comment explaining that it only applies to kernels <=v4.3 on arm and
suggestion deletion when it becomes tiresome to maintain.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 scripts/runtime.bash | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index f8794e9..18a8dd7 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -183,17 +183,3 @@ function run()
 
     return $ret
 }
-
-#
-# Probe for MAX_SMP, in case it's less than the number of host cpus.
-#
-# This probing currently only works for ARM, as x86 bails on another
-# error first. Also, this probing isn't necessary for any ARM hosts
-# running kernels later than v4.3, i.e. those including ef748917b52
-# "arm/arm64: KVM: Remove 'config KVM_ARM_MAX_VCPUS'". So, at some
-# point when maintaining the while loop gets too tiresome, we can
-# just remove it...
-while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
-		|& grep -qi 'exceeds max CPUs'; do
-	MAX_SMP=$((MAX_SMP >> 1))
-done
-- 
2.39.0.314.g84b9a713c41-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
