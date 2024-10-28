Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797C1185B54
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 16:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730134629; cv=none; b=XZWjnKikkx1zgYRcG8BUpCO35KTTcOXTfn2oDS7GOvcdaIOjYax8rR3fhA0HztvMBv9osVUjTxvDkytK+YF4O7dq0mUb57Mw4JGvWB51b28J/Gw/YfMhDYBw7/DdC1s5w2VPs8+YKwEiUeEzkhePtrs1FHEDad5fxLvFfZzs5SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730134629; c=relaxed/simple;
	bh=RdmZDTDE9BLeG7dsYyPI4ThDSYWwXURmUVr8J/1j2ww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kgwLKSevksmh9XO4OJ+iESmfyCbSRSy6ghsnveP1V1mYN82lsRtsOVOIN5lIulSlZoaxzACinQu17gaJeOKa6Fdz+M8LcFxdIvFnahikHR1GZcx3t6/0TcjWjetVzC8nb1udLluksvoDeMrbGxHWCY+suy6LwY3WWvPz1/ii4/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cCvZSEcF; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cCvZSEcF"
Date: Mon, 28 Oct 2024 09:56:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730134621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/KOhnqIpYwSqkh+if8TVn48GnX568QbnMCx/zN5PUM4=;
	b=cCvZSEcFd/1XGsQIynCXj1VZLmsOYP6o3327svSfwJaceesyFRqzjIO6goaWG2ST7TPqHO
	8RV5bF238tMqz1xocrZBoQ5YPb4CYfFjXZ0WlGrD50G1L/rUtASS+lTVhayvg+go7wmbgx
	+srcoP8+vCGtfmwRcmYlVuiW7ho49zY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
	cohuck@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev, richard.henderson@linaro.org,
	alex.bennee@linaro.org, maz@kernel.org, sebott@redhat.com,
	shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
	abologna@redhat.com, jdenemar@redhat.com, shahuang@redhat.com,
	mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [RFC 18/21] arm/cpu: Introduce a customizable kvm host cpu model
Message-ID: <Zx_CU9eeQByANMRW@linux.dev>
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-19-eric.auger@redhat.com>
 <ZxuX4i9NjVRizB72@redhat.com>
 <cb6c8f62-c5dc-416d-865f-fbdf96164dac@redhat.com>
 <Zxub7ol4p8P_sWF8@redhat.com>
 <CAFEAcA_wQu17y0PyQwxw0wuf2H5y2VE5aX16nLP2-u7QUP2ggA@mail.gmail.com>
 <Zx-9WxXkmkMuGIlQ@redhat.com>
 <CAFEAcA9w0mb5bcU8p+fScQony-=oqLmNurGWpnL_sBneQCzxUg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFEAcA9w0mb5bcU8p+fScQony-=oqLmNurGWpnL_sBneQCzxUg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 28, 2024 at 04:48:18PM +0000, Peter Maydell wrote:
> On Mon, 28 Oct 2024 at 16:35, Daniel P. Berrangé <berrange@redhat.com> wrote:
> >
> > On Mon, Oct 28, 2024 at 04:16:31PM +0000, Peter Maydell wrote:
> > > On Fri, 25 Oct 2024 at 14:24, Daniel P. Berrangé <berrange@redhat.com> wrote:
> > > > On Fri, Oct 25, 2024 at 03:18:25PM +0200, Eric Auger wrote:
> > > > > On 10/25/24 15:06, Daniel P. Berrangé wrote:
> > > > > > Also, is this naming convention really the same one that users
> > > > > > will see when they look at /proc/cpuinfo to view features ? It
> > > > > No it is not. I do agree that the custom cpu model is very low level. It
> > > > > is very well suited to test all series turning ID regs as writable but
> > > > > this would require an extra layer that adapts /proc/cpuinfo feature
> > > > > level to this regid/field abstraction.
> > > > >
> > > > > In /cpu/proc you will see somethink like:
> > > > >  Features    : fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp
> > > > > asimdhp cpuid asimdrdm lrcpc dcpop asimddp
> > > >
> > > > Right, IMHO, this is the terminology that QEMU must use in user
> > > > facing APIs.
> > >
> > > /proc/cpuinfo's naming is rather weird for historical
> > > reasons (for instance there is only one FEAT_FP16 feature
> > > but cpuinfo lists "fphp" and "asimdhp" separately).
> >
> > There's plenty of wierd history in x86 too. In this
> > case I might suggest just picking one of the two
> > common names, and ignoring the other.
> >
> > If we really wanted to, we could alias the 2nd name
> > to the first, but its likely not worth the bother.
> 
> Or we could use the standard set of architectural
> feature names, and not have the problem at all, and not
> have to document what we mean by our nonstandard names.

+1

There's existing documentation [*] for the standard feature names, which
provides:

 - A short description of what the feature does
 - Any dependencies a particular feature has (e.g.FEAT_VHE implies
   FEAT_LSE, FEAT_Debugv8p1, and FEAT_AA64EL2)
 - The register fields/values that are used to discover the feature.

This seems like the most user-friendly option...

[*]: https://developer.arm.com/documentation/109697/2024_09

-- 
Thanks,
Oliver
