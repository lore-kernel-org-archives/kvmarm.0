Return-Path: <SRS0=WazV=CX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C793CC433E2
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 47D6C21D41
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="iEFv1oxO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47D6C21D41
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECC594B59B;
	Mon, 14 Sep 2020 13:28:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0pGdFeIWd1tT; Mon, 14 Sep 2020 13:28:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB78E4B59F;
	Mon, 14 Sep 2020 13:28:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 342834B57A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nUT5HNcHW-5J for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Sep 2020 13:28:22 -0400 (EDT)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2F4D34B594
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:22 -0400 (EDT)
Received: by mail-wm1-f67.google.com with SMTP id s13so800116wmh.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 10:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=oxR4q2exhcBC90vTFTNwz9/4eynAbLxOPQRAqHe9Mw8=;
 b=iEFv1oxODcKOHWza+NvTccTL3/wQordMg3U1eoRfqFg8wT2ZdgAAKIR5TqyBMDSz7j
 p6Two6b4VjgeiaRHbB/+ioQrmadcmqQvnY2N2R59qUqGWhKvSFcPBbecWZMmsRSOU+b8
 KasiVBhlOh+RhMOjN/LwusWdi6h9O0xedIEU1Db+QSOrCrPoo9U0qsW40Nrzrbp0EX3n
 +kIWWdPuoVXtvUJpO3w/+q3szInGmWzwUlyfDpMM1RV0gzMMrgepqVoqPV5Re2h4Id55
 72djWWoXs5+9bVxRyrIlmei/6++TYwru7YoKIBE4OfzDSAe/C622EhPn8E3Mn02ok9ma
 srOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=oxR4q2exhcBC90vTFTNwz9/4eynAbLxOPQRAqHe9Mw8=;
 b=iX7GMffULzZpTcAF12OxDe0pLxd96kIH7Y5F7YQociB5OgxYDoczyO1kbyJdzvab5a
 oW0RwggoR8dN7pZJHG0d/zhCU/ifE/GJoG+BJcDjH+gUSSjgfztVx8jp5oVQ1IB5VYgu
 SSleI1Du/EeLzIniEN/3wGs9q9eRg4dF4VXFXikr0PDPDqLQWgurvFsgC1CRkzaaOkYF
 D48zWDymo1xzMxtHfCvK/9mCutsoMtveQcbsjqNspqziiCUII/+1gwfusf/zDOLvZyUB
 MZbTi3n5fXlBHsxHLznaH39c4Vm46guw3yBaundV2ldPHY3zBEFKy1WBurBLawic2i7/
 a7HA==
X-Gm-Message-State: AOAM533P/hr587DSclDvkaHwrEvAm06HTnwF+LqDXMJRncMazZBqocmv
 BRfYljYcK8bu+7YErah6oSdgCQ==
X-Google-Smtp-Source: ABdhPJziHq0hb99caNbhZ6ZpDc46fHJPvgXN25hJZzyvPSDfDyF5i1/XYuIsmSM1xvZxBc9ptSKANw==
X-Received: by 2002:a1c:6145:: with SMTP id v66mr426746wmb.171.1600104501282; 
 Mon, 14 Sep 2020 10:28:21 -0700 (PDT)
Received: from localhost (49.222.77.34.bc.googleusercontent.com.
 [34.77.222.49])
 by smtp.gmail.com with ESMTPSA id m1sm20204287wmc.28.2020.09.14.10.28.20
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 14 Sep 2020 10:28:20 -0700 (PDT)
From: George-Aurelian Popescu <georgepope@google.com>
To: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 masahiroy@kernel.org, michal.lkml@markovi.net
Subject: [PATCH 10/14] KVM: arm64: __ubsan_handle_load_invalid_value hyp/nVHE
 implementation.
Date: Mon, 14 Sep 2020 17:27:46 +0000
Message-Id: <20200914172750.852684-11-georgepope@google.com>
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

The handler for the load invalid value undefined behaviour is
implemented for hyp/nVHE. The handler's parameters are stored inside
the buffer.

They are used by the symmetric handler from the kernel.

Signed-off-by: George Popescu <georgepope@google.com>
---
 arch/arm64/include/asm/kvm_ubsan.h |  5 ++++-
 arch/arm64/kvm/hyp/nvhe/ubsan.c    | 14 +++++++++++++-
 arch/arm64/kvm/kvm_ubsan_buffer.c  |  4 ++++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_ubsan.h b/arch/arm64/include/asm/kvm_ubsan.h
index 3130a80cd8b2..b643ac9a4090 100644
--- a/arch/arm64/include/asm/kvm_ubsan.h
+++ b/arch/arm64/include/asm/kvm_ubsan.h
@@ -22,12 +22,14 @@ struct kvm_ubsan_info {
 		UBSAN_NONE,
 		UBSAN_OUT_OF_BOUNDS,
 		UBSAN_UNREACHABLE_DATA,
-		UBSAN_SHIFT_OUT_OF_BOUNDS
+		UBSAN_SHIFT_OUT_OF_BOUNDS,
+		UBSAN_INVALID_DATA
 	} type;
 	union {
 		struct out_of_bounds_data out_of_bounds_data;
 		struct unreachable_data unreachable_data;
 		struct shift_out_of_bounds_data shift_out_of_bounds_data;
+		struct invalid_value_data invalid_value_data;
 	};
 	union {
 		struct ubsan_values u_val;
@@ -38,3 +40,4 @@ struct kvm_ubsan_info {
 void __ubsan_handle_out_of_bounds(void *_data, void *index);
 void __ubsan_handle_builtin_unreachable(void *_data);
 void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs);
+void __ubsan_handle_load_invalid_value(void *_data, void *val);
diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan.c b/arch/arm64/kvm/hyp/nvhe/ubsan.c
index 40b82143e57f..1888a1f51724 100644
--- a/arch/arm64/kvm/hyp/nvhe/ubsan.c
+++ b/arch/arm64/kvm/hyp/nvhe/ubsan.c
@@ -82,4 +82,16 @@ void __ubsan_handle_builtin_unreachable(void *_data)
 	}
 }
 
-void __ubsan_handle_load_invalid_value(void *_data, void *val) {}
+void __ubsan_handle_load_invalid_value(void *_data, void *val)
+{
+	struct kvm_ubsan_info *slot;
+	struct invalid_value_data *data = _data;
+
+	slot = kvm_ubsan_buffer_next_slot();
+	if (slot) {
+		slot->type = UBSAN_INVALID_DATA;
+		slot->invalid_value_data = *data;
+		slot->u_val.lval = val;
+	}
+
+}
diff --git a/arch/arm64/kvm/kvm_ubsan_buffer.c b/arch/arm64/kvm/kvm_ubsan_buffer.c
index b4a282bec91d..01bf2171af9e 100644
--- a/arch/arm64/kvm/kvm_ubsan_buffer.c
+++ b/arch/arm64/kvm/kvm_ubsan_buffer.c
@@ -32,6 +32,10 @@ void __kvm_check_ubsan_data(struct kvm_ubsan_info *slot)
 		__ubsan_handle_shift_out_of_bounds(&slot->shift_out_of_bounds_data,
 				slot->u_val.lval, slot->u_val.rval);
 		break;
+	case UBSAN_INVALID_DATA:
+		__ubsan_handle_load_invalid_value(&slot->invalid_value_data,
+				slot->u_val.lval);
+		break;
 	}
 }
 
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
