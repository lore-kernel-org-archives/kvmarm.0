Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F106C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  5 May 2022 12:08:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9842349F09;
	Thu,  5 May 2022 08:08:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sZpD-Tj-ZkG0; Thu,  5 May 2022 08:08:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E06F4B292;
	Thu,  5 May 2022 08:08:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D71C49EB2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 19:04:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EVpLrZnpEcRp for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 May 2022 19:04:54 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 523B749EB1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 19:04:54 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2eb7d137101so24496467b3.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 May 2022 16:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=qM3WeTRGf014+xltrOCJyyvSsJFoYEUo992PW7r6YCc=;
 b=pk6Cq3bg/cHBVqSK4eB0LWgjcBNLH8WIZH+5WOfTf8lUIpWsHexDwxKpZ0Lz/7NF2o
 warqHuZNmAjfWvcg23RFHD+3G/ieE0IaFpEbd3JGTr5lZ5k1cXlZ5CRprv3YpNiDa4sH
 LV1j8hpvBgm/A9KlUn3Uju+Sn8qleubxLQj/Mk+vdHehsP6uQT+OveO16m3lqej+b+yx
 cwtKqHYZEzubSgwkYvZ8InXupPkCi6ILJvlbnWjZropnpxocNOIQPW36NZukeAEQxZI0
 /R1PPJi6pvILJpybsY6eIkkWk8ac88Tzwz5Fs92v+5q5Oe3f6uKn5+YSfZGI04zoyb4p
 zIOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=qM3WeTRGf014+xltrOCJyyvSsJFoYEUo992PW7r6YCc=;
 b=YSuo6vMIfQKCdxsVt1vzE1fOVKRbwlj620eSkSVg1DkMeVvyYyyHm62+GlxA4dSJfS
 aAOJxIXZC26NAvjC76UZQx4cdbigksVopKR2msx9uaCxpWyG8OqHBwrRM2kGVevj7qhy
 srZcclhBeZVI+Y2Z29DVzXLXEGWtcSsTvKrqvORSUPp3qopPnEOrHz+tI6u3lbjdgWx4
 iaDOts7yl1V9oeGWZrsWwJ46TqA6JGmQLdr94cxixfYIwS7b+cW/YxwUO/+AT/qqd7eC
 aX9D9oLfuVfQzxQ2n+08jWQnYhxuRZgH4B01NIhoAWkSa5OUxDbUIl+13SO86yydJPlK
 fB2Q==
X-Gm-Message-State: AOAM532A/GtyAjbEEUo7/NqmwFA4aMw/F/OM37VHY28Y1vctscWMYru4
 eZla43DFduy5mHQrUjbxgBwaHgWt
X-Google-Smtp-Source: ABdhPJxzLvfsH/LRmWcBtUxYZeDOJcW/44OyvncigFxPSXagOKuuyDPvOqFUdHNOoPgqGDinqLdT1wGL1g==
X-Received: from fawn.svl.corp.google.com
 ([2620:15c:2cd:202:a90d:dc8:dc5a:2e99])
 (user=morbo job=sendgmr) by 2002:a81:34f:0:b0:2f7:bbb1:1576 with SMTP id
 76-20020a81034f000000b002f7bbb11576mr21455680ywd.45.1651705493730; Wed, 04
 May 2022 16:04:53 -0700 (PDT)
Date: Wed,  4 May 2022 16:04:46 -0700
Message-Id: <20220504230446.2253109-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [kvm-unit-tests PATCH] arm64: Check for dynamic relocs with readelf
From: Bill Wendling <morbo@google.com>
To: kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>, 
 Andrew Jones <drjones@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>, 
 Zixuan Wang <zixuanwang@google.com>, Cornelia Huck <cohuck@redhat.com>,
 kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Thu, 05 May 2022 08:08:20 -0400
Cc: Bill Wendling <morbo@google.com>
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

Clang's version of objdump doesn't recognize "setftest.elf" as a dynamic
object and produces an error stating such.

	$ llvm-objdump -R ./arm/selftest.elf
	arm/selftest.elf:	file format elf64-littleaarch64
	llvm-objdump: error: './arm/selftest.elf': not a dynamic object

This causes the ARM64 "arch_elf_check" check to fail. Using "readelf
-rW" is a better option way to get the same information and produces the
same information in both binutils and LLVM.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 arm/Makefile.arm64 | 6 +++---
 configure          | 2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 6feac76f895f..42e18e771b3b 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -14,9 +14,9 @@ mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
 CFLAGS += $(mno_outline_atomics)
 
 define arch_elf_check =
-	$(if $(shell ! $(OBJDUMP) -R $(1) >&/dev/null && echo "nok"),
-		$(error $(shell $(OBJDUMP) -R $(1) 2>&1)))
-	$(if $(shell $(OBJDUMP) -R $(1) | grep R_ | grep -v R_AARCH64_RELATIVE),
+	$(if $(shell ! $(READELF) -rW $(1) >&/dev/null && echo "nok"),
+		$(error $(shell $(READELF) -rW $(1) 2>&1)))
+	$(if $(shell $(READELF) -rW $(1) | grep R_ | grep -v R_AARCH64_RELATIVE),
 		$(error $(1) has unsupported reloc types))
 endef
 
diff --git a/configure b/configure
index 86c3095a245a..23085da7dcc5 100755
--- a/configure
+++ b/configure
@@ -12,6 +12,7 @@ cflags=
 ld=ld
 objcopy=objcopy
 objdump=objdump
+readelf=readelf
 ar=ar
 addr2line=addr2line
 arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
@@ -372,6 +373,7 @@ CFLAGS=$cflags
 LD=$cross_prefix$ld
 OBJCOPY=$cross_prefix$objcopy
 OBJDUMP=$cross_prefix$objdump
+READELF=$cross_prefix$readelf
 AR=$cross_prefix$ar
 ADDR2LINE=$cross_prefix$addr2line
 TEST_DIR=$testdir
-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
