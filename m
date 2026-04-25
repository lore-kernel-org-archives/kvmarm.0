Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4977B5CDF1
	for <kvmarm@lists.linux.dev>; Sat, 25 Apr 2026 04:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777092810; cv=none; b=Us2ZyePlTvpvnSy/+tIw2AWdYcdoCa8za7Bj8X3Sxb2to8E2KsC9J6DJb4zhIW4fKKXa5HepoaoajUIAMGkjoVzZUHDsR1UrCt+6Dfj3dHAzbzE1I8FUzYNaeaIcmjYKw16cMKKDk2wiKDFoGT4p5mkZ2Fy3rP5A40pdZqssrMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777092810; c=relaxed/simple;
	bh=+9u7EK2Y/HhdgOEE30vcAjodDpWFlSP0b0+cZVFApXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q7VaLvZiy9ztzQeZ9MeoW18asfod8t+p+DaiYdJb9G6DqW2R/Vkss8dHkbuJZ05h1BE4tRgggBakxIvagSSEW9zybOHiDwhGvpEVyda3mnmc40kFLnyDPYONZuYBxTZl10GmEeaATkJHvNpuWhc0OOaPI9e16kX6hHtN6X58ujk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mpyx+TbM; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mpyx+TbM"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F16E335AB;
	Fri, 24 Apr 2026 21:53:21 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 597DE3F62B;
	Fri, 24 Apr 2026 21:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777092807; bh=+9u7EK2Y/HhdgOEE30vcAjodDpWFlSP0b0+cZVFApXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mpyx+TbMIq+ior7LsPTIlyZk8u/VbsgXRov22WCh+KdsLt06ArcEHlBUHXOlw+5tP
	 zoH8OS46iFTYFpYFWcrsJrw3oFSPduaM14w1BBFJd/fUg7AujO/atqUP3oPa8LMf2A
	 NS6wirQcjTnwHLgYLDMgefazm5Gmke6C/JKNzV4w=
Date: Sat, 25 Apr 2026 05:53:20 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Paul Moore <paul@paul-moore.com>, roberto.sassu@huawei.com,
	Jonathan McDowell <noodles@earth.li>,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	jmorris@namei.org, serge@hallyn.com, dmitry.kasatkin@gmail.com,
	eric.snowberg@oracle.com, jarkko@kernel.org, jgg@ziepe.ca,
	sudeep.holla@kernel.org, maz@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, noodles@meta.com,
	sebastianene@google.com
Subject: Re: [RFC PATCH v2 1/4] security: ima: call ima_init() again at
 late_initcall_sync for defered TPM
Message-ID: <aexIwJpno3iPIdRD@e129823.arm.com>
References: <bd908e28298d968740d03c97bc7e441de188b7b4.camel@linux.ibm.com>
 <aeokwrC86WI7uT+K@e129823.arm.com>
 <aeomlp3I0eVE5mce@earth.li>
 <aeotq8nPVu4wvEx5@e129823.arm.com>
 <e4e242ae5533d5762a3647186a178764881bf9ff.camel@linux.ibm.com>
 <aephL3MzYoqFGaT5@e129823.arm.com>
 <CAHC9VhRQWHEWQ5NzOPiu8jtYv6UsRm8WVS4fd74AbkOcAd4y_g@mail.gmail.com>
 <aesGU8a3mbVzvteH@e129823.arm.com>
 <CAHC9VhSaT_quKYnpFjAfqvL07JNbWMgM6c4pB9F46NHawX3DCA@mail.gmail.com>
 <014cf39aa8d6a0bcfa1a95c069675977ac67b843.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <014cf39aa8d6a0bcfa1a95c069675977ac67b843.camel@linux.ibm.com>

[...]
> > I understand the need to ensure that the TPM is available, but if it
> > isn't safe to wait to initialize IMA at late_initcall_sync() then it
> > would seem like this is a bad option and we need another mechanism to
> > synchronize IMA with TPM devices.  If it is safe to initalize IMA in
> > late_initcall_sync(), just do that and be done with it.
>
> Within the same initcall level there is no way of ordering the initialization.
> Yeorum attempted to address the ordering issue in commit 0e0546eabcd6
> ("firmware: arm_ffa: Change initcall level of ffa_init() to rootfs_initcall"),
> which is being reverted in this patch set.
>
> Ordering within an initcall level needs to be fixed, but for now retrying at
> late_initcall_sync works for some, hopefully most, cases.

Ordering within an initcall level is not good idea.

Though it came to my mind first long ago,
It also goes against existing mechanisms like deferred probe, and
can cause the driver model’s dependency handling to harden
in the wrong direction. So this I think it wouldn't be an option.

--
Sincerely,
Yeoreum Yun
