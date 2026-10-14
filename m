Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 156DA515962
	for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 13:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791985571; cv=none; b=tBqj1SI4/tPgkkjjj/iH6KkXrwKbbBepaPiGE1IGKetGrbOyDRZ8qEMlpnNCY4PUQ4MS1/inMOoAXlZAxKBT7G8eGEWo6kcDQp73G3msMVHoV795K/E7vfLlx5AFTQ9T80/hgU/Rq5/4ICK3cM5d4CRLdxv1A9ZyWak7FV1e16Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791985571; c=relaxed/simple;
	bh=0inB59qaRugPpia4kgYwImiOX1wdChUgdWVEES4jPh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S7a5kA/YlWw0YFLh1ZxmNYtgmxW2oMWYU1VQ1mlIciGNorxq6rqgZOtn0w3LKWdMzzYJukuB8ezs1c63ql3jUt1cyIWsx/956dmrDaIufd6lk/RyBOe9VprP/MbqVul9Fi1NMQUbb/gTZPoyjxPKgKbCF/F87b7mZzFLoflvVDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XLyTA9y0; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XLyTA9y0"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF5521570;
	Wed, 14 Oct 2026 06:45:59 -0700 (PDT)
Received: from e142392.arm.com (e142392.arm.com [10.2.213.23])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CD86F3F7B4;
	Wed, 14 Oct 2026 06:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791985563; bh=0inB59qaRugPpia4kgYwImiOX1wdChUgdWVEES4jPh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XLyTA9y0OrLaz8C3GXcl3JnMAXQ66bYK5O8u/HZ7Qq+K8glC8UI7jP2OtzZpk0CP1
	 u7MZF0KLvTL8GIu40bmnzu+cMMY5jFKe+rp5d5i1Hdtd1L1CrPM3DKr2YhtJ+og4Hg
	 UakRwqZPw+lMfKHNXkonF6t9U8YDl3l/FfVySdbQ=
Date: Wed, 14 Oct 2026 14:45:52 +0100
From: Kristina =?utf-8?Q?Mart=C5=A1enko?= <kristina.martsenko@arm.com>
To: Steffen Eiden <seiden@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-efi@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Linu Cherian <linu.cherian@arm.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Hanjun Guo <guohanjun@huawei.com>, 
	Sudeep Holla <sudeep.holla@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [RFC 03/12] KVM: arm64: Hide TLBID from guest sysregs
Message-ID: <t7f3l6ewiyenrvsvh3olhwszis4i4zifue6dvlrpgcry5n5b2q@3z7eminzykqr>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
 <20261001110655.461473-4-kristina.martsenko@arm.com>
 <20261012081254.483793-A-seiden@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261012081254.483793-A-seiden@linux.ibm.com>

On Mon, Oct 12, 2026 at 10:12:54AM +0200, Steffen Eiden wrote:
> On Thu, Oct 01, 2026 at 12:06:46PM +0100, Kristina Martšenko wrote:
> > Don't expose FEAT_TLBID to guests. It wouldn't be useful in the general
> > case since a guest doesn't know which domains exist and its vCPUs can be
> > moved between any physical CPUs.
> > 
> > Try to hide TLBID sysregs and sysreg fields from the guest:
> > 
> >   * Report the feature as not supported in the ID register
> >     ID_AA64MMFR4_EL1.TLBID.
> > 
> >   * Configure the TLBIDIDR_EL1 sysreg to UNDEF via the FGU mechanism.
> >     Sanitize a nested hypervisor's HFGRTR2.nTLBIDIDR.
> > 
> >   * Sanitize a nested hypervisor's HCRX.{VTLBIDEn,VTLBIDOSEn,FNB}.
> > 
> >   * VTLBID{OS}<n>_EL2 registers are VNCR-backed and not exposed to
> >     guests (apart from being able to read/write into the VNCR page) so
> >     no need to handle them in sys_reg_descs or elsewhere.
> > 
> >   * The guest is free to set SCTLR2_EL{1,2}.TLBOSNIS, which shouldn't
> >     matter to KVM.
> >
> 
> What confuse me where a bit that you wrote 'try to hide'.
> For me this indicates that the hiding process may not be successful.
> For me the code looks like it will always succeddin hiding the feature
> from the guest, no? Did I miss anything?

Sorry for the vague wording. You’re right that we always succeed in
hiding the feature. What I meant was that there are some parts of the
feature that we can’t fully hide, because the architecture doesn’t
provide a way to do it.

Accessing a VTLBID register should ideally cause an UNDEF exception
(like on a CPU without TLBID), but guest accesses will go to the VNCR
page instead (which won’t have any effect).

> Same for the next patch.

Executing a TLBIP instruction should also UNDEF, but will succeed. There
is no way to trap it without also trapping TLBI instructions.

Thanks,
Kristina
