Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 204E039768C
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 17:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774631919; cv=none; b=KjR/JLlYeSAkFLJ06Ioz/Y0KURI2S+RM8U2Rmsuk+s+xI9MD4NReBxw9ye1dTw036OSKlOhiRr0vG68qdPDEDdAPVSvfg1t4SkE++KIWFvq/capnsm86a7fnUa+GTBgzXKLNrt2GZbr+SrOBMy9pPoaMg8dIViCsvVY4x8JWZNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774631919; c=relaxed/simple;
	bh=aY/JswWMujYof83wSPNLXR7cuzHQPIe4Rii8L3Y7AjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=njI66IbsJcBxex4AMPysZRrDONgbxTUWyxPl1Iuo5kiwMvkCS64oQIdbeuEGmulkvCquXNnZrFAYNEO3O+ONezfSsqfBI2zh3s5b/PmS54mtXX966tiDVyC2wF6MmoyCmnSV4olYTDfEn6b5NYHJxCYpLVkdk9Fu01Z3hPrtFTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NSCH7MHN; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NSCH7MHN"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83C3635AA;
	Fri, 27 Mar 2026 10:18:30 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C71D3F99C;
	Fri, 27 Mar 2026 10:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774631916; bh=aY/JswWMujYof83wSPNLXR7cuzHQPIe4Rii8L3Y7AjA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NSCH7MHNUqegat7jNlT/WqiQ96q/ACI+/Rvxuacx95VZSPVtfc8cbhrWP3FAW9i61
	 2M951WUPxho9rGQ/ji69E2T44RnbgtSJdquxgk1vk1aGLk6LSEXnIX2vcWpetXf3E4
	 OMoBcyeimLzoBxQIKKcgSxj32zi2wIuhb9WoN8OA=
Date: Fri, 27 Mar 2026 17:18:31 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	oupton@kernel.org, miko.lenczewski@arm.com, kevin.brodsky@arm.com,
	broonie@kernel.org, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, joey.gouly@arm.com, yuzenghui@huawei.com
Subject: Re: (subset) [PATCH v17 0/8] support FEAT_LSUI
Message-ID: <aca75_16R1nnobb8@arm.com>
References: <20260314175133.1084528-1-yeoreum.yun@arm.com>
 <177461632621.2272468.5197255307509898250.b4-ty@arm.com>
 <acaMex3Pq13njdRt@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acaMex3Pq13njdRt@e129823.arm.com>

On Fri, Mar 27, 2026 at 01:56:11PM +0000, Yeoreum Yun wrote:
> > I decided to drop patch [6/8] (arm64: armv8_deprecated: disable swp
> > emulation when FEAT_LSUI present). The way FEAT_LSUI support looks now,
> > we still have uaccess_enable_privileged() working properly and we could
> > even support SWP emulation using exclusives. While it's highly unlikely
> > to see both 32-bit EL0 and FEAT_LSUI in practice,
> 
> This is one of decisive reason to drop the swp emulation with LSUI
> (https://lore.kernel.org/all/aXDbBKhE1SdCW6q4@willie-the-truck/)

Ah, I forgot about this discussion. It's a valid point, I just thought
it's unnecessary given that __uaccess_disable_hw_pan() still works.

If we want strict no PAN, I can add it back (really small patch). I
wonder whether we should also add a
WARN_ON_ONCE(cpus_have_final_cap(ARM64_HAS_LSUI)) to the pan disabling
function. Not urgent though.

-- 
Catalin
