Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC613446D3
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 15:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771513420; cv=none; b=Vg7VAY8Qp1QEllpsQGPMTehl31xuP5Vgf1dM9fayNCLlloPIrjWrAfB9/0miwoFNsvSUvWLehj6pjaA+8C/IfPZXO+QNmfJzXvJjz+Xd+2ku6PSNNgdcOlENavPNU1J/L5pwy2opJ/XmZiwVtz8wuGf+X45jwiM0S2weu2VlLaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771513420; c=relaxed/simple;
	bh=qycVq9exA6mLWPP8keygKmCRQgbn9lw2EkQS3r2m1Nw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rcE7FeZAEa8QHYMkf8OPfLlNHz6IZVysLgR2qSVUHB8S3n5SVa0GEPbdBS6Pc4hWBB2X9Wy55GPoEynBoadjABkH8FF6UzjJVsp6ZM8FPlFK21TMkL69KMxUKalxGfouMzbECCE8M21zHSj0/9kNKSivvmxtJDwJaeGYXnIsrb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rQayTwY4; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rQayTwY4"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b8861544696so153828566b.3
        for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 07:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771513416; x=1772118216; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SorlUulsd+U5Uq7YRCISY/t3U+DY0uXrDLjkkMFRG3w=;
        b=rQayTwY4x6gFr91CTLWiW/WCeZpLMT6uzfuxF9bJlffpixzrsjQ9kEkbEiuQSVFKqI
         xVQgpAw9dy3dJu3UveS0IIC9XHmB2W/YFRIp81zkHwpGFDRsq29WOsELSYf5HfvADsuU
         nh4/cDoNaHnjXNwppn/asAVNRVfTREBs6Jw74dBqQkfvlV1FyCU3dD/azgAT+CAH5gXk
         X+n5HKmpNeDraiScH48JOwiJKxxo3DxrImZiI4PNrTq3G5RARKx4xPgPEtjHTKKbesHG
         YfrpCTvW9fxYaJ0+1d/PQdRaGp6vjz/c4mGPwcsxWpLr6Nnu+Dz0O3VW+cqEdSniHEfE
         l67w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771513416; x=1772118216;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SorlUulsd+U5Uq7YRCISY/t3U+DY0uXrDLjkkMFRG3w=;
        b=FIbYRnMDee+gLJ7TKya6s0CJVB1qOVMfnZq1xLukn47PRwjH/OYWpNUZVkL6R76E4j
         bGaJeS6CbRHe58cZtsMRRNTnng3OiZ6EZV+wLRHq/uagZ+YmG3j4uIrwsoJencN36eIe
         o24vHub9lFEx1geb/Qs1FtCt4bUo6ljbm5QnEQU2rT5hOa48B5dKNh1rT5/0876cm6GH
         RzrrNUYuaNpz9pPz5kxTSL9OKaMVOW7o5vySmPMZkUGWvt6xlRpN6XB+vLhUyXritCvX
         NjpOTp1I5rvfMU6yqZct0WZZ6TOoc5Adv+H4boiJfYNbJM3R2DhNyX+B5FU7Z00h0R1a
         zLAw==
X-Gm-Message-State: AOJu0YxO2rVjxwXAK5yFqL2iJF1eFtGUOHLfI4WHMqEg5rVRRURzjcaY
	qKqnrHTVUFlDp4yBlFvDJpDoTAKF8w5FhOgsgPTPsB7n+A+Ei7KbgG2C9yJ3OSJ+GVn/BBNtgMq
	Lo4Nv3HzWC1R3vLwar6gJyg==
X-Received: from ejbqh28.prod.google.com ([2002:a17:906:ecbc:b0:b8f:aa0f:8067])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:6a10:b0:b43:b7ec:b8a1 with SMTP id a640c23a62f3a-b904d8a49f6mr218865166b.24.1771513416080;
 Thu, 19 Feb 2026 07:03:36 -0800 (PST)
Date: Thu, 19 Feb 2026 15:02:52 +0000
In-Reply-To: <20260219150307.14538-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260219150307.14538-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.335.g19a08e0c02-goog
Message-ID: <20260219150307.14538-16-vdonnefort@google.com>
Subject: [PATCH v12 15/30] tracing: selftests: Add trace remote tests
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Exercise the tracefs interface for trace remote with a set of tests to
check:

  * loading/unloading (unloading.tc)
  * reset (reset.tc)
  * size changes (buffer_size.tc)
  * consuming read (trace_pipe.tc)
  * non-consuming read (trace.tc)

Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-kselftest@vger.kernel.org
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/tools/testing/selftests/ftrace/test.d/remotes/buffer_size.tc b/tools/testing/selftests/ftrace/test.d/remotes/buffer_size.tc
new file mode 100644
index 000000000000..1a43280ffa97
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/buffer_size.tc
@@ -0,0 +1,25 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test trace remote buffer size
+# requires: remotes/test
+
+. $TEST_DIR/remotes/functions
+
+test_buffer_size()
+{
+    echo 0 > tracing_on
+    assert_unloaded
+
+    echo 4096 > buffer_size_kb
+    echo 1 > tracing_on
+    assert_loaded
+
+    echo 0 > tracing_on
+    echo 7 > buffer_size_kb
+}
+
+if [ -z "$SOURCE_REMOTE_TEST" ]; then
+    set -e
+    setup_remote_test
+    test_buffer_size
+fi
diff --git a/tools/testing/selftests/ftrace/test.d/remotes/functions b/tools/testing/selftests/ftrace/test.d/remotes/functions
new file mode 100644
index 000000000000..97a09d564a34
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/functions
@@ -0,0 +1,88 @@
+# SPDX-License-Identifier: GPL-2.0
+
+setup_remote()
+{
+	local name=$1
+
+	[ -e $TRACING_DIR/remotes/$name/write_event ] || exit_unresolved
+
+	cd remotes/$name/
+	echo 0 > tracing_on
+	clear_trace
+	echo 7 > buffer_size_kb
+	echo 0 > events/enable
+	echo 1 > events/$name/selftest/enable
+	echo 1 > tracing_on
+}
+
+setup_remote_test()
+{
+	[ -d $TRACING_DIR/remotes/test/ ] || modprobe remote_test || exit_unresolved
+
+	setup_remote "test"
+}
+
+assert_loaded()
+{
+	grep -q "(loaded)" buffer_size_kb
+}
+
+assert_unloaded()
+{
+	grep -q "(unloaded)" buffer_size_kb
+}
+
+dump_trace_pipe()
+{
+    output=$(mktemp $TMPDIR/remote_test.XXXXXX)
+    cat trace_pipe > $output &
+    pid=$!
+    sleep 1
+    kill -1 $pid
+
+    echo $output
+}
+
+check_trace()
+{
+	start_id="$1"
+	end_id="$2"
+	file="$3"
+
+	# Ensure the file is not empty
+	test -n "$(head $file)"
+
+	prev_ts=0
+	id=0
+
+	# Only keep <timestamp> <id>
+	tmp=$(mktemp $TMPDIR/remote_test.XXXXXX)
+	sed -e 's/\[[0-9]*\]\s*\([0-9]*.[0-9]*\): [a-z]* id=\([0-9]*\)/\1 \2/' $file > $tmp
+
+	while IFS= read -r line; do
+		ts=$(echo $line | cut -d ' ' -f 1)
+		id=$(echo $line | cut -d ' ' -f 2)
+
+		test $(echo "$ts>$prev_ts" | bc) -eq 1
+		test $id -eq $start_id
+
+		prev_ts=$ts
+		start_id=$((start_id + 1))
+	done < $tmp
+
+	test $id -eq $end_id
+	rm $tmp
+}
+
+get_cpu_ids()
+{
+    sed -n 's/^processor\s*:\s*\([0-9]\+\).*/\1/p' /proc/cpuinfo
+}
+
+get_page_size() {
+    sed -ne 's/^.*data.*size:\([0-9][0-9]*\).*/\1/p' events/header_page
+}
+
+get_selftest_event_size() {
+    sed -ne 's/^.*field:.*;.*size:\([0-9][0-9]*\);.*/\1/p' events/*/selftest/format | awk '{s+=$1} END {print s}'
+}
diff --git a/tools/testing/selftests/ftrace/test.d/remotes/reset.tc b/tools/testing/selftests/ftrace/test.d/remotes/reset.tc
new file mode 100644
index 000000000000..4d176349b2bc
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/reset.tc
@@ -0,0 +1,90 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test trace remote reset
+# requires: remotes/test
+
+. $TEST_DIR/remotes/functions
+
+check_reset()
+{
+    write_event_path="write_event"
+    taskset=""
+
+    clear_trace
+
+    # Is the buffer empty?
+    output=$(dump_trace_pipe)
+    test $(wc -l $output | cut -d ' ' -f1) -eq 0
+
+    if $(echo $(pwd) | grep -q "per_cpu/cpu"); then
+        write_event_path="../../write_event"
+        cpu_id=$(echo $(pwd) | sed -e 's/.*per_cpu\/cpu//')
+        taskset="taskset -c $cpu_id"
+    fi
+    rm $output
+
+    # Can we properly write a new event?
+    $taskset echo 7890 > $write_event_path
+    output=$(dump_trace_pipe)
+    test $(wc -l $output | cut -d ' ' -f1) -eq 1
+    grep -q "id=7890" $output
+    rm $output
+}
+
+test_global_interface()
+{
+    output=$(mktemp $TMPDIR/remote_test.XXXXXX)
+
+    # Confidence check
+    echo 123456 > write_event
+    output=$(dump_trace_pipe)
+    grep -q "id=123456" $output
+    rm $output
+
+    # Reset single event
+    echo 1 > write_event
+    check_reset
+
+    # Reset lost events
+    for i in $(seq 1 10000); do
+        echo 1 > write_event
+    done
+    check_reset
+}
+
+test_percpu_interface()
+{
+    [ "$(get_cpu_ids | wc -l)" -ge 2 ] || return 0
+
+    for cpu in $(get_cpu_ids); do
+        taskset -c $cpu echo 1 > write_event
+    done
+
+    check_non_empty=0
+    for cpu in $(get_cpu_ids); do
+        cd per_cpu/cpu$cpu/
+
+        if [ $check_non_empty -eq 0 ]; then
+            check_reset
+            check_non_empty=1
+        else
+            # Check we have only reset 1 CPU
+            output=$(dump_trace_pipe)
+            test $(wc -l $output | cut -d ' ' -f1) -eq 1
+            rm $output
+        fi
+        cd -
+    done
+}
+
+test_reset()
+{
+    test_global_interface
+    test_percpu_interface
+}
+
+if [ -z "$SOURCE_REMOTE_TEST" ]; then
+    set -e
+    setup_remote_test
+    test_reset
+fi
diff --git a/tools/testing/selftests/ftrace/test.d/remotes/trace.tc b/tools/testing/selftests/ftrace/test.d/remotes/trace.tc
new file mode 100644
index 000000000000..170f7648732a
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/trace.tc
@@ -0,0 +1,127 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test trace remote non-consuming read
+# requires: remotes/test
+
+. $TEST_DIR/remotes/functions
+
+test_trace()
+{
+	echo 0 > tracing_on
+    assert_unloaded
+
+    echo 7 > buffer_size_kb
+    echo 1 > tracing_on
+    assert_loaded
+
+    # Simple test: Emit few events and try to read them
+    for i in $(seq 1 8); do
+        echo $i > write_event
+    done
+
+    check_trace 1 8 trace
+
+    #
+    # Test interaction with consuming read
+    #
+
+    cat trace_pipe > /dev/null &
+    pid=$!
+
+    sleep 1
+    kill $pid
+
+    test $(wc -l < trace) -eq 0
+
+    for i in $(seq 16 32); do
+        echo $i > write_event
+    done
+
+    check_trace 16 32 trace
+
+    #
+    # Test interaction with reset
+    #
+
+    echo 0 > trace
+
+    test $(wc -l < trace) -eq 0
+
+    for i in $(seq 1 8); do
+        echo $i > write_event
+    done
+
+    check_trace 1 8 trace
+
+    #
+    # Test interaction with lost events
+    #
+
+    # Ensure the writer is not on the reader page by reloading the buffer
+    echo 0 > tracing_on
+    echo 0 > trace
+    assert_unloaded
+    echo 1 > tracing_on
+    assert_loaded
+
+    # Ensure ring-buffer overflow by emitting events from the same CPU
+    for cpu in $(get_cpu_ids); do
+        break
+    done
+
+    events_per_page=$(($(get_page_size) / $(get_selftest_event_size))) # Approx: does not take TS into account
+    nr_events=$(($events_per_page * 2))
+    for i in $(seq 1 $nr_events); do
+        taskset -c $cpu echo $i > write_event
+    done
+
+    id=$(sed -n -e '1s/\[[0-9]*\]\s*[0-9]*.[0-9]*: [a-z]* id=\([0-9]*\)/\1/p' trace)
+    test $id -ne 1
+
+    check_trace $id $nr_events trace
+
+    #
+    # Test per-CPU interface
+    #
+    echo 0 > trace
+
+    for cpu in $(get_cpu_ids) ; do
+        taskset -c $cpu echo $cpu > write_event
+    done
+
+    for cpu in $(get_cpu_ids); do
+        cd per_cpu/cpu$cpu/
+
+        check_trace $cpu $cpu trace
+
+        cd - > /dev/null
+    done
+
+    #
+    # Test with hotplug
+    #
+
+    [ "$(get_cpu_ids | wc -l)" -ge 2 ] || return 0
+
+    echo 0 > trace
+
+    for cpu in $(get_cpu_ids); do
+        echo 0 > /sys/devices/system/cpu/cpu$cpu/online || return 0
+        break
+    done
+
+    for i in $(seq 1 8); do
+        echo $i > write_event
+    done
+
+    check_trace 1 8 trace
+
+    echo 1 > /sys/devices/system/cpu/cpu$cpu/online
+}
+
+if [ -z "$SOURCE_REMOTE_TEST" ]; then
+    set -e
+
+    setup_remote_test
+    test_trace
+fi
diff --git a/tools/testing/selftests/ftrace/test.d/remotes/trace_pipe.tc b/tools/testing/selftests/ftrace/test.d/remotes/trace_pipe.tc
new file mode 100644
index 000000000000..669a7288ed7c
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/trace_pipe.tc
@@ -0,0 +1,127 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test trace remote consuming read
+# requires: remotes/test
+
+. $TEST_DIR/remotes/functions
+
+test_trace_pipe()
+{
+    echo 0 > tracing_on
+    assert_unloaded
+
+    # Emit events from the same CPU
+    for cpu in $(get_cpu_ids); do
+        break
+    done
+
+    #
+    # Simple test: Emit enough events to fill few pages
+    #
+
+    echo 1024 > buffer_size_kb
+    echo 1 > tracing_on
+    assert_loaded
+
+    events_per_page=$(($(get_page_size) / $(get_selftest_event_size)))
+    nr_events=$(($events_per_page * 4))
+
+    output=$(mktemp $TMPDIR/remote_test.XXXXXX)
+
+    cat trace_pipe > $output &
+    pid=$!
+
+    for i in $(seq 1 $nr_events); do
+        taskset -c $cpu echo $i > write_event
+    done
+
+    echo 0 > tracing_on
+    sleep 1
+    kill $pid
+
+    check_trace 1 $nr_events $output
+
+    rm $output
+
+    #
+    # Test interaction with lost events
+    #
+
+    assert_unloaded
+    echo 7 > buffer_size_kb
+    echo 1 > tracing_on
+    assert_loaded
+
+    nr_events=$((events_per_page * 2))
+    for i in $(seq 1 $nr_events); do
+        taskset -c $cpu echo $i > write_event
+    done
+
+    output=$(dump_trace_pipe)
+
+    lost_events=$(sed -n -e '1s/CPU:.*\[LOST \([0-9]*\) EVENTS\]/\1/p' $output)
+    test -n "$lost_events"
+
+    id=$(sed -n -e '2s/\[[0-9]*\]\s*[0-9]*.[0-9]*: [a-z]* id=\([0-9]*\)/\1/p' $output)
+    test "$id" -eq $(($lost_events + 1))
+
+    # Drop [LOST EVENTS] line
+    sed -i '1d' $output
+
+    check_trace $id $nr_events $output
+
+    rm $output
+
+    #
+    # Test per-CPU interface
+    #
+
+    echo 0 > trace
+    echo 1 > tracing_on
+
+    for cpu in $(get_cpu_ids); do
+        taskset -c $cpu echo $cpu > write_event
+    done
+
+    for cpu in $(get_cpu_ids); do
+        cd per_cpu/cpu$cpu/
+        output=$(dump_trace_pipe)
+
+        check_trace $cpu $cpu $output
+
+        rm $output
+        cd - > /dev/null
+    done
+
+    #
+    # Test interaction with hotplug
+    #
+
+    [ "$(get_cpu_ids | wc -l)" -ge 2 ] || return 0
+
+    echo 0 > trace
+
+    for cpu in $(get_cpu_ids); do
+        echo 0 > /sys/devices/system/cpu/cpu$cpu/online || return 0
+        break
+    done
+
+    for i in $(seq 1 8); do
+        echo $i > write_event
+    done
+
+    output=$(dump_trace_pipe)
+
+    check_trace 1 8 $output
+
+    rm $output
+
+    echo 1 > /sys/devices/system/cpu/cpu$cpu/online
+}
+
+if [ -z "$SOURCE_REMOTE_TEST" ]; then
+    set -e
+
+    setup_remote_test
+    test_trace_pipe
+fi
diff --git a/tools/testing/selftests/ftrace/test.d/remotes/unloading.tc b/tools/testing/selftests/ftrace/test.d/remotes/unloading.tc
new file mode 100644
index 000000000000..cac2190183f6
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/unloading.tc
@@ -0,0 +1,41 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test trace remote unloading
+# requires: remotes/test
+
+. $TEST_DIR/remotes/functions
+
+test_unloading()
+{
+    # No reader, writing
+    assert_loaded
+
+    # No reader, no writing
+    echo 0 > tracing_on
+    assert_unloaded
+
+    # 1 reader, no writing
+    cat trace_pipe &
+    pid=$!
+    sleep 1
+    assert_loaded
+    kill $pid
+    assert_unloaded
+
+    # No reader, no writing, events
+    echo 1 > tracing_on
+    echo 1 > write_event
+    echo 0 > tracing_on
+    assert_loaded
+
+    # Test reset
+    clear_trace
+    assert_unloaded
+}
+
+if [ -z "$SOURCE_REMOTE_TEST" ]; then
+    set -e
+
+    setup_remote_test
+    test_unloading
+fi
-- 
2.53.0.335.g19a08e0c02-goog

