Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A812ECD11
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 08:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755764081; cv=none; b=AUyP2O4tFNeQ7L7YDElfSS9AkB3zicoMiAhegIKrG9e43HuuI6R4TBgkOlkc9ZAb4iw7S16gRANxGCwYEx15+6IDL2HP56qnjfjPieojzCW2vNwDLi7xGjVpbieJJPH5P1bf+hkEyFx5CNOFEcZ1k3h8egBSMjqJNakeGnafGJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755764081; c=relaxed/simple;
	bh=Zido7BGGyCct8PB7xiBoqrYPrOfJP7X7Fr0Wiblezzg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ogWikzrO5dz6NY0U+ZNZ5g806wVv5b9rPk2ufdCY4MFzcF6FCze1L+v9hxQypcO5lnKmkVACr7CWPI5jp4zJ7rKG5GTxyt3E6OmkdG9KCUnP4M/GLqODbjsr0V5Fb692ByM8RyFFYPjtREYkst1BarjzFMLJenvlMX1u3xPIUvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i6Z8Mn4s; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i6Z8Mn4s"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45a1b0b2b5cso5591195e9.2
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 01:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755764077; x=1756368877; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YuQZHh/5I/+ZxLcLKvlHxM6rBuApcg0gP5KQuEHQPgA=;
        b=i6Z8Mn4swTkrGmhZSOJyBhUOyoTcjFcY3WlDBtQTy7ImljKUv3OXoMazi3iBZQRg29
         AKnMniHAHuASIQB5MAPaVPEgLb75CD/NJIu/J1CQv2+U1gjSGszPknGAtqV4rM39gcW9
         Td4ix/rbKuJkziPCXGehJ+4IKV7dq5L20BflH2gxvO+hqRsZAvy6LgCP87cpc6hFPLq8
         ZJp47yJ/B+JZ2c3M8STSwCDYbTC2UFrTzI9uiShTerifgCFCsQH0Qv1t6IW+zFCRrN4s
         b1MHwu1f+znfz95NcNj703cm7CtZ2l3sXfDvDF3CY5/gkg5DSKdsoJJQdPHoUYPgtocj
         VORQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755764077; x=1756368877;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YuQZHh/5I/+ZxLcLKvlHxM6rBuApcg0gP5KQuEHQPgA=;
        b=IZQe1Fm5N27GHq7uy3zaiSup7WFMV0yqP3U7WLH/bQuKhSkzspZluK19iHF7zi4i0M
         bFWc63534KFfRzBkOgs6C6BMQm+wviJwxT2SipFtpYNK3+cg4ypNRdLyS24UkDCqEkL3
         M8kOTxfMfaWqNyjrmDZPkU9RniU2tOOo9q62pQ4NvbYVN+K+GYU6NTmFA34jZy7nG7L3
         rZ6UEtq0TZ/cFBeXwb6TS0wrvSZr1Za/LUCPu9bXDeRKb7a7af/zVUjl9obqip4GBQZ6
         6MSLorJJcInn2VTtWrDY0hLq2c5W5nHMYI4f5TFkukqOLzXDjrQuxofmdh+UfiXsIQTR
         3bdA==
X-Gm-Message-State: AOJu0YzSRb7lrpWOWkh0NCPvfT4a3ImrbY3tDX31BLRWIFvvoehgYZTV
	EmqzJNy1CjTmX61Algcwzp28i8Z9uHli7VnWwZB14CppLVZrhMjhGYkx0xDrBZ+kCs2kAhkv8iK
	BtdugKwQKQhTKFyeC9yWwDg==
X-Google-Smtp-Source: AGHT+IFMMEtGICfKL2zb2gyZ0RFhYHt6HTY8hUaeQd7Rm7nNHdZUXNjhKqLZBjHKkTE99BTV5Bzs4Nkm6UF9G/4v
X-Received: from wmqa4.prod.google.com ([2002:a05:600c:3484:b0:459:dbaa:93b0])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b19:b0:459:e025:8c40 with SMTP id 5b1f17b1804b1-45b4d7f0ddamr12544005e9.10.1755764077591;
 Thu, 21 Aug 2025 01:14:37 -0700 (PDT)
Date: Thu, 21 Aug 2025 09:14:00 +0100
In-Reply-To: <20250821081412.1008261-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821081412.1008261-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250821081412.1008261-13-vdonnefort@google.com>
Subject: [PATCH v6 12/24] tracing: selftests: Add trace remote tests
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
  * event integrity (trace_pipe)

Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-kselftest@vger.kernel.org
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/tools/testing/selftests/ftrace/test.d/remotes/buffer_size.tc b/tools/testing/selftests/ftrace/test.d/remotes/buffer_size.tc
new file mode 100644
index 000000000000..60bf431ccc91
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/buffer_size.tc
@@ -0,0 +1,24 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test trace remote buffer size
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
index 000000000000..504a495b3b1b
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/functions
@@ -0,0 +1,33 @@
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
diff --git a/tools/testing/selftests/ftrace/test.d/remotes/reset.tc b/tools/testing/selftests/ftrace/test.d/remotes/reset.tc
new file mode 100644
index 000000000000..93d6eb2a807f
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/reset.tc
@@ -0,0 +1,105 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test trace remote reset
+
+. $TEST_DIR/remotes/functions
+
+get_cpu_ids()
+{
+    sed -n 's/^processor\s*:\s*\([0-9]\+\).*/\1/p' /proc/cpuinfo
+}
+
+dump_trace()
+{
+    output=$(mktemp /tmp/remote_test.XXXXXX)
+    cat trace_pipe > $output &
+    pid=$!
+    sleep 1
+    kill -1 $pid
+
+    echo $output
+}
+
+check_reset()
+{
+    write_event_path="write_event"
+    taskset=""
+
+    clear_trace
+
+    # Is the buffer empty?
+    output=$(dump_trace)
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
+    output=$(dump_trace)
+    test $(wc -l $output | cut -d ' ' -f1) -eq 1
+    grep -q "id=7890" $output
+    rm $output
+}
+
+test_global_interface()
+{
+    output=$(mktemp /tmp/remote_test.XXXXXX)
+
+    # Confidence check
+    echo 123456 > write_event
+    output=$(dump_trace)
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
+            output=$(dump_trace)
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
diff --git a/tools/testing/selftests/ftrace/test.d/remotes/trace_pipe.tc b/tools/testing/selftests/ftrace/test.d/remotes/trace_pipe.tc
new file mode 100644
index 000000000000..f4bd2b3655e0
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/trace_pipe.tc
@@ -0,0 +1,57 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test trace remote trace_pipe
+
+. $TEST_DIR/remotes/functions
+
+test_trace_pipe()
+{
+    echo 0 > tracing_on
+    assert_unloaded
+
+    echo 1024 > buffer_size_kb
+    echo 1 > tracing_on
+    assert_loaded
+
+    output=$(mktemp /tmp/remote_test.XXXXXX)
+
+    cat trace_pipe > $output &
+    pid=$!
+
+    for i in $(seq 1 1000); do
+        echo $i > write_event
+    done
+
+    echo 0 > tracing_on
+    sleep 1
+    kill $pid
+
+    prev_ts=0 # TODO: Init with proper clock value
+    prev_id=0
+
+    # Only keep <timestamp> <id>
+    sed -i -e 's/\[[0-9]*\]\s*\([0-9]*.[0-9]*\): [a-z]* id=\([0-9]*\)/\1 \2/' $output
+
+    IFS=$'\n'
+    for line in $(cat $output); do
+        ts=$(echo $line | cut -d ' ' -f 1)
+        id=$(echo $line | cut -d ' ' -f 2)
+
+        test $(echo "$ts>$prev_ts" | bc) -eq 1
+        test $id -eq $((prev_id + 1))
+
+        prev_ts=$ts
+        prev_id=$id
+    done
+
+    test $prev_id -eq 1000
+
+    rm $output
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
index 000000000000..99f97e100fde
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/unloading.tc
@@ -0,0 +1,40 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test trace remote unloading
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
2.51.0.rc2.233.g662b1ed5c5-goog

