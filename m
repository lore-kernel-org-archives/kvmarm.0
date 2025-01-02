Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43B6A1A9B32
	for <kvmarm@lists.linux.dev>; Thu,  2 Jan 2025 11:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735818347; cv=none; b=ER8aOxv8GBItT7MIs7alSXuMm5RD6gh+Eu6Sm/NBTkT3SnIqq0Cxgkt+OtzinvuxEa6F0JHqicOZ2OWZEKdS9FzD/TsckaJEbb/caCqJd3gmVOih7VcivwoyL8Bpx3mnyjTGrSbq8pHrnseOLRmZWEhxEBtGRnkEQRhdnmtZ46I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735818347; c=relaxed/simple;
	bh=s0UQBnYyW6Ie54Fp8an25ldfagSLW+NuganFN6QY3QA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mvTp+kYA6yNihhYv7YbMe5NLLrIrZdPMx9xHeKmT+uEGZp4gMP7kNWRPAlab1oSRwD7wxMSipLTUe5E/Rz0wZRzkS5ChXVQ2NLWCsEvE+1K3wLnAyFXz85UELJW04bJQPX07S9YvOm/GwasYLQH4h10+hPIiXqK3gEhdTqWI15w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5743111FB;
	Thu,  2 Jan 2025 03:46:12 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2824F3F59E;
	Thu,  2 Jan 2025 03:45:43 -0800 (PST)
Date: Thu, 2 Jan 2025 11:45:40 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: kvmarm@lists.linux.dev, nikos.nikoleris@arm.com, andrew.jones@linux.dev,
	eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2] arm64: Add basic MTE test
Message-ID: <Z3Z8ZHDLATOS1UH3@raptor>
References: <20241212103447.34593-1-vladimir.murzin@arm.com>
 <Z2lRk_NLHxDPvmrS@raptor>
 <0fc53bdf-f919-40b9-8530-d11593ec55f7@arm.com>
 <Z3K6FLG2qfwphAfS@raptor>
 <590394e4-b21f-4ff8-a250-0cbf50adfe38@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <590394e4-b21f-4ff8-a250-0cbf50adfe38@arm.com>

Hi Vladimir,

On Thu, Jan 02, 2025 at 10:04:37AM +0000, Vladimir Murzin wrote:
[..]
> On 12/30/24 15:19, Alexandru Elisei wrote:
> > Hi Vladimir,
> > Interestingly though, when I try to run a test (either with ./run_tests.sh
> > mte-sync, or by trying out your example), I get this error:
> > 
> > qemu-system-aarch64: MTE requested, but not supported by the guest CPU
> > 
> > My guess is that's caused by kvm-unit-tests defaulting to cortex-a57 as the
> > model CPU. Changing the cpu to 'max' makes the test run. How are you getting
> > around this on your end?
> > 
> 
> ./configure --arch=arm64 --processor=max

Ah, so that explains it. Would you mind adding this information to the commit
message, perhaps something like this:

If using TCG as the accelerator, qemu must emulate a CPU that supports MTE
in order for the tests to run. Use configure --processor to set an
appropriate CPU. If unsure about a particular processor, 'max' will most
likely work with a new enough qemu version.

> 
> Thanks
> Vladimir
> 
> > Thanks,
> > Alex
> > 
> 
