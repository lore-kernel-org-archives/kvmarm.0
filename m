Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E48C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 06:17:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8045D40DFD;
	Fri,  4 Nov 2022 02:17:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@bytedance-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IlhFSb1L3mgn; Fri,  4 Nov 2022 02:17:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A4CC4106C;
	Fri,  4 Nov 2022 02:17:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A39640DFD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 02:17:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bdfcPGsq2dKa for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 02:17:04 -0400 (EDT)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com
 [209.85.128.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA5ED40DF4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 02:17:03 -0400 (EDT)
Received: by mail-wm1-f41.google.com with SMTP id
 p13-20020a05600c468d00b003cf8859ed1bso2566938wmo.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 23:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bytedance-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:from:to:cc:subject:date:message-id:reply-to;
 bh=zhu8jnKVSyUET5dWBbeizhKy1SMpRgjknQ38ay3i9pY=;
 b=covwzkdstwrYZ2G7OGrFQYxKlY30OW2v5rlDRhhupowlVD65ej46/o9SO1UinrJ3/m
 0lzcsO8YTJZmr/8SS9w4G7XV3IkmHQcJPGZbAe/TLjJ5KTJK85/W6uuk7h6kTDoQj92W
 ApAWWRRkpDXzKGV9t9o3idyzMUpNFaWAZu9DuTUUy6nrTakQB0q5wzB+k2CelDXa6IB5
 2FO5BoKxhA2bpTh7AZA9bEYA3HeY+XOxsUwYP4XXKEpXY21QhzIYtSm/7JtZ8pYOY/Ta
 +TNovCnwrRY7TDHWx4Ppwn5BGKQJ1qdrs6RhX5fjH3YY+C3XZRqQmGpNg1DWvjpAr/EE
 Kv2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=zhu8jnKVSyUET5dWBbeizhKy1SMpRgjknQ38ay3i9pY=;
 b=QsXAMtQdZ1qJf+b7jfI2jQkgZMjDBnbUxcYHeNxbeudHRXL2InM0sQXQF7oAwq11M4
 A4OBw/FCbNI1JtPEZDMVF25YmOfk2qmPma149OpdOEfd391qP8pNG8fLL5ZZzhzHsPYV
 tapf2A8+BR6X0lwNYJvygrXPs/hiJS8q7QFk6v/1/2iReom0Dsl/zmE18RH+tSoh9e6+
 qjhEMjXd82iFhvXncptwu57d/gL75DrixkC9GBbOOHaktiVX9XKwXSQ8DjcYb8gYsoHB
 giILrKyj7FUfJ1sGUZ80OjrDUdUP7owcEM9xCwybKXBENIvugh+nZOMUampNjxo55s8V
 Y7EA==
X-Gm-Message-State: ACrzQf0o17wqsbYi17tCck3DAK19OWZ8bFg8KaPDiVvOzKj12Gm0imNh
 oFJlpRRuZp5TXTfMqVdru/83+A==
X-Google-Smtp-Source: AMsMyM7QV0dYQ4ol87Y3z5F86P2uJ/pz/WIvC3iw6qySzDfWN/XF8zwLlmhTATqf2Z5wsEx3NYMhJw==
X-Received: by 2002:a05:600c:1e8c:b0:3cf:55e7:c54f with SMTP id
 be12-20020a05600c1e8c00b003cf55e7c54fmr27323841wmb.61.1667542622808; 
 Thu, 03 Nov 2022 23:17:02 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk
 ([2a02:6b6a:b4d7:0:c7c:f931:dd4c:1ea6])
 by smtp.gmail.com with ESMTPSA id
 m16-20020a5d6250000000b00236860e7e9esm2487658wrv.98.2022.11.03.23.17.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Nov 2022 23:17:02 -0700 (PDT)
From: Usama Arif <usama.arif@bytedance.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
 yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
 maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com
Subject: [PATCH] arm64: paravirt: remove conduit check in has_pv_steal_clock
Date: Fri,  4 Nov 2022 06:16:59 +0000
Message-Id: <20221104061659.4116508-1-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Cc: punit.agrawal@bytedance.com, fam.zheng@bytedance.com, liangma@liangbit.com,
 Usama Arif <usama.arif@bytedance.com>
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

arm_smccc_1_1_invoke() which is called later on in the function
will return failure if there's no conduit (or pre-SMCCC 1.1),
hence the check is unnecessary.

Suggested-by: Steven Price <steven.price@arm.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 arch/arm64/kernel/paravirt.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
index 57c7c211f8c7..aa718d6a9274 100644
--- a/arch/arm64/kernel/paravirt.c
+++ b/arch/arm64/kernel/paravirt.c
@@ -141,10 +141,6 @@ static bool __init has_pv_steal_clock(void)
 {
 	struct arm_smccc_res res;
 
-	/* To detect the presence of PV time support we require SMCCC 1.1+ */
-	if (arm_smccc_1_1_get_conduit() == SMCCC_CONDUIT_NONE)
-		return false;
-
 	arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
 			     ARM_SMCCC_HV_PV_TIME_FEATURES, &res);
 
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
