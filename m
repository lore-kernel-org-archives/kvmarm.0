Return-Path: <SRS0=WazV=CX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFE6C43461
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8471A20771
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="EYgWAcl9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8471A20771
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2688A4B170;
	Mon, 14 Sep 2020 13:28:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aLVhpveqvKVD; Mon, 14 Sep 2020 13:28:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09A614B58D;
	Mon, 14 Sep 2020 13:28:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 240F84B49A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hacQJIDQfsx3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Sep 2020 13:28:20 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C3134B571
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:20 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id m6so556515wrn.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 10:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=KftJRcollRLFMVov7TaPj7WtBHwyxRPUsiHY/UZT1fw=;
 b=EYgWAcl9cL9AeiTblL7CMC+AqQx78U6/I1W7VW7Ja5I15I0jt+My8KPdhD1SAVpEHD
 AJXt5LuKrD0WR0bw/B1exIDwe7tkOX43hf5qS4uwiYCJAEU/FA1aTxXb7U22+RLK0Gw5
 IEqZhFqCrBcnVwsvqPgPtUtdGHrW6CU24YKBfkwIy52kBZc31aRqkrNTC7FpmXQy/eQ5
 dVCJRFM3SOoQVUXjSfMIKlDXY7aS2d0IgN2BzjI6mWTiBBzhjwhcJRJy/vKgdde8y6Km
 iNWk73Vy+veU+2hjy0D/PR5vfHhuUmQkzEOLnrIPC2sx7KQNQCejEB2d78t3JnwXXpZV
 WvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=KftJRcollRLFMVov7TaPj7WtBHwyxRPUsiHY/UZT1fw=;
 b=dWBRIOVOLaLh/1XdB1B4W7393/pS31E11nj2cynoJ3eCW/JP6uc6F5cPoHXP//Rawv
 1CnCOKbTqf3NW4/WBLrhIhwtN4wI2cqitGf+1bRpixYTn4+iBZZwzmxd65ICn30dBsfg
 X0zitCFLwm7J8Ro/+tGLO54y/q1Bjsed94czDHzkJli2QQgOgkYqNk1Mzl84Ea4Ix299
 tyq7cfSeMv/0ytcqd217IBL99ARG2Y4UH66i3IOkWpkJcMgpbZPRK+1TjlzT6x8gITLR
 tz/NcAT6TxEE9gYvCP/aqb/eLB57XeDr/7zLcnFUXdwt+yrEJZvy7qKWid5spgSd0vkq
 p34Q==
X-Gm-Message-State: AOAM533/Mo6mk2s4g/R44F4DvhEcAEou4hTa3fe4W0J508RvDnsZN7ZT
 GmtLbDe0Zw8L2J0wJSteDKszig==
X-Google-Smtp-Source: ABdhPJyWV+uC0DmNRAdK7vcbjg9wndOENA5KYq6/erRd565McYdWx62TZeUsQp7Eg/H+vCrNtXp7tA==
X-Received: by 2002:adf:f10a:: with SMTP id r10mr16416565wro.86.1600104499411; 
 Mon, 14 Sep 2020 10:28:19 -0700 (PDT)
Received: from localhost (49.222.77.34.bc.googleusercontent.com.
 [34.77.222.49])
 by smtp.gmail.com with ESMTPSA id l19sm19870946wmi.8.2020.09.14.10.28.18
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 14 Sep 2020 10:28:18 -0700 (PDT)
From: George-Aurelian Popescu <georgepope@google.com>
To: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 masahiroy@kernel.org, michal.lkml@markovi.net
Subject: [PATCH 09/14] KVM: arm64: Enable shift out of bounds undefined
 behaviour check for hyp/nVHE
Date: Mon, 14 Sep 2020 17:27:45 +0000
Message-Id: <20200914172750.852684-10-georgepope@google.com>
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

__ubsan_handle_shift_out_of_bounds data is passed to the buffer inside
hyp/nVHE. This data is passed to the original handler from kernel.

The values of the operands of the shift expression are stored as the lhs
and rhs pointers, so there is no need to dereference them.

Signed-off-by: George Popescu <georgepope@google.com>
---
 arch/arm64/include/asm/kvm_ubsan.h |  5 ++++-
 arch/arm64/kvm/hyp/nvhe/ubsan.c    | 14 +++++++++++++-
 arch/arm64/kvm/kvm_ubsan_buffer.c  |  4 ++++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_ubsan.h b/arch/arm64/include/asm/kvm_ubsan.h
index 7fd0d0dfbd82..3130a80cd8b2 100644
--- a/arch/arm64/include/asm/kvm_ubsan.h
+++ b/arch/arm64/include/asm/kvm_ubsan.h
@@ -21,11 +21,13 @@ struct kvm_ubsan_info {
 	enum {
 		UBSAN_NONE,
 		UBSAN_OUT_OF_BOUNDS,
-		UBSAN_UNREACHABLE_DATA
+		UBSAN_UNREACHABLE_DATA,
+		UBSAN_SHIFT_OUT_OF_BOUNDS
 	} type;
 	union {
 		struct out_of_bounds_data out_of_bounds_data;
 		struct unreachable_data unreachable_data;
+		struct shift_out_of_bounds_data shift_out_of_bounds_data;
 	};
 	union {
 		struct ubsan_values u_val;
@@ -35,3 +37,4 @@ struct kvm_ubsan_info {
 
 void __ubsan_handle_out_of_bounds(void *_data, void *index);
 void __ubsan_handle_builtin_unreachable(void *_data);
+void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs);
diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan.c b/arch/arm64/kvm/hyp/nvhe/ubsan.c
index 9497e7f7f397..40b82143e57f 100644
--- a/arch/arm64/kvm/hyp/nvhe/ubsan.c
+++ b/arch/arm64/kvm/hyp/nvhe/ubsan.c
@@ -56,7 +56,19 @@ void __ubsan_handle_out_of_bounds(void *_data, void *index)
 	}
 }
 
-void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs) {}
+void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs)
+{
+	struct kvm_ubsan_info *slot;
+	struct shift_out_of_bounds_data *data = _data;
+
+	slot = kvm_ubsan_buffer_next_slot();
+	if (slot) {
+		slot->type = UBSAN_SHIFT_OUT_OF_BOUNDS;
+		slot->shift_out_of_bounds_data = *data;
+		slot->u_val.lval = lhs;
+		slot->u_val.rval = rhs;
+	}
+}
 
 void __ubsan_handle_builtin_unreachable(void *_data)
 {
diff --git a/arch/arm64/kvm/kvm_ubsan_buffer.c b/arch/arm64/kvm/kvm_ubsan_buffer.c
index f66cc5f7878e..b4a282bec91d 100644
--- a/arch/arm64/kvm/kvm_ubsan_buffer.c
+++ b/arch/arm64/kvm/kvm_ubsan_buffer.c
@@ -28,6 +28,10 @@ void __kvm_check_ubsan_data(struct kvm_ubsan_info *slot)
 	case UBSAN_UNREACHABLE_DATA:
 		__ubsan_handle_builtin_unreachable(&slot->unreachable_data);
 		break;
+	case UBSAN_SHIFT_OUT_OF_BOUNDS:
+		__ubsan_handle_shift_out_of_bounds(&slot->shift_out_of_bounds_data,
+				slot->u_val.lval, slot->u_val.rval);
+		break;
 	}
 }
 
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
