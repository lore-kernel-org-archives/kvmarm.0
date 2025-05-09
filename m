Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6AE25E471;
	Fri,  9 May 2025 19:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746820042; cv=none; b=WiRBtXltD1E7cr0YrGyU6CsNA/x4e25NjYEfYF3DpdgcALLh68ce5VpdSfNA1yDOrAZxCLNdgFVVUHUOq77coxsM9Myjd4gKK1LTde9Hx8Aw+OYpxTmlZrBa/U56cUJiniKhiAfNkfkdbTQxysdbw6gBYYAT/q2ET9Tnkzs9QhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746820042; c=relaxed/simple;
	bh=NFUht2wKDJ+lhKUqHDc+W11Fj3bUVE0Zk2wQ0tkASbU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hSTXUmSsJNILM7mSVSr2gl2u5IvoZMSkZaW432fwBtAwowNLJ2aPlK6LJ/g1Lm9azI2LkkvjS2MY9DyWqR7XcqcEf+pm5srFsxMvqhpOiM7MoEDcHkxdFsQx6R5V8Q3TeD7gehAN5awtNPff0h10Ea/L3ErcpbnH9U1x53rEI64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7D8C4CEE4;
	Fri,  9 May 2025 19:47:20 +0000 (UTC)
Date: Fri, 9 May 2025 15:47:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 05/24] tracing: Add events to trace remotes
Message-ID: <20250509154735.530d4a37@gandalf.local.home>
In-Reply-To: <20250506164820.515876-6-vdonnefort@google.com>
References: <20250506164820.515876-1-vdonnefort@google.com>
	<20250506164820.515876-6-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  6 May 2025 17:48:01 +0100
Vincent Donnefort <vdonnefort@google.com> wrote:

> diff --git a/include/linux/trace_remote_event.h b/include/linux/trace_remote_event.h
> new file mode 100644
> index 000000000000..621c5dff0664
> --- /dev/null
> +++ b/include/linux/trace_remote_event.h
> @@ -0,0 +1,23 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _LINUX_TRACE_REMOTE_EVENTS_H
> +#define _LINUX_TRACE_REMOTE_EVENTS_H
> +
> +struct trace_remote;
> +struct trace_event_fields;
> +
> +struct remote_event_hdr {
> +	unsigned short	id;
> +};
> +
> +#define REMOTE_EVENT_NAME_MAX 29

29 is a particularly strange number. It's not even divisible by
sizeof(short). This will leave a hole in the remote_event structure.

Should it be "30" to plug up that one byte space between name and "id"?

-- Steve

> +struct remote_event {
> +	char				name[REMOTE_EVENT_NAME_MAX];
> +	unsigned short			id;
> +	bool				enabled;
> +	struct trace_remote		*remote;
> +	struct trace_event_fields	*fields;
> +	char				*print_fmt;
> +	void				(*print)(void *evt, struct trace_seq *seq);
> +};
