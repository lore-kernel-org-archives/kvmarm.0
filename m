Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAD715F304
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 08:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306289; cv=none; b=I1KICNTOpdDWjvvF9XZuXA5gQrCClrHfMKVLNLEBDmWE0wKbY9blcmoC0pMJPvmRA0SK0G00J4j2ZKd2EnlbCotFQw6Yhr1ivm6V9MM/qq3VEm4Ex1Z9lSxlHneib1i3KV8kSzTkXaovbgcqYVTQAK/EPK/L5FvrDcvydqokqlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306289; c=relaxed/simple;
	bh=7yO6yPDHGesSmeOkN/fR8ci49hsn9kz43K4p5e/8WBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NPyp+ab04/PLA2TuCdlxf5tfmbkHmYsytSzVlFrSaxgNbv1avFXRE5DPiOce7ETg9OonSymviWyxkMACrMldioKcbTy7TXDiDVPXKHrOS7CHBexJ2aWYlpDIJKuwrOU4MPLOHHxR/o7X/xRXUKU3gQGVo/2BLupRC00KtYqwBy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O2Jzf5Zi; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O2Jzf5Zi"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-368c13003eeso8575625ab.0
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 01:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306287; x=1712911087; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sGCyPgl3I2RhYB72u4qf5QL0i6/5w7xwNKgPUqw6zXE=;
        b=O2Jzf5Zi8+cwLgzF98c/E7ThlRHUowFTi1A+clHMzDdfQ5b7zJq+cXg5DwJiN7hpZO
         48t9u/sqU8Fu2nxJypKQPft6lq+gtTauknBfzjxD1wtUqMKEd1wIhJmt4Zdk2se29S6s
         0WZEr+6gwJAQJReugDhFcpJ+LCTrZQhJhnOZXHGdBLBMvvyMzATKknef41cM+8/Tvh6L
         TPPH3vGKqpQclvhpG4m8iOUvZm+N4hdrTM4wOhwvx1YHO/WmrPgpN+Kwl8rnnnmWrXSc
         e/a4AtS6kBD+KTMgjRbZvm5a5HpMbDahiCUazX9SrdIanhDfoxSDjERdhrChNWnToyRf
         efag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306287; x=1712911087;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sGCyPgl3I2RhYB72u4qf5QL0i6/5w7xwNKgPUqw6zXE=;
        b=iYcP3CYIgBnezZV7BGNkhYArIaYhaFWfA81M5wVpc+6pCoygla4uHfpW9XIal2LIaB
         Id8CPDotXJ20/E0QOVh/WY6iffB8Q/e03NxZY/fN05mmqji3vuFsc2O4OCuV+omGURp9
         1g/6oHr/KQgklmvaANpfgsXBrT1rI0TgSBV0u3Mng1YgMZ8or8URk7Yy73Ga4s7V4yNk
         zkfw8z/qt3CVX+m0U4x7DyDr57uA4lZQhYI3p3FoNnZ9kPwPwDWTXOlnWpAVfnNjworW
         50GIf8jkEJ4LRqia1r7EnJQ05u63DF0AiP8uvLo82BLZXQTNUKnPuna/MMoB4dvtWFbP
         lQ0A==
X-Forwarded-Encrypted: i=1; AJvYcCVxZSc5MG8o+LhXPsQ8zmEXJZp2vrCrKey9cP+wiKdrXNSB0J7gnF9UMA7ioVGfweTRspGRvebudhSJb6ETidMdqPg7kSaS
X-Gm-Message-State: AOJu0YysKeRfH3Bve/L9Bj8/oSRkVLyjsq4DigRhKQl+i+UWs1iXBiIz
	/+VYrxy6sKgugSQOEH2dKlLOfmhrP9h+bMY2gv1F71Ohwr7oGOTK
X-Google-Smtp-Source: AGHT+IEXdRMMtpxkTXLY1QR9+bDc6JrDHOZHEaNaHrlHrdrhRUuA/h4JbDJfUfZ+VZMIfoOk2EDb4A==
X-Received: by 2002:a05:6e02:219b:b0:368:a856:aa20 with SMTP id j27-20020a056e02219b00b00368a856aa20mr661890ila.20.1712306287401;
        Fri, 05 Apr 2024 01:38:07 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:38:07 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: [kvm-unit-tests PATCH v8 33/35] configure: Make arch_libdir a first-class entity
Date: Fri,  5 Apr 2024 18:35:34 +1000
Message-ID: <20240405083539.374995-34-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405083539.374995-1-npiggin@gmail.com>
References: <20240405083539.374995-1-npiggin@gmail.com>
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
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
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
index e19ba6f0c..a1308db8e 100755
--- a/configure
+++ b/configure
@@ -216,7 +216,6 @@ fi
 arch_name=$arch
 [ "$arch" = "aarch64" ] && arch="arm64"
 [ "$arch_name" = "arm64" ] && arch_name="aarch64"
-arch_libdir=$arch
 
 if [ "$arch" = "riscv" ]; then
     echo "riscv32 or riscv64 must be specified"
@@ -286,8 +285,10 @@ fi
 
 if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
     testdir=x86
+    arch_libdir=x86
 elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     testdir=arm
+    arch_libdir=$arch
     if [ "$target" = "qemu" ]; then
         arm_uart_early_addr=0x09000000
     elif [ "$target" = "kvmtool" ]; then
@@ -336,6 +337,7 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     fi
 elif [ "$arch" = "ppc64" ]; then
     testdir=powerpc
+    arch_libdir=ppc64
     firmware="$testdir/boot_rom.bin"
     if [ "$endian" != "little" ] && [ "$endian" != "big" ]; then
         echo "You must provide endianness (big or little)!"
@@ -346,6 +348,7 @@ elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
     arch_libdir=riscv
 elif [ "$arch" = "s390x" ]; then
     testdir=s390x
+    arch_libdir=s390x
 else
     echo "arch $arch is not supported!"
     arch=
@@ -355,6 +358,10 @@ if [ ! -d "$srcdir/$testdir" ]; then
     echo "$srcdir/$testdir does not exist!"
     exit 1
 fi
+if [ ! -d "$srcdir/lib/$arch_libdir" ]; then
+    echo "$srcdir/lib/$arch_libdir does not exist!"
+    exit 1
+fi
 
 if [ "$efi" = "y" ] && [ -f "$srcdir/$testdir/efi/run" ]; then
     ln -fs "$srcdir/$testdir/efi/run" $testdir-run
@@ -417,10 +424,11 @@ fi
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
2.43.0

