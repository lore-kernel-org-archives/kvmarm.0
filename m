Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550B95F87B
	for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 10:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942488; cv=none; b=Frqb7ah0XM6IH54wNgdY0zSF7W19g+P9p3ildx+3tjlcOlOhmXz5nimElvv/hQHppH4yMsOyuZ+nBEQMswQ5lfFAaToVZEIyGYNxXfcX6gOeRD6t+WnBMbdM1MZAQK+dwgDmPZh8wl+/sT5QsU2gvhi22G/VKHUFh03pPzIaSGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942488; c=relaxed/simple;
	bh=8udX0cgp93MszWyZ03GEI7NLIrdSXlIepkA+ThFw9Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i7NV0OIOcGKLYwdgU188EpcfCi+Q0VjLqHDablTuRVN3DCh1VwxZ1BkH/kvCOkX6SkHreC0zvyE1rnlKLhGs9iyM3V9P2kZJ/x8KlQWTsVsojCYUJKy7RXcnBE2H6vT2/dBKvYS1O2zxUm5OBDZrX5UfACaqBY2oC1+evoNazao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a68P2qkh; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a68P2qkh"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6e48eef8be5so1842784b3a.1
        for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 02:14:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942485; x=1709547285; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A05If4ES6byzPc96w4d0O/4phtiePSkwA25rkb54AlQ=;
        b=a68P2qkhCoixdLpJunitvedQ0elyDFZ99LziKoOZEWK+gxSymLZH39R/hY9potVunQ
         OC5mcJc2Jf972tvTuQMz1tfSc4U245dKu5ws+T3sfPaXwugON1p/cmdu5IctXXnBVTp7
         6+lq45z7opZXT++GuHiyFUoJU2h9lBv74UIHLc+AhNqVkbMQen0eshoHqzPbE9ySaD8W
         eb9cBsywCPizxdjEUcEjX6UlmHGJ2ChOAAe1W/MfAEE91l3Nu96HyOD1Gdr7M6EnLhV/
         dG9PgLorYWFbZBQtl+n3vees4+vDPwEMtdX2C9aM8B3S7lqmP/kbfUEFWMSsi+gj7WdK
         HHTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942485; x=1709547285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A05If4ES6byzPc96w4d0O/4phtiePSkwA25rkb54AlQ=;
        b=at4QpsWj/1DPxU4P2VkVqzkAjS7QQARcLh5dd0IXCqgFpBrctmjUGStYLwHgU/0kS7
         M+Qqsp8rVn7WyPoitERoyA/MXWW357OlvsUDIF5POCoqN7JzSxBaoeVd+faJQbuAkkYX
         ZK7neVx/SLh5BczY2oTs4KCTSyk41b402YQ+Eb0nTSKvxueaINyn+xkYXfuqD+TgM8oo
         Hf7I0SZ52DwhaVxCM3uH6t8olwX18Wp4c1XNaPSfRjPft4U+vXC23LRMVa6tfyOdPW/V
         vgEMG130NZbeHp593B5QaFzGUr1XXhLW8htwrNRobDcdDdUQuGTDCiKMdbFYuvyLfwtt
         Uilg==
X-Forwarded-Encrypted: i=1; AJvYcCWcDcRcmuYKyGPMvNB+2psVKi+R65WBkRa5B3ZgdulHz5KrRZVnhbjtxQOOB39DLtm3QOzo6MddfUOkfYY/t40Cg15HLSZ4
X-Gm-Message-State: AOJu0YzI7GBDtJ51SnIUQL3j82FlHoP3bQhnPOnqEbMI+BGIDKFWl7R6
	ZzL17ykMxXvBpRkRglC6ZWrE1MXsdihuxAPFR2EARkqzIK6EjJvT
X-Google-Smtp-Source: AGHT+IFkY1GIJLB6yWYGNglDakT3fA113fKaZeKyFRaTRQxO85354Z4DQShb9ESUASscSl7tU+qTAg==
X-Received: by 2002:a62:8497:0:b0:6e4:4a26:1cbd with SMTP id k145-20020a628497000000b006e44a261cbdmr6206179pfd.2.1708942485627;
        Mon, 26 Feb 2024 02:14:45 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:14:45 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH 30/32] configure: Make arch_libdir a first-class entity
Date: Mon, 26 Feb 2024 20:12:16 +1000
Message-ID: <20240226101218.1472843-31-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226101218.1472843-1-npiggin@gmail.com>
References: <20240226101218.1472843-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

arch_libdir was brought in to improve the heuristic determination of
the lib/ directory based on arch and testdir names, but it did not
entirely clean that mess up.

Remove the arch_libdir->arch->testdir heuristic and just require
everybody sets arch_libdir correctly. Fail if the lib/arch or
lib/arch/asm directories can not be found.

Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Laurent Vivier <lvivier@redhat.com>
Cc: Nico Böhr <nrb@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: kvmarm@lists.linux.dev
Cc: kvm-riscv@lists.infradead.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 Makefile  |  2 +-
 configure | 18 +++++++++++++-----
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index 4f35fffc6..4e0f54543 100644
--- a/Makefile
+++ b/Makefile
@@ -10,7 +10,7 @@ include config.mak
 VPATH = $(SRCDIR)
 
 libdirs-get = $(shell [ -d "lib/$(1)" ] && echo "lib/$(1) lib/$(1)/asm")
-ARCH_LIBDIRS := $(call libdirs-get,$(ARCH_LIBDIR)) $(call libdirs-get,$(TEST_DIR))
+ARCH_LIBDIRS := $(call libdirs-get,$(ARCH_LIBDIR))
 OBJDIRS := $(ARCH_LIBDIRS)
 
 DESTDIR := $(PREFIX)/share/kvm-unit-tests/
diff --git a/configure b/configure
index ae522c556..8c0e3506f 100755
--- a/configure
+++ b/configure
@@ -199,7 +199,6 @@ fi
 arch_name=$arch
 [ "$arch" = "aarch64" ] && arch="arm64"
 [ "$arch_name" = "arm64" ] && arch_name="aarch64"
-arch_libdir=$arch
 
 if [ "$arch" = "riscv" ]; then
     echo "riscv32 or riscv64 must be specified"
@@ -264,8 +263,10 @@ fi
 
 if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
     testdir=x86
+    arch_libdir=x86
 elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     testdir=arm
+    arch_libdir=$arch
     if [ "$target" = "qemu" ]; then
         arm_uart_early_addr=0x09000000
     elif [ "$target" = "kvmtool" ]; then
@@ -314,6 +315,7 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     fi
 elif [ "$arch" = "ppc64" ]; then
     testdir=powerpc
+    arch_libdir=ppc64
     firmware="$testdir/boot_rom.bin"
     if [ "$endian" != "little" ] && [ "$endian" != "big" ]; then
         echo "You must provide endianness (big or little)!"
@@ -324,6 +326,7 @@ elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
     arch_libdir=riscv
 elif [ "$arch" = "s390x" ]; then
     testdir=s390x
+    arch_libdir=s390x
 else
     echo "arch $arch is not supported!"
     arch=
@@ -333,6 +336,10 @@ if [ ! -d "$srcdir/$testdir" ]; then
     echo "$srcdir/$testdir does not exist!"
     exit 1
 fi
+if [ ! -d "$srcdir/lib/$arch_libdir" ]; then
+    echo "$srcdir/lib/$arch_libdir does not exist!"
+    exit 1
+fi
 
 if [ "$efi" = "y" ] && [ -f "$srcdir/$testdir/efi/run" ]; then
     ln -fs "$srcdir/$testdir/efi/run" $testdir-run
@@ -395,10 +402,11 @@ fi
 # link lib/asm for the architecture
 rm -f lib/asm
 asm="asm-generic"
-if [ -d "$srcdir/lib/$arch/asm" ]; then
-	asm="$srcdir/lib/$arch/asm"
-elif [ -d "$srcdir/lib/$testdir/asm" ]; then
-	asm="$srcdir/lib/$testdir/asm"
+if [ -d "$srcdir/lib/$arch_libdir/asm" ]; then
+    asm="$srcdir/lib/$arch_libdir/asm"
+else
+    echo "$srcdir/lib/$arch_libdir/asm does not exist"
+    exit 1
 fi
 mkdir -p lib
 ln -sf "$asm" lib/asm
-- 
2.42.0

