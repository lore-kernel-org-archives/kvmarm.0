Return-Path: <SRS0=WazV=CX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92BFDC2BC11
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 099C220E65
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="tHkFPa0p"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 099C220E65
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8C144B58D;
	Mon, 14 Sep 2020 13:28:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xuW1dDsF-gae; Mon, 14 Sep 2020 13:28:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A28F4B599;
	Mon, 14 Sep 2020 13:28:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EAE84B565
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vWEliOKWZU67 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Sep 2020 13:28:27 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DECA94B555
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:25 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id m6so556793wrn.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 10:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=iB4T9kLFB3iIR2Z+tST4GCiUmTN46viq6Nw4qtcThCM=;
 b=tHkFPa0pnHNp4OB1KzhooQ3KuORDrIJ7EGWt10+yQOe8MMQgNYmjvEghP0/sEQoSOw
 NrHpSaLPFtOEbdIH9+QT2zFtdAdtVSJMZUXbmMtmY3dpj/pbWw+n7CeJaMiwconli2u0
 Aq9SPNQjoF5YaSNdG2pKHO6K6yXVQYc/hqdvdq04SyAuqS5OMA9RdpqN6bK/vjgH1P2E
 nEuQNt3dBI+O7bKCdwYE9d4NGSUX4o8hKfj56xPAkb3QSVu8+VbwpCHLiLB43E6Mmk0x
 T2fPnr0nxh+nP7t5TwBiUIkBB9Mp91pQ3RSH/8TvQJaByVAfUODo3KhhmSbUoNInEg47
 59PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=iB4T9kLFB3iIR2Z+tST4GCiUmTN46viq6Nw4qtcThCM=;
 b=j06h3wfDZ5IrKM2R+liKzCU4WsV+aTPlkn9GKG/OEsGAGG3TLsYYT8Vf4NaD+HXaxU
 y+F4iTpEyJf04IhwfwokWwqozBKTNLDlWlHVM6E1OskKKfaE58tv9F28wYWZp3pXD6ZN
 KwX/FvtYrgU0WSR7QGov/Vcr3m2+OtCTAn8jTHvIzDWcFRJJsTOZk7TcZtDvQ25XXYt8
 U8MIg3pSmYnTUCrDdrYoKg/spQxvTgL/xCxZvKj2ikNsAyYBRdmvb4cHc5FeSx7VWEEc
 x0bUapsj11aaKyNZfkXlnzax32XAYtytpmajgjZCNx/kWWVLRJhQiJUkZWtm2ywsU76k
 oWwQ==
X-Gm-Message-State: AOAM533zxxKsvJCQvBJtWy9z4eLjyHgzSZYTVpsWmL51uqnmrSipv5OT
 /myBpFzRhgDUzEpFw2OrzatEaQ==
X-Google-Smtp-Source: ABdhPJxsgUHbqteuZSLV5s7MMDzWKj4bHGqYYGxCbtmcUOFgjTdJjebJk3JjekSIihnZSCM+KQlc3w==
X-Received: by 2002:adf:cf0b:: with SMTP id o11mr16218454wrj.94.1600104504963; 
 Mon, 14 Sep 2020 10:28:24 -0700 (PDT)
Received: from localhost (49.222.77.34.bc.googleusercontent.com.
 [34.77.222.49])
 by smtp.gmail.com with ESMTPSA id l126sm20422503wmf.39.2020.09.14.10.28.24
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 14 Sep 2020 10:28:24 -0700 (PDT)
From: George-Aurelian Popescu <georgepope@google.com>
To: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 masahiroy@kernel.org, michal.lkml@markovi.net
Subject: [PATCH 12/14] KVM: arm64: Detect arithmetic overflow is inside
 hyp/nVHE.
Date: Mon, 14 Sep 2020 17:27:48 +0000
Message-Id: <20200914172750.852684-13-georgepope@google.com>
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

Whenever an arithmetic overflow: addition, subtraction, multiplication,
division or negating happens inside the hyp/nVHE code,
an __ubsan_handle_*_overflow is called.

All the overflow handlers are sharing the same structure called
overflow_data and they use the write_overflow_data(*) function to store
the data to the buffer.

When decapsulating the data inside the kernel, the right handler is
called by checking the "op" field, which stores the arithmetic
opperator.

Signed-off-by: George Popescu <georgepope@google.com>
---
 arch/arm64/include/asm/kvm_ubsan.h | 10 ++++++--
 arch/arm64/kvm/hyp/nvhe/ubsan.c    | 40 ++++++++++++++++++++++++++----
 arch/arm64/kvm/kvm_ubsan_buffer.c  | 18 ++++++++++++++
 3 files changed, 61 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_ubsan.h b/arch/arm64/include/asm/kvm_ubsan.h
index a9f499f4ef6d..4abdbff38f79 100644
--- a/arch/arm64/include/asm/kvm_ubsan.h
+++ b/arch/arm64/include/asm/kvm_ubsan.h
@@ -24,7 +24,8 @@ struct kvm_ubsan_info {
 		UBSAN_UNREACHABLE_DATA,
 		UBSAN_SHIFT_OUT_OF_BOUNDS,
 		UBSAN_INVALID_DATA,
-		UBSAN_TYPE_MISMATCH
+		UBSAN_TYPE_MISMATCH,
+		UBSAN_OVERFLOW_DATA
 	} type;
 	union {
 		struct out_of_bounds_data out_of_bounds_data;
@@ -32,6 +33,7 @@ struct kvm_ubsan_info {
 		struct shift_out_of_bounds_data shift_out_of_bounds_data;
 		struct invalid_value_data invalid_value_data;
 		struct type_mismatch_data type_mismatch_data;
+		struct overflow_data overflow_data;
 	};
 	union {
 		struct ubsan_values u_val;
@@ -44,4 +46,8 @@ void __ubsan_handle_builtin_unreachable(void *_data);
 void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs);
 void __ubsan_handle_load_invalid_value(void *_data, void *val);
 void __ubsan_handle_type_mismatch(struct type_mismatch_data  *_data, void *ptr);
-
+void __ubsan_handle_add_overflow(void *data, void *lhs, void *rhs);
+void __ubsan_handle_sub_overflow(void *data, void *lhs, void *rhs);
+void __ubsan_handle_mul_overflow(void *data, void *lhs, void *rhs);
+void __ubsan_handle_negate_overflow(void *_data, void *old_val);
+void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs);
diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan.c b/arch/arm64/kvm/hyp/nvhe/ubsan.c
index c99d919105aa..dd2dae60864f 100644
--- a/arch/arm64/kvm/hyp/nvhe/ubsan.c
+++ b/arch/arm64/kvm/hyp/nvhe/ubsan.c
@@ -47,15 +47,45 @@ static void write_type_mismatch_data(struct type_mismatch_data_common *data, voi
 	}
 }
 
-void __ubsan_handle_add_overflow(void *_data, void *lhs, void *rhs) {}
+static void write_overflow_data(struct overflow_data *data, void *lval, void *rval, char op)
+{
+	struct kvm_ubsan_info *slot = kvm_ubsan_buffer_next_slot();
+
+	if (slot) {
+		slot->type = UBSAN_OVERFLOW_DATA;
+		slot->overflow_data = *data;
+		slot->u_val.op = op;
+		slot->u_val.lval = lval;
+		if (op != '!')
+			slot->u_val.rval = rval;
+	}
+}
+
+void __ubsan_handle_add_overflow(void *_data, void *lhs, void *rhs)
+{
+	write_overflow_data(_data, lhs, rhs, '+');
+}
 
-void __ubsan_handle_sub_overflow(void *_data, void *lhs, void *rhs) {}
+void __ubsan_handle_sub_overflow(void *_data, void *lhs, void *rhs)
+{
+	write_overflow_data(_data, lhs, rhs, '-');
+}
 
-void __ubsan_handle_mul_overflow(void *_data, void *lhs, void *rhs) {}
+void __ubsan_handle_mul_overflow(void *_data, void *lhs, void *rhs)
+{
+	write_overflow_data(_data, lhs, rhs, '*');
+}
 
-void __ubsan_handle_negate_overflow(void *_data, void *old_val) {}
+void __ubsan_handle_negate_overflow(void *_data, void *old_val)
+{
+	write_overflow_data(_data, old_val, NULL, '!');
+}
+
+void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs)
+{
+	write_overflow_data(_data, lhs, rhs, '/');
+}
 
-void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs) {}
 
 void __ubsan_handle_type_mismatch(struct type_mismatch_data *data, void *ptr)
 {
diff --git a/arch/arm64/kvm/kvm_ubsan_buffer.c b/arch/arm64/kvm/kvm_ubsan_buffer.c
index 21c242c92f0a..bd847ac1321e 100644
--- a/arch/arm64/kvm/kvm_ubsan_buffer.c
+++ b/arch/arm64/kvm/kvm_ubsan_buffer.c
@@ -40,6 +40,24 @@ void __kvm_check_ubsan_data(struct kvm_ubsan_info *slot)
 		__ubsan_handle_type_mismatch(&slot->type_mismatch_data,
 				slot->u_val.lval);
 		break;
+	case UBSAN_OVERFLOW_DATA:
+		if (slot->u_val.op == '/') {
+			__ubsan_handle_divrem_overflow(&slot->overflow_data,
+					slot->u_val.lval, slot->u_val.rval);
+		} else if (slot->u_val.op == '!') {
+			__ubsan_handle_negate_overflow(&slot->overflow_data,
+					slot->u_val.lval);
+		} else if (slot->u_val.op == '+') {
+			__ubsan_handle_add_overflow(&slot->overflow_data,
+					slot->u_val.lval, slot->u_val.rval);
+		} else if (slot->u_val.op == '-') {
+			__ubsan_handle_sub_overflow(&slot->overflow_data,
+					slot->u_val.lval, slot->u_val.rval);
+		} else if (slot->u_val.op == '*') {
+			__ubsan_handle_mul_overflow(&slot->overflow_data,
+					slot->u_val.lval, slot->u_val.rval);
+		}
+		break;
 	}
 }
 
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
