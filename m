Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FE33FBB5E
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 18:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784572340; cv=none; b=CKNOFLK14pp7rUFX2i4eBO7kqQ+pAmCnf+UD5rFJjPjlUHLCU63EoXY8q/hB7m+xEpCcTBu588+FUZMnXsZ/dJqK2kPhoIjcfOmiWlotMTGnAyOSXFXNunF5C9BknnMFF96OcJ2JJNbsnvPibYFTjYHUN1ULqdV3WrSCZcZpmwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784572340; c=relaxed/simple;
	bh=+VsiFxb+8JmhMchEafCdhkdqTceARPGzXe+Pedvl8x4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NWTzcssGfz2rDgCvPGAdxgkAKOCi9uyRQ7r/8cI5pe7i4UkyE6gc+R0riovq+OU+iO3zH0o3Ljp27dqjjKqQEtwhgbv4H2ZLIGw7sqPrmn3XR9yHu81Fd6C38seoD6S8GY0gpbs55TDh0C+8KQZ8FHScE9SAiY4SCLFjSfJtZbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE9D91A0289;
	Mon, 20 Jul 2026 18:32:16 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf11.hostedemail.com (Postfix) with ESMTPA id 73CF12002A;
	Mon, 20 Jul 2026 18:32:12 +0000 (UTC)
Date: Mon, 20 Jul 2026 14:32:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org,
 mhiramat@kernel.org, alexandru.elisei@arm.com, vdonnefort@google.com,
 joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, qperret@google.com, ardb@kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 tabba@google.com
Subject: Re: [PATCH v1 01/11] tracing: Include linux/types.h in
 trace_remote_event.h
Message-ID: <20260720143211.0bc5d6a4@robin>
In-Reply-To: <20260720161343.1367007-2-fuad.tabba@linux.dev>
References: <20260720161343.1367007-1-fuad.tabba@linux.dev>
	<20260720161343.1367007-2-fuad.tabba@linux.dev>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: a831g5wityo5unzsfqepbjsayoypenqi
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 73CF12002A
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18V9+EcvOTS50wfn1iUFdmuVa/ykzVCoIA=
X-HE-Tag: 1784572332-903957
X-HE-Meta: U2FsdGVkX1/nUie4EgfVs/N2MN8uYuXasi4IxdlvoavaGWe59c26La92i2jL7d8Ef0hWHk+Gs6YDAwZLoyVdqIXpVxEvu5g7sdhsQYQ128RX80hg4ZjuTEDC3f3aARD6PmMbm9HvR7IQQCVCMx9Xyk5NLs3upKYJSf98tJMMCixZuWNL6pm30wjpZM4XQxKnzFryYh0M2qH2uV8IcIQI1KHfCDaJtD14aaldy6iuuRezR3LRfKUNdAHfAtgH+dnCaYL3cSwR+0rrstNociZI03uZ1ghPYjjLtLJPJNNQ06xf3O1QLr1ywSywYVo0oHbaG7DSLu+AGcJsRqWedIOESDblNETM+yOk0hnRlEWWnVNZuxdBxyjmpTjSoCh0KcpE

On Mon, 20 Jul 2026 17:13:33 +0100
Fuad Tabba <fuad.tabba@linux.dev> wrote:

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

I don't know if this is correct or not, but here's my ack so others can
decide and take it through their trees.

Acked-by: Steven Rostedt <rostedt@goodmis.org.

-- Steve
