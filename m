Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C943D9524;
	Thu, 17 Sep 2026 07:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789631913; cv=none; b=jjY3egHphIRB3t+4Z/v0Fdfjj5cVba22b23F4o0CWA9kuBSYbGXXZd99gN+2OU7ve2grjceEooLXeaM69f7KApHFVhgy4RAIsXEpV4FQd93DymZhSWsyO/9/+dRG1sg/HLgy6MKMVdCARpo+7NHGpwUUBZnrYbK19BYa6vHqTsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789631913; c=relaxed/simple;
	bh=RRfDq16oxGgKtBw9UeQmNtYm4ST9qaYOgq1HK0Ny8A8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q6a5xLJyrE2AWDLvpnqwTdxkXJvGl6lR0X3T0WDakhNmVTDNDeH/RRYFgK6utTuJkJ5UfzczvxvsGO1zPjMuwBjfH0R+RxV4q5D4QJ0bVaCFyEFXbW1VOdKPUrYtk3D9+cD0A5bM8WZE90X6Gu+NmE2GaF7Xuox4UwhHsdcTHTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=f4wC/Tvn; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="f4wC/Tvn"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4F851476;
	Thu, 17 Sep 2026 00:58:26 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B1D4B3F7B4;
	Thu, 17 Sep 2026 00:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789631910; bh=RRfDq16oxGgKtBw9UeQmNtYm4ST9qaYOgq1HK0Ny8A8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f4wC/TvnWaNgPI27Dfy+Nrnm0xEIKICSS0D4shLai0nf6X//HHrkuIFoWvfQ+w1mP
	 XBlhRCgFI09l+Ayz0I9KRZNU4Uol8xNufG0CUKYMPjKpPh7zh4QZ1X3bc38dYeR9RW
	 Z7cso9/xLARHAJCe+Be3ye8vh/HNKsc1XvD/la1s=
Date: Thu, 17 Sep 2026 08:58:25 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	will@kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
Subject: Re: [PATCH v18] arm64: mm: Handle Granule Protection Faults (GPFs)
Message-ID: <aqudod8kM5AjkCFY@arm.com>
References: <20260913070459.2547407-1-suzuki.poulose@arm.com>
 <aqrGPK0lFBFXL2qY@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqrGPK0lFBFXL2qY@arm.com>

On Wed, Sep 16, 2026 at 05:39:24PM +0100, Catalin Marinas wrote:
> However, can we end up delegating a non-guest_memfd memslot page as
> protected?
> 
> I played a bit with codex and it reckons it's possible if a guest_memfd
> memslot is deleted after its IPA range has been initialised with
> RIPAS=RAM. Removing the memslot unmaps and undelegates any data pages
> but leaves the RMM state as RAM. The VMM can then install an ordinary
> memslot over the same GPA range.

After some more digging, I think RIPAS becomes DESTROYED after
undelegation but it doesn't change much. A subsequent guest access to
the private IPA still exits to the host which will attempt to delegate
it again even if it's no longer guest_memfd. RIPAS remains DESTROYED but
GPT is now REALM (and potentially a valid user mapping).

-- 
Catalin
