Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48F82175A87
	for <kvmarm@lists.linux.dev>; Tue,  5 May 2026 15:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777993620; cv=none; b=jg9eJupvNd2xNYORMSzbavfYw9+9oDgwi403fsAG6omAEr9l5hLRUXyL/HWmm6MFKyibfwInyp9QOtR+hnBLL2CSFDr3SMsrlU2wN+C4u9B0a+PeKiL+3SnY71h0dQvCke53oJqXBMAjRrLe6s8rtMExzw8u9II0Zx/cttgfW5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777993620; c=relaxed/simple;
	bh=BeYuC+U+TvY87kCGVgh7iHS9dj+g7bI/fKs9BPIiGBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mUOi7i0KwTDqCqCaZ5RW7jMN1v5HmoZ+s5XX/rxGIlPgPetfEimW4ObjXoaJkOEwl0WHtOjeItAQLQILN/ENy259OYt4fY5Aw6HDxWeXMz46cuP/m2s7xiwjqtW3mdVfledIZ9s1cRMVg3N3wB4+tWcKIOSfLJDYUNPhrtMB8CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=f+iBoUGk; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="f+iBoUGk"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C9BB165C;
	Tue,  5 May 2026 08:06:52 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E02F83F836;
	Tue,  5 May 2026 08:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777993617; bh=BeYuC+U+TvY87kCGVgh7iHS9dj+g7bI/fKs9BPIiGBk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f+iBoUGk8BmoZc0I83YuzJUwdRjjsapp0YmhbwVraS05rC5e8/lAxTo6QaBJzO/uz
	 XxwMCmGis1kvV3x3mcD/LXf1oAs+ephfkejwE3zO0tuJLrO6BlpAgIdVC8KOKKS1z0
	 5hKCdG2Glgkt/8ZNFa4lo3kv0SNaawo/o2/95uAI=
Date: Tue, 5 May 2026 16:06:51 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Sudeep Holla <sudeep.holla@kernel.org>
Cc: linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	jarkko@kernel.org, zohar@linux.ibm.com, roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org
Subject: Re: [RFC PATCH 2/3] firmware: arm_ffa: initialise ff-a after
 finalising pKVM initialisation
Message-ID: <afoHizU8NgFWzvYW@e129823.arm.com>
References: <20260505095409.1948371-1-yeoreum.yun@arm.com>
 <20260505095409.1948371-3-yeoreum.yun@arm.com>
 <20260505-super-gecko-of-argument-655030@sudeepholla>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505-super-gecko-of-argument-655030@sudeepholla>

Hi Sudeep,

> On Tue, May 05, 2026 at 10:54:08AM +0100, Yeoreum Yun wrote:
> > When pKVM is enabled, the FF-A driver must be initialised after pKVM.
> > Otherwise, pKVM cannot negotiate the FF-A version or obtain the RX/TX
> > buffer information, leading to failures in FF-A calls.
> > 
> > Currently, pKVM initialisation completes at device_initcall_sync,
> > while ffa_init() runs at the device_initcall level.
> > 
> > So far, linker deployes kvm_arm_init() before ffa_init(), and SMCs can
> > still be trapped even before finalise_pkvm() is invoked.
> > As a result, this issue has not been observed.
> > 
> > However, relying on above stuff is fragile.
> > Therefore, when pKVM is enabled, the FF-A infrastructure should be
> > initialised only after pKVM initialisation has been fully finalised.
> > 
> > To achieve this, introduce an ffa_root_dev ("arm-ffa") and
> > a corresponding driver to defer initialisation of the FF-A infrastructure
> > until pKVM initialisation is complete, and to defer probing of all FF-A devices until then
> > when pKVM is enabled.
> > 
> 
> I don't like this whole ffa root device design.
> Two question for now:
> 1. Can FF-A be a module on systems with pKVM which removes the need for all
>    this dance done here ?

But this means we reduce the other feature e.x) IMA with TPM over
FF-A and pKVM feature. Since IMA must be a built-in, we couldn't avoid
to build FF-A driver with built-in.

> 2. If it is a requirement to have this built-in, I prefer to add a probe
>    and defer it instead of this root ffa device.

But, How? anyway all of FF-A device & driver couldn't be probed unless
FF-A initialisation is finished and How can we trigger FF-A initailise
after pKVM finish its initialisation?

The problem is ff-a intiailisation happens before pKVM finish its
initailasation and to do defer probe, it should use dd-model and
As we discussed in other thread, notifier couldn't be a soluation.

Could you let me share other way I'm missing?

Thanks!

> -- 
> Regards,
> Sudeep

-- 
Sincerely,
Yeoreum Yun
