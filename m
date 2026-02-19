Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CA6283FC5
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 17:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771523761; cv=none; b=oxeq61dSNk74GIKzpt0tNnWmLWGYem/UTSAZ0NQOMO5awE9LYtpvPeBth8/dzgxlkuIKpFQywaFpeH2XN/0dvMUxWNunraBFbC2bPxmYXj2QJafDb1w5FO+gthb77w9Jc+73QL9fYilVsmFV45nKHoeBu5ZVhrHNXV0yg4Cw0hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771523761; c=relaxed/simple;
	bh=nY+j5oxVGYQvDKO8Yu+WV9A4a5jXV0U4EY8JgLGtlIs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TLy82WjZNKQpB5iyCO/ZVnHXdyrU/EGT0gl8unuslcPV0smBKrtOP4ttio/kULpQi7P6EZVjFj0cBNwexB9D/TdjILEVX0Yh6L/LMqCWzgXzOQfTRxpyGIMyidmk3Y7nAooNlaS81liTl1ElzbNdY0RKWHXUkateVu4ca7FvX94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 193D413B6A9;
	Thu, 19 Feb 2026 17:55:53 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf13.hostedemail.com (Postfix) with ESMTPA id 9F43F20012;
	Thu, 19 Feb 2026 17:55:49 +0000 (UTC)
Date: Thu, 19 Feb 2026 12:55:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 07/30] tracing: Add non-consuming read to trace
 remotes
Message-ID: <20260219125555.4952101e@gandalf.local.home>
In-Reply-To: <20260219150307.14538-8-vdonnefort@google.com>
References: <20260219150307.14538-1-vdonnefort@google.com>
	<20260219150307.14538-8-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xcebk93g9cxu4r4g13r94iuz5okyo7tu
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 9F43F20012
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+ElNfWeNU4/cCv8EiXEbaqGNcsinTzoe8=
X-HE-Tag: 1771523749-420940
X-HE-Meta: U2FsdGVkX1+jCOpHILfzxNo/oKCU19ickooQWBWqnFc9VpEacNX9ws5ABGTHrB3qZu/8KfQaOB3Rub/jzcpRTSn3Z6Djz+x/LPCDTZpHF5MWB7ulHqWwGhdeU+RG7iM2oGprWeOwvjVK02xwrAbXjVP4NLDNad0zk/JqeYFkubXVJGrdIlIeCMJ6rQeLV5SiNb/+Te1m8FA+bxSd29HuamjZxnDONCFq4DlUGuUdaLgTWbFfDg8IFX9vrgfiDVcI0uZDymjXwOwWDM8dnKcOhrMlYfJVzulnMuu4HoTZOm6Z4LEQ5q3er4jTpUZK8YevPQozxeNM3kbu9PK52LNtwtbSKSfgGrabxKdKZmXpfHnRpO/tQcSKH9iKv4Y5RCBS2CZOg+bCqisqQFbLVhpEIA==

On Thu, 19 Feb 2026 15:02:44 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> Allow reading the trace file for trace remotes. This performs a
> non-consuming read of the trace buffer.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
