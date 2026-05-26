Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A496D248F7C
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 12:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779800112; cv=none; b=Meoj6Cv09CdIzU1nzRvQ9XjBQnmlQKd2fgJxTJB/br0xCBxgVEpluydNweL7aPb97d4d/5Z591IPYBQoUgaLadc+GVMIWBaUFTK4hYpL76Z8jP4uBjR2L/u8Ow7VOg3OMG5KBfAN1L4n6ilP3X7nIhZg8+/+oBrm7aYCAWauv2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779800112; c=relaxed/simple;
	bh=VxSbsncF9vADETy7fhLZoS22+L7DTIEAKMxSb9WtYrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qlqBZd3EW8LSNSZNSnOh4frsxuZaGrrNbahWdQa8GPYhek9jsAVHMUvSgzwf38/uSNlY09MUVbE/NZKBaP9mzB44MzSqWp4ZLeQvVVfCZ9mo4L8jxgxkGORnbsAuG6gRUhQUm8BpU+/9dvzSDaq1QIG6C+lHBo+ZFjN8S4XcFIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fo5a9G0/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fo5a9G0/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 15BC0169C;
	Tue, 26 May 2026 05:55:05 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D1B823F86F;
	Tue, 26 May 2026 05:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779800110; bh=VxSbsncF9vADETy7fhLZoS22+L7DTIEAKMxSb9WtYrM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fo5a9G0/UR1rJmXRW8xYXjhAvtLS2+70sZ6z1sOp/HlSEMk0q9pDFKe5TXJFhEe9p
	 Bus1NUBvRv9ywGtrw5jgFylzEHIQv/5HBa9k1qcjGljFnL/ePc8CNz2C2IXRURJUTt
	 6oHeIDtNLGjpysUwLQableFVV5GxivWDR9z3iuXQ=
Date: Tue, 26 May 2026 13:55:04 +0100
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
Subject: Re: [PATCH v10 04/30] arm64/fpsimd: Determine maximum virtualisable
 SME vector length
Message-ID: <ahWYKJ5zOrnNnAgI@J2N7QTR9R3>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-4-43f7683a0fb7@kernel.org>
 <agGwWE2hcj9O4EGu@J2N7QTR9R3.cambridge.arm.com>
 <agHOvFiI1e3y_ur4@sirena.co.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agHOvFiI1e3y_ur4@sirena.co.uk>

On Mon, May 11, 2026 at 09:42:36PM +0900, Mark Brown wrote:
> On Mon, May 11, 2026 at 11:32:56AM +0100, Mark Rutland wrote:
> > On Fri, Mar 06, 2026 at 05:00:56PM +0000, Mark Brown wrote:
> 
> > > +#define SME_VQ_INVALID	(SME_VQ_MAX + 1)
> 
> > Does using (SME_VQ_MAX + 1) for this make something easier than if we
> > used 0?
> 
> There were checks for VLs less than $THING which were causing annoyance
> IIRC but it should be workable since we shouldn't offer SME to guests if
> the invalid VL comes up.  I'll look again when I'm back from holiday.
> 
> > To solve all of the above, I think what we actually want to do is find
> > the largest uniformly implemented VL which is smaller than the smallest
> > partially implemented VL.
> 
> Yes, that's what we're going for.

To be clear, that was a concrete suggestiong as to the algorithm.

I'm saying we should have code along the lines of:

int find_virtualisable_vl(struct vl_info *info)
{
        DECLARE_BITMAP(partial_only_map, SVE_VQ_MAX);
        unsigned long b_min_partial, m_max_virt;

        bitmap_andnot(partial_only_map, info->va_partial_map, info->vq_map,
                      SVE_VQ_MAX);
        b_min_partial = find_last_bit(partial_only_map, SVE_VQ_MAX);

        /* All implemented VLs are virtualisable */
        if (m_min_partial >= SVE_VQ_MAX)
                return info->max_vl;

        b_max_virt = find_next_bit(info->vq_map, SVE_VQ_MAX, b_min_partial);

        /* No implemented VLs are virtualisable */
        if (b_max_virt >= SVE_VQ_MAX)
                return 0;

	/* At least one virtualisable VL exists */
        return sve_vl_from_vq(__bit_to_vq(b_max_virt));
}

Mark.
