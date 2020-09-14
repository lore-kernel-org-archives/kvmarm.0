Return-Path: <SRS0=WazV=CX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252D9C43461
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B377C217BA
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="MRgm2+rK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B377C217BA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 551D74B5AE;
	Mon, 14 Sep 2020 13:28:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BZPSCnTRmej8; Mon, 14 Sep 2020 13:28:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EA2B4B555;
	Mon, 14 Sep 2020 13:28:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9852C4B59F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9hPtRPktgBR3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Sep 2020 13:28:24 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 117E34B58F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:24 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id e16so539822wrm.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 10:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=CR8a6tMHdr0USdHEJnOukkMN6eSncqh9/9HspEdN4UY=;
 b=MRgm2+rKGyjkfvyujlRyBIOQT8NCbfm4KKDVDwHLRRHlD5WGV1auhwHouV2MeQI6dF
 zIyYkgBw2wejuJUELfkk6Ay18dTESFVPqqBPpI9zj/KvPzXv9tdlhflhOmYQUU62xw0W
 V29wHi2hnqK9PGB/ZYSyNBaXxVHJLBd+uo4Ec/+vUICZRFpSUr/9OFyJOQyudIL6V2uH
 hdv6qYn9LE3RZ6X6bsj8IXVKUViiL5MCpw0RmeZMgzefEZR96WeKni9QIlkgykEysnIF
 doq0McQXcdv+G9lExgusCVKbZmJoUIhrBmLSHwERahucZpyZ9a/UZ6bWgQocmkHC08s8
 QhKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=CR8a6tMHdr0USdHEJnOukkMN6eSncqh9/9HspEdN4UY=;
 b=R4vvMEj8oxXUydySgJNx0O1haJLPkAuu5Jbtn/bQhC9FWzcO1C8abxzxMkaeK0sOzL
 zx4y0pk1zQkmCoHQ5gbyYKgzCZzqz2bta1zRJqmlsp5Ubl/qXsyP1hi/cIRQien9EGYy
 rAhhy6sc60QpIlUwcPiB3jYwGTuVNGU/FA9v7RLrbvELCh6XGe7buVvsKLziEL0Ft2TF
 1AKbPXIuAXIf6OtF55N4nEkCcPYuZe18O/YdbNV/oXQyn+fLxYNI2Qk0zRXcercFhGgJ
 DGhSd4yl7LJR5oBw7oqWTtPrRjvCPoBt0yYjzm9DBC2C8N+BZUjopMotc/m98RFyrRTb
 dh6w==
X-Gm-Message-State: AOAM530zRb4wf9cZnHRpddqBQKmXW6ICDO06tmTNGfb+L9crphKyn91G
 H7Lhi5FvuFrW4nONlSXAT3jPDg==
X-Google-Smtp-Source: ABdhPJx5klzNqO5C+D8N9yK1WGPOUSEyiPciNY6KedkODWKmogjwhf4A1yZOnxEUD7w3yfpl+BSg4A==
X-Received: by 2002:a5d:6283:: with SMTP id k3mr17620699wru.191.1600104503135; 
 Mon, 14 Sep 2020 10:28:23 -0700 (PDT)
Received: from localhost (49.222.77.34.bc.googleusercontent.com.
 [34.77.222.49])
 by smtp.gmail.com with ESMTPSA id k8sm21852072wrl.42.2020.09.14.10.28.22
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 14 Sep 2020 10:28:22 -0700 (PDT)
From: George-Aurelian Popescu <georgepope@google.com>
To: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 masahiroy@kernel.org, michal.lkml@markovi.net
Subject: [PATCH 11/14] KVM: arm64: Detect type mismatch undefined behaviour
 from hyp/nVHE code
Date: Mon, 14 Sep 2020 17:27:47 +0000
Message-Id: <20200914172750.852684-12-georgepope@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
In-Reply-To: <20200914172750.852684-1-georgepope@google.com>
References: <20200914172750.852684-1-georgepope@google.com>
MIME-Version: 1.0
Cc: arnd@arndb.de, elver@google.com, tglx@linutronix.de, keescook@chromium.org,
 maskray@google.com, linux-kbuild@vger.kernel.org, ndesaulniers@google.com,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 clang-built-linux@googlegroups.com, broonie@kernel.org, dvyukov@google.com,
 natechancellor@gmail.com, kvmarm@lists.cs.columbia.edu,
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

From: George Popescu <georgepope@google.com>

Type mismatch undefined behaviour handler provides two handlers with two
data structures type_mismatch_data and type_mismatch_data_v1. Both can be
stored inside a common data structure: type_mismatch_data_common, which
differs of type_mismatch_data only by keeping a pointer to a
struct source_location instead of the value of the struct.

In this way, the buffer keeps the data encapsulated inside of a struct
type_mismatch_data, because pointers from nVHE can not be passed to the
kernel.

Inside the kernel call the __ubsan_handle_type_mismatch_data with the
data from the buffer.

Signed-off-by: George Popescu <georgepope@google.com>
---
 arch/arm64/include/asm/kvm_ubsan.h |  6 ++++-
 arch/arm64/kvm/hyp/nvhe/ubsan.c    | 41 ++++++++++++++++++++++++++++--
 arch/arm64/kvm/kvm_ubsan_buffer.c  |  5 +++-
 3 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_ubsan.h b/arch/arm64/include/asm/kvm_ubsan.h
index b643ac9a4090..a9f499f4ef6d 100644
--- a/arch/arm64/include/asm/kvm_ubsan.h
+++ b/arch/arm64/include/asm/kvm_ubsan.h
@@ -23,13 +23,15 @@ struct kvm_ubsan_info {
 		UBSAN_OUT_OF_BOUNDS,
 		UBSAN_UNREACHABLE_DATA,
 		UBSAN_SHIFT_OUT_OF_BOUNDS,
-		UBSAN_INVALID_DATA
+		UBSAN_INVALID_DATA,
+		UBSAN_TYPE_MISMATCH
 	} type;
 	union {
 		struct out_of_bounds_data out_of_bounds_data;
 		struct unreachable_data unreachable_data;
 		struct shift_out_of_bounds_data shift_out_of_bounds_data;
 		struct invalid_value_data invalid_value_data;
+		struct type_mismatch_data type_mismatch_data;
 	};
 	union {
 		struct ubsan_values u_val;
@@ -41,3 +43,5 @@ void __ubsan_handle_out_of_bounds(void *_data, void *index);
 void __ubsan_handle_builtin_unreachable(void *_data);
 void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs);
 void __ubsan_handle_load_invalid_value(void *_data, void *val);
+void __ubsan_handle_type_mismatch(struct type_mismatch_data  *_data, void *ptr);
+
diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan.c b/arch/arm64/kvm/hyp/nvhe/ubsan.c
index 1888a1f51724..c99d919105aa 100644
--- a/arch/arm64/kvm/hyp/nvhe/ubsan.c
+++ b/arch/arm64/kvm/hyp/nvhe/ubsan.c
@@ -29,6 +29,24 @@ static inline struct kvm_ubsan_info *kvm_ubsan_buffer_next_slot(void)
 	return res;
 }
 
+static void write_type_mismatch_data(struct type_mismatch_data_common *data, void *lval)
+{
+	struct kvm_ubsan_info *slot;
+	struct type_mismatch_data *aux_cont;
+
+	slot = kvm_ubsan_buffer_next_slot();
+	if (slot) {
+		slot->type = UBSAN_TYPE_MISMATCH;
+		aux_cont = &slot->type_mismatch_data;
+		aux_cont->location.file_name = data->location->file_name;
+		aux_cont->location.reported = data->location->reported;
+		aux_cont->type = data->type;
+		aux_cont->alignment = data->alignment;
+		aux_cont->type_check_kind = data->type_check_kind;
+		slot->u_val.lval = lval;
+	}
+}
+
 void __ubsan_handle_add_overflow(void *_data, void *lhs, void *rhs) {}
 
 void __ubsan_handle_sub_overflow(void *_data, void *lhs, void *rhs) {}
@@ -39,9 +57,28 @@ void __ubsan_handle_negate_overflow(void *_data, void *old_val) {}
 
 void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs) {}
 
-void __ubsan_handle_type_mismatch(struct type_mismatch_data *data, void *ptr) {}
+void __ubsan_handle_type_mismatch(struct type_mismatch_data *data, void *ptr)
+{
+	struct type_mismatch_data_common common_data = {
+		.location = &data->location,
+		.type = data->type,
+		.alignment = data->alignment,
+		.type_check_kind = data->type_check_kind
+	};
+	write_type_mismatch_data(&common_data, ptr);
+}
 
-void __ubsan_handle_type_mismatch_v1(void *_data, void *ptr) {}
+void __ubsan_handle_type_mismatch_v1(void *_data, void *ptr)
+{
+	struct type_mismatch_data_v1 *data = _data;
+	struct type_mismatch_data_common common_data = {
+		.location = &data->location,
+		.type = data->type,
+		.alignment = 1UL << data->log_alignment,
+		.type_check_kind = data->type_check_kind
+	};
+	write_type_mismatch_data(&common_data, ptr);
+}
 
 void __ubsan_handle_out_of_bounds(void *_data, void *index)
 {
diff --git a/arch/arm64/kvm/kvm_ubsan_buffer.c b/arch/arm64/kvm/kvm_ubsan_buffer.c
index 01bf2171af9e..21c242c92f0a 100644
--- a/arch/arm64/kvm/kvm_ubsan_buffer.c
+++ b/arch/arm64/kvm/kvm_ubsan_buffer.c
@@ -36,6 +36,10 @@ void __kvm_check_ubsan_data(struct kvm_ubsan_info *slot)
 		__ubsan_handle_load_invalid_value(&slot->invalid_value_data,
 				slot->u_val.lval);
 		break;
+	case UBSAN_TYPE_MISMATCH:
+		__ubsan_handle_type_mismatch(&slot->type_mismatch_data,
+				slot->u_val.lval);
+		break;
 	}
 }
 
@@ -51,4 +55,3 @@ void __kvm_check_ubsan_buffer(void)
 		slot->type = 0;
 	}
 }
-
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
