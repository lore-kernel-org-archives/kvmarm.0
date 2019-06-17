Return-Path: <SRS0=wAvJ=UQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50318C468B0
	for <kvmarm@archiver.kernel.org>; Mon, 17 Jun 2019 22:12:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 093F92085A
	for <kvmarm@archiver.kernel.org>; Mon, 17 Jun 2019 22:12:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HsMQvlLI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 093F92085A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3B624A4EC;
	Mon, 17 Jun 2019 18:11:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8NpAgUx1ML2L; Mon, 17 Jun 2019 18:11:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EAE54A511;
	Mon, 17 Jun 2019 18:11:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4671A4A4F3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jun 2019 18:11:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZJ1JqxuB6VDg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Jun 2019 18:11:56 -0400 (EDT)
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com
 [209.85.214.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B15C4A534
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jun 2019 18:11:56 -0400 (EDT)
Received: by mail-pl1-f195.google.com with SMTP id c14so4765754plo.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jun 2019 15:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references;
 bh=/VaXSLpZ75ORCB1zbl4hdNQEjbM9Qsyda80h69PRSPA=;
 b=HsMQvlLIq0OP3L+FNIJyK0J78hvT1oQovohPXn1CRaD6VJCWPJiDVE7KaumvwPCqPI
 Kejd+2gug/XQ+dNQmZn8ot3iXedEbK/uf+uCWp4vrklRf18r/7wuC36QXr3aC2I+yPSn
 3juO07q/f4tTVJwdeVZeS+cbKvuPVDA2UKZ3y9lNhUdSG9QP7k6tD56pNJfmIEkIqJk2
 sKiiEmKP2oqEo16lJeYQGSdpJTVjAM+5d4O9IfYuxLMdcrGY6tZdFU379hSKXMadpcUH
 BFHBZh5uBpa0YpPUJgjJR7h2ZfTw9qFlGiq/GJX4ri5ptBDGBx/oc8dwS2ohZf26tdUc
 95nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=/VaXSLpZ75ORCB1zbl4hdNQEjbM9Qsyda80h69PRSPA=;
 b=V+4Wli/WYbYxZwV+KXo4WegG6KuZMmnOaqTzojH0xkt9FptOgKzxz7BWKTL1kmjJUi
 Co4eRxoPAlo1rc7Q7fnzcuXslS5wGwp7p1fxZUCKnLJyRflDo/Q7bB80+8Vx6xc90Ywc
 Q6cZlUqyCbAAAveMva/XyVNhALtibWSZmhN1JBz7hh96jhAD5PJ5XStc8dKJR3ay4nip
 4EgEJ2gESW7cX5RZJjcOuJmVsClIZsazzVgMJsx/OTztdnTj+1Zfugv2HHOW5YeHRFsS
 A854/mn46N98fEEmss6eMevztNo8qP4DcjjCFa4LrDg4bFoVPZXnrPyo3kFY9NPvb+/B
 Lc8g==
X-Gm-Message-State: APjAAAX5LrBbfnjMJahuhTrJGFtSYZJyz5RVUurQrnB7Xu2/aS/fL3f2
 8YNGB0xryV2TXSjjjnyhEr0=
X-Google-Smtp-Source: APXvYqx55+qVC4ZdfQ7ba9JDRhraTt/q+1YyyqWzNGimZEtBjgZOCXen8WCKjalGTR2c2HmM9y+7AA==
X-Received: by 2002:a17:902:8696:: with SMTP id
 g22mr84220867plo.249.1560809515479; 
 Mon, 17 Jun 2019 15:11:55 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
 by smtp.gmail.com with ESMTPSA id s129sm12551020pfb.186.2019.06.17.15.11.53
 (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
 Mon, 17 Jun 2019 15:11:54 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6 6/6] ARM: Enable KASan for arm
Date: Mon, 17 Jun 2019 15:11:34 -0700
Message-Id: <20190617221134.9930-7-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190617221134.9930-1-f.fainelli@gmail.com>
References: <20190617221134.9930-1-f.fainelli@gmail.com>
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

This patch enable kernel address sanitizer for ARM.

Acked-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Abbott Liu <liuwenliang@huawei.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/dev-tools/kasan.rst | 4 ++--
 arch/arm/Kconfig                  | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/kasan.rst
index b72d07d70239..a9cb1feec0c1 100644
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
index 8869742a85df..5c98431ddaea 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -59,6 +59,7 @@ config ARM
 	select HAVE_ARCH_BITREVERSE if (CPU_32v7M || CPU_32v7) && !CPU_32v6
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL && !CPU_ENDIAN_BE32 && MMU
 	select HAVE_ARCH_KGDB if !CPU_ENDIAN_BE32 && MMU
+	select HAVE_ARCH_KASAN if MMU
 	select HAVE_ARCH_MMAP_RND_BITS if MMU
 	select HAVE_ARCH_SECCOMP_FILTER if AEABI && !OABI_COMPAT
 	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
