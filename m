Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2ED379D1
	for <kvmarm@lists.linux.dev>; Fri, 17 Mar 2023 19:50:41 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id ie21-20020a17090b401500b0023b4ba1e433so2716558pjb.0
        for <kvmarm@lists.linux.dev>; Fri, 17 Mar 2023 12:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679082641;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z72R+3odzfiNkyX6SGGSqUQNHo1bmT9+pfk1eNIvl7o=;
        b=GN2SLPKRMda0UocyaeMMDhoPnXjXS6wzxhV4spf1woRM0Pd7GRpnUmjWIZ5Icnq+sx
         lJWebUhxwCIQO9Pj3ZFOzqj6/fC+ZaEsju01x2S/bzLIm8pltxc2Sat+2cjblcbdKu8H
         4gqXVEEOdeZtJztVvnN/WU9G3dTzct/mX6/U749LYRTMRF/qWmvtKnRvOS6LKccJ3Q7D
         JJ+VvjKzYOi03Vctd2SMh6/HirKWPMFwHkNx2fUoHTJYv3HgLnom8eFlUyI3VdRyebiJ
         w9LBNCrjsmcL8mVGuzWUdWPCEiuFSlqpWYtnKFHKGzSuCfGQHYJnBKRyxRU9QNf40l77
         SQww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679082641;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z72R+3odzfiNkyX6SGGSqUQNHo1bmT9+pfk1eNIvl7o=;
        b=eDnwuUp8K7JoZUIzsOYh7Hwecekdkow1x611Cudawsdtj/CvHSEgYFMGIsNOXiPpjZ
         DCUxtAJicoroBjTrS4YNL+L5oj7b/blVRXMvrs1ijzpvkLUHoysvFYQ/lxKomm3M8Dam
         pRQ1wMU2sjYb3ZkD+QZOPBhFlKe4PW/hEMDoRXLb/VpsTDTJFSVVao3l7DfJ4towNyAV
         OHVG5gsAHHhmhfqdul593XnV23vIqiaxZKftTHGZoVm7TMr00qnbF1Bna9M6klfXqaOX
         mlzlxauRbdTKSjr38QGdoiT064tsawqyaqkN1hiG/uGkpvHI6lgwImL9BLAPW+Bb2Lr2
         YuQg==
X-Gm-Message-State: AO0yUKWnlhlrYwnsLuv7YS9vPyBZanvGKJYziGSsOY0549ZSZOe5SANI
	9JyyPEtY71sCACf3NpAdIlHCLwGYgQP4Ko4=
X-Google-Smtp-Source: AK7set8bLjWRAqpMz9hYfPmb4+QfmXU1/pHVOHvQ8yGi0o0OYjh6bRGR/OHWF5WezN91QfrFA6teCY/w+iDwzqk=
X-Received: from zaidcloud.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5325])
 (user=zalbassam job=sendgmr) by 2002:a17:903:3295:b0:19f:30be:e9f6 with SMTP
 id jh21-20020a170903329500b0019f30bee9f6mr3465284plb.6.1679082641228; Fri, 17
 Mar 2023 12:50:41 -0700 (PDT)
Date: Fri, 17 Mar 2023 15:50:23 -0400
In-Reply-To: <20230317195027.3746949-1-zalbassam@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230317195027.3746949-1-zalbassam@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230317195027.3746949-5-zalbassam@google.com>
Subject: [PATCH v4 4/8] perf: pmuv3: Move inclusion of kvm_host.h to the
 arch-specific helper
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
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, f.fainelli@gmail.com
Cc: Zaid Al-Bassam <zalbassam@google.com>
Content-Type: text/plain; charset="UTF-8"

KVM host support is available only on arm64.

By moving the inclusion of kvm_host.h to an arm64-specific file,
the 32bit architecture will be able to implement dummy helpers.

Signed-off-by: Zaid Al-Bassam <zalbassam@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/arm_pmuv3.h | 2 ++
 drivers/perf/arm_pmuv3.c           | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 80cdfa4c3e88..d6b51deb7bf0 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -6,6 +6,8 @@
 #ifndef __ASM_PMUV3_H
 #define __ASM_PMUV3_H
 
+#include <linux/kvm_host.h>
+
 #include <asm/cpufeature.h>
 #include <asm/sysreg.h>
 
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index f7d890af8cc1..2cab600af4fd 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -16,7 +16,6 @@
 
 #include <linux/acpi.h>
 #include <linux/clocksource.h>
-#include <linux/kvm_host.h>
 #include <linux/of.h>
 #include <linux/perf/arm_pmu.h>
 #include <linux/perf/arm_pmuv3.h>
-- 
2.40.0.rc2.332.ga46443480c-goog

