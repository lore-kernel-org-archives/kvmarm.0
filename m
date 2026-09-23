Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7A039280D;
	Wed, 23 Sep 2026 05:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790139688; cv=none; b=B+utT4up83kt5bqWj3P3YzK+P7ORiYkBc0ddeliwDviYdbUinTeyBXIdfG/nGYtcuWR5lRElQq1GgQaHaroetymQJriEsQcRIp8xqUHpEfcFRTICpli7hj4OddEHCvQAz2fLWDTMNWoUewFO/FCY/271DF2uyIZ0WhBoaJJbdPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790139688; c=relaxed/simple;
	bh=P/1ngG6hntaphfy8LnE37qJXAAGi8yHhAJzztWYFxWE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BaYg/3kcdJcTJINPPJhRP/5k869GPLcIO7X7iGuN1Bqzmpqa1FJmBsKEuEX5H5p3y5OrPaIspXG5NUB6UZbBRQD6RYIpoNhV6ndCjuyPDF/WWBia+bYyBiKT7Eo0E/6F13wPRlOtB5mYchJIyMfcxeFIRUIkaxaEKKM7q3ZVwPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f+uE8f47; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f+uE8f47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57C81F00893;
	Wed, 23 Sep 2026 05:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790139687;
	bh=QLmF0v8QtglTj6lhzt+VYTF5WKRtG/i0I5+a8Z9D+Pw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=f+uE8f473BmHUYPtfP+DSAO/2PPTToyTXGdy7kfluD3JI6wZ+WhsIKuDhHY7DM1/8
	 8ZZr/GE9D1f3n3vrsWRuTKMphi/wltWB6A+RgrE/kkVzrKvtCG/cAAfOkdo1qhFlsJ
	 C0cfngBRQ7EtBdiv1INAQ0CaK9I24pB7EgRU91x9GMj8oVqTPcXJh+IpX9RezahEYN
	 Qn8foUFcTCPV47tgDPfVx9L3JIY9oSXWCbzZf7oOWji2Xaba5fxpWohjWmQbDitrRc
	 iCd3KNeOHayR5T1B1pSqdr5WwP7wXk6fvgr5Qpiz1psLOZAezZipEBGm3rXdKoz0sx
	 rFU+XdHdMPX8w==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v6 0/9] coco: guest: Enforce host page-size alignment
 for shared buffers
In-Reply-To: <20260918165754.GG11599@ziepe.ca>
References: <20260904103452.1197239-1-aneesh.kumar@kernel.org>
 <aq1sT2EDsGaomqST@arm.com> <20260918165754.GG11599@ziepe.ca>
Date: Wed, 23 Sep 2026 10:31:19 +0530
Message-ID: <yq5ao6do36jk.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Jason Gunthorpe <jgg@ziepe.ca> writes:

> On Fri, Sep 18, 2026 at 05:52:31PM +0100, Catalin Marinas wrote:
>
>> TBH, I'm tempted not to support this configuration at all, just fail
>> gracefully if the realm page size doesn't match the host's. However, if
>> that's a real world configuration, 
>
> realm != host is going to be fairly common.
>
> host > realm is probably not that common, I would guess.
>

Wouldn't it be more common to run a distro with a 4K page size as the
guest on a custom hypervisor with a 4K or larger page size?

-aneesh
