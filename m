Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B62C4332F
	for <kvmarm@archiver.kernel.org>; Sat, 19 Nov 2022 01:35:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EB924B64F;
	Fri, 18 Nov 2022 20:35:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wbUoWrcmRc+C; Fri, 18 Nov 2022 20:35:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30D104BB6C;
	Fri, 18 Nov 2022 20:35:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1A984B64F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 20:35:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tUV8OoWEOXCK for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Nov 2022 20:35:02 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5F704BB5F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 20:35:00 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 k16-20020a635a50000000b0042986056df6so3956705pgm.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 17:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=TighIegw0FVxEDaBlZjjTMFerelt3ds/i85zL8CdikU=;
 b=rmXe3VvPa8zVoj+4dcS77sndQg/asQbzYB56Apv5ggGW1UuoVvHp+A5nMUNJLLDfT3
 0SofbaNG1mdy2xYr69bYijAVWvASmZ+BqpR/39RMUQ9fkkgAxOfAbbiCLxjhwxFDSnJD
 CYvPDNSf4OyAJDiay7zq/RREBEcBoCo+j9xnBGDg3cCGMQQFHgk7xqMIHyhqLMB+bCwR
 NAaB2xI/+noK1nArryRf5o2AI/YWSXe/+BtRdDtBj4KcS5PatRnf6S7gkyW5Yh4ep5o2
 9FIQoQ8VkWuppw661uC0FbLCjWmBTrmiieXQzRAdkvaLBoGT3HMeR/wJf7SYLzVFCqzk
 4tiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=TighIegw0FVxEDaBlZjjTMFerelt3ds/i85zL8CdikU=;
 b=553ZCqA/uJMj6j+kaksk1v+6pSJMmZ+QXB8STZZzduZvqkhLSdxO3Y5pLmvRmryZLQ
 tsRnSCxtBkd/2nVS+V/Ff4hYuRnbyhWi7Y81gr3gNWL9EKsG/vsQoFD2wOxiqWx/wI+G
 lYx1xAJpm08CWhoQoYSuyQmpdq7Kin/JtgHdubPBsWAgK6gXY97jq3QDabDgLfjjreyg
 PfkD4MMkIcBwZ15MBJUcwlCKsWXYaeb5rYQJdWcmsBAPLCkezMpQTB4QSqhm6t9FjlGO
 UbUyQRE2kxZBv7RUEkjx3EUfpLFO1DAiJeA0qEeveSunfoWwct0tXtW2re/H03+aMYjL
 qoqg==
X-Gm-Message-State: ANoB5pmkb1urYfLoPPILFruiV/0VU9m1MpXzKYJ6SBU+pzUpt2Re9puX
 gSAJ58zbPVgAZFTK8+KMdhj1CekiRLM=
X-Google-Smtp-Source: AA0mqf7npHfQc5LwOz0q7JCYBS7uttfoGJCbriNRIIB73IIE/vGbpLSdnE48DGaUO0X9NP3W41W4iWnhxeQ=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8d88:0:b0:562:69d4:f9f3 with SMTP id
 i8-20020aa78d88000000b0056269d4f9f3mr10570461pfr.5.1668821700033; Fri, 18 Nov
 2022 17:35:00 -0800 (PST)
Date: Sat, 19 Nov 2022 01:34:45 +0000
In-Reply-To: <20221119013450.2643007-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221119013450.2643007-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221119013450.2643007-5-seanjc@google.com>
Subject: [PATCH 4/9] tools: Take @bit as an "unsigned long" in
 {clear,set}_bit() helpers
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

Take @bit as an unsigned long instead of a signed int in clear_bit() and
set_bit() so that they match the double-underscore versions, __clear_bit()
and __set_bit().  This will allow converting users that really don't want
atomic operations to the double-underscores without introducing a
functional change, which will in turn allow making {clear,set}_bit()
atomic (as advertised).

Practically speaking, this _should_ have no functional impact.  KVM's
selftests usage is either hardcoded (Hyper-V tests) or is artificially
limited (arch_timer test and dirty_log test).  In KVM, dirty_log test is
the only mildly interesting case as it's use indirectly restricted to
unsigned 32-bit values, but in theory it could generate a negative value
when cast to a signed int.  But in that case, taking an "unsigned long"
is actually a bug fix.

Perf's usage is more difficult to audit, but any code that is affected
by the switch is likely already broken.  perf_header__{set,clear}_feat()
and perf_file_header__read() effectively use only hardcoded enums with
small, positive values, atom_new() passes an unsigned long, but its value
is capped at 128 via NR_ATOM_PER_PAGE, etc...

The only real potential for breakage is in the perf flows that take a
"cpu", but it's unlikely perf is subtly relying on a negative index into
bitmaps, e.g. "cpu" can be "-1", but only as "not valid" placeholder.

Note, tools/testing/nvdimm/ makes heavy use of set_bit(), but that code
builds into a kernel module of sorts, i.e. pulls in all of the kernel's
header and so is getting the kernel's atomic set_bit().  The NVDIMM test
usage of atomics is likely unnecessary, e.g. ndtest_dimm_register() sets
bits in a local variable, but that's neither here nor there as far as
this change is concerned.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/include/asm-generic/bitops/atomic.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/include/asm-generic/bitops/atomic.h b/tools/include/asm-generic/bitops/atomic.h
index 2f6ea28764a7..f64b049d236c 100644
--- a/tools/include/asm-generic/bitops/atomic.h
+++ b/tools/include/asm-generic/bitops/atomic.h
@@ -5,12 +5,12 @@
 #include <asm/types.h>
 #include <asm/bitsperlong.h>
 
-static inline void set_bit(int nr, unsigned long *addr)
+static inline void set_bit(unsigned long nr, unsigned long *addr)
 {
 	addr[nr / __BITS_PER_LONG] |= 1UL << (nr % __BITS_PER_LONG);
 }
 
-static inline void clear_bit(int nr, unsigned long *addr)
+static inline void clear_bit(unsigned long nr, unsigned long *addr)
 {
 	addr[nr / __BITS_PER_LONG] &= ~(1UL << (nr % __BITS_PER_LONG));
 }
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
