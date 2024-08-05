Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E1315EFA6
	for <kvmarm@lists.linux.dev>; Mon,  5 Aug 2024 17:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722879243; cv=none; b=MUPxJ6MAHGpqq6KwcgsRChSc716R6pQGAMv4igfoFtuilVNMyRk+lF3P8p8LcRZmZcVnbZwlmTHh+OI9ScInM58tFDr1Db8y5ECI6OoWyxDCSy+PDW3SAIRA2//rXhj1EYh9WVJ8M4j/W4FBPqeudBiSLX5SqNMkXRP7RwYlzug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722879243; c=relaxed/simple;
	bh=WnUTdrRIw06Sm8p4lhxd3NpInTL+91157CN4Xts9Cv8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=izFPUSp7T26drdNioT5VHbFjAlICWmGfEbLaKEkLcOKSWkb1rKeEP0FsbgNnhC6/cgP4EjEMeOwazHyUb7J1s3TfuSlech/JkgyCKsfB5f3ltCjuOUNqdt9PNHo7CJ4ITw3SK0nHAuz5L9JBMjMNDOvcEUqp9UXrcIWIa0tugpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mHDIlII7; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mHDIlII7"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4280ec5200cso70549775e9.0
        for <kvmarm@lists.linux.dev>; Mon, 05 Aug 2024 10:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722879239; x=1723484039; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1urJTEMvEtFl4AB0gpe886SYgHV2sjVLIcEz3Auu7JY=;
        b=mHDIlII74kYnfAs9G5y9M2lxalbRkrQjZjz9HJJo+H7pVDbB6V0cxIyVGaNr8D8Vt8
         8r77GHiSgT9qixQTja2Ur4LxC7PmrJ/QHyk6M23UUJ7gxwseq7o9KfsjhROXbhmzrXjJ
         z/7A2oXsW3JWRZj+Czv0LoIxweWSNcUMq2uJsJlZLa1E4J6GMAENoJ3E7JBxGNb8nq25
         l500S1fahcl8/5Dtt5KiOkcIsi9P+d7PhlkxftRHRrtjCrc+2ijQhWhCPp8H8BEBOJYO
         sQdYMa8o1rqVONPisHSZ0U9rgElzvSHr+xthk7Cv8rzUXGSh+iBrd52pSm1wsfDsX5ON
         E9iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722879239; x=1723484039;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1urJTEMvEtFl4AB0gpe886SYgHV2sjVLIcEz3Auu7JY=;
        b=ObA2nBdvbsifMRZLJDLhCYA+Qvb17xNx7i4qtEFUorNRTSt6M3owrR7cSSVCTIs2E6
         VjcRULE8HixNugkJuqNIoLx8/U+rXqgv3Gzd80u+t0xx9VzDZSaOaDn8UAxMfLIQSLCp
         d2XFOyjown0mqbSef1PeWJH7wWnkgRUPML6yApsU3BAEavW4QUyEAZbGvmmNwLPIqQxG
         5e4P82O+vLEYfVMlilLMq1mSdkR8keXhggT1s+S0/y9/Q6rGhNeiwTLd+ZwcwdrpfHxl
         EPwG6KlSSPkfZGmkrQLVQAdFK/LnyZ910qaatFy88xvK2j1fTcRWriXEJOBCWjLTQRtm
         qWIg==
X-Gm-Message-State: AOJu0YwS3x89AZchD7lVHaUAKxlaIXXGhSN0DkK7ESuxQPSBBZ9Uthak
	IITZlCfsBN8DluDjzSIlQtKx45K2R42BtSCz6inxSzVTVdhFEDikZr2WgVMVi70AuSXk9Go15dR
	K9iEycQHoVISDA7XNHQ==
X-Google-Smtp-Source: AGHT+IFaW8yosq7eXgU5Gc6ixe+t5OoMFDzd9ALlWaK2i0FIq5ANv/047xQ3jieIrkoM+LNIIf/M3FAlvs4RDccQ
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a05:600c:5029:b0:425:7ac6:96fe with
 SMTP id 5b1f17b1804b1-428e6a580dbmr582245e9.0.1722879239688; Mon, 05 Aug 2024
 10:33:59 -0700 (PDT)
Date: Mon,  5 Aug 2024 18:32:34 +0100
In-Reply-To: <20240805173234.3542917-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240805173234.3542917-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240805173234.3542917-12-vdonnefort@google.com>
Subject: [RFC PATCH 11/11] KVM: arm64: Add kselftest for tracefs hyp tracefs
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a test to validate the newly introduced tracefs interface for the
pKVM hypervisor. This test covers the usage of extended timestamp and
coherence of the tracing clock.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 1a576ef28b7f..4ed5fac75981 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -84,6 +84,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_enable_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_swap_reader_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_enable_event,
+	__KVM_HOST_SMCCC_FUNC___pkvm_selftest_event,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
index 0b98a87a1250..1c797b748ff2 100644
--- a/arch/arm64/include/asm/kvm_hypevents.h
+++ b/arch/arm64/include/asm/kvm_hypevents.h
@@ -28,4 +28,14 @@ HYP_EVENT(hyp_exit,
 	),
 	HE_PRINTK(" ")
 );
+
+#ifdef CONFIG_PROTECTED_NVHE_TESTING
+HYP_EVENT(selftest,
+	  HE_PROTO(void),
+	  HE_STRUCT(),
+	  HE_ASSIGN(),
+	  HE_PRINTK(" ")
+);
 #endif
+
+#endif /* __ARM64_KVM_HYPEVENTS_H_ */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 58f09370d17e..f3906cb733fe 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -65,4 +65,13 @@ config PROTECTED_NVHE_STACKTRACE
 
 	  If unsure, or not using protected nVHE (pKVM), say N.
 
+config PROTECTED_NVHE_TESTING
+	bool "Protected KVM hypervisor testing infrastructure"
+	depends on KVM
+	default n
+	help
+	  Say Y here to enable pKVM hypervisor testing infrastructure.
+
+	  If unsure, say N.
+
 endif # VIRTUALIZATION
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index f6119dbdcce1..f9991ba9744a 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -412,6 +412,19 @@ static void handle___pkvm_enable_event(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_enable_event(id, enable);
 }
 
+static void handle___pkvm_selftest_event(struct kvm_cpu_context *host_ctxt)
+{
+	int smc_ret = SMCCC_RET_NOT_SUPPORTED, ret = -EOPNOTSUPP;
+
+#ifdef CONFIG_PROTECTED_NVHE_TESTING
+	trace_selftest();
+	smc_ret = SMCCC_RET_SUCCESS;
+	ret = 0;
+#endif
+	cpu_reg(host_ctxt, 0) = smc_ret;
+	cpu_reg(host_ctxt, 1) = ret;
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -449,6 +462,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_enable_tracing),
 	HANDLE_FUNC(__pkvm_swap_reader_tracing),
 	HANDLE_FUNC(__pkvm_enable_event),
+	HANDLE_FUNC(__pkvm_selftest_event),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index d3a14ac8b3dd..143c7edf7d17 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -765,6 +765,36 @@ static const struct file_operations hyp_trace_fops = {
 	.release        = NULL,
 };
 
+#ifdef CONFIG_PROTECTED_NVHE_TESTING
+static int selftest_event_open(struct inode *inode, struct file *file)
+{
+	if (file->f_mode & FMODE_WRITE)
+		return kvm_call_hyp_nvhe(__pkvm_selftest_event);
+
+	return 0;
+}
+
+static ssize_t selftest_event_write(struct file *f, const char __user *buf,
+				    size_t cnt, loff_t *pos)
+{
+	return cnt;
+}
+
+static const struct file_operations selftest_event_fops = {
+	.open	= selftest_event_open,
+	.write	= selftest_event_write,
+	.llseek	= no_llseek,
+};
+
+static void hyp_trace_init_testing_tracefs(struct dentry *root)
+{
+	tracefs_create_file("selftest_event", TRACEFS_MODE_WRITE, root, NULL,
+			    &selftest_event_fops);
+}
+#else
+static void hyp_trace_init_testing_tracefs(struct dentry *root) { }
+#endif
+
 int hyp_trace_init_tracefs(void)
 {
 	struct dentry *root, *per_cpu_root;
@@ -818,6 +848,7 @@ int hyp_trace_init_tracefs(void)
 	}
 
 	hyp_trace_init_event_tracefs(root);
+	hyp_trace_init_testing_tracefs(root);
 
 	return 0;
 }
diff --git a/tools/testing/selftests/hyp-trace/Makefile b/tools/testing/selftests/hyp-trace/Makefile
new file mode 100644
index 000000000000..2a5b2e29667e
--- /dev/null
+++ b/tools/testing/selftests/hyp-trace/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+all:
+
+TEST_PROGS := hyp-trace-test
+
+include ../lib.mk
diff --git a/tools/testing/selftests/hyp-trace/config b/tools/testing/selftests/hyp-trace/config
new file mode 100644
index 000000000000..39cee8ec30fa
--- /dev/null
+++ b/tools/testing/selftests/hyp-trace/config
@@ -0,0 +1,4 @@
+CONFIG_FTRACE=y
+CONFIG_ARM64=y
+CONFIG_KVM=y
+CONFIG_PROTECTED_NVHE_TESTING=y
diff --git a/tools/testing/selftests/hyp-trace/hyp-trace-test b/tools/testing/selftests/hyp-trace/hyp-trace-test
new file mode 100644
index 000000000000..7f010fba385a
--- /dev/null
+++ b/tools/testing/selftests/hyp-trace/hyp-trace-test
@@ -0,0 +1,161 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0-only
+
+# hyp-trace-test - Tracefs for pKVM hypervisor test
+#
+# Copyright (C) 2024 - Google LLC
+# Author: Vincent Donnefort <vdonnefort@google.com>
+#
+
+log_and_die()
+{
+    echo "$1"
+
+    exit 1
+}
+
+host_clock()
+{
+    # BOOTTIME clock
+    awk '{print $1}' /proc/uptime
+}
+
+goto_hyp_trace()
+{
+    if [ -d "/sys/kernel/debug/tracing/hyp" ]; then
+        cd /sys/kernel/debug/tracing/hyp
+        return
+    fi
+
+    if [ -d "/sys/kernel/tracing/hyp" ]; then
+        cd /sys/kernel/tracing/hyp
+        return
+    fi
+
+    echo "ERROR: hyp tracing folder not found!"
+
+    exit 1
+}
+
+reset_hyp_trace()
+{
+    echo 0 > tracing_on
+    echo 0 > trace
+    for event in events/hyp/*; do
+        echo 0 > $event/enable
+    done
+}
+
+setup_hyp_trace()
+{
+    goto_hyp_trace
+
+    reset_hyp_trace
+
+    echo 16 > buffer_size_kb
+    echo 1 > events/hyp/selftest/enable
+    echo 1 > tracing_on
+}
+
+stop_hyp_trace()
+{
+    echo 0 > tracing_on
+}
+
+write_events()
+{
+    local num="$1"
+    local func="$2"
+
+    for i in $(seq 1 $num); do
+        echo 1 > selftest_event
+        [ -z "$func" -o $i -eq $num ] || eval $func
+    done
+}
+
+consuming_read()
+{
+    local output=$1
+
+    nohup cat trace_pipe > $output &
+
+    echo $!
+}
+
+run_test_consuming()
+{
+    local nr_events=$1
+    local func=$2
+    local tmp="$(mktemp)"
+    local start_ts=0
+    local end_ts=0
+    local pid=0
+
+    echo "Output trace file: $tmp"
+
+    setup_hyp_trace
+    pid=$(consuming_read $tmp)
+
+    start_ts=$(host_clock)
+    write_events $nr_events $func
+    stop_hyp_trace
+    end_ts=$(host_clock)
+
+    kill $pid
+    validate_test $tmp $nr_events $start_ts $end_ts
+
+    rm $tmp
+}
+
+validate_test()
+{
+    local output=$1
+    local expected_events=$2
+    local start_ts=$3
+    local end_ts=$4
+    local prev_ts=$3
+    local ts=0
+    local num_events=0
+
+    IFS=$'\n'
+    for line in $(cat $output); do
+        echo "$line" | grep -q -E "^# " && continue
+        ts=$(echo "$line" | awk '{print $2}' | cut -d ':' -f1)
+        if [ $(echo "$ts<$prev_ts" | bc) -eq 1 ]; then
+            log_and_die "Error event @$ts < $prev_ts"
+        fi
+        prev_ts=$ts
+        num_events=$((num_events + 1))
+    done
+
+    if [ $(echo "$ts>$end_ts" | bc) -eq 1 ]; then
+        log_and_die "Error event @$ts > $end_ts"
+    fi
+
+    if [ $num_events -ne $expected_events ]; then
+        log_and_die "Expected $expected_events events, got $num_events"
+    fi
+}
+
+test_base()
+{
+    echo "Test consuming read..."
+
+    run_test_consuming 1000
+
+    echo "done."
+}
+
+test_extended_ts()
+{
+    echo "Test Extended timestamp..."
+
+    run_test_consuming 1000 "sleep 0.1"
+
+    echo "done."
+}
+
+test_base
+test_extended_ts
+
+exit 0
-- 
2.46.0.rc2.264.g509ed76dc8-goog

