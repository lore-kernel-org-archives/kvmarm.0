Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794765711;
	b=yaYsJE+3gC8/1grEcOVNp3UIzD734tpSFQD1JLZV1amYKUlVZZeUVEGcH20XTik/n8/q
	 kV/fv9ZQPzXtEARPvkA6Y2ss8W+8gVtZ/GREsG7fi/YooyBzGZdUuYAKM1VwrJcPhYvg/
	 fWshIGs0AOUpbF8/EQUERNg6NvqICLytNCCX6W7KLxz7O+RIMxjy8TTkVnObeIBMCREkm
	 Lzeunv3HykuwEhaeR26lv+6sTOK8MQVtYUUA45Z7x2cyw6zp+CbRgX1ETl5uq9Zubiw1V
	 j4qxZELgJy+EiNIIb8gBMGVu5Ip3OuaFrsJagSe9T/pDuREuCtOLjWoT3hmA9gNS3oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794765711;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=E5e8BJEiuZ4whbgu1Hr+6JPc8nqHGgyY0u0a+RokHVQ=;
	b=OGx1C2faWBV3SR8KCgQOGhCGknhl1iEvNz6lAcY67vK7QOjOvnvfRPdyzHDUPC1Xcz1I
	 SYOQ+kiWRt9vQV+JuMkh+oLrbq0DvLPl4PF3iZPxJnoc0cxQwroRGWe17/kvSjcz1n71n
	 ibJ2hp7HlXXhi9pAK41jVN6qZPmKOxtIhB47fTW7gV0P/3ANAYbdDIiWL+VFFmW1p9kTq
	 xVT3fA2+5ZdZ61kNp3N5KFhetpjNhcwAJtCbqoRFSqk8eoGNdPa01qaXr5kq3jxeBHcJQ
	 obG5ioKIoLfOsOqoWfM9B5IPetgsKcPsdw4PqJwRNyfQqc7fEqLEIPP3kvrJYch+AfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o2aAKF9+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75E2606A31A;
	Sun, 15 Nov 2026 18:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o2aAKF9+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FBC1F000C4;
	Sun, 15 Nov 2026 18:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794765711;
	bh=E5e8BJEiuZ4whbgu1Hr+6JPc8nqHGgyY0u0a+RokHVQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=o2aAKF9+YecDzzGk4bV1bgV0jRjVUpJLhAYO7F+KOkCHqua5bwkkqaIW2TcKzIbVH
	 8RrypZah37W8SoLFH+cHTWDJSt7g97GkpFDUJwpOa8fXEP+C7Fk6eZGhN5bZ5QIWGv
	 rNolRUfDXYPxamX3x3K99oNFg+prs8oECrVd82aJgQ4n1vZ2k1l/hIbRyzuBfF8uiT
	 SP3N1MJ5SlYTbuy72JItmaVx0qM0W054SYKcPl3aN0rEaY1nttQPHOG1KwcWmsiT9y
	 t6SsJiUY3zhw8E+wDnL4kBJBk7lTf7M92W7m9dew6fxdbCTR+FrT6wxWeM+LVgDM2r
	 6NmZ515+KqNWw==
Date: Sun, 15 Nov 2026 20:01:37 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, robin.murphy@arm.com,
	maz@kernel.org, will@kernel.org,
	David Matlack <dmatlack@google.com>,
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com,
	loganodell@google.com, arnd@arndb.de, dwmw2@infradead.org,
	baolu.lu@linux.intel.com, Bjorn Helgaas <bhelgaas@google.com>,
	oupton@kernel.org, alex@shazbot.org, gle.com@google.com,
	pbonzini@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
	kevin.tian@intel.com, joro@8bytes.org, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org, kvm@vger.kernel.org,
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI
 compatibility
Message-ID: <avnzgVJic77yKMoh@kernel.org>
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-6-tarunsahu@google.com>
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
In-Reply-To: <20261110050202.529473-6-tarunsahu@google.com>

On Tue, Nov 10, 2026 at 05:01:48AM +0000, Tarun Sahu wrote:
>
> Each subsystem registers its serialized structure with:
> 
>         DECLARE_KHO_SER(name, payload_size, nr_required, nr_optional)
> 
> This establishes compile-time assertions and provides type-checked
> helpers: kho_ser_size() for total allocation size, kho_ser_init() to
> initialize the header, kho_ser_payload() to access the typed payload at
> its dynamic offset, and kho_ser_validate() to validate required features
> during restoration. DECLARE_KHO_SER_HDR(name, *fhdr) declares a struct
> kho_ser_hdr pointer while verifying at compile time that name was
> registered with DECLARE_KHO_SER(), allowing callers to document which
> structure a feature header pointer represents.
> 
> An example demonstrating how a hypothetical structure defines its
> features:
> 
>   enum foo_ser_required {
>           FOO_SER_REQ_BAR,
>           __FOO_SER_NR_REQUIRED,
>   };
> 
>   enum foo_ser_optional {
>           FOO_SER_OPT_BAZ,
>           __FOO_SER_NR_OPTIONAL,
>   };
> 
>   struct foo_ser {
>           __u64 base;     /* base fields, always present */
>           __u64 bar;      /* FOO_SER_REQ_BAR */
>           __u64 baz;      /* FOO_SER_OPT_BAZ */
>   };
> 
>   DECLARE_KHO_SER(foo_ser, 24,

The example should have included 7 fields total to make it 42 ;-)

Seriously, this magic number show must stop.

>                   __FOO_SER_NR_REQUIRED, __FOO_SER_NR_OPTIONAL);
> 

-- 
Sincerely yours,
Mike.
