Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=139.138.36.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794312712;
	b=gpnnutvyVqBDX1uqCYoxNdwUF6AWib8DjahQa3AQO3zm1VBSeaPZD91qhjnU11fyaVsU
	 IJdwxRsYgs0kc1ie2v7GOlsLveB89BT22fQ/W6wbDgT39PghMU23W+cqDJWE2XW+hUeSl
	 lMXDIzyromqJ8bwPkBdShVlFD5BZXlz+xu+AOrpRocHGrO3qisoFH3ISv+s6FEAMO0okz
	 j6b9UQTTrJABF+jLUCrF0wx4c0F+llIBHSBJEcu0zO+7tyhqmK4Y6zG6yB0YQ1B0uD2ZC
	 wuWzPQgFbmOcDTzFhMWspg3/RXCOH2u81V62ZfCes4GqBIJxHoMZV9oSPjuF28DLfrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794312712;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=xPi/3K5EgSO8uxLuJimni9tpMpXLjb9QZkfq/GsXYRI=;
	b=E7on/I36ZztRjhwtDDbG6oFScyC+debM/UaSZL2v4G3Qt1M25iOAvP/wyTVzePIGdlLq
	 wJhebj1flSGuh+Rtcm7gSMUv7cheba0qXBRM+KuHyiJ/ijpHIHhIhviHd0J5baBCnBtrl
	 Nq/EFMrHuHOkJ2RT6wcIr6TjydfcRPGnKKdt6rG5FOz/7DiGeIL3F/OBoz1DGRB3I+yGj
	 wjaZQvgsCIZeedO0bVL211D+lmG/Z/x/45vnSIE96X7vFIfmdPO4xpqoNxm6NV1Vvj6Wt
	 UnNur2hEC5Dh8W4xoUv3Wt5TqZGLYZ3dEEFMlAPrAAAEhdvoHxMKay7sNAPfWFGJXFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=rDU39eoS;
	arc=none smtp.remote-ip=139.138.36.225
Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BCD606A326;
	Tue, 10 Nov 2026 12:11:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88BCD606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=rDU39eoS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1794312719; x=1825848719;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2Eio9nYqq1HUIYESAuWhCyeK9Re+Weog6uesd4h1oSo=;
  b=rDU39eoSKj5LUjyMW678rgBP2q/moAsrULF0LgLlrrii4LL6wmd+zw+y
   Jz+t0zHzE+zZHiW4L12A46bv/hLVM7wZurHsfC9gFhFVCapJ0m+XvR0hz
   Q+iZ+Mxib9GDXMo+44Nink/jdYEXL3/Kuv8qEqhVU1HQX/v5y9r5G1Mom
   pedKjmYWnP/jodAkh/phtKOcLHjJX59UGzbW2yyVWidULRIj5HNn/4QsJ
   suPc2hfzEp/xLGr+tg1jDnaqH9T9t3HO4Oh2K9Qa30c2pRA5BB8Wt8GLo
   lgg8gUwU7LLcLtSt7b/JfxzH7G+Yyz8TT7u32Xpexio6pfjO93GE9UqO1
   g==;
X-CSE-ConnectionGUID: ZUAiW5ofS8214b0HcWIJVw==
X-CSE-MsgGUID: aLdooNCNRTWy8zXKUktquA==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="247477340"
X-IronPort-AV: E=Sophos;i="6.27,205,1786978800"; 
   d="scan'208";a="247477340"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 21:11:57 +0900
Received: from az2nlsmgm4.fujitsu.com (unknown [10.150.26.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id EED2A1C000EE;
	Tue, 10 Nov 2026 12:11:49 +0000 (UTC)
Received: from az2uksmom1.o.css.fujitsu.com (unknown [10.151.22.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm4.fujitsu.com (Postfix) with ESMTPS id 9A260100010F;
	Tue, 10 Nov 2026 12:11:49 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.9.61.34])
	by az2uksmom1.o.css.fujitsu.com (Postfix) with SMTP id E5AFE1800A47;
	Tue, 10 Nov 2026 12:11:40 +0000 (UTC)
Date: Tue, 10 Nov 2026 21:11:39 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH 00/11] KVM: arm64: CCA: Prepare Realm memory management
Message-ID: <avMI__K5XBf3z7wv@FCCLS0092175.localdomain>
References: <20261102141304.126883-1-steven.price@arm.com>
 <avLgdqlfUPMAI-r9@FCCLS0092175.localdomain>
 <e9bc3885-4e29-44a0-a186-463337f57d9e@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e9bc3885-4e29-44a0-a186-463337f57d9e@arm.com>

On 11/10 11:54, Suzuki K Poulose wrote:
> Hi Kohei
> 
> On 10/11/2026 09:24, Kohei Enju wrote:
> > On 11/02 14:12, Steven Price wrote:
> > > This series adds the memory plumbing for CCA building on the basic
> > > plumbing[1] that has just been merged.
> > > 
> > > These patches add the internal realm VM state and RMM feature checks,
> > > prepare realm stage-2 setup and teardown, and provide RTT mapping and
> > > invalidation helpers. Realm memslots are now contrained to the lower
> > > half of the IPA space, because faults treat the protected and shared
> > > halves as aliasing. The final patch then connects these helpers to the
> > > KVM stage-2 MMU operations.
> > > 
> > > There's also an integration branch[2] that builds on this series and
> > > includes the realm descriptor creation, REC entry/exit, activation and
> > > the new uAPI. This series by itself is also available as a git
> > > branch[3]. However the new code isn't generally active without the full
> > > integration branch.
> > > 
> > > [1] https://lore.kernel.org/all/20261007073537.2454351-1-suzuki.poulose@arm.com/
> > > [2] https://gitlab.arm.com/linux-arm/linux-cca
> > >      branch: cca-host-mm/v1/integration
> > 
> > Hi Steve, thanks for your work on CCA upstreaming.
> > 
> > For testing purposes, could you clarify which TF-RMM revision (or commit
> > hash) you tested with? Although this MM series itself doesn't seem to be
> > particularly sensitive to changes in TF-RMM, testing the integration
> > branch could be affected by subtle changes in the RMM.
> 
> Tip of both the repositories should work (tf-a and tf-rmm).

Hi Suzuki,

Thanks for the clarification.

Then, unless otherwise specified in the cover letter or elsewhere, I'll
assume that the latest revisions of both repositories are expected to
work together going forward.

Thanks,
Kohei
