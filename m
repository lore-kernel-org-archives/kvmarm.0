Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A42339370;
	Wed, 23 Sep 2026 08:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790152362; cv=none; b=o1spWRXYwv8HGrVJ1P4gtVARZV0iXe28CluSk40yoHBv0q6c+hUrhog3tHCSL6Y9qBrgRYZf5gTPSpVhwKS9GtXU4e8o8DlTOG+e87f7+T3pdIDqjxhW04YQVWRGd2o0bRjwEMyrJ2OKn936Igyydd2BTIhuWxSIzseW4F8PNoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790152362; c=relaxed/simple;
	bh=l+yK5+zyEHSK/AJtaCzSVpNPxaH4je8PBLfFrOyF2I4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YnWIajUjwFwNX2w3ZDWnDMatIePAJeboY+4gEanLNzURAOrON7hUci0mdm9tTwssT5tx/uHII6cNCDU1iO5s+8EUKFD0VaN+Ftg7bRSHpUerQKljGwU93aSqSAdN//Zfr7EIiI9jTTbADsgDnfXDLBk1FpxQaoH+XgmSiyT8xoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RS3N/efX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RS3N/efX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B501F000FF;
	Wed, 23 Sep 2026 08:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790152360;
	bh=moOLRtl3B7HRHlFtZpcGMhBGtQIVrDlmkD6QtGKrT/g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=RS3N/efXIphFUEtBFsza67Ka1RwMr4BLxzOiJOdBGwr+rjJ5oDOXrPT0on7sTmLx3
	 JyhOwCb33yYBvYRbUQ5PLQCKXU3jd53OjIGNCFMNuouzBC9DaX4bbWLJ3lJ/uZDxg8
	 MMM3rhmaiFkgIz4Dxh006YZUNjXJiRcDZit047rpIbXt4IZGBuzWpa+aPmOkKwnsXe
	 ooKtmh12qMBFhPlEqo+a1tG2pddPoc+TTdTiu04cbk4s+AFqE9jzH4eWs8KcaCuAUV
	 gVqxn0Z3erPq5J+5aeyUtucbtJ3ofv4HU7U1z+vpHmAuvb/WcDVz2kvYICHYEHRAjs
	 CTjSmBCM1IcjA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	christian.koenig@amd.com, Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 12/13] dma-buf: system_heap: Allocate shared
 buffers using CoCo shared memory allocator
In-Reply-To: <arKvKME-_wNeW7ea@arm.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-13-aneesh.kumar@kernel.org>
 <arKvKME-_wNeW7ea@arm.com>
Date: Wed, 23 Sep 2026 14:02:31 +0530
Message-ID: <yq5acxu42wrk.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Mon, Sep 21, 2026 at 08:18:46PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> @@ -405,6 +396,7 @@ static struct dma_buf *system_heap_allocate(struct d=
ma_heap *heap,
>>  {
>>  	struct system_heap_buffer *buffer;
>>  	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
>> +	struct cc_shared_layout layout;
>>  	unsigned long size_remaining =3D len;
>>  	unsigned long sg_remaining =3D len;
>>  	unsigned int max_order =3D orders[0];
>> @@ -417,6 +409,14 @@ static struct dma_buf *system_heap_allocate(struct =
dma_heap *heap,
>>  	struct page *page, *tmp_page;
>>  	int i, ret =3D -ENOMEM;
>>=20=20
>> +	if (cc_shared) {
>> +		ret =3D cc_shared_calc_layout(len, &layout);
>
> You should not override 'ret' here, it was set to -ENOMEM for a reason.
> cc_shared_calc_layout() succeeds resetting 'ret' and some further down
> allocation failure, goto free will return ERR_PTR(0).


Agreed. I=E2=80=99ll fix this in the next revision.

-aneesh
