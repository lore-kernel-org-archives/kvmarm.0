Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790495;
	b=TgjHc34zK4xOMZvM4uN69gFnceEyBvMpqVU0iaZpVt9Gx3ZhM1NLal4SyIJ9ibK61+An
	 jDFHBeDKm9Uow7sPDwYe8KLnFCstn05LcL3rD3Yo7zk/+1hK8BI0oblJ3AvDGiEZ7lZj0
	 DxodArUWCfiIOMz7Jihoc+JpJ++1KayM+gbrO4l3cFkcKXpqjE6bCdvuQqE0wFAM+FVLX
	 mufYGP/z1WPs1gFGe+Tex0TH0ZOhRkHABM9urzSVNxE6BMCZOuhFKYRB8lhTqJdgzNTZH
	 pZ26fe3OZAzMHhBTvYf1TiPY+78Ekl/izrSUchAkcHcdU4Rzrfk8d0u63wpoQeVsNNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790495;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=SEZ09rfl3fC0bB/J62YE+Ly+ABzQkNWTxD/3Oq9VKPw=;
	b=i7gotKBnWT92HXnWSHq+6+m8MIxR//MG7r5T/5ld15lpXV5+Vp1OsAwxr5CxkWMfPqnQ
	 cSwHLgBOWBqfAqYywigIj+X9cHcj5Yny1de3tQ7lRPWodeSILdA7HNADrLNFGUKWk5uUq
	 hSbmoKpfP3rpsiL7l+iYQlkuQK6urlUJ9sEvgIHMEvwxZmSxn8Gp5jeN14a5l66GNSgT2
	 baXLWgpwLUjwIvP4vrvtpUdeCYVB22XTGvYMU4o3aRGq1k+eFVO8922NxudwObDjsjeWe
	 g4qK3u96y13RS3ynpE8192jtPncAa/qkwzD8AEU8T6OcW0IVbwGbbIBthdjiRd/YBvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZFN9BpFR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B31606A31E;
	Fri, 27 Nov 2026 14:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZFN9BpFR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEACE1F0089A;
	Fri, 27 Nov 2026 14:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795790494;
	bh=SEZ09rfl3fC0bB/J62YE+Ly+ABzQkNWTxD/3Oq9VKPw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZFN9BpFRdcam3nQN+YC9gJUadLUJyPbAHGj5vHiSMl2hRmquxwkHHswm1KUV1nDw8
	 Ryc5rhe3uxYayqClsir87oxZMyA1LGyzryFu2i0zVypaR4sAFgvSg3kzIitZFPD54/
	 X22onnRQa17fpWANidA7z4Pd8oIVmh5rBZ2DCLuRKqW4+oG1JutcQuTF67T9YdD5Eq
	 rrq6ntIlQvf7/97N4rQZowYmVBwzsV4gCZJk26g9ZehinrTdEbcTQwIZy9MKhCXBl6
	 0rqf+le5aeW7YflkQrlkZIkOqeu0WqKyfSlBEKy/aeXe946juFlDRxNp02cF0DkxI6
	 EZ6dVBRsKJD0g==
Date: Fri, 27 Nov 2026 14:41:29 +0000
From: Will Deacon <will@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com,
	alexandru.elisei@arm.com, andre.przywara@arm.com
Subject: Re: [PATCH kvmtool] arm64: THPs for systems with pages bigger than 4K
Message-ID: <awmWmb8uiDY1QYC-@willie-the-truck>
References: <20261019145949.1922019-1-vdonnefort@google.com>
 <awhZk3NrkqeGvQxC@willie-the-truck>
 <awiX9cEDByf7d40x@google.com>
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
In-Reply-To: <awiX9cEDByf7d40x@google.com>

On Thu, Nov 26, 2026 at 08:35:01PM +0000, Vincent Donnefort wrote:
> On Thu, Nov 26, 2026 at 04:08:51PM +0000, Will Deacon wrote:
> > On Mon, Oct 19, 2026 at 03:59:49PM +0100, Vincent Donnefort wrote:
> > > The THP support imposes an alignment of the memslot userspace address to
> > > the size of a THP (PMD_SIZE). To do so, kvmtool overallocates the RAM
> > > size and aligns it. However it assumes PMD_SIZE is 2MiB, which is only
> > > true on 4KiB page systems.
> > > 
> > > Use a huge-page size, based on the system page size. This value can be
> > > massive for a 64KiB page system, so skip the alignment if we couldn't
> > > even install one THP.
> > > 
> > > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > > 
> > > diff --git a/arm64/kvm.c b/arm64/kvm.c
> > > index 36b3284e4a92..2c01dc32fa9a 100644
> > > --- a/arm64/kvm.c
> > > +++ b/arm64/kvm.c
> > > @@ -18,6 +18,8 @@
> > >  
> > >  #include <asm/image.h>
> > >  
> > > +#define HUGEPAGE_SIZE (PAGE_SIZE * (PAGE_SIZE / 8UL))
> > 
> > Does this invoke sysconf() twice per invocation?
> > 
> > Will
> 
> It does. 
> 
> How about I use for PAGE_SIZE a memoized version of the existing
> host_page_size() function?
> 
> kvm/util.h:
> 
>    unsigned long host_page_size(void);
>    
>    #define PAGE_SIZE host_page_size()
> 
> 
> util.c:
> 
>   unsigned long host_page_size(void)
>   {
>   	static unsigned long page_size;
> 
> 	if (!page_size)
> 		page_size = sysconf(_SC_PAGE_SIZE);
> 
> 	return page_size;
>   }

Yes, that looks much better to me, thanks!

Will
