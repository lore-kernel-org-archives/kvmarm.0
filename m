Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DC82F8BC3
	for <kvmarm@lists.linux.dev>; Thu,  5 Feb 2026 17:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770313301; cv=none; b=sUW6BkhQG6XquxlbelEoiUyFt5WCghtWgImacR+ylexw1/OpvrDsxHB6NVuPIZWbbojrcRzLMqauibIFgvR5usnmHkKPGaMRA+pVHCxDHj6UBWGCkzCjNFsS3mzEklp2guD2AhXqb40JmLrmNrde97fGMvjdMRYAQeenzTMOoHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770313301; c=relaxed/simple;
	bh=dmL7Lk+6dlXqEGvGe/Bs7X3mYeHB1WOarIYKrEOGFXI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rz+SOUsYlUmBkpneC4ceYmVsSSCc0+YU/PGRgqc9U+W34ykIrAGat14HACrN0XlE6gcxe+MPBn5UVUEeaaZ5CZW0//n7qGNh0EZm/JnKv66M20y+I2M/yTjj1O80cpMPaWD1KG4nYE16um6rugJ0xj5mQGjK0Ko2yUl63wyBhRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A3238C109;
	Thu,  5 Feb 2026 17:41:37 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf07.hostedemail.com (Postfix) with ESMTPA id 1CB9120024;
	Thu,  5 Feb 2026 17:41:34 +0000 (UTC)
Date: Thu, 5 Feb 2026 12:42:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v11 15/30] tracing: selftests: Add trace remote tests
Message-ID: <20260205124208.2ed7cff8@gandalf.local.home>
In-Reply-To: <20260131132848.254084-16-vdonnefort@google.com>
References: <20260131132848.254084-1-vdonnefort@google.com>
	<20260131132848.254084-16-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 1CB9120024
X-Stat-Signature: xrqfaergycraki9ixirzx4pqwqpkshpz
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/AAJG0H2Y0nJ6yIVW93vc/rmOZvsTHdvc=
X-HE-Tag: 1770313294-751280
X-HE-Meta: U2FsdGVkX1+uuRgLPQ0ZgTKxMjzwxSS3wkxfEc/ttq2P0equ3WYuTk1Eo8BUqwVZX+pHP5PyilUVvCZrp/Id69DfyKfI2Lcp/JUghTpize8GQcHlrhj+pA1vcARhFNwS9fozq1kAOB1M5jjdhbgyyftg7E6q0Tm13V0vgY0dBYjaHm8CJ9e43ks2XZGIkfziMs32Vie/pcc9aL59qt67rJDOd8YNL9sFIg4S/bmc3qWX6TEookAaDBK0BzqiQTGiYhmLBwffXuSRZsCBHFPgG/lyEUt40fCk9nEWr/1+qTYjj82gzk1WqrJTqJK1Isyl4D6JObzKUKNVidE/baBu0TfHLiCDT7J7kI1mj9b80sNlo4rLU0R/bknCw+sIoPJs4g4uWStQ1N19ite56C3RWzGZxfFk+rXqZPVMs/Cnb5Q=

On Sat, 31 Jan 2026 13:28:33 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> Exercise the tracefs interface for trace remote with a set of tests to
> check:
> 
>   * loading/unloading (unloading.tc)
>   * reset (reset.tc)
>   * size changes (buffer_size.tc)
>   * consuming read (trace_pipe.tc)
>   * non-consuming read (trace.tc)
> 
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: linux-kselftest@vger.kernel.org
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

This still fails:

=== Ftrace unit tests ===
[1] Test trace remote buffer size	[PASS]
[2] Test hypervisor trace buffer size	[UNSUPPORTED]
[3] Test hypervisor trace buffer reset	[UNSUPPORTED]
[4] Test hypervisor consuming trace read	[UNSUPPORTED]
[5] Test hypervisor non-consuming trace read	[UNSUPPORTED]
[6] Test hypervisor trace buffer unloading	[UNSUPPORTED]
[7] Test trace remote reset	[PASS]
[8] Test trace remote consuming read	[FAIL]
[9] Test trace remote non-consuming read	[FAIL]
[10] Test trace remote unloading	[PASS]

I added this patch and the two failed tests now pass:

diff --git a/tools/testing/selftests/ftrace/test.d/remotes/trace.tc b/tools/testing/selftests/ftrace/test.d/remotes/trace.tc
index 081133ec45ff..dfc954a6a380 100644
--- a/tools/testing/selftests/ftrace/test.d/remotes/trace.tc
+++ b/tools/testing/selftests/ftrace/test.d/remotes/trace.tc
@@ -106,8 +106,10 @@ test_trace()
     echo 0 > trace
 
     for cpu in $(get_cpu_ids); do
-        echo 0 > /sys/devices/system/cpu/cpu$cpu/online
-        break
+        if [ -f /sys/devices/system/cpu/cpu$cpu/online ]; then
+            echo 0 > /sys/devices/system/cpu/cpu$cpu/online
+            break
+        fi
     done
 
     for i in $(seq 1 8); do
diff --git a/tools/testing/selftests/ftrace/test.d/remotes/trace_pipe.tc b/tools/testing/selftests/ftrace/test.d/remotes/trace_pipe.tc
index d28eaee10c7c..146f0a9fe311 100644
--- a/tools/testing/selftests/ftrace/test.d/remotes/trace_pipe.tc
+++ b/tools/testing/selftests/ftrace/test.d/remotes/trace_pipe.tc
@@ -102,8 +102,10 @@ test_trace_pipe()
     echo 0 > trace
 
     for cpu in $(get_cpu_ids); do
-        echo 0 > /sys/devices/system/cpu/cpu$cpu/online
-        break
+        if [ -f /sys/devices/system/cpu/cpu$cpu/online ]; then
+            echo 0 > /sys/devices/system/cpu/cpu$cpu/online
+            break
+        fi
     done
 
     for i in $(seq 1 8); do

-- Steve
