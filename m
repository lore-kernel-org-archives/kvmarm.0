Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBCC31A55E
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 09:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762508348; cv=none; b=HtuR+0Fv1581sZ+ikYR+OEv3nsU6m5PlrJKuP/R3MPhvgJD11eO1jgjb8LO5oTPOOv1Wd1nGfy4WUiVEKCo34iqg95U97+hpZNKkRwxwAwQIb9tEnKKRIjJnmknlD8Voo8CVuo1IhbtWVjZWyulWaC1LMFaoeR16VmlKI101MmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762508348; c=relaxed/simple;
	bh=8CFfxFNc8wgUrIgXXfIhPhYBCHYrK5a40eJpGndN+So=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s1XC5rWIX61sj+c1SccFOoXMEcJR8hHnNpXeqBPyGNDk33oCQVNkoL6iHecPdvJwLFXrMQr/vqFdvYqsiwaizCtjxWF0KzKoupetZhshEJe8xGLm6VFJsRVdR2ds5lYvB8JG9KchIyeJzmLAaoUPv8gPxJrySCYsANc8Uy1tD9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TXEEghBE; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TXEEghBE"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b72a95dc6d9so73123066b.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Nov 2025 01:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762508343; x=1763113143; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bPUhNEejuI4ROkultepl+QkcZEmmkhnj2S8YwKbxDF8=;
        b=TXEEghBEo6aNhkcf6rhdJhSDJRW57PGiWxN7N6Er8vojAmg8ywKRiXrXAkeJ+db52m
         aAeKPuQAAKPzIkTugw1No/u47bQXv8aDOL84BPRPigQyqdQFDbO1KbhgkZ8KOFVR92lj
         i9k42HbzaZn2Rqcc+KbU7LU2/633xzxzRG7jmGouTZfKofJ1efrQMr1Byk/9ohuyyO4k
         ldbWHqoD2bOtuEdLCIjKndRyjkP+4fbtITf7RYXysQIDQQMgmh8PH6MQxYrnDbCvtwC4
         E66RU/XARK3EbdtsyAwos3oLyk5nEk45AKns6XII6IApd5CkaBoj3Ypg11MiyHV7vPjI
         nLlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762508343; x=1763113143;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bPUhNEejuI4ROkultepl+QkcZEmmkhnj2S8YwKbxDF8=;
        b=BvRnbmg6QZ0V5vJCBOKI5o/h5dW8pTNisQRv/9Sqhbssbvfy+u6/wHDk0ev3jOhBJu
         jf4tGnFZ8UDSZm9hKlBOXhOyp96IwplpwtbeoZGBUYlYUFFfHR5tN7+EuTI8HhSEKb0W
         usM3IyiRqz7AqtqWALU3fPSm3dyEpEYlgcd98oypeURIwy5KZuh99YxUaeJu/n4JE+kO
         x+VTKYbFrPGF5t5V1WcvuoWgvYkVvTcsZA0WpPxjBtqoF0UQseR1feTSK4on62B+onqL
         JCnIXtIQm8FElHd9LWtJQgqHMZtsO+Ld5fKcG6ICn1rEZxWm5qcwDw2qnmgKUImD4VZo
         INIg==
X-Gm-Message-State: AOJu0YxfUgtVSWZKnnSZCqN4sfZbhi7KkPxI7EeKCEPOVQmiNQLhyn/u
	VQA5DGOspaeFTuhQ1UprPrkD3llLRwCXehsY7Jgb7/yK72CFHP1G04OMVXXGjUf/NM9E2CfMTDz
	bCjmEcU0c0fUJ5QQgocYJhA==
X-Google-Smtp-Source: AGHT+IH8TOweny6YzE2wQnnSWCCWQQn1nM9ubfgPRlSHyLaTYS1XMM/QFgQzJfwZlQA3YDfo6ibpED3HRgYshmxX
X-Received: from ejcvt9.prod.google.com ([2002:a17:907:a609:b0:b72:552d:e87b])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:7ba5:b0:b72:7acc:24c8 with SMTP id a640c23a62f3a-b72c094e5dcmr278116466b.20.1762508342801;
 Fri, 07 Nov 2025 01:39:02 -0800 (PST)
Date: Fri,  7 Nov 2025 09:38:27 +0000
In-Reply-To: <20251107093840.3779150-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251107093840.3779150-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251107093840.3779150-16-vdonnefort@google.com>
Subject: [PATCH v8 15/28] tracing: selftests: Add trace remote tests
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
index 000000000000..081133ec45ff
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
+        echo 0 > /sys/devices/system/cpu/cpu$cpu/online
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
index 000000000000..d28eaee10c7c
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
+        echo 0 > /sys/devices/system/cpu/cpu$cpu/online
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
2.51.2.1041.gc1ab5b90ca-goog

