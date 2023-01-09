Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD40D8C18
	for <kvmarm@lists.linux.dev>; Mon,  9 Jan 2023 19:26:39 +0000 (UTC)
Received: by mail-ot1-f51.google.com with SMTP id i26-20020a9d68da000000b00672301a1664so5735475oto.6
        for <kvmarm@lists.linux.dev>; Mon, 09 Jan 2023 11:26:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PhyORF2P/3DyAeuNip+D3UZxHZqFcutPSwK+nSe9q5A=;
        b=F4FFHAuw2hAeEjJdjvjGPwWD3QVniQTcrANUcyvFMrhmQthrX/uWgjrsKDE5k1/SyN
         6HI18TwCURLk1Q7in4RQPcBfWdEHU3nGD+vgCB6vUkBeloytzGvSj6OSnXLXsbZpiTQM
         Ri60ili1Nua4SC8P8GpMrGqiBBvHDWo6txjW5ELcyZRD362iQPvim/0WF/8MMQgTApVA
         zLoHRYwew4bNpsUHS5pEdoQr/t1qhYcmRLuIY8Yt78N1djocj8m8nejkgKXBA6S7t29A
         p4iDe2m85Xwqm/h14GuhMGHTtvnDV08DsnswHt58X4QMb4mbviJ7AY1DkiX3HEBfFBuT
         NAYQ==
X-Gm-Message-State: AFqh2kqwqFW/Ljo5X+EVChoP7zAa3PBS6OkM8XI+d2J5MJzMqVnzo7kF
	74i2LZLbgPXrAn0JVbqNHQ==
X-Google-Smtp-Source: AMrXdXtQakXq+GiEhNJNrTLT/Kt4j9QDhHq5mQPoYNysZKYYdW2im1ldV7iPGFymXGTMKxSydH+yWw==
X-Received: by 2002:a9d:68c1:0:b0:66b:cae2:3a3f with SMTP id i1-20020a9d68c1000000b0066bcae23a3fmr32983649oto.17.1673292398563;
        Mon, 09 Jan 2023 11:26:38 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id b19-20020a9d6b93000000b0066ca61230casm4989496otq.8.2023.01.09.11.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 11:26:38 -0800 (PST)
Received: (nullmailer pid 1483618 invoked by uid 1000);
	Mon, 09 Jan 2023 19:26:31 -0000
From: Rob Herring <robh@kernel.org>
Date: Mon, 09 Jan 2023 13:26:23 -0600
Subject: [PATCH v4 7/8] perf: Add perf_event_attr::config3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20220825-arm-spe-v8-7-v4-7-327f860daf28@kernel.org>
References: <20220825-arm-spe-v8-7-v4-0-327f860daf28@kernel.org>
In-Reply-To: <20220825-arm-spe-v8-7-v4-0-327f860daf28@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, James Clark <james.clark@arm.com>
X-Mailer: b4 0.12-dev

Arm SPEv1.2 adds another 64-bits of event filtering control. As the
existing perf_event_attr::configN fields are all used up for SPE PMU, an
additional field is needed. Add a new 'config3' field.

Tested-by: James Clark <james.clark@arm.com>
Signed-off-by: Rob Herring <robh@kernel.org>
---
There's still an unresolved discussion about validating 'config3' with
the options laid out here[1].

v4:
 - Rebase on v6.2-rc1
v3:
 - No change
v2:
 - Drop tools/ side update

[1] https://lore.kernel.org/all/Y49ttrv6W5k3ZNYw@FVFF77S0Q05N.cambridge.arm.com/
---
 include/uapi/linux/perf_event.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index ccb7f5dad59b..37675437b768 100644
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
2.39.0
