Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE55C4332F
	for <kvmarm@archiver.kernel.org>; Sat, 19 Nov 2022 01:35:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D8AC4BB5F;
	Fri, 18 Nov 2022 20:35:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FONpRUAL7HBi; Fri, 18 Nov 2022 20:35:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 610BE4BB6D;
	Fri, 18 Nov 2022 20:35:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5BBA4B64F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 20:35:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pj-GK5l-MdBF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Nov 2022 20:35:06 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 116F84BB54
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 20:35:05 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 k16-20020a635a50000000b0042986056df6so3956823pgm.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 17:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=tD2ZlexlcX0KfmQHE0mJ5LR6ZJYKnXIf8Otqhyd2XwU=;
 b=MB9MhSdwME1l5f01zL+yqUNJf3WE7Wu0+w8g0OhQMoRgcdFNMiEl2Posb3nwOUuTuD
 +tDRTwe89VCBh4TUUBZYFwPkQegSk7I3pM8hr0OWMKYHJXHnIW5iyWHzAp1baiIvkL+M
 xvWAhhFwW2Yf1Gj5279lBpactxhKOCQ0IEInrZiBKCsvP5jjloBw2bf5pvCQbaP/a02E
 HctMjGFpVqM0zObrPX67hF9ozKCMkdYoLheziBuZphT1nqQ1b2UPE5GWbP6p2+JrfcJy
 4NPgcWYf4DFDp2d5yS3j2Vy/fKpDMxIRtkJbIs7JiWbVyohddhm+ah4g1/MDsxL6xsfT
 dFHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=tD2ZlexlcX0KfmQHE0mJ5LR6ZJYKnXIf8Otqhyd2XwU=;
 b=tSrG/HQTv3e9QBTkHlL/ruz2qSi4AaQbtCj9x1bMm4WatAl18bthdXYGxWrjgavfDR
 apITywD7N+dAyQ3bSHVVfC8lw5Afao0bi2HUg/VmHqC7jbzt3WDEssp/AwPpL3tgQ+kj
 CSSt5P3GNnSu/X6H3BLdpCEgEn7PKN1SD+6IlHKOWUb97+n3cnOalzA2TkrdjQjiZ0ZT
 BTZKYzGdYJ23hlzoHo7FqOMim5t4tzBau4jq9gJdczzxq/KGFyfUcJRc59qKitNfdw2p
 eHhcQXxSYRb2BlYswF9YkBUsh0PCgm14MwHm/v9+IocXyl0Kr+ztNFUYj/k4DVMhcry3
 jDHA==
X-Gm-Message-State: ANoB5pmcXE3ME7hEfTs8uPSpuLj2GMtSCn/9c8pO1ecu4bTDZTVhKZZL
 uiZ8KuZXQRtlLILh6R1WVj6Deep3PnQ=
X-Google-Smtp-Source: AA0mqf4s6WDEnZBoY+6XZCe4HZOEbOD1f6H/JunJuats/BV6uCd/5C6MD5Uo30NfHWTAU95c5mftoaNq5KY=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:16d4:0:b0:572:6b5f:bdc2 with SMTP id
 203-20020a6216d4000000b005726b5fbdc2mr10383566pfw.36.1668821704620; Fri, 18
 Nov 2022 17:35:04 -0800 (PST)
Date: Sat, 19 Nov 2022 01:34:48 +0000
In-Reply-To: <20221119013450.2643007-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221119013450.2643007-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221119013450.2643007-8-seanjc@google.com>
Subject: [PATCH 7/9] tools: Drop conflicting non-atomic test_and_{clear,
 set}_bit() helpers
From: Sean Christopherson <seanjc@google.com>
To: Yury Norov <yury.norov@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
 kvmarm@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Drop tools' non-atomic test_and_set_bit() and test_and_clear_bit() helpers
now that all users are gone.  The names will be claimed in the future for
atomic versions.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/include/linux/bitmap.h | 34 ----------------------------------
 1 file changed, 34 deletions(-)

diff --git a/tools/include/linux/bitmap.h b/tools/include/linux/bitmap.h
index 65d0747c5205..f3566ea0f932 100644
--- a/tools/include/linux/bitmap.h
+++ b/tools/include/linux/bitmap.h
@@ -77,40 +77,6 @@ static inline void bitmap_or(unsigned long *dst, const unsigned long *src1,
 		__bitmap_or(dst, src1, src2, nbits);
 }
 
-/**
- * test_and_set_bit - Set a bit and return its old value
- * @nr: Bit to set
- * @addr: Address to count from
- */
-static inline int test_and_set_bit(int nr, unsigned long *addr)
-{
-	unsigned long mask = BIT_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
-	unsigned long old;
-
-	old = *p;
-	*p = old | mask;
-
-	return (old & mask) != 0;
-}
-
-/**
- * test_and_clear_bit - Clear a bit and return its old value
- * @nr: Bit to clear
- * @addr: Address to count from
- */
-static inline int test_and_clear_bit(int nr, unsigned long *addr)
-{
-	unsigned long mask = BIT_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
-	unsigned long old;
-
-	old = *p;
-	*p = old & ~mask;
-
-	return (old & mask) != 0;
-}
-
 /**
  * bitmap_zalloc - Allocate bitmap
  * @nbits: Number of bits
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
