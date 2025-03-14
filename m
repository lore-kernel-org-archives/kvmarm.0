Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC95F202C21
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 15:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741967481; cv=none; b=sQDEzSusdZflzEcasmig/kNN5WUrhWZMFI805+tqxj/LO8aixWCrN0Cvp+Zn7Hus8lm54nTAkHbKA7zOYadrtrC4pjijc3qzX0CCmU06AdhkQU7RVCkK4fY8jkW5uOqJ/8ziSozhqtSjiEHFFnHHpvQ7VW778nVR5OdEtYphy4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741967481; c=relaxed/simple;
	bh=EkpO5sHjJ3k0w3GcR85plkff9xr8C3dB7U2UpNDrtPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKZouMvp+CcoolguNnZzf7fUZwEpbDdE9kC0Y3Pi7tpRI+O/lHygTFj/Wp7Wl8KnCX6VDo6l20dmmB3xLs3cwrtam3RRbGHGmAnE0Wjeydxi0PsZ7A8wVMQ0znG7PsmeLowPQWMM3KHtmKNMlvscbH2lKMzp+8Lq5tz5xpN/AWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ldnNQeTM; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ldnNQeTM"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-391342fc1f6so1916434f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 08:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741967477; x=1742572277; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D0zGO9xjg0JJPs4PFAX2msz/3yAP4xRZn7yO7s54uDo=;
        b=ldnNQeTMjuLiYjUS/pTtrVSiLvPqSe+HCAJ1HF+t3Ut1uTCR194i1R58B1gYgBpi3P
         Enu9RrvqBKD5ZD12cOsxpH42oG9a1m9LZjYvr9/mcI51feGWRytjoDl6FKuorT+X7AGO
         bsk3LjNRaRYLXrS5WdUUJVeJ9aaDOvmCjQuodhr2LtIrMa0DVlNAo03PVzewJzuzkrTO
         1VrN3jzt5+infZ7gQzIyYneHqXCifsKpgfuWS81ztaJhjRrCRQPYgcKpoPJPXegKAUWU
         KJeBig8DisTjM3Uybrtztthc+Gxtlg8CpqL8GHuFspCUDvKiOo7XSQOXh4G+ysLDr5O3
         eb8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741967477; x=1742572277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D0zGO9xjg0JJPs4PFAX2msz/3yAP4xRZn7yO7s54uDo=;
        b=QGYaV89tu20kExb1jTAEtfh9vBB6+sOWxq67R/7GfT2NZC7ocAf8ZHaIR7PWODY3BC
         Zj+8sCanKXL/k16bSv+lTL9MvbUYIsgcJXUtvtL7JFdlruGEm8TD2MSjxEqhLvstr3DR
         JNnx+f6BA06Y4YCN4IWt+PDkFaBI7jDbsfOmKTfv4zie541X0vaWV+IT79rVPZOEjGY5
         eiSNFO8JGQxkxTCaRv1BpwWk4TOzl1Q8FjHr7UdAJOqotowHHvua9GlLWf0BQjRXtQXH
         IcwtV0sYeottUGCc3IEPyUuF1s8Bjvp1FjM7xQd+mn8fH2z/uWHpgGdAUqtRgzgakwRd
         nGhw==
X-Forwarded-Encrypted: i=1; AJvYcCXhYniSKo5zJKycgfCCrV2d+jk6iAZLtJR30YxLNpEmYqbhdAmljRAOOiSImzbC35Cs5Qxag+A=@lists.linux.dev
X-Gm-Message-State: AOJu0YwcAlZVEXHv5vKmprUYwAAYhSe4Fs6LQd8Q9cyH2kcCZD86HaKr
	w6+IbFtQ4PzCNQuLwg9nOkAUc1eU13UF1SlzTv78dTNuQ7LKh6dzh4nwsAtbk38=
X-Gm-Gg: ASbGncvY5GEmt+pb1X6+LAoSKJI9qoJb92qWSejacqefBnHjGacaaC2781BCUcrn61i
	Drdomn6xKgH8HHQ5CO4Q79BRUxrg0HSiym03ZGsvmYMlp2GQbI9NOAnjhQvBzwSVZ8DhiZb1XGg
	97xybBIcOeNhSCphOw5Ck3hL7yqm8nXB5GoGESDalNjtcP+eOQ/i4Yg+GJGkggZM+hr9+j5S0/V
	Dx4+L3ncifnRLoxPHkqYNiGRvaYOdeDaXGb/RJIH1W6MMCTxS0llfEjTn0VrYcJvOFiOFTlzPBF
	2NqSwOBvxrON7pItMH+788o+rsqIOsctv/xxvBiNP0oahjbIqOkHsWfDgFWG63A=
X-Google-Smtp-Source: AGHT+IECh7v7OK/v5EHEcUY4C0dtwmYasbITKNCuGAGjy0H2BYksZDgS5IwiyYO2BbZMuCf+xK8yVw==
X-Received: by 2002:a5d:6481:0:b0:38d:ca55:76c3 with SMTP id ffacd0b85a97d-3971cd57ed1mr4057887f8f.11.1741967476931;
        Fri, 14 Mar 2025 08:51:16 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d21d67819sm15249945e9.21.2025.03.14.08.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 08:51:16 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v2 4/5] configure: Add --qemu-cpu option
Date: Fri, 14 Mar 2025 15:49:04 +0000
Message-ID: <20250314154904.3946484-6-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250314154904.3946484-2-jean-philippe@linaro.org>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
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
modify the CPU capabilities by setting extra -cpu options.
Since GCC -mcpu doesn't accept "max" or "host", separate the compiler
and QEMU arguments.

`--processor` is now exclusively for compiler options, as indicated by
its documentation ("processor to compile for"). So use $QEMU_CPU on
RISC-V as well.

Suggested-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 scripts/mkstandalone.sh |  2 +-
 arm/run                 | 17 +++++++++++------
 riscv/run               |  8 ++++----
 configure               |  7 +++++++
 4 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index 2318a85f..6b5f725d 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -42,7 +42,7 @@ generate_test ()
 
 	config_export ARCH
 	config_export ARCH_NAME
-	config_export PROCESSOR
+	config_export QEMU_CPU
 
 	echo "echo BUILD_HEAD=$(cat build-head)"
 
diff --git a/arm/run b/arm/run
index efdd44ce..561bafab 100755
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
@@ -37,12 +37,17 @@ if [ "$ACCEL" = "kvm" ]; then
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
+	elif [ "$ARCH" = "arm64" ]; then
+		qemu_cpu="cortex-a57"
+	else
+		qemu_cpu="cortex-a15"
 	fi
 fi
 
@@ -71,7 +76,7 @@ if $qemu $M -device '?' | grep -q pci-testdev; then
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
index 5306bad3..d25bd23e 100755
--- a/configure
+++ b/configure
@@ -52,6 +52,7 @@ page_size=
 earlycon=
 efi=
 efi_direct=
+qemu_cpu=
 
 # Enable -Werror by default for git repositories only (i.e. developer builds)
 if [ -e "$srcdir"/.git ]; then
@@ -69,6 +70,8 @@ usage() {
 	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
 	                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
 	    --processor=PROCESSOR  processor to compile for ($processor)
+	    --qemu-cpu=CPU         the CPU model to run on. The default depends on
+	                           the configuration, usually it is "host" or "max".
 	    --target=TARGET        target platform that the tests will be running on (qemu or
 	                           kvmtool, default is qemu) (arm/arm64 only)
 	    --cross-prefix=PREFIX  cross compiler prefix
@@ -142,6 +145,9 @@ while [[ $optno -le $argc ]]; do
         --processor)
 	    processor="$arg"
 	    ;;
+	--qemu-cpu)
+	    qemu_cpu="$arg"
+	    ;;
 	--target)
 	    target="$arg"
 	    ;;
@@ -464,6 +470,7 @@ ARCH=$arch
 ARCH_NAME=$arch_name
 ARCH_LIBDIR=$arch_libdir
 PROCESSOR=$processor
+QEMU_CPU=$qemu_cpu
 CC=$cc
 CFLAGS=$cflags
 LD=$cross_prefix$ld
-- 
2.48.1

