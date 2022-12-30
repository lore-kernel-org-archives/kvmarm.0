Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C721FD8
	for <kvmarm@lists.linux.dev>; Fri, 30 Dec 2022 09:55:12 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso25336847pjp.4
        for <kvmarm@lists.linux.dev>; Fri, 30 Dec 2022 01:55:12 -0800 (PST)
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
        b=iHexfTXIcc4ay2BzgymH1mruSJoIaOaF1abRQyHj3U6UXRoLrVBPPR4YrT0wnXFCLV
         yS6/yyRcGEaBZ2CwefP56QwmhanoEDUSxKl6XiDsuw0VOJKED6c7nr+AfL9GdA+4xoyC
         hYc9EPQ8QyQNaYuVDfqAWlyk0EBz0vBRLrOWIR+XhJU4AdXQJ8TKBd6ydEZJSEz9qte8
         IP0xDhki4uDRLAji/nO17PEYljXKPPJ0Js+Vk1s2zhys6j7cPFiz906QbOA78dE01w/5
         DJf51WYzSeBqX5i3jEv0MHxZHXyUIVA96rHTkSD77nN37KL+WP7gHlS7OtS/7+lkov6X
         tONA==
X-Gm-Message-State: AFqh2kp1CqGezXgHWRw9YXYustAENnSMek2uf91qtZWPyiPPqfmJwGVO
	EKtab9DgEJ84Tfs0yoBl3ync4Q==
X-Google-Smtp-Source: AMrXdXtSRFfO2p1wbW3ViQzM9RIF7nl9dbVTX5rM/MOJJVKgQugKaChiS3aO1Z4gX+n1jZDeTh6hIQ==
X-Received: by 2002:a17:902:e34c:b0:185:441e:4cfa with SMTP id p12-20020a170902e34c00b00185441e4cfamr31132628plc.42.1672394112244;
        Fri, 30 Dec 2022 01:55:12 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b00189c536c72asm14487719plk.148.2022.12.30.01.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 01:55:11 -0800 (PST)
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
Subject: [PATCH v5 3/7] arm64/sysreg: Add CCSIDR2_EL1
Date: Fri, 30 Dec 2022 18:54:48 +0900
Message-ID: <20221230095452.181764-4-akihiko.odaki@daynix.com>
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
Message-ID: <20221230095448.rFrW9aNSlZjv77j3Y8W0IvEVIL7zfOX8HOxHhOOoa68@z>

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

