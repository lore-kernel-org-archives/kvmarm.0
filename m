Return-Path: <SRS0=WazV=CX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4E7C2BC11
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1D01A21D1A
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="LDOJW73/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D01A21D1A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC2034B5B8;
	Mon, 14 Sep 2020 13:28:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PYIvenG7qq9L; Mon, 14 Sep 2020 13:28:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1C9B4B59C;
	Mon, 14 Sep 2020 13:28:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 872914B59F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4HHKvL+dVOnN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Sep 2020 13:28:18 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 72AAB4B58D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:18 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id s13so799923wmh.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 10:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=/EjNih3r7ygkjYASNBWp7YtEX1KLL1OovUvtOR4yQ8E=;
 b=LDOJW73/Nx4NRSF62nukRv0fkeOiLGfPXVP1aJhDKCMUKmk3HmHAf6NWlyYj1Fc30H
 4ctb86ijJJ+PMUx7pA1+2eEIf+G0cmjOvbtE9oBe55C3Cvn1qkgI3USj0yAzKEsPU9q0
 Kg6zWbX13Nvf35fM5FUm0vCKYp5AV89AlTGoxiq/9SNtkV9H5JeJZSjohjU7p9UCPTCc
 AFzF0SLwziqh80xl5uTlhqNQPcFqdMho3+ObPMEgdgw7XZugj3HlUg9gMeuZ9Wl5vn3G
 sEIZ2338YOSdEnkx35Dj1zujfiD6uqhHIIRpeBrFBUJeHIahNLU31ZLtfIcNVZWFj6tG
 ir0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=/EjNih3r7ygkjYASNBWp7YtEX1KLL1OovUvtOR4yQ8E=;
 b=pT4yiP/76pvUyrwKvuTCl97ogEq2mAjDWGX76eBhZZQQhJ9aUTMMZwLZHCuh73WpUe
 0AHzBKNwzs/grZ68YsYOnCfZOSwll6ZN2PH+ajyC+xEx8UC3VeQjr8A5TJt05Ragn7c7
 FQnjfn0m5SOkgvm9qnZt5jsfjWo/WUIfPhB3CUecKLaLjt8b6zlUisC6JwoYQ53nBT8q
 j8VoCTR6lz7YJeTLVolBC8jiwZSks6PKaLLzWoqRYi5W0PwLiPKSyAW7RwX3oMV1zIco
 Gn/G5QK3u3jRl1HmeDFtRCAvpfS5DeSvNIxjHiH+2vN4TPHxln3NosSWmu6hd4eriUxB
 fAKg==
X-Gm-Message-State: AOAM533Mbl7XvqWj9wwOl9XcBzYLvXG8IiGnQZDIOknFETSse7stB6g8
 repveMe1zzs0NLChs8l6hQZJXw==
X-Google-Smtp-Source: ABdhPJz7n/8ZzKopjoksEbonJHe8/t/B9RylxHy4LiUHqu75FJ9ZhVdcDVjP7yVogd6IknutagEtqw==
X-Received: by 2002:a1c:a551:: with SMTP id o78mr486952wme.4.1600104497464;
 Mon, 14 Sep 2020 10:28:17 -0700 (PDT)
Received: from localhost (49.222.77.34.bc.googleusercontent.com.
 [34.77.222.49])
 by smtp.gmail.com with ESMTPSA id a17sm22898300wra.24.2020.09.14.10.28.16
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 14 Sep 2020 10:28:16 -0700 (PDT)
From: George-Aurelian Popescu <georgepope@google.com>
To: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 masahiroy@kernel.org, michal.lkml@markovi.net
Subject: [PATCH 08/14] KVM: arm64: Enable UBsan check for unreachable code
 inside hyp/nVHE code
Date: Mon, 14 Sep 2020 17:27:44 +0000
Message-Id: <20200914172750.852684-9-georgepope@google.com>
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

The data from __ubsan_handle_builtin_unreachable is passed to the buffer
and printed inside the kernel by its symmetric handler.

Signed-off-by: George Popescu <georgepope@google.com>
---
 arch/arm64/include/asm/kvm_ubsan.h |  5 ++++-
 arch/arm64/kvm/hyp/nvhe/ubsan.c    | 12 +++++++++++-
 arch/arm64/kvm/kvm_ubsan_buffer.c  |  3 +++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_ubsan.h b/arch/arm64/include/asm/kvm_ubsan.h
index 575881e0bd5f..7fd0d0dfbd82 100644
--- a/arch/arm64/include/asm/kvm_ubsan.h
+++ b/arch/arm64/include/asm/kvm_ubsan.h
@@ -20,10 +20,12 @@ struct ubsan_values {
 struct kvm_ubsan_info {
 	enum {
 		UBSAN_NONE,
-		UBSAN_OUT_OF_BOUNDS
+		UBSAN_OUT_OF_BOUNDS,
+		UBSAN_UNREACHABLE_DATA
 	} type;
 	union {
 		struct out_of_bounds_data out_of_bounds_data;
+		struct unreachable_data unreachable_data;
 	};
 	union {
 		struct ubsan_values u_val;
@@ -32,3 +34,4 @@ struct kvm_ubsan_info {
 #endif
 
 void __ubsan_handle_out_of_bounds(void *_data, void *index);
+void __ubsan_handle_builtin_unreachable(void *_data);
diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan.c b/arch/arm64/kvm/hyp/nvhe/ubsan.c
index b2d3404f6215..9497e7f7f397 100644
--- a/arch/arm64/kvm/hyp/nvhe/ubsan.c
+++ b/arch/arm64/kvm/hyp/nvhe/ubsan.c
@@ -58,6 +58,16 @@ void __ubsan_handle_out_of_bounds(void *_data, void *index)
 
 void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs) {}
 
-void __ubsan_handle_builtin_unreachable(void *_data) {}
+void __ubsan_handle_builtin_unreachable(void *_data)
+{
+	struct kvm_ubsan_info *slot;
+	struct unreachable_data *data = _data;
+
+	slot = kvm_ubsan_buffer_next_slot();
+	if (slot) {
+		slot->type = UBSAN_UNREACHABLE_DATA;
+		slot->unreachable_data = *data;
+	}
+}
 
 void __ubsan_handle_load_invalid_value(void *_data, void *val) {}
diff --git a/arch/arm64/kvm/kvm_ubsan_buffer.c b/arch/arm64/kvm/kvm_ubsan_buffer.c
index ce796bdd027e..f66cc5f7878e 100644
--- a/arch/arm64/kvm/kvm_ubsan_buffer.c
+++ b/arch/arm64/kvm/kvm_ubsan_buffer.c
@@ -25,6 +25,9 @@ void __kvm_check_ubsan_data(struct kvm_ubsan_info *slot)
 		__ubsan_handle_out_of_bounds(&slot->out_of_bounds_data,
 				slot->u_val.lval);
 		break;
+	case UBSAN_UNREACHABLE_DATA:
+		__ubsan_handle_builtin_unreachable(&slot->unreachable_data);
+		break;
 	}
 }
 
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
