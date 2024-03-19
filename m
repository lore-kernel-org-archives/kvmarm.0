Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D5A54775
	for <kvmarm@lists.linux.dev>; Tue, 19 Mar 2024 08:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835316; cv=none; b=ducwV6B0ZjJEOFs/tBXniNAkgFaHObrtcPuQCJrhygMvdwU70IPT1davvBWH1a+dCislIEjOKC/jgXq8dRH6/0YNbWq3ezBtweaE5CWejoBCXODd1Jj1K7RviKkz7nOl++omNXBxwX6Y49pLqUrcp3W6fUxpJLWRtrFbemvVgL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835316; c=relaxed/simple;
	bh=uOh2bHKLRUXUaO+Y4SQ5EIoftUs7uj6ScZRl2vQddKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VmhDt2zBaPyUtRW8Rzuc9HI+gnIde+KN1CWyh7X5MQw0Wu7+vTPPJmWrKODZNXhmIPJ4omYFfSY0EIffOxnmB0ZWDiPif5DyyIHM+8fR2/FAANVANXPoGu/bDngfEae8M9zc8GKG6Jvg5LhDc8gIAvRA1xrRAqvym/b3LRF0Nh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FTXY4FdQ; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FTXY4FdQ"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6e67cf739d0so2289704a34.1
        for <kvmarm@lists.linux.dev>; Tue, 19 Mar 2024 01:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835314; x=1711440114; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lYCFo5qndkhUTKD0ju2V6NpbPZWgrF0rvNKi9F72sCM=;
        b=FTXY4FdQEzl+lo2bkE89ukxVsJzEs/aXCJFa/jc6FsUtjdBjZfLcNzX0YP86dZwcfJ
         Fh2GoW3nVaqTlWXqOSzjVzIqoBssl6/o7LgArvTdllucmWqB07GKFyeTr0BCTP3UnSpR
         n3lrFIJGssdlad8fhf2kTRV57i+8ATA/NQZG6zMEm+r2mIzU/9inGSphn7aPDp4gHCcb
         busZxheOVaQupmjg9iZBDukJmQQMdJQIttfvDjD7ixwwJgqDLiGobe++8KOzIpLOZGpO
         lchjW6zSSJ4sZUmNg2HQLBqmY0zWAnR68e+dhshvS02yMP4pHIQNfOrO1t9zlzEa3XMU
         8UWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835314; x=1711440114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lYCFo5qndkhUTKD0ju2V6NpbPZWgrF0rvNKi9F72sCM=;
        b=O2/ZqVMQSFqlG0qLqaow5QdhtvAPKOD+KScxLsCh/lulOiFnj7ofkYFn5Jg7Vlxt+W
         m02P2VdLCSyyivAzDutNJIkIIuU7r1ehouQ9GTpN2/QdmiaLNURXoNTjkgIPZqZBSXbC
         Gct3r0h9FECJPLHivjaJhRoW0hEyvrsHxb11cCOuEhYugcAEcHKVyoQVmWRRR7o8kT5z
         ZVlUXLIw7pt6546+PTP43LTk3nLC/jU4E5uZD3yMHc+fMUsES7RxOYSGybJJmOVZo47m
         fyRC0xcov9WkIVvrtFc9AWeNVgM0Y0/yx3z1tGo+lkJL4hskEmD2ANqFsATgPzyVk+ol
         t4FA==
X-Forwarded-Encrypted: i=1; AJvYcCUR5UjAF4HtVpLHLK0S0YMv6wRwsRINRW0X9cAfZS9g+8BX8JvSROP1pGGY046pOzJLCIy+JYoIaRysGmy/AjRQh5hVZADC
X-Gm-Message-State: AOJu0YyXXspz91dn7+DWCmgM5f9LJOVq/jClxzcBHmazsyphnhdEqMPm
	OeXFiOIUpNgXMP4bSDTkmTKk65KG59PvV4vJc89em5n51yZ5VINs
X-Google-Smtp-Source: AGHT+IF70kukuIUslOKRONbnfx6Q5qzHIC6G6YQbr4o/AriQpKZiTDdR6gDB2b8R+nXV1Kt8v8DJvA==
X-Received: by 2002:a05:6870:e308:b0:220:932f:1a1e with SMTP id z8-20020a056870e30800b00220932f1a1emr17263158oad.12.1710835314432;
        Tue, 19 Mar 2024 01:01:54 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.01.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:01:53 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v7 33/35] configure: Make arch_libdir a first-class entity
Date: Tue, 19 Mar 2024 17:59:24 +1000
Message-ID: <20240319075926.2422707-34-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240319075926.2422707-1-npiggin@gmail.com>
References: <20240319075926.2422707-1-npiggin@gmail.com>
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
2.42.0

