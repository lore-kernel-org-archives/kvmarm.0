Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51184538D
	for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 20:45:07 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id f15-20020a62380f000000b0058db55a8d7aso1430079pfa.21
        for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 12:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gau1yQskHf3VXQpkYLtjLur+Qip6kit3p9HDDaJBRs4=;
        b=f1tvDTkJ9Rdj2sN9ssxN48UvzmplgYwTrZ0hhtRdBm9fRaPLn8g8VcDs0rLpbFcHEO
         27uS/Yu9hQmGtLZ99VCsQzwNchjpqj2B6r0Xr8JbcX69qEPLXE/ORk0iBr0fjYz0+nu9
         5FqcIFvNu4h5DsqJ5X6gcJE+XAjXWHcCit7jhK0MSJYvkTi209/LoB2JzX79iYN4FFQm
         K4XiVxY0vElKce6pOAA4fTVctu57lRe6ssarPx+s4HXm82RDYdSwG6tVPxToUsj+qnzK
         sNnF9xQEuFU6bWgkzcAgoyJ8kaKUPKPhSg7qXZMzPNbTFJyUSaAxOjzq7Jy1Wce9mH6r
         SUjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gau1yQskHf3VXQpkYLtjLur+Qip6kit3p9HDDaJBRs4=;
        b=Lzd4mpH1cqeSXKaMDQmG66jzY+1PP3nojHoXUVEvfT6W4PhFMaUaMCiI04uwesOLCX
         0G65nEA/60joSBjh2pVYMhPhMUIKdVkQRo/extI5FKF2mYk33Mj3yViY2tvXtead65nY
         CX0zT6bbMmmAyfaC7eMeix4I/EE4kLi4Ssey5COeaxKkPAONuNW2ke+iuMAbFGX4/Op8
         clr2cZsqva5lGc3sLd+FDvSZg+/slVlNkrsHM3HkLaOWEj8/tjuf0VJJhBVYHkoSh1bn
         ZckRGsMB16qb065DJwaCPFOxut9KN2wF4S6vecshTKhQGf3odCBjLdKi60/OHu7xZMNv
         KCzw==
X-Gm-Message-State: AO0yUKUaYIxJvPc9jd/TzT3FuiFcwjQi22Vpj9p10WW38BoDLdO55d9m
	u2s+n0ObChTvtZ2l8Fs7sE4ulQ5Z8sldt0o=
X-Google-Smtp-Source: AK7set/TbnBjmUgqAAFzQMjbref3OlBWOk5pcb13kQePVWLM6NrlJPmaTSILrlFJ/sogPIbjRGpVECGiCbZN5ng=
X-Received: from zaidcloud.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5325])
 (user=zalbassam job=sendgmr) by 2002:a17:90a:2983:b0:22c:4174:3ad with SMTP
 id h3-20020a17090a298300b0022c417403admr156376pjd.24.1674765906698; Thu, 26
 Jan 2023 12:45:06 -0800 (PST)
Date: Thu, 26 Jan 2023 15:44:44 -0500
In-Reply-To: <20230126204444.2204061-1-zalbassam@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230126204444.2204061-1-zalbassam@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126204444.2204061-9-zalbassam@google.com>
Subject: [PATCH 8/8] ARM: mach-virt: Select PMUv3 driver by default
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

Since 32bit guests are not unlikely to run on an ARMv8 host,
let's select the PMUv3 driver, which allows the PMU to be used
on such systems.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Zaid Al-Bassam <zalbassam@google.com>
---
 arch/arm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 137f89ad0521..3802997fb36e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -400,6 +400,7 @@ config ARCH_VIRT
 	select ARM_GIC_V3
 	select ARM_GIC_V3_ITS if PCI
 	select ARM_PSCI
+	select ARM_PMUV3 if PERF_EVENTS
 	select HAVE_ARM_ARCH_TIMER
 
 config ARCH_AIROHA
-- 
2.39.0.246.g2a6d74b583-goog

