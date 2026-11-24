Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795527984;
	b=cGsmsPJUaSBa7HzYIY9YhNgSlK51HhdVxH4WbEw6t0mukniqP3J8MDKWAKppYtFHJStK
	 85p1HTdLx5AoPS+5yUQqzTye00+tMmYVMJIHX5uTPA7+glIWvEZ51RmOsWfmf2lNzSRgU
	 5DMhJA7MqORJ1AB4lUmUzh/NIEHoAMQbnGjmmOJ+LuEFnBfM3vDEggouJYG0NT4jHLn0r
	 W2rcvGFHnIe6Bz9BQxnnEVD3PxVnB/Fy57D+OdiyXOu7fnT7qKIUS+Zk+XmscRYBvh7wU
	 aPcj//tr1fRZioNRxMd9SwzLXPKnO0hU/lew88c5pdhZ/ldgrUDDefvbr0unhkQQVlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795527984;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Zc7zKgD/SDYnIbkY4MVpBd0Jo9DiJTva6Dv7og4GVfM=;
	b=JFEK8GSeK9TjxJlcoIIMXi4ToSqVt0xpzraXqQdmDPTE2c11L4KxC1Ofe6nkLuzENPyj
	 ZRbZuFE2RDu+W2iUUTspRC5MHIZgndYbAYXSAp1uZLe2JVv4M3UZQv96fRp/F5Vwtve5Y
	 h/Lqr3sVADhA/dkvR+j82cd8TEcqLknjEAZnf168syFkYaxLZ4A1+6P0S7jZGjF3/dmpa
	 k2BugguKv/lCHzL9gktboQWh9NvajzZej/JYjYuASr35UFp/CVU4oFzMT5HuV4iw/nTt7
	 x5m81v1/O1zDLaY4CowbFf/Oak8oDla/KND76Z3/dyp0F9n5mveRq2Vq5mY0Kzgi1PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=EqnpeJwx;
	arc=none smtp.remote-ip=209.85.160.175
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D7F606A31E
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 13:46:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08D7F606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=EqnpeJwx
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-53664b4860bso52277651cf.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 05:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795527983; x=1796132783; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Zc7zKgD/SDYnIbkY4MVpBd0Jo9DiJTva6Dv7og4GVfM=;
        b=EqnpeJwx4IAAp9mfsj00WoR29F/1+r5796MPouaebQUygK4aVUnRa6eVS7qXcaT4ks
         Cy1SozoWyb/dvImEqPhS5piGTnA+NT7OFO3eWko2Zh3shjWND6NUhDZZUGTo4his9VU8
         qU/Hj+sBdzclTaKlXDb/qa1g/+8nQCAFYVADWucUf30k7kyCTDmxc9cAiv3P9rg615By
         dIEnYe6/1/C2VpeNnzi0ixjLPEc3Tyfb17hPezkZxync20ieZ/j49+DFoLdPHOqp2D7J
         ORJcbgEnXNTXIZifTIp3/jwUYHap6o0pF353gcrfEyNfbXCqGnTLL65RNrBC4/EEmmoW
         pXeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795527983; x=1796132783;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zc7zKgD/SDYnIbkY4MVpBd0Jo9DiJTva6Dv7og4GVfM=;
        b=DVneu7KRnbdcDjy05BWjDtsA/oaRCjT75sF8ndZCwwMWwPMEdJZFZGYTENS3NS2hQ6
         qC/tAtsjgQPejpYyaQXD7pIBMf3F/8tiatAKR38NEr/VzrulGGEicB5TyDryGkLRfDz5
         pZ4JUjf8gbjnPyuJ+UfpxVrg8UFsl17qddY7/U7uzGf/AvxB89nrsi8Nq8jckZN0kmCS
         5hOwHCWDbCDFiIRnBfUNFUq8vPdEOUEwO+t0CWCy89Ql9/tf0JlysYxIK6fDTp3ULeNI
         oBj/6rdc1ltMzsPJTraIH0eA86HczUwr79m/rl3ukxrPJ0QRLrds8l4tk4Rkk+5+gXb9
         bYDw==
X-Forwarded-Encrypted: i=1; AL+hErEoGUkktRbVKr4vzrSAtyDPadRxsimb5XQZbPiozpemDD6bRq6P2SLVV4LIiOWVZvj8oEt3DgA=@lists.linux.dev
X-Gm-Message-State: APuU4Z/koyiw2339XOylWpcrZyrOJvLf2BGm8ZHqQ50CrP1aijQqRmra
	1kFV/zhw06+Wr0Yvd6ClcUQq0xCqwd8M+XMLh3ccGBQXSZlilzb32bQC1tLU41CLoJM=
X-Gm-Gg: AZFdTZdAdGMoTlasNKD+dxjxKMItk8NiImou8gEzGdhPSomDx/ZhZFryfXGqoVJZCZz
	7guxgipGt7uPkmLYhBJqaAbwNsphwy2bcI9gUeEgFPkD13dWFKuOMj/51jL+V/YvcC5M89U7ToC
	n9uuIQAX4D6ycyC3c/Hbs+eZFmcVWYahjF0rs6hu6xoF2j9JmI/1MEuXCPGqD+iyhUn1lttTBHK
	O6Qf/6C6HpP7DJ4cfaFp3VzGSTiYFJlLtGpbFGd82YlwvJHM12jcrxrB+I6iQxTxXwkmSaLJliE
	vVaEMJ4an2ecHvjmWI1MAzE+vz/V7sWu7U0+XGcu8kL7bvcBjF4Bw0Y1dzEvmOnhxabfZIqZIa+
	iXMPns/RQQLP6WhIniEJ+0YGp6sC3oZSpg0JpJobVEpqGl2EpO3D3x1rXYetUnkr+8IRBL+8cMr
	UDMvIlYabwyUAt4hZGoCzx3SEFkWKfudf9+M/C/DLcDExw2MAE4jypswcMBfknCyTrmKIseGfMG
	37Tcw3ClSxZrtYJzZ82YAjwa+jbIsQWUPXU/9l+33FuhROBVe58v83OdP8L4EPgc2palxJlKGJF
	ObyR+A==
X-Received: by 2002:a05:622a:120c:b0:535:a5f9:752e with SMTP id d75a77b69052e-55d76aed568mr264410241cf.77.1795527982900;
        Tue, 24 Nov 2026 05:46:22 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d78451407sm128368371cf.2.2026.11.24.05.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 05:46:22 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVqqj-00000000QIG-3EJB;
	Tue, 24 Nov 2026 09:46:21 -0400
Date: Tue, 24 Nov 2026 09:46:21 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Christian K?nig <christian.koenig@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
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
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v10 04/13] irqchip/gic-v3-its: Allocate shared tables
 using CoCo shared memory allocator
Message-ID: <20261124134621.GI9566@ziepe.ca>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-5-aneesh.kumar@kernel.org>
 <awQd81MwZqi55gf8@arm.com>
 <yq5aa4mybbmv.fsf@kernel.org>
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
In-Reply-To: <yq5aa4mybbmv.fsf@kernel.org>

On Tue, Nov 24, 2026 at 07:00:00PM +0530, Aneesh Kumar K.V wrote:

> Taking Jason's feedback into account, we could have the allocator
> request compound pages and recover the actual allocation order with
> compound_order(). That would avoid passing an order to free:
> 
> void *alloc_cc_shared_node(int nid, gfp_t gfp, unsigned int order);
> void *alloc_cc_shared(gfp_t gfp, unsigned int order);
> void free_cc_shared(void *addr);

It probably shouldn't be order here, that is hard to use. Just size_t
len

And round up internally

If we ever want to do some kind of slab sharing scheme then the API is
already set up for it.

> As you noted, dma-buf would need virt_to_page() to obtain the pages for
> its scatterlist.

I think that is fine, other places working with kalloc/vmap already do
that.

Jason
