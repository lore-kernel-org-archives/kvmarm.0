Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF0ADC4332F
	for <kvmarm@archiver.kernel.org>; Wed, 21 Dec 2022 20:40:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 415584B858;
	Wed, 21 Dec 2022 15:40:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UHPlYqngadvI; Wed, 21 Dec 2022 15:40:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31B7E4B894;
	Wed, 21 Dec 2022 15:40:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FC034B824
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2022 15:40:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sVPHcZOGriW8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Dec 2022 15:40:39 -0500 (EST)
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com
 [209.85.210.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5BB7B4B922
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2022 15:40:38 -0500 (EST)
Received: by mail-pf1-f179.google.com with SMTP id k79so11508150pfd.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2022 12:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=Pmk4xq5A3rzrlj2+ophiAaZi/UXmP/mo3GRVdbl+68c=;
 b=rBZZZQ+6jmJ0L8kt2AAAyWKDYURGWgg2jYIvzhfsZvZvEtJZOEgaefc6924ldak9C4
 bGIi/87uhR4CkdUNv1Y9HrDcs8qRvip5lwN+kTe6HxiJSTKRPaovQ74xU513HQJ7wu7o
 DlowDD5mS9cCTp4yxhmu5/vCAZTJNw43eJjxbHD4DLmXp9oZYLJNY0QVLUcO2DHQ6uWv
 wHqRsl/XD2RLPWzKnNegucX6kUSMsfIQ67qE4GDKweu2IX1UQY2CSR53j7q6XnjAloNt
 3exq48ddIwSK7doMeHFKrwOlWhTnOgAD5nuGqynto1ETtEPVFhDmV/oIeKa3IBb91CIG
 eyMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=Pmk4xq5A3rzrlj2+ophiAaZi/UXmP/mo3GRVdbl+68c=;
 b=YcoJbRJ3U4OsPOzZiOtPwUpehfE0kKTMwLsA2Dio6Ejblo0sL7l3d9yEPNh6Ck3Fo0
 o9enZWid44CTuQspQD2hK1JO7xlk/pgCc/RV/IqQgI9rjJql7BqUi4FLWdQpW90ui8Xh
 gpthEGfQFPRtBJgnrE6TmCd+rh3XKrpCshsUYkjZH2ZX5xn+jCLJzSiD0rragqGdKux/
 TxO5r47Q7gvxXzDo1Ne3/MO7o7SMCoxgXOkElAERE6I1USn5svYw7ecZKjlQSmOfO8L0
 eRkUqxVQb91YgGIvtIHlo3mFYY59MzXv7ebytlZVVAA3gIYqIPZk/5uXKacVdOhLiwKH
 4z7Q==
X-Gm-Message-State: AFqh2krNAOhf2LF2+SUofHqrtAVQikquxcquocTHpYjg2f+dr+VFk97B
 X5qup5FZ7S3gQEy2Qe8EigRB5Q==
X-Google-Smtp-Source: AMrXdXsax/iqZklqdXP5/90X5ExMF635ed0bL4vX13zR5gG19L2ERgmig6NZK0frHLvyHdzzrJLAXA==
X-Received: by 2002:aa7:9514:0:b0:57f:1da7:a781 with SMTP id
 b20-20020aa79514000000b0057f1da7a781mr3809463pfp.25.1671655237614; 
 Wed, 21 Dec 2022 12:40:37 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 r4-20020aa79884000000b005763c22ea07sm11017784pfl.74.2022.12.21.12.40.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Dec 2022 12:40:37 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Subject: [PATCH v4 3/7] arm64/sysreg: Add CCSIDR2_EL1
Date: Thu, 22 Dec 2022 05:40:12 +0900
Message-Id: <20221221204016.658874-4-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221221204016.658874-1-akihiko.odaki@daynix.com>
References: <20221221204016.658874-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Marc Zyngier <maz@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
 asahi@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

CCSIDR2_EL1 is available if FEAT_CCIDX is implemented as per
DDI0487I.a.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/tools/sysreg | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 097d6faafc87..01d592cbc0ba 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -899,6 +899,11 @@ Field	5:3	Ctype2
 Field	2:0	Ctype1
 EndSysreg
 
+Sysreg	CCSIDR2_EL1	3	1	0	0	2
+Res0	63:24
+Field	23:0	NumSets
+EndSysreg
+
 Sysreg	GMID_EL1	3	1	0	0	4
 Res0	63:4
 Field	3:0	BS
-- 
2.38.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
