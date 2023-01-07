Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEB51842
	for <kvmarm@lists.linux.dev>; Sat,  7 Jan 2023 09:46:52 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id b9-20020a17090a7ac900b00226ef160dcaso2547983pjl.2
        for <kvmarm@lists.linux.dev>; Sat, 07 Jan 2023 01:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fiIDHLmR6Z3DLA7ZmBUtEJMzeUne5nEPIKyDcmHBzVw=;
        b=yJu2zPLq+s3FH5mEbGHQnaCOt/fA1bkJ9uAuTdCgzCGYTMFL+vOE4qNDxb8QaYyqTT
         SmSc46YwBbIloQzijwBeh/41wdk9+x746aDufVmzZgqNxrXtG5ex4N37BM6umBV1A01X
         YNHNAMgbrMalLioaSGoV6M7TWVlAUjJ/FlPCJ1kndfbS4VpAEi/5RS9tXJvApoOLWpIM
         GWFqJxy+Ol7XHPIbWNO5RZydcFUH2Ur6+4RJPELKzDnoKNjVXYaAdJqdBJ7WDysSbxN2
         Ysl+pE29yF5jM8zHPA9XPrevwOOh5Dh/068nECqwqSvwROBS+8X0Z0lsEgYI3X85o3KE
         vnYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fiIDHLmR6Z3DLA7ZmBUtEJMzeUne5nEPIKyDcmHBzVw=;
        b=dP9Hyvt8SvtzCby+K5ZH6NeJZceoQikUADo1M6uRMAO9G/EhnUNLZWOfFK+VYclD1n
         1jRty8OcaDormBtfqlGhhMlN5Lc7IlxUG8qKAQJWd0dWyDN0ZIgmdyOPXI/ToU0gjiTR
         mPBiBJkVqudyrZYp7uxAoT7l33pD+A1uOGAX+yWboKfM8WMqNCODZUN/4pmwQx3lHLOv
         snKWDL68DU1cWZXabI+GumTE6331tOczRRoeGqnvAm5TJLqKOIb4CzN32fjCowi/pO7P
         5Mgt+bN9CeNKd4H9CGgT+ELbXML2+XI60R607o7L8E4U1RcC4U/GZSYwxP9T5frQ4ikg
         Or4A==
X-Gm-Message-State: AFqh2kqTciv7MSlKVyOv9fnt4cG7Dj5Mto9bqll29CSx3u8BJEds9M0t
	OuDW612HKXYna9C3RM9uj+PkXg==
X-Google-Smtp-Source: AMrXdXtmYw6MgSdZBfTMXKijPPEzf8bJIA2VpXjIRChc0KKR72/kDm2z6Pxza0jgOTVy14a/H48EyA==
X-Received: by 2002:a17:903:181:b0:191:1b93:e391 with SMTP id z1-20020a170903018100b001911b93e391mr79420228plg.63.1673084811969;
        Sat, 07 Jan 2023 01:46:51 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:a840:1e00:d54:e521:8bac:7bed])
        by smtp.gmail.com with ESMTPSA id n9-20020a170902d2c900b00183c6784704sm2263449plc.291.2023.01.07.01.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 01:46:51 -0800 (PST)
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
Subject: [PATCH v6 3/7] arm64/sysreg: Add CCSIDR2_EL1
Date: Sat,  7 Jan 2023 18:46:25 +0900
Message-Id: <20230107094629.181236-4-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230107094629.181236-1-akihiko.odaki@daynix.com>
References: <20230107094629.181236-1-akihiko.odaki@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CCSIDR2_EL1 is available if FEAT_CCIDX is implemented as per
DDI0487I.a.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/tools/sysreg | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 45648fa89be8..90b64697345f 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1663,6 +1663,11 @@ Field	5:3	Ctype2
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

