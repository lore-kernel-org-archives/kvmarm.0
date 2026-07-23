Received: from esa3.hc1455-7.c3s2.iphmx.com (esa3.hc1455-7.c3s2.iphmx.com [207.54.90.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BB83F4116;
	Thu, 23 Jul 2026 09:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784797372; cv=none; b=eUKlZZ79O340rzmsTER6LycinTS7p9lEOcLVtNYiA2ZRMwrPqTEk3HhWiYyrofpwf1blbIs44BhCuAOoOO8pGhzme2VvREFUAgobodxQCG0Rt3RyAoI/Nwa3YFxhLOdRJENluI6+t702DkzY2oFyYWpASMARkNUgZfUMXCV8cN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784797372; c=relaxed/simple;
	bh=QlInud9zY6Zj2WAQdHZwDimVEk6ix99BMpZJ6uDFG4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CqIPjmJBBz0EhtoGmp7L5eJC98Vn0wrC+CNMAoiUgOjpE84bKzkiIdueEupfOWhQVjnUbPR73EVHKmQzKHMxk5nWm2azwHiipNiXLlT1ZN6qePz1pBdCt+C2RYtlyAb5MOuwUSjWiJxu72MDc+O/ntusXIFXAHI5NWmqlYI4Isk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=Y79VcGx9; arc=none smtp.client-ip=207.54.90.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="Y79VcGx9"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1784797372; x=1816333372;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QlInud9zY6Zj2WAQdHZwDimVEk6ix99BMpZJ6uDFG4c=;
  b=Y79VcGx9Y5YG+GH9L4nuL/qlKQ7Knt+/cPNlqU79R69LIVB55BKvhn0r
   tvwg/qcAxV3lyHI2kwdAO2xg3dahRVbpnA9gfqCSmICNgW/dX9RdNRETV
   w0Vrj1fhEXAwQMqAQRSP5zlSI8rfgGts1gP1v5SmrwVWh3ByzEZWRaHFV
   cXcOBSCc4dZkID624M9C9+waACje/c8u2nvkmltphYTIosWvN1AKanoJk
   KWo+MzuenQ1jiDC9AGKC7SkPBt01tXl5bcHGse/zMGqiJDTqaWbLn5Rz3
   Sfjyf8Y9G03AjAGg5pF7lgw6HB3YVWh1woIoPLISa5t+2mLsMWL2wZcio
   g==;
X-CSE-ConnectionGUID: XaUx2ZloTZWuWSv6MrrQHw==
X-CSE-MsgGUID: SWpKE7QeRG+4kY77te6mKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="248279711"
X-IronPort-AV: E=Sophos;i="6.25,180,1779116400"; 
   d="scan'208";a="248279711"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa3.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 18:02:50 +0900
Received: from az2uksmgm3.o.css.fujitsu.com (unknown [10.151.22.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 3C9DEC00550;
	Thu, 23 Jul 2026 09:02:49 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm3.o.css.fujitsu.com (Postfix) with ESMTPS id E38D5C15973;
	Thu, 23 Jul 2026 09:02:48 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.10.80.137])
	by az2uksmom4.o.css.fujitsu.com (Postfix) with SMTP id B285540267C;
	Thu, 23 Jul 2026 09:02:40 +0000 (UTC)
Date: Thu, 23 Jul 2026 18:02:33 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH v15 12/37] KVM: arm64: CCA: Support the VGIC in realms
Message-ID: <amHYWxZJsXzIu_7c@FCCLS0092175.localdomain>
References: <20260715142841.80544-1-steven.price@arm.com>
 <20260715142841.80544-13-steven.price@arm.com>
 <amB-opawGgF6jNHB@FCCLS0092175.localdomain>
 <86cxwfe5m8.wl-maz@kernel.org>
 <amGwgAfHWX2P9pZx@FCCLS0092175.localdomain>
 <868q72dt8o.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <868q72dt8o.wl-maz@kernel.org>

On 07/23 09:07, Marc Zyngier wrote:
> On Thu, 23 Jul 2026 07:38:16 +0100,
> Kohei Enju <enju.kohei@fujitsu.com> wrote:
> > 
> > On 07/22 10:27, Marc Zyngier wrote:
> > > >
> > > > As far as I can tell, the CCA requirements don't require the
> > > > ARM64_HAS_ICH_HCR_EL2_TDIR feature. If that's the case, this seems to be a
> > > > problem. Is there any workaround for this issue, or should we implement trap
> > > > handlers for those registers?
> > > 
> > > No. Either you support TDIR, like any modern CPU, or you don't run
> > > CCA. I'm not adding yet another level of emulation for this.
> > 
> > However, I'm still not aware of any requirement in the CCA architecture,
> > or in Armv8-A/Armv9-A, that mandates TDIR support.
> 
> The GICv3 architecture has deprecated the lack of TDIR support since
> the very first release of the specification in 2015, because it was
> quickly identified as an architecture bug. CCA mandates GICv3 support
> as written in the spec, and relying on deprecated features 11 years
> later is not acceptable.
> 
> By any definition, this is buggy hardware, and I don't feel a strong
> urge to support it.
> 
> > 
> > When you say "you don't run CCA", is that because the architecture
> > requires it,
> 
> See above.
> 
> > or because that's the current KVM policy? If it's the
> > latter, we'd be interested in adding the required emulation to make it
> > work.
> 
> And I say no to this. Enough. This isn't a "policy*. This is a hard
> red line. "Do Not Cross".
> 
> We already have the most complicated interrupt architecture ever, and
> I have zero desire to add even more complexity to it. Because I'm the
> idiot who ends-up maintaining this horror, and not you.
> 
> So no, no more emulation code. CCA in KVM won't handle systems that do
> not support TDIR, unless you rewrite the CCA support so that it can
> use the *existing* emulation code without any change.

Understood. Thanks for the clarification.

Thanks,
Kohei

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 
