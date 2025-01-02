Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D465E3D68
	for <kvmarm@lists.linux.dev>; Thu,  2 Jan 2025 12:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735819630; cv=none; b=HYKZOdaMiHfFg8X9usN7EMa0cvy2OH4JybEz610Pt4GXV6omkYUZEPVhkd5//x6bFeTWSqGVDnBCKrTqucTQTm3FtBanBfzZrUnmcaTilkeBgNM4lfa8rFprfyDNa4mDwaauLorh2YChphbhmKK2vvQQrQR7yIpsKCsOtqW3CgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735819630; c=relaxed/simple;
	bh=nPqphhQ3v/qlhIdSSar6/dfUS15VV96Jz/Xqxwk+xiQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pu9csURiINiCmfcAFy/M6QrTW61xf499U7BRxqMMVuVg8Nr5Fxftu5LzYkoAyqfTQT5PJ6Uy+2dJuPw4uP1LcweslSj9LhUeXKPVEzYYwBbp9hWrAwhFD8bjmK+rN+dKhem1NwOl+KQHnfd3rsoaWeoAawpXRCK++fv7JRiaiVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YP55k1CmQz6K6nF;
	Thu,  2 Jan 2025 20:06:18 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id BF298140A9C;
	Thu,  2 Jan 2025 20:07:06 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 2 Jan
 2025 13:07:05 +0100
Date: Thu, 2 Jan 2025 12:07:04 +0000
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Will Deacon <will@kernel.org>
CC: Ryan Roberts <ryan.roberts@arm.com>, Marc Zyngier <maz@kernel.org>,
	=?UTF-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>,
	<catalin.marinas@arm.com>, <corbet@lwn.net>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvmarm@lists.linux.dev>,
	<yangyicong@huawei.com>, <guohanjun@huawei.com>,
	<wangkefeng.wang@huawei.com>, <liaochang1@huawei.com>,
	<sunnanyong@huawei.com>, <yangyicong@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [RESEND RFC PATCH v1 2/5] arm64: Add BBM Level 2 cpu feature
Message-ID: <20250102120704.00002984@huawei.com>
In-Reply-To: <20241219164528.GH24724@willie-the-truck>
References: <20241211160218.41404-1-miko.lenczewski@arm.com>
	<20241211160218.41404-3-miko.lenczewski@arm.com>
	<87cyhxs3xq.wl-maz@kernel.org>
	<084c5ada-51af-4c1a-b50a-4401e62ddbd6@arm.com>
	<86ikrprn7w.wl-maz@kernel.org>
	<2b1cc228-a8d5-4383-ab25-abbbcccd2e2c@arm.com>
	<86h678sy00.wl-maz@kernel.org>
	<5c551e43-78e9-4336-ab16-b55c0d6c7f92@arm.com>
	<20241219164528.GH24724@willie-the-truck>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Thu, 19 Dec 2024 16:45:28 +0000
Will Deacon <will@kernel.org> wrote:

> On Thu, Dec 12, 2024 at 04:03:52PM +0000, Ryan Roberts wrote:
> > >>> If anything, this should absolutely check for FAR_EL1 and assert that
> > >>> this is indeed caused by such change.  
> > >>
> > >> I'm not really sure how we would check this reliably? Without patch 5, the
> > >> problem is somewhat constrained; we could have as many changes in flight as
> > >> there are CPUs so we could keep a list of all the {mm_struct, VA-range} that are
> > >> being modified. But if patch 5 is confirmed to be architecturally sound, then
> > >> there is no "terminating tlbi" so there is no bound on the set of {mm_struct,
> > >> VA-range}'s that could legitimately cause a conflict abort.  
> > > 
> > > I didn't mean to imply that we should identify the exact cause of the
> > > abort. I was hoping to simply check that FAR_EL1 reports a userspace
> > > VA. Why wouldn't that work?  
> > 
> > Ahh gottya! Yes agreed, this sounds like the right approach.  
> 
> Please, can we just not bother handling conflict aborts at all outside of
> KVM? This is all dead code, it's complicated and it doesn't scale to the
> in-kernel use-cases that others want. There's also not been any attempt
> to add the pKVM support for handling host-side conflict aborts from what
> I can tell.
> 
> For now, I would suggest limiting this series just to the KVM support
> for handling a broken/malicious guest. If the contpte performance
> improvements are worthwhile (I've asked for data), then let's add support
> for the CPUs that handle the conflict in hardware (I believe this is far
> more common than reporting the abort) so that the in-kernel users can
> benefit whilst keeping the code manageable at the same time.
> 

Hi All,

Given direction the discussion is going in time to raise a hand.

Huawei has implementations that support BBML2, and might report TLB conflict
abort after changing block size directly until an appropriate TLB invalidation
instruction completes and this Implementation Choice is architecturally compliant.

Jonathan

> Will
> 

