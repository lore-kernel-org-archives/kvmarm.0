Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DF41F8EED
	for <kvmarm@lists.linux.dev>; Wed,  8 Jan 2025 11:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736336790; cv=none; b=bLRqQINE+ne7xrl4vxoy9l545VqUB5IB+pt3sxhBChv1R4lyBQSbgJdf08cU9W+s3AVummEh+xnvcyv2197T9V6YL+NS6cOl01Vseps5vx8J9ZXfaK6IpmXE5SzJeMB4dV4g5kkV4kwQ2Eu7uClXU3SWwd9su7DYPWI4HWmMoag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736336790; c=relaxed/simple;
	bh=1RhNgAyBYwnY1lmaJpGPMJ1Z7wtx/NBVUARf1zLmbsk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rQ+DERLrOqYshGnf80UoXd50lQcTNLitATMv9kagtoUSq7owPs2pLVm70eFUb0DFk1BZTRfrr2I9r2eNeABY8hu+VHUegYEhx0EKjsegMSaJZU2GdgBSFY644ZEnKb3hUpKhk1AcfOIzmeuoBTNoRf/jhfBNZjQH5fjI4i9RNPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m9RuiDSU; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m9RuiDSU"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4361c040ba8so53254815e9.1
        for <kvmarm@lists.linux.dev>; Wed, 08 Jan 2025 03:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736336787; x=1736941587; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QbQ/1nIXXwGxfAoTE/TC8PTd45WcqY21w+/Qgwgx3q8=;
        b=m9RuiDSUmgGyQLeOfyHAeMD9QQfBct/qRjjpRbsfxmWBbaxCw+OpoDMxyf2/fz5z/D
         buB/C2DAu32G21ykxXk4FX2fquuD2nuz/nG8ts4QX5lsVVNCACHqkqOve5E5TwlYacKh
         e0Nnmz0RKaYx2H3YJLSdg6U/uMZOY1F54GTVqve1nxwDd+F8qWvlj4653u8VloJsQgLN
         NAS/2JeyaYJNeWL37bG3ocMVMIv4JuXzNJW7pgifJx62GKhFuzTlHYh8ZhKaUwkal3/f
         rHbPViAGk1ZdrWd89nZXnUaUej+bu/wxxpYFFePMgmQq+dx4RFQkUBq8ML8w6ANJOy5P
         ijJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736336787; x=1736941587;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QbQ/1nIXXwGxfAoTE/TC8PTd45WcqY21w+/Qgwgx3q8=;
        b=NG8ubcGmC1xD0cpdBdVYRD8snJ9AO8upqR7Rc0XYUmivw1m2G3JGnsPz9cnWyF4VCD
         L1WVLHnZ2Ba49IV9aB6Wqpvp0+y44sov3fhkGXkTkJ/0uayjnPCYYAU48tEZjtV0DLJX
         2G7R7ImLUShjo435qwVDnPTxCDP0jLdcb1AkdLgueMZ8zvLJxXjMtVilkZ4DyaTHsim7
         JFc+sa4K4dd3EPEwWlPtJSTE2vSErikfzhkT9LAWhorfrqJsuN7c5OSOO8DPSFsojpCw
         cy1hDrzrYAWo2GvbRsw0FUXGFqolLK5+9UktKqI8fChLQnUDTFLWhMS2daTOOuUPg8WS
         owPg==
X-Gm-Message-State: AOJu0YzgrfsQA0pbyK0aaXkjhxhsOL1Aj9xsXVf35AaW6GTP1k2mRp4k
	MrObdXVAK1pDoZ6jXJ/WXAvdFzNNB5bzX8Ty3g+PhvJdgg0EgZx+us9BeDK/Ftt+48yy6OZfInM
	Suw1aDTA2DgvTeRC+pg==
X-Google-Smtp-Source: AGHT+IGmtxuQJ5R7JETfm1bouxcxdHJ+CL6MhsFC4RluXUZnyO+yUdelUMuFT12Ogzt7f0uODwAj8yN9o62sPdo3
X-Received: from wmbbh17.prod.google.com ([2002:a05:600c:3d11:b0:436:3ea:c491])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c98:b0:434:a04f:2557 with SMTP id 5b1f17b1804b1-436e266e802mr19136005e9.4.1736336787077;
 Wed, 08 Jan 2025 03:46:27 -0800 (PST)
Date: Wed,  8 Jan 2025 11:45:36 +0000
In-Reply-To: <20250108114536.627715-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250108114536.627715-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250108114536.627715-13-vdonnefort@google.com>
Subject: [PATCH v2 12/12] KVM: arm64: Add kselftest for tracefs hyp tracefs
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
pKVM hypervisor. This test covers the usage of extended timestamp and
coherence of the tracing clock.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 784f6b3ae892..60c42661d179 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -86,6 +86,7 @@ enum __kvm_host_smccc_func {
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
index 1920af496952..406b456d09c8 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -436,6 +436,19 @@ static void handle___pkvm_enable_event(struct kvm_cpu_context *host_ctxt)
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
@@ -474,6 +487,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_reset_tracing),
 	HANDLE_FUNC(__pkvm_swap_reader_tracing),
 	HANDLE_FUNC(__pkvm_enable_event),
+	HANDLE_FUNC(__pkvm_selftest_event),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index fef082559a19..ac36f0b56fc2 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -895,6 +895,35 @@ static int hyp_trace_clock_show(struct seq_file *m, void *v)
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
@@ -953,6 +982,7 @@ int hyp_trace_init_tracefs(void)
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
new file mode 100755
index 000000000000..868eb81bfb77
--- /dev/null
+++ b/tools/testing/selftests/hyp-trace/hyp-trace-test
@@ -0,0 +1,254 @@
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
+    write_events 5
+    echo 0 > trace
+    write_events 5
+
+    pid=$(consuming_read $tmp)
+    sleep 1
+    stop_hyp_trace
+    kill $pid
+
+    validate_test $tmp 5 0 $(host_clock)
+
+    rm $tmp
+
+    echo "done."
+}
+
+test_big_bpacking()
+{
+    local hyp_buffer_page_size=48
+    local page_size=$(page_size)
+    local min_buf_size=$(echo "$page_size * $page_size / ($hyp_buffer_page_size * $(nproc))" | bc)
+
+    min_buf_size=$(echo "$min_buf_size * 2 / 1024" | bc)
+
+    echo "Test loading $min_buf_size kB buffer..."
+
+    reset_hyp_trace
+    echo $min_buf_size > buffer_size_kb
+    echo 1 > tracing_on
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
2.47.1.613.gc27f4b7a9f-goog

