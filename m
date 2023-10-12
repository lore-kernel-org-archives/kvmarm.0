Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420951EA95
	for <kvmarm@lists.linux.dev>; Thu, 12 Oct 2023 14:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l7brKmqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3C9C433C8;
	Thu, 12 Oct 2023 14:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1697120974;
	bh=g4zyIMr785IdKOmshRe8BPkyHz7FSyWBu6onVRShE/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l7brKmqwuiCDHBI3q/3t8RCzt3QRcl9RdNkDp1eCzK+g5zfMjntqQzq5q6iKL26+m
	 UMQ5piRnIaYeirKMnmJMQO1FPrmbkMRGkhVsNphxgtcOkKV55xQhZ5PuIhYcinwLf0
	 EhTGo+DNP4miSscxWPYC4UdGj9TSHe8DQ0V1rwwwk9/L+WBSJTa6rqolOpgQubPzVE
	 sfZwfnll7r8W8rSamseuS7WZwN+jeAWq7v02owwtSVh1zXnbp+7I7ZFdPvuZbF4rw3
	 xpaDaaehGO7SPsbmVsUtAlJg+EpBj1QOXiRxnKuQThwvq5FVa2UUXlnsPfnz4kTp5g
	 Tkqmzy5gtvj3Q==
Date: Thu, 12 Oct 2023 16:29:26 +0200
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>, ankita@nvidia.com,
	maz@kernel.org, oliver.upton@linux.dev, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <ZSgCxhVMGREXpAQL@lpieralisi>
References: <20230907181459.18145-3-ankita@nvidia.com>
 <ZP8q71+YXoU6O9uh@lpieralisi>
 <ZP9MQdRYmlawNsbC@nvidia.com>
 <ZQHUifAfJ+lZikAn@lpieralisi>
 <ZQIFfqgR5zcidRR3@nvidia.com>
 <ZRKW6uDR/+eXYMzl@lpieralisi>
 <ZRLiDf204zCpO6Mv@arm.com>
 <ZR6IZwcFNw55asW0@lpieralisi>
 <20231012123541.GB11824@willie-the-truck>
 <20231012132045.GI3952@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012132045.GI3952@nvidia.com>

On Thu, Oct 12, 2023 at 10:20:45AM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 12, 2023 at 01:35:41PM +0100, Will Deacon wrote:
> 
> > > Failures containability is a property of the platform
> > > and is independent from the memory type used for MMIO
> > > device memory mappings (ie DEVICE_nGnRE memory type is
> > > even more problematic than NormalNC in terms of containability
> > > since eg aborts triggered on loads cannot be made synchronous,
> > > which make them harder to contain); this means that,
> > > regardless of the combined stage1+stage2 mappings a
> > > platform is safe if and only if device transactions cannot trigger
> > > uncontained failures; reworded, the default KVM device
> > > stage 2 memory attributes play no role in making device
> > > assignment safer for a given platform and therefore can
> > > be relaxed.
> > > 
> > > For all these reasons, relax the KVM stage 2 device
> > > memory attributes from DEVICE_nGnRE to NormalNC.
> > 
> > The reasoning above suggests to me that this should probably just be
> > Normal cacheable, as that is what actually allows the guest to control
> > the attributes. So what is the rationale behind stopping at Normal-NC?
> 
> I agree it would be very nice if the all the memory in the guest could
> just be cachable and the guest could select everything.
> 
> However, I think Lorenzo over stated the argument.
>
> The off-list discussion was focused on NormalNC for MMIO only. Nobody
> raised the idea that cachable was safe from uncontained errors for
> MMIO.

True, it should be made clearer ie "independent from the
non-cacheable/uncacheable memory type...", please update the
log accordingly, forgive me the confusion I raised.

Lorenzo
 
> I'm looking through the conversations and I wouldn't jump to
> concluding that "cachable MMIO" is safe from uncontained failures.
> 
> Catalin has already raised a number of conerns in the other patch
> about making actual "designed to be cachable memory" into KVM
> cachable.
> 
> Regards,
> Jason
