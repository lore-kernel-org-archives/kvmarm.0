Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BFA227BA4
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 00:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769646385; cv=none; b=hqDOYKsGtMDk10DBax+A77MViWDwZMD5FzBMM/T17bzelUD43pZLPqrcu930FVtGtbW8xGqgQQ8THMr6XPpCiJzDNXY/lDqMhNPHP/BPNgNusm0TNOQ29eXrTV4izGHH/IQJRx7wuDDTEO0olNzuuSgWT7sgd6ndzXTRc9WniYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769646385; c=relaxed/simple;
	bh=TpL8ATScig+6ZE6wNJvCEDRr+L6MgljLA7ihrQ5g3s4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bBNljYFDkg8oDyazIZede34MXbAM/Mq+UFKFX2g31G5smnC4b/gUNfJhLJlMbhWvnMG5tpKsOnIMi2SfFgsZNDghEdew1DG6Bv5mhwRhAqNXDGPeBK63xpViAQ+ZFEsu4vkmLQ/v3RUbyl/IhcTksVwg3K19dx2KGaa09rhKKrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 80678D458B;
	Thu, 29 Jan 2026 00:26:22 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf14.hostedemail.com (Postfix) with ESMTPA id EF0B63D;
	Thu, 29 Jan 2026 00:26:18 +0000 (UTC)
Date: Wed, 28 Jan 2026 19:26:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 03/30] ring-buffer: Introduce ring-buffer remotes
Message-ID: <20260128192628.79a34a6c@gandalf.local.home>
In-Reply-To: <20260126104419.1649811-4-vdonnefort@google.com>
References: <20260126104419.1649811-1-vdonnefort@google.com>
	<20260126104419.1649811-4-vdonnefort@google.com>
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
X-Rspamd-Queue-Id: EF0B63D
X-Stat-Signature: uhmrud73kdr8woybqusxsioup13m367u
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+t7iG84us8MSiQ2nrNQ7ZWsO9Oq9yZUDQ=
X-HE-Tag: 1769646378-999802
X-HE-Meta: U2FsdGVkX1+bdwF6ot5uPAXO4UKg9m06342APJv10ilLiPixyUI0CFyy6j0Wj/mz6USzSld6iqIYjfII9chDfFeqOCTaZfvxnja7wGjtaTKXp1LbqX3ONComYLSnev9DGtru1uePYI+AhojequSwYIz7AV6hGNoriS7Gnu6FuRaH//dq+BmBRuYoOi47TGOozJNBG2yIPBGOGNCDwicj1dUXKBkyBSykqnKGmF8/x1NxAIhf9xTJmpEBVEH2qlCwGNiLwNqhyO4M8r5WGhLrJC4QuOvv/ueTJZLtWVJkEmyta9R547wZzPtH5+++tMlVfofAs0Tp4KOvhMxutVihpsrx6m5sAqmqs3DE9Ne+lw62cgRW2Pnq+js7nnOuKPdBuZsbiBft49LeZOJC01wZww==

On Mon, 26 Jan 2026 10:43:52 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> A ring-buffer remote is an entity outside of the kernel (most likely a
> firmware or a hypervisor) capable of writing events in a ring-buffer
> following the same format as the tracefs ring-buffer.
> 
> To setup the ring-buffer on the kernel side, a description of the pages
> forming the ring-buffer (struct trace_buffer_desc) must be given.
> Callbacks (swap_reader_page and reset) must also be provided.
> 
> It is expected from the remote to keep the meta-page updated.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
