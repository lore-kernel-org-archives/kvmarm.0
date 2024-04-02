Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043CF2AD1E
	for <kvmarm@lists.linux.dev>; Tue,  2 Apr 2024 16:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712077079; cv=none; b=LvaYlJHrBKhjO5c2pN8meKdypIlAJ57p8eNmfnk0tc5mOg6n+XEWO05tDorO2cF9i+8dOIIF3o5kZWltuw1bEkpifvhBI1/U7gXOmFf4PaFp7LLttAbMpbGSWV57inrexb/q2JkSVNlFScupjm4By2yZFj/b4CPviG2wFi2XPqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712077079; c=relaxed/simple;
	bh=tZKktaU4JSCVMM4vi8NfEApuH1tBHCRuMbULedwn7Lk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X9EuvjZOTFGl56zQ4H7Rmcly8uorQwiwIR0vN4F03LJdqrSxLvCX3bRuQECKFQa97xbRU7Chdy04mpDYELoy+KoKiTGxztOwgtnR2sb3dK/x33wbCytBtlulMvzMaT5kjHiHY8k+zJiSvyWO7Ygch0sSkArFxc7xItYoFX1x8NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DnV82zaC; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DnV82zaC"
Date: Tue, 2 Apr 2024 18:57:50 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712077074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kMHXSo95z0umhL7zQYT4soiJN4mtDTx5gM9IPO4Oec4=;
	b=DnV82zaCadblPY9Z+OX+P2KKW5iYd7XyLCYb7C+gVMpDcJIgCoZWRLWePHK8PectMeWnWd
	6GJ5gK36sqSVe9eBFtkrSZW6i0DywgdKvQ3XDBD3yzaqjLW/f1vfYmOd+BWYdzyiSpOCk0
	QysXaL+j4HfavDyOQjJ1uu/rldx6eiA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, 
	nikos.nikoleris@arm.com, shahuang@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 0/2] arm/arm64: Use 'max' cpu and gic
 types
Message-ID: <20240402-ef9dd0d5f92689db7e704d8c@orel>
References: <20240402132739.201939-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402132739.201939-5-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 02, 2024 at 03:27:40PM +0200, Andrew Jones wrote:
> The arm64 'max' CPU type enables all features, so it makes sense to use
> it for testing to ensure we're testing the latest models. The 'max' GIC
> is used to pick the latest GIC model by default which is better than
> defaulting to gicv2 since it tests a later model and, when more
> than 8 CPUs are configured, it'll actually work. We don't need to
> convert 'max' to 'host' with KVM/HVF since 'max' is an alias for
> 'host' when those accelerators are enabled.
> 
> v2:
>  - Forgot to test with efi on v1 and testing now found an issue.
>    Add a patch to allow '-cpu max', which has LPA2, to work with efi.
> 
> Andrew Jones (3):
>   arm64: Prepare for LPA2
>   arm/arm64: Use 'max' gic type
>   arm64: Use 'max' cpu type
> 
>  arm/run                   |  8 +------
>  configure                 |  2 +-
>  lib/arm64/asm/processor.h | 49 +++++++++++++++++++++------------------
>  3 files changed, 29 insertions(+), 30 deletions(-)
> 
> -- 
> 2.44.0
>

I see our gitlab CI is failing for a branch with these patches. That's
because the QEMU used is pretty old on the CI and it doesn't have
commit 312b71abce30 ("target/arm: Limit LPA2 effective output address
when TCR.DS == 0"). I either need to force the CI to use 'cortex-a57',
like it always did before (and would be similar to how I've forced
riscv to use 'rv64'), or we should update the CI to use a later QEMU.

Thanks,
drew
