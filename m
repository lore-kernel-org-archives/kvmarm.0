Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793110987;
	b=Bvt4dlnFq324LS4iiSwB86MO9W1G3hhFUB2RWjWvu18Y9Y89xCg6hTZM2QHdO/JTsDqu
	 Uxn9+gjeWv511ZSYbauED6up/50QfrkocfAEmBDOn4oMy5Es99e9CByxNdCmFaD2SPhfY
	 XLYwqvQie6OPiF+3lio4Y5AeqHIJXDOZBkTpi/mQRZMGjxR37A886sqVLjdATNiGk2FRX
	 H4/tRTT8evuzoE6Vl+2H/dnkhnM3ymnnSPWutT70CfkIr4BitvAA/hC3B8W1Cnb+aKJtA
	 zVT9jbaaqcwK91cK/5cFWkQPhm0hUcONTF76kXV5d1CtRmzieuWdbX87hEEI/KTHq5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793110987;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=YCM1R6dVVWvuIH+UBR6TH5CMJ3bKt8HZdVGd2g1zmYs=;
	b=02POx9IapN1F2n0ALapkUdBUkR+x/XsM37FHYyr3Hgyq0s9N5GojEpKycy4vIFv9mjFQ
	 mKorD8Ocgg9/nO0wxUs5yeFIYM/jHNXPQGedK7WwVWKhqf8OX+haW4WsPik+ZMHGyLI0x
	 N42p2GqEQoX1RxMPQAnNO4ovNdmiDS1/j0l61Op9B4BpuI2SLQ9mw3lfmj0YkY6Fm7KcH
	 BOxGmLC7Gi3JXC7U8Y17eb/WDJAYzp5p/SnNFf2ruDPubWHPaVqibB3AHIHc04oV8S9Gc
	 ofH4+fzm0QBLdliiLOGKNMYP2X+3C8ShaKZ3Fl3lw5W+ued272KvfBhYMJ5ZxMLKMZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Y1y72I7Z;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2822D606A31B
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 14:23:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2822D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Y1y72I7Z
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4A8F15A1;
	Tue, 27 Oct 2026 07:23:00 -0700 (PDT)
Received: from e142392.arm.com (e142392.arm.com [10.2.213.23])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7565A3F7B4;
	Tue, 27 Oct 2026 07:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793110984; bh=5oj/0Olu6P0vOlAuhliwwyRovCufR2SAkrdb83vbrEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y1y72I7ZZgHOwDZ52neOkUJTOFHLGM6SpPrLJVlApi2ONKuPpXy5gvo/YDy6bjRdY
	 UjZ8l/7y5kF6noVILXl0H6e+7Nb7KYz93CLjCCr7D1N2FQkJe6kC1ZNYqjb4NZfw1c
	 kqwUht3UItiP8Y9UtMdtZaMB+dEp84ku6EU01etY=
Date: Tue, 27 Oct 2026 14:22:50 +0000
From: Kristina =?utf-8?Q?Mart=C5=A1enko?= <kristina.martsenko@arm.com>
To: Jinqian Yang <yangjinqian1@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-efi@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Linu Cherian <linu.cherian@arm.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Hanjun Guo <guohanjun@huawei.com>, 
	Sudeep Holla <sudeep.holla@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [RFC 00/12] arm64: Add support for TLBI domains
Message-ID: <cs3tsczrky7egqzde6gnsf7l22t53jit3cygtwe56yfeka5ue7@zesz6zptww3v>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
 <9eb6e0fe-5d8a-499c-b19b-ce73fe982451@huawei.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9eb6e0fe-5d8a-499c-b19b-ce73fe982451@huawei.com>

On Mon, Oct 19, 2026 at 04:52:04PM +0800, Jinqian Yang wrote:
> Hi,
> 
> On 2026/10/1 19:06, Kristina Martšenko wrote:
> > Hi,
> > 
> > This series allows the kernel to use TLBI domains. TLBI domains (FEAT_TLBID) is
> > an Arm architecture feature that enables a TLB invalidation to target a subset
> > of CPUs instead of the whole system. It can improve performance on systems with
> > many CPUs. TLBID is not yet part of the Arm Architecture Reference Manual but
> > some of it is described in the latest XML [1].
> > 
> > The goal of this series is to send TLBI commands only to the CPUs where a
> > process has run (i.e. where its page tables have been installed). The last
> > patch explains a bit about how it works. This is an RFC since I'm not familiar
> > with the kernel's TLB/mm code and I'd like feedback on whether the general
> > approach is correct.
> > 
> 
> Thanks for posting this series.
> 
> I'm working on the KVM side of TLBID, and have a series that
> virtualizes TLBI domains for guests. It includes:
> 
>  - per-vCPU vDomain configuration via a new capability and
>    two ioctls
>  - VTLBID_EL2 programming at vCPU load/put, mapping vDomains
>    to physical domains
>  - a guest visible TLBIDIDR_EL1 with virtual domain counts,
>    and conditional exposure of ID_AA64MMFR4_EL1.TLBID
> 
> You mentioned you planned to look at KVM support in your next
> version. Would it be OK for us to post this as an RFC on top
> of your series? :)

Thanks for sharing.

I’m starting to look at KVM support but I’m not working on exposing
domains to guests. I’m looking at if we can track which CPUs a guest has
run on and transparently redirect all of a guest’s TLBIs to a single
domain that contains those CPUs. This could be a fallback in case the
guest is not configured to have virtual domains itself (which your
series enables).

I think there is some overlap between what we’re doing (e.g. configuring
VTLBID), but also lots of separate parts. So no objection from my side,
please feel free to post your series.

Thanks,
Kristina

