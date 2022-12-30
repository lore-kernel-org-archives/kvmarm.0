Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 747CAC4167B
	for <kvmarm@archiver.kernel.org>; Fri, 30 Dec 2022 09:55:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AF084B355;
	Fri, 30 Dec 2022 04:55:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Tuh0XBZUX55z; Fri, 30 Dec 2022 04:55:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B1C14A0D6;
	Fri, 30 Dec 2022 04:55:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 054F740BE7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Dec 2022 04:55:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id svthA15gTyms for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Dec 2022 04:55:10 -0500 (EST)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF1144B5E9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Dec 2022 04:55:08 -0500 (EST)
Received: by mail-pl1-f173.google.com with SMTP id 20so7935004plo.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Dec 2022 01:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=zggXqOYMewY2d3hZ3CPkP3qIf0LN+Vu5ELXaG5NbWEQ=;
 b=ik8i2dsg/lcvg+AOR1XkFPLbf+47WOq+jw8TuhUVIVQWRyTfG7IJaZZMvrzfES/Mlg
 62EzM3P3LwoYs2k9zXyitXQi2IElphOjRFxxZgWs+Z6U2bdaOlTHTRJZJ8YK71mAJ+hF
 c+4Std/TW2WunQoAeFkpiMGGoD6V7w2CwnVL6rCfrpJtFYUcuauyJiRd7ugqhkFzNKOo
 irpSMGLiuw8ShHjYDpPzE4j1BwlfpPD0qQlTSIMJEL0IHdrlzCBdKMxmWc++LFXNIiWq
 7fnxUH0OWw34OYz+WYwmKOQneo9H7IytsjlRH92SbjxnTg+BNQpTaslTiynIRmshIXA6
 O3LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=zggXqOYMewY2d3hZ3CPkP3qIf0LN+Vu5ELXaG5NbWEQ=;
 b=6iWSl1rdRqYI167wlZcqGTVj1e5K3tAqVLqkASDhn/5Cap4D2V92suq1t7NVcpjcai
 brA9exNIzb2Hxo2oY9BvwWX5R+olZrySAL7MrQn5yu2jjuk7MeO4qdHtF4HAWbLenAvT
 HJTL7aUxLoZELRHK/+qEXnI4K28epIBY1dauJCrJ6skghP2yx7oORHmEXu33O65o0wXX
 7mCN84urzw4Q7WgyStR6a+1SPVpptpE5R8eM/Z40u55RbsfrfZV+ENbzwx74CozSjiTn
 4Hc4ziJaKu9xbFerfm9oa3PEKter0ayd9o0lDqsSkuoMyIlc2GuV7l2xzoBCusv1WtWh
 TnlQ==
X-Gm-Message-State: AFqh2kqIdXHkvrTedFJyG52uNo+k3q72nEcNMH3cIWER7wxn0lGpo+jf
 WM9UtHdUR3i4jMfTtQxnwQ+iqw==
X-Google-Smtp-Source: AMrXdXvGMIVFFgtATbw0q2lsn/zLJnzh6sQGfMIVn1mk9W3uwE553KoECNHYMuTkJK21nl/C/+mFdg==
X-Received: by 2002:a17:902:6a85:b0:191:420e:e6b1 with SMTP id
 n5-20020a1709026a8500b00191420ee6b1mr33509015plk.32.1672394108083; 
 Fri, 30 Dec 2022 01:55:08 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 b7-20020a170902650700b00189c536c72asm14487719plk.148.2022.12.30.01.55.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 30 Dec 2022 01:55:07 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Subject: [PATCH v5 2/7] arm64/sysreg: Convert CCSIDR_EL1 to automatic
 generation
Date: Fri, 30 Dec 2022 18:54:47 +0900
Message-Id: <20221230095452.181764-3-akihiko.odaki@daynix.com>
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

Convert CCSIDR_EL1 to automatic generation as per DDI0487I.a.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/sysreg.h |  1 -
 arch/arm64/tools/sysreg         | 10 ++++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

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
index 8f26fe1bedc6..097d6faafc87 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -873,6 +873,16 @@ Sysreg	SCXTNUM_EL1	3	0	13	0	7
 Field	63:0	SoftwareContextNumber
 EndSysreg
 
+# The bit layout for CCSIDR_EL1 depends on whether FEAT_CCIDX is implemented.
+# The following is for case when FEAT_CCIDX is not implemented.
+Sysreg	CCSIDR_EL1	3	1	0	0	0
+Res0	63:32
+Unkn	31:28
+Field	27:13	NumSets
+Field	12:3	Associativity
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
