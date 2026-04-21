Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C8533A168B
	for <kvmarm@lists.linux.dev>; Tue, 21 Apr 2026 09:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776762731; cv=none; b=J0+NANHAd6sSf1nvguYHWRE4ClD+8zGeDXWHO4lwo5G9+nWz1uQUVa/MCVcL1y37BrsXGmDearmWphfPSlRU6cz+aLQYOIK3pWZA9Ubmh6dhdnQU8GyuBlV9XyokuELIUuabHHKiVPie9Do+Dev6iCKmscraxWTXAkjzQvmf+Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776762731; c=relaxed/simple;
	bh=bUki7691gF6PAdgoVdG4YA6Jl/b0UXzAgcjElizpR2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vd5HkQPg5BXNyMs12RM1bwWZv3wvhdte/Aj/vrtvnZyUY1qKCUJ4e+Fi3dola9um0D3YIdAMxVBouxF7H3uZD1VlGGZpYp3j+gt8cndM3S2THbZLBtm8QuIpHDl9qwnSOts61BZE2CvVTeDBV44dnZe0j0doz5JqERORtApW0/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OGniPLsi; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OGniPLsi"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB80625E0;
	Tue, 21 Apr 2026 02:12:02 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF5C93F641;
	Tue, 21 Apr 2026 02:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776762728; bh=bUki7691gF6PAdgoVdG4YA6Jl/b0UXzAgcjElizpR2c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OGniPLsiAh0DSyvAQ5HMjlIYa15Nz9Y+R15H0PhXbZ+6i7lwFWMIo2fK1tBXZmc6c
	 CJDGh1w13rrXBujXV81XH+KUHfoFW8C30GmjcKXD7XDvf6xppKXyTPQ8qpdwEnv14Z
	 U33+LK267IvzFlZkJIbw7cpxCc+Ho2cIdtbjqz9o=
Date: Tue, 21 Apr 2026 10:12:01 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Sudeep Holla <sudeep.holla@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	zohar@linux.ibm.com, roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com,
	peterhuewe@gmx.de, jarkko@kernel.org, jgg@ziepe.ca,
	oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org
Subject: Re: [RFC PATCH 4/4] firmware: arm_ffa: check pkvm initailised when
 initailise ffa driver
Message-ID: <aec/YSxYO1bOhXhn@e129823.arm.com>
References: <20260417175759.3191279-1-yeoreum.yun@arm.com>
 <20260417175759.3191279-5-yeoreum.yun@arm.com>
 <87se8sbozv.wl-maz@kernel.org>
 <aeNeNjfO7i128TIP@e129823.arm.com>
 <87pl3vb5bm.wl-maz@kernel.org>
 <aecf57rWloQwDh6v@e129823.arm.com>
 <20260421-married-liberal-ammonite-dffda8@sudeepholla>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421-married-liberal-ammonite-dffda8@sudeepholla>

> On Tue, Apr 21, 2026 at 07:57:43AM +0100, Yeoreum Yun wrote:
>
> [...]
>
> >
> > Also, the FF-A initialization is not driven by a device probe, but rather
> > happens as part of the bus registration itself,
> > so it does not fit well with a device_link or probe deferral based approach.
> >
> > Instead, perhaps we could go with the idea I mentioned previously:
> > either introduce a notifier, or create a pseudo ffa_device
> > once pKVM initialization has completed, and
> > then let the ffa driver perform the additional initialization from there.
> >
> > Am I missing something?
> >
>
> In order to handle/cleanup some ugliness in interrupt management in the
> FF-A driver, we may introduce DT node eventually. But it will take sometime.

Unfortunately, I think this DT node wouldn't be helpful to solve
this situation for dependency with the kvm misc device...

IMHO, current situation, the notifier seems to good option. unless
we make the initcall to recongise this dependency.

--
Sincerely,
Yeoreum Yun
