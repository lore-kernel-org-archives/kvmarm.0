Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B43C3A9DAD
	for <kvmarm@lists.linux.dev>; Wed,  7 Jan 2026 16:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767803805; cv=none; b=fD6A/zzZUMXy8m28V9etCHk8POwDo1crfFEqwsTpvTq959rtW3Yxx27Z+OycdKM4Me85gwX6jYbvQmr5Ne93HAOpBJC+6cQQh71Yi/Ai5k0VqVinI38N/rVf9LtlS9Y2CDjzsEbG7FH2TdWmeZsudvqU7i5bWlyOjMshPxpMDd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767803805; c=relaxed/simple;
	bh=bmxfz7RLBQaWdLfkTqfscPD06EGxMNEG69vcTIZ+NIo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PNq0EYQUZUDacDhasRa1SGsiGNj+CObl5GvP6dvt5ztfo1329RnXTxj97paxGYq6cKXPf9bDhDBgNVe5IPxq/UyNxZjsTS5ykCqZwS/WDW96DNbJoC8p4GjiJFED3nQtMEdgoUEyRhHkP3b3GQgtjv7Nn2guo777g968KEQMtZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02B501AACE2;
	Wed,  7 Jan 2026 16:36:34 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf03.hostedemail.com (Postfix) with ESMTPA id 8B1E560010;
	Wed,  7 Jan 2026 16:36:31 +0000 (UTC)
Date: Wed, 7 Jan 2026 11:36:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, jstultz@google.com,
 qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
 kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 28/30] KVM: arm64: Add hyp_enter/hyp_exit events to
 nVHE/pKVM hyp
Message-ID: <20260107113658.6647b6c3@gandalf.local.home>
In-Reply-To: <86a4ypmqts.wl-maz@kernel.org>
References: <20251202093623.2337860-1-vdonnefort@google.com>
	<20251202093623.2337860-29-vdonnefort@google.com>
	<86a4ypmqts.wl-maz@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: x4udjx1eez5trx587ipsm619xq7kn66b
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 8B1E560010
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18n7XnQ6iyL5ktIei/Ah4wQyDbpnc0P5VQ=
X-HE-Tag: 1767803791-100275
X-HE-Meta: U2FsdGVkX1/WAY6vrp1YLOm63QkIip39ElanvjPPfuAOYqR+0PkitkXdNF5vduNxqH7hbx3vdax6KDhWUUbUzPnwPxG1z8Z0TlKFsIxXu7dhnp2VWqZmb4yU/UoDH28iIi8dNGBfsDkc+lvfIV7LaHyZ/3jxiOvPhXAbnIUMhsKFjD0BXdEetZrT819q59iAG/O8xNdvnLyFydVhkFuVHmYHZG8BTASmkQ2T4JY0UkeHgr1wAZcZM8xdwBZlOZyAGjL7LkebHfTcc46WCKEqthpCHTzQVqT1WTVOMyIwg7l5VKfiu/Z8tJ+5uCFbw+BFHjoLKy58JmxxsBFO2gbK16jf26jTMygn

On Wed, 07 Jan 2026 14:37:35 +0000
Marc Zyngier <maz@kernel.org> wrote:

> > +static const char *__hyp_enter_exit_reason_str(u8 reason);
> > +
> >  #include <asm/kvm_define_hypevents.h>
> >  
> > +static const char *__hyp_enter_exit_reason_str(u8 reason)  
> 
> That's one ugly hack... :-(

This is basically the way TRACE_EVENT()s are created.

Have a look at include/trace/trace_event.h and include/trace/define_event.h

But I have to warn you. You may need to wear ugly hack proof glasses ;-)

-- Steve
