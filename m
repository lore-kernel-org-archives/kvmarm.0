Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56134C10F1E
	for <kvmarm@archiver.kernel.org>; Sun, 18 Dec 2022 05:15:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8C494B5EA;
	Sun, 18 Dec 2022 00:15:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YeQqUzEvGCMA; Sun, 18 Dec 2022 00:15:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B25F4B3D2;
	Sun, 18 Dec 2022 00:15:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A27A43C6F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Dec 2022 00:15:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Re53qiGj2wC3 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 18 Dec 2022 00:15:29 -0500 (EST)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A2614B286
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Dec 2022 00:15:29 -0500 (EST)
Received: by mail-pj1-f47.google.com with SMTP id
 fa4-20020a17090af0c400b002198d1328a0so11674132pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Dec 2022 21:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=fSSvNarkcX8fxYBT0hcpDCN4tMu56rqMEzf7f5+m+DY=;
 b=iLqdfLkStRaxHz+T3WwGYnUjZRwjQLDIM6smk/z9ggwXePajQv6m0ooG9QKQ0GWRTA
 wqdAAu0KvXiBq/eKd+yVFjDuOUwe+wF+VD0VTuWUEasfwUtJtRw5ySEbZg7q74TrfE6u
 MZTYLlVYskcnskHNAw1baY8qVMmQOP3ZU4bmyuRcOtD2UWIC/3lVpWyYigGECtFjYxAA
 4CsfHveHyc6NYMba0olefWZFBbCxIl8BjdNDhdpoPfnEtcH1NOAn96086MnE1pOtjZ+n
 89ChjXUU7yurmLWae+JylmBuTNf1ZGfFjVRK1xNYBkoPA4KWHOMd3fZEZ+bYF3tYsQeg
 y1yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=fSSvNarkcX8fxYBT0hcpDCN4tMu56rqMEzf7f5+m+DY=;
 b=o5ETQiFrsCszf2TStooHT0QfYinMR/mf/2hFKw+uxkkN+q7Z5s3bUhvAupnDGaoRd/
 Nas9fcdTE2hWb24edlp8DMvE9MExqYZWsgIRy0XhQ5ONsZ8nRZKJqCbFzCg+1j8YBgkw
 qfWBlQSfKbqsHwkpk2txGjUM8pjKVxjvZixZSGo2xImT83QP+Xtl6cBcBe78Ytz47od8
 3cS4VzvusTxDMlg3UcV/rcpMEPUq2oKzvdQWLPKnEeryjoVUQqwOgfFMNcLoAIzJVV1R
 oYWjAXLMk2Uew299oBza7d18pA90BLfS0hd/s4EflaRFSe2jXd4mhs4Ul0maHZPmlkWr
 vVXQ==
X-Gm-Message-State: ANoB5pmJNqVe2e3cGqPn4Tnp5LQi2mZ4FACVQ9spu4FLCxnsyBSoo59M
 o4OKbmNWGk9AffDWP2RANQmDDA==
X-Google-Smtp-Source: AA0mqf7vb6+GyWqLL5OnXKgkL1qGpIo5stbUWTmlKYousX0ZRaRgIzvlA59WnLDwjmcjYLYidZRXJA==
X-Received: by 2002:a17:90a:b891:b0:21d:5e73:d562 with SMTP id
 o17-20020a17090ab89100b0021d5e73d562mr37465528pjr.27.1671340528507; 
 Sat, 17 Dec 2022 21:15:28 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 b1-20020a17090a6ac100b002139459e121sm7002417pjm.27.2022.12.17.21.15.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 17 Dec 2022 21:15:28 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Subject: [PATCH v3 1/7] arm64/sysreg: Convert CCSIDR_EL1 to automatic
 generation
Date: Sun, 18 Dec 2022 14:14:06 +0900
Message-Id: <20221218051412.384657-2-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221218051412.384657-1-akihiko.odaki@daynix.com>
References: <20221218051412.384657-1-akihiko.odaki@daynix.com>
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

Convert CCSIDR_EL1 to automatic generation as per DDI0487I.a. The field
definition is for case when FEAT_CCIDX is not implemented. Fields WT,
WB, RA and WA are defined as per A.j since they are now reserved and
may have UNKNOWN values in I.a, which the file format cannot represent.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/include/asm/sysreg.h |  1 -
 arch/arm64/tools/sysreg         | 11 +++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 7d301700d1a9..910e960661d3 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -425,7 +425,6 @@
 
 #define SYS_CNTKCTL_EL1			sys_reg(3, 0, 14, 1, 0)
 
-#define SYS_CCSIDR_EL1			sys_reg(3, 1, 0, 0, 0)
 #define SYS_AIDR_EL1			sys_reg(3, 1, 0, 0, 7)
 
 #define SYS_RNDR_EL0			sys_reg(3, 3, 2, 4, 0)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 384757a7eda9..acc79b5ccf92 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -871,6 +871,17 @@ Sysreg	SCXTNUM_EL1	3	0	13	0	7
 Field	63:0	SoftwareContextNumber
 EndSysreg
 
+Sysreg	CCSIDR_EL1	3	1	0	0	0
+Res0	63:32
+Field	31:31	WT
+Field	30:30	WB
+Field	29:29	RA
+Field	28:28	WA
+Field	27:13	NumSets
+Field	12:3	Associavity
+Field	2:0	LineSize
+EndSysreg
+
 Sysreg	CLIDR_EL1	3	1	0	0	1
 Res0	63:47
 Field	46:33	Ttypen
-- 
2.38.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
