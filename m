Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CD318CBFB
	for <kvmarm@lists.linux.dev>; Tue, 25 Mar 2025 16:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742918875; cv=none; b=FSkhHS09sZJ5p28JxpbdgiRlHpajpTM9zg+dAGcKoaWeKNTimtp0qVs/XohXoF3BQ+hVBDVseq+DX+1QzGqrQYgX1vRiYL1Epht5vXluLp7NY9fMQPTCqd3C9Za6txTVqMxlOHD9GwI4uBji825/jQ1vXXwakVCgXsMdoheBJwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742918875; c=relaxed/simple;
	bh=deGWWrRabN2BUuESzK6sCMhIniOcxImAkRg9Tz3X9gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pU7MzrzrcF6Rt3E8+EAqJ+6SRKPkqS4g8eGjSipDYYorVT+ykZu2c49S4pdmYmRabBeF8MAqWPR7fLgYfw6nk9HGcYWJ8Tq98e9GjDLh5qrFcIFAG/2lzS407yEY/GcypQ9i1/DL/tcsfI9vYF4ecKZo14cGgfRAGtLlrznlYpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Xtm6NHos; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Xtm6NHos"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43cf680d351so40766825e9.0
        for <kvmarm@lists.linux.dev>; Tue, 25 Mar 2025 09:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742918872; x=1743523672; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6v4oWjxs3w2OXtl8okLU3CaHVHPFgAaN27M8fJJ3JPw=;
        b=Xtm6NHoszIMlGUcPfjmaTrZw0qVMl8lKXOVHFUooiQnPK7YoAHfw47iEl16Tny2YqE
         oHAnZdrpUJNg98duh2cV3G1CwfDsyFy+guw9LDRUybmoWygmyny/FSkeLp3PEXYzAS60
         ImkeDypfYDCUFmDIt7vefgfs2Yd4iB4lyRswe44/sj5dY1379PRL63dHwij/JMECQeeL
         i5q9luHxWnGK1W3sAbQgndyNatB9LyjTURkXtgvTSa4RZg8t1upHN4jBnbUc+tz+YaK8
         UUe8mDYnLXYxStT+jlzTSCnhYBoFJsjM40+44RnObSrzgD60w7+oMbgIN+R6YHYyAN2V
         ATmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742918872; x=1743523672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6v4oWjxs3w2OXtl8okLU3CaHVHPFgAaN27M8fJJ3JPw=;
        b=NC9+CgHUlYKVjrHAaehVZV4Uk1OX66US7Hx97FYgOzKIN/JLAxSu8ebpDvE6p56uaN
         H4UU2W18Aoxg3O4rxjMuVgTfu3h5QhTERIxVi3hK0AtGiZLDn03Tnpc83rgjlSUdDLT/
         KiKUGjGLPAGBH6xMvx5NmNuL4H+hsqJWaKNg916vsdah2iLtAG2QM2ZSWiHnKEKnwS7d
         7Qg0gC13cNtlUBeIXiAZ0sqB5a/rWooZj0XCWrKxhH8TL8UjhXOxgEP7bMHO0TKXFCKl
         LVZ3VGgs/F5khwZM0DTQDjpJrq789Y2VmMPBtj3Q5YRknFHMmKb5n5RWoPXDJO4AC2lM
         GFCA==
X-Forwarded-Encrypted: i=1; AJvYcCUr5zWJ3QUhU6c2shX0/x8ldomdCugyEl+rq+nA+hBYR/fwY3wESx5o0EbZdkDGdQwB/qo95Xg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyJ+1r6v/WZ0FnJE4SsTaxNaYalYxGBollM+bn/kMM/0Q1vUFrm
	S+Rub9Ww09KCwtOmDF4hF1XuvcY+9UuA9Qp8tZP8mf5DVxH/t0pgRvzO8PFgkaU=
X-Gm-Gg: ASbGncv6TU3fl55ukvhFcLcrmnJx+5roEzxDbeI/JYKwRMRMdh4Nge1ixU/ApFyL4Bu
	41D+K6SWWMv8hVp/jFsPdOkDQE7D5zG8MXSs9QXJhkYM7aQU8b+HpUZBg5VULquOG7U/w2JKQ9G
	aeMTp6LZr4qsGOOO7gEPTYDpt9SXxf/ci9yh72cBW5f39bzQED3wuHIJHNWtngk/RI/+37Be+tH
	2uj8Ugz/jPU/K/PpW8vy69xcvKqqSH7h/78AchH57KdAZx211CMHGk6IBzUeMA1SUN2i3Hmo1dQ
	zQ0KUN/KxR4Jo5OpmTiuIxG9xxdEfTgvTimI5e9eASfSwvIRZ5zMQnC3SvDKB3Ap57g8MHrYIQ=
	=
X-Google-Smtp-Source: AGHT+IHMqhvbDDmS/MsUebAwQrnmnrLCj1L6a/nkr+ekAH/NHss4lv/QGFSzm78I2k54eI/LtzmFrw==
X-Received: by 2002:a05:600c:1d01:b0:439:8878:5029 with SMTP id 5b1f17b1804b1-43d77547ecbmr3550045e9.2.1742918871939;
        Tue, 25 Mar 2025 09:07:51 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d43f43cbasm203972195e9.9.2025.03.25.09.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 09:07:51 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v3 4/5] configure: Add --qemu-cpu option
Date: Tue, 25 Mar 2025 16:00:32 +0000
Message-ID: <20250325160031.2390504-7-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325160031.2390504-3-jean-philippe@linaro.org>
References: <20250325160031.2390504-3-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the --qemu-cpu option to let users set the CPU type to run on.
At the moment --processor allows to set both GCC -mcpu flag and QEMU
-cpu. On Arm we'd like to pass `-cpu max` to QEMU in order to enable all
the TCG features by default, and it could also be nice to let users
modify the CPU capabilities by setting extra -cpu options.  Since GCC
-mcpu doesn't accept "max" or "host", separate the compiler and QEMU
arguments.

`--processor` is now exclusively for compiler options, as indicated by
its documentation ("processor to compile for"). So use $QEMU_CPU on
RISC-V as well.

Suggested-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 scripts/mkstandalone.sh |  3 ++-
 arm/run                 | 15 +++++++++------
 riscv/run               |  8 ++++----
 configure               | 24 ++++++++++++++++++++++++
 4 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index 2318a85f..9b4f983d 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -42,7 +42,8 @@ generate_test ()
 
 	config_export ARCH
 	config_export ARCH_NAME
-	config_export PROCESSOR
+	config_export QEMU_CPU
+	config_export DEFAULT_QEMU_CPU
 
 	echo "echo BUILD_HEAD=$(cat build-head)"
 
diff --git a/arm/run b/arm/run
index efdd44ce..4675398f 100755
--- a/arm/run
+++ b/arm/run
@@ -8,7 +8,7 @@ if [ -z "$KUT_STANDALONE" ]; then
 	source config.mak
 	source scripts/arch-run.bash
 fi
-processor="$PROCESSOR"
+qemu_cpu="$QEMU_CPU"
 
 if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
    [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
@@ -37,12 +37,15 @@ if [ "$ACCEL" = "kvm" ]; then
 	fi
 fi
 
-if [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ]; then
-	if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
-		processor="host"
+if [ -z "$qemu_cpu" ]; then
+	if ( [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ] ) &&
+	   ( [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ] ); then
+		qemu_cpu="host"
 		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
-			processor+=",aarch64=off"
+			qemu_cpu+=",aarch64=off"
 		fi
+	else
+		qemu_cpu="$DEFAULT_QEMU_CPU"
 	fi
 fi
 
@@ -71,7 +74,7 @@ if $qemu $M -device '?' | grep -q pci-testdev; then
 fi
 
 A="-accel $ACCEL$ACCEL_PROPS"
-command="$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_testdev"
+command="$qemu -nodefaults $M $A -cpu $qemu_cpu $chr_testdev $pci_testdev"
 command+=" -display none -serial stdio"
 command="$(migration_cmd) $(timeout_cmd) $command"
 
diff --git a/riscv/run b/riscv/run
index e2f5a922..02fcf0c0 100755
--- a/riscv/run
+++ b/riscv/run
@@ -11,12 +11,12 @@ fi
 
 # Allow user overrides of some config.mak variables
 mach=$MACHINE_OVERRIDE
-processor=$PROCESSOR_OVERRIDE
+qemu_cpu=$QEMU_CPU_OVERRIDE
 firmware=$FIRMWARE_OVERRIDE
 
-[ "$PROCESSOR" = "$ARCH" ] && PROCESSOR="max"
+[ -z "$QEMU_CPU" ] && QEMU_CPU="max"
 : "${mach:=virt}"
-: "${processor:=$PROCESSOR}"
+: "${qemu_cpu:=$QEMU_CPU}"
 : "${firmware:=$FIRMWARE}"
 [ "$firmware" ] && firmware="-bios $firmware"
 
@@ -32,7 +32,7 @@ fi
 mach="-machine $mach"
 
 command="$qemu -nodefaults -nographic -serial mon:stdio"
-command+=" $mach $acc $firmware -cpu $processor "
+command+=" $mach $acc $firmware -cpu $qemu_cpu "
 command="$(migration_cmd) $(timeout_cmd) $command"
 
 if [ "$UEFI_SHELL_RUN" = "y" ]; then
diff --git a/configure b/configure
index b4875ef3..b79145a5 100755
--- a/configure
+++ b/configure
@@ -23,6 +23,21 @@ function get_default_processor()
     esac
 }
 
+# Return the default CPU type to run on
+function get_default_qemu_cpu()
+{
+    local arch="$1"
+
+    case "$arch" in
+    "arm")
+        echo "cortex-a15"
+        ;;
+    "arm64")
+        echo "cortex-a57"
+        ;;
+    esac
+}
+
 srcdir=$(cd "$(dirname "$0")"; pwd)
 prefix=/usr/local
 cc=gcc
@@ -52,6 +67,7 @@ earlycon=
 console=
 efi=
 efi_direct=
+qemu_cpu=
 
 # Enable -Werror by default for git repositories only (i.e. developer builds)
 if [ -e "$srcdir"/.git ]; then
@@ -70,6 +86,9 @@ usage() {
 	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
 	                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
 	    --processor=PROCESSOR  processor to compile for ($processor)
+	    --qemu-cpu=CPU         the CPU model to run on. If left unset, the run script
+	                           selects the best value based on the host system and the
+	                           test configuration.
 	    --target=TARGET        target platform that the tests will be running on (qemu or
 	                           kvmtool, default is qemu) (arm/arm64 only)
 	    --cross-prefix=PREFIX  cross compiler prefix
@@ -146,6 +165,9 @@ while [[ $optno -le $argc ]]; do
         --processor)
 	    processor="$arg"
 	    ;;
+	--qemu-cpu)
+	    qemu_cpu="$arg"
+	    ;;
 	--target)
 	    target="$arg"
 	    ;;
@@ -471,6 +493,8 @@ ARCH=$arch
 ARCH_NAME=$arch_name
 ARCH_LIBDIR=$arch_libdir
 PROCESSOR=$processor
+QEMU_CPU=$qemu_cpu
+DEFAULT_QEMU_CPU=$(get_default_qemu_cpu $arch)
 CC=$cc
 CFLAGS=$cflags
 LD=$cross_prefix$ld
-- 
2.49.0

