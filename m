Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B61863B6
	for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 16:55:31 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id w15-20020a25850f000000b008fcfd8e695eso604658ybk.3
        for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 08:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E9xr7inanUxvnhbT5e3KgIdxiMjmahu/YJZqJj0STyM=;
        b=dorYTVJY81IW8njZuZmcIkXwowwBggAihpo2PrUJFXxOns0g6cYH0r0Oh3CIk0/EpG
         09LvwEViXEJLDblRrkESm2N7DmIiMkq6MNY3K8s44kuozzJakiZSM52iDmpNwZg3O1he
         3x9hLXK482NAnKK246NGclWsTncJSMYtCfIu4oqPw8XaaqXcIAcjSaONYXAfeEf4U9Bu
         XF6O9pt03u+T2EdZqy1thJVjD7DJkCrkkfzmnjy/dKukLi/i2SBNPa06qYUKwKw3fFiv
         5tR5wi0SHBhSHjEPOKTAgVtdkFiuKPp1d+yur02vCPKrlDJnpxvdWzsJB5nPx7P0nFeM
         UC0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E9xr7inanUxvnhbT5e3KgIdxiMjmahu/YJZqJj0STyM=;
        b=6Dyz8+1f5UiBnO3BDPYV/9e3AR0lB1h+UBP0nW2aNy9GJ7Sh4qRNZ/ftVgTVypqlTA
         NRqHg9fzQU5Zmc6glfrfL3PcmPhQvjTA9EFEbxnHutZtingSy8ArFo+j/Nd8aODzkA4d
         Qc4EWgFkrQkj+TAd0/5tBOd1IV78iGRUVPqiuq6dj1LecgrzXEsoTkbt0c7afvnehVKW
         xIcMBpgztsuA3nNEiSZ1APeyo6Yp/6k5s9AoJtTUqImCj73Zuo3FBRbMYHFbZgJu3PEh
         TZ9tIWhUGnUNjAScHuXchPc8r/ZsqTt5Owm3ks4GsL37kpgeHg2Y6g21LlVi+xPVVQMh
         9jaw==
X-Gm-Message-State: AO0yUKWi9bIrXZ7nPUJwEI4AGqETsuGZK40+1v9TE5SS//eSts/DaVee
	kPyw5TFh2SlskzoP+EsdCsbgWTsGYuTNKiU=
X-Google-Smtp-Source: AK7set+aaGC8ED1Z1V48dR1v+sHl5MfnTu8+R57SOtAi0NcxeUy9VenwVgsenFBOObiltCmLkVHcnl3/u4biTJQ=
X-Received: from zaidcloud.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5325])
 (user=zalbassam job=sendgmr) by 2002:a81:9b17:0:b0:52e:cacb:d7c4 with SMTP id
 s23-20020a819b17000000b0052ecacbd7c4mr0ywg.5.1676048130025; Fri, 10 Feb 2023
 08:55:30 -0800 (PST)
Date: Fri, 10 Feb 2023 11:55:00 -0500
In-Reply-To: <20230210165500.2292608-1-zalbassam@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230210165500.2292608-1-zalbassam@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210165500.2292608-9-zalbassam@google.com>
Subject: [PATCH v2 8/8] ARM: mach-virt: Select PMUv3 driver by default
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
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230126204444.2204061-9-zalbassam@google.com
---
 arch/arm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 137f89ad05211..3802997fb36e6 100644
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
2.39.1.581.gbfd45094c4-goog

