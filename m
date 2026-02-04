Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94995393DCC
	for <kvmarm@lists.linux.dev>; Wed,  4 Feb 2026 22:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770245082; cv=none; b=EYD+bu2aK72Fpf28Quox4ZRpqzkbxLPX1TEE/77yFmk961tD3v9FaNJqwJaDxVa7qMpZkxr3v6qqFnsMw2O+tKM6FGKWVCV2ukLtyICpp4zmUgyMjUCEqV8jMChnJY3hdGBLUOEMdVHZjYgVnN9wWfO9NziLUXoDQsJhaEaWhtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770245082; c=relaxed/simple;
	bh=GTn8ruOjH0csRmv7GGKpxO3wKD7DNKzddYY3UgMNdoA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UHmbNJvWhHYIPRQnGEfi47UWTf7UYpSb15ZaMpwrA+wHoEBlWN68Lg6wqXkbs8fxtBiYSXTlktYFB3xtNgB8wpH4fgqJ28VmFfL2LD5Qz74Lb85XAlYBEs5GDJ1g5LxXIwuJgOKIFMw0lDEBUAvh3XaCSc5KfBfwMYjIfe+9fWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 08C361C13A;
	Wed,  4 Feb 2026 22:44:34 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf01.hostedemail.com (Postfix) with ESMTPA id 8C11460010;
	Wed,  4 Feb 2026 22:44:30 +0000 (UTC)
Date: Wed, 4 Feb 2026 17:45:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 00/30] Tracefs support for pKVM
Message-ID: <20260204174502.06d6e02e@gandalf.local.home>
In-Reply-To: <20260131132848.254084-1-vdonnefort@google.com>
References: <20260131132848.254084-1-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout06
X-Rspamd-Queue-Id: 8C11460010
X-Stat-Signature: 7jotxs4bft4oqga453rcsoz77gixrbth
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+55NIOMUfSEl+N2ypkA4LkTl+xYz6Ea4Q=
X-HE-Tag: 1770245070-131592
X-HE-Meta: U2FsdGVkX1/nC1z6BLY3Br+vNzZ+OBSyJBsxnqi1VA4x6I1RmQ4EaAIefPOXKXy9+gV1hP8mKiyrgt9x/KK3Ucg+lfUaLqaK1qTQ6BqJSvMX5GMnr+qxK3gYBdSUNcga/Gi2hclKS0i5BKhleW2D9wqnR+SsjWnfQYOf7qMAD2PcWFJAAicMYVR45w/ZsbGQqvonT2lQAe3Y919tGdzvz9s++gzHDFFTKd8D+uY0zeHDf+tkkDfJPKLVf1DJQQWdDALkJ6tSNXSJaNTgDnW4Paoe+TxApyw8RFeppKU4QPys/tcxhex4BrRHVDWzwHOdZhwrrt06Upe2tdjPeWBk23bmmQDD1/GHodoOuHRgrNtUUlP2olrRfg==

On Sat, 31 Jan 2026 13:28:18 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> changes since v10

BTW, it's always nice to add a link to the previous version here. That way
it makes it easy to backtrace from one version to the next (and reviewers
to see what they said the last time).

Changes since v10: https://lore.kernel.org/all/20260126104419.1649811-1-vdonnefort@google.com/

-- Steve


> 
>   - Move kerneldoc to .c files (Steven)
>   - Return EBUSY on buffer_size_kb write if buffer is loaded (Steven)
>   - Remove rb_iter/rb_iters union in trace_remote_iterator (Steven)
>   - Rename a refactor trace file seq_operations (Steven)
>   - Make trace_get_cpu() accessible to trace_remote.c (Steven)
>   - Remove unnecessary cpus_read_unlock() (Steven)
>   - !preempt on remote_test driver buffer writing (Steven)
>   - Do not fail selftest if cpu/online is unavailable (Steven)
>   - Add rational for trace_remote into documentation (Steven)
