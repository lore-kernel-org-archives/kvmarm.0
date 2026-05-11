Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 888933D47DC
	for <kvmarm@lists.linux.dev>; Mon, 11 May 2026 10:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778496011; cv=none; b=gKR4TYOpv5Ywc6lTch0I1wBOIwMckXohgFF157vhuzJOGsFTcB8osO1dgVVDTvrEvadLg+TbXe023ttdQs/ur44sTQtRDAw2Mu9sYbPzOhEPUV5Rt7LHGK6cI4wUG7Lfkc8CSZ9XZhj8GPB+Z/a5kLKRgONoOSlcGkosp6uCNRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778496011; c=relaxed/simple;
	bh=qIBIaoZMw/edt0QBmUc5C+O+459IgUULanpiPn179Hg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IJBopeOJ1vGcII6PWMnAX4teQADpjiPBdlhXBseKc4xDZYa7sjb2L6j+W41snVqeGScxkQIYIjYv/YDL4NdWXHKHUXdoo4/eCOdxecKoaaqIW91RcxI4LxM+UPr8fPZIP/t7GM7PJB5C6GAJBqLJwVow9ujBSMt52hby32Fgbzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AZqdSIPc; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AZqdSIPc"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 75A2E16F2;
	Mon, 11 May 2026 03:40:03 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F384E3F836;
	Mon, 11 May 2026 03:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778496008; bh=qIBIaoZMw/edt0QBmUc5C+O+459IgUULanpiPn179Hg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AZqdSIPcNDUt2vsK0aBBMNGq9ftbYQkLtJzZEzpQyfsNIjrAIFSQvILVMNzfskFEI
	 3FSQiqKU+OjtNIqZZdvzkW0W9FwO3XyBsK96xa0zZ+jH7MmqlpmVwr9Vzdo88s+c3e
	 Y04PU7WiXTlkgUqc0fJH/a8rXBHvUWHvl79a6z4o=
Date: Mon, 11 May 2026 11:40:02 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v10 01/30] arm64/sysreg: Update SMIDR_EL1 to DDI0601
 2025-06
Message-ID: <agGyAvutI1GOCQkI@J2N7QTR9R3.cambridge.arm.com>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-1-43f7683a0fb7@kernel.org>
 <af4ZYVFsbYlEfdOu@J2N7QTR9R3>
 <af6DH_j7pyEm4HyI@sirena.co.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af6DH_j7pyEm4HyI@sirena.co.uk>

On Sat, May 09, 2026 at 09:43:11AM +0900, Mark Brown wrote:
> On Fri, May 08, 2026 at 06:12:01PM +0100, Mark Rutland wrote:
> > On Fri, Mar 06, 2026 at 05:00:53PM +0000, Mark Brown wrote:
> 
> > > Update the definition of SMIDR_EL1 in the sysreg definition to reflect the
> > > information in DD0601 2025-06. This includes somewhat more generic ways of
> > > describing the sharing of SMCUs, more information on supported priorities
> > > and provides additional resolution for describing affinity groups.
> 
> > FWIW, these are all in ARM DDI 0487 M.b:
> 
> >   https://developer.arm.com/documentation/ddi0487/mb/
> 
> > Is anything later in the series going to depend on these fields, or
> > would everything behave correctly with the existing RES0 field
> > definitions?
> 
> We're exposing the affinity fields so there's a build time issue.

What I'm asking is what is the rationale for updating these definitions?
e.g.

* Are we planning to use any of the fields in a specific way in the
  *host*?

* Are we planning to use any of the fields in a specific way in the
  *guest*?

* Is this updated just out of habit?

Knowing the rationale would help with review, even if that rationale is
just "it seemed nice to use the latest".

> > > +Field	55:52	HIP
> 
> > Reading the ARM ARM, HIP is arguably a backwards-incompatible change.
> 
> Yes, I belive people are aware.

Ok. Is that considered a problem, or accepted?

Which people are aware?

> > Do we expect to expose that to VMs, or just hide priorities entirely? I
> > suspect we probably want to require that the guest sees
> > SMIDR_EL1.SMPS==0, and not care about any of that.
> 
> Currently we're not exposing priority support to guests so we don't need
> to worry about it yet.

Do we plan to in future?

Mark.
