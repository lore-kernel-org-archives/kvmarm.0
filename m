Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EB81DE4E5
	for <kvmarm@lists.linux.dev>; Fri, 21 Feb 2025 16:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740155293; cv=none; b=dGsy9kPM4Jb2S/2aMAxHWCnBW/fxBt+cTTQuRcSpjFy9wXXYNado2fQC9vbZunUhh8hCt23wppr8pnVcL16s9HCZiZ5Mj2BUzR1ultQ08IsYvguyWNuFQn+shzwEHuw/rg8zL5KHsZKfEdVDfYnHk/Y3b9inaqLPzsk2889m48s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740155293; c=relaxed/simple;
	bh=KhRJyAmmKJe4p4n+Are3TrNChOE8oHzm14caGVLifOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlYApwG0emLyIuWHjr6WuWA7kOTtCEQ2ZlmHaxIjIM8JF0Gw1Ee361oZO+vnIgq1lwZ+g4vYYZLpfs/N5QnXASHPCMBC5p86nQ5X3si3Ou5np/kngukOsw/uEl4B/OpD9CtIZuqyps4HP7XXkvFCqUQx/o4VVKCAsm1wP9aH+d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jZSS+1hJ; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jZSS+1hJ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740155288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8IPSvRUBRtTpCvRUq9nyj+UMlr4YW022ZUQVoIdr2zM=;
	b=jZSS+1hJ8o5+w2CsroqJVude4/LswkFwuoNbl0UALqzivFafzKEtgS0nwTCU2g/CMr1pDl
	QiZO1qQdBzm5+Jpg0qcdv/OpMNDSiEEMOPs46ApdSLSWksW3kTGwW5opZSjyM24C2g/0P9
	livc6vD9NkxWsLhNgACnQmBOvMOmCOU=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	atishp@rivosinc.com,
	cleger@rivosinc.com,
	pbonzini@redhat.com,
	thuth@redhat.com,
	Andrew Jones <ajones@ventanamicro.com>
Subject: [kvm-unit-tests PATCH 1/2] configure: Allow earlycon for all architectures
Date: Fri, 21 Feb 2025 17:27:55 +0100
Message-ID: <20250221162753.126290-5-andrew.jones@linux.dev>
In-Reply-To: <20250221162753.126290-4-andrew.jones@linux.dev>
References: <20250221162753.126290-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Andrew Jones <ajones@ventanamicro.com>

earlycon could be used by any architecture so check it outside the
arm block and apply it to riscv right away.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 configure | 88 +++++++++++++++++++++++++++----------------------------
 1 file changed, 43 insertions(+), 45 deletions(-)

diff --git a/configure b/configure
index 86cf1da36467..7e462aaf1190 100755
--- a/configure
+++ b/configure
@@ -78,10 +78,9 @@ usage() {
 	                           4k [default], 16k, 64k for arm64.
 	                           4k [default], 64k for ppc64.
 	    --earlycon=EARLYCON
-	                           Specify the UART name, type and address (optional, arm and
-	                           arm64 only). The specified address will overwrite the UART
-	                           address set by the --target option. EARLYCON can be one of
-	                           (case sensitive):
+				   Specify the UART name, type and address (optional).
+	                           The specified address will overwrite the UART address set by
+	                           the --target option. EARLYCON can be one of (case sensitive):
 	               uart[8250],mmio,ADDR
 	                           Specify an 8250 compatible UART at address ADDR. Supported
 	                           register stride is 8 bit only.
@@ -283,6 +282,41 @@ else
     fi
 fi
 
+if [ "$earlycon" ]; then
+    IFS=, read -r name type_addr addr <<<"$earlycon"
+    if [ "$name" != "uart" ] && [ "$name" != "uart8250" ] && [ "$name" != "pl011" ]; then
+        echo "unknown earlycon name: $name"
+        usage
+    fi
+
+    if [ "$name" = "pl011" ]; then
+        if [ -z "$addr" ]; then
+            addr=$type_addr
+        else
+            if [ "$type_addr" != "mmio32" ]; then
+                echo "unknown $name earlycon type: $type_addr"
+                usage
+            fi
+        fi
+    else
+        if [ "$type_addr" != "mmio" ]; then
+            echo "unknown $name earlycon type: $type_addr"
+            usage
+        fi
+    fi
+
+    if [ -z "$addr" ]; then
+        echo "missing $name earlycon address"
+        usage
+    fi
+    if [[ $addr =~ ^0(x|X)[0-9a-fA-F]+$ ]] || [[ $addr =~ ^[0-9]+$ ]]; then
+        uart_early_addr=$addr
+    else
+        echo "invalid $name earlycon address: $addr"
+        usage
+    fi
+fi
+
 [ -z "$processor" ] && processor="$arch"
 
 if [ "$processor" = "arm64" ]; then
@@ -296,51 +330,14 @@ if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
 elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     testdir=arm
     if [ "$target" = "qemu" ]; then
-        arm_uart_early_addr=0x09000000
+        : "${uart_early_addr:=0x9000000}"
     elif [ "$target" = "kvmtool" ]; then
-        arm_uart_early_addr=0x1000000
+        : "${uart_early_addr:=0x1000000}"
         errata_force=1
     else
         echo "--target must be one of 'qemu' or 'kvmtool'!"
         usage
     fi
-
-    if [ "$earlycon" ]; then
-        IFS=, read -r name type_addr addr <<<"$earlycon"
-        if [ "$name" != "uart" ] && [ "$name" != "uart8250" ] &&
-                [ "$name" != "pl011" ]; then
-            echo "unknown earlycon name: $name"
-            usage
-        fi
-
-        if [ "$name" = "pl011" ]; then
-            if [ -z "$addr" ]; then
-                addr=$type_addr
-            else
-                if [ "$type_addr" != "mmio32" ]; then
-                    echo "unknown $name earlycon type: $type_addr"
-                    usage
-                fi
-            fi
-        else
-            if [ "$type_addr" != "mmio" ]; then
-                echo "unknown $name earlycon type: $type_addr"
-                usage
-            fi
-        fi
-
-        if [ -z "$addr" ]; then
-            echo "missing $name earlycon address"
-            usage
-        fi
-        if [[ $addr =~ ^0(x|X)[0-9a-fA-F]+$ ]] ||
-                [[ $addr =~ ^[0-9]+$ ]]; then
-            arm_uart_early_addr=$addr
-        else
-            echo "invalid $name earlycon address: $addr"
-            usage
-        fi
-    fi
 elif [ "$arch" = "ppc64" ]; then
     testdir=powerpc
     firmware="$testdir/boot_rom.bin"
@@ -351,6 +348,7 @@ elif [ "$arch" = "ppc64" ]; then
 elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
     testdir=riscv
     arch_libdir=riscv
+    : "${uart_early_addr:=0x10000000}"
 elif [ "$arch" = "s390x" ]; then
     testdir=s390x
 else
@@ -491,7 +489,7 @@ EOF
 if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
 cat <<EOF >> lib/config.h
 
-#define CONFIG_UART_EARLY_BASE ${arm_uart_early_addr}
+#define CONFIG_UART_EARLY_BASE ${uart_early_addr}
 #define CONFIG_ERRATA_FORCE ${errata_force}
 
 EOF
@@ -506,7 +504,7 @@ EOF
 elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
 cat <<EOF >> lib/config.h
 
-#define CONFIG_UART_EARLY_BASE 0x10000000
+#define CONFIG_UART_EARLY_BASE ${uart_early_addr}
 
 EOF
 fi
-- 
2.48.1

