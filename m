Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3DB91F09A8
	for <kvmarm@lists.linux.dev>; Sat, 23 May 2026 06:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779517673; cv=none; b=Beql68mk1mpVTRmduFBncbGxU+D0N0gmC8lNUkxEnFYinwMTQLkTCNS6WgqO5qu7s4LaYTFfynVw8T8o9sIddE15ZvIdmcLFcuekDVmeV7yYyhGtvYEmgZPKo0H6kJhD5iiwrR9Vm6oaOuDiQCybqyQ4idKhuSee0My2eqrdssE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779517673; c=relaxed/simple;
	bh=JEVR6CkLj/c0gaMD1sZUS4SWLivaFbisW4FMLpwuuDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pbq/girzGJE5u0NofQRHDKwM55DQq8CWpJ0YgBhZ1jN6WOCi1bHBY/p59ewb8nWSW/vxY4m7qWrgz+FSactctYYWyx6DDfq5zcZgtTZCtBhCNBeOkcSlAKX0lrGWNbIJd3yTHoA/x34kbEsBWJJRCzfvfvDBDzuPllW2BRLxn28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=uIQJFM/c; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="uIQJFM/c"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3A2C21F02;
	Fri, 22 May 2026 23:27:46 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 211CB3F7B4;
	Fri, 22 May 2026 23:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779517671; bh=JEVR6CkLj/c0gaMD1sZUS4SWLivaFbisW4FMLpwuuDg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uIQJFM/cEmjlN4stENbpOIKjt/iyaSbTyh5hLaLGIXxF5+qBDVQp/OE3m2CxHVp/O
	 sWtBL7579DfUCAmc8WHI8dr0MQGjw0iVJjBYEegAij/WaCFEgrX6P4bNO4EZyU8DAI
	 8mOq6ipz1yrieS4cv9bsHmMFlxHkSofGAUYfjwE4=
Date: Sat, 23 May 2026 07:27:47 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Sudeep Holla <sudeep.holla@kernel.org>,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 2/4] firmware: arm_ffa: Register core as a platform driver
Message-ID: <ahFI43hT9eoktFlU@e129823.arm.com>
References: <20260508-b4-ffa_plat_dev-v1-0-c5a30f8cf7b8@kernel.org>
 <20260508-b4-ffa_plat_dev-v1-2-c5a30f8cf7b8@kernel.org>
 <20260523001148.GA1319283@ax162>
 <ahEyBrZGSVbdQxDJ@e129823.arm.com>
 <20260523050555.GA1121518@ax162>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260523050555.GA1121518@ax162>

On Fri, May 22, 2026 at 10:05:55PM -0700, Nathan Chancellor wrote:
> On Sat, May 23, 2026 at 05:50:14AM +0100, Yeoreum Yun wrote:
> > Hi Nathan,
> > 
> > > Hi Sudeep,
> > > 
> > > On Fri, May 08, 2026 at 06:54:16PM +0100, Sudeep Holla wrote:
> > > > Move the FF-A core bring-up and teardown paths into platform driver
> > > > probe and remove callbacks, and register a synthetic arm-ffa platform
> > > > device to bind the driver.
> > > > 
> > > > This makes the FF-A core lifetime follow the driver model while keeping
> > > > the device creation internal to the FF-A core. Use normal platform driver
> > > > registration so the probe path has standard driver-core semantics.
> > > > 
> > > > The synthetic platform device is a temporary bridge until ACPI and
> > > > devicetree describe the FF-A core device or object. Once those firmware
> > > > description paths are defined, the internal platform device creation can
> > > > be dropped and the driver can bind to the firmware-described device
> > > > directly.
> > > > 
> > > > Since the transport selection now happens from the platform probe path,
> > > > drop the __init annotation from ffa_transport_init().
> > > > 
> > > > Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
> > > 
> > > I am seeing
> > > 
> > >   arm-ffa arm-ffa: probe with driver arm-ffa failed with error -95
> > > 
> > > on my two arm64 test machines after this change landed in -next as
> > > commit e659fc8e537c ("firmware: arm_ffa: Register core as a platform
> > > driver"), is this expected? If so, perhaps it should be silenced?
> > 
> > Could you share the .config file you used for this?
> 
> Sure thing! It is attached. If you need anything else, please let me
> know.

Thanks! unless there was other error log from ff-a driver,
I think this happens because your environment either doesn’t
support FF-A or is using an SMCCC version earlier than 1.2 from
ffa_version_check() or ffa_transport_init().

If that’s the case, You can ignore this log since this behavior is
expected, and the dd core should print an error log.
Before this patch, the error was not shown because all FF-A initialization
was done during the initcall phase, and nothing was printed
even when the initcall function returned an error from caller of initcall.

[...]

--
Sincerely,
Yeoreum Yun
