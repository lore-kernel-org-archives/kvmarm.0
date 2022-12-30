Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B00FBC3DA7C
	for <kvmarm@archiver.kernel.org>; Fri, 30 Dec 2022 09:55:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AE584B286;
	Fri, 30 Dec 2022 04:55:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IuPebeKMiUqX; Fri, 30 Dec 2022 04:55:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3045B4B5E6;
	Fri, 30 Dec 2022 04:55:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DFF34A0D6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Dec 2022 04:55:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ArxCU+M-pOHJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Dec 2022 04:55:14 -0500 (EST)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 17FEC4B5E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Dec 2022 04:55:13 -0500 (EST)
Received: by mail-pj1-f53.google.com with SMTP id
 m7-20020a17090a730700b00225ebb9cd01so13440015pjk.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Dec 2022 01:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=Pmk4xq5A3rzrlj2+ophiAaZi/UXmP/mo3GRVdbl+68c=;
 b=Py7rXdCdc1eVMHulbXcV8b2D30+WKztQa1e3UdcsdZbHvk8LLaAIAibEUYKPI2V7JR
 sG9B/ORoWEj4W0i0BeLlazoWnrqNYtYol0+LB0wlf65z6fXbH/v9gUFwCoPaiMWM+vxm
 Fyk0uZQqBNNuW9d6fMRIlZ04tBtlQ1LGbmbn6mrVurOhMxCNA3w0MoNr4sEYapB1XfjC
 eypkwVx6LMNFF18BygGQ9+S3WYsvtdHs5L5oU4vMYEQOg+9ouBSBeFJB2yElIUjUjD8X
 y+yTFUJI5X8k+JTQx/PaO0dak79rTD3RLA2uTYXySlr58FH4yLRNFNFnH0Pd7/piZcGn
 hcLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=Pmk4xq5A3rzrlj2+ophiAaZi/UXmP/mo3GRVdbl+68c=;
 b=l9lFpeOep6HgUEQU/kj46a5Csqc2Z2boDUxFZaBuNA662w5nUH1JKsbqsIvhzbwVEo
 IvzMqJB8/CSkKaetJDFK7fvD0nJj7BIUMkA+xgUtqIB1t3m9a8HuQN/sCNuf/hHNVdPn
 rHLCrybsQlo9Kt5Z+kbLzlU2kUVarl865VKIMGLzQ7LjkOVsyku/v5EciWKzSWiWLSf3
 tkwEgSEYsH5snic3skshAOqF/Hv4an3cNDbyk/6xBv5z8t/aWjJ/eSIdQBkql1BGFT1M
 0x4sllrnNwMnudvkiXY533Dc1GRLetJ4iwXsT2G0TSBIJP0RX0BaHKGJNkyRdSWZOUs7
 pn2Q==
X-Gm-Message-State: AFqh2koA9VCHmmQ7q0ojyR2zFzUiFlNBDWBdJej6RFmUi1veObM+sGa+
 WmzOgVTC5IKuMxABjYZDEm7eC/8tPnfMZpV0AIY=
X-Google-Smtp-Source: AMrXdXtSRFfO2p1wbW3ViQzM9RIF7nl9dbVTX5rM/MOJJVKgQugKaChiS3aO1Z4gX+n1jZDeTh6hIQ==
X-Received: by 2002:a17:902:e34c:b0:185:441e:4cfa with SMTP id
 p12-20020a170902e34c00b00185441e4cfamr31132628plc.42.1672394112244; 
 Fri, 30 Dec 2022 01:55:12 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 b7-20020a170902650700b00189c536c72asm14487719plk.148.2022.12.30.01.55.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 30 Dec 2022 01:55:11 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Subject: [PATCH v5 3/7] arm64/sysreg: Add CCSIDR2_EL1
Date: Fri, 30 Dec 2022 18:54:48 +0900
Message-Id: <20221230095452.181764-4-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221230095452.181764-1-akihiko.odaki@daynix.com>
References: <20221230095452.181764-1-akihiko.odaki@daynix.com>
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
