Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1E279D1
	for <kvmarm@lists.linux.dev>; Fri, 17 Mar 2023 19:50:49 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id e80-20020a255053000000b00b641ae96a5cso2808486ybb.18
        for <kvmarm@lists.linux.dev>; Fri, 17 Mar 2023 12:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679082648;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SWp43EKSObLScNJyve8NVm0+M7i+tQFxyt9k8TiRe9g=;
        b=e0o+1QipaOeuxF3SQj+/1I0NUJYANsvskj+jz+/JVVr1JI/Gi8EhYKPNYf6VCam0BD
         BAsjPkgg5/ctjSm5fbatVkc37cbroqyTAJ5lMHDQqqUyK1lU4+hREwmj8Q8fnx7emkyA
         FqesCCLDpG94eJAu7iyFgDIMb2uvcOYUTcrQgwHxZ/qSMHGAbwYNX1NfDIvwCrf3/yLh
         Qlzcif76NWl2d5Dec/ik4T5zqD5Ogl0pkotQHRqs3F6j3Db5VjWme4evtJbL06vcVC8k
         5G2KHySl3FJNxq+4Y1E8Q2s1mqtvNv/IskSm5DyA1K7kEWGH1hY/bYV0pIPrlheqehC+
         Vjsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679082648;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SWp43EKSObLScNJyve8NVm0+M7i+tQFxyt9k8TiRe9g=;
        b=b7ogJuYHMDzCfaQT2jK2IvJ7WJcDklJnlLEvKV8EUKsaugghWdmHSghWrojy9uWK4s
         B4QVGxsmoQsjYv1w/vm6yl4nQzx2THakD92wH0qLSH8OID2aJXtGpmhieE+Z3lSogOvq
         bG9hBU/rqmZhiSsif1JPpt04+dxrjDrNAsHRrmoMdLPCyJW3el0WmMmjMcd1QWB8vc5U
         vEC1JBrwpGNGRF4k+m8mqHNQLoWhIkh/lcKjZRW9qW4exsgoFqkJMuV/rfk6H9XBttVh
         uispIdmjZaFyu2CtMM5/xcBmB4JL0jF67lvURqIIIH5eFy56xGSJjuylzMKQv5BAoKwc
         4WHA==
X-Gm-Message-State: AO0yUKWzitdJikyDi/RVx8h2zZOGsDmD/xGqUNDZeTL7YXv0W1YpkSYD
	etpRN3z0MFXEAN4D1CXRY246vg2/cH6GE20=
X-Google-Smtp-Source: AK7set+1dZfI1V93G2NNZOWgyqiVDUpszfGni5yoPVSFDzoxKaFlWRR3P5jO5zsNV2xWLmuL0WJ9RjPmhL3qVro=
X-Received: from zaidcloud.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5325])
 (user=zalbassam job=sendgmr) by 2002:a25:2d1a:0:b0:8ed:3426:8a69 with SMTP id
 t26-20020a252d1a000000b008ed34268a69mr511377ybt.1.1679082648198; Fri, 17 Mar
 2023 12:50:48 -0700 (PDT)
Date: Fri, 17 Mar 2023 15:50:27 -0400
In-Reply-To: <20230317195027.3746949-1-zalbassam@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230317195027.3746949-1-zalbassam@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230317195027.3746949-9-zalbassam@google.com>
Subject: [PATCH v4 8/8] ARM: mach-virt: Select PMUv3 driver by default
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Zaid Al-Bassam <zalbassam@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <marc.zyngier@arm.com>

Since 32bit guests are not unlikely to run on an ARMv8 host,
let's select the PMUv3 driver, which allows the PMU to be used
on such systems.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Zaid Al-Bassam <zalbassam@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index bc12857e81f9..6f0a2576d17f 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -401,6 +401,7 @@ config ARCH_VIRT
 	select ARM_GIC_V3
 	select ARM_GIC_V3_ITS if PCI
 	select ARM_PSCI
+	select ARM_PMUV3 if PERF_EVENTS
 	select HAVE_ARM_ARCH_TIMER
 
 config ARCH_AIROHA
-- 
2.40.0.rc2.332.ga46443480c-goog

