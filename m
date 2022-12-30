Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883307E
	for <kvmarm@lists.linux.dev>; Fri, 30 Dec 2022 09:55:08 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id d9so4618208pll.9
        for <kvmarm@lists.linux.dev>; Fri, 30 Dec 2022 01:55:08 -0800 (PST)
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
        b=RhI5PDBEewGAXMW15nGLL8Xj4fTMdbJ1UWJ1ilEvHzjPlKsqOR+DJzoXPvlRqjyxbd
         SjsJay1bzZlrn0NWAFmdBF4FzkFL/+bsjDviSrxxLZ31ONALspda0S6Jrrvcocz/UB6C
         rSgqiwiHhE7eenerMvlAqBYlANzZN7J9ROSMQAqg/FDJM85h/6lPYZL585St47eWNaQS
         0YpWZL50A1aTOMJKIxU3bUhW28SOp7orcVf84aS5FakYvmb3FSMRe8as/ODMHzCTOHLr
         ZsqcB2pdUJeTMDuy4jq/2EI92N0u+uNgJU3N9Tl9I4rvfBcTultzadTWl2st5MlRC0lN
         bwAQ==
X-Gm-Message-State: AFqh2kr5hbOa4rMdG9YtS2xVZriIR1VFmOLHQ2zQRQnJyCmhIJl6g5va
	gag+B12U6xdoFWpPXN8PnGRmvQ==
X-Google-Smtp-Source: AMrXdXvGMIVFFgtATbw0q2lsn/zLJnzh6sQGfMIVn1mk9W3uwE553KoECNHYMuTkJK21nl/C/+mFdg==
X-Received: by 2002:a17:902:6a85:b0:191:420e:e6b1 with SMTP id n5-20020a1709026a8500b00191420ee6b1mr33509015plk.32.1672394108083;
        Fri, 30 Dec 2022 01:55:08 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b00189c536c72asm14487719plk.148.2022.12.30.01.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 01:55:07 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Cc: Mark Brown <broonie@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	asahi@lists.linux.dev,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Sven Peter <sven@svenpeter.dev>,
	Hector Martin <marcan@marcan.st>,
	Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v5 2/7] arm64/sysreg: Convert CCSIDR_EL1 to automatic generation
Date: Fri, 30 Dec 2022 18:54:47 +0900
Message-ID: <20221230095452.181764-3-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221230095452.181764-1-akihiko.odaki@daynix.com>
References: <20221230095452.181764-1-akihiko.odaki@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221230095447.ZHykNJ7rjEjTcrViiova-fhriBBGHgi00ZH_0Uz-B7k@z>

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

