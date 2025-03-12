Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731C21DB356;
	Wed, 12 Mar 2025 08:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741767715; cv=none; b=frpE0obF7byAJPLuGvI6pSJpILK7SSQVYdXcuWu65Zol3NwrDE1OCJYwrFWAc8XrhAgmipmRD018804YJj4CF3s8WNfXKPVZm3BGc4DvXEILQCetwiriS+i/Jzmg6H4S+iCLeqvFRQBjKuAHGis48eTbtdSnJkmxZr2uWYaMHoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741767715; c=relaxed/simple;
	bh=K3w+uvK/T33Sb7r/wuWcRSqZZjDSkSf+R1EUffld+B4=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dULXqa/QlHNBVYihb/V8LjMWwmz0lv3bvl1S7hBPFszwaMuyBrilw1tCUlywYdwKPzw5gq05ldGbMF6VYBE1pys//LiiVROR/zbEEkIWoleUsu1a694uWqBC1G9toXcJDFoXi7icddpwqp7ujan6F2ypw78ECedsnS622egPs+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ps3W89ZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ps3W89ZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAD8C4CEE3;
	Wed, 12 Mar 2025 08:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741767714;
	bh=K3w+uvK/T33Sb7r/wuWcRSqZZjDSkSf+R1EUffld+B4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ps3W89ZBWzBgV5aqiLiYoLipNPLdjHTQNCngZ8dk+H/MBGCaW2rZSbp6BKT6OW2o7
	 Z8dCp3BNbPLdQ7/ZXy4REwYgQA71kW5kw5DvEtt1QJtQJMyLFbj4Z8GZseurUKLlfZ
	 yjMwPfQXOHYsFT4pjbsyaJM1DmWQTMQPEBQJwctkvgHWj852OLYPLF9hH9PV0gWh5A
	 zgUQ2E7zCB4CGaVmeWGU7nOsETk3rZWFoOobGZDB6t1ogJSa1z53/w0fLDFHh/vyI9
	 uL5Vga2L0c/sDJr8jQcHacaKxwxi3htynM60odIZEHqfch4NlpSgRSgorJQoSPCoAN
	 Yn8alerznEKMw==
Received: from 82-132-232-216.dab.02.net ([82.132.232.216] helo=wait-a-minute.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tsHLb-00Cn8v-Jn;
	Wed, 12 Mar 2025 08:21:51 +0000
Date: Wed, 12 Mar 2025 08:21:48 +0000
Message-ID: <87tt7y7j6r.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	"oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com"
	<yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"ryan.roberts@arm.com"
	<ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"david@redhat.com"
	<david@redhat.com>,
	Aniket Agashe <aniketa@nvidia.com>,
	Neo Jia
	<cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta\
 (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>,
	Andy
 Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John
 Hubbard <jhubbard@nvidia.com>,
	Dan Williams <danw@nvidia.com>,
	Zhi Wang
	<zhiw@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke
	<udhoke@nvidia.com>,
	Dheeraj Nigam <dnigam@nvidia.com>,
	Krishnakant Jaju
	<kjaju@nvidia.com>,
	"alex.williamson@redhat.com"
	<alex.williamson@redhat.com>,
	"sebastianene@google.com"
	<sebastianene@google.com>,
	"coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com"
	<yi.l.liu@intel.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com"
	<gshan@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"ddutile@redhat.com" <ddutile@redhat.com>,
	"tabba@google.com"
	<tabba@google.com>,
	"qperret@google.com" <qperret@google.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
In-Reply-To: <SA1PR12MB7199500A3683B15A64B663D6B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250310103008.3471-1-ankita@nvidia.com>
	<20250310103008.3471-2-ankita@nvidia.com>
	<861pv5p0c3.wl-maz@kernel.org>
	<SA1PR12MB7199DD985C45943A663E7003B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
	<86r033olwv.wl-maz@kernel.org>
	<SA1PR12MB7199500A3683B15A64B663D6B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/29.4
 (x86_64-pc-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 82.132.232.216
X-SA-Exim-Rcpt-To: ankita@nvidia.com, jgg@nvidia.com, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com, shahuang@redhat.com, lpieralisi@kernel.org, david@redhat.com, aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com, zhiw@nvidia.com, mochs@nvidia.com, udhoke@nvidia.com, dnigam@nvidia.com, kjaju@nvidia.com, alex.williamson@redhat.com, sebastianene@google.com, coltonlewis@google.com, kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org, gshan@redhat.com, linux-mm@kvack.org, ddutile@redhat.com, tabba@google.com, qperret@google.com, seanjc@google.com, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 11 Mar 2025 12:07:20 +0000,
Ankit Agrawal <ankita@nvidia.com> wrote:
> 
> Thanks Marc for the feedback.
> 
> > No, I'm concerned that a well established API (populating a memslot)
> > works in some case and doesn't work in another without a clear
> > indication of *why* we have this behaviour.
> >
> > To me, this indicates that userspace needs to buy in this new
> > behaviour, and that behaviour needs to be advertised by a capability,
> > which is in turn conditional on FWB.
> 
> Yes, that makes sense.
> 
> >>> Perhaps we can gracefully fall back to the default device mapping
> >>> in such case? But that would cause VM to crash as soon as it makes some
> >>> access violating DEVICE_nGnRE.
> >
> > Which would now be a regression...
> > 
> > My take is that this cacheable PNFMAP contraption must only be exposed
> > to a guest if FWB is available. We can't prevent someone to do an
> > mmap() behind our back, but we can at least:
> >
> > - tell userspace whether this is supported
> 
> For my education, what is an accepted way to communicate this? Please let
> me know if there are any relevant examples that you may be aware of.

A KVM capability is what is usually needed.

> 
> I suppose just checking for FWB (for PFNMAP) and returning some sort of
> an error on userspace mmap will not be enough of a hint here?

I don't think checking for FWB at mmap() time is correct. mmap()
shouldn't care about FWB at all, because stage-2 is irrelevant to
mmap(). You also want to be able t perform the same mmap() inside an
EL1 guest, which by definition cannot consider FWB.

This must be checked at the point of memslot creation, and return an
error at that point. Memslots are all about stage-2, so it makes sense
to check it there.

	M.

-- 
Without deviation from the norm, progress is not possible.
