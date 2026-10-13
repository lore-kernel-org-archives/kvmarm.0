Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9928B3C4574;
	Tue, 13 Oct 2026 13:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791899247; cv=none; b=eLQrmnodaiCDamP+RDb2QosbjTWb5IXgg//FY9tcFin91G5IrDb4d46LiLiNRXvhA9He5U6IfhCkL1SIQ+AKPN1ofrTJmUR8NVzKddwl2u45biBOevt2qCQQv46Vb0ybfcq+kpKSm7CsqvKgxTn6BROJzY6PVyBanL9mFe4RhsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791899247; c=relaxed/simple;
	bh=Hd6B3HmdeeY+37Ck7A9VvJD6apYnPKGi0/9MCJajo2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sm2FfxW8WTmPC88TzRt16EymArlGAVhac6Atj2vQfArI9k/sw8EXAdVF7TUCAJfE89vgvupE7rVP51E/Pnq9BGyRS7pKXdYZp+gtr26VREXQqx09qmQG6/MgIgwhL/8Ygo1F+QgpAbZ5IukvrAgr/t6mUx9tTw2QXw2dt9ZUIUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S32sFMdJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S32sFMdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E541F000FF;
	Tue, 13 Oct 2026 13:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791899246;
	bh=ufMZp4Qc9d80hvvRB3vNUruXIvuXEMAYVkTpkYEJ0aU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S32sFMdJ2NY/boJZiq7qHgwrDvnfacP5JNU8mgaJyQiC/aJSf/o6u1yYss44okWo+
	 Sjga82Sb2QOdchZ1LbH0ux4IvEmSVJYxDuqsW2hn+bGfVieTjBjqpSHEZOrRJigUno
	 Px/tm8jUDyk1sC2fW1OcOVHLHHQvxIxtYjd1Q9Yv72c3MLoEPN+IRXDvhqPnrpGeFv
	 wDS7604PLG+GDAQq4ZB6hDi1UaV9y9t8Kh+H+s/ulOnRB0aWSsvTUCvQRS756SbO3C
	 aRc+OXw5d+p7xFNvkD8MgBaeVjQN7uppe/zdzAtPLcpNJmMMBmFatZswffJxTVZJ3G
	 jQSn9tSa+g88w==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 01726198003A;
	Tue, 13 Oct 2026 09:47:11 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 13 Oct 2026 09:47:21 -0400
X-ME-Sender: <xms:XzbOan8Y8kGba8pRx5mgpWDM4YXW1EMocY6hBF154p4NE_F875UjkA>
    <xme:XzbOasWum8CcjS-iK132ufVMOimRtEOpWN8JV7dRfEX1h1Dp_3dY_DtQtcao6Ny_a
    yYaAPEJ0M59QTbNoSdl3ZanKVC4FYisPINrKzr_mvgREULtKWqsDGvx>
X-ME-Received: <xmr:XzbOap0ub0Qc1GVOIpPOLwa49EH1LI7JGZhO_dy3oWX53Pt7ElSMpyHzD84>
X-ME-Proxy-Cause: dmFkZTE4j+cS9gh3PxGqMjY7PyaLxMVg3dj8MlDzlM7GN7gdgiVxP0yJ//GkJN0wCahlMx
    5JdZXyer7uBv1S7r9zKudGJTVsIfvIDNMUthTv4zHTDadaydFl5J3WM5oOjG7bueTu1P/y
    ErJcoDmdDlf2mbevwhHQ61prG/aGc64Y1+ArTq02T6BN55y6XBoncRB7eE5H2SYOX4r3El
    YrSBfcjthcbdK9TH5Jj2U1yRZNxzXvJ0LVkfeDISJaGmLMzoC8igk5XBTY+38fhiHSyGiL
    +cnpmehXA2/flj223aR6gM8IWtENoV0RxoyPyt9udox5uLVBfm0KgCcO5tiVN9eCvh/5JM
    aTKNqGwu/2rDhCkM1c+ix5JpPW+GGwuxufWlSR9jnyihSU+e9+lhP2kVKcTNhuePk4D7h4
    2Q/OqvXjwTCM/tEN3XsDlSmc1l8yzmlZPtSQ3+C0mMNsQsEFPswQDCtfmGg67K80Az+PVL
    LRd83YGI28XR3lRflIQMmdCsHVNKROP4bmpOl8lfPNG/peUSuiL9LZu5QLVVUe3NoZwPGs
    g7i+lcpjCaoYEqyEbFS/GsC8fY2i0+IyggX935VBX1nvot5c71LozqkHm+PSwQtEOzOylc
    ws01IE6e2mhHKHvxbwqIw1oJJoQYx5BwXuQtZfTdhwj1Ef1bu0vOINgdPZAw
X-ME-Proxy: <xmx:XzbOavjAdgGfkkFd30Sl97e4fKs0AXQI0rmS1xtCq9gumhdIOAyBRQ>
    <xmx:XzbOamTbl7FUwBPXlrXZ5UPMDMEsm-qJQemClGWaBNm7JvXRJNgTWQ>
    <xmx:XzbOahFtiScMJxuiSy8_Pg59KzrCRLfao8Sx9nm0MSTSvPdPM-8nyw>
    <xmx:XzbOau_9QagkSr9Gcvi2fyeWTN6rOk-E4VNxPyjkfdaOI5zuhHPpVw>
    <xmx:XzbOanGVoJjyM8cI1RPfiSHx1bWBKrDdsr6nob_WZdZmjMxe9r7CI-pk>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 13 Oct 2026 09:47:09 -0400 (EDT)
Date: Tue, 13 Oct 2026 14:47:08 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
 	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev, 	Andrew Morton <akpm@linux-foundation.org>,
 Baoquan He <baoquan.he@linux.dev>, 	Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 	Pratyush Yadav <pratyush@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
 	Marc Zyngier <maz@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 	Robin Murphy <robin.murphy@arm.com>,
 Steven Price <steven.price@arm.com>,
 	Sumit Semwal <sumit.semwal@linaro.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
 	Russell King <linux@armlinux.org.uk>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 	Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 	Mark Rutland <mark.rutland@arm.com>, Radu Rendec <radu@rendec.net>,
 	"T.J. Mercier" <tjmercier@google.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 	Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 	Christophe Leroy <chleroy@kernel.org>,
 Ritesh Harjani <ritesh.list@gmail.com>,
 	Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, 	Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 	Sven Schnelle <svens@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>,
 	Rick Edgecombe <rick.p.edgecombe@intel.com>,
 "K . Y . Srinivasan" <kys@microsoft.com>,
 	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, 	Long Li <longli@microsoft.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 	Vitaly Kuznetsov <vkuznets@redhat.com>,
 Andy Lutomirski <luto@kernel.org>,
 	Peter Zijlstra <peterz@infradead.org>, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, 	linux-media@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [RFC PATCH v8 02/14] mm: Zero memory during shared memory
 transitions
Message-ID: <as4q9FlxUy9EFJZK@thinkstation>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
 <20260924100529.1398790-3-aneesh.kumar@kernel.org>
 <arZkEugXwCtKHH64@thinkstation>
 <yq5azewiqj39.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5azewiqj39.fsf@kernel.org>

On Tue, Oct 13, 2026 at 10:42:58AM +0530, Aneesh Kumar K.V wrote:
> Kiryl Shutsemau <kas@kernel.org> writes:
> 
> > On Thu, Sep 24, 2026 at 03:35:17PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >> diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
> >> index f904a636d449..1f1f39082391 100644
> >> --- a/arch/x86/coco/tdx/tdx.c
> >> +++ b/arch/x86/coco/tdx/tdx.c
> >> @@ -978,6 +978,9 @@ static bool tdx_enc_status_changed(unsigned long vaddr, int numpages, bool enc)
> >>  static int tdx_enc_status_change_prepare(unsigned long vaddr, int numpages,
> >>  					 bool enc)
> >>  {
> >> +	if (!enc)
> >> +		memset((void *)vaddr, 0, (size_t)numpages << PAGE_SHIFT);
> >> +
> >>  	/*
> >>  	 * Only handle shared->private conversion here.
> >>  	 * See the comment in tdx_early_init().
> >
> > This doesn't make sense to me.
> >
> > On TDX the memset zeroes a page that is about to be dropped.
> > MapGPA(shared) makes the VMM back the GPA with different memory, and
> > what the guest reads afterwards through the shared mapping is whatever
> > the host has there.
> >
> 
> Does TDX require the guest contents to be preserved when pages are
> converted to shared?

No.

From the host perspective, the private page is withdrawn from the TD.
Its contents are encrypted with the TD's key and do not carry over. Then
the host inserts some page (maybe the same one) as shared.

So the memset() in the prepare callback zeroes a page the guest is about
to lose, and it does nothing to what the caller sees. With the
post-conversion memset() gone from dma_direct_alloc(),
dma_alloc_coherent() in a TDX guest returns whatever the host has at
that GPA.

TDX needs the same ordering as CCA: zero in
tdx_enc_status_change_finish() after tdx_enc_status_changed(). No flag
is needed for that.

But, again, shared memory is under host control and you cannot assume it
will stay zeroed.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
