Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACCF339890F
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 13:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774619778; cv=none; b=O58Q3VG90hfBmR+ypgV9kArLpvFVHg+NxnVNb4ZZCEM5ckq0xXTQZ9oRtqxfNZ4tye2/K0Ar1GnxfBK1PtkycOej8gvnciZZE7iTd/yvoTAqJu9USyveDPZnpbCEtPGHib2JBwNLCgY0BYj1BRLFOJ3IeSF0MtxIlj+6wmMUEiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774619778; c=relaxed/simple;
	bh=WCss18sy6f8aOP99Nk+4QmSSu+zP78Vtv2kjNibzlRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HxcgX5QE76LtXWFMO0FPKP7TQ//+cyCagzLaqKRNuW4yPsGYWD7GXLI74HBH83B/AfXruQWDciqSDQO3inSasiVRfmwa1PnKNFhlGqdbBi+nd3q8Nt78HjQkpB2RMRDSoELI6mWMZlTbuK6yQw70plZOEXp/nTCrDLGa9JE6SXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ch1QomEW; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ch1QomEW"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 26DCE15A1;
	Fri, 27 Mar 2026 06:56:10 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DDB63F99C;
	Fri, 27 Mar 2026 06:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774619776; bh=WCss18sy6f8aOP99Nk+4QmSSu+zP78Vtv2kjNibzlRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ch1QomEW70t+DRrnli8fMm69HGPNma+E9iROlZi7nQwaoX6dUOQ2JtWnRSIdpGqg7
	 fZSIz7auQeuccyoYEIQo10XRwAP4aihUy6i1bGlld6hD18OxpUTK41orhRrdaSB5fV
	 nr9RhTZJNZx6SnSUjSgZiRXnR7ex2+tuAeEXGGxQ=
Date: Fri, 27 Mar 2026 13:56:11 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	oupton@kernel.org, miko.lenczewski@arm.com, kevin.brodsky@arm.com,
	broonie@kernel.org, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, joey.gouly@arm.com, yuzenghui@huawei.com
Subject: Re: (subset) [PATCH v17 0/8] support FEAT_LSUI
Message-ID: <acaMex3Pq13njdRt@e129823.arm.com>
References: <20260314175133.1084528-1-yeoreum.yun@arm.com>
 <177461632621.2272468.5197255307509898250.b4-ty@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177461632621.2272468.5197255307509898250.b4-ty@arm.com>

Hi Catalin,

> On Sat, 14 Mar 2026 17:51:25 +0000, Yeoreum Yun wrote:
> > Since Armv9.6, FEAT_LSUI supplies the load/store instructions for
> > previleged level to access to access user memory without clearing
> > PSTATE.PAN bit.
> >
> > This patchset support FEAT_LSUI and applies it mainly in
> > futex atomic operation and others.
> >
> > [...]
>
> Applied to arm64 (for-next/feat_lsui), thanks!

Thanks!

>
> I decided to drop patch [6/8] (arm64: armv8_deprecated: disable swp
> emulation when FEAT_LSUI present). The way FEAT_LSUI support looks now,
> we still have uaccess_enable_privileged() working properly and we could
> even support SWP emulation using exclusives. While it's highly unlikely
> to see both 32-bit EL0 and FEAT_LSUI in practice,

This is one of decisive reason to drop the swp emulation with LSUI
(https://lore.kernel.org/all/aXDbBKhE1SdCW6q4@willie-the-truck/)

However,

> models may support the
> combination and disabling SWP emulation feels pretty artificial.

But I'm not sure this is a sufficient rationale for supporting SWP with LSUI,
since it's highly unlikely to encounter a real CPU that supports both 32-bit EL0
and FEAT_LSUI.

Anyway, it's fair enough to drop 6/8 right now.
But I appreciate whether it would be good to support SWP emulation with
LSUI so that let me respin for it with the former patch.

[...]

--
Sincerely,
Yeoreum Yun
