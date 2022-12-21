Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196DA3212
	for <kvmarm@lists.linux.dev>; Wed, 21 Dec 2022 20:40:38 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id x66so11519602pfx.3
        for <kvmarm@lists.linux.dev>; Wed, 21 Dec 2022 12:40:38 -0800 (PST)
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
        b=r20xmRk9tPjHKr0obUxLLBwSkI/MpmSLGdTBv85WZBfsXgqb6AEfMnRbgIyMjqtjMn
         Mi5A3z2u1vRb2PFxgScJryJlur4pHTI/V7WoezNvr5hpfVqQPaSMzR1HZTWrEQOp/V6W
         RTgelGE3egbI/ni2RZP/wGKhdlHcDu01OuExaKMVYfOYWbSDc5pReVrcOAaYMUJ6CnsR
         Yn3QZD6H6nntof23RcmAKsq7ExHKHlw9C26MCHmoE+T5+XhSJJd9LWXdMW4lzSwNo4QO
         CNAtJwgIE/0djZh8CKf3jEjciiii+LyDkcbWKvrDoDFsz/kFkS63LIyVyAUC5wkm1IEJ
         xkow==
X-Gm-Message-State: AFqh2koaT5akaWNqz/6EDTA2ZRZmAvx+D97a8Ok/5LeRgJ5YL1cg0i3o
	ncfwB/EEp74SufC3F5haojk4dQ==
X-Google-Smtp-Source: AMrXdXsax/iqZklqdXP5/90X5ExMF635ed0bL4vX13zR5gG19L2ERgmig6NZK0frHLvyHdzzrJLAXA==
X-Received: by 2002:aa7:9514:0:b0:57f:1da7:a781 with SMTP id b20-20020aa79514000000b0057f1da7a781mr3809463pfp.25.1671655237614;
        Wed, 21 Dec 2022 12:40:37 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id r4-20020aa79884000000b005763c22ea07sm11017784pfl.74.2022.12.21.12.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 12:40:37 -0800 (PST)
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
Subject: [PATCH v4 3/7] arm64/sysreg: Add CCSIDR2_EL1
Date: Thu, 22 Dec 2022 05:40:12 +0900
Message-ID: <20221221204016.658874-4-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221221204016.658874-1-akihiko.odaki@daynix.com>
References: <20221221204016.658874-1-akihiko.odaki@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221221204012.ORP-hmgQmBlfk87bfS8wCmAN0MWrBT6vGfnqvxF-x4E@z>

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

