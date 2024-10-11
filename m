Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDE8839EB
	for <kvmarm@lists.linux.dev>; Fri, 11 Oct 2024 17:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728666458; cv=none; b=Ep7dwvRQ1dbH5nARj5Mx29TXSt+iqnHkWaeLF1b04POwsWvi2l6PWYL3OJnJ+1bGMsYHIhnVejI1bKm/Nh5mxeCP7ou4vAna1tjVxt0Z0wp/yR7w+4my/07VH4QzBqCiNh1GVXAwlL1OMum+HT8+DkAWPl+xOO9Q9o8imj6tf1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728666458; c=relaxed/simple;
	bh=EdLNFzYgBv6ON5GklIDUzCSCqxp3LdQEQNvY6fWjudg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kt7cJEId0Txw4lQhF1o4fbVttEj89afsUFsQV4vHPTmzOTOKPLv3LFm8KelOL5kqQdh3aug61/ubY/R1iUfcahztCM52OkHMYVhG+gLYnbZ2R0N15rTeHS4JKpzA+rjhIKxh9fiUiM0tXtqprnmGzpU7Wrexbd8mZmMEwWTbDI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GJws6XVE; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GJws6XVE"
Date: Fri, 11 Oct 2024 10:07:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728666453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B7SnnnTfOwt4kWHiPAWUzLS15XAxy5TfsaE83NvMhaE=;
	b=GJws6XVEr6jYMDBApSbVk0SwWkV0U5j3dE4Z2bGBFsXKdio+v64vTPEW0yoqaGWny9nitT
	Jc8INvHNXmV9fLafK1AWciGDKPrF9Ztr5ldjWYz0MZvQT2Pf6+useQwi7nykgtxqvCJsxD
	Nm03XvHEGqkYbPRxskRUniNSxVuvDQ4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com,
	will@kernel.org, mark.rutland@arm.com, cohuck@redhat.com,
	eric.auger@redhat.com, yuzenghui@huawei.com,
	wangzhou1@hisilicon.com, jiangkunkun@huawei.com,
	jonathan.cameron@huawei.com, anthony.jebson@huawei.com,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
 migration
Message-ID: <ZwlbTCwoKQyh3vmF@linux.dev>
References: <20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com>
X-Migadu-Flow: FLOW_OUT

Hey Shameer,

Thank you for posting this series. This'll help might cross-host
migrations on arm64 a little less sketch :)

On Fri, Oct 11, 2024 at 08:50:47AM +0100, Shameer Kolothum wrote:
> Hi,
> 
> On ARM64 platforms most of the errata workarounds are based on CPU
> MIDR/REVIDR values and a number of these workarounds need to be
> implemented by the Guest kernel as well. This creates a problem when
> Guest needs to be migrated to a platform that differs in these
> MIDR/REVIDR values even if the VMM can come up with a common minimum
> feature list for the Guest using the recently introduced "Writable
> ID registers" support.
> 
> (This is roughly based on a discussion I had with Marc and Oliver
> at KVM forum. Marc outlined his idea for a solution and this is an
> attempt to implement it. Thanks to both and I take all the blame
> if this is nowhere near what is intended/required)
> 
> This RFC proposes a solution to handle the above issue by introducing
> the following,
> 
> 1. A new VM IOCTL,
>    KVM_ARM_SET_MIGRN_TARGET_CPUS  _IOW(KVMIO,  0xb7, struct kvm_arm_migrn_cpus)
>    This can be used by the userspace(VMM) to set the target CPUs the
>    Guest will run in its lifetime. See patch #2
> 2. Add hypercall support for Guest kernel to retrieve any migration
>    errata bitmap(ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_ERRATA)
>    The above will return the bitmaps in R0-R3 registers. See patch #4
> 3. The "capability" field in struct arm64_cpu_capabilities is a generated
>    one at present and may get renumbered or reordered. Hence, we can't use
>    this directly for migration errata bitmaps. Instead, introduced
>    "migartion_safe_cap", which has to be set statically for any
>    erratum that needs to be enabled and is safe for migration
>    purposes. See patches 3 & 6.
> 4. Rest of the patches includes the plumbing required to populate the
>    errata bitmap based on the target CPUs set by the VMM and update the
>    system_cap based on it.
> 
> ToDos:-
>   -We still need a way to  handle the error in setting the invariant
>    registers(MIDR/REVIDR/AIDR) during Guest migration. Perhaps we can
>    handle it in userspace?

This seems entirely reasonable.

There's nothing KVM can do to unilaterally prevent userspace from
migrating VMs between different implementations already, and the
invariance of MIDR/REVIDR is just a speed bump and not an outright
blocker.

Ultimately this is now a contract between the VMM and guest, so we may
as well let userspace advertise whatever implementation it wants in the
ID registers.


> Please take a look and let me know your thoughts.

Looking at the guest side of things, it'd be nice if we hide the entire
MIDR abstraction behind is_midr_in_range() et al and stop letting
callers provide the MIDR. Internally that can find the MIDR of the
current CPU or walk the array of MIDRs supplied by the hypervisor.

Beyond that, we probably need a way to clue in userspace on the game in
case it has some behaviors keyed off MIDR too.

-- 
Thanks,
Oliver
