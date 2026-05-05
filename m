Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDDC3624C9;
	Tue,  5 May 2026 14:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777991974; cv=none; b=fRAKN2qdaVJPQSqYEG4gm1YnoHvieMt+VQ3EAaSpDR9IejZ/WppJhUZtZ9dLYDK9LgLsQXJKvvG4zAEiD/Vd956/OMci6mF71uDaRkfkLBQ6z0oP4D/0wCSlYDHKZGjOG+pYZBjAFPt53A3cz4NZ4ma5pQgOe1MdAllE3zG1KeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777991974; c=relaxed/simple;
	bh=NgwaOYYhwkJoidvqP9ynAMiAuhZHiTJ5mxPCuvHYbM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W2Z/Lqx+1zbaEMV3abj7Fztm7l5ur8oREW9jCLyHt+9OPIzQLy7n8AYXWEtKTfJg+BfIelFJVZ8BKREM3gx5qB+fuz0xgHXtz5796C/b5OPI/HsWA7kfEDpORtmMjCPBlBXZlAm1nRpjbhgnsleViECXjNxwPUBU+YBVY4ilEJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bvYfCPdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bvYfCPdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2880C2BCB4;
	Tue,  5 May 2026 14:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777991973;
	bh=NgwaOYYhwkJoidvqP9ynAMiAuhZHiTJ5mxPCuvHYbM4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bvYfCPdEURheb7BU5RKgPvIL+Vd0jex98+FTp1gb0vtK2vTkS8ONmY2bBZDIshbB9
	 z2FEbM5CHxGKeDHpIl/bU28tnETNo8/UupR8KVhyLLEzi0LkCW99D9wh8WAhak/pFo
	 zfaxYthB9lMPsbzd20eSvu2+0A+IhuJAmaHwO/XQLh57NsDpPxBED3q3tWggEIt2cC
	 U1S7jFYiUt1Lz6hu5sQDX3ra2cAI0KVEc7c8CbrfoGdMLFRlLN0CFkMJLHt0K9+Tov
	 o2+fcoWTCpsacPoeehvuyfcDGsXMr6CWbkJAtkD2vJKx/CDY+kB9dMjVblusWkL7Kc
	 Zbi+jt7w3hYTA==
Date: Tue, 5 May 2026 15:39:27 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
	Sudeep Holla <sudeep.holla@kernel.org>,
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
Message-ID: <20260505-super-gecko-of-argument-655030@sudeepholla>
References: <20260505095409.1948371-1-yeoreum.yun@arm.com>
 <20260505095409.1948371-3-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505095409.1948371-3-yeoreum.yun@arm.com>

On Tue, May 05, 2026 at 10:54:08AM +0100, Yeoreum Yun wrote:
> When pKVM is enabled, the FF-A driver must be initialised after pKVM.
> Otherwise, pKVM cannot negotiate the FF-A version or obtain the RX/TX
> buffer information, leading to failures in FF-A calls.
> 
> Currently, pKVM initialisation completes at device_initcall_sync,
> while ffa_init() runs at the device_initcall level.
> 
> So far, linker deployes kvm_arm_init() before ffa_init(), and SMCs can
> still be trapped even before finalise_pkvm() is invoked.
> As a result, this issue has not been observed.
> 
> However, relying on above stuff is fragile.
> Therefore, when pKVM is enabled, the FF-A infrastructure should be
> initialised only after pKVM initialisation has been fully finalised.
> 
> To achieve this, introduce an ffa_root_dev ("arm-ffa") and
> a corresponding driver to defer initialisation of the FF-A infrastructure
> until pKVM initialisation is complete, and to defer probing of all FF-A devices until then
> when pKVM is enabled.
> 

I don't like this whole ffa root device design.
Two question for now:
1. Can FF-A be a module on systems with pKVM which removes the need for all
   this dance done here ?
2. If it is a requirement to have this built-in, I prefer to add a probe
   and defer it instead of this root ffa device.

-- 
Regards,
Sudeep
