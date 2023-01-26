Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313EE538D
	for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 20:45:03 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id dc11-20020a056a0035cb00b00589a6a97519so1407077pfb.8
        for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 12:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EwzPZHPsAKvYmgPaOXFHIXWk96k1/mVIbUR6ZLbCeOo=;
        b=sjTOX0tbY7UDj7YQC9tG/vi0URtTLhlec3V0xhmTN6Ohhmb/18ffK+c6FLzN3QyAYz
         GDDO1TNPjs42kQ7KWyo4E+sg7M1a5Nieesq1IHuJ2RwuCl6hJGOjmFYV4S7PqQxHb5oK
         TYcxVTJLQF80vwvBhtWBStbmFPn2rTZx/4hjn3Mt3sVzIc0A0Y9yqEWO7URlkGiaZpN2
         QineabgOkUVT6Bu1LVaMreQvfN+EtyHAyaPyKOxTInstmz8MdJED/A2SO6Z28OXoqufW
         0LOaKnIdPiCYfI4sZ/UEf13x4JqGjhUPWHKmkuUA/LJTSmmg8/ORfZoeBsm6Grt8AeO5
         f3MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EwzPZHPsAKvYmgPaOXFHIXWk96k1/mVIbUR6ZLbCeOo=;
        b=gsfcoyVb7x7qea4Iz8K3qIX+s5u/Q9V5hqaqGxD+/GabFtNJ2Z0a2KRduLx/Wl5IKS
         nHKRD9VY0VqIGaDAhYdk8aBYO2WoDVPR8k1gTRhZgMG4SWsH23Bu7M7saJbMVCoiEnyp
         yepjPzrTa6ee6PDXd3Djc92Zcj0tGlu2N+xYqLIzzsTJbH0hDCVGdrA4Q13o+ZiULSZO
         Nd0h3fyz7T2LAnrhkf8bQWDdfkjS0LaVYQGX0woYAxCogAkZlpPv1FrVBvVj+uWAO+As
         QYPNKkFJ4Iqgwp51KDag9LEVcI3QGv3NaK58qDVT0r38nUx/QpT7Azh55uvcDv+Iy/cE
         ZYpw==
X-Gm-Message-State: AO0yUKWkPWh/Uk3ZPrij7PsJT3c/8QLhrJsrNB4bQAj0Cz3sEcU3Naz8
	GC6tJ97RCyoSWW0wa0E3lTcGZkTNYrFQADo=
X-Google-Smtp-Source: AK7set+MGxgQBz/1oO7K76qmPJ54mP7Z+dqqknPhNPhQ8N2pNNvbFsTR8SK9GU3iWYgoDuawG0diyZOfrB+NmiY=
X-Received: from zaidcloud.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5325])
 (user=zalbassam job=sendgmr) by 2002:a62:2542:0:b0:590:7829:f566 with SMTP id
 l63-20020a622542000000b005907829f566mr694764pfl.50.1674765902603; Thu, 26 Jan
 2023 12:45:02 -0800 (PST)
Date: Thu, 26 Jan 2023 15:44:42 -0500
In-Reply-To: <20230126204444.2204061-1-zalbassam@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230126204444.2204061-1-zalbassam@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126204444.2204061-7-zalbassam@google.com>
Subject: [PATCH 6/8] ARM: Make CONFIG_CPU_V7 valid for 32bit ARMv8 implementations
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
---
 arch/arm/mm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index e949e84a2dec..b77f4a0d9072 100644
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
2.39.0.246.g2a6d74b583-goog

