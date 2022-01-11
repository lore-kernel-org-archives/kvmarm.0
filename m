Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B588AC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 04:11:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B68D4B1B6;
	Mon, 10 Jan 2022 23:11:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OdtiaMFCtCba; Mon, 10 Jan 2022 23:11:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E18D54B156;
	Mon, 10 Jan 2022 23:11:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B08E4B12E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 23:11:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IYFPpDWzyKNd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jan 2022 23:11:12 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D0514B099
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 23:11:11 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 g12-20020a17090a4b0c00b001b313b7a676so13558763pjh.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 20:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=vuys1FOVQgJkQm3U23Wnkdvvz8kMB7ON0dRulHlLdEE=;
 b=DMOs9ZfuIX/E8E0XOSnK/jEt42wVxalj2BjYlkjVxBiiLVtCW8IfoafUUEyv6afof2
 kU+X4V61/uPmHSqdWMLxLTsPH8SRE7MD8xTmo+4mnsrn73gHo0lUmU8fsx0RGRimmHxh
 BbeIVLhYBzcEuwxNd+EvfQNxk15SOD3U5wEAato04jXIRYvbtrcmiaWXa2aCYAzvBJeh
 2wSJoZDojPBHmjNWMZ66K3vYJmPkxt6OyaUuVqx15Z7u5Ns71Ak7sN8UgkqNJs9mogx+
 l5118bYPCDAPg8AKCVTviTiAiY7J241SVVTMBM/xXlq0FcsYSPcF8XuAd01hQhMxGr2n
 z2/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=vuys1FOVQgJkQm3U23Wnkdvvz8kMB7ON0dRulHlLdEE=;
 b=fhylUfCBlYIZx0PoWsHvyCPm23a2E0d0FCvsIMEfn+izulC7dxZ0uRvdrvoQLGar7I
 43rp6wUVeBRZ74eqsSXrkSYn7gk7lpqqsl5wCHsL+XC/rtLXxGHpBj/jQ9pvxc5Iv53Y
 WFadMj7tbwFla/Hce5V2AbKuwbVgyTxWgzRxkBzKX5VZMw1M3wF6izOC0tTp1GuUvhWE
 J5Cw2p9NE7GbCu5E/LQjUBi4VirUajwzOAy1kJJEH8MMAyF5DUlTWKxJms9NpY8Oyoiz
 EcKqwaVK4GKghAuKhVTUypoz3Rfqon8XPNmg3NkocDT8jaA22P78hLcmxqkx3cjEUNxc
 /9bQ==
X-Gm-Message-State: AOAM531O5H0Nn66V3NIEf6enY9ST1Y3RKqjg4GisuKRI/9XUNas7ThP1
 vl5K7NEFRkJLI74oPDsmEBnI/iAp/mco6A==
X-Google-Smtp-Source: ABdhPJxVtWdGmFRZAURDuDsj5vwVOqytm2YwefpIzsPSUT1dplrnA1BH+TP83+kWDfXruoOlCGzM4mllxvS5TA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:7793:b0:149:c4ad:ecc3 with SMTP
 id o19-20020a170902779300b00149c4adecc3mr2585026pll.171.1641874271051; Mon,
 10 Jan 2022 20:11:11 -0800 (PST)
Date: Mon, 10 Jan 2022 20:11:03 -0800
Message-Id: <20220111041103.2199594-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [kvm-unit-tests PATCH] arm64: debug: mark test_[bp, wp,
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
index 54f059d..6c5b683 100644
--- a/arm/debug.c
+++ b/arm/debug.c
@@ -264,7 +264,7 @@ static void do_migrate(void)
 	report_info("Migration complete");
 }
 
-static void test_hw_bp(bool migrate)
+static __attribute__((noinline)) void test_hw_bp(bool migrate)
 {
 	extern unsigned char hw_bp0;
 	uint32_t bcr;
@@ -310,7 +310,7 @@ static void test_hw_bp(bool migrate)
 
 static volatile char write_data[16];
 
-static void test_wp(bool migrate)
+static __attribute__((noinline)) void test_wp(bool migrate)
 {
 	uint32_t wcr;
 	uint32_t mdscr;
@@ -353,7 +353,7 @@ static void test_wp(bool migrate)
 	}
 }
 
-static void test_ss(bool migrate)
+static __attribute__((noinline)) void test_ss(bool migrate)
 {
 	extern unsigned char ss_start;
 	uint32_t mdscr;
-- 
2.34.1.575.g55b058a8bb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
