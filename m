Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7814A595754;
	Wed, 16 Sep 2026 16:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789577802; cv=none; b=aUTGajJQi5pLItIdt3n9cIoxqT89SKRbtyIR13mu1fMGgv0WhjZJNMxrXzrGjbRQEITMmAbTQ+CgylRWdAJ2a0jsj29S7ejzyAzlDR+VffhZgFg9sfTQRkvx4sG0kCFwR/M1DdsN35DrRjw5dOLuBg6q70uvuOHWOgyAeVMwzLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789577802; c=relaxed/simple;
	bh=9fSY0YtZszmnwmnH72T2AXZffe4pzVRSX07T/e91g2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pFAVUURrwCO9+bDAFhqxlW2gQHh5AQcEiw4xMGvHm5EOfge9RpDxuTcX9YukJCLgDIyTRMltaFRq9iiU75moJtYnfKJd7P2AqvriIm9aK8ijp0il9RH4juJgCfWbzKB4KKZ30qS0jmmf18J/8cxo74Ww2XNEtcJSbM8jATeljJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Vef64xh9; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Vef64xh9"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 386EA1476;
	Wed, 16 Sep 2026 09:56:33 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AE4803FAA1;
	Wed, 16 Sep 2026 09:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789577796; bh=9fSY0YtZszmnwmnH72T2AXZffe4pzVRSX07T/e91g2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vef64xh9KpWL2pmX8x3XXeNP4dknBKucoXLhzKgP8teEasVYgR9XZfcGfJUzoKvj4
	 i0/ODhioxM1eIhQIAitKxdZrFXMdEimBOUh2fwKYciRlYZdBxTX72iTZbsWkTBen4V
	 tdy5aVDJnMqpujftXrCqeSXXJH5WsRVooO60ju9U=
Date: Wed, 16 Sep 2026 17:56:30 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	will@kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
Subject: Re: [PATCH v18] arm64: mm: Handle Granule Protection Faults (GPFs)
Message-ID: <aqrKPkMPeHdtCVGg@arm.com>
References: <20260913070459.2547407-1-suzuki.poulose@arm.com>
 <aqrGPK0lFBFXL2qY@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqrGPK0lFBFXL2qY@arm.com>

On Wed, Sep 16, 2026 at 05:39:31PM +0100, Catalin Marinas wrote:
> On Sun, Sep 13, 2026 at 08:04:58AM +0100, Suzuki K Poulose wrote:
> > +static int do_gpf(unsigned long far, unsigned long esr, struct pt_regs *regs)
> > +{
> > +	if (!user_mode(regs) && !is_el1_instruction_abort(esr) &&
> > +	    fixup_exception(regs, esr))
> > +		return 0;
> > +
> > +	return 1;
> > +}
> 
> We discussed briefly offline. With the latest patches around, would we
> ever end up with private memory mapped in the VMM and hence the GPF? If
> not, I would still keep this handling but add a
> WARN_ON_ONCE(user_mode(regs)).

Actually, even better:

	WARN_ON_ONCE(is_ttbr0_addr(untagged_addr(far)));

to capture uaccess. The user_mode() test you have above can stay the
same.

-- 
Catalin
