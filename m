Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A84335BB4
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 13:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757425631; cv=none; b=TbooEugz7JgvCfDzWHQHXNxUJufpzgO4ECHEooDyncPMlQLqfM1kw0O3F5aoTFRD2sJaBLciBSDPo/LaxAL7BJupcHUIbYKFvov4SvrREhsvoZyr32WcC58yZEhty2ir8hCEsphxB7XzMXTggxVRbayD+N6RmUNFbiPbYaNZLs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757425631; c=relaxed/simple;
	bh=2BJeKSYyt2QeV17fbx9+Ox1ZHzz/kjSxSb3PMy93A1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mnoQtG6vljxl3QNaC+epFIlz35SbaWibfkoFoonT77Gm1v+I/tUzscMEor9r4T4DtRjtte0nE33BQvyItD+6A8KVyrJpTvzu0qIiSrB7oojP69OCBt8Cp+SrZ5RmrqI0qO47o0DpVez/zmLBqj7pJjrt0Y61+MgUiRqK3W//8bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E1F0C0522;
	Tue,  9 Sep 2025 13:38:04 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id D27A430;
	Tue,  9 Sep 2025 13:38:00 +0000 (UTC)
Date: Tue, 9 Sep 2025 09:38:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 03/24] tracing: Introduce trace remotes
Message-ID: <20250909093848.402674b7@gandalf.local.home>
In-Reply-To: <aMAYvA9LSvfxvt_C@google.com>
References: <20250821081412.1008261-1-vdonnefort@google.com>
	<20250821081412.1008261-4-vdonnefort@google.com>
	<20250908193606.47143d09@gandalf.local.home>
	<aMAYvA9LSvfxvt_C@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: D27A430
X-Stat-Signature: 1s7jby4e1f59eijakdh5dmnw6a8s4s5n
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+b/T21/hKOjzR7gNCBVyeet5D9OLclCrM=
X-HE-Tag: 1757425080-965095
X-HE-Meta: U2FsdGVkX19VwrFDIvaXh2/25xJubPmnV4q+Sr9wRzIe2LHd9NOD0fypN81SxorUfRNk3louWVAXupbKvR6AOCmY8xCfj+sDUCOjQ8oGOwFNHSJ6YRbmIsjYM8XqtOZsZdSQ4hCfEuM3e9AiUGJsD9nrIdcLRQM9zLWzAWVK9hwbZGIlN7Tdv/KV/Bk5NuYjXXwkQVGMeDrVUrA5os9pgJsBCYk0kJKo33fzgzqt1s7NA2vswDqZN9ZJUAoexPIgv1bq2izsTWIPEl0KhVLd1eR3j6H4waYdR2NxW2whBncEsO54iFRPoRneqfcuqrHpMSD3xgydcOOS5876As3l4P7rFStwpDgM

On Tue, 9 Sep 2025 13:08:28 +0100
Vincent Donnefort <vdonnefort@google.com> wrote:

> > > +		rb_desc = __next_ring_buffer_desc(rb_desc);  
> > 
> > Is there no check to make sure that the cpu mask matches what the rb_desc
> > will have?  
> 
> The function is filling rb_desc[], based on the cpumask input, so both will
> match when returning from this function.
> It is then easy to handle the case where some CPUs are not part of the cpumask.
> See remote_test_load() where for_each_ring_buffer_desc() iterates over all the
> CPUs from the trace_desc but uses rb_desc->cpu.
> 
> Is it what you meant?

I'm more worried about the allocation not being big enough for the rb_desc
being filled. I just noticed that the trace_remote_register() function is
missing a kerneldoc header. Please add one and specify what the parameters
are for as well as their requirements.

It's fine to state that the allocation of desc must match what the cpumask
is. But the lack of comments about what the function does and what is
expected of the parameters makes it hard to know if it is performing
properly.

-- Steve
