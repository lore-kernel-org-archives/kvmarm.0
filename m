Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8575D38FA3
	for <kvmarm@lists.linux.dev>; Wed, 12 Jun 2024 05:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718169849; cv=none; b=fggKk66knOqfqwvEdKfPOBwEPax9NYtsYCxlOXRi6W//8w/RAImnWvxp5YFPduGyDMtC/OuloJ73QOnnJHBlPSI/D39hvbIoQQz+LSOpVzddKzsr458VxWa95hrutM15mw3c7zOfcA3FsAcVOzJLKqGVNzrjD2AP5CMJljYcCYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718169849; c=relaxed/simple;
	bh=RymY7PnAv6b7tpTyJmoUZ0kfNOhoGlBV1AlNrgFlVCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K046YaYIAF9KCq7IG/0N4mh5SUQgUXE62iJ3nwfAHB4CNiYLM5NRMrab4rvOrjPdHuM55KhauVuCb20Rgmtswe5+3/9Q00dBfRV8xT16DYp726MhA6ti9i9SlrPsXqgWc5WZg4slSeYwA1mnUtJlFBmIzU4+v1xtB7xu8e/q+k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jXNSu1vh; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jXNSu1vh"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1f480624d10so56299025ad.1
        for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 22:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718169847; x=1718774647; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cQuI8YGQgLmsUNQvvWuFnLsfcid8kBB0k+CZ86TDvAk=;
        b=jXNSu1vhnj13e8lgFUrXONeT2qoof1YSK5WPO7//6L5eIUwko3JtCVfURl58vbE/Be
         JckSKkIrljgCieI8DUruIpxgoHYqunfL3nac3Xz8Kf2TRRs2fHVPI/MVY6tHTMBHIbNC
         VVb5MMWlDBEoFlFZdqCVdXHWkC9mr3hEEMAKOucpNs6v89bqhc00ir5XPYtEJsGcPsx/
         hXWcB7WyLJ9L/zT3EPwPDyCZpKRsU0oWji4mgLtGAmAtFumkyNUt+UroDFS8PcQ7bgX8
         RyBvpUV+jHFltdCoNke6bWy7z+0tOAsEVCtX/i0KmyyQHJLo+92o+BmOcvMPMpjegpGC
         RMdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718169847; x=1718774647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cQuI8YGQgLmsUNQvvWuFnLsfcid8kBB0k+CZ86TDvAk=;
        b=DHv0GQ1cbQxmaxqNZWkFdts9jWF/ufKwwcUeVr9C9+4qzMNHirOSh/W3j0jojbk97r
         CUMZZK4CdinaEOIf5ZdHKXJz5ZafZZDoXFbkDh64ayVNunNFVOCHFGzKZG9qcDpEE7K7
         xfxjW2bUnbh/mIxithVYJAI7RipyvOVcc3zV8gznjepV6lyLLUEIuPdHx9JCJpT1rOAE
         ZWPD8adJHDukeVKcspeE5hoXn+XGy2WZr5vxV5rcN1LQrJI+TqzvFpXMWexSVkbpBHNw
         UA3QJVAL+Oc0scE26Lna/KlKjETdnaYZM9ihODjok/jlHA8dvWqXUhszfrSVuBcKY9RG
         MjbA==
X-Forwarded-Encrypted: i=1; AJvYcCWLhA/Ie/UGhVUwu2sTo7aOtxuQ75O1aJUx2GJmHidUePxdRVD3cGRGk6AnUIdx5cHr2h+i//ZcnCUVq0avw+/+8Y3XDMg6
X-Gm-Message-State: AOJu0YzhUOQQSGNaULdNIkPGGs+x0bwXA9GDb2lqRBe/VIjS9EvfNWMg
	XaZzjhv0/7g7RoW9t8T5v74N0tNsQMF0Y/K8vXtcC5ogE7KKr6ex
X-Google-Smtp-Source: AGHT+IGibBQ31aFbHM2KNIyG3WXGmC6uDThIWGe0iAzdMLifnbTThBiAhC+djmwgDB3YyNkgibzPkg==
X-Received: by 2002:a17:902:ceca:b0:1f7:969:7e87 with SMTP id d9443c01a7336-1f83b666b52mr10420065ad.35.1718169846856;
        Tue, 11 Jun 2024 22:24:06 -0700 (PDT)
Received: from wheely.local0.net (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd75f711sm112170705ad.11.2024.06.11.22.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 22:24:06 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v10 09/15] configure: Make arch_libdir a first-class entity
Date: Wed, 12 Jun 2024 15:23:14 +1000
Message-ID: <20240612052322.218726-10-npiggin@gmail.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240612052322.218726-1-npiggin@gmail.com>
References: <20240612052322.218726-1-npiggin@gmail.com>
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
index db15e85d6..b93723142 100755
--- a/configure
+++ b/configure
@@ -217,7 +217,6 @@ fi
 arch_name=$arch
 [ "$arch" = "aarch64" ] && arch="arm64"
 [ "$arch_name" = "arm64" ] && arch_name="aarch64"
-arch_libdir=$arch
 
 if [ "$arch" = "riscv" ]; then
     echo "riscv32 or riscv64 must be specified"
@@ -285,8 +284,10 @@ fi
 
 if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
     testdir=x86
+    arch_libdir=x86
 elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     testdir=arm
+    arch_libdir=$arch
     if [ "$target" = "qemu" ]; then
         arm_uart_early_addr=0x09000000
     elif [ "$target" = "kvmtool" ]; then
@@ -335,6 +336,7 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     fi
 elif [ "$arch" = "ppc64" ]; then
     testdir=powerpc
+    arch_libdir=ppc64
     firmware="$testdir/boot_rom.bin"
     if [ "$endian" != "little" ] && [ "$endian" != "big" ]; then
         echo "You must provide endianness (big or little)!"
@@ -345,6 +347,7 @@ elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
     arch_libdir=riscv
 elif [ "$arch" = "s390x" ]; then
     testdir=s390x
+    arch_libdir=s390x
 else
     echo "arch $arch is not supported!"
     arch=
@@ -354,6 +357,10 @@ if [ ! -d "$srcdir/$testdir" ]; then
     echo "$srcdir/$testdir does not exist!"
     exit 1
 fi
+if [ ! -d "$srcdir/lib/$arch_libdir" ]; then
+    echo "$srcdir/lib/$arch_libdir does not exist!"
+    exit 1
+fi
 
 if [ "$efi" = "y" ] && [ -f "$srcdir/$testdir/efi/run" ]; then
     ln -fs "$srcdir/$testdir/efi/run" $testdir-run
@@ -416,10 +423,11 @@ fi
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
2.45.1

