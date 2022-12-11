Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 255FFC4332F
	for <kvmarm@archiver.kernel.org>; Sun, 11 Dec 2022 05:17:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 905FD4BD46;
	Sun, 11 Dec 2022 00:17:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P2FWlt8ll7q1; Sun, 11 Dec 2022 00:17:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BE3E4BDB6;
	Sun, 11 Dec 2022 00:17:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E8C44BDB2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Dec 2022 00:17:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pNWrrROUKzjY for <kvmarm@lists.cs.columbia.edu>;
 Sun, 11 Dec 2022 00:17:30 -0500 (EST)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0B7754BDB1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Dec 2022 00:17:29 -0500 (EST)
Received: by mail-pf1-f180.google.com with SMTP id n3so6417215pfq.10
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Dec 2022 21:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=A5kiwn5okie3cYkwLwnJvTGi40F+wMTuMjX2LuHOS+A=;
 b=WM+yFLRXJy6JnBZbZOpn5+t8atNOLnueKar48v96qp2NwU/8Ik1wwnuxmytttty2z9
 ITUmFGcOh29D6O6PlCO0PlhB2szHk7iTkSdA0gLqBptODhfUF520Gbgw7MZBVwLwLiTw
 0CSCnOHilk+hhVw4IuvHirujaQAZXrBuPE4ZmouZYqe2dHTtICsf6+0xz/CW8OWjOcpj
 JOCFkmrSinl+xQUfrSMRl/7MyercuXij7RIG389zwGUekxyDAo63H1HbdgfXDq4JFyI8
 2HRfGSO+Go17DonBkq5ok61YEIAdu2j4o7pvrlOMtTlhWZV7F0tGbfILJBgZ/rE6SGs2
 p8ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=A5kiwn5okie3cYkwLwnJvTGi40F+wMTuMjX2LuHOS+A=;
 b=2/2R1yg4/ztiqW31U1UvQljnuo5A0zZGIVjZ++WTqI7uGjEnvmxWcHg4nGfj36AJvp
 CkcpU/OzJpdXnzD+7ZnW+lT7VaWNcqImSLuOuPizi/tUZjHB3jXC4wS+l9bYtDtK31Vy
 sJJ6hg03gwnvWa34qSBazH/C6T6rpgDTGuiwZv6L38/GXqcpKgBY+cVvTk+EIHyrYb7s
 rDU7bn/PcHIimqfU+0svh54VjQGJdV9xet4+k1mcRgfsUJg8GhPht0zoh5Og55qFjVEq
 hzFi7v6d8zzfRsGu6jk6AphZGLp1pB/fGkFllajCxJBzEnfPlePnCJdqVkySb4nXzq01
 TNsQ==
X-Gm-Message-State: ANoB5pkVFXOkaqi6QfmDrfpcEQz0kdEQYbJQSbZamoZ4YOzMIdWD4Nb1
 Zsm3NKVpfBHe6SijvgXHnN0LTg==
X-Google-Smtp-Source: AA0mqf4MODz3PRgxNZCX+N8VP2CyAydeEtYzkGUUPBV3KsYk9uUNpuHV9OrohMyN3dXkAHtnQP7GRQ==
X-Received: by 2002:a05:6a00:1c81:b0:577:8bae:29a7 with SMTP id
 y1-20020a056a001c8100b005778bae29a7mr10830364pfw.33.1670735849244; 
 Sat, 10 Dec 2022 21:17:29 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 f125-20020a623883000000b00575d90636dcsm3463684pfa.6.2022.12.10.21.17.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 10 Dec 2022 21:17:28 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Subject: [PATCH 1/3] arm64/sysreg: Add CCSIDR2_EL1
Date: Sun, 11 Dec 2022 14:16:58 +0900
Message-Id: <20221211051700.275761-2-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221211051700.275761-1-akihiko.odaki@daynix.com>
References: <20221211051700.275761-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Marc Zyngier <maz@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, asahi@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

CCSIDR2_EL1 was added with FEAT_CCIDX.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/tools/sysreg | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 384757a7eda9..0fb08c53fcdb 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -887,6 +887,11 @@ Field	5:3	Ctype2
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
