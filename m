Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5AB1C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:19:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 33395238EE
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:19:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33395238EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2E0C4B17A;
	Fri, 15 Jan 2021 12:19:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dwZbxnI0i1wS; Fri, 15 Jan 2021 12:19:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B6874B24C;
	Fri, 15 Jan 2021 12:19:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A61244B24A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:19:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WZ0inTgrw4mD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 12:19:03 -0500 (EST)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A409F4B255
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:19:03 -0500 (EST)
Received: by mail-qt1-f201.google.com with SMTP id j1so7911123qtd.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 09:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=r0Yb1c7k86IyNObw3uSoYlpOEjwui41Agh14pBOSnbw=;
 b=hSGoDFKkQJHGGbbbprh+JxndXzQMIC8A2b8d9cTjLGKS/6zjlELBAHWg4LPBIoZ4jj
 sjmAkDmfv8OsfkYhVYnYCIySbeWOKuX/YZ1Ccj1CD02RwKuakr2GX0dRfijjqAv1wS3K
 U9n5bG3Wpn8v3e/+eR4uc6iSuNxdSuav4Ptyyb1iFzorCs1hN2Mi7vMiOD2jI2m59SYP
 hE2QzF1GzaMu2pOCfiYHmdwDe6f0Z0L4DNaBXsGwupkD6R3LZKduwiOrHwvy3o6qXMuA
 SulMTJ5ImdYgKkn7evHvJql8gV/auPPTSyGhJAq51ES+qrEVB9OqAbZNeZhysMsu2A4E
 boCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=r0Yb1c7k86IyNObw3uSoYlpOEjwui41Agh14pBOSnbw=;
 b=INsg/6qon+T1pg+OAiG5YTKyZg2E8quVs9P2+9cN/dpuCgxwRTUd6zDKDSM/uy+o8/
 92yQCwBZAr3wJAUlLGqPonBNdoxZIs6BEo0GFgeEjZv8PnG5tESXOcUVMlyO0VUGPWCh
 mz9pOHh++y3lzl/KPtlYrUKIUkYzWp45ZYLWC383t6n3gqPYCHVRBD/wgmHKXG2lPvRA
 iVqSA/r0He7HEwo6C6O+SOuuFP7lukp6f+wFX3215xfa6YfqZcQgwQzetoguGB9Mx7xw
 c3WzixDRzEdc53WUVthZKhC0PmUJlAIAuHvMoS3ZDVBvy0dqk2rIg0sCerT1QppcutYD
 VSeg==
X-Gm-Message-State: AOAM531ft4lEnrDfsAXLZNyYGbY9n9WNQmkh8+MiWgJ6YQygQ5k+TFa2
 yhstHKSToKMq89KvuYe2vA8aeWaMF0hMQWTkONd8kJWA2BoFEpTiUkzTtQ5SK7cu4vH7D9bYqZF
 Qgmp1rUeRSbxXEfABS3BaZZskKfniry77sirMrjvYiymcGJl1VDe+GH5wLJ875jhd8tmbj5Fj
X-Google-Smtp-Source: ABdhPJweYd/lOR/2KFC86rRuTjATek2F+PrOdMNMG0Iz9+YTijZh11W4oUszwbXeTbKE9po4C1UvasiMh4dA
X-Received: from beef.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1091])
 (user=lenaptr job=sendgmr) by 2002:a0c:b65f:: with SMTP id
 q31mr13017862qvf.24.1610731143114; Fri, 15 Jan 2021 09:19:03 -0800 (PST)
Date: Fri, 15 Jan 2021 17:18:26 +0000
In-Reply-To: <20210115171830.3602110-1-lenaptr@google.com>
Message-Id: <20210115171830.3602110-6-lenaptr@google.com>
Mime-Version: 1.0
References: <20210115171830.3602110-1-lenaptr@google.com>
X-Mailer: git-send-email 2.30.0.296.g2bfb1c46d8-goog
Subject: [PATCH v3 5/9] KVM: arm64: Enable shift out of bounds undefined
 behaviour check for hyp/nVHE
From: Elena Petrova <lenaptr@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: George Popescu <georgepope@google.com>, Elena Petrova <lenaptr@google.com>,
 Marc Zyngier <maz@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-arm-kernel@lists.infradead.org,
 George Popescu <george.apopescu97@gmail.com>
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

The 64bit values of the shift expression operands are stored as the lhs
and rhs pointers, so there is no need to dereference them.

Signed-off-by: George Popescu <georgepope@google.com>
Signed-off-by: Elena Petrova <lenaptr@google.com>
---
 arch/arm64/include/asm/kvm_ubsan.h |  5 ++++-
 arch/arm64/kvm/hyp/nvhe/ubsan.c    | 14 +++++++++++++-
 arch/arm64/kvm/kvm_ubsan_buffer.c  |  4 ++++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_ubsan.h b/arch/arm64/include/asm/kvm_ubsan.h
index 70c6f2541d07..0eef0e11a93b 100644
--- a/arch/arm64/include/asm/kvm_ubsan.h
+++ b/arch/arm64/include/asm/kvm_ubsan.h
@@ -19,11 +19,13 @@ struct ubsan_values {
 struct kvm_ubsan_info {
 	enum {
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
@@ -32,3 +34,4 @@ struct kvm_ubsan_info {
 
 void __ubsan_handle_out_of_bounds(void *_data, void *index);
 void __ubsan_handle_builtin_unreachable(void *_data);
+void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs);
diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan.c b/arch/arm64/kvm/hyp/nvhe/ubsan.c
index 5e55897b2d72..1069ed5036d5 100644
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
index e51949c275aa..b80045883047 100644
--- a/arch/arm64/kvm/kvm_ubsan_buffer.c
+++ b/arch/arm64/kvm/kvm_ubsan_buffer.c
@@ -27,6 +27,10 @@ void __kvm_check_ubsan_data(struct kvm_ubsan_info *slot)
 	case UBSAN_UNREACHABLE_DATA:
 		__ubsan_handle_builtin_unreachable(&slot->unreachable_data);
 		break;
+	case UBSAN_SHIFT_OUT_OF_BOUNDS:
+        	__ubsan_handle_shift_out_of_bounds(&slot->shift_out_of_bounds_data,
+				slot->u_val.lval, slot->u_val.rval);
+		break;
 	}
 }
 
-- 
2.30.0.296.g2bfb1c46d8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
