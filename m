Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459D32F3E
	for <kvmarm@lists.linux.dev>; Wed,  7 Aug 2024 16:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723048786; cv=none; b=P/9ty8prjZJ6DsRdJ32lTAtaImSVUWclmIxYC0siN1oiIEtvBdYj0Z3a5T8Lb64UfEJx7KHdYLlytVZH4cuAB0PVFKw9WIajzjfNSpI9sx2QJkAq2I/dNH7OvtWtCB2b1NOkjt5dKXDenXyIYTQnGMyLcHIYRr1d8h04/35+wUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723048786; c=relaxed/simple;
	bh=LPdAnUCvP/1/42vQX7gvD0FSLRCj53R2KV60JM7JR70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GAYoRg+dqxRD5Oua2Ih0hl3D9FCCdQUPMeCMW9Ql0zUPF9g5FMFsMajO0eREo0HZ6XOgEzA8vaJTrmXjXKMuv6BxV+JWm3CEdh7V0GunwMYmHt74Lq5DECFwOkH3OvzHPtFPUQuDooutnx2cYuPwkGCMQB6KUHtjfStM1z4IpqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aMcb3LKu; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aMcb3LKu"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-42808071810so511095e9.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Aug 2024 09:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723048782; x=1723653582; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QHW1mxXo99BTncFCV2Od8EwldJIdp0HcoBntkRqHPbI=;
        b=aMcb3LKua9oAtOpovy3hrVFShkN6rwV2ht2yojcfYyz8uEM8E/25M7crYXzg36kq/t
         /1+gU9x8BNnQc33Bxtj53MCzMWZhaZ3tWJemZF/vS1n1j2lrrLIScWZszTGyJd1ebn84
         Ids2l3geIifxoyY5tVetXmQjDgXj8SYecXl9vHuYSPEndDy+kESVw4CNFYVFDwUr0ZYf
         gLze+UCFL+4IfRWsPmX9qcZnt13q7Oer3tFs5HjNenFiCj0C6K/c+8yfYoCsBjeW4sR9
         xdp0t2wh67m2qGLIOFSSgMJ9IFWLmsesYeojN1eWsxB4ipcF5p60Dg1wd+djRg9oIpwc
         G0oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723048782; x=1723653582;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QHW1mxXo99BTncFCV2Od8EwldJIdp0HcoBntkRqHPbI=;
        b=PexOSlyNP0qSMekLa6vBpsV18AZdNdmNCBD1gAWP8CQAEzObY4lJL3aZn0ES+Jxfux
         I+sEY2QYgvcTJmXt22FsSqmq8aQvbPS/n+KjV5PCYFjGKj3qm4gbBwW1baf0NKBTvY7W
         N3H1WC/BX4KxZJ/bZmy+FSbSZF6Y9o+8ne09VvDfOvEOYqdj+cwrgWD9WtaQWQx1CdLE
         Ux8YTaFIptCk7vT4u7jn6DQZo+F2tq6hACAjTucLLTbzGNqM6NGehRlfaoUElgY7V7s3
         UmKSxrMuWeHy3qsP4TtaIr4FLOKugYAHerwLUDKnV6b11Uo83tvqmBq7d5ZrFVVe1LwB
         133w==
X-Forwarded-Encrypted: i=1; AJvYcCXBtMW58j+cgx00KBX99DYEm4HRvOMsw8m4GQAFfAWfW4O6zq36imELLopZrY9JfWUXFNeE1LpQ91hM3G74jAK/ZIFyGf2l
X-Gm-Message-State: AOJu0Yy7ABumb3x2N7c7RS49/ILRIA3ylz5aodtmeKBDw62Zy9K79Bjt
	k6cQBNTSaaWlM+LkMh6qVGxfBqb3YYIIugz/y+uP1KnlihjmEzDpkZ1HHoAcQQ==
X-Google-Smtp-Source: AGHT+IFpj8OAf/zU2P5H1nf7aSDiDGP+hlwNCJGS6cZvB3Vvk1HpMfsIAD1gNsJAlgupqm5KpgXoAQ==
X-Received: by 2002:a5d:6d49:0:b0:368:36e6:b248 with SMTP id ffacd0b85a97d-36bbc0cc71cmr14259786f8f.23.1723048782179;
        Wed, 07 Aug 2024 09:39:42 -0700 (PDT)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36bbd05ad0csm16751056f8f.79.2024.08.07.09.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 09:39:41 -0700 (PDT)
Date: Wed, 7 Aug 2024 17:39:37 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, will@kernel.org,
	qperret@google.com, kernel-team@android.com
Subject: Re: [RFC PATCH 00/11] Tracefs support for pKVM
Message-ID: <ZrOjSZ_JfcaLnCgh@google.com>
References: <20240805173234.3542917-1-vdonnefort@google.com>
 <20240806161138.3a91c04a@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806161138.3a91c04a@gandalf.local.home>

On Tue, Aug 06, 2024 at 04:11:38PM -0400, Steven Rostedt wrote:
> 
> Hi Vincent,
> 
> Thanks for sending this!

And thanks for already having a look at it!

[..]

> > 2. Tracefs interface
> > --------------------
> > 
> > The interface is a hyp/ folder at the root of the tracefs mount point.
> > This folder is like an instance and you'll find there a subset of the
> > regular Tracefs user-space interface:
> > 
> >   hyp/
> 
> Hmm, do we really need to shorten it? Why not just call it "hypervisor". I
> mean tab completion helps with the typing.

In most of the code we do refer to hyp, that's why we kept the naming here too.
But yeah we could expand it.

> 
> >      buffer_size_kb
> >      trace_pipe
> >      trace_pipe_raw
> >      trace
> >      per_cpu/
> >              cpuX/
> >                  trace_pipe
> >                  trace_pipe_raw
> >      events/
> >             hyp/
> >                 hyp_enter/
> >                           enable
> >                           id
> > 

[...]

> > 
> > 4. Few limitations:
> > -------------------
> > 
> > Non consuming reading of the buffer isn't supported (i.e. cat trace) due
> > to the lack of support in the ring-buffer meta-page.
> 
> Hmm, I don't think it should be hard to support that. I've been looking
> into it for the user mapping. But that can be added later. For now, perhaps
> "cat trace" just returns -EPERM?

Yeah, I am sure that's something we can make work. But definitely not a priority
as it is less reliable than _pipe and unused by user-space tools I believe.

For now we print "Not supported yet". But happy to modify it to a EPERM.

> 
> > 
> > Tracing must be stopped for the buffer to be reset. i.e. (echo 0 >
> > tracing_on; echo 0 > trace)
> 
> Hmm, why this?  I haven't looked at the patches yet, but why can't the
> write to trace just stop tracing and re-enable it after the reset?

I could reset the buffers from the hypervisor with a dedicated hypercall.

However I'd still need a way to "teardown" the buffer, that is unsharing it with
the hypervisor and freeing the allocated memory. Using that reset for this
purpose was nice even though it implied to stop tracing in a first place. 

Perhaps `echo 0 > trace` could reset the buffer if tracing_on=1 and teardown the
buffers if tracing_on=0?

Alternatively, I could use `echo 0 > buffer_size_kb` for the teardown. But I
prefer the former solution: interface users are more likely to just 0 tracing_on
and trace.

> 
> > 
> 
> -- Steve
