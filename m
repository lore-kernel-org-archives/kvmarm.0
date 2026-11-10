Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794330446;
	b=y4Nt/HvDgVxzFg5xqW4fSBBVLmbnu23ZZJVZpppo3Prt3lPfmfU15XZLpvh77Cv/mU2i
	 TzhXGqesZ9jBrZBREFJf5jaoxSqh6fVxcrG6YY/L+Al7wf25ChRHChLpruWeG8FhXGbgf
	 +XGhk7TievDZN2nj7Fn4e3MZNTA+VVCFO8ISwZ4gc1BPl9R6Oq3nImpfUOz7Yth/tDk5C
	 j79QzIutYKjlKgYD0sREqlUlQkGgjd6k4ATImlg4DbFtKRnKWZ9sP9gGKcpFB5jsznYNI
	 pXQnIUW1WhPZEWKIEAz0RXU1staPPJHqn8nLxxldEqGeVUh5Q1fBNKJq/SibHU726Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794330446;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Mime-Version:
	 Content-Transfer-Encoding:Content-Type:Date:Message-Id:Cc:Subject:
	 From:To:X-Mailer:References:In-Reply-To;
	bh=FNcC9m18UoMJxRcJEPoSUxoKZdU2fxVY/XU8PXnrjcA=;
	b=co1BhFampp2jtyCkZqAcabxEHe8yBGdKhgJNtTL71wfIbFlvM2mQWI8xnhpPSo0dOFbt
	 4k/Iod4W7SAi/1s15E+rvcEEAHa5AoVS4bVefWzwrcqhEzQPgFQxgcFYKUlm4yFi5xtxw
	 PYVKatVTMOnG8hQEeyN4iBu9ay4lB/qOGwVfgkT2d6E3ZTGFY+RlF0lqBak24nRRwbORj
	 S63Yay7Q118++4YSOuw8Lhwxpc7dc754p4N2dzBHK9jbO6vbMGd06P/e+j+obNvvtWTVB
	 kivjSvmbJ+IZTvZjZwr37qpBuspbdrHiCcrPp3BuUIY/jXIu4RaRXA7NW0fcthnPA+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Ll0+Kvxx;
	arc=none smtp.remote-ip=209.85.215.179
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B6D606A323
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 17:07:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20B6D606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Ll0+Kvxx
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cdab8873d9dso977705a12.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 09:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794330445; x=1794935245; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FNcC9m18UoMJxRcJEPoSUxoKZdU2fxVY/XU8PXnrjcA=;
        b=Ll0+KvxxI+7IeuvplIdz7eSwRx9j+HljixU6YOayzTVMwxQLQ8B3ghkMFHsbrdJU0Y
         wTNjyow+DEOpLOct+X+4JaPEZAf6eVTLywqpyMGTmm88DyLbrzyFaalcvZTaKxweKqe4
         1UeB/grNPGGNPji2RaXwJldNfGK7Nx+llFCxh2zpqfJ5WtUhEC08M7+5X6lDgBnG0NiL
         YmDItt6FK+r35cWntGxVz9MKTCtwJh0anmThSHOGMBs5x3BXTjK9PijI6u+Z6PRdb1LF
         j9MXcdXSx3Fy5RR+U/WIf4XQ5EJqDgJmttceBaq4W8IPNKItDGigLOSmOrHexY3detaW
         t3qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794330445; x=1794935245;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FNcC9m18UoMJxRcJEPoSUxoKZdU2fxVY/XU8PXnrjcA=;
        b=dfZICzLvjmRqy/Bj8cFd9ro0otmuYu8Ja5QxZpAGbon7D43KlC73jf7AdpbFApmFUI
         nNJRtRQ6XDMmvTb0mRQ9rFRwCS3n5ImydFmORI1CY/XtXf9RLz4TvDxqSxpvB0Gzm4aX
         u8M7VHsiqpJ34PBLLofTSF5wLhFtp1fd7p46lEQfOtr7igkkztFOKalK/qwmjEADFKFF
         DkNrYBB4YXEEmN6P1nxBhoKKnp8SUYu8r3pqSdzc+nj9OC5zWp9I4+OVuohldUljLzUO
         ms8uHUeq05XyZtyIGDBqZ9N8HEpbbaZkFRILyoqPPt3kkibSXTcChFexMwBfv6WlvgwW
         9iRg==
X-Gm-Message-State: APuU4Z+/zPUsPZEcQDbwjJAtNxLRxx6R6nV8NiozYLiBHZ+guRoiF15l
	qh0cnUMmevw/KLCuHEEzSilJY29tF1y46fMS6df3B6lqdyPP0uWPUhU8KtwaRj/plA==
X-Gm-Gg: AYBFou1xGZSE9AP11u+DAFOu1RqR5ZYYtGdSCYqRcgtRJgMCcS6H5qQ8sc+ouaUob0W
	67L7WR1ClFf36V3kfo81GQkPLNYhNdR7Y6JJQecuMTQAc8OcT/Bh8z/Pvro+swq5eiwDmbwtsMo
	hkThlisHuul40ZB3ZcryZxjWuMwTBNZoFtNVt2TSO7Ks2J6cIiXHy7W+8pc0lwktg3Y96sWi2kk
	Y+g6EgbipSIXXAL9yQSUn+D2b/TqKw3+VV9YZ7TYVYWcSptiwr3bntfnSNlAtEOzv6vbhuO2PEB
	yfZ9K7HvVZHG7tvhS/KTin2+H9sMg9kOFRtKsMTN48crn4Z7rGZpvybCL/unS6dWPao5rj3RZIK
	r1bW+GAhj4cyEQUxZCxHUTGcZFTIZ5zlMMYHvU5H2umZgqMq151Hx1yPWziuBuVL8bHOG137fjK
	Sf6ZiC/Q3Hpi1+bsNm146B3CClVcTUiuSm+WFNl6gWvJGy1rTYnSMm2V20tOZCqmcsJH5MLk763
	5U85u7ZXv8WP41I4KAGAn+s+Y07SwuKZopQ6Ey7sIRgEs+s3H1c4AafXfRPV+CbRMF9H9H56z9/
	df1Mg/qFm0PcS2Ps5ft1TqDbva9UJ44I5c2G6njWsJot6Bu2CxtyTh1qOLSTq/xS
X-Received: by 2002:a17:90a:e7c1:b0:3a5:133:ca5f with SMTP id 98e67ed59e1d1-3b166cdb54amr3659496a91.46.1794330444574;
        Tue, 10 Nov 2026 09:07:24 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db56c7esm499973a91.8.2026.11.10.09.07.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 09:07:22 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 10 Nov 2026 17:07:22 +0000
Message-Id: <DMRP21FATCC0.ARAURXWV85JP@google.com>
Cc: <kvmarm@lists.linux.dev>, <linux-pci@vger.kernel.org>, "Pratyush Yadav"
 <pratyush@kernel.org>, <kexec@lists.infradead.org>, <kvm@vger.kernel.org>,
 <iommu@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
 <skhawaja@google.com>, <sagis@google.com>, <linux-arch@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 08/19] kho: block: Add the feature header to blocks
From: "David Matlack" <dmatlack@google.com>
To: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>, "Mike Rapoport" <rppt@kernel.org>,
 <robin.murphy@arm.com>, <maz@kernel.org>, <will@kernel.org>, "David
 Matlack" <dmatlack@google.com>, "Alexander Graf" <graf@amazon.com>,
 <seanjc@google.com>, <jgg@nvidia.com>, <loganodell@google.com>,
 <arnd@arndb.de>, <dwmw2@infradead.org>, <baolu.lu@linux.intel.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, <oupton@kernel.org>, <alex@shazbot.org>,
 <gle.com@google.com>, <pbonzini@redhat.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, <kevin.tian@intel.com>, <joro@8bytes.org>
X-Mailer: aerc 0.21.0
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-9-tarunsahu@google.com>
In-Reply-To: <20261110050202.529473-9-tarunsahu@google.com>

On Tue Nov 10, 2026 at 5:01 AM UTC, Tarun Sahu wrote:
> Precede struct kho_block_header_ser with struct kho_ser_hdr using
> DECLARE_KHO_SER. Each block in a block set starts with struct
> kho_ser_hdr followed by struct kho_block_header_ser. Serialized entries
> start immediately after the header payload at offset fhdr->size.

This adds a feature header to every block in the set, but the layout it
describes is a property of the whole set: all blocks are written by the
same kernel with the same header.

Blocks are only ever added and removed at the tail, so the head block
is stable for the lifetime of the set. I'd put a single set-wide
header in the first block only, e.g. a struct kho_block_set_ser with
its own feature header, and keep the per-block header to next and
count.

entry_size (added in patch 2) is another set-wide property that belongs
there. All blocks in a set have the same entry size, so recording it in
every block is redundant, and restore has to check that the copies
agree.

[...]

>  		entry_size =3D ser->entry_size;
>  		bs->entry_size =3D entry_size;
> -		capacity =3D (KHO_BLOCK_SIZE - sizeof(*ser)) / bs->entry_size;
> +		capacity =3D (KHO_BLOCK_SIZE - fhdr->size) / bs->entry_size;
>  		bs->count_per_block =3D capacity;

Nothing checks that the blocks agree. Each block's entries start at its
own fhdr->size, and count_per_block ends up being whatever the last
block implies. With a single set-wide header this can't happen.
