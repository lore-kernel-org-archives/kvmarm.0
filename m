Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82511322E
	for <kvmarm@lists.linux.dev>; Fri, 31 Jan 2025 11:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738321305; cv=none; b=Fy/hDABOO1Ct1ZnVufzFFqFfLg6bH351dWk6nshiPc3/8S7tGGJrWzohfm7CtR8/0NfO2SGvC0VuioP/OzHbyESyAyc6HKJRt562fpP2TLm6tGM/nTopytUimENyX5jixbR2BV6FcP5eQYQsKCLD9Kuw/1wHd/5el5Bab8hvzOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738321305; c=relaxed/simple;
	bh=tt7H/zNsZKG0S60obN/uvyN04GjacLQklnYE3MKKk9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SLS0QdNxu3y0u1zDhS2eV8kRpYnT+X1nyRt4je1PfBhWokLmzoEsINdBl2PUNy4tNlL0Fz5Nf6tuLiwM1v6rv7Js2o4a/VJSL0gHNKgDIDAFXiz2DaOX0h6+Rrr/smfpTKv8W2lYQbll6plprJZL5RrqfUmPwXO4lAiTNY29lwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3C83E497;
	Fri, 31 Jan 2025 03:02:08 -0800 (PST)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 24B813F63F;
	Fri, 31 Jan 2025 03:01:41 -0800 (PST)
Date: Fri, 31 Jan 2025 11:01:38 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
	joey.gouly@arm.com, kvmarm@lists.linux.dev, maz@kernel.org,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com
Subject: Re: [PATCH 0/4] arm64: mitigate CVE-2024-7881 in the absence of
 firmware mitigation
Message-ID: <Z5ytkrfzphlio2Ow@J2N7QTR9R3>
References: <20250128155428.210645-1-mark.rutland@arm.com>
 <Z5vzxWX4AY-JY4TV@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5vzxWX4AY-JY4TV@linux.dev>

On Thu, Jan 30, 2025 at 01:48:53PM -0800, Oliver Upton wrote:
> Hi Mark,
> 
> On Tue, Jan 28, 2025 at 03:54:24PM +0000, Mark Rutland wrote:
> > On some CPUs from Arm Ltd, it is possible for unprivileged code to cause
> > a hardware prefetcher to form an address using the contents of a memory
> > location which is accessible by privileged accesses in the active
> > translation regime, potentially leaking the contents of this memory
> > location via a side channel. This has been assigned CVE-2024-7881:
> > 
> >   https://developer.arm.com/Arm%20Security%20Center/Arm%20CPU%20Vulnerability%20CVE-2024-7881
> > 
> > Arm's recommended mitigation is that firmware configures an
> > IMPLEMENTATION DEFINED control bit (CPUACTLR6_EL1[41]) to disable the
> > affected prefetcher, and updates to Trusted Firmware-A are available to
> > do this. For systems which have not yet recevied a firmware update, KPTI
> > can help to mitigate the issue.
> > 
> > These patches enable KPTI for affected parts when the firmware
> > mitigation is not present. The presence of the mitigation is identified
> > by the presence of the SMCCC_ARCH_WORKAROUND_4 SMCCC call, which was
> > deployed with the mitigation. This is documented in the SMCCC 1.6 G BET0
> > specification:
> > 
> >   https://developer.arm.com/documentation/den0028/gbet0/?lang=en
> > 
> > I have tested this on a few configurations of virtual platforms. I'd
> > appreciate any feedback, especially on the KVM changes.
> 
> The KVM changes look reasonable and follow the usual model for this
> crud. It would be nice to report the mitigation state to userspace
> somehow as I would like to have a KVM selftest for all of the hardware
> vulnerabilities.

Lemme go figure that out. Just to check, do you mean exposed through a
KVM mechanism, or under /sys/devices/system/cpu/vulnerabilities/ ? I
assume the latter.

> But anyway,
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks; much appreciated!

Mark.
