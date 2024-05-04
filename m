Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2053771C
	for <kvmarm@lists.linux.dev>; Sat,  4 May 2024 12:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825844; cv=none; b=giF6Q9toFll/M4e1AEbEfpmCcyt67thQ0FLRhvPsDP2bMy9sABxC1aQ7HOG51j7oNJaO1Ekekq1kuL1r1lpphYJjb6LGgy9wbFQtXrGejrSatm41JdZmKbVnr/CTjH23Ih4k/K4z0jXm12FAakLP/G6Ef3fYrwC/J97BL9O3u/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825844; c=relaxed/simple;
	bh=jsNTji5NnHKuzmZV80n+3e06Y8Wp0HEd+qIk+38OFKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Evc7+AgXFgovN0Yun9kiBTIOm2u6YHDrzvvhA+6tFChFVLXRlsSmIdQGsKPpGEWukHcEe5Ns4LcJh0LRS1qLvKZbUvCwa1OLHN8eeYqChd4JetMExY7c5U7ghVHmyjt0qOJoRMb8BuIAxmUNdNRl1b7i2kuSqPwY9WGUHC01ExM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U5iGME3c; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U5iGME3c"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6f457853950so373182b3a.0
        for <kvmarm@lists.linux.dev>; Sat, 04 May 2024 05:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825843; x=1715430643; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5e7S6CmFvKeffkGPyTCOL8jP7a0oCwEqBFa0CpbZAAo=;
        b=U5iGME3cig1m0RgBhLRxFBpiXDzki33zpNxnyiw/atUeofq/6WbdCa8cV1n/0Ad3ot
         LFsu0FuUFHKXM0NVFUoQcGu+VbJnF6aZbYmne7ePPdhoLQHaCdmweV4HLloY8kIQNAza
         Zc2NQxmW0nFNBCvPKVYltX65F7A4JoscgUAUpSGUuASCLN+9C24hO2sFHokVlRUZmg0y
         CZVAsZ78hnAkcpseYsb1SCQ+Xjn+qzDZlj6RsJ2eQ2NdikIyPk3SR+rEeg2TvVXSoHwQ
         d5fhugnN0JKuSO7aynhMQz9gSdrFg35RsM5Nz9yXfeNlTEZtpUluZW7X2ivnmd1/y1Cw
         sitQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825843; x=1715430643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5e7S6CmFvKeffkGPyTCOL8jP7a0oCwEqBFa0CpbZAAo=;
        b=dah477RuBEW87lStSVM/MkBwa0oPeYpzmurclqpyGHDG3rQD1CyrXtkA9rjlqCXBoq
         KroLBppLH/2y3dvdZlKPSPqh8FGZXOYXmZUdio67NgtYb0D+1j9HGY5uhCyzBaFBGqP1
         Iy3sCRCiqIQ0k1BsEdb9tuFC0gcnpVqv9DXFEyjd8F/dLVRFHAwfTn5x0hkIFti18aO9
         SHvREkOMPVFqiucI9BvwhsvlCduQsrVnEx0Ip9BDXybtKCGqv5XpUY6eEVSFL7Mf8oQq
         RrqANJ7o16HuCwr6rQ2IjYuGjGJOL4Jk4Z0M1t/O5xXNxZ5LTexyvXh8lYQDvf2ZpqVp
         2/Bw==
X-Forwarded-Encrypted: i=1; AJvYcCWa+f9nnNj004Sfv4dD76YMcjSHdyKc4yqIO97SZbvunMgLsyp3VZ3kLvdw/FBdakcspwdznHRyy52T5AS4Hq082rbbatdS
X-Gm-Message-State: AOJu0YyieQ27gDbS20SgpKsm+c0P/v716ZzdGxNI1Yyp26CduC144mnT
	byzIMJ1buaXgjFUMuo5WjWkBzaHPc3/vkFEDH3QTKB5zfxk7/BNc
X-Google-Smtp-Source: AGHT+IFPZkfPU8Egb2mh6EBzGgW9QChyXJexPKHvEKB5uBRSLxU0nzgY3U6aLmK8CozI1eiDyMOazA==
X-Received: by 2002:a05:6a20:8420:b0:1a3:b187:f261 with SMTP id c32-20020a056a20842000b001a3b187f261mr12634372pzd.29.1714825842756;
        Sat, 04 May 2024 05:30:42 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:30:42 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH v9 28/31] configure: Make arch_libdir a first-class entity
Date: Sat,  4 May 2024 22:28:34 +1000
Message-ID: <20240504122841.1177683-29-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240504122841.1177683-1-npiggin@gmail.com>
References: <20240504122841.1177683-1-npiggin@gmail.com>
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
index 5b7998b79..7fe93dfd8 100644
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
index d744ec4dc..2b788d0c8 100755
--- a/configure
+++ b/configure
@@ -216,7 +216,6 @@ fi
 arch_name=$arch
 [ "$arch" = "aarch64" ] && arch="arm64"
 [ "$arch_name" = "arm64" ] && arch_name="aarch64"
-arch_libdir=$arch
 
 if [ "$arch" = "riscv" ]; then
     echo "riscv32 or riscv64 must be specified"
@@ -284,8 +283,10 @@ fi
 
 if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
     testdir=x86
+    arch_libdir=x86
 elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     testdir=arm
+    arch_libdir=$arch
     if [ "$target" = "qemu" ]; then
         arm_uart_early_addr=0x09000000
     elif [ "$target" = "kvmtool" ]; then
@@ -334,6 +335,7 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     fi
 elif [ "$arch" = "ppc64" ]; then
     testdir=powerpc
+    arch_libdir=ppc64
     firmware="$testdir/boot_rom.bin"
     if [ "$endian" != "little" ] && [ "$endian" != "big" ]; then
         echo "You must provide endianness (big or little)!"
@@ -344,6 +346,7 @@ elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
     arch_libdir=riscv
 elif [ "$arch" = "s390x" ]; then
     testdir=s390x
+    arch_libdir=s390x
 else
     echo "arch $arch is not supported!"
     arch=
@@ -353,6 +356,10 @@ if [ ! -d "$srcdir/$testdir" ]; then
     echo "$srcdir/$testdir does not exist!"
     exit 1
 fi
+if [ ! -d "$srcdir/lib/$arch_libdir" ]; then
+    echo "$srcdir/lib/$arch_libdir does not exist!"
+    exit 1
+fi
 
 if [ "$efi" = "y" ] && [ -f "$srcdir/$testdir/efi/run" ]; then
     ln -fs "$srcdir/$testdir/efi/run" $testdir-run
@@ -415,10 +422,11 @@ fi
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

