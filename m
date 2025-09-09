Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B973E22258C
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 18:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757443148; cv=none; b=jxdYfRCksT/zyaqmI/cmCSYwslGYf9rFpxdmjzfZoS5vG9yFd9pXpdMJ8gBeAumibT41ar1M8kuYHY+0FDTp6y7ct8Y9JBDRFQ+K6AyzCre4JNn4sGPBQV/NWvSEf/duoE34xW5iUZq7D8XletbJCTdaylbLHNKo0yW3FvCporI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757443148; c=relaxed/simple;
	bh=eqcE62nxhCYT/g1eduv2zGQJ99h5K0JxSzmZu9RmBP4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b4nsspJv1rAJPBxz1L+eKyloJ130+ZRAZcNCfEkXt1agNHw5G77EAmiPtXtx+NDbxo6sBDmMi7dYLtCl5cHX4qm5d4n47UiOa0Jfuuj+rSU3KUriXP29izaUUxt6R+v64uqIUA1cU7K+Fd723r7ysIbNpNU42jnKtXmhCwDgoAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69E5A14069C;
	Tue,  9 Sep 2025 18:39:04 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id B2FDE20025;
	Tue,  9 Sep 2025 18:39:00 +0000 (UTC)
Date: Tue, 9 Sep 2025 14:39:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 04/24] tracing: Add reset to trace remotes
Message-ID: <20250909143948.420bfb1c@gandalf.local.home>
In-Reply-To: <aMBSa29ev0BNgr5R@google.com>
References: <20250821081412.1008261-1-vdonnefort@google.com>
	<20250821081412.1008261-5-vdonnefort@google.com>
	<20250908193757.079aae76@gandalf.local.home>
	<aMAZMaZJ1_Eny5Ku@google.com>
	<20250909094028.3265b751@gandalf.local.home>
	<aMBSa29ev0BNgr5R@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B2FDE20025
X-Stat-Signature: 88rpahm4umjmmcjmrz9w7j3z6z8cjawb
X-Rspamd-Server: rspamout02
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/Dfb0F/ok0yMi6rVU9qwiXjkJqxDcdMLk=
X-HE-Tag: 1757443140-354827
X-HE-Meta: U2FsdGVkX1/dFMJGRD+C6O+Za+iRGR7QlQeUizfNtukq1m6fiS7yJXJxYQxG9yxfVWgqP1DYfzB0aOk3vcc97HywbUnaMvNe17yZQK7V0szWK1Xn6Fl1E/CQyXQAKRnkuCgAc7SuJp0V/GjwyvI52PlbVs4xIb6J5bfiz08Jgs1BYuK2BxX9Q4cDppfKLQ5O3V9K0Fdd3muKjQcb4613ryQc1TiRocoDXYvOIhxEJ3hsZTAKZllg5vzY8IgoDRAIEVes+/4idN+hXi8UaE6BF780N6C1bIYBKIOoWDOENiR/Vg6w8f57zdLTvf6x0jOhYSOnHsTZAQiFGZjiGXvDuz1xkAnD1qwI

On Tue, 9 Sep 2025 17:14:35 +0100
Vincent Donnefort <vdonnefort@google.com> wrote:

> On Tue, Sep 09, 2025 at 09:40:28AM -0400, Steven Rostedt wrote:
> > On Tue, 9 Sep 2025 13:10:25 +0100
> > Vincent Donnefort <vdonnefort@google.com> wrote:
> >   
> > > > I wonder if we should name the file "reset" to not be confusing to users
> > > > when they cat the file and it doesn't produce any output.    
> > > 
> > > My idea was to keep the exact same interface as the rest of the tracing. I could
> > > keep that /trace file for compatibility and add /reset?
> > > 
> > > "cat trace" could also just returns a text like *** not supported *** ?  
> > 
> > If it's never going to be supported, I rather not add it. It not being
> > there is a sure way of knowing it's not supported. Just adding it because
> > the normal system has it is actually worse if it doesn't behave the same.  
> 
> If later we extend the meta-page to support non-consuming read, /trace would
> then become useful.
> 
> Another argument for non-consuming read would be to enable dump on panic.
> 
> But I understand your point, it might be wishful thinking at this point.
>

It may be possible to still do a trace file. Basically, it would work the
same way the normal iterator works. Today it reads the trace while the
writer could be modifying it.

Actually, I think there's a bug in the iterator code today :-p

It needs to be modified to copy the event, as it currently passes the event
as is and that event could be written over by the writer.

But anyway, I think it should work for the remote buffers too. Let me go
and fix the current iterator.

-- Steve
