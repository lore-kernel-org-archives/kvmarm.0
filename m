Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E50352C5B
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 22:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786401014; cv=none; b=p78ku/aPOVf6jOdtWGqh2up0NyjcJMYnFt7yIBckyRgJsso/U/Adl1GS2FAs4F70wVytDpNqZGxBWFwfFBywO50rNmuHp2EoVD5Mxiyg+I9015Xs32+7bBPJICITziRb2S1rmYLPTMtYdq8BxI9uTJ+c8o9b4W2A5Tncvv9xXls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786401014; c=relaxed/simple;
	bh=pMQeTWAJgjBFPryP+mgHfeSEFIXYfLKuU6oqLQ3/Q/4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Anx6STLHqRFGcmdR9e9F8Ux4WFzPEnNwthBt14qwGct7hvoJ2Yn/Wei13CkD/DCwGJO1szlXrKcbmshiZXVvlulDbQFVMBBenzX2PpekdBvTLi1EPZ3hvlxOrsgtCDw1QMajTKNmqKYEVmL+cq3Qq7dFp73ZLqhS0tx7K/5u18U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E6FE340112;
	Mon, 10 Aug 2026 22:30:10 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id 589DF20027;
	Mon, 10 Aug 2026 22:30:07 +0000 (UTC)
Date: Mon, 10 Aug 2026 18:30:17 -0400
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
Message-ID: <20260810183017.32db8b80@gandalf.local.home>
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
X-Stat-Signature: xtakhy7qecsge63wfcdxaimch8gwjbnx
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 589DF20027
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19liynQwYzW2cdd/ru5E/BnLybWK79UrC0=
X-HE-Tag: 1786401007-540265
X-HE-Meta: U2FsdGVkX19l/bEg6WyVs62MYOai422ZzDxhronGQpZKSZ4s32iH4P1VGDA53+tbK+BXLKUYFsHv9yDFVr+GrYI2NEUMPXj7HpMSDIQaYc9Nj1Bctwp/Pkrf3ctMcaxVNwTrSGdYSeNYZebmMWL5W/FsZmgRe2nI6yH1kGp7W7hDfHVMN3YMrGVgDrxQcimnv/BgQhppR6tttie8NfRdTPliP0DjxctbAOqHn0KgbbWI8kcTvhonPhC6ogthYw86+2FBdA2vsizcy1JrQIyVAydisG7j19nqTbfB+8Ava2qZG77H02CYKP+uX6GvyBal8cxaWhLuiM5Q8MQxna5x8bs5L70pNOSC5lKESCizsfvyPn9i9o2vs6GbFNgWRZu1r6pNcDt/u6CLtKPN95bmq6hvw+NM6L54

On Tue,  4 Aug 2026 12:23:07 +0100
Fuad Tabba <fuad.tabba@linux.dev> wrote:

> trace_remote_event.h uses bool without including linux/types.h, so a
> translation unit that includes it ahead of anything else that pulls
> types.h in fails to build, as with nvhe/trace.h at EL2.
> 
> Fixes: 072529158e60 ("tracing: Add events to trace remotes")

Is there a config that already fails the build without this change? Or is
it that new code will fail without it?

If it is the former, please drop the fixes tag, as nothing is currently
broken. If it is the latter, then sure, keep it, but you should mention
what config options break with it.

-- Steve


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

