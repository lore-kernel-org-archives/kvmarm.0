Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C94384CCB;
	Thu, 23 Jul 2026 06:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.36.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784789901; cv=none; b=I2P3VwFk34AYCPk0Rn1IFOmDLqpvRVjHDjc2kj5iw9AOkd9RWgIz1y5ARRlGY9TxmfpxxaWgmLJo3798CcLpmHShX2Wy11AHUyc0uuyF4SMHBvDX9oXS6BiPDsOD5FTOsirdM5zy1W1t3nk1dWPbvhQieX8y+VJTBMyI1TGoIUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784789901; c=relaxed/simple;
	bh=qZw/Mpb9yuRHoHUWT2a56q40bog3XvEKC61lCecinxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LGmj9o3KgkntZZDHyQLHlKFcmDBtLJxLS9ESj3Ai1jIgwIj1pi8M7ZJ2gOZlv0XXlCphtAZA5/p82AF4DQrWioVhO50JDwIm4athrBF/iz+ELa9OMWdYOsmZo5QU3+dHdrTZaynSsv62XqM+GifzSlvA1+sboywyqUIccoJBFWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=F+TG6igy; arc=none smtp.client-ip=139.138.36.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="F+TG6igy"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1784789900; x=1816325900;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qZw/Mpb9yuRHoHUWT2a56q40bog3XvEKC61lCecinxQ=;
  b=F+TG6igymjrER56mtbxurICqfmenUhLzNd3Ozl6wVufxJHZj2Pc8zioD
   ndhFswSfZgXqKRpLvtybWiNeNSkJ/J+Bj9e0ojtO43o9tMDopQqY7I5Gn
   jvHMpIuxUbchyFDLMlfpOztmVQ9s6PTQvFIhxeH4GBuGuIUCSbga0PbGN
   9JBPTNVj6yc6Fvs1OnSj+h7igk/8Nhmjaour4cfjIPNYM0vmtMMDSGMPa
   S1hH0VOfYMhs/a83qgt7Dt5tTFK/TGHwRdjO8+afqmHpC3dT0xNKyx/eG
   QdslWYmMTD7Y0u771B7W6eqAclHxj8gMXIcuA5aYHC2jFWY5oNYpbEJ5J
   Q==;
X-CSE-ConnectionGUID: Z0czLjHbShasyzRtp56+eg==
X-CSE-MsgGUID: XmtL1rZ7TUWAaXPOCfltjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="234505088"
X-IronPort-AV: E=Sophos;i="6.25,180,1779116400"; 
   d="scan'208";a="234505088"
Received: from gmgwnl01.global.fujitsu.com (HELO mgmgwnl01.global.fujitsu.com) ([52.143.17.124])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 15:57:10 +0900
Received: from az2nlsmgm1.o.css.fujitsu.com (unknown [10.150.26.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mgmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 2842FADAD;
	Thu, 23 Jul 2026 06:57:10 +0000 (UTC)
Received: from az2uksmom1.o.css.fujitsu.com (unknown [10.151.22.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id C6643C0964A;
	Thu, 23 Jul 2026 06:57:09 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.10.80.137])
	by az2uksmom1.o.css.fujitsu.com (Postfix) with SMTP id 817491801C29;
	Thu, 23 Jul 2026 06:57:01 +0000 (UTC)
Date: Thu, 23 Jul 2026 15:56:54 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH v15 12/37] KVM: arm64: CCA: Support the VGIC in realms
Message-ID: <amG3KHE4Tdd_Nvuz@FCCLS0092175.localdomain>
References: <20260715142841.80544-1-steven.price@arm.com>
 <20260715142841.80544-13-steven.price@arm.com>
 <amB-opawGgF6jNHB@FCCLS0092175.localdomain>
 <b71e81ee-372c-4963-a1f7-bd301aee89cb@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b71e81ee-372c-4963-a1f7-bd301aee89cb@arm.com>

On 07/22 14:31, Steven Price wrote:
> On 22/07/2026 09:27, Kohei Enju wrote:
> > On 07/15 15:28, Steven Price wrote:
> >> The RMM provides emulation of a VGIC to the realm guest. With RMM v2.0
> >> the registers are passed in the system registers so this works similar
> >> to a normal guest, but kvm_arch_vcpu_put() need reordering to early out,
> >> and realm guests don't support GICv2 even if the host does.
> >>
> >> Signed-off-by: Steven Price <steven.price@arm.com>
> > 
> > Hi Steven,
> 
> Hi Kohei,
> 
> > I've been testing this series and found that when the host CPU doesn't have
> > ARM64_HAS_ICH_HCR_EL2_TDIR this series doesn't work as expected.
> 
> Thanks for testing!
> 
> > Since commit 2a28810cbb8b ("KVM: arm64: GICv3: Detect and work around the lack
> > of ICV_DIR_EL1 trapping"), when the host CPU doesn't support this feature, KVM
> > traps all GIC sysreg accesses in the common group. However, currently trap
> > handlers for ICC_{PMR,RPR,CTLR}_EL1 registers are missing [0]. So when Realm
> > guests try to access those registers, KVM traps them but just emits the warning
> > shown in [1], and Realm guests fail to boot.
> > 
> > As far as I can tell, the CCA requirements don't require the
> > ARM64_HAS_ICH_HCR_EL2_TDIR feature. If that's the case, this seems to be a
> > problem. Is there any workaround for this issue, or should we implement trap
> > handlers for those registers?
> 
> As Marc has already said in his reply, I'm really surprised you have a
> CPU which implements CCA but doesn't have ARM64_HAS_ICH_HCR_EL2_TDIR.
> Can you give some more details about the platform you are testing on?

Thank you for taking a look, Steve.

Unfortunately, due to the company's policy, I can't share any details
about the platform I'm currently testing on. When the time is right,
I'll be happy to do so.

> 
> Ultimately there are two options here - either don't support CCA (so
> detect the lack of ARM64_HAS_ICH_HCR_EL2_TDIR and bail out early), or
> plumb in the trap handlers - as commit 2a28810cbb8b points out this
> isn't something we really want to support if we can avoid it.

Yes, the former makes perfect sense if there would be no systems that
supports CCA without TDIR. However, if such systems do exist, I'd be
interested in exploring the latter approach.

> 
> Hence I'm interested to know where this sits between "hacked up test
> system" and "production hardware". E.g. if this is an emulator it might
> be possible to just enable the CPU feature.

Again, I can't share that right now, but I'd like to share more when the
time comes.

Thanks,
Kohei

> 
> Thanks,
> Steve
> 
