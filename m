Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DEA806
	for <kvmarm@lists.linux.dev>; Sun, 18 Dec 2022 05:15:28 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id hd14-20020a17090b458e00b0021909875bccso11405521pjb.1
        for <kvmarm@lists.linux.dev>; Sat, 17 Dec 2022 21:15:28 -0800 (PST)
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
        b=a89TNfXB9ENsF5nDtef2Zr+zdVVCO39vFzNN8/Gsmetpqq20DcbLbIKRB5Z/WxHq1i
         yoeHpxJ4uVSQAsVLt/+cgk4k5MsFh0QQ5Fo17IvrAy/8kay76RMGnGR0c8CnffHdi4IS
         TOPgy0RUkkjnY28buBCi1/gXUzUFg8zTWZxuWyy+/SWzRcVRdMi3RBt4+vCedJR7ymdm
         OLD8OBKnT5uebc8eImzgcP2J9uWAmgxt2zd+GakcwPszLz/pWCFjzqkqFXolP0WIXeQW
         AQ7rEwLXoYGFqkBH5dB3sSwnKJwHO5J7UWEUwTpHq4BWvXpc6rMJ+pl0BpDjvCdi9hCG
         AMMA==
X-Gm-Message-State: ANoB5pmdOLIhfnACYE/5t9CP8VbsK0Ppm37nLbKFfiz81gxtBKr95vQq
	ZR/zHlnBgGpAlYDXgertyHgltA==
X-Google-Smtp-Source: AA0mqf7vb6+GyWqLL5OnXKgkL1qGpIo5stbUWTmlKYousX0ZRaRgIzvlA59WnLDwjmcjYLYidZRXJA==
X-Received: by 2002:a17:90a:b891:b0:21d:5e73:d562 with SMTP id o17-20020a17090ab89100b0021d5e73d562mr37465528pjr.27.1671340528507;
        Sat, 17 Dec 2022 21:15:28 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id b1-20020a17090a6ac100b002139459e121sm7002417pjm.27.2022.12.17.21.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 21:15:28 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Cc: Marc Zyngier <maz@kernel.org>,
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
Subject: [PATCH v3 1/7] arm64/sysreg: Convert CCSIDR_EL1 to automatic generation
Date: Sun, 18 Dec 2022 14:14:06 +0900
Message-ID: <20221218051412.384657-2-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221218051412.384657-1-akihiko.odaki@daynix.com>
References: <20221218051412.384657-1-akihiko.odaki@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221218051406.lhFlUiSsA7hkqP4nT8n_4a8eerwydjUeP1TtF00nKCE@z>

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

