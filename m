Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C5EAC4708D
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 00:17:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4759B4B93E;
	Mon, 12 Dec 2022 19:17:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zoydE1rukCYb; Mon, 12 Dec 2022 19:17:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E10F4B941;
	Mon, 12 Dec 2022 19:17:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDC144B6C8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DZQvmoaeLJJP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 19:17:22 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2BABC4B942
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:22 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 134-20020a63008c000000b00478b9313e0eso8466516pga.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 16:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=sNSL8jiUwkIgQF+f7LKM6ExXdf/VymBG2POuUwuNLgE=;
 b=X3XOty/l01/xeN/hKkn1EpgJ33YKq3U2qtH9GiJ5/B0nOJ0DB+hLmj4UfSSjeoJtZB
 r3WCB8nZwf1VlN7+893cXq/5kUvyTwTDCZxL2nIPUKLALlzRPBZMfeoH0Ua0SHFxAPI3
 /Uv3ZxCaECDcW2eeqyV8ZVWd1hAjmNuzXaMV7oaRBjF3tNInWHVE7czGbwWdAPA4Hukj
 Vcsk24frgaF7Oql5xOx7BPdx2Nha0adydl6KmebMs/wKPMnAOgI3pEI6XB3jQLbLNFR9
 iwyZylWx8ZK0kgB1K5whCjACIx96wIRJdQeYwYX5foAv7IbCJ4PHaibz2NHGhj7JHDYg
 U68w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=sNSL8jiUwkIgQF+f7LKM6ExXdf/VymBG2POuUwuNLgE=;
 b=IwmPzA4i9/q15CL9zuO9NqHjqkue5QsoDqhlsnzGI0j0Lvlw7IRhRvpGNFuCz8g/zp
 Mfg1IB9rVqjSwHHi5RRuIBHzWXhpa/IGCBu7wOUdEmKxkmExftEgssU9KVWlUx2nMxWN
 f9+YD1jnfgL7jO4YmZFcMra2tIzLWex20fTA/RLENy2kRYz7D2LpZGAsH1lNkeqRE9jc
 JsKEsvZ7ldztp48lePuh4+i+CmZoF0T2vQssLDBGrTv1tKVRSloLl75NRKHxIBcF4gNf
 WBcaDBXgTjsT3YjsX84Y6EtgXSdK+LV7YPwPkSQajITCcTRb2SkLrvWLT86LaRg1O0IB
 2d8Q==
X-Gm-Message-State: ANoB5pmpueuckShQoWiS6wFczL42qHCcU0ceb6ezvQfL/VXArkC04DEv
 zMk9uOoBqsJYlhPEv6ef9Jw2xP6RZ88=
X-Google-Smtp-Source: AA0mqf6O/+6Xz33uYXNagfPhZfGdLb4gsoDNpenMWb9N8M3Pf/4lwZ6k3UWvF8FLs6w60jREU9TzRW9INS4=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1d98:b0:578:2fb3:b373 with SMTP id
 z24-20020a056a001d9800b005782fb3b373mr577725pfw.33.1670890641355; Mon, 12 Dec
 2022 16:17:21 -0800 (PST)
Date: Tue, 13 Dec 2022 00:16:53 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-15-seanjc@google.com>
Subject: [PATCH 14/14] KVM: selftests: Enable RSEQ test for RISC-V
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>
Cc: Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
 Tom Rix <trix@redhat.com>, llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, linux-riscv@lists.infradead.org,
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

Enable the RSEQ test for RISC-V, which according to HAVE_RSEQ is supported
by the kernel and thus should be tested.  The RSEQ test was added shortly
before RISC-V selftests support landed, i.e. was likely overlooked during
merging.

Note, the RSEQ test currently doesn't compile with clang due to an issue
in the base RSEQ test code.  Given that clang is constantly broken for KVM
selftests, enable the RSEQ test and deal with its broken clang state in a
separate commit/series.

  In file included from rseq_test.c:23:
  In file included from ./../rseq/rseq.c:33:
  In file included from ../rseq/rseq.h:97:
  ../rseq/rseq-riscv.h:657:17: error: invalid input constraint 'er' in asm
                                      [off]                       "er" (off),
                                                                ^

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/rseq_test.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index 34c3df9b4e81..3045fdf9bdf5 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -22,8 +22,6 @@
 
 #include "../rseq/rseq.c"
 
-TEST_UNSUPPORTED(riscv);
-
 /*
  * Any bug related to task migration is likely to be timing-dependent; perform
  * a large number of migrations to reduce the odds of a false negative.
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
