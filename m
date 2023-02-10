Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2FE63B6
	for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 16:55:24 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id j14-20020aa7928e000000b00593bca77b0dso2903121pfa.9
        for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 08:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1676048124;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2+p08AfrdrQMfpJn1ylcvtO2Ig9cnBH4qygeKLOxyr4=;
        b=SJJd0x95oNZ+eJQfXnvXcpugz/a/cJ+t9ikkLVEfVtRWYvweJlyL3WsO4eM7MJcg/c
         AvuIkRDYmJfWt6mBsXaQDLbUYUv3iGwzyNiSTYdCbjk5NTtwPRCibsiHvcZPRYnkKCNj
         4vFEqat3l1uNf6/MAVgldhCHeMCpAWjiqKddoQZ2bu07652Sv7UUo0O9PZ7XLU0YGlhH
         o8+55/RBTztktn9Vpf63AFfTrFUym6cc66WxvRBEQgxqBxunk42UE7pYxOTFK/lysFhk
         1s4Osm/IfUcqfAnVjhZii9KLaMfHR7HFObkNzRTMRYTPuqXC64V60/lqDTHenBHt6+kd
         GPyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676048124;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2+p08AfrdrQMfpJn1ylcvtO2Ig9cnBH4qygeKLOxyr4=;
        b=XPXZynPnO6tzaa+gnbT3wW09558Pj2aNA8b1jfRlRC/tUSY+TqBAhwJ3Kd3I22VB1w
         2k1uVmCl4kFZq++9F87WFOJcuexS+T215Lf2rDbEJBY/6ySnCBPFs3yB8krDlgX1U214
         mxI7RCZcaqZrP1flGCQjNOp2aD40jr74WM6hv1PNiKUr8DeG0WP8WQEj0OQoOhfLLEYv
         sXLApB8/HpQ8TyXsxL/IB1AmBCF5tN+fWm3O65v+nOySmkX/PE466+HFxeVQQgnUNO+5
         ik26XIh1zJ5yGisPqSz2KErCls7x2qq24Vh6DOfKsqFMk/rKrT21+G4lDZd/HXzOuW9O
         I8BA==
X-Gm-Message-State: AO0yUKXnahL7vSScgsqim+wh/SvVZTDLE2f9ovG4pSjZp55P4mzzzspE
	XIHaQMrS4N7XcpbWmaK3rONLa8yM0AjG4MI=
X-Google-Smtp-Source: AK7set/PQpe51rDPvh02XY2GdXIh+tKbGt2sc7iL1OsES4twfuke9JZKzmdezrhfCssa+/AlaHlxPxaE7ZVOG9U=
X-Received: from zaidcloud.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5325])
 (user=zalbassam job=sendgmr) by 2002:a17:902:ea0e:b0:196:64bf:ed7a with SMTP
 id s14-20020a170902ea0e00b0019664bfed7amr3779552plg.29.1676048124218; Fri, 10
 Feb 2023 08:55:24 -0800 (PST)
Date: Fri, 10 Feb 2023 11:54:57 -0500
In-Reply-To: <20230210165500.2292608-1-zalbassam@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230210165500.2292608-1-zalbassam@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210165500.2292608-6-zalbassam@google.com>
Subject: [PATCH v2 5/8] perf: pmuv3: Change GENMASK to GENMASK_ULL
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
Cc: Zaid Al-Bassam <zalbassam@google.com>
Content-Type: text/plain; charset="UTF-8"

GENMASK macro uses "unsigned long" (32-bit wide on arm and 64-bit
on arm64), This causes build issues when enabling PMUv3 on arm as
it tries to access bits > 31. This patch switches the GENMASK to
GENMASK_ULL, which uses "unsigned long long" (64-bit on both arm
and arm64).

Signed-off-by: Zaid Al-Bassam <zalbassam@google.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230126204444.2204061-6-zalbassam@google.com
---
 drivers/perf/arm_pmuv3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index b3683fdf8d0b9..dc8b8c8f1b3ed 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -489,7 +489,7 @@ static bool armv8pmu_event_needs_bias(struct perf_event *event)
 static u64 armv8pmu_bias_long_counter(struct perf_event *event, u64 value)
 {
 	if (armv8pmu_event_needs_bias(event))
-		value |= GENMASK(63, 32);
+		value |= GENMASK_ULL(63, 32);
 
 	return value;
 }
@@ -497,7 +497,7 @@ static u64 armv8pmu_bias_long_counter(struct perf_event *event, u64 value)
 static u64 armv8pmu_unbias_long_counter(struct perf_event *event, u64 value)
 {
 	if (armv8pmu_event_needs_bias(event))
-		value &= ~GENMASK(63, 32);
+		value &= ~GENMASK_ULL(63, 32);
 
 	return value;
 }
-- 
2.39.1.581.gbfd45094c4-goog

