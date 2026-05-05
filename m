Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AF933845CB
	for <kvmarm@lists.linux.dev>; Tue,  5 May 2026 11:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777979822; cv=none; b=kF9Q/9qweWXQkkQ5lTWc6eQExHSOZ1rjeQoNCAqKglRWH300NjzzyUQ+lhtw/3SrBCe5QTXgbgwYzL4P0RA9GCC/cK9RuJWACe33j5pfhUDUU5YXisf4f47FnBMjLZD5mVU+kbksoGS/oAxwXAwbzIPA3z4846quWc7emtpA2KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777979822; c=relaxed/simple;
	bh=0zBd8wva2lIq2UG6LFH51+kY22Y+m/b1XM8Xt6AEgUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eu6r5A/Q8AlmLj4870mm44BJCDVU2NW3HvqqzdAt5Nh7x4nF0hF8fVlYeX5mZ0ews3uUZ8qkBZlOAu6cWW0KFqayfJoU8VvPysUT9aRgxgkQb1XsJGGuq+k2EjvHe2YdMxY3l8ZCHMlTleIQI9UNuX0JvWYkwhdwSEpKBmRxZbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TgXY4NXh; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TgXY4NXh"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0851A28FA;
	Tue,  5 May 2026 04:16:55 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 49B5F3F836;
	Tue,  5 May 2026 04:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777979820; bh=0zBd8wva2lIq2UG6LFH51+kY22Y+m/b1XM8Xt6AEgUY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TgXY4NXhIx2uDQtS0+FeUAocTNO/hz/3iB1TpIUaaRDIUIEFp3/HJJkl0ejwC72QX
	 9cP5IiB+uC8oCB2nihgKqV/IctWHgVbGec1iw5QPPe4UAjjLb5iGXgMDxY0jk2hmL2
	 WSNQ2ZVG7uXjr3eR1SnEOGFhGx6V09e/ChdG1Z74=
Date: Tue, 5 May 2026 12:16:54 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Ben Horgan <ben.horgan@arm.com>
Cc: linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	jarkko@kernel.org, zohar@linux.ibm.com, roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, sudeep.holla@kernel.org
Subject: Re: [RFC PATCH 0/3] initalise ff-a after finalising pKVM
Message-ID: <afnRptWilWr7nABJ@e129823.arm.com>
References: <20260505095409.1948371-1-yeoreum.yun@arm.com>
 <8942c12e-6315-493e-98c5-d55f4e6341f4@arm.com>
 <afnLpG4osopTzpip@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afnLpG4osopTzpip@e129823.arm.com>

> Hi Ben,
> 
> > Hi Levi,
> > 
> > On 5/5/26 10:54, Yeoreum Yun wrote:
> > > This patch is split out from the patchset [0] --
> > > fix FF-A call failure with pKVM when the FF-A driver is built-in,
> > > specifically the IMA-related part.
> > > 
> > > When pKVM is enabled, the FF-A driver must be initialised after pKVM.
> > > Otherwise, pKVM cannot negotiate the FF-A version or obtain the RX/TX
> > > buffer information, leading to failures in FF-A calls.
> > > 
> > > Currently, pKVM initialisation completes at device_initcall_sync,
> > > while ffa_init() runs at the device_initcall level.
> > > 
> > > So far, linker deployes kvm_arm_init() before ffa_init(), and SMCs can
> > > still be trapped even before finalise_pkvm() is invoked.
> > > As a result, this issue has not been observed.
> > > 
> > > However, relying on above stuff is fragile.
> > > Therefore, when pKVM is enabled, the FF-A infrastructure should be
> > > initialised only after pKVM initialisation has been fully finalised.
> > > 
> > > To achieve this, introduce an ffa_root_dev ("arm-ffa") and
> > > a corresponding driver to defer initialisation of the FF-A infrastructure
> > > until pKVM initialisation is complete, and to defer probing of all FF-A devices until then
> > > when pKVM is enabled.
> > > 
> > > This patch is based on v7.1-rc2
> > > 
> > > Question:
> > > 
> > > FF-A initialisation can occur at late_initcall. Because it may be deferred,
> > > some FF-A requests cannot be serviced at that stage.
> > > A typical example is the EFI runtime variable service using DIRECT_MSG_REQ.
> > > 
> > > Depending on the platform, the EFI runtime variable service runs with StandaloneMm
> > > and uses FF-A DIRECT_REQ. However, when pKVM is enabled, FF-A initialisation
> > > may be deferred to late_initcall. In this case, load_uefi_certs()
> > > can fail if it is invoked before the FF-A driver is initialised
> > > via deferred_probe_initcall().
> > > 
> > > Moving load_uefi_certs() to late_initcall_sync, as in the third patch,
> > > seems not to have any problem since late_initcall and
> > > late_initcall_sync are both of do_basic_setup() and it's before loading
> > > init process. However, it is still unclear whether
> > > it would be better to allow DIRECT_MSG_REQ in kvm_host_ffa_handler()
> > 
> > The spec doesn't allow this. Looking at DEN0077A 1.2 REL0:
> > 
> > Section 13.2.2 says:
> > 
> > "If they are compatible, it enables them to determine which Framework functionalities can be used. Hence, negotiation of
> > the version must happen before an invocation of any other FF-A ABI."
> > 
> > and a bit further down
> > 
> > "Once the caller invokes any FF-A ABI other than FFA_VERSION, the version negotiation phase is complete."
> > 
> > I would have thought that an SP would only go into the waiting state once the version negotiation is done.
> 
> I mean the negotiation between hypervisor and ff-a driver.
> actually the version negotiation is done with SPMC in
> hyp_ffa_init() but the negotiaion between hypervisor and ff-a driver
> just choose the lower version between version requested from ff-a driver
> and negotiated version with hypervisor and SPMC.

Sorry. re-parse the word, not choose "re-negotiate" when
FF-A driver request lowever version.

> 
> So, the version negotiation is already done with SPMC
> but with FF-A driver with hypervisor is not yet.
> However, DIRECT_MSG_REQ has supported from v1.0 
> In this situation, is there any reason not to send DIRECT_REQ_MSG?

IOW, question is that some of ff-a request can be allowed
before version negotiation with FF-A driver but
using negotiated version via hyp_ffa_init() first or not.

[...]

Thanks.

-- 
Sincerely,
Yeoreum Yun
