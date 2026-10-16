Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE391C3BFC
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 00:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792109693; cv=none; b=SREHp6749kKnYWZORWqwOPe9N+KsRQh0cNCecN436UebPIqpgPGfh3MgjL/VD0y2VJvY59nwjeQ+aBIaGCSWr3bvcIuqnFsCdc2TBKizHZTckg3sURQP+39wStFsyf5ae/E4+DxoWdgLndpURZlOYcVvb+LIgvNn1ZBpDBUgGVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792109693; c=relaxed/simple;
	bh=N3hAyy7nTu0uD6uxxEosrsvSAc05WwQLSTSIID6INNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oQL4ihDAGmXWvS783iA18OArqFb6kN/OAbu65qwzlQJiTYgUVpb7l8ls0Il5N197RVMZ7Xuhr2xKyfHqH6bIqwbBfSiQyvNjfGkSVS6A4CcTgBsHE7Pj9YFR+XPoym8V80TD3jOjo6N/9xQ0hrZIBGS8zCpo/fz75ioJjAa/AAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=bJzYnRFl; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="bJzYnRFl"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-535d60d850cso5463631cf.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 17:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792109691; x=1792714491; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=V2saNd2pf5xXpmgizEGMG+P83blHZRupazL/vtIJhv4=;
        b=bJzYnRFlIDxmVj0hiPhhIk0Tpjyy1Hw8G0mxbVBIu4vU0O9DXvQKwpYj4o6qxs9Y6x
         aymBEGjcgZpuZvh1GqjD9yZSAs6m8g1eyKY0QAxkhvpddBEmzS55ehGLiJQbngJmr088
         1wX9hegbOXjL9KRYIJ+Qi1tp1I6Rx4Cgh1MpUKPOBxM/YEFk3kb+Kj3lNklsjL5Pnjqp
         fniPPEYKSQVn0npdcaBPUlBGwSGR8vBxFdfSb5D/eT0odmQ+wQyerA0UX4aGK4osd2GE
         6rz81qrWRn7VRbc84MOJBMOgulrPRhegfd5NL8i3aClEUpkZ+vivifirQ6iQpmG1vy3s
         yiRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792109691; x=1792714491;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V2saNd2pf5xXpmgizEGMG+P83blHZRupazL/vtIJhv4=;
        b=GIzASKnaDAmmZ0oVfaKny3Z15eCQswzss45SJcLJD/yNsE7J5+wkKDqFXlOfr9GX2v
         oJbuqco/jcfbY5kSxuwmzQkLrAN9NmE1sJLCx0nDyhW/wHy4eQTS469pVL5OUYIw0Xz4
         jlrPGRUV/WTbfG+MaCwI8DTfvQz4GpGHE66W0qcNpL02YbxZubJp4jGrzNOnfaHjc2u3
         DF/AkVZsef/i+SGuDETAoc7gs8pvu3wTbd6j8JA3mYiuLFrxgPW6TxKV84wpXhTNObIQ
         hcYtTUZtWpJaet4tLPjZ0qphj7VfH3K/gQd/WMchuDteUzhNSTou9VHMEsumxwZ4MLNo
         gQKg==
X-Forwarded-Encrypted: i=1; AKwUvBwcwxFY7grrq60vlj7iwJhsue25Yr2BA+QfvAAvQIXYf7H83Pl10mjpT8oKWv5txam9lXIkH/I=@lists.linux.dev
X-Gm-Message-State: AFq9FYIU+ZW6rzXW3BQRcmfDrWmDlPGZA4ncph5rKYHUoYM9wr6C1jGx
	PofYOlaZtEQxFPn/b3C62K5+A03XctetgarTQ0J/ourJldUzp8GjdKzKc44os9M3jNY=
X-Gm-Gg: AYBFou2NuEOcUZuxTEYr+11A6x3oVp9qG0cUFemb0aTr0tfCSxNPrfFo+XkjJNWxYpM
	rnUefOtiT4HSRzmwdORW9K/mdILPc5rsK7ZsFajFIzNfeADc9ruCQdMHntzMCzdsYZFR9FqK5RL
	xglAX962tYE9d09ga4rAPTTAnPAyo6EqphHUuyvAJTWsQGUxqG3w8vNGZ9PMJxXMZooQISPMfKj
	4r6BSbHFS9dSq9T0Ua6NfXjwhGb0Vqq53h160U6q1M0oLTv9G3mMhz7otbH06Q+K2/H0zCSfEVb
	F3tc3COu7Cldj03rPgMIq1h+QV25TSQtxos/9IKx51aJTH592zShau5fDJQkP+K/BVLpJAgVS7s
	LXmWGrAZJ4fRhnU7JaBH2BNgmxDrmtTeg3a4nRXx9g+HAp8hB99YuVe7HKNooBcfJ3ichEsNgOo
	IXG0z9bCzWrGn3wZ1MvuHfUAyTXlkVmXOEkBkU1QANHc7G0EI7BAyw0XzbdwPoLNgD7vS8/ON3w
	VkCO6ht6FB0zMRdk1PxaXVi1qVLYKn8aeXzucD/rUlykpU7EAB8gkvE
X-Received: by 2002:a05:622a:990:b0:535:ba01:d95 with SMTP id d75a77b69052e-536272c2d55mr30900421cf.19.1792109690637;
        Thu, 15 Oct 2026 17:14:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5362aa57106sm7257071cf.28.2026.10.15.17.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 17:14:49 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xHVay-00000000IxD-2c33;
	Thu, 15 Oct 2026 21:14:48 -0300
Date: Thu, 15 Oct 2026 21:14:48 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Fred Griffoul <griffoul@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2 07/11] iommufd: Use large IOMMU pages for provider
 mappings
Message-ID: <20261016001448.GC14213@ziepe.ca>
References: <20261014093733.90312-1-griffoul@gmail.com>
 <20261014093733.90312-8-griffoul@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014093733.90312-8-griffoul@gmail.com>

On Wed, Oct 14, 2026 at 09:37:29AM +0000, Fred Griffoul wrote:
> From: Fred Griffoul <fgriffo@amazon.co.uk>
> 
> Provider pages are mapped with one PAGE_SIZE entry each. A device that
> uses a large provider block then misses in the IOTLB on every page, and
> the IOMMU needs more page table memory than the block requires. A
> revoke also flushes the IOTLB once per run of pages it unmaps.
> 
> Map each block that the provider reports with large IOMMU pages where
> the IOVA and the frames are aligned alike, and with smaller ones where
> they are not. Only the pages of the block are mapped, as before.
> 
> A large IOMMU page can only be unmapped whole, so a revoke that cuts
> one widens its range to the whole page. It maps back what the provider
> backs now, and a device may also fault on the rest of that page while
> it is remapped. The widening finds the page with iova_to_phys():
> pages that only look like one large page make the revoke remap more
> than it must, which is harmless.

You are going to need to go into generic_pt and implement cut and a
more suitable unmap to make this stuff work properly. We can't over
unmap on conversions.

> iommu_unmap() may not split the range of one map call either, and
> virtio-iommu refuses to. Map each IOMMU page with its own call: the
> widened range ends on IOMMU page boundaries, so it also ends on map
> call boundaries.

Also please don't write commit messages with AI. WTF is this even
trying to say? The subject is "use large pages" and this text says
"map each page with its own call"

Jason
