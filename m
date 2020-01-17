Return-Path: <SRS0=hOah=3G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B4AC33C9E
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jan 2020 22:51:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CC3B521D56
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jan 2020 22:51:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cb3k7qTY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC3B521D56
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 858104B194;
	Fri, 17 Jan 2020 17:51:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AW38Qclg0+qG; Fri, 17 Jan 2020 17:51:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D65D4B176;
	Fri, 17 Jan 2020 17:51:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39F874B15B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jan 2020 17:51:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XPgmLnzHUp-c for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jan 2020 17:51:54 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F6284B167
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jan 2020 17:51:54 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id w5so10424215wmi.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jan 2020 14:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references;
 bh=x0se5PsWKgfvt31l3mqEKGiEnfoaKNuR8Ii/GhrHCb0=;
 b=Cb3k7qTYEq+BzZTIpESkbV8UQhEjMMfgrXK6+q6jIZ6lZ/FD83b4m2Cc5+d/3Kz8rf
 +1rME0s2s4mRDHl5Uc8e2VeTze6nQn0QFxIbmZdcWA7iZeZG8G5LrqxWEV2k1STiX1g1
 PtWIQZLLsDv7v9GWMOb7Em58EV6VT2dDc9li0FMu6XCHD92GmePrLFVWHxJFPE+MumYq
 anfCtfMUSn+KPsXejDa9tlRLNVnpXkeON3+wCV+fWxzMCS0CV0kDKFGS66l3+upa36eb
 kSdzl0ESEz5aaA8Ly+POGIU8sD3ladsqW/gF5s4VGDxAWoULseYtm3PZxlXzARJDDSeQ
 oSPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=x0se5PsWKgfvt31l3mqEKGiEnfoaKNuR8Ii/GhrHCb0=;
 b=cqFDgOFYIFB17v91eaQESV5q768knMrzx6TM1QJApjG1Q7e7WvWq1mY6jRyX4P0Kew
 Vbfkdu29K7/ytkO2amAvCl7xa9bvIeeXGCLIeWDiLJgbs0r//jhgX+uMciyU1MB7lVDO
 OMrcAO4LSFXVMTiMIdUfs1HTB0By0fCQM8cIVOP1xcouFArvmzdEgsWKW5kuY6rXCR6X
 2kbmlMJQIrpXVysdMcg6HOQE+1J1WUzdZGTcP1lc7l9bmTq33LhP2OwoY8u+aJ3wJhLk
 6SmTEWrWd5xa7k0gYowYtjD81CYoLsGcmvY+S2sYaZDraG6d/VWAFSCSCEqxTTBWtMC6
 Zh6Q==
X-Gm-Message-State: APjAAAW7Z60QOh+cI5NmaqIgDk9luCFYH4KqbP1Za91h3V22NIrM67ha
 OI8myhJMVuT1X1XO4wTIU40=
X-Google-Smtp-Source: APXvYqyfbPI9bgHRb8Atz6VGPe0wOtNnReQyHgWRrgoN+moHJ+YqxTkMDq9s4T0wfpoo6b9j5ETtyA==
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr6796728wmk.124.1579301513296; 
 Fri, 17 Jan 2020 14:51:53 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
 by smtp.gmail.com with ESMTPSA id l3sm32829387wrt.29.2020.01.17.14.51.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jan 2020 14:51:52 -0800 (PST)
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v7 3/7] ARM: Disable instrumentation for some code
Date: Fri, 17 Jan 2020 14:48:35 -0800
Message-Id: <20200117224839.23531-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200117224839.23531-1-f.fainelli@gmail.com>
References: <20200117224839.23531-1-f.fainelli@gmail.com>
Cc: alexandre.belloni@bootlin.com, mhocko@suse.com, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, dhowells@redhat.com,
 yamada.masahiro@socionext.com, ryabinin.a.a@gmail.com, glider@google.com,
 kvmarm@lists.cs.columbia.edu, Florian Fainelli <f.fainelli@gmail.com>,
 corbet@lwn.net, Abbott Liu <liuwenliang@huawei.com>, daniel.lezcano@linaro.org,
 linux@armlinux.org.uk, kasan-dev@googlegroups.com,
 bcm-kernel-feedback-list@broadcom.com,
 Andrey Ryabinin <aryabinin@virtuozzo.com>, keescook@chromium.org,
 arnd@arndb.de, marc.zyngier@arm.com, andre.przywara@arm.com,
 philip@cog.systems, jinb.park7@gmail.com, tglx@linutronix.de,
 dvyukov@google.com, nico@fluxnic.net, gregkh@linuxfoundation.org,
 ard.biesheuvel@linaro.org, linux-doc@vger.kernel.org, geert@linux-m68k.org,
 rob@landley.net, pombredanne@nexb.com, akpm@linux-foundation.org,
 thgarnie@google.com, kirill.shutemov@linux.intel.com
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Andrey Ryabinin <aryabinin@virtuozzo.com>

Disable instrumentation for arch/arm/boot/compressed/* and
arch/arm/vdso/* because that code would not linkd with kernel image.

Disable instrumentation for arch/arm/kvm/hyp/*. See commit a6cdf1c08cbf
("kvm: arm64: Disable compiler instrumentation for hypervisor code") for
more details.

Disable instrumentation for arch/arm/mm/physaddr.c. See commit
ec6d06efb0ba ("arm64: Add support for CONFIG_DEBUG_VIRTUAL") for more
details.

Disable kasan check in the function unwind_pop_register because it does
not matter that kasan checks failed when unwind_pop_register read stack
memory of task.

Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Reported-by: Marc Zyngier <marc.zyngier@arm.com>
Tested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Abbott Liu <liuwenliang@huawei.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/boot/compressed/Makefile | 1 +
 arch/arm/kernel/unwind.c          | 6 +++++-
 arch/arm/mm/Makefile              | 1 +
 arch/arm/vdso/Makefile            | 2 ++
 4 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index a1e883c5e5c4..83991a0447fa 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -24,6 +24,7 @@ OBJS		+= hyp-stub.o
 endif
 
 GCOV_PROFILE		:= n
+KASAN_SANITIZE		:= n
 
 # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
 KCOV_INSTRUMENT		:= n
diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index 4574e6aea0a5..f73601416f90 100644
--- a/arch/arm/kernel/unwind.c
+++ b/arch/arm/kernel/unwind.c
@@ -236,7 +236,11 @@ static int unwind_pop_register(struct unwind_ctrl_block *ctrl,
 		if (*vsp >= (unsigned long *)ctrl->sp_high)
 			return -URC_FAILURE;
 
-	ctrl->vrs[reg] = *(*vsp)++;
+	/* Use READ_ONCE_NOCHECK here to avoid this memory access
+	 * from being tracked by KASAN.
+	 */
+	ctrl->vrs[reg] = READ_ONCE_NOCHECK(*(*vsp));
+	(*vsp)++;
 	return URC_OK;
 }
 
diff --git a/arch/arm/mm/Makefile b/arch/arm/mm/Makefile
index 7cb1699fbfc4..432302911d6e 100644
--- a/arch/arm/mm/Makefile
+++ b/arch/arm/mm/Makefile
@@ -16,6 +16,7 @@ endif
 obj-$(CONFIG_ARM_PTDUMP_CORE)	+= dump.o
 obj-$(CONFIG_ARM_PTDUMP_DEBUGFS)	+= ptdump_debugfs.o
 obj-$(CONFIG_MODULES)		+= proc-syms.o
+KASAN_SANITIZE_physaddr.o	:= n
 obj-$(CONFIG_DEBUG_VIRTUAL)	+= physaddr.o
 
 obj-$(CONFIG_ALIGNMENT_TRAP)	+= alignment.o
diff --git a/arch/arm/vdso/Makefile b/arch/arm/vdso/Makefile
index 0fda344beb0b..1f76a5ff6e49 100644
--- a/arch/arm/vdso/Makefile
+++ b/arch/arm/vdso/Makefile
@@ -42,6 +42,8 @@ GCOV_PROFILE := n
 # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
 KCOV_INSTRUMENT := n
 
+KASAN_SANITIZE := n
+
 # Force dependency
 $(obj)/vdso.o : $(obj)/vdso.so
 
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
