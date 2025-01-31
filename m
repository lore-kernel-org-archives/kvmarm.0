Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE7C1C54BE
	for <kvmarm@lists.linux.dev>; Fri, 31 Jan 2025 17:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738345213; cv=none; b=UcVdOV7f4nJai4CVm29ixcB73MXD9yJ0jKK9O2/2Wvx3IoIVBJ5svUO8WHb6ajKj6e2782yp0Q6oEORe4aIbnH+N9RQ5pCPBHhNAV16p0slsJu01A9ZMqWAxw7fLVmCk0QU4WH8AGCBY+VVKTFuVVHhJeUgYNssl06o17Rk7VfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738345213; c=relaxed/simple;
	bh=okV/Kt94oXMruvh6NogC9buqKwaOfwoRVF9DUnuf/y4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WJNBLzNDGqz6o1hZPVBXitCQS8z22U9laGixSVHSUTpOgu8xzxiPOj1vaAxiOa5tEiJkNhrXOu1topGsEIJBQvUVAYQ+JXifarGDNrhB47LIAk9xQn18OH8mCFi0uZk3T6lOIF+WlZYedGWzqjIjgDyZhHHi8nh4k5bYISXwgs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BO1kvr3h; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BO1kvr3h"
Date: Fri, 31 Jan 2025 09:40:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738345209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rlodqL6yK3BGIsNrH6i3IJDGV8PpdHzqkTl8VYx6/30=;
	b=BO1kvr3hGnY3TUfFREG91fgDSDvM5EjAT+3nGDRhMxfmYWVF8eLXgjnqo0MN/XQsExy3hd
	5Iewav6yDBNcQNqDNCFLYYGwd+KKR9V/tqsNZ4WrHWMQToIg7PNtF1D/U1qJxIsshj8Nam
	Dykp4/3MeeGNkaxXTruRv4U2HdHP3xs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
	joey.gouly@arm.com, kvmarm@lists.linux.dev, maz@kernel.org,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com
Subject: Re: [PATCH 0/4] arm64: mitigate CVE-2024-7881 in the absence of
 firmware mitigation
Message-ID: <Z50K8V9u9hyB2Pz-@linux.dev>
References: <20250128155428.210645-1-mark.rutland@arm.com>
 <Z5vzxWX4AY-JY4TV@linux.dev>
 <Z5ytkrfzphlio2Ow@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5ytkrfzphlio2Ow@J2N7QTR9R3>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 31, 2025 at 11:01:38AM +0000, Mark Rutland wrote:
> On Thu, Jan 30, 2025 at 01:48:53PM -0800, Oliver Upton wrote:
> > Hi Mark,
> > 
> > On Tue, Jan 28, 2025 at 03:54:24PM +0000, Mark Rutland wrote:
> > > On some CPUs from Arm Ltd, it is possible for unprivileged code to cause
> > > a hardware prefetcher to form an address using the contents of a memory
> > > location which is accessible by privileged accesses in the active
> > > translation regime, potentially leaking the contents of this memory
> > > location via a side channel. This has been assigned CVE-2024-7881:
> > > 
> > >   https://developer.arm.com/Arm%20Security%20Center/Arm%20CPU%20Vulnerability%20CVE-2024-7881
> > > 
> > > Arm's recommended mitigation is that firmware configures an
> > > IMPLEMENTATION DEFINED control bit (CPUACTLR6_EL1[41]) to disable the
> > > affected prefetcher, and updates to Trusted Firmware-A are available to
> > > do this. For systems which have not yet recevied a firmware update, KPTI
> > > can help to mitigate the issue.
> > > 
> > > These patches enable KPTI for affected parts when the firmware
> > > mitigation is not present. The presence of the mitigation is identified
> > > by the presence of the SMCCC_ARCH_WORKAROUND_4 SMCCC call, which was
> > > deployed with the mitigation. This is documented in the SMCCC 1.6 G BET0
> > > specification:
> > > 
> > >   https://developer.arm.com/documentation/den0028/gbet0/?lang=en
> > > 
> > > I have tested this on a few configurations of virtual platforms. I'd
> > > appreciate any feedback, especially on the KVM changes.
> > 
> > The KVM changes look reasonable and follow the usual model for this
> > crud. It would be nice to report the mitigation state to userspace
> > somehow as I would like to have a KVM selftest for all of the hardware
> > vulnerabilities.
> 
> Lemme go figure that out. Just to check, do you mean exposed through a
> KVM mechanism, or under /sys/devices/system/cpu/vulnerabilities/ ? I
> assume the latter.

Yep, the latter. Google has a test out of tree that checks the pseudo-FW
registers, hypercalls, and guest ID registers against what's in sysfs.

-- 
Thanks,
Oliver
