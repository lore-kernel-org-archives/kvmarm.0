Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484DB2FC881
	for <kvmarm@lists.linux.dev>; Thu, 13 Nov 2025 18:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763058118; cv=none; b=TBnD8QQYgCBTJw1BCCuwUiZb08cILTUZ7wKU85CDUQy/0Yf2U9GWQKGJCGhvGGXqnb6PlXE5WFEYYoFQzFsSZBkVA65PO4YefuK34ydmt6rsav8X9tX23TMCzVAZn+UO7AoVr6oPgNWPHnbvFH4hr+/GXG3GbK4pMPf7J481/CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763058118; c=relaxed/simple;
	bh=M1YRC3EZuqhEa+vddm/0lZ0BSjtWI8L6D1eAzYbvdV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UWXofv4B45+EHvs5+jKQkXz7sc+gDCn29hAa6IMI7Mpqn6ouHyeNcfuHwN/pv5ESFI8q/NqX6er2R71ZhM86DKITBryFzLfbXex9JyxayJzOUvgKwvUBMUkQM7ppzAyEgOE9YkxELb0U+i1tmN+4OWeDOzx2pGG4IfioBPlgF0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KYaFV0zd; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KYaFV0zd"
Date: Thu, 13 Nov 2025 10:21:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763058114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NUDmGsLuzt7y0qWak8NiOpLtPu0rSZCLo1L1cHvQHAU=;
	b=KYaFV0zdSrAsy3+bs3d+Njo5HH7l5LDFC+vVwJNgeam5lFDlKGiqBaEIq/Pop6uDctz6CU
	K0dpQsv9myUU67EubhxWDnd2mb53KLfuGzpRQG4ohGsdzYHYWBxrjKy/RUU++EuOdUrsuF
	dh8lf+UmmKCYpFgOfbnxuQ8tAnSn+/U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Jiaqi Yan <jiaqiyan@google.com>, Jason Gunthorpe <jgg@nvidia.com>,
	maz@kernel.org, duenwen@google.com, rananta@google.com,
	jthoughton@google.com, vsethi@nvidia.com, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com,
	corbet@lwn.net, shuah@kernel.org, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 0/3] VMM can handle guest SEA via KVM_EXIT_ARM_SEA
Message-ID: <aRYhrmLz__AbnCFN@linux.dev>
References: <20251013185903.1372553-1-jiaqiyan@google.com>
 <20251020144646.GT316284@nvidia.com>
 <CACw3F528D6odL3MJWb28Y4HVOLo56tMQXBpvti5nhczdpMxOdQ@mail.gmail.com>
 <wuuvrqxezybzdnijarlom4wvxlfgzgjoakwt7ixittz2jb4mal@ngjvq2rrt2ps>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <wuuvrqxezybzdnijarlom4wvxlfgzgjoakwt7ixittz2jb4mal@ngjvq2rrt2ps>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 13, 2025 at 02:54:33PM +0100, Mauro Carvalho Chehab wrote:
> Hi,
> 
> On Mon, Nov 10, 2025 at 09:41:33AM -0800, Jiaqi Yan wrote:
> > On Mon, Oct 20, 2025 at 7:46 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > On Mon, Oct 13, 2025 at 06:59:00PM +0000, Jiaqi Yan wrote:
> > > > Problem
> > > > =======
> > > >
> > > > When host APEI is unable to claim a synchronous external abort (SEA)
> > > > during guest abort, today KVM directly injects an asynchronous SError
> > > > into the VCPU then resumes it. The injected SError usually results in
> > > > unpleasant guest kernel panic.
> > > >
> > > > One of the major situation of guest SEA is when VCPU consumes recoverable
> > > > uncorrected memory error (UER), which is not uncommon at all in modern
> > > > datacenter servers with large amounts of physical memory. Although SError
> > > > and guest panic is sufficient to stop the propagation of corrupted memory,
> > > > there is room to recover from an UER in a more graceful manner.
> > > >
> > > > Proposed Solution
> > > > =================
> > > >
> > > > The idea is, we can replay the SEA to the faulting VCPU. If the memory
> > > > error consumption or the fault that cause SEA is not from guest kernel,
> > > > the blast radius can be limited to the poison-consuming guest process,
> > > > while the VM can keep running.
> 
> I like the idea of having a "guest-first"/"host-first" approach for APEI,
> letting userspace (likely rasdaemon) to decide to handle hardware errors
> either at the guest or at the host. Yet, it sounds wrong to have a flag
> called KVM_EXIT_ARM_SEA, as:
> 
>     1. This is not exclusive to ARM;
>     2. There are other notification mechanisms that can rise an APEI
>        errors. For instance QEMU code defines:
> 
>     ACPI_GHES_NOTIFY_POLLED = 0,
>     ACPI_GHES_NOTIFY_EXTERNAL = 1,
>     ACPI_GHES_NOTIFY_LOCAL = 2,
>     ACPI_GHES_NOTIFY_SCI = 3,
>     ACPI_GHES_NOTIFY_NMI = 4,
>     ACPI_GHES_NOTIFY_CMCI = 5,
>     ACPI_GHES_NOTIFY_MCE = 6,
>     ACPI_GHES_NOTIFY_GPIO = 7,
>     ACPI_GHES_NOTIFY_SEA = 8,
>     ACPI_GHES_NOTIFY_SEI = 9,
>     ACPI_GHES_NOTIFY_GSIV = 10,
>     ACPI_GHES_NOTIFY_SDEI = 11,
>     ACPI_GHES_NOTIFY_RESERVED = 12
> 
>  - even on arm. QEMU currently implements two mechanisms (SEA and GPIO);
>  - once we implement the same feature on Intel, it will likely use
>    NMI, MCE and/or SCI.
> 
> So, IMO, the best would be to use a more generic name like
> KVM_EXIT_APEI or KVM_EXIT_GHES - or maybe even name it the way it really
> is meant: KVM_EXIT_ACPI_GUEST_FIRST.

This is not the sort of thing that I'd like to seen dressed up as an
arch-generic interface.

What Jiaqi is dealing with is the very sorry state of RAS on arm64,
giving userspace the opportunity to decide how an SEA is handled when a
platform's firmware couldn't be bothered to do so. The SEA is an
architecture-specific event so we provide the hardware context to
the VMM to sort things out.

If the APEI driver actually registers to handle the SEA then it will
continue to handle the SEA before ever involving the VMM. I'm not
aware of any system that does this. If you're lucky you'll take an
*asynchronous* vector after to process a CPER and still have to deal
with a 'bare' SEA.

And of course, none of this even matters for the several billion
DT-based hosts out in the wild.

Thanks,
Oliver
