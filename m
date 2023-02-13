Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CC5AD54
	for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 21:03:43 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id z8-20020a170902d54800b001994bb90ddfso7866077plf.8
        for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 13:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PNlCxue8f7lOs6QuvM7/2EAnGBBamHm0s0gmH31uJ+I=;
        b=U058KpMINjh/TIWfjHqmqrzoZS+zo6kQ3qBHMGBc/zxuaVSMiK2aoKmOj9MVkOtqiH
         kQv+V8ppdbQr3FiXtnTo48s1embSUNk9+M2x/tDoErzuwTHbvafGS5z6hPD6+GWuYEPW
         uZSZ7pD6wZg/ji/Ee08N75aHmpCGZs0oRo1k8TmWL/nbIAzTTqF6j+kzGC0cGpO5sKRZ
         3Di7zJrx8vMmDb+mBOROXRu4C4pC5sfeowRAAL1tgiNYmWN9CQmKOwhVOOARyOyi/HSp
         TETl92ToaFLbPJB8RatdASWp5YMsJK9xcUT0MEjgmm8etExgbW3gKRELybDRmrFH7WJD
         85mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PNlCxue8f7lOs6QuvM7/2EAnGBBamHm0s0gmH31uJ+I=;
        b=JJCBo4o3rc2ipLCg0dD4nYKuwlYw/jrohWoqtgrJ4n9bA78EPnU35LRCG8EffUgCTe
         YrFTUPg22tFseo2tl+kRIk2Nmt0bwXDPvJT2y7a4WAy7xxvCY/pPsPfH0BBiQYp/BAgA
         CtmGu4BMzztFvqbvhVHBCb+MYOUQ1waZo4PiBhlDZ3Dil7AeMnTneaSak9y1O3ZfS1K/
         JLro1wRtgfYg+NK9cXg3PICMFXzrHL49q80dbliJwP5EJd7g17ZPweypMRM9gNAROHgE
         HUp3zZl16yvvVbtJEKY/bLnWsiDAX1KT0PnIa6r5zharCVfCxK1BCi1Vvig9oPg0sz1n
         bqrw==
X-Gm-Message-State: AO0yUKXUusbRJLr8wwakyOmt+l4MzK8Kv9AIn/tcW4oOGUGOrjIQtnJ9
	55ibvQEwOKb0e4JobJ56v0YIn8KlsMP8Gxc=
X-Google-Smtp-Source: AK7set+80DDsCF1md9COtpoXmv7reEuLQsu7dVpGY6/rfogIf19/pYZcTTCpC8Ysd1iYqvJlAziEz4DFcLpoalI=
X-Received: from zaidcloud.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5325])
 (user=zalbassam job=sendgmr) by 2002:a17:902:9682:b0:19a:9980:854 with SMTP
 id n2-20020a170902968200b0019a99800854mr102676plp.3.1676322222866; Mon, 13
 Feb 2023 13:03:42 -0800 (PST)
Date: Mon, 13 Feb 2023 16:03:17 -0500
In-Reply-To: <20230213210319.1075872-1-zalbassam@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230213210319.1075872-1-zalbassam@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230213210319.1075872-7-zalbassam@google.com>
Subject: [PATCH v3 6/8] ARM: Make CONFIG_CPU_V7 valid for 32bit ARMv8 implementations
From: Zaid Al-Bassam <zalbassam@google.com>
To: Jesus Sanchez-Palencia <jesussanp@google.com>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Zaid Al-Bassam <zalbassam@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <marc.zyngier@arm.com>

ARMv8 is a superset of ARMv7, and all the ARMv8 features are
discoverable with a set of ID registers. It means that we can
use CPU_V7 to guard ARMv8 features at compile time.

This commit simply amends the CPU_V7 configuration symbol comment
to reflect that CPU_V7 also covers ARMv8.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Zaid Al-Bassam <zalbassam@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm/mm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index e949e84a2decd..b77f4a0d9072e 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -403,7 +403,7 @@ config CPU_V6K
 	select CPU_THUMB_CAPABLE
 	select CPU_TLB_V6 if MMU
 
-# ARMv7
+# ARMv7 and ARMv8 architectures
 config CPU_V7
 	bool
 	select CPU_32v6K
-- 
2.39.1.581.gbfd45094c4-goog

