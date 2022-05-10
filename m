Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58AD7C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 09:57:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0503A49EE8;
	Tue, 10 May 2022 05:57:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Og9g8NVlj4dT; Tue, 10 May 2022 05:57:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D74E4B19F;
	Tue, 10 May 2022 05:57:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FD1C4B177
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 05:57:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UwUVVuZ0ZJ3s for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 May 2022 05:57:17 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 18AE34B1B7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 05:57:17 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 n186-20020a1c27c3000000b00392ae974ca1so582710wmn.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 02:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=4qfi1EyfzrAF17+2Q3vwA2/NLnPP5Sk/AW+fkoZOXmg=;
 b=Z35kcWzQCyc0/bgmoXEQqd04oE3P3i58RdxLoNVzcFf9aRRH2ZdLk8CKxbpiwmuekE
 wmQb457pslsukEJOJbgp6RJM5XJAUf1svZqei9GW5UR+07V7fQkMUstay9+aCOsPVwxz
 qQb8PUj20Ac8wsYwgFiAfCDNOJ/lAQCvXJ9covjO8jGSQhoTfMiIFEY97vShdao+1tym
 76DvaTxgSoSmHK6kAGvoeXmi/vXP1lZGfhJdx3vRb1aoGcLp0eEzJNaIO2IyoFftfItv
 9kmcuj87Et9SPGkBp4c4vgyqZXB4olQQgPVaTVs7pJ+QMl04tf1DAm0w1BNV8x7Q/mb9
 DYUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=4qfi1EyfzrAF17+2Q3vwA2/NLnPP5Sk/AW+fkoZOXmg=;
 b=kUp6C+AwWQ9NJGXShkw4aVf1AdGcLdcb4Y/n8vD9cY/wBlbeixiD9uu/Gss4/yq7Ha
 RTS0L5PyzBO+JOYWw5Y/aFz2rxE4FKrOVqnv5W/Ap///bbopi+3EWOmGlLtjcwv7Qstn
 MKqlY3cPrjOpP11IHzzghrhNYBFdauiVZTr+2JqEBqnOlYd35+lFjj57kioA5W8tj1Zv
 b5B1kmx6+sGOSGN0SNtGwtjQSTAr0P3BMSillM8xefzSiRXoeYiO38KgrHA+HMXbIT8s
 Pmq1qOWIc0UEzFFjGJt+pZaOmg1LX4/Th13hV4BOK40qtnUHYh+MriU6vrc0xk9TA45H
 ytww==
X-Gm-Message-State: AOAM533X4nTytJtWGasxEWK35BgSSRGwnx2EYv78/acniKvYAlhaXVz1
 U/Ogf1ihQ3/J45xhggJoZxAUErblcfFVxGX6jd7SmhvWLSBUhMPbEJ0R6grIdemYtuzWHwR8wsx
 EpV/OqqjZE+URnbNeShT+8AhVwyg3tr/eAoPAsfm2IjTEMX/wOCpgDGQsC2/oCMD876Q=
X-Google-Smtp-Source: ABdhPJx45MlpCKopCtV4MwMconf+bzC+zG0kq7MrmyagGdL8LTEIOWRQrf/j8rQrG1mUQKHBc7UCeGq4Wg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:4f8d:b0:394:939f:bd2f
 with SMTP id
 n13-20020a05600c4f8d00b00394939fbd2fmr8148434wmq.16.1652176636198; Tue, 10
 May 2022 02:57:16 -0700 (PDT)
Date: Tue, 10 May 2022 09:57:08 +0000
In-Reply-To: <20220510095710.148178-1-tabba@google.com>
Message-Id: <20220510095710.148178-3-tabba@google.com>
Mime-Version: 1.0
References: <20220510095710.148178-1-tabba@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v4 2/4] KVM: arm64: Repack struct kvm_pmu to reduce size
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
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

struct kvm_pmu has 2 holes using 10 bytes. This is instantiated
in all vcpus, so it adds up. Repack the structures to remove the
holes.

No functional change intended.

Reviewed-by: Oliver Upton <oupton@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/kvm/arm_pmu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 20193416d214..eaa8290b116f 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -21,12 +21,12 @@ struct kvm_pmc {
 };
 
 struct kvm_pmu {
-	int irq_num;
+	struct irq_work overflow_work;
 	struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
 	DECLARE_BITMAP(chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
+	int irq_num;
 	bool created;
 	bool irq_level;
-	struct irq_work overflow_work;
 };
 
 struct arm_pmu_entry {
-- 
2.36.0.512.ge40c2bad7a-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
