Received: from out-52.mta0.migadu.com (out-52.mta0.migadu.com [91.218.175.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF23BC952
	for <kvmarm@lists.linux.dev>; Tue, 21 Mar 2023 15:07:09 +0000 (UTC)
Date: Tue, 21 Mar 2023 16:07:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679411227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TCnOwZ5hK6OX/UZaD9F4u+bgFnj3TwRoGBE0/NR556w=;
	b=Ymo8+QYqFSqHQ+6WBTBV3WvX91V42Ky1ooU6lNKH4ddKTJvN5VmYQtVYqD05Xlq2nNKPly
	ddhvR8MIP+0Th/SFf2nYwbxevwr2PF9N8g4K6T/lQidnOvv9Rch0i1ad/jGAb8D5pHYA77
	vnUUTWwzXY5jk5fI68MBKmOag0Blq90=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
	qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.linux.dev,
	qemu-arm@nongnu.org, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [kvm-unit-tests PATCH v10 4/7] arm/tlbflush-code: TLB flush
 during code execution
Message-ID: <20230321150706.6njowkadyp3vpb44@orel>
References: <20230307112845.452053-1-alex.bennee@linaro.org>
 <20230307112845.452053-5-alex.bennee@linaro.org>
 <20230321150220.mfrvgxg3ebju5e6k@orel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321150220.mfrvgxg3ebju5e6k@orel>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 21, 2023 at 04:02:21PM +0100, Andrew Jones wrote:
...
> > +
> > +# TLB Torture Tests
> > +[tlbflush-code::all_other]
> 
> It's better to use '-', '_', '.', or ',' than '::' because otherwise the
> standalone test will have a filename like tests/tlbflush-code::all_other
> which will be awkward for shells.
> 
> BTW, have you tried running these tests as standalone? Since they're
> 'nodefault' it'd be good if they work that way.
> 
> > +file = tlbflush-code.flat
> > +smp = $(($MAX_SMP>4?4:$MAX_SMP))
> > +groups = nodefault mttcg
> > +
> > +[tlbflush-code::page_other]
> > +file = tlbflush-code.flat
> > +smp = $(($MAX_SMP>4?4:$MAX_SMP))
> > +extra_params = -append 'page'
> > +groups = nodefault mttcg
> > +
> > +[tlbflush-code::all_self]
> > +file = tlbflush-code.flat
> > +smp = $(($MAX_SMP>4?4:$MAX_SMP))
> > +extra_params = -append 'self'
> > +groups = nodefault mttcg
> > +
> > +[tlbflush-code::page_self]
> > +file = tlbflush-code.flat
> > +smp = $(($MAX_SMP>4?4:$MAX_SMP))
> > +extra_params = -append 'page self'
> > +groups = nodefault mttcg

Shouldn't these also be in something like a "tlb" group?

Thanks,
drew
