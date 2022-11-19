Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0311E37C
	for <kvmarm@lists.linux.dev>; Sat, 19 Nov 2022 01:35:04 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id f22-20020a635556000000b0046fd05d55cdso3946662pgm.1
        for <kvmarm@lists.linux.dev>; Fri, 18 Nov 2022 17:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=HwpHtjW2tWLEm+B8HZt2gKJ4ajkO6tFSNWL6y95xS6C/fEh9EjyfrS4ZSAwt5U1070
         5vDPlUG24qPfZ1wKMjaJOPrpXYe8VTC+gSNLB7RbhU0JVWt4iLVx8RlGaqo3CvYfJfVe
         A6MfKaS110ftLYv1HfGAM6o7INkjs/QzR4PqQ4jHSvjmzCTxBBt0MKEkYlC8vDTQE6A9
         tzHzbhEZxFIY9iCGnTOJzs3E0D/S8IesOkpjBpihftGAc7y2n17iPaaH55HOpBCM5XiI
         2VCw9KMbsSwrfas+f90qZvlNdooHXjGIPLc1uipFO7VlAVX/1ibpW8KRA0QLg8T9Y8Oh
         Jxug==
X-Gm-Message-State: ANoB5plqiqnxDDtO6CX4xS6IY9RH5LepWu/5/pB0OZ6E5af0YxPMzw+4
	WZJygW1M064LM1aJT8PQinsiMFjGlnQ=
X-Google-Smtp-Source: AA0mqf4s6WDEnZBoY+6XZCe4HZOEbOD1f6H/JunJuats/BV6uCd/5C6MD5Uo30NfHWTAU95c5mftoaNq5KY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:16d4:0:b0:572:6b5f:bdc2 with SMTP id
 203-20020a6216d4000000b005726b5fbdc2mr10383566pfw.36.1668821704620; Fri, 18
 Nov 2022 17:35:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Sat, 19 Nov 2022 01:34:48 +0000
In-Reply-To: <20221119013450.2643007-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221119013450.2643007-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221119013450.2643007-8-seanjc@google.com>
Subject: [PATCH 7/9] tools: Drop conflicting non-atomic test_and_{clear,set}_bit()
 helpers
From: Sean Christopherson <seanjc@google.com>
To: Yury Norov <yury.norov@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221119013448.2j4vo1waOpZky7h5a7dmjwq7qKdSYFpGu0IspIdIvW0@z>

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

