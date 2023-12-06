Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23651321B9;
	Wed,  6 Dec 2023 11:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m8uHeg6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFF0C433C7;
	Wed,  6 Dec 2023 11:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701863551;
	bh=05fhoFGytrb/RJVFsqCfWb/MpYZO3vCszNXvCTYOi5I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m8uHeg6+sgeVDfycKFuNZurfjPt2fm+n6wDkQ2SIs7zyPppjfdb2wm1va/48JA0TP
	 I1W704/kf75kVpMltgXOgSY4eseh24mIbw19LRFUEJVfd/c/wmYe73odbLOo/5XmWX
	 sFcS/mGGxs7HRYLdErEeAbyFTFMqvKU9uCzB/Wrx6ZCMM0RFZ+vyMOQ7ZydeeB9h6U
	 qxpC1YE4z6o1/Vy43ZMxA6Ct+J67pShbtcOqSkrV/7VbsWnQfFvHsFkflCcy+2+H6I
	 WJmjaPF+/BQfCb6TPQDsXEDG9egNaA5cy6ZqmGOCw1m3ktAdpIY36JlLT+BfUYxlpL
	 FCpOHg+/KS0Qg==
Date: Wed, 6 Dec 2023 12:52:22 +0100
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
	ankita@nvidia.com,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, mochs@nvidia.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <ZXBgdnz7wVYuDCgU@lpieralisi>
References: <20231205033015.10044-1-ankita@nvidia.com>
 <86fs0hatt3.wl-maz@kernel.org>
 <ZW8MP2tDt4_9ROBz@arm.com>
 <20231205130517.GD2692119@nvidia.com>
 <ZW9OSe8Z9gAmM7My@arm.com>
 <20231205164318.GG2692119@nvidia.com>
 <86bkb4bn2v.wl-maz@kernel.org>
 <ZW9ezSGSDIvv5MsQ@arm.com>
 <86a5qobkt8.wl-maz@kernel.org>
 <ZW9uqu7yOtyZfmvC@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW9uqu7yOtyZfmvC@arm.com>

On Tue, Dec 05, 2023 at 06:40:42PM +0000, Catalin Marinas wrote:
> On Tue, Dec 05, 2023 at 05:50:27PM +0000, Marc Zyngier wrote:
> > On Tue, 05 Dec 2023 17:33:01 +0000,
> > Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > Ideally we should do this for vfio only but we don't have an easy
> > > way to convey this to KVM.
> > 
> > But if we want to limit this to PCIe, we'll have to find out. The
> > initial proposal (a long while ago) had a flag conveying some
> > information, and I'd definitely feel more confident having something
> > like that.
> 
> We can add a VM_PCI_IO in the high vma flags to be set by
> vfio_pci_core_mmap(), though it limits it to 64-bit architectures. KVM
> knows this is PCI and relaxes things a bit. It's not generic though if
> we need this later for something else.
> 
> A question for Lorenzo: do these BARs appear in iomem_resource? We could
> search that up instead of a flag, something like the page_is_ram()
> helper.

They do but an iomem_resource look-up alone if I am not mistaken would
not tell us if it is PCI address space, we would need additional checks
(like detecting if we are decoding an address within a PCI host bridge
windows) to determine that if we go down this route.

Lorenzo
