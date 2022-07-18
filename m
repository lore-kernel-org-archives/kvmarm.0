Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E01ABCCA479
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 15:49:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CD5B4D778;
	Mon, 18 Jul 2022 11:49:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ttiBiCMQKugh; Mon, 18 Jul 2022 11:49:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59ADE4D6DA;
	Mon, 18 Jul 2022 11:49:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4E404D465
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 11:49:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xJg-f6vrdOWQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 11:49:18 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD7A24D6FB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 11:49:18 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 79-20020a630252000000b004125da7d520so5851051pgc.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 08:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=cmJ2PM63bOnylY+PhF6moARZAV6IMnlTPoAZtyO2Gn4=;
 b=CtWk6HRGLzw+0N7cur63mkAt7Igfoix9q+cH9JMaZKKYjXJT1/B142/0+zAj9ZBg7q
 L8TfOyUC6CKGDVRk1pgcruXZt+1i3ePtiWWyJcl5tOL/hnogF/688Jok7Y8kgKFGE7Ev
 ZhoJgO46P65kapB0S4U/iYmNXuCQOGD7pI/7pwY/WOivkdJkEnKID4dh0KJZRZi+M3wA
 lFu6p3ALSgN82+zUqp316tY4YxeiDTqHECMJk78qPh7RRuIy/0pInJ7RbJx8ueyuWZ0n
 Uc/77odm+I6spCmJ21Mj7CSzxZDptZkxUG/yFkILbJ36TLAF0wUzbxnF+49zGgw2vhbC
 P5FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=cmJ2PM63bOnylY+PhF6moARZAV6IMnlTPoAZtyO2Gn4=;
 b=iDGiO4uwYSePlCOgPWy8o60x1XpRpDz+5v+7DHr0U1t/AtCxxhqH9xpRXSt29GXzvr
 yfdUvWDgeRI2ID9Fuiz4r2uGaQ96nLoDrv7nYIGfAhcmdT0BlRgkR1/6yIf9uIi0QXPA
 aeIOPslMib1cifNoPdkx48O4st2IAJm7jThHIMrYYot+R/ex/sTJjHgpZSogRUKROa6E
 HYsUL3fQMPikV6DMjDeIdvkIXbCFYe1Wp1bZf1olmjhcz6u25j9ifSTikh8MQG5GIfjO
 z8xh2UtP+cZfTJziXgGs+TqSmsuKvxBqLDwwGKuBq0CtAtRlwic36jW42dWyv8lcB1vw
 Ck0Q==
X-Gm-Message-State: AJIora9cQkXQoBjbPE5r4Su6PtCZkXBgzaXF9K58+DyQXH8zQduz4bzS
 pbR68wh304WzKPZSaEs1qbwHpy/af9QwLg==
X-Google-Smtp-Source: AGRyM1vRjKRJK0biQU71Mf3Gei7WSM/6ywPga2c58wN1Z4pm6Iwg/dCB70UwDq41UZuhntEmYbWJJPEovZ9JvA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:aa7:88d5:0:b0:52a:ea1f:50c6 with SMTP id
 k21-20020aa788d5000000b0052aea1f50c6mr28429498pff.81.1658159357794; Mon, 18
 Jul 2022 08:49:17 -0700 (PDT)
Date: Mon, 18 Jul 2022 08:49:09 -0700
In-Reply-To: <20220718154910.3923412-1-ricarkol@google.com>
Message-Id: <20220718154910.3923412-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220718154910.3923412-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [kvm-unit-tests PATCH 2/3] arm: pmu: Reset the pmu registers before
 starting some tests
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

Some registers like the PMOVS reset to an architecturally UNKNOWN value.
Most tests expect them to be reset (mostly zeroed) using pmu_reset().
Add a pmu_reset() on all the tests that need one.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index fd838392..a7899c3c 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -884,6 +884,7 @@ static bool check_cycles_increase(void)
 	bool success = true;
 
 	/* init before event access, this test only cares about cycle count */
+	pmu_reset();
 	set_pmcntenset(1 << PMU_CYCLE_IDX);
 	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
 
@@ -938,6 +939,7 @@ static bool check_cpi(int cpi)
 	uint32_t pmcr = get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E;
 
 	/* init before event access, this test only cares about cycle count */
+	pmu_reset();
 	set_pmcntenset(1 << PMU_CYCLE_IDX);
 	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
 
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
