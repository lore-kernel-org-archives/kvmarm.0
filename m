Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFCF18890B
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 09:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726047079; cv=none; b=FlOBDSF74rWRXl1wH5kE2/ASU0Rb4g0DPDhNqlZu+BZbHHjBTUqxcBu1W+zvmk8hceIhlDopkSNoE/ykPOpKg8MtekPZmDpXsi84Pyegu7/bZnBlvtOyW18KKTtLfetMpqa4iw6XqI1ud7Ncajuyc2T/jrc9OX3zL92j9kzcfbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726047079; c=relaxed/simple;
	bh=nHH6U/9NK1NGegXj6WlTrXArnD2Ybi4HhEFmOD+lSEk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RHgbCQR1I/LLVrkWqKVddg0EL2VELA8cgMAXY/92+RtES8idimhq29WzwFRlI9v3hAJzSf1s/FpavDOrv3xzKDav6LL9IVo10mTaFc8Ih0DHfsvTlSkkZt83JVLL1KHhSx/YGz0UGJ6JNuWybYnZRL7KCOVt/vUHVDqW9lFJpVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o/FHP4DR; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o/FHP4DR"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3787ea79dceso3237856f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 02:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726047075; x=1726651875; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R0ql8FhOpfg6VpbbTG/ZwJ1DV871rVa0x5nxiQMVov8=;
        b=o/FHP4DRvOpFHq27li6a63XkiqSvzdOtSdvcL4/cKizt0kf63YZakM+RrhPFgy/lR5
         GRZpnfsetVraieRr09HUlXgoNw6h7aIeoIGVyrA+EvsaEVGUsgnaTByMx9dSNgxKdLS5
         HEYJwwmVPwjOL0jgTnbQF1ceEh6QUQnax/snXHAq2ENlvIvA8zKwDvypNDnb1izlMJpy
         EfdIG4SIoyQ/gDS0kcsYgJk1NMJpnXOrD+1po2bmK4YS9t4jMCaCOauaZqFn1ZW5wD8W
         nI0iosIl7SCEhRvxMAny+uH4uqFa4jQewwLYlsQ2DT9R7FpT40eqHXepn0doVUB9rkOs
         VTXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726047075; x=1726651875;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R0ql8FhOpfg6VpbbTG/ZwJ1DV871rVa0x5nxiQMVov8=;
        b=TSeAfs9rXzce1ucJKmwWpa1R2OjXCb2vUwWZItu/SvGoji/SNkBsGqVR4Kkr/gXOpY
         60mX5rHBG3TTaFde5sskdnVkc6jrjqBYZxIcpdYX32Zw7nSjn+fXsFxrTqFPiT6B9TyO
         W7fUVelsLtka58nzYDIUN+xms2U8kC0Kl3IGzNBz54pMNzfjDcJ2RzfZ6JVPBzWoocL/
         hV3D32DUedRpS3inbmxNvFt/kc9VvTuOwFgQcgRlo7nKR3LU7XSJgFpo9HeUzN+jXZYW
         CsrFbR0MsNVnrRNlny5VXamLlgrTnKIhCc+u/pKxv24fzSdxyvYXuKV52+BcE8bFkSQZ
         db8g==
X-Gm-Message-State: AOJu0YxHWQFWZJ473HrRjITY4NIqWveahBv6FnVEGW1vd1N77LAdv1Z4
	ArcjCuDS7QfCd+2KELDDGsykxfhIt1hqH5XNuKerMko4IMgzQAeG7eF6XPWTvP3JuJFmwhs17Fm
	VF3ABLPoBXgLRZACzBA==
X-Google-Smtp-Source: AGHT+IHT7JcnsHOxG+44WSeWAc4200KmqhzTuuadsLCqKhH/XiIelY9/9nsYaSZQ0k9teOOJUozUOlVOw5AEwKK6
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:adf:ec8c:0:b0:374:bf86:57a2 with SMTP
 id ffacd0b85a97d-378896eab80mr20744f8f.11.1726047074846; Wed, 11 Sep 2024
 02:31:14 -0700 (PDT)
Date: Wed, 11 Sep 2024 10:30:29 +0100
In-Reply-To: <20240911093029.3279154-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911093029.3279154-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911093029.3279154-14-vdonnefort@google.com>
Subject: [PATCH 13/13] KVM: arm64: Add kselftest for tracefs hyp tracefs
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a test to validate the newly introduced tracefs interface for the
pKVM hypervisor. This test covers the usage of extended timestamp and
coherence of the tracing clock.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 3710deb6eaa0..be7d4d2434e7 100644
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
index 8304eb342be9..c7ae07a88875 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -66,4 +66,13 @@ config PROTECTED_NVHE_STACKTRACE
 
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
index f9983d4a8d4c..2c040585fdd2 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -431,6 +431,19 @@ static void handle___pkvm_enable_event(struct kvm_cpu_context *host_ctxt)
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
@@ -470,6 +483,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_reset_tracing),
 	HANDLE_FUNC(__pkvm_swap_reader_tracing),
 	HANDLE_FUNC(__pkvm_enable_event),
+	HANDLE_FUNC(__pkvm_selftest_event),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 292f7abc23f4..356ce3042936 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -887,6 +887,36 @@ static int hyp_trace_clock_show(struct seq_file *m, void *v)
 }
 DEFINE_SHOW_ATTRIBUTE(hyp_trace_clock);
 
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
@@ -945,6 +975,7 @@ int hyp_trace_init_tracefs(void)
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
2.46.0.598.g6f2099f65c-goog

