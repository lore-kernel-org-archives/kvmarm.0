Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC4D4C43219
	for <kvmarm@archiver.kernel.org>; Wed, 19 Oct 2022 19:11:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85D0C4B90E;
	Wed, 19 Oct 2022 15:11:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G-qfnyeP0hGV; Wed, 19 Oct 2022 15:11:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AB424B934;
	Wed, 19 Oct 2022 15:11:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 581194B928
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 15:11:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jrT7nSEuPbTo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Oct 2022 15:11:29 -0400 (EDT)
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com
 [209.85.167.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 687AE4B908
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 15:11:29 -0400 (EDT)
Received: by mail-oi1-f178.google.com with SMTP id w74so20401863oie.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 12:11:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
 :mime-version:subject:date:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=4nOSzjJQMiiQFtQCXOfHoj5W8uYrP30fMIHaTAT/kCc=;
 b=MWs0lCWKcb0NOhmYz28FKfydipraJj/m4beKPa8G8CcWvZfdA5csE8RlCc8sPh2wHW
 hVVK2CK+g/lzO2NnT6N4ui2dnvEXqNh4N+SB0Dw8PAPizwInNl9OBR6gwF2dFzsEkkvd
 9ak/H9O1ymFDK74SKSZPTipXoemT/NDmkdJ8DH478KI3zEyO4YGF+yYeX9rXOD6hokIj
 C4Oulm9qBTvOVRj0ksJTuRFUEM6k4bAqURgVInwlZFrmZjM27TnesqoNDx7JpOeR30QO
 +YBjh3S6octBY10oOs9dVStZtArFEODb+oRxE36+9sBRtI/xDmziV5mSXXrSG9/h8sUL
 3FJQ==
X-Gm-Message-State: ACrzQf3lGpGe26YYR8y7j7ggvLha3s2qjTGdPt6sPziFdAYRyP3SxM6W
 wp6vkTsgXxs129RTVpPdrw==
X-Google-Smtp-Source: AMsMyM6hBFo6lc3QPPJZLi2rdtLDIwN0Hv6MsBsjwIii7y66xrRf5EteOTh2AxrGHMhQuml0B0j83w==
X-Received: by 2002:a05:6808:3090:b0:354:e8e2:6512 with SMTP id
 bl16-20020a056808309000b00354e8e26512mr18775295oib.118.1666206688760; 
 Wed, 19 Oct 2022 12:11:28 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net.
 [66.90.144.107]) by smtp.gmail.com with ESMTPSA id
 z9-20020a056870460900b0013191b00f72sm7878011oao.17.2022.10.19.12.11.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 19 Oct 2022 12:11:28 -0700 (PDT)
Received: (nullmailer pid 3420908 invoked by uid 1000);
 Wed, 19 Oct 2022 19:11:25 -0000
From: Rob Herring <robh@kernel.org>
Date: Wed, 19 Oct 2022 14:11:29 -0500
Subject: [PATCH v2 6/7] perf: Add perf_event_attr::config3
MIME-Version: 1.0
Message-Id: <20220825-arm-spe-v8-7-v2-6-e37322d68ac0@kernel.org>
References: <20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org>
In-Reply-To: <20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>, James Morse <james.morse@arm.com>,
 Ingo Molnar <mingo@redhat.com>, Mark Rutland <mark.rutland@arm.com>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Will Deacon <will@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Oliver Upton <oliver.upton@linux.dev>, Jiri Olsa <jolsa@kernel.org>
X-Mailer: b4 0.11.0-dev
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Arm SPEv1.2 adds another 64-bits of event filtering control. As the
existing perf_event_attr::configN fields are all used up for SPE PMU, an
additional field is needed. Add a new 'config3' field.

Signed-off-by: Rob Herring <robh@kernel.org>
---
v2:
 - Drop tools/ side update
---
 include/uapi/linux/perf_event.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 85be78e0e7f6..b2b1d7b54097 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -374,6 +374,7 @@ enum perf_event_read_format {
 #define PERF_ATTR_SIZE_VER5	112	/* add: aux_watermark */
 #define PERF_ATTR_SIZE_VER6	120	/* add: aux_sample_size */
 #define PERF_ATTR_SIZE_VER7	128	/* add: sig_data */
+#define PERF_ATTR_SIZE_VER8	136	/* add: config3 */
 
 /*
  * Hardware event_id to monitor via a performance monitoring event:
@@ -515,6 +516,8 @@ struct perf_event_attr {
 	 * truncated accordingly on 32 bit architectures.
 	 */
 	__u64	sig_data;
+
+	__u64	config3; /* extension of config2 */
 };
 
 /*

-- 
b4 0.11.0-dev
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
