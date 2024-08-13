Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7215719EEC2;
	Tue, 13 Aug 2024 14:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723559740; cv=none; b=f7Xzyz8HdsXqMZTmr0bJNaPb7WPf4VlE5W3il3Eo1Y4HIUEooQp1CoaGiVx/1zDCU3/ooPWwb5uuIhRHPigBElbtDFFwKmDqTnWfDyPsfFREuSn5Jt/iMJDD/+idXAYO0vTI8WomD3qZ9a72MQSKH0btgKK6PbkstY79p5avmz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723559740; c=relaxed/simple;
	bh=dhGepppGGmSWpWeZiWkVz8+PeRCv7f8LwNPwF7Czhv0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OaNNT9p61boOkuWVu9JjQHFcVsC6X0Ta76XAs3IugpP8AebRe0gLrlWd08gUlUlHp8ggRrdMCcxSmSDeyBiP2KhgqcNfbSI9/bkVX6IYcuLUyIXPucasTuBtrkleDG8VbDyM9bMBEqGs9mxd+IbdX2p6KcrahNwhtTU2DOYFVtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0806C4AF09;
	Tue, 13 Aug 2024 14:35:38 +0000 (UTC)
Date: Tue, 13 Aug 2024 10:35:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, maz@kernel.org,
 oliver.upton@linux.dev, kvmarm@lists.linux.dev, will@kernel.org,
 qperret@google.com, kernel-team@android.com
Subject: Re: [RFC PATCH 02/11] ring-buffer: Introducing ring-buffer writer
Message-ID: <20240813103537.441321aa@rorschach.local.home>
In-Reply-To: <ZrtsAl4zpdMFAN4q@google.com>
References: <20240805173234.3542917-1-vdonnefort@google.com>
	<20240805173234.3542917-3-vdonnefort@google.com>
	<20240806163953.5ec6551a@gandalf.local.home>
	<ZrtsAl4zpdMFAN4q@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 13 Aug 2024 15:21:54 +0100
Vincent Donnefort <vdonnefort@google.com> wrote:

> > > +
> > > +#define for_each_rb_page_desc(__pdesc, __cpu, __trace_pdesc)				\
> > > +	for (__pdesc = (struct rb_page_desc *)&((__trace_pdesc)->__data[0]), __cpu = 0;	\
> > > +	     __cpu < (__trace_pdesc)->nr_cpus;						\
> > > +	     __cpu++, __pdesc = __next_rb_page_desc(__pdesc))
> > > +
> > > +static inline
> > > +struct rb_page_desc *rb_page_desc(struct trace_page_desc *trace_pdesc, int cpu)
> > > +{
> > > +	struct rb_page_desc *pdesc;
> > > +	int i;
> > > +
> > > +	if (!trace_pdesc)
> > > +		return NULL;
> > > +
> > > +	for_each_rb_page_desc(pdesc, i, trace_pdesc) {
> > > +		if (pdesc->cpu == cpu)  
> > 
> > Is there a reason for the linear search?
> > 
> > Why not just:
> > 
> > 	if (cpu >= trace_pdesc->nr_cpus)
> > 		return NULL;
> > 
> > 	len = struct_size(pdesc, page_va, pdesc->nr_page_va);
> > 	pdesc = (void *)&(trace_pdesc->__data[0]);
> > 
> > 	return pdesc + len * cpu;
> > 
> > (note I don't think you need to typecast the void pointer).  
> 
> I supposed we can't assume buffers will be allocated for each CPU, hence the
> need to look at each buffer.

OK, but by default that should be the fast path. We could add the above
and then do:

	pdesc += len * cpu;

	if (pdesc->cpu == cpu)
		return pdesc;

	/* Missing CPUs, need to do a linear search */

	for_each_rb_page_desc(pdesc, i, trace_pdesc) {
		if (pdesc->cpu == cpu)
	[...]

-- Steve

