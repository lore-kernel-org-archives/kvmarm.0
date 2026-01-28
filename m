Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F462C159E
	for <kvmarm@lists.linux.dev>; Wed, 28 Jan 2026 21:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769634062; cv=none; b=bKZQnxX+7VpJf6FVeHz7SKgvoDdZ/DZVw0tvpFwuyATqtCu5e2N+ntPNvwfKeLp6EwMOJAa4hs/+mvbqhIgElFrhJMofuLjgt1Sk5nKUkvTKutesrN0qQFLNGGKpiXghmYys/7zD7bBN0ihf9W4oGof2UYYD93QBhO0CwON0BcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769634062; c=relaxed/simple;
	bh=b62khCeZ/rhvqDwrMOk7qWHgkzo1CmySZKVQfvwOhbc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UHdCq2V/Znd0mYNITG7pxg26gqjxcr67k7NWUc070Io3RbLXcpZk/fkoZEoYBSRrerEQn0sxpNifvOmzJJqoASpyAlaqSrbIPYv1Tmdcd5HiDn/fyu/ukpd+gws2lMZBCDj+4noL2hgj1iV1boMppap7+oTrAzhaZLbagNcNpHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2220E8C3A2;
	Wed, 28 Jan 2026 20:52:20 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf11.hostedemail.com (Postfix) with ESMTPA id A3F2D2002A;
	Wed, 28 Jan 2026 20:52:16 +0000 (UTC)
Date: Wed, 28 Jan 2026 15:52:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 05/30] tracing: Introduce trace remotes
Message-ID: <20260128155225.31da0ec6@gandalf.local.home>
In-Reply-To: <20260126104419.1649811-6-vdonnefort@google.com>
References: <20260126104419.1649811-1-vdonnefort@google.com>
	<20260126104419.1649811-6-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: f31kg7drewjoy9957a1gqw6gjtfftkok
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: A3F2D2002A
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/vhzK6M22bxGe4NiqcTpWVVnRKoNj9/58=
X-HE-Tag: 1769633536-445104
X-HE-Meta: U2FsdGVkX1/weuzLfX+KUZ2JXl2DZeaNPbJCLkX8KHV73l4PAxpDd89OdEi0bZ16ZfjGJZe2FVxPr9cpEA5fZRSKSeGgJj2k/Si3EWOTHpBAHLHOEeeFWnFsRYJzwIqLpWsv/mz/yNv7gs9jE92Yc7a+wzd3fHkCIWo2Dl2qs5TcPpATF31YuB14nZaJWD5DcqxK3XXWcM1r+pmOH+podcMJAcx47U+Ob3BKvEPhJ3Ksjux7tgHmVDNa8qKx1P3OEmwVJ9HxLh7tGJRb3bUdeH3OOnY9sNpFPqnaTzDWjch2hMJQMFwWjnANppvSf52THV6aaHD+CcGJORorOZHfPcYeqMI0mb2O

On Mon, 26 Jan 2026 10:43:54 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> +	if (!trace_create_file("tracing_on", TRACEFS_MODE_WRITE, remote_d, remote,
> +			       &tracing_on_fops) ||
> +	    !trace_create_file("buffer_size_kb", TRACEFS_MODE_WRITE, remote_d, remote,
> +			       &buffer_size_kb_fops) ||
> +	    !trace_create_file("trace_pipe", TRACEFS_MODE_READ, remote_d, remote,
> +			       &trace_pipe_fops))
> +		goto err;
> +

Oh, and don't do this in an if statement. Make them each individually as:

	ret = trace_create_file(...);
	if (!ret)
		goto err;

Linus hates complex if statements and I can see him having a conniption if
he were to see this.

-- Steve
