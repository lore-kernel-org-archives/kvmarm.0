Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A899C433FE
	for <kvmarm@archiver.kernel.org>; Sat,  5 Nov 2022 07:23:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F6824A105;
	Sat,  5 Nov 2022 03:23:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PzClyC4PTTNX; Sat,  5 Nov 2022 03:23:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B57084B092;
	Sat,  5 Nov 2022 03:23:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0CB749AF7
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Nov 2022 03:23:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JdEOKy3pCnE0 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  5 Nov 2022 03:23:49 -0400 (EDT)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com
 [209.85.215.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D20248FA4
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Nov 2022 03:23:49 -0400 (EDT)
Received: by mail-pg1-f171.google.com with SMTP id 78so6170081pgb.13
 for <kvmarm@lists.cs.columbia.edu>; Sat, 05 Nov 2022 00:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=QfZA8Oeq546U9rjXWlvF9+hmpzEZ8iLdnFqiiX6KOGA=;
 b=bHXFAvPFjUm6i2kX0+cKQ9kyX3IEu0dAg7rej/TY3PIo8z+3oigqZrU9IyDTpig+R3
 HJN1Txjluse6j+vStwPJGRMGQ2GQfVNq9iTZQAZG/88DlBTj+WoYddnMO7dEAGRRy81/
 7uNc8LfdswOlXFqzrYNoY8hk83/eFkQeePpTXaZNoWlSiI6RkzO9bBj1Lra5u7PKE7XI
 YZp8JMGcjrYuXqAQUIfNvqMj6q3LmZW7DsihaejeJi5LGY/dO0jhHe1SpWyFBo0LGCh0
 NU/4w+dZlOR2PRJFjVuQstVilJzYNAhIsBuGRf0wBs9nuZ+/VHjwdaQp2+kwd9dj3X8W
 dBZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=QfZA8Oeq546U9rjXWlvF9+hmpzEZ8iLdnFqiiX6KOGA=;
 b=SzgjK7lcPPquj5pTo9Kh3KatiBVvvU6yC4FDZmqEHvIkRmjKXRVJ5l8L4qX/DoxaXn
 TX1MCv2x7f7M9bYnjHZdDj0wcdegmyWu4Hgu5kQ6UoBflfL6GEr1GogRCsu6j1Ntx54a
 v/5K5D91l7wqFKD9Bi1IiZscsHgY4+kqxLTuv7n8OXF+gee1qbbkps4yZ7HakmjjQ3PV
 XlPvmrkrE9L7O1jSps3uyg7bP+YoWzPHkYuswxebMnSBR+ZZsKHTyrwRdWOzDWYK/Tqa
 dYlGTVJsF+o8DjlTjtKK2/0FkayGB9mioq6Ri9cW4W0f8XHiWyCw3pakNHjcGfmCIJ4J
 RLIQ==
X-Gm-Message-State: ACrzQf1Y5yb++dqVDyVrN21zLAgM5sY0FB+7gIsBoNVaD9Sb1V+QM9JM
 0DulVPCEITSwUkQk+KhDoxGj9w==
X-Google-Smtp-Source: AMsMyM5wcfHGBOZqSWFQQMZBQipB+vd3qIPfNGFDpVK5wLEQTDZBAIR4i3sEAE/hnRLXOzTBhLMmoA==
X-Received: by 2002:a63:1a60:0:b0:43c:9bcd:6c37 with SMTP id
 a32-20020a631a60000000b0043c9bcd6c37mr33168645pgm.125.1667633028514; 
 Sat, 05 Nov 2022 00:23:48 -0700 (PDT)
Received: from leoy-huangpu.lan (211-75-219-201.hinet-ip.hinet.net.
 [211.75.219.201]) by smtp.gmail.com with ESMTPSA id
 w27-20020aa79a1b000000b00562ef28aac6sm698138pfj.185.2022.11.05.00.23.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 05 Nov 2022 00:23:48 -0700 (PDT)
From: Leo Yan <leo.yan@linaro.org>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 John Garry <john.garry@huawei.com>, James Clark <james.clark@arm.com>,
 Mike Leach <mike.leach@linaro.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org
Subject: [PATCH v1 2/3] KVM: arm64: Add trace events with field 'vcpu_id'
Date: Sat,  5 Nov 2022 07:23:10 +0000
Message-Id: <20221105072311.8214-3-leo.yan@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221105072311.8214-1-leo.yan@linaro.org>
References: <20221105072311.8214-1-leo.yan@linaro.org>
MIME-Version: 1.0
Cc: Leo Yan <leo.yan@linaro.org>
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

The existed trace events kvm_entry and kvm_exit don't contain the info
for virtual CPU id, thus the perf tool has no chance to do statistics
based on virtual CPU wise; and the trace events are ABI and we cannot
change it to avoid ABI breakage.

For above reasons, this patch adds two trace events kvm_entry_v2 and
kvm_exit_v2 with a new field 'vcpu_id'.  To support both the old and
new events, we use the tracepoint callback to check if any event is
enabled or not, if it's enabled then the callback will invoke the
corresponding trace event.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 arch/arm64/kvm/trace.c     |  6 +++++
 arch/arm64/kvm/trace_arm.h | 45 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/arch/arm64/kvm/trace.c b/arch/arm64/kvm/trace.c
index d25a3db994e2..d9b2587c77c3 100644
--- a/arch/arm64/kvm/trace.c
+++ b/arch/arm64/kvm/trace.c
@@ -10,6 +10,9 @@ static void kvm_entry_tp(void *data, struct kvm_vcpu *vcpu)
 {
 	if (trace_kvm_entry_enabled())
 		trace_kvm_entry(*vcpu_pc(vcpu));
+
+	if (trace_kvm_entry_v2_enabled())
+		trace_kvm_entry_v2(vcpu);
 }
 
 static void kvm_exit_tp(void *data, int ret, struct kvm_vcpu *vcpu)
@@ -17,6 +20,9 @@ static void kvm_exit_tp(void *data, int ret, struct kvm_vcpu *vcpu)
 	if (trace_kvm_exit_enabled())
 		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu),
 			       *vcpu_pc(vcpu));
+
+	if (trace_kvm_exit_v2_enabled())
+		trace_kvm_exit_v2(ret, vcpu);
 }
 
 static int __init kvm_tp_init(void)
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index ef02ae93b28b..932c9d0c36f3 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -4,6 +4,7 @@
 
 #include <kvm/arm_arch_timer.h>
 #include <linux/tracepoint.h>
+#include <asm/kvm_emulate.h>
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kvm
@@ -30,6 +31,23 @@ TRACE_EVENT(kvm_entry,
 	TP_printk("PC: 0x%016lx", __entry->vcpu_pc)
 );
 
+TRACE_EVENT(kvm_entry_v2,
+	TP_PROTO(struct kvm_vcpu *vcpu),
+	TP_ARGS(vcpu),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	vcpu_id		)
+		__field(	unsigned long,	vcpu_pc		)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id		= vcpu->vcpu_id;
+		__entry->vcpu_pc		= *vcpu_pc(vcpu);
+	),
+
+	TP_printk("vcpu: %u PC: 0x%016lx", __entry->vcpu_id, __entry->vcpu_pc)
+);
+
 DECLARE_TRACE(kvm_exit_tp,
 	TP_PROTO(int ret, struct kvm_vcpu *vcpu),
 	TP_ARGS(ret, vcpu));
@@ -57,6 +75,33 @@ TRACE_EVENT(kvm_exit,
 		  __entry->vcpu_pc)
 );
 
+TRACE_EVENT(kvm_exit_v2,
+	TP_PROTO(int ret, struct kvm_vcpu *vcpu),
+	TP_ARGS(ret, vcpu),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	vcpu_id		)
+		__field(	int,		ret		)
+		__field(	unsigned int,	esr_ec		)
+		__field(	unsigned long,	vcpu_pc		)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id		= vcpu->vcpu_id;
+		__entry->ret			= ARM_EXCEPTION_CODE(ret);
+		__entry->esr_ec			= ARM_EXCEPTION_IS_TRAP(ret) ?
+						  kvm_vcpu_trap_get_class(vcpu): 0;
+		__entry->vcpu_pc		= *vcpu_pc(vcpu);
+	),
+
+	TP_printk("%s: vcpu: %u HSR_EC: 0x%04x (%s), PC: 0x%016lx",
+		  __print_symbolic(__entry->ret, kvm_arm_exception_type),
+		  __entry->vcpu_id,
+		  __entry->esr_ec,
+		  __print_symbolic(__entry->esr_ec, kvm_arm_exception_class),
+		  __entry->vcpu_pc)
+);
+
 TRACE_EVENT(kvm_guest_fault,
 	TP_PROTO(unsigned long vcpu_pc, unsigned long hsr,
 		 unsigned long hxfar,
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
