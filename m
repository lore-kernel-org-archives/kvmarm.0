Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34246168BD
	for <kvmarm@lists.linux.dev>; Mon, 20 May 2024 20:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716238412; cv=none; b=BpPs9bY28rJPZ9I2q4cvl7O6yeDXNpl3vFu/PZ6WFtk7pvNwYS86cV0OdmaF417CzqPU8+XqCKZtRddnoPR62Mxz+lBfLBjV/wpzPpmhHkpzCTrqGEOD9Zf9PoDKOXjyW4gHWsMJ9bd8r3lkWsmKNcXWEbbtpogmpRfWipgB3Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716238412; c=relaxed/simple;
	bh=n6yMqD/WngMwk7w9Jeu47n5HWVQHksGgcRTHISmJ6W0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XwzaL0b7hLtYhK5NkCXkdfuxvtu2DiVEoW3I9KUNKEyOxQzuMo12vB2oMAEBAowGLFoXTq4as0NsURBSYu8udyAoYj0kE77TcxjcAVewul40HmR+c6KonXr2rEo+Qg+wsX57EwzuO+6q5qtp7pWuO3c4uiMwDeWDzHRH9Xk3Sas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lFFgi+F+; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lFFgi+F+"
X-Envelope-To: tabba@google.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1716238408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r0e2eP2YYVoU2x+o/8aZJiXueSDsv6ENv+vQg2tvzwY=;
	b=lFFgi+F+blut49/BSKLTZAkqokdnmBHw130VFMSQdXTmv7psR9h6bsXjii8vb7OqjBU+6C
	hwYqlUluEL360ULfWeuGwgmFvpjGiT6O0uM/ugpqt2VR6trPMgWqsXLIioRf3yFUhp4GqW
	vdaW1NJBaoubsTR041rB42Jr8s+ZJOQ=
X-Envelope-To: maz@kernel.org
X-Envelope-To: broonie@kernel.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: will@kernel.org
X-Envelope-To: qperret@google.com
X-Envelope-To: seanjc@google.com
X-Envelope-To: alexandru.elisei@arm.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: philmd@linaro.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: mark.rutland@arm.com
X-Envelope-To: joey.gouly@arm.com
X-Envelope-To: rananta@google.com
X-Envelope-To: yuzenghui@huawei.com
Date: Mon, 20 May 2024 13:53:20 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	will@kernel.org, qperret@google.com, seanjc@google.com,
	alexandru.elisei@arm.com, catalin.marinas@arm.com,
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v1 0/7] KVM: arm64: Fix handling of host fpsimd/sve state
 in protected mode
Message-ID: <Zku4QF1VtKJqhnGg@linux.dev>
References: <20240517131814.719933-1-tabba@google.com>
 <ZkeUTix0Ojn5eHKP@linux.dev>
 <b73372b3-e032-4afd-a7cd-e08a687b1d3f@sirena.org.uk>
 <CA+EHjTxJe8yjVkhc=2fENJoMZs+MTR=9AZLmYcxZ5HxNnUOaQw@mail.gmail.com>
 <87pltg3ntq.wl-maz@kernel.org>
 <ZkuKYA6-u-eZmBOO@linux.dev>
 <CA+EHjTyvRU13+LL=vyRTOykj5pbycVPce7dstXK1rpTF98jKFA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+EHjTyvRU13+LL=vyRTOykj5pbycVPce7dstXK1rpTF98jKFA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

Hey Fuad,

On Mon, May 20, 2024 at 06:57:36PM +0100, Fuad Tabba wrote:
> Hi Oliver,
> 
> On Mon, May 20, 2024 at 6:37 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Mon, May 20, 2024 at 09:11:13AM +0100, Marc Zyngier wrote:
> > > On Mon, 20 May 2024 08:35:47 +0100, Fuad Tabba <tabba@google.com> wrote:
> > > > The reason for that is that in pKVM we want to avoid leaking any
> > > > information about protected VM activity to the host, including whether
> > > > the VM might have performed fpsimd/sve operations. Therefore, we need
> > > > to ensure that the host SVE state looks the same after a protected
> > > > guest has run as it did before a protected guest has run.
> >
> > Wouldn't it be equally valid to just zero the state that will not be
> > preserved regardless of whether or not the guest used fpsimd/sve?
> 
> Yes it would. I think I did mention that as an option.

Apologies, I probably missed it earlier on then.

> However, that would need to be done at every protected guest exit, whereas
> restoring the host SVE state only needs to be done if the guest has used
> fpsimd/sve.

Indeed, what I was _hoping_ is that implementations do a decent job of
handling a zeroing idiom for SVE and avoid needing to fetch a bunch of
state out of memory.

> I think the code for the latter (i.e., zeroing out), would be simpler.
> I'm happy to do it that way if you and the others think it's better.

Right, I have no fundamental objections to fully managing the host SVE
state in EL2. Strong preference for something simple + correct in the
interim. Anyway, thanks for suffering through my whining and hopefully
we can land a fix soon :)

-- 
Best,
Oliver
