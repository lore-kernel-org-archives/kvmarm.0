Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847BB64A8F
	for <kvmarm@lists.linux.dev>; Tue,  8 Apr 2025 13:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744118468; cv=none; b=uloKebzMZJN1tshblkjvAe0L70t88+58fJkTs305kpqqRXBqrayBeF935JA60DNaoB3vQGjvkzbbyZnSDDU3G97k6xxIhyRHqEI2VwBRicSTXZm5+7YebA8juh3QZzMagEWq1IBgJ27aIaUWhUcGf1oqaUyGt7nPSwGSePXq1RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744118468; c=relaxed/simple;
	bh=IN7VS19lwIj4mFtoPVwDHThAtfSDM5hBoBnjzalsMKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GM/Xz+5+1sclCfMq8N4KRufaWPE3tNMVOIZgNWdGZHEAeQEPucydjpFAVkokRNKtBO1RD3o2rm3ma5vbOWle5524tErlw6I8jdVft40pdryLMslJ1Xb0Ci0XhgzUxQcE3Y47t7GwiAWVTpaVYFdP6ISMndhqTycA77AKRTU1f50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Y3AJToaC; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Y3AJToaC"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43cfecdd8b2so43622855e9.2
        for <kvmarm@lists.linux.dev>; Tue, 08 Apr 2025 06:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744118465; x=1744723265; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HOPA2fmXPhp0g7ThkLsi+uZYdZ8vnNqs5fSRtuJQXEs=;
        b=Y3AJToaC3ukOMNFtpgRPpZGM5nxCR8C1qFk5GwmEJFRvVLOt/isRoysjD0QVK49qEB
         H+xaatS9Rme1Yhk7L+iS4QQsfPpLj3cznq8Je3g8n6cOCJup748ft8IdeqV1vuBbdFqQ
         ciWXb3be7hGBlMJEZPr/fBPsdiH8aZrymkGMUzEdGd/vX+bsd3KJ+h1CcM4lLpIKqAVM
         C5MBqYs+Hq2BdDPY+h3NHAxm2+E81zDAuf0rqW5xIcJx4b93vujNlqu2W2YJ+lSBsems
         8TOiKU0q9wh+jMg6+6oJ74cVmEjFf2K+x+GBDLvon4bT/R4o7Yx1if+ZuWkWxCeV6nvw
         b8Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744118465; x=1744723265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HOPA2fmXPhp0g7ThkLsi+uZYdZ8vnNqs5fSRtuJQXEs=;
        b=EEY1hLS9Dax8nLWatCmm1AbNaA063xN4P7Oq407oJZAfNEeoLQc7TXec4gBHGJlQX3
         WDaj0L0bkibbALeC1kZQcWzF/RwihLTZTnkKY+nq5JidpNyph6fsDjZ1UMhYMBqDJfpI
         HUFex46T/5tm6+SYaUNF+o9IiUaC3lG5qEoWT+aUTDXe2CHDdiKYbViu6ifTJLb32g3a
         +aRd0sObVH0Xq/F6IRZ2S2rRD9NLK+rChHb5/QcmQ6YolwpSY51tNDtBcMwyr5iVf0ao
         McQH/4S1JVyWCDZrVIUwyEPqFfRf8QjnAxTSVDDx9epYCDyqbc6klC6C0WG0R27pj+Aq
         OmRA==
X-Forwarded-Encrypted: i=1; AJvYcCWT/R0PEQUw7qJmINdncNc4rMVtpFSNP2ViujMrxNwaEZE5kzFrdDa7Rn9hl7Jr2ouz3YMV+yE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8OZ7rPmYVVFECUNNWIx3amI9GSkii3181i3xUWMgPATQ03UB+
	KEO1UZOVkguICRQgtc8lVSdUUowtoTdyVN6eXsC0q9RZqYanipzYme5ffBux6PE=
X-Gm-Gg: ASbGncsyNLM1KevuKzkR6byte/SUtt2J0YnN8X9CHUQi4AyiV32OQqSnYwctI2Af3IL
	9AqrilocNH/tXws1TrnGFafbUympgOsktQZ9Vu1UQ6mb819otBbOW8SMSUFEzQEd0o0T4LV6uXp
	EVM/P8xlBdVX6ndNe0nu0ZhWkU9wTXSNZZwx/RwOAV5VY/DNwWvdZuiPpL0ZOBc5AOEnloXneKf
	j3UnGzrxPNahmMAiLUmfY45ZLCZ2tUZvvHdPy+3+IwGf6lOr/rrdz9hqA+uBOUu8v/91cSd0J3R
	kL0qxd2Ova6DOTOBkbJ4GZocWF1jwopRCWVe7weNN+vcK19wzvkI0wvk6+c2izk=
X-Google-Smtp-Source: AGHT+IEEYzGOKHN6r46LzVByJFbW7i8YbDNKMzXqurwCu8CRJ0JfLsDForarjYS/wFNxfVFVo9a5Nw==
X-Received: by 2002:a05:600c:524c:b0:43c:e70d:44f0 with SMTP id 5b1f17b1804b1-43f1890857emr9390535e9.19.1744118464779;
        Tue, 08 Apr 2025 06:21:04 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec36699e0sm162159705e9.35.2025.04.08.06.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 06:21:04 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v4 4/5] configure: Add --target-cpu option
Date: Tue,  8 Apr 2025 14:20:53 +0100
Message-ID: <20250408132053.2397018-6-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408132053.2397018-2-jean-philippe@linaro.org>
References: <20250408132053.2397018-2-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the --target-cpu option to let users set the CPU type to run on.
At the moment --processor allows to set both GCC -mcpu flag and QEMU
-cpu. On Arm we'd like to pass `-cpu max` to QEMU in order to enable all
the TCG features by default, and it could also be nice to let users
modify the CPU capabilities by setting extra -cpu options. Since GCC
-mcpu doesn't accept "max" or "host", separate the compiler and QEMU
arguments.

`--processor` is now exclusively for compiler options, as indicated by
its documentation ("processor to compile for"). So use $TARGET_CPU on
RISC-V as well.

Suggested-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 scripts/mkstandalone.sh |  3 ++-
 arm/run                 | 15 +++++++++------
 riscv/run               |  8 ++++----
 configure               | 27 +++++++++++++++++++++++++++
 4 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index 2318a85f..c4ba81f1 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -42,7 +42,8 @@ generate_test ()
 
 	config_export ARCH
 	config_export ARCH_NAME
-	config_export PROCESSOR
+	config_export TARGET_CPU
+	config_export DEFAULT_QEMU_CPU
 
 	echo "echo BUILD_HEAD=$(cat build-head)"
 
diff --git a/arm/run b/arm/run
index efdd44ce..ef585582 100755
--- a/arm/run
+++ b/arm/run
@@ -8,7 +8,7 @@ if [ -z "$KUT_STANDALONE" ]; then
 	source config.mak
 	source scripts/arch-run.bash
 fi
-processor="$PROCESSOR"
+qemu_cpu="$TARGET_CPU"
 
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
index e2f5a922..2bd42ad8 100755
--- a/riscv/run
+++ b/riscv/run
@@ -11,12 +11,12 @@ fi
 
 # Allow user overrides of some config.mak variables
 mach=$MACHINE_OVERRIDE
-processor=$PROCESSOR_OVERRIDE
+qemu_cpu=$QEMU_CPU_OVERRIDE
 firmware=$FIRMWARE_OVERRIDE
 
-[ "$PROCESSOR" = "$ARCH" ] && PROCESSOR="max"
 : "${mach:=virt}"
-: "${processor:=$PROCESSOR}"
+: "${qemu_cpu:=$TARGET_CPU}"
+: "${qemu_cpu:=$DEFAULT_QEMU_CPU}"
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
index b4875ef3..63367bbc 100755
--- a/configure
+++ b/configure
@@ -23,6 +23,24 @@ function get_default_processor()
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
+    "riscv32" | "riscv64")
+        echo "max"
+        ;;
+    esac
+}
+
 srcdir=$(cd "$(dirname "$0")"; pwd)
 prefix=/usr/local
 cc=gcc
@@ -52,6 +70,7 @@ earlycon=
 console=
 efi=
 efi_direct=
+target_cpu=
 
 # Enable -Werror by default for git repositories only (i.e. developer builds)
 if [ -e "$srcdir"/.git ]; then
@@ -70,6 +89,9 @@ usage() {
 	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
 	                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
 	    --processor=PROCESSOR  processor to compile for ($processor)
+	    --target-cpu=CPU       the CPU model to run on. If left unset, the run script
+	                           selects the best value based on the host system and the
+	                           test configuration.
 	    --target=TARGET        target platform that the tests will be running on (qemu or
 	                           kvmtool, default is qemu) (arm/arm64 only)
 	    --cross-prefix=PREFIX  cross compiler prefix
@@ -146,6 +168,9 @@ while [[ $optno -le $argc ]]; do
         --processor)
 	    processor="$arg"
 	    ;;
+	--target-cpu)
+	    target_cpu="$arg"
+	    ;;
 	--target)
 	    target="$arg"
 	    ;;
@@ -471,6 +496,8 @@ ARCH=$arch
 ARCH_NAME=$arch_name
 ARCH_LIBDIR=$arch_libdir
 PROCESSOR=$processor
+TARGET_CPU=$target_cpu
+DEFAULT_QEMU_CPU=$(get_default_qemu_cpu $arch)
 CC=$cc
 CFLAGS=$cflags
 LD=$cross_prefix$ld
-- 
2.49.0

