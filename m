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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE051C33CB8
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jan 2020 22:52:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9755821D7D
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jan 2020 22:52:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ITxORkbK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9755821D7D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51FA94B176;
	Fri, 17 Jan 2020 17:52:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nAGeePCcO9Xn; Fri, 17 Jan 2020 17:52:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B2F24B189;
	Fri, 17 Jan 2020 17:52:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BB944B167
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jan 2020 17:52:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5ey-G3acONOV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jan 2020 17:52:23 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE7C74B169
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jan 2020 17:52:22 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id q6so24108060wro.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jan 2020 14:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references;
 bh=kkVH3WV4mS0X3+3FT56qa2DP27GgNwjhnKPZdjR/cEg=;
 b=ITxORkbK/eZIaQFygF9sIZY3a+lP6APCWVuUR2qCA8ArF56Rf0lBuPnE+xI3e0amgN
 ciN+GBjyNVKgHqzSGXJFbp9JOTAEqA9RWPxRMK5h9N+vLuimpulhOlgLPpaOCIy8H4Ve
 a0pGuqzVIpDDfMESsUZyewaDYvKc2y6CVlSZKkuF/ln0NYlPArYMZzdBuaBoOJ/6/2M2
 4xyRE8OUJsK6IEetVrp+jzk4Px2/zkMqE3nHq9oQxbWMQeQAFuiXJD0eN/oMzFeS+8bC
 5D7/f8b0pfF/pBjt1WlJVM3c5rSFEE/jdJqH++qw/yWw7Qn/ATn+y94BMOvffktWheFb
 xriw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=kkVH3WV4mS0X3+3FT56qa2DP27GgNwjhnKPZdjR/cEg=;
 b=Fy63FyPaJRVKY/DCPv5Z545BfYYxx1M2RiGDcyjgXcUabUlfj5HE3CQwL1QAOT5BWx
 93cuLbQ7Gn7fVLq9sUYZSZe9eofMLVJWPB8a1cvScY6bmzLR8o3hsxsXdxCL30zwzqR7
 T2BG4tdPgX82UZ0a9vTaDJJqGkwUxHFBW76HZ41NcB8CVxaoc2w4fN1oiAXFkVxW0FaG
 0JHJsMfRc/f9Q/AgXEzNx5OjoDC0J7DTwHrr0q5uyrKHjvNrfoKotlepey2U5MGRwEhm
 OTtJVWldft/BpwzLZNwpKuK8VFuVV8Q283PUdhZNKKrymqfOsSbyWmkoYKMVrVIlxiRO
 l3xQ==
X-Gm-Message-State: APjAAAUfRezaydW6gtiM2FpQCoEfHcxD5Izps03isQIfdxEUuDuvcX0N
 9UElIPnVeLvwNXyRLKxwFxo=
X-Google-Smtp-Source: APXvYqxO45pdsD9bw7k1ZN/eHmJMDDLMtgzyredpWmd19F4mOCrBwdTMZQFVNqDl2BHgwDko/5ETWA==
X-Received: by 2002:a5d:4ed0:: with SMTP id s16mr5523773wrv.144.1579301542065; 
 Fri, 17 Jan 2020 14:52:22 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
 by smtp.gmail.com with ESMTPSA id l3sm32829387wrt.29.2020.01.17.14.52.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jan 2020 14:52:21 -0800 (PST)
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v7 7/7] ARM: Enable KASan for ARM
Date: Fri, 17 Jan 2020 14:48:39 -0800
Message-Id: <20200117224839.23531-8-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200117224839.23531-1-f.fainelli@gmail.com>
References: <20200117224839.23531-1-f.fainelli@gmail.com>
Cc: alexandre.belloni@bootlin.com, mhocko@suse.com, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, dhowells@redhat.com,
 yamada.masahiro@socionext.com, ryabinin.a.a@gmail.com, glider@google.com,
 kvmarm@lists.cs.columbia.edu, Florian Fainelli <f.fainelli@gmail.com>,
 corbet@lwn.net, Abbott Liu <liuwenliang@huawei.com>, daniel.lezcano@linaro.org,
 linux@armlinux.org.uk, kasan-dev@googlegroups.com,
 bcm-kernel-feedback-list@broadcom.com, geert@linux-m68k.org,
 keescook@chromium.org, arnd@arndb.de, marc.zyngier@arm.com,
 andre.przywara@arm.com, philip@cog.systems, jinb.park7@gmail.com,
 tglx@linutronix.de, dvyukov@google.com, nico@fluxnic.net,
 gregkh@linuxfoundation.org, ard.biesheuvel@linaro.org,
 linux-doc@vger.kernel.org, thgarnie@google.com, rob@landley.net,
 pombredanne@nexb.com, akpm@linux-foundation.org,
 Andrey Ryabinin <ryabinin@virtuozzo.com>, kirill.shutemov@linux.intel.com
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

From: Andrey Ryabinin <ryabinin@virtuozzo.com>

This patch enables the kernel address sanitizer for ARM. XIP_KERNEL has
not been tested and is therefore not allowed.

Acked-by: Dmitry Vyukov <dvyukov@google.com>
Tested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Abbott Liu <liuwenliang@huawei.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/dev-tools/kasan.rst     | 4 ++--
 arch/arm/Kconfig                      | 9 +++++++++
 arch/arm/boot/compressed/Makefile     | 1 +
 drivers/firmware/efi/libstub/Makefile | 3 ++-
 4 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/kasan.rst
index e4d66e7c50de..6acd949989c3 100644
--- a/Documentation/dev-tools/kasan.rst
+++ b/Documentation/dev-tools/kasan.rst
@@ -21,8 +21,8 @@ global variables yet.
 
 Tag-based KASAN is only supported in Clang and requires version 7.0.0 or later.
 
-Currently generic KASAN is supported for the x86_64, arm64, xtensa and s390
-architectures, and tag-based KASAN is supported only for arm64.
+Currently generic KASAN is supported for the x86_64, arm, arm64, xtensa and
+s390 architectures, and tag-based KASAN is supported only for arm64.
 
 Usage
 -----
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 96dab76da3b3..70a7eb50984e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -65,6 +65,7 @@ config ARM
 	select HAVE_ARCH_BITREVERSE if (CPU_32v7M || CPU_32v7) && !CPU_32v6
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL && !CPU_ENDIAN_BE32 && MMU
 	select HAVE_ARCH_KGDB if !CPU_ENDIAN_BE32 && MMU
+	select HAVE_ARCH_KASAN if MMU && !XIP_KERNEL
 	select HAVE_ARCH_MMAP_RND_BITS if MMU
 	select HAVE_ARCH_SECCOMP_FILTER if AEABI && !OABI_COMPAT
 	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
@@ -212,6 +213,14 @@ config ARCH_MAY_HAVE_PC_FDC
 config ZONE_DMA
 	bool
 
+config KASAN_SHADOW_OFFSET
+	hex
+	depends on KASAN
+	default 0x1f000000 if PAGE_OFFSET=0x40000000
+	default 0x5f000000 if PAGE_OFFSET=0x80000000
+	default 0x9f000000 if PAGE_OFFSET=0xC0000000
+	default 0xffffffff
+
 config ARCH_SUPPORTS_UPROBES
 	def_bool y
 
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 83991a0447fa..efda24b00a44 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -25,6 +25,7 @@ endif
 
 GCOV_PROFILE		:= n
 KASAN_SANITIZE		:= n
+CFLAGS_KERNEL		+= -D__SANITIZE_ADDRESS__
 
 # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
 KCOV_INSTRUMENT		:= n
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index c35f893897e1..c8b36824189b 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -20,7 +20,8 @@ cflags-$(CONFIG_ARM64)		:= $(subst $(CC_FLAGS_FTRACE),,$(KBUILD_CFLAGS)) \
 				   -fpie $(DISABLE_STACKLEAK_PLUGIN)
 cflags-$(CONFIG_ARM)		:= $(subst $(CC_FLAGS_FTRACE),,$(KBUILD_CFLAGS)) \
 				   -fno-builtin -fpic \
-				   $(call cc-option,-mno-single-pic-base)
+				   $(call cc-option,-mno-single-pic-base) \
+				   -D__SANITIZE_ADDRESS__
 
 cflags-$(CONFIG_EFI_ARMSTUB)	+= -I$(srctree)/scripts/dtc/libfdt
 
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
