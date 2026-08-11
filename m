Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 415A2310784
	for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 16:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786464231; cv=none; b=ag53eCg6ZfyHVFaNPLXiw55nhNa+PfH9jwRfuBqIgKFNM+uqFwzsRJLXbSkMaLMHmpQY8aE3jEXyLIHmthbqf+agJYu2AcQ/NwYVks23sBbFaVD8VKmrrdMegd0emxy5h5WWyIKAzbrSg/TjJEtklj/LULCwA/gW53Y+T7Ykxic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786464231; c=relaxed/simple;
	bh=e7Z+l/mTt+5Pf3Y1BUH3J9fnuA6QlidiOwjauwgkWhw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BZ5Jr/A96Y3Nk+quIQL2WJRJMqTfWzihID9rg9jEKfdEtM9O0TLmzTL/21jBoifRKB+evRx0JzKYgrjwpHggWhfiUXMpD0L4sHp5n0JVss6O2/ASjIvg13utiHqtXMkPl4yXY312aZSC3o8poMpD6PB9xn/3UIV2y9CPL7fRooA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Xxn4tmxR; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Xxn4tmxR"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AAE4D1516;
	Tue, 11 Aug 2026 09:03:44 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D96803F86F;
	Tue, 11 Aug 2026 09:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786464228; bh=e7Z+l/mTt+5Pf3Y1BUH3J9fnuA6QlidiOwjauwgkWhw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xxn4tmxRk8DDeLoDWJgLcSjvqgphcHHVSsLy9W3k5A933OGBP25O9NacR3PR0oDK3
	 ukIq7VgR7qCS4RSCWK4DChBI13S4mlFzVtMR+R0w67k3zZwG691gS+zt/F9N80ybn3
	 y48X7w43mZz/dl4gMIp+oztTAkaA7JJMYvorezEE=
Date: Tue, 11 Aug 2026 17:03:43 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Jack Thomson <jackabt.amazon@gmail.com>, maz@kernel.org,
	oupton@kernel.org, pbonzini@redhat.com, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, shuah@kernel.org,
	corbet@lwn.net, vladimir.murzin@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	isaku.yamahata@intel.com, Jack Thomson <jackabt@amazon.com>
Subject: Re: [PATCH v5 2/5] KVM: arm64: Add pre_fault_memory implementation
Message-ID: <antH38FPSmAZ0nrB@raptor>
References: <20260612162354.73378-1-jackabt.amazon@gmail.com>
 <20260612162354.73378-3-jackabt.amazon@gmail.com>
 <alEXtW7w-rqlNG09@raptor>
 <yq5acxvz4u1i.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5acxvz4u1i.fsf@kernel.org>

Hi Aneesh,

On Mon, Aug 03, 2026 at 11:36:33AM +0530, Aneesh Kumar K.V wrote:
> Alexandru Elisei <alexandru.elisei@arm.com> writes:
> 
> > Hi Jack,
> >
> > On Fri, Jun 12, 2026 at 05:23:50PM +0100, Jack Thomson wrote:
> >> From: Jack Thomson <jackabt@amazon.com>
> 
> ....
> 
> >> +		if (kvm_is_error_hva(hva)) {
> >> +			ret = -EFAULT;
> >> +			goto out;
> >> +		}
> >> +
> >> +		s2fd.hva = hva;
> >> +		ret = user_mem_abort(&s2fd);
> >
> > If is_protected_kvm_enabled(), this function doesn't check if the mapping
> > already exists. user_mem_abort() will call **p**kvm_pgtable_stage2_map()
> > (emphasis is mine) to create the mapping, and pkvm_pgtable_stage2_map() will
> > return -EAGAIN, and keep returning -EAGAIN until the mapping is destroyed, which
> > might be some time away.
> >
> > Same thing happens **without** pKVM, kvm_pgtable_stage2_map() will return
> > -EAGAIN if the mapping exists. But that's not such a big issue, when the
> > user calls KVM_PRE_FAULT_MEMORY on the remaining range
> > kvm_pgtable_get_leaf() will detect the existing mapping. Which you have
> > already taken into consideration judging by the comment, so all good here.
> >
> 
> But both gmem_abort() and user_mem_abort() handle -EAGAIN internally, don't they?

I think you're right, please ignore my comment about an existing mapping with
is_protected_kvm_enabled().

Thanks,
Alex
