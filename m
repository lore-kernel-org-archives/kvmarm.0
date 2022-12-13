Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD50C4708D
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 00:17:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDE5A4B938;
	Mon, 12 Dec 2022 19:17:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XGsQ7GtEHVsn; Mon, 12 Dec 2022 19:17:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE8F74B975;
	Mon, 12 Dec 2022 19:17:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03B7F4B959
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q3J6i-P318fI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 19:17:14 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 907904B94F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:12 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 r7-20020a25c107000000b006ff55ac0ee7so14780763ybf.15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 16:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=cl2hz2Xl0INQZgi0/FdsZaZQh2aAYVKtm1GOrQ0BNuA=;
 b=qtuKL0chntBw8WmvJab1K7kXx56vDxcM9Lz3Ed1k66okiPfskMIfRbRPhkpYl+zGcP
 mkp5v4Xa7xKSkNVTIU5I70auAIKnC0QeyzQFPgSFF7WWS+tDOctc4tDRG/YuUfhAOX4B
 t8ijgFRQsDMni3C+Sb2bEyRHhRoH07jF7n9YtSS4rtkdGTPQ9kigYoTmO1aL/fn/jywD
 tNkEscjQPz0T4cqIQReHVuDH+sIuUu9AxFpVApk///ScvT5q9609eMJOQx/F3P0B5FVO
 7yKU4XPqBRk3J8E/xxsYrzOoSaTZobfNQITHw9pavl02O+kx8NUkPc5JhtHd2UP0Zuz7
 2pbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=cl2hz2Xl0INQZgi0/FdsZaZQh2aAYVKtm1GOrQ0BNuA=;
 b=KDR8ClTrhilUVxQycfVbP3wtYV8JW7gfi7Yd1jBYyOL0C4EjRRvJhd0btTrf9AAPkS
 1Mi4n6dMPj3zniIrzSCO1LZAN7L/dJtaW+NuGTqTb19KZdSkcjeGX40iDBl+cH7diUC8
 hXm/Y0p621ns0C+D0zWkmuK16AN/GzIiQ8eweL0NGk069x/KzD/cI7+H6QR/7SlftbKq
 NUdVg9xIDnyb/6vGcK7OnJbQdG9MEazsjlH3+ZGxs4TJZ+Y8yInZuZeRay9aapINwKd7
 7V2/x27YAC3cBl5yjG4IlZZej8OfLhOEIgpeWDDjLT9K46lZY/gyXcirUx5n9IghKHZM
 tmuw==
X-Gm-Message-State: ANoB5pnTclFFPNNyY8qZK+479wH0/awqjnixQLdh4PTn32EXbjmeOX+E
 j8g0wUsMLVosrEDP2vJIX1Mjt/SfxwQ=
X-Google-Smtp-Source: AA0mqf5PAbtMk1FlbJUnxb446gjQZtpZQwbl0k154cV60HQy1+WGqGPPTBe02uIxBcfNlX5eyXkFbuPBOrQ=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3303:0:b0:6f0:be3f:26f0 with SMTP id
 z3-20020a253303000000b006f0be3f26f0mr67005598ybz.512.1670890632080; Mon, 12
 Dec 2022 16:17:12 -0800 (PST)
Date: Tue, 13 Dec 2022 00:16:48 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-10-seanjc@google.com>
Subject: [PATCH 09/14] KVM: selftests: Explicitly disable builtins for mem*()
 overrides
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

Explicitly disable the compiler's builtin memcmp(), memcpy(), and
memset().  Because only lib/string_override.c is built with -ffreestanding,
the compiler reserves the right to do what it wants and can try to link the
non-freestanding code to its own crud.

  /usr/bin/x86_64-linux-gnu-ld: /lib/x86_64-linux-gnu/libc.a(memcmp.o): in function `memcmp_ifunc':
  (.text+0x0): multiple definition of `memcmp'; tools/testing/selftests/kvm/lib/string_override.o:
  tools/testing/selftests/kvm/lib/string_override.c:15: first defined here
  clang: error: linker command failed with exit code 1 (use -v to see invocation)

Fixes: 6b6f71484bf4 ("KVM: selftests: Implement memcmp(), memcpy(), and memset() for guest use")
Reported-by: Aaron Lewis <aaronlewis@google.com>
Reported-by: Raghavendra Rao Ananta <rananta@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a6050dcc381a..6594ed51eeea 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -191,6 +191,7 @@ else
 LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
 endif
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
+	-fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
 	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
 	-I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
