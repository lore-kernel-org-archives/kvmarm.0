Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E68C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 15:55:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3144E49AF7;
	Fri,  4 Nov 2022 11:55:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tbGxYdcy8o-q; Fri,  4 Nov 2022 11:55:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31DFB4141A;
	Fri,  4 Nov 2022 11:55:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C93E41075
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 11:55:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hpmITEJ7IhCJ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 11:55:34 -0400 (EDT)
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com
 [209.85.210.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6AF5648F99
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 11:55:32 -0400 (EDT)
Received: by mail-ot1-f46.google.com with SMTP id
 94-20020a9d0067000000b0066c8d13a33dso1582909ota.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Nov 2022 08:55:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
 :mime-version:subject:date:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=rdANC8NrUTH0lQipJQx568c5Das7/Cs95kVjxC07YnA=;
 b=MvlKDud0cbt62ByPVP1nhtc6THhJ8LqmpnhsQI9YCrzTkGc573uwMuv7lju599BTB5
 2cmiTB6uapWTiXO0/9HGGdaYAHh3CG43XEyH6LK3Ig/Dej6/MJtj4PwfKqiJ4/ODSap1
 NXynmd1Jdgz4PxW0v66SeaHO+CYvYKMKtnzGsHPjGAXJYQY+N3ehvK4nuZyARYZPmiW3
 0GifDHaGMHq1zV4HeRiAQ+ZJeZYrPpWPn0kvnUAwpOFxXThrZ/GTiBnl2LzQV03Fn18b
 Y/rG7AOHmFS2Zt6/s46alvgA0JskQRomqhB5bJb3QNzh4aAMv56SUdz2U3pab51/cD3x
 RG8w==
X-Gm-Message-State: ACrzQf2gEu++zhFTPqIp0s2zdyOwpmdY8NzJUnpbeKQl7j1C70KchnPB
 vp+Q6Nln8SEfB2StZVqAMw==
X-Google-Smtp-Source: AMsMyM59dgaW5KOcOiwYnuILFe/BJR9IA6bPecpfclxA2KHdZ3Eq+UoizXI26yxdMDvL0GyieiOjSA==
X-Received: by 2002:a05:6830:1241:b0:66c:3bc2:f919 with SMTP id
 s1-20020a056830124100b0066c3bc2f919mr16838358otp.33.1667577331662; 
 Fri, 04 Nov 2022 08:55:31 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net.
 [66.90.144.107]) by smtp.gmail.com with ESMTPSA id
 l21-20020a05687040d500b0013d9bd4ad2esm1906311oal.12.2022.11.04.08.55.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 04 Nov 2022 08:55:31 -0700 (PDT)
Received: (nullmailer pid 1880422 invoked by uid 1000);
 Fri, 04 Nov 2022 15:55:18 -0000
From: Rob Herring <robh@kernel.org>
Date: Fri, 04 Nov 2022 10:55:07 -0500
Subject: [PATCH v3 7/8] perf: Add perf_event_attr::config3
MIME-Version: 1.0
Message-Id: <20220825-arm-spe-v8-7-v3-7-87682f78caac@kernel.org>
References: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
In-Reply-To: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>, Will Deacon <will@kernel.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Ingo Molnar <mingo@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>
X-Mailer: b4 0.11.0-dev
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Mark Brown <broonie@kernel.org>, James Clark <james.clark@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Tested-by: James Clark <james.clark@arm.com>
Signed-off-by: Rob Herring <robh@kernel.org>
---
v3:
 - No change
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
