Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F3E1C11
	for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 08:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF5BC433C8;
	Tue, 26 Sep 2023 08:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695717106;
	bh=Fc48TGFGlIvNgT5qj7OMuZkiOQBxoSbh/YnlAwsL9Uc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gJ5n8dkm6AT3cuVGUxgXBM0mMuUixfCKzrCGnbeNxoqGWgmxJR5SdFe7U6reKp1yx
	 pa7R/A9x381CenK03NcXBpJbqW7/Wqo+tJ8JHTimsjhSTtn3jPUWmrLL/MtDhVKIji
	 R0xvu18gp3g9eocn2oW2lCWbzPs519LEpf0Zm/BJ1jZTXQ4rpoLmrrTAZMgifY58ht
	 bgAfVL+vUPzbW6u4EjBgGL0fZwMlOgA2/jOFYwOcMEwsPmQQbQzIH0a5MtW//y/lvk
	 snppNh8bAbHQpZGy3l5zwWIxs8FFPrYYCdMyeqVYdyUlr3OsOYM5p5oI2ZqSKRzGkl
	 GnaCa76+elYsg==
Date: Tue, 26 Sep 2023 10:31:38 +0200
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: ankita@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	catalin.marinas@arm.com, will@kernel.org, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <ZRKW6uDR/+eXYMzl@lpieralisi>
References: <20230907181459.18145-1-ankita@nvidia.com>
 <20230907181459.18145-3-ankita@nvidia.com>
 <ZP8q71+YXoU6O9uh@lpieralisi>
 <ZP9MQdRYmlawNsbC@nvidia.com>
 <ZQHUifAfJ+lZikAn@lpieralisi>
 <ZQIFfqgR5zcidRR3@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZQIFfqgR5zcidRR3@nvidia.com>

On Wed, Sep 13, 2023 at 03:54:54PM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 13, 2023 at 05:26:01PM +0200, Lorenzo Pieralisi wrote:

[...]

> > I can write up the commit log and post it if I manage to summarize
> > it any better - more important the review on the code (that was already
> > provided), I will try to write something up asap.
> 
> Thank you!
> 
> Jason

FWIW, I have come up with the commit log below - please review and
scrutinize/change it as deemed fit - it is not necessarily clearer
than this one and it definitely requires MarcZ/Catalin/Will attention
before it can be considered:

---
Currently, KVM for ARM64 maps at stage 2 memory that is
considered device (ie using pfn_is_map_memory() to discern
between device memory and memory itself) with DEVICE_nGnRE
memory attributes; this setting overrides (as per the ARM
architecture [1]) any device MMIO mapping present at stage
1, resulting in a set-up whereby a guest operating system
can't determine device MMIO mapping memory attributes on its
own but it is always overriden by the KVM stage 2 default.

This set-up does not allow guest operating systems to map
device memory on a page by page basis with combined attributes
other than DEVICE_nGnRE, which turns out to be an issue in that
guest operating systems (eg Linux) may request to map
devices MMIO regions with memory attributes that guarantee
better performance (eg gathering attribute - that for some
devices can generate larger PCIe memory writes TLPs)
and specific operations (eg unaligned transactions) such as
the NormalNC memory type.

The default device stage 2 mapping was chosen in KVM
for ARM64 since it was considered safer (ie it would
not allow guests to trigger uncontained failures
ultimately crashing the machine) but this turned out
to be imprecise.

Failures containability is a property of the platform
and is independent from the memory type used for MMIO
device memory mappings (ie DEVICE_nGnRE memory type is
even more problematic than NormalNC in terms of containability
since eg aborts triggered on loads cannot be made synchronous,
which make them harder to contain); this means that,
regardless of the combined stage1+stage2 mappings a
platform is safe if and only if device transactions cannot trigger
uncontained failures; reworded, the default KVM device
stage 2 memory attributes play no role in making device
assignment safer for a given platform and therefore can
be relaxed.

For all these reasons, relax the KVM stage 2 device
memory attributes from DEVICE_nGnRE to NormalNC.

This puts guests in control (thanks to stage1+stage2
combined memory attributes rules [1]) of device MMIO
regions memory mappings, according to the rules
described in [1] and summarized here ([(S1) = Stage1][(S2) = Stage2]):

 S1           |   S2          |  Result
 NORMAL-WB    |  NORMAL-NC    |  NORMAL-NC
 NORMAL-WT    |  NORMAL-NC    |  NORMAL-NC
 NORMAL-NC    |  NORMAL-NC    |  NORMAL-NC
 DEVICE<attr> |  NORMAL-NC    |  DEVICE<attr>

[1] section D8.5 - DDI0487_I_a_a-profile_architecture_reference_manual.pdf
