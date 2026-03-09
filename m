Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3A23ECBF7
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 16:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773073579; cv=none; b=sC3Cv36JcZoZHSJuJOlS7eCE7glvnmRiHnYxb6cOeY44yebBUTdumB1AWhoHrsOpMk0EkTCVUZ9s68qefZbc9CEvo+glX5IcQ1pcMLKEuB9hdbzMEhghCXCvy8gAxXibyQ+33PhRSlAgHFhwntFOOmm6b4c/P8rwGY9Ys+Xr3ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773073579; c=relaxed/simple;
	bh=QgrpnA9vqWR0LvqBZTQt9eWvlVYE0nDC3NQs7drGfDs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fDKs0PFpxG/tdA+Bl/9uitaySQLa0Lh0iiPRAMgLk8JrLLOwfIji67uwe8YvJvU1ZAN06d4jxsA3FXMiQxbpdJy/PC+dhH8lWJIijnx2sWHs1tR5xcGudwdFchzRV7DdjWfKtKf4Bm8NmxfV6ylD31e5Yeheai9Yax3Nr0kSvVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x+G/Y9E/; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x+G/Y9E/"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4806cfffca6so129825095e9.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Mar 2026 09:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773073575; x=1773678375; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7EWtEU3hLDTOygEgGBU2HCNdGhHgmpQrxlmxxTt9Vi8=;
        b=x+G/Y9E/w/bNdS3kkbqGeYyVLGBHbx1EUcLQ8xtE0PCJKBIEAkTx+4TfyoulSl5vJQ
         6VORRc954USoJLIxi+u1xuyqlFSu1Cwi14BCsbm7meUKdTk6oiNfMYw5UsyUoH2314M0
         zAzSHxNriVoUbsUwfQ98HcVihLH2Ofs7dh+jJN/cOH9za8F4uKb7VJyGQLgUnWsgKKXD
         MwLAPdJWxu6GdSMlNirrE54ibtb2ZeIQOrrjBKfUY1ta1e/g7G0Vn8b3/kgngQSE+idz
         04FalxikARIYheTBIoWd5hCIGDaIqOd6VYA9+or6AZlcSwENKWNRDl8Unev3t4CKPKSX
         Ie1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773073575; x=1773678375;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7EWtEU3hLDTOygEgGBU2HCNdGhHgmpQrxlmxxTt9Vi8=;
        b=dTTl0PbTLWv7QWqc/CNCSSDXCMSi0281tcUN6Ct+KWSFltymtbIcj+oi+RG4INICkA
         P5sFhhJdY6FsojedcO6tAUglPFIPnGb8Vd+E0wzL17mq6IwnQFtsimbYhWO+hAalHQLh
         E7ixQQVtE4TlBLoS/LdQuf5nzr2CSO6r1s13mNoywrAMI6QzzXGCB9sdMGTiaAVA5d4y
         5NUSCuV6k8+af6ObdWfpC966Q++zbKmKDjKzSHl6rOIu0S8e3mLHlhYJ4GfIqEihutpw
         r6twU1frlxSHE71ADN+UMWHWpAulS91R46EzLtmNsxfrXE2sZu7nRUnUNWmaOVjz/DzM
         EYRQ==
X-Gm-Message-State: AOJu0Yx/Qv9jPkz693NB1DPia4p66NXTJgtHMDi81Mmw1WqdcTShbpAc
	1WEV5Wv0J90WMhVk+GCmIO47nSzp438WKL/7yxujVOrE16LlqFfCbpNWNzrDx0tifxb9zmx3rkB
	3XcX6vvnoDV9VJPUutQDuJA==
X-Received: from wmgp3.prod.google.com ([2002:a05:600c:2043:b0:483:be6e:b81c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4751:b0:485:3ae3:b394 with SMTP id 5b1f17b1804b1-4853ae3b587mr75117615e9.31.1773073575481;
 Mon, 09 Mar 2026 09:26:15 -0700 (PDT)
Date: Mon,  9 Mar 2026 16:25:01 +0000
In-Reply-To: <20260309162516.2623589-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260309162516.2623589-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260309162516.2623589-16-vdonnefort@google.com>
Subject: [PATCH v14 15/30] tracing: selftests: Add trace remote tests
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
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
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
2.53.0.473.g4a7958ca14-goog

