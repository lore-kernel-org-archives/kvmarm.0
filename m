Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851985695
	for <kvmarm@lists.linux.dev>; Sat,  5 Apr 2025 02:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743821461; cv=none; b=ebDrPqMdaXQ10ej/VTLrVwUEqW5tAkHExnidg4+jUzzf9XkfHx/AIwlxAJI03+63xXSS+mZlLX0qLnKw1P344oQwVFihWIK0tG1dUcfUI5VGyT7cxNgQ4WcT77gecbaxBW+UGZ4XNH5o3rLGPzCKZfM5KiPHJZIT6JWzfFAs1J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743821461; c=relaxed/simple;
	bh=3iG4uszjJhYz1xN5KTHblBC7rKWOYr8Zu82RAVweGu4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VFaKYLxrMCe6w02GL4E46hcS7+VrSDJHqzae8jsHx3VSJdx0nG3kCxp5Cc2Z8shbS+fZjRVg0cSycCqxiq5mhkH3N3rEDyzaGwoGAnTjINUZKWzxDHoESoI5xrQR9ga8zTLh9J+prvVMHT/eh0SP1Gv4qyny/lQ1ZCnVlElrsjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wuZTNv4A; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wuZTNv4A"
Date: Fri, 4 Apr 2025 19:50:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743821457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QhuOOLdy9BplIOjwl5SEjiFDq9KRcuImi5tiBulKOHg=;
	b=wuZTNv4A8KHVliI7RVi1iq+KyXkkEpVXmobDwuSfJ9jC8v/d5c4jG9aKVyhGLgutSACa+p
	b7yQoi8ZZUiOQIdBt+InpQt4A/6qxUhExtd68Vqs6sb3UFkP45CYt9Is6Pyf9vvaO4updu
	JiTYbbTedWepNbQD4ccJn7P+3rF9OrE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mingwei Zhang <mizhang@google.com>
Cc: Raghavendra Rao Ananta <rananta@google.com>,
	Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 2/2] KVM: selftests: arm64: Explicitly set the page
 attrs to Inner-Shareable
Message-ID: <Z_CaiKsi42ho8DoK@linux.dev>
References: <20250405001042.1470552-1-rananta@google.com>
 <20250405001042.1470552-3-rananta@google.com>
 <CAL715WKaAHSgUhtMMT3Ztw90mMoHpVLdKUgVM15xx6yoUws9+Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL715WKaAHSgUhtMMT3Ztw90mMoHpVLdKUgVM15xx6yoUws9+Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 04, 2025 at 05:31:49PM -0700, Mingwei Zhang wrote:
> On Fri, Apr 4, 2025 at 5:10 PM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Atomic instructions such as 'ldset' over (global) variables in the guest
> > is observed to cause an EL1 data abort with FSC 0x35 (IMPLEMENTATION
> > DEFINED fault (Unsupported Exclusive or Atomic access)). The observation
> > was particularly apparent on Neoverse-N3.
> >
> > According to ARM ARM DDI0487L.a B2.2.6 (Possible implementation
> > restrictions on using atomic instructions), atomic instructions are
> > architecturally guaranteed for Inner Shareable and Outer Shareable
> > attributes. For Non-Shareable attribute, the atomic instructions are
> > not atomic and issuing such an instruction can lead to the FSC
> > mentioned in this case (among other things).
> >
> > Moreover, according to DDI0487L.a C3.2.6 (Single-copy atomic 64-byte
> > load/store), it is implementation defined that a data abort with the
> > mentioned FSC is reported for the first stage of translation that
> > provides an inappropriate memory type. It's likely that Neoverse-N3
> > chose to implement these two and why we see an FSC of 0x35 in EL1 upon
> > executing atomic instructions.

Ok, can we please drop this second reference?

This is talking about something else (FEAT_LS64) that happens to share
the same FSC as an unsupported atomic instruction. I mentioned this to
you internally as an illustration of how different implementations may
behave when determining if the attributes support a particular access,
but it isn't actually relevant to this change.

> nit: It's likely that Neoverse-N3 chose to implement this option (the
> first option) instead of reporting at the final enabled stage of
> translation

I would much rather we rely on the language that describes what the
architecture guarantees rather than speculate as to how Neoverse-N3
behaves.

Mentioning that the breakage was observed on Neoverse-N3 is still useful
to add to the changelog.

> I have minor question here: The DDI0487L C3.2.6 (Single-copy atomic
> 64-byte load/store) mentioned
> 
> """
> When the instructions access a memory type that is not one of the
> following, a data abort for unsupported Exclusive or atomic access is
> generated:
> 
> • Normal Inner Non-cacheable, Outer Non-cacheable.
> """
> 
> So, the above is the "Normal Inner Non-cacheable", but in our case we
> have "Normal and non-shareable" in stage-1 mapping, right? I know it
> is very close, but it seems the situation is still only "one bit" away
> in my understanding...

This citation relates to FEAT_LS64. If you look at B2.2.6 instead, it
reads:

"""
The memory types for which it is architecturally guaranteed that the
atomic instructions will be atomic are:

 - Inner Shareable, Inner Write-Back, Outer Write-Back Normal memory
   with Read allocation hints and Write allocation hints and not
   transient.

 - Outer Shareable, Inner Write-Back, Outer Write-Back Normal memory
   with Read allocation hints and Write allocation hints and not
   transient.
"""

and

"""
If the atomic insturctions are not atomic in regard to other agents that
access memory, then performing an atomic instruction to such a location
can have one or more of the following effects:

[...]

 - The instruction generates an IMPLEMENTATION DEFINED fault reported
   using the Data Abort Fault status code of ESR_ELx.DFSC = 110101
"""

The memory type used by KVM selftests is *Non-Shareable*, which is not
one of the memory types guaranteed by the architecture to work.

Thanks,
Oliver
