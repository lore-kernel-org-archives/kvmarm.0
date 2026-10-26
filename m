Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.139.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051002;
	b=AxPoVM5B8dE44yjHmwAAnchkaFbw+RtUHGaNLPJA2gJZN8HrW5a6JnzJoptJ/w6t17E2
	 HTGw/4iOF2eZZmaSRu9ciLwqXiLc2UpXWfFZyJSbh6EAK8qWkbFIOQt33Asv67xmLcTB3
	 bjCXEn9kG80+CPYZ9keaT+tagomh0sKHAVznviNBoxlOvf5x2AOvDglaYyPp7g6hBM8V0
	 GHHIf8SwKhiWMqXsqkLy7uZEPXITbMrQd8rws7BU1ITNbU/QLxrvLxy35Ms0othzg/3fZ
	 17voAP5Tl4wVtXhFDkwlXVyKk5TtfSanBdPSyNRCcQQjIKBN1mcRKErKhKVTx9EF6XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051002;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=0Lq4a/V8mDm6FCGgdk05nU9bT6DX1rNy3nB4AjBmimk=;
	b=VGuPEu5hrCezxW+2uouFkgpBRfFJUExufkT/OD/6Zf+K4roDEOy8VVCQBiF7dfsc/e4u
	 eVf+qxl6DXBT6he0YbpfZtslEcENbagAv/Lb73tj9d66ZZbUV39ojp9Zc65FtOba0DWHx
	 LIAEkupX48r3UhOcDuM3y9HrjPeVQW0e5yEfqVCqlRqlBeF7bHsNAHN6tJW8EpvGwggst
	 LDSEzFjnrg5rouWJ72k+srZk3bLVNPomy9rhyQRULCqCSJA6pBztnRIxXApKHwUzwUDml
	 RjfqtW11/cR7AmJvePcFGtRcP5LfDkjAayjtT54hvF8TiqAt3YkdI88hl1UIh8lZiZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=jndxdWO5;
	arc=none smtp.remote-ip=68.232.139.139
Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72281606A322
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 21:43:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72281606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=jndxdWO5
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1793051001; x=1824587001;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K8Tw0xjvYKK5C3EMr77Wx4LoUSWiFby6WDQXp/hFglg=;
  b=jndxdWO5ZVoz7cbseldj2fP8S6Ln+wEc22UIXtYkLx48ThyPh8xuU8iX
   /oiTP4EOq9n501VHuJ5sIGQw9ghEDHwGa7ov2xcO8uUb1g40i06yUGk0E
   w4guO2rNyBsSHzClbsx27/xRVfFqI8ISFBAVT4+DvTAG78HcKxpAznvUO
   AZTeaRnaBsPyBFw+9IkSufXl5Lt0y7/5nt/VtknQ8GhOIrF8WC3XKnMkm
   S9s6Ed2Btp7r+GgQECZzZ5oLONRZQOHv8gMQw7Br4O9JU2AyTtnFIdfqu
   Ef1tk4bi7tar1j2xZNKj0LRNj90YVVh07z/I41kbiNceDHlyi+35W6MeM
   w==;
X-CSE-ConnectionGUID: rBqorV/OQEW/BqYb187Reg==
X-CSE-MsgGUID: YPc/kLxISh+ixam/YdeEAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11947"; a="263464847"
X-IronPort-AV: E=Sophos;i="6.27,180,1786978800"; 
   d="scan'208";a="263464847"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 06:43:13 +0900
Received: from az2uksmgm1.o.css.fujitsu.com (unknown [10.151.22.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id A75C71C1C700
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 21:43:13 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 5F02D8D65FE
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 21:43:13 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTPS id 36B3A405E32;
	Mon, 26 Oct 2026 21:43:07 +0000 (UTC)
Date: Tue, 27 Oct 2026 06:43:05 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3] KVM: arm64: selftests: Test VNCR translation
 invalidation
Message-ID: <at_JaV29gVqxueSK@sm-arm-grace07>
References: <20261026-b4-vncr-mapping-test-v3-1-7c094a00d46e@fujitsu.com>
 <861p9czwxc.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861p9czwxc.wl-maz@kernel.org>

On Mon, Oct 26, 2026 at 08:30:07AM +0000, Marc Zyngier wrote:
> On Mon, 26 Oct 2026 03:10:10 +0000,
> Itaru Kitayama <itaru.kitayama@fujitsu.com> wrote:
> > 
> > Add a standalone KVM selftest that checks VNCR accesses after L1
> > updates its stage-1 mapping and issues a TLBI. This guards against
> > stale VNCR translations, as KVM caches L1's translation of
> > VNCR_EL2 and must drop it when L1 invalidates the mapping in
> > kvm_handle_s1e2_tlbi().
> > 
> > Keep VNCR_EL2 unchanged while remapping its backing page A to B then
> > again to A. At each step, L2 reads and writes TPIDR_EL2, and L1
> > verifies that the accesses reach the selected page while leaving the
> > other page unchanged.
> 
> If you were tracking cross vcpu invalidation and exercising all the
> architecture corner cases (such as permission changes and co), that
> would be helpful.
> 
> But as it is, it doesn't help much as a validation tool. Its scope is
> way too narrow.

Thank you for your comments. I will try to incorporate the suggested
test scenarios.

Thanks,
Itaru.

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 
