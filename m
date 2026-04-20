Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F98A8BE9;
	Mon, 20 Apr 2026 16:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776703808; cv=none; b=U5Cm+GZw47juf8W4OzOSN7iWFQx+ku5J8ec+7jaxyw1tjiY2LAceEEZF0U8LEbjjko8bExeU2sBsSDMeOhpSm4s/nhqrLHqnzW82my2T+hJTRLxmHHIabB5Zeu6unyWR66+gyvtf7N0bj7VHKcnZZvgnwzDVdHGrfrVNbawoH+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776703808; c=relaxed/simple;
	bh=AKF9yaMzIWbWagkxI0dMOZfdgR9VStvIl7neIOYfotI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lEJFCoJwPjdnhcjVhMGTIB7VDMBeCdSQXJF/RicaTSNbDAEvjOCDC5sKlPgzz02FreMBvyacODJQyo2Rhh9VaT7Gz0LPZiRaQJN7N6hrOADJ7llnEMVJXWBhtDBqpc283ToD7IVIfE7nXkn9gOSsQIT2TiemWnEbGrqqaFuRlqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PPawA7RH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PPawA7RH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBA0C19425;
	Mon, 20 Apr 2026 16:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776703808;
	bh=AKF9yaMzIWbWagkxI0dMOZfdgR9VStvIl7neIOYfotI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PPawA7RH6DotUc6sisJgZh2YZ7bFuZxq1Ef+VOUtUgjA1Wv+sjqEQEcLbco3xAf1Y
	 xa1QUsKcBYNuTV1FC38Rigudf8p8F4TDE9zbmy9kgLGwlbwFf4gNZZxoRnC7z2SWfH
	 rloJLe5ZtOv+1VJR4LU5e12BUqwQRlpjthLEfV2fsm3rUe6IX83OkeY+UK/3rknyRk
	 QXBzd6/3pVLBnpk7gD23zFLrjO3f2QXDGfoYarzRyjVQY6w19qrgzUKKRP4IBQ9EWB
	 swa+5CvWNpDJ+3szva+rXMAWmrPmPrgZHIpPBj36eh/uemUJRfNqfIG9Vcht3RQ2Xq
	 y6fMruH/jAY3A==
Date: Mon, 20 Apr 2026 17:50:01 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Sebastian Ene <sebastianene@google.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Sudeep Holla <sudeep.holla@kernel.org>,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	zohar@linux.ibm.com, roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com,
	peterhuewe@gmx.de, jarkko@kernel.org, jgg@ziepe.ca,
	oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org
Subject: Re: [RFC PATCH 4/4] firmware: arm_ffa: check pkvm initailised when
 initailise ffa driver
Message-ID: <20260420-swinging-stallion-of-refinement-0f26b0@sudeepholla>
References: <20260417175759.3191279-1-yeoreum.yun@arm.com>
 <20260417175759.3191279-5-yeoreum.yun@arm.com>
 <aeYbdmshGZJ4GhXd@google.com>
 <86mryx2408.wl-maz@kernel.org>
 <aeY2M3v97c00JjFe@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeY2M3v97c00JjFe@google.com>

On Mon, Apr 20, 2026 at 02:20:35PM +0000, Sebastian Ene wrote:
> On Mon, Apr 20, 2026 at 01:46:47PM +0100, Marc Zyngier wrote:
> > On Mon, 20 Apr 2026 13:32:32 +0100,
> > Sebastian Ene <sebastianene@google.com> wrote:
> > > 
> > > On Fri, Apr 17, 2026 at 06:57:59PM +0100, Yeoreum Yun wrote:
> > > 
> > > Hello Yeoreum,
> > > 
> > > 
> > > > When pKVM is enabled, the FF-A driver must be initialized after pKVM.
> > > > Otherwise, pKVM cannot negotiate the FF-A version or
> > > > obtain RX/TX buffer information, leading to failures in FF-A calls.
> > > 
> > > At the moment this already happens after you move back ffa_init() to
> > > device_initcall().
> > 
> > But relying on this sort of ordering is just making things more
> > fragile.
> > 
> 
> Thanks for letting me know. Since this is not a solid construct we will have
> to change the driver init code to come after pKVM in this case.
> 
> > > 
> > > > 
> > > > During FF-A driver initialization, check whether pKVM has been initialized.
> > > > If not, defer probing of the FF-A driver.
> > > > 
> > > 
> > > I don't think you need to add this dependency. pKVM is
> > > installed through KVM's module_init() which ends up calling hyp_ffa_init() to
> > > do the proxy initialization. The ARM-FFA driver comes after it (since
> > > pKVM is arch specific code). We don't have to call finalize_pkvm(..) to
> > > be able to handle smc(FF-A) calls in the hyp-proxy.
> > 
> > You do. Without the finalisation, SMCs are not trapped by EL2.
> > 
> > And even if it did, relying on such hack is just wrong.
> > 
> 
> That makes it an even stronger argument to move the driver init at a
> later stage. I was relying on this to trap early ff-a when the
> ARM FF-A driver was used.
> 

Indeed, if both are at `device_initcall` level, then correct behaviour is
effectively left to link order. That makes the outcome depend on build-time
ordering rather than on an explicit and well-defined dependency, which is
quite fragile and difficult to justify as a reliable fix.

That is precisely the kind of arrangement I am worried about here. Even if it
happens to work today, it is not guaranteed in any robust sense and can easily
break as the code evolves or as unrelated changes affect the link order. In
other words, it may appear functional, but it still lacks a proper dependency
model and remains vulnerable to subtle regressions.

-- 
Regards,
Sudeep
