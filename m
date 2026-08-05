Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995153D6472
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 20:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785963235; cv=none; b=j7WOFYyEaGZS7tkxOYd9dHKudiOUZhgdcfhRcYkTWwTcWMJeVyIHblHiBX8ebh9B06tJddTT9S5eCaoDhiByaLE9TiZM6G9xz10eDJYmN/Z2FWEt8N+n9wyQjL0lGEwPB9sTvaPizDBuYDDYuGOOzqGzcfSqN2d5mEso1oGrX2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785963235; c=relaxed/simple;
	bh=nuuxHAPBlapaUTkdySFg2/beJaAzM9XHpZ0juQT2a2E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tm4n1Aa+9opgzFeU3AOEfu2tkTDQq2+j4kWDVIY9UIQEsPvXJTvImwLQoL2M96lhmwiiCAv18gtSjhTH+xhhwa1O5vH+COUFCo3qb7+j9cnY1vE24RL369yafn/POytcFh1I+P10FK888B26tyw4B1QazovusiWNS/GTywcJixc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A84C81A059C;
	Wed,  5 Aug 2026 20:53:50 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf11.hostedemail.com (Postfix) with ESMTPA id CC2332002C;
	Wed,  5 Aug 2026 20:53:46 +0000 (UTC)
Date: Wed, 5 Aug 2026 16:54:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org,
 mhiramat@kernel.org, alexandru.elisei@arm.com, vdonnefort@google.com,
 joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, qperret@google.com, ardb@kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 tabba@google.com
Subject: Re: [PATCH v3 01/11] tracing: Include linux/types.h in
 trace_remote_event.h
Message-ID: <20260805165432.0118a513@gandalf.local.home>
In-Reply-To: <20260804112317.1937387-2-fuad.tabba@linux.dev>
References: <20260804112317.1937387-1-fuad.tabba@linux.dev>
	<20260804112317.1937387-2-fuad.tabba@linux.dev>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: CC2332002C
X-Stat-Signature: pxsw1pa851hmtm4bd3fsfd3rxys5wq8o
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/Ii2lk289HP5RYh2cytm4riV8/kWfoNK4=
X-HE-Tag: 1785963226-84509
X-HE-Meta: U2FsdGVkX18LjkoLn70IBd+mdTzL3BBwKziwL1mftDUpVecf84v6aX7M5PCYnIXzb3JQz4/epiui+kwQlLFVoL2Azwhvfdb88Up8yzvb0bvWgRI4ScImgQFztoVKY9LKRRV1BQXpd18qgWqRbUPnsSMIKYZa9wrECuSSAGeq1u/Z1MZVzTUcXbc2Z/vztp7CwPRw8GqypKKKU4AaBflBm4JaLIOJud2J0TMLmFwQaRfvi3RYxypub6O4sBv6U2TcDfaH9/mucJ3j3C4zPxZEDrxcvYR+qiI1NHTLwJ6U+FiyQvhC7pRNUJq68ys8Elsrsj361ai54w3QngssXiaH4gWgeldMRHqjV2Nt/d6496G2vWH4XCmAGVtUjMjpfhg4FY+8ipgFHe0trTnE9E/aSncSmKfO2fw2

On Tue,  4 Aug 2026 12:23:07 +0100
Fuad Tabba <fuad.tabba@linux.dev> wrote:

> trace_remote_event.h uses bool without including linux/types.h, so a
> translation unit that includes it ahead of anything else that pulls
> types.h in fails to build, as with nvhe/trace.h at EL2.
> 
> Fixes: 072529158e60 ("tracing: Add events to trace remotes")
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  include/linux/trace_remote_event.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/trace_remote_event.h b/include/linux/trace_remote_event.h
> index c8ae1e1f5e721..e4cc2d4497bcf 100644
> --- a/include/linux/trace_remote_event.h
> +++ b/include/linux/trace_remote_event.h
> @@ -3,6 +3,8 @@
>  #ifndef _LINUX_TRACE_REMOTE_EVENTS_H
>  #define _LINUX_TRACE_REMOTE_EVENTS_H
>  
> +#include <linux/types.h>
> +
>  struct trace_remote;
>  struct trace_event_fields;
>  struct trace_seq;

My ack still stands, but I wonder if we should just not use the include and
instead s/bool/_Bool/ ?

-- Steve
