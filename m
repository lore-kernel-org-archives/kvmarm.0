Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90AB31DF248
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 12:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768219311; cv=none; b=GdwxcJlHdpx01LIrE2xaGJGgK1ZywF6ZRZsK/IPkWof9XyWV+M2MHq+QWDY4Lxfjd6TYFZZG51G1gpK0HmqBfkjizsw3wUusggyVKT3rfjfToY6CLTLeJQWI/r8bvmLdQssk9XwLosu2lpchMW0S+vPaKrGwWq2/C2UrnbOuqXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768219311; c=relaxed/simple;
	bh=mxI4UQAAGzY3RINut2eupTGQN7GWpnif6zdDROXBn6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YHRtHbPoZRUJfoHZZE1bY5FhCs+eEpiR5DQBue3DZ1ZPqvIw47FSoXi/VwNgCGNXU+q4pUQNq5dw0JyOTZCk482jwux+WxqzjH8v2C1TFi7iIc4gntvAEE0FNj0TE3u2OmKRn4e/bkW5At5AlULnRqgKYLSDe89aU7RngBqAT1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5867B497;
	Mon, 12 Jan 2026 04:01:42 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 42ED53F59E;
	Mon, 12 Jan 2026 04:01:47 -0800 (PST)
Date: Mon, 12 Jan 2026 12:01:44 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: James Clark <james.clark@linaro.org>
Cc: mark.rutland@arm.com, james.morse@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [RFC PATCH v6 29/35] KVM: arm64: Pin the SPE buffer in the host
 and map it at stage 2
Message-ID: <aWTiqNfMPQzGBmHk@raptor>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-30-alexandru.elisei@arm.com>
 <38443801-af4e-4ce1-a1c2-603eca8d90da@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38443801-af4e-4ce1-a1c2-603eca8d90da@linaro.org>

Hi James,

On Fri, Jan 09, 2026 at 04:29:33PM +0000, James Clark wrote:
> 
> 
> On 14/11/2025 4:07 pm, Alexandru Elisei wrote:
> > If the SPU encounters a translation fault when it attempts to write a
> > profiling record to memory, it stops profiling and asserts the PMBIRQ
> > interrupt.  Interrupts are not delivered instantaneously to the CPU, and
> > this creates a profiling blackout window where the profiled CPU executes
> > instructions, but no samples are collected.
> > 
> > This is not desirable, and the SPE driver avoids it by keeping the buffer
> > mapped for the entire the profiling session.
> > 
> > KVM maps memory at stage 2 when the guest accesses it, following a fault on
> > a missing stage 2 translation, which means that the problem is present in a
> > SPE enabled virtual machine. Worse yet, the blackout windows are
> > unpredictable: the guest profiling the same process can during one
> > profiling session, not trigger any stage 2 faults (the entire buffer memory
> > is already mapped at stage 2), but worst case scenario, during another
> > profiling session, trigger stage 2 faults for every record it attempts to
> > write (if KVM keeps removing the buffer pages from stage 2), or something
> > in between - some records trigger a stage 2 fault, some don't.
> > 
> > The solution is for KVM to follow what the SPE driver does: keep the buffer
> > mapped at stage 2 while ProfilingBufferEnabled() is true. To accomplish
> 
> Hi Alex,
> 
> The problem is that the driver enables and disables the buffer every time
> the target process is switched out unless you explicitly ask for per-CPU
> mode. Is there some kind of heuristic you can add to prevent pinning and
> unpinning unless something actually changes?
> 
> Otherwise it's basically unusable with normal perf commands and larger
> buffer sizes. Take these basic examples were I've added a filter so no SPE
> data is even recorded:
> 
>  $ perf record -e arm_spe/min_latency=1000,event_filter=10/ -m,256M --\
>      true
> 
> On a kernel with lockep and kmemleak etc this takes 20s to complete. On a
> normal kernel build it still takes 4s.
> 
> Much worse is anything more complicated than just 'true' which will have
> more context switching:
> 
> $ perf record -e arm_spe/min_latency=1000,event_filter=10/ -m,256M --\
>     perf stat true
> 
> This takes 3 minutes or 50 seconds to complete (with and without kernel
> debugging features respectively)
> 
> For comparison, running these on the host all take less than half a second.
> I measured each pin/unpin taking about 0.2s and the basic 'true' example
> resulting in 100 context switches which adds up to the 20s.
> 
> Another interesting stat is that the second example says 'true' ends up
> running at an average clock speed of 4Mhz:
> 
>           12683357      cycles   #    0.004 GHz
> 
> You also get warnings like this
> 
>  rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
>  rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-0): P53/1:b..l
>  rcu: 	(detected by 0, t=6503 jiffies, g=8461, q=43 ncpus=1)
>  task:perf            state:R  running task     stack:0     pid:53 tgid:53
> ppid:52     task_flags:0x400000 flags:0x00000008
>  Call trace:
>   __switch_to+0x1b8/0x2d8 (T)
>   __schedule+0x8b4/0x1050
>   preempt_schedule_common+0x2c/0xb8
>   preempt_schedule+0x30/0x38
>   _raw_spin_unlock+0x60/0x70
>   finish_fault+0x330/0x408
>   do_pte_missing+0x7d4/0x1188
>   handle_mm_fault+0x244/0x568
>   do_page_fault+0x21c/0x548
>   do_translation_fault+0x44/0x68
>   do_mem_abort+0x4c/0x100
>   el0_da+0x58/0x200
>   el0t_64_sync_handler+0xc0/0x130
>   el0t_64_sync+0x198/0x1a0

This is awful, I was able to reproduce it.

> 
> If we can't add a heuristic to keep the buffer pinned, it almost seems like
> the random blackouts would be preferable to pinning being so slow.

I guess I could make it so the memory is kept pinned when the buffer is
disabled. And then unpin that memory only when the guest enables a buffer that
doesn't intersect with it. And also have a timer to unpin memory so it doesn't
stay pinned forever, together with some sort of memory aging mechanism. This is
getting to be very complex.

And all of this still requires walking the guest's stage 1
each time the buffer is enabled, because even though the VAs might be the same,
the VA->IPA mappings might have changed.

I'll try to prototype something, see if I can get an improvement.

Question: if having a large buffer is an issue, couldn't the VMM just restrict
the buffer size? Or having a large buffer size is that important?

Thanks,
Alex
