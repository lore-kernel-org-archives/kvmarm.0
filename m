Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5354B23BD1B
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 12:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740399350; cv=none; b=jlYmU2GPbf9n7bZ+QrKlusitttCPqSWiA3QhisY627JzcgSUyzLOZVHey5+MkNPRZcDNzwvu4fsBoZaxaYxLgLesg5Uya0Za7Am60magjX/uhuhlH9XBrHTyi7Ml/NSv2ZLf4Rdf/yH5fx6bGdHj7Nsp9cjcvu+0ugJQqUZ4WqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740399350; c=relaxed/simple;
	bh=73xFST6IcyWSU4ybz4NXXeeLlo1YTFKR59MBsdv/5AM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lSNFzBoTncqN8X8ZslWN0RQkpNSd/BQZmWCoKwy6LiT0ysv34+JSDDniJXMe0q1piUsHIje5NeATmLMrz//cD2EC+oKE2s05EwSMuEuj4wTkALAmTVQ5cguRaGiFeXXVo1sYyAcJ1IBJvDXdT/0WI+9sR82g4gnY5RvQG/CauIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VXl8L0ug; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VXl8L0ug"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43998ec3733so21964845e9.2
        for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 04:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740399347; x=1741004147; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9CAntV7cf9FOGSVoXQbvcHO1SNXeVU07stlk2XXrAaE=;
        b=VXl8L0ugmCSHJSW9/XxtSMhrQ526qjw4cRbbFQSmw3VhDuXGCJyV7d4b1M2AFGOQAU
         GHswreH2EIagVJvvc5IlZU1xqt64l4qfX76I2YrMTlvy3t+iGvNK4BxJKWoDICRHTmKu
         emjQF4nzK8a5wp1fn1Wt91g7vrVfAJZwbWgYIeDrJOkoQVg+mFwFSdFBxzzg2WkOMrZH
         oBNThv8BFBsIFhGVPlRwDhVzK4eXz1ydPI0Wsn4+0Jgvv/uH+LqO75M9T38x08E60HJH
         fm0su59CiH8QxL5eLOLlEX4Wobh4N1UdxvLJn7vBof4I5fsjmpsVOz6xdYuJjgxL/GLI
         T6hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740399347; x=1741004147;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9CAntV7cf9FOGSVoXQbvcHO1SNXeVU07stlk2XXrAaE=;
        b=UKTWI1411Jtu7qNfiYVRlY4T7OEhUbPR6Di56BGgFzCjAm5FAWUxoJ99rhtIHR9oCE
         nmXZUPVtPE4UoQ0b4boCTiLOmxSUqeaXsd63/P7CuL5if6r18PE22UCRVZUsalvSqRLU
         chNH6xwWZvdPsZgSobyqjHCEG9MmOCcsUJ37bjFUk91Z/QXLFr/ntrc9kF5Fn9Jly+FT
         AkPJR+WmI+B8ughfFalsn3WpVnpoCEUUwyuepzHWEk8oBgDFbfhxIe1WngaJkLljwry6
         uG7DC/N4FShc/+3rpudOP6MHLPhBZGrnwIa94OK+PywOFUXwzMznz9AM3MTbvo0cdOVk
         SYhQ==
X-Gm-Message-State: AOJu0YzFvy3Oe0joCiAkk1s1FsfBjiLunPKfosP2GDupueB4iP3OaJVk
	IsWnQBDSHkUYA91pz904M6GcfnK3jUGNZIUHP/kDJUtRcUwWv77Y2qM9dGOjm3aESbzAdCqV07J
	Qt/hRN/84SUheNHhC+w==
X-Google-Smtp-Source: AGHT+IF9r3S0MEV0pAXIHdPmAlcUav0RqTDnvruMkd3+nrJooxI1n1GLlFqOTkZUvY5CUW1Km7zrrpubG9E1i1Nk
X-Received: from wmqe19.prod.google.com ([2002:a05:600c:4e53:b0:439:831e:ca7c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:468e:b0:439:9b3f:2de1 with SMTP id 5b1f17b1804b1-439ae1f199cmr103370945e9.15.1740399346852;
 Mon, 24 Feb 2025 04:15:46 -0800 (PST)
Date: Mon, 24 Feb 2025 12:13:53 +0000
In-Reply-To: <20250224121353.98697-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250224121353.98697-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250224121353.98697-12-vdonnefort@google.com>
Subject: [PATCH 11/11] KVM: arm64: Add kselftest for tracefs hyp tracefs
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a test to validate the newly introduced tracefs interface for the
pKVM hypervisor. Covers buffer reset, loading/unloading, extended
timestamp and coherence of the tracing clock.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index afeb983ca97b..c798bd6ad27e 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -94,6 +94,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_reset_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_swap_reader_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_enable_event,
+	__KVM_HOST_SMCCC_FUNC___pkvm_selftest_event,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
index 0b98a87a1250..25d8e23a3cc6 100644
--- a/arch/arm64/include/asm/kvm_hypevents.h
+++ b/arch/arm64/include/asm/kvm_hypevents.h
@@ -28,4 +28,14 @@ HYP_EVENT(hyp_exit,
 	),
 	HE_PRINTK(" ")
 );
+
+#ifdef CONFIG_PKVM_SELFTESTS
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
index ead632ad01b4..fff9d24d7771 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -46,6 +46,7 @@ menuconfig KVM
 config NVHE_EL2_DEBUG
 	bool "Debug mode for non-VHE EL2 object"
 	depends on KVM
+	select PKVM_SELFTESTS
 	help
 	  Say Y here to enable the debug mode for the non-VHE KVM EL2 object.
 	  Failure reports will BUG() in the hypervisor. This is intended for
@@ -83,4 +84,13 @@ config PTDUMP_STAGE2_DEBUGFS
 
 	  If in doubt, say N.
 
+config PKVM_SELFTESTS
+	bool "Protected KVM hypervisor selftests"
+	depends on KVM
+	default n
+	help
+	  Say Y here to enable pKVM hypervisor testing infrastructure.
+
+	  If unsure, say N.
+
 endif # VIRTUALIZATION
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 96dde58f4984..8f0dafaab568 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -628,6 +628,19 @@ static void handle___pkvm_enable_event(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_enable_event(id, enable);
 }
 
+static void handle___pkvm_selftest_event(struct kvm_cpu_context *host_ctxt)
+{
+	int smc_ret = SMCCC_RET_NOT_SUPPORTED, ret = -EOPNOTSUPP;
+
+#ifdef CONFIG_PKVM_SELFTESTS
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
@@ -674,6 +687,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_reset_tracing),
 	HANDLE_FUNC(__pkvm_swap_reader_tracing),
 	HANDLE_FUNC(__pkvm_enable_event),
+	HANDLE_FUNC(__pkvm_selftest_event),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index cb63af69c38d..1e887e430c42 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -892,6 +892,35 @@ static int hyp_trace_clock_show(struct seq_file *m, void *v)
 }
 DEFINE_SHOW_ATTRIBUTE(hyp_trace_clock);
 
+#ifdef CONFIG_PKVM_SELFTESTS
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
@@ -950,6 +979,7 @@ int hyp_trace_init_tracefs(void)
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
index 000000000000..135657ef550d
--- /dev/null
+++ b/tools/testing/selftests/hyp-trace/config
@@ -0,0 +1,4 @@
+CONFIG_FTRACE=y
+CONFIG_ARM64=y
+CONFIG_KVM=y
+CONFIG_PKVM_SELFTESTS=y
diff --git a/tools/testing/selftests/hyp-trace/hyp-trace-test b/tools/testing/selftests/hyp-trace/hyp-trace-test
new file mode 100755
index 000000000000..9be0c5f57160
--- /dev/null
+++ b/tools/testing/selftests/hyp-trace/hyp-trace-test
@@ -0,0 +1,264 @@
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
+    awk '/now/ { printf "%.6f\n", $3 / 1000000000 }' /proc/timer_list
+}
+
+page_size()
+{
+    echo "$(awk '/KernelPageSize/ {print $2; exit}' /proc/self/smaps) * 1024" | bc
+}
+
+goto_hyp_trace()
+{
+    if [ -d "/sys/kernel/debug/tracing/hypervisor" ]; then
+        cd /sys/kernel/debug/tracing/hypervisor
+        return
+    fi
+
+    if [ -d "/sys/kernel/tracing/hypervisor" ]; then
+        cd /sys/kernel/tracing/hypervisor
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
+    for event in events/hypervisor/*; do
+        echo 0 > $event/enable
+    done
+
+    assert_unloaded
+}
+
+setup_hyp_trace()
+{
+    reset_hyp_trace
+
+    echo 16 > buffer_size_kb
+    echo 1 > events/hypervisor/selftest/enable
+    echo 1 > tracing_on
+}
+
+stop_hyp_trace()
+{
+    echo 0 > tracing_on
+}
+
+hyp_trace_loaded()
+{
+    grep -q "(loaded)" buffer_size_kb
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
+    cat trace_pipe > $output &
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
+test_ts()
+{
+    echo "Test Timestamps..."
+
+    run_test_consuming 1000
+
+    echo "done."
+}
+
+test_extended_ts()
+{
+    echo "Test Extended Timestamps..."
+
+    run_test_consuming 1000 "sleep 0.1"
+
+    echo "done."
+}
+
+assert_loaded()
+{
+    hyp_trace_loaded || log_and_die "Expected loaded buffer"
+}
+
+assert_unloaded()
+{
+    ! hyp_trace_loaded || log_and_die "Expected unloaded buffer"
+}
+
+test_unloading()
+{
+    local tmp="$(mktemp)"
+
+    echo "Test unloading..."
+
+    setup_hyp_trace
+    assert_loaded
+
+    echo 0 > tracing_on
+    assert_unloaded
+
+    pid=$(consuming_read $tmp)
+    sleep 1
+    assert_loaded
+    kill $pid
+    assert_unloaded
+
+    echo 1 > tracing_on
+    write_events 1
+    echo 0 > trace
+    assert_loaded
+    echo 0 > tracing_on
+    assert_unloaded
+
+    echo "done."
+}
+
+test_reset()
+{
+    local tmp="$(mktemp)"
+
+    echo "Test Reset..."
+
+    setup_hyp_trace
+    write_events 1000
+    echo 0 > trace
+    clock_before=$(host_clock)
+    write_events 5
+
+    pid=$(consuming_read $tmp)
+    sleep 1
+    stop_hyp_trace
+    kill $pid
+
+    validate_test $tmp 5 $clock_before $(host_clock)
+
+    rm $tmp
+
+    echo "done."
+}
+
+test_big_bpacking()
+{
+    local hyp_buffer_page_size=40
+    local page_size=$(page_size)
+    local min_buf_size
+
+    # Number of ring-buffer pages stored in a single bpacking page
+    min_buf_size=$(echo "$page_size / ($hyp_buffer_page_size * $(nproc))" | bc)
+    # Size of the ring-buffer to fill a single bpacking page
+    min_buf_size=$(echo "$page_size * $min_buf_size" | bc)
+    # Size in kiB of the ring-buffer to fill an order-1 bpacking page
+    min_buf_size=$(echo "$min_buf_size * 2 / 1024" | bc)
+
+    echo "Test loading $min_buf_size kB buffer..."
+
+    reset_hyp_trace
+
+    echo $min_buf_size > buffer_size_kb
+    echo 1 > tracing_on
+    assert_loaded
+
+    stop_hyp_trace
+
+    echo "done."
+}
+
+goto_hyp_trace
+
+test_reset
+test_unloading
+test_big_bpacking
+test_ts
+test_extended_ts
+
+exit 0
-- 
2.48.1.601.g30ceb7b040-goog

