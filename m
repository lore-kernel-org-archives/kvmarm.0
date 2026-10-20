Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792508803;
	b=HdSRggNeonJb0qXCsLwf1k6oc32B61dIrnHFYpdc5CiAu6erA5AfW4Hv4TP61EvHh/Lf
	 bi0AOzyAYSl0vSoW/mJYLG0rma3qwritJx+IKwJtWzCR9GLIprPoO9KdMThYSD0630dM6
	 xF++n7iZzrpYdpJg8tdmP0/duulCffaEZiKWn1wVWmynOBEP2fTLtw57mkfhPRQlcUGt6
	 fv2oqybv0p/fd41MoHJu/S82aI5hVyU6rANBOENy58i6bOs4HWkljm/K14pmxH7w5aKut
	 OmjX/0el17543qtoUonPEdy+3+APp1YKVwIdrPYCOIjFH2GtN6mXU1eF7WKszaFypbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792508803;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=0c2WAJ+A3fmtE5JIgmM33C+5uxJtcuzd3UjlEAxXX4c=;
	b=I1PEnOZKrq5MN19LIFnCm7q1fe8PBZjsHJ80PyOV0uToi28pMPtcwTsKpgxNdnnPc+xL
	 Tp6dqXQDO4MPF1rTcuES2dTH5guBSh1AH8cZUiSu9inor50bUIwUT29lpjv25FP9tccU6
	 Q+sfr07XworeK+jZoqn68VDPLEOvcIoAzKvY/LbDUfltDq21tXf2HpgXKVIqWiIsdQdWZ
	 MRz7NTB4XXCVO8MSFjqyZq8hm0+HReIAKq2Q4iUvBNflfDcxTpeDhtTOszJRYfOQiKYSe
	 fDBCClVuY4yde9cqOuQYHMFlf+W5bGLCB8Q+eLCMJU65KuCNPoGF2Kb0V0AIsWZD0oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=qbsEPwkD;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B91A5606A31B
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 15:06:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B91A5606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=qbsEPwkD
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BACB516F8;
	Tue, 20 Oct 2026 08:06:38 -0700 (PDT)
Received: from [10.0.137.15] (XHFQ2J9959-5.cambridge.arm.com [10.0.137.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 023503F7B4;
	Tue, 20 Oct 2026 08:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792508801; bh=B2p95+bauGKjmtB2lfd2lV6Dt4OS4tWv6hQlDp4Cj+Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qbsEPwkDD7Lc4yU5KuGZCTmflk83ca1uakWmyzyB5V+G5xona4bnVrrf8HUO7SfBD
	 hWcREG5/ibmRlF3zEEC0SajKDIYlVtmTByzKmcih5lFG3FO5cxnsZcCqcNRrejVtTV
	 ofgzQDwH+CmP1BeWW8uCRXFv9mqJ7hmrpsqrKaQ8=
Message-ID: <c367caf3-d462-42ea-b482-bf9c51c47a63@arm.com>
Date: Tue, 20 Oct 2026 16:06:37 +0100
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 12/15] vfio: Support VFIO devices that access the
 CPU MMU
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Alex Williamson <alex@shazbot.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Jean-Philippe Brucker <jpb@kernel.org>,
 Oded Gabbay <ogabbay@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, devicetree@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
 <20261015142552.4128028-13-ryan.roberts@arm.com>
 <20261015164421.GD13920@nvidia.com>
 <95e0f9bd-0203-4c7a-9d09-622593bb3d4c@arm.com>
 <20261020140944.GA3008132@nvidia.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20261020140944.GA3008132@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 20/10/2026 15:09, Jason Gunthorpe wrote:
> On Tue, Oct 20, 2026 at 12:51:26PM +0100, Ryan Roberts wrote:
>>> However.. you still have to affirm which single mm is the mm that the
>>> device is going to be doing DMA against. The process the opens the fd
>>> should not be forced to be the mm that it gets linked to.
>>
>> What is the mm representing here? Ultimately we want to install the KVM
>> instance's stage2 pgtables and (pinned) VMID. We currently get that via the
>> bound KVM instance (which looks like it still works using the cdev interface?)
>>
>> The guest will then install the stage1 pgtables and (pinned) ASID associated
>> with the relevant (guest) mm_struct.
>>
>> Do we _need_ an mm association in the host?
> 
> Ah.. I see, I didn't quite follow that. OK.. Ah everyone else doing
> this is using iommufd with a viommu to establish their connection
> between device an KVM. eg Jacob Pan's series. That's a probably a
> better idea to stay aligned with the common path. Though your reasons
> are a little different..

Just to check, you're referring to [1]?

I was under the impression that I could open the VFIO device through the cdev
interface, then bind it to the KVM instance via KVM_DEV_VFIO_FILE_ADD... Why do
I need an iommufd at all?

[1]
https://lore.kernel.org/all/20260925190742.1575380-1-jacob.pan@linux.microsoft.com/#t

Thanks,
Ryan

> 
> If you manage to get pinned VMID out of KVM then we can implement SMMU
> BTM as well!
> 
> Jason

