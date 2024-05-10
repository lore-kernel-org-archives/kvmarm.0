Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F7CD224FD
	for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 18:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715364580; cv=none; b=KDq8P0o3Vp88ql4as39NJ35nnWFNJ22cxp9tbwz26rLrPmFQfL9nczOog7v8lyEQMQWf6q38WR3CcOYz3qkSd845QTzW+qsrFjQL9pOFZzracY49e1gdP+Gorkrio57+fWlY19f4xdHfcOYd69XfcJbqG4WQWz4LocoJD+aJEYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715364580; c=relaxed/simple;
	bh=qktXfpT7DJT7vb3bkZbzY0J0anO5j1oOyntxnZGeHh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TIpcCzUuhBlil3ocvhsEvR54dVMGF0olAAGMdkWu6t3PQiPxoDvQ3D32hOLZs9dCu+UhZ4gfRLhhg5bDM6omuCMVz3+sDV4ioKe78lk5jMv4vB+2NBq+XC+zFMx/J4olIHSGE8UG6NU+t5rkvgGkw47AS5cyZqqTpw1SsMSMPYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B18B150C;
	Fri, 10 May 2024 11:10:04 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 789A33F6A8;
	Fri, 10 May 2024 11:09:37 -0700 (PDT)
Date: Fri, 10 May 2024 19:09:31 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Replace custom macros with fields from
 ID_AA64PFR0_EL1
Message-ID: <Zj5i2x8Sh95YIfeq@J2N7QTR9R3>
References: <20240418053804.2573071-1-anshuman.khandual@arm.com>
 <20240418053804.2573071-2-anshuman.khandual@arm.com>
 <871q73rufi.wl-maz@kernel.org>
 <ab6466f2-023e-4b5f-bb60-aadb9eee089a@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab6466f2-023e-4b5f-bb60-aadb9eee089a@arm.com>

On Mon, Apr 29, 2024 at 07:53:14AM +0530, Anshuman Khandual wrote:
> On 4/18/24 13:09, Marc Zyngier wrote:
> > On Thu, 18 Apr 2024 06:38:03 +0100,
> > Anshuman Khandual <anshuman.khandual@arm.com> wrote:
> >>  #define PVM_ID_AA64PFR0_RESTRICT_UNSIGNED (\
> >> -	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
> >> -	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL1), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
> >> -	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL2), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
> >> -	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL3), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
> >> +	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0), ID_AA64PFR0_EL1_EL0_IMP) | \
> >> +	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL1), ID_AA64PFR0_EL1_EL1_IMP) | \
> >> +	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL2), ID_AA64PFR0_EL1_EL2_IMP) | \
> >> +	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL3), ID_AA64PFR0_EL1_EL3_IMP) | \
> > 
> > If you are going to rework this, can we instead use something less
> > verbose such as SYS_FIELD_GET()?
> 
> Just wondering, is not FIELD_PREP() and SYS_FIELD_GET() does the exact opposite thing.
> The earlier builds the entire register value from various constituents, where as the
> later extracts a single register field from a complete register value instead. Or did
> I just misunderstood something here.
 
He means use one of the SYS_FIELD_*() helpers, e.g. SYS_FIELD_PREP_ENUM(), with
which this can be:

#define PVM_ID_AA64PFR0_RESTRICT_UNSIGNED (\
        SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, EL0, IMP) | \
        SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, EL1, IMP) | \
        SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, EL2, IMP) | \
        SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, EL3, IMP) | \
        SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, RAS, IMP) \
        )

... which is far less verbose, and much easier to read.

Mark.
