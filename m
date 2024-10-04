Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBC41C3059
	for <kvmarm@lists.linux.dev>; Fri,  4 Oct 2024 16:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728058894; cv=none; b=gXSh2DzjeMLOnYIs8KH1Q9hQNWM6aIf6A6+afF2vDjFwiT6jqh1IjrGHNtxRwv3D5P/ZkIuQIAYrjjzNK4J50ON4hrMRrO/vv4qPDzrmbesH4Wud4WjsnYEgYhm/jnc4GIuAg2ZFidFUdMosZy34JyG6Nk2m/Y4qQ/8Z/T+BkQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728058894; c=relaxed/simple;
	bh=fbSBeFv4y2bND28JAXVuOJpQ4t3ohxSV4OnX4+OhxEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l+Dj/riWDdRXyFtxvdS736bKgi6Gobn6mEdkGCvqC1ccCNqKc/r+SjmwN/GN+BJ85OwRD2Nh9px4/wEKGVybROw2ZBDIeLgLZFbtP1gelwVh7715O08SX0WdFRNdp7i6m9OpsMKbYiFadKcQOAiuJZL6p0QDt94ArD5Adv758/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lSOjAaTq; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lSOjAaTq"
Date: Fri, 4 Oct 2024 09:21:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728058889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zlM8m7v/qswLm5RCIdVV6zcxY4xUPPYPHOAIW5U70Sc=;
	b=lSOjAaTqUpZvTU6T8QVVY02TEP5Ti3WOAE+d2atngJNuLQ7fVaEjcYA1WT0s1/E46OuU6Y
	kpwXZjwQFFbbscrh2qD/IkA4IIGc9l/n74Kqtt+OLdJJSAgr0eLB0uWY1ypqHw9OUyxFH5
	03sVn0dZ65TN/TUObvZxxJ07yvWSEqU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>, qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Enrico Joerns <ejo@pengutronix.de>
Subject: Re: [BUG] ARM64 KVM: Data abort executing post-indexed LDR on MMIO
 address
Message-ID: <ZwAWAaTfHGUCGUPQ@linux.dev>
References: <89f184d6-5b61-4c77-9f3b-c0a8f6a75d60@pengutronix.de>
 <CAFEAcA_Yv2a=XCKw80y9iyBRoC27UL6Sfzgy4KwFDkC1gbzK7w@mail.gmail.com>
 <a4c06f55-28ec-4620-b594-b7ff0bb1e162@pengutronix.de>
 <CAFEAcA9F3AR-0OCKDy__eVBJRMi80G7bWNfANGZRR2W8iMhfJA@mail.gmail.com>
 <ZwAPWc-v9GhMbERF@linux.dev>
 <CAFEAcA9bnJR__3v2ixjjEyQD+Kwz4oR9+HO=w8u6JsVjgnXE2w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA9bnJR__3v2ixjjEyQD+Kwz4oR9+HO=w8u6JsVjgnXE2w@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 04, 2024 at 04:57:56PM +0100, Peter Maydell wrote:
> On Fri, 4 Oct 2024 at 16:53, Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Fri, Oct 04, 2024 at 01:10:48PM +0100, Peter Maydell wrote:
> > > On Fri, 4 Oct 2024 at 12:51, Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
> > > > > Strictly speaking this is a missing feature in KVM (in an
> > > > > ideal world it would let you do MMIO with any instruction
> > > > > that you could use on real hardware).
> > > >
> > > > I assume that's because KVM doesn't want to handle interruptions
> > > > in the middle of such "composite" instructions?
> > >
> > > It's because with the ISV=1 information in the ESR_EL2,
> > > KVM has everything it needs to emulate the load/store:
> > > it has the affected register number, the data width, etc. When
> > > ISV is 0, simulating the load/store would require KVM
> > > to load the actual instruction word, decode it to figure
> > > out what kind of load/store it was, and then emulate
> > > its behaviour. The instruction decode would be complicated
> > > and if done in the kernel would increase the attack surface
> > > exposed to the guest.
> >
> > On top of that, the only way to 'safely' fetch the instruction would be
> > to pause all vCPUs in the VM to prevent the guest from remapping the
> > address space behind either KVM or the VMM's back.
> 
> Do we actually care about that, though?

Judging from the fact that our existing MMIO flows have a similar "bug",
I'd say no. I was just being pedantic about how annoying it'd be to do
this faithfully, including the VA -> IPA translation.

> If the guest does
> that isn't it equivalent to a hardware CPU happening to
> fetch the insn just-after a remapping rather than just-before?
> If you decode the insn and it's not a store you could just
> restart the guest...

Definitely, you'd need to restart any time the instruction doesn't line
up with the ESR. The pedantic thing I was thinking about was if the
instruction bytes remain the same but marked as non-executable:

	T1				T2
	==				==
					readl(addr);
					< MMIO data abort >
					insn = fetch(readl);
	set_nx(readl);
	tlbi(readl);
	dsb(ish);
					emulate(insn);

-- 
Thanks,
Oliver
