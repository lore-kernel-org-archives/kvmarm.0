Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA9C30BB8A
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 17:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771523799; cv=none; b=e5K2dMJw4sdJ2AajWdE9TBzwdBUBb7OeqY3/vYdaC9i52XAUGxTks3OScH++n4ADWB/I+N3MNz/aRJzYcbKM0EQQ91POYeQ9uhwK+Fl63qE1qqmvuLbAmhF60sJvdvaHEvlJ7WaHH1rL60yGIfN8Js7hI8g7uQ6G1aFDlroYmFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771523799; c=relaxed/simple;
	bh=0YdwDtCs5hMMCWZb6rrOqb6KIxSvrq5h7Ig3nebrWbs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XR3t/idWgAmzm3TpLse1n/QBc2/pDz7aBx/NR++I/AWjqitRReqzdUXUEJ8m9y8MYQ6Xyotvea5dIK30rODpT7i+PNCfm7cGZd6hxIRZLi/mEw9CfMaM9hUT07yd+aJlL4Cu93lLmaFMWaWG1AKIlZXpMtGjxsix8Dt5/8riIxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7B90813B6AC;
	Thu, 19 Feb 2026 17:56:30 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf14.hostedemail.com (Postfix) with ESMTPA id A7EC730;
	Thu, 19 Feb 2026 17:56:26 +0000 (UTC)
Date: Thu, 19 Feb 2026 12:56:32 -0500
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
Subject: Re: [PATCH v12 15/30] tracing: selftests: Add trace remote tests
Message-ID: <20260219125633.61b46621@gandalf.local.home>
In-Reply-To: <20260219150307.14538-16-vdonnefort@google.com>
References: <20260219150307.14538-1-vdonnefort@google.com>
	<20260219150307.14538-16-vdonnefort@google.com>
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
X-Rspamd-Queue-Id: A7EC730
X-Stat-Signature: y5x93jyjbxih3r5a8uoi88tic3k5dzi3
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX191EZ947KRGRihnOgbmtLmncn/2PlnjI/Q=
X-HE-Tag: 1771523786-358500
X-HE-Meta: U2FsdGVkX1/3kw1qj0Ocms5uM3wPQ/pREmBbxB19FdKcABvf1PtXK3rGfPO18dwRu14FJsjHM+XaQSE5es9jqaOx11PwyozWKss8/eUet+nh4LBUmysxPUhZmmY7Z90kiWZLVavzF0FrzrNMRJt840+JqnKkMsczxgWiIia06fxKqMbEAAlAcPfiPxyLqzSr2C0Z0kgsTgnEnB5bAwEbvSksfImlMFxIQxroCmGnbquO0JuJF/BevVXhIoeosaCJPq4En8YFIX/Av2UW8yMUwJFvZOkniRqLxKOYexR236nQQDUZyQsPjsCqeZuDgbWkIFxWetl6WwN2sTFsBG7u4x3N85IBIQ+uBL3HItTy2YTICl6KYO28syo4hcr64RDQPG9P6FbCOwLqd0fpnzLupfV62kObR84+iSn/HI2NWxAFUCsnvkuZJNrUAzNU4tzURGyzZUz1kcJ0/22sZbqCdQ+WjGR24KxqF2kU7Ps0fC0=

On Thu, 19 Feb 2026 15:02:52 +0000
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

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
