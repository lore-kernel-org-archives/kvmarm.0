Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5312B19CD1D
	for <kvmarm@lists.linux.dev>; Sat, 23 May 2026 04:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779511821; cv=none; b=JOApPv78RuEQwBn5QiMLlKsIGJMnhdXZvixuwQWg70qCPyWmzqrcGxNmzbdC+zdleDm/66g/ckP/2JVZJi6VcsU02G+QqS0SPmoN5gREimd2O2D00kryqIM+8HU3965m2EyEbl/buBEWy1A0vP98B5tczBR/Fks7wngHvgUeip4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779511821; c=relaxed/simple;
	bh=XmvhcCMIyo6mbxY7y8SuJFHc01ftQ4EjSoIcMDfl8vM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BoS044QkKAdr4Vl3IT1jtp1AU4KvkLYdsvhpMqh2GJUK9t/srtLBEooNtsjr6hrTt0AgrUwgDl4/b3W7d5Rs+Y86WpdvsPj3Ihbb13qahIxR+XdMdH1+gKUUMJc0XWVhfDZpMJuWut1HNHdIcxbc5WtIbaLy44QKvpPWsNo+0es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bzHVuZt+; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bzHVuZt+"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4BCF81D15;
	Fri, 22 May 2026 21:50:13 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 138B63F85F;
	Fri, 22 May 2026 21:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779511818; bh=XmvhcCMIyo6mbxY7y8SuJFHc01ftQ4EjSoIcMDfl8vM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bzHVuZt+7Gx0IxrA/jJUyXVmCQt7cfSi6k2mMPe8nHd4sfRjVlGTNBoGM5H52rIVN
	 8A3HtdwyDPKY8sMi+Ut8F8j3d40pXrL7n/BBO3SK1gqNrdHDwjIAKUICsChx131qDp
	 QSk/Uav64ygKlsTZaSAwXeNfEvYNn4lDNK2r43uk=
Date: Sat, 23 May 2026 05:50:14 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Sudeep Holla <sudeep.holla@kernel.org>, yeoreum.yun@arm.com,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 2/4] firmware: arm_ffa: Register core as a platform driver
Message-ID: <ahEyBrZGSVbdQxDJ@e129823.arm.com>
References: <20260508-b4-ffa_plat_dev-v1-0-c5a30f8cf7b8@kernel.org>
 <20260508-b4-ffa_plat_dev-v1-2-c5a30f8cf7b8@kernel.org>
 <20260523001148.GA1319283@ax162>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523001148.GA1319283@ax162>

Hi Nathan,

> Hi Sudeep,
> 
> On Fri, May 08, 2026 at 06:54:16PM +0100, Sudeep Holla wrote:
> > Move the FF-A core bring-up and teardown paths into platform driver
> > probe and remove callbacks, and register a synthetic arm-ffa platform
> > device to bind the driver.
> > 
> > This makes the FF-A core lifetime follow the driver model while keeping
> > the device creation internal to the FF-A core. Use normal platform driver
> > registration so the probe path has standard driver-core semantics.
> > 
> > The synthetic platform device is a temporary bridge until ACPI and
> > devicetree describe the FF-A core device or object. Once those firmware
> > description paths are defined, the internal platform device creation can
> > be dropped and the driver can bind to the firmware-described device
> > directly.
> > 
> > Since the transport selection now happens from the platform probe path,
> > drop the __init annotation from ffa_transport_init().
> > 
> > Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
> 
> I am seeing
> 
>   arm-ffa arm-ffa: probe with driver arm-ffa failed with error -95
> 
> on my two arm64 test machines after this change landed in -next as
> commit e659fc8e537c ("firmware: arm_ffa: Register core as a platform
> driver"), is this expected? If so, perhaps it should be silenced?
> 
> Cheers,
> Nathan
>

Could you share the .config file you used for this?

Thanks!

[...]

-- 
Sincerely,
Yeoreum Yun
