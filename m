Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58E318C24
	for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 11:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B91DC433C8;
	Fri, 20 Oct 2023 11:21:53 +0000 (UTC)
Date: Fri, 20 Oct 2023 12:21:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Will Deacon <will@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>, ankita@nvidia.com,
	maz@kernel.org, oliver.upton@linux.dev, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <ZTJizmxV4Gtb4g3S@arm.com>
References: <ZR6IZwcFNw55asW0@lpieralisi>
 <20231012123541.GB11824@willie-the-truck>
 <ZSf6Ue09IO6QMBs1@arm.com>
 <20231012144807.GA12374@willie-the-truck>
 <ZSgsKSCv-zWgtWkm@arm.com>
 <20231013092934.GA13524@willie-the-truck>
 <ZSlBOiebenPKXBY4@arm.com>
 <20231013134541.GP3952@nvidia.com>
 <ZTEN_oe97VRWbnHb@arm.com>
 <20231019115142.GQ3952@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019115142.GQ3952@nvidia.com>

On Thu, Oct 19, 2023 at 08:51:42AM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 19, 2023 at 12:07:42PM +0100, Catalin Marinas wrote:
> > Talking to Will earlier, I think we can deem the PCIe scenario
> > (somewhat) safe but not as a generic mechanism for other non-PCIe
> > devices (e.g. platform). With this concern, can we make this Stage 2
> > relaxation in KVM only for vfio-pci mappings? I don't have an example of
> > non-PCIe device assignment to figure out how this should work though.
> 
> It is not a KVM problem. As I implied above it is VFIO's
> responsibility to reliably reset the device, not KVMs. If for some
> reason VFIO cannot do that on some SOC then VFIO devices should not
> exist.
> 
> It is not KVM's job to double guess VFIO's own security properties.

I'd argue that since KVM is the one relaxing the memory attributes
beyond what the VFIO driver allows the VMM to use, it is KVM's job to
consider the security implications. This is fine for vfio-pci and
Normal_NC but I'm not sure we can generalise.

> Specifically about platform the generic VFIO platform driver is the
> ACPI based one. If the FW provides an ACPI method for device reset
> that is not properly serializing, that is a FW bug. We can quirk it in
> VFIO and block using those devices if they actually exist.
> 
> I expect the non-generic VFIO platform drivers to take care of this
> issue internally with, barriers, read from devices, whatver is
> required to make their SOCs order properly. Just as I would expect a
> normal Linux platform driver to directly manage whatever
> implementation specific ordering quirks the SOC may have.

This would be a new requirement if an existing VFIO platform driver
relied on all mappings being Device. But maybe that's just theoretical
at the moment, are there any concrete examples outside vfio-pci? If not,
we can document it as per Lorenzo's suggestion to summarise this
discussion under Documentation/.

-- 
Catalin
