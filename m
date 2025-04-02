Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 554C923A9BE
	for <kvmarm@lists.linux.dev>; Wed,  2 Apr 2025 13:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743602292; cv=none; b=nBdmruOJq7OvtapRjaRR+eKBbxmGInGfYX6pgOYCtrNLy/5jI/FjH1IsRoqHWOId5wilspCZx+bFFi1MPUY8kPkbvtlkPaEasSmup6gnTHD8OJ67nPWhCrrnc69lgXWsWM4lgEmrs6aoLCJ/8KbcnnnDLqej5pyg716NA7N4d3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743602292; c=relaxed/simple;
	bh=9iCJ1GrS2n6Egewh9FC4egeInvpI3spyNwwACNyEgqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ST4i/mLDxX1f9AivCOZ3ssg60TUMCiS3KLnQWJuezzuRPVT14nW5dO+jyVin1S0HxEXEIxLjiDHyvU5Wgiii2de1eJO43ptmllOtRz3gLYqrx33/9GNea653EfJT60+ykIADrPEOJriX2uVQA+HA39uvE/7DtLdArXXCFhu7EpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com; spf=none smtp.mailfrom=foss.arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=foss.arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A7401007;
	Wed,  2 Apr 2025 06:58:13 -0700 (PDT)
Received: from bogus (unknown [10.57.41.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E55B13F63F;
	Wed,  2 Apr 2025 06:58:08 -0700 (PDT)
Date: Wed, 2 Apr 2025 14:58:06 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	oliver.upton@linux.dev, maz@kernel.org, mark.rutland@arm.com,
	lpieralisi@kernel.org, catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smccc/kvm_guest: Remove the accidental semicolon
Message-ID: <20250402-independent-hyrax-of-honor-4515fb@sudeepholla>
References: <20250402134401.146156-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402134401.146156-1-shameerali.kolothum.thodi@huawei.com>

On Wed, Apr 02, 2025 at 02:44:01PM +0100, Shameer Kolothum wrote:
> Fixes cocci reported warning:Unneeded semicolon
> 

There was similar patch on the list [1] few days ago.

> Fixes: 86edf6bdcf05 ("smccc/kvm_guest: Enable errata based on implementation CPUs")

^^^ Is this really necessary as they get backported as well ?

Since, KVM maintainers are in cc-ed, let me know if you guys want to pick
this ? Else I can send it as part of my firmware (ffa/scmi) fixes.

-- 
Regards,
Sudeep

[1] https://lore.kernel.org/all/20250326040659.1190696-1-nichen@iscas.ac.cn
