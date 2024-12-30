Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD1A1A83E6
	for <kvmarm@lists.linux.dev>; Mon, 30 Dec 2024 15:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573510; cv=none; b=jNR4IodY7yNVhXHhY5/kl/YqTT3MxAn/qlbnbicvg/6/FJsOYF9un7ejs+fAwl8IBQIXCM2+16csV6/HaIxIawdZI2iCAeDOxyX85BVaBAvT5osldVmGSSjSiIbToQAcBM0Lvh/yrbuCGKWbn84zTMTcz5kcIyNjo4L47xjK2Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573510; c=relaxed/simple;
	bh=Ep9Zl/pc401o6yHUWJbfwRZBNbPR7NMQ2qyTe8z4hDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kRWGkogHmxk/uGlAosI+wwuFlxeZMy6QWNkE3os8/BEmt3dWz62M08GNrwac0gp4y/dh9Z8s6700mUBTLqtVoicr/VrRte/gpfJqnyv0ATfkEyDFnWowAatfnMiDAdYwIRvRAYe0BAFI8bknC2mTB+NZjNKaDEXNZH5FM/Jnvbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mFmXcj5I; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mFmXcj5I"
Date: Mon, 30 Dec 2024 16:45:01 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735573505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v1KNDKFUS9H2n8i6mTT0ywvBnDtCIoTQVTnvvPJAxdM=;
	b=mFmXcj5IsCCm8+IzFCpRFHELsM7Q9EyfkihBQqUp3pxMWfJsFyiReV/kaDcHJUXJSiRpD6
	IpZCa9RGxp5klaZsZiDuOY2cWmhcwK0LUNjOXBUvS+Ch7h223bDzZI8sn3UooFqk7DN32U
	tbFiSdRyjs6HSEgLUpgiGaTm1APP0qc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.linux.dev, 
	nikos.nikoleris@arm.com, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2] arm64: Add basic MTE test
Message-ID: <20241230-3c7d660ca38c9b390ec74b01@orel>
References: <20241212103447.34593-1-vladimir.murzin@arm.com>
 <Z2lRk_NLHxDPvmrS@raptor>
 <0fc53bdf-f919-40b9-8530-d11593ec55f7@arm.com>
 <Z3K6FLG2qfwphAfS@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z3K6FLG2qfwphAfS@raptor>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 30, 2024 at 03:19:48PM +0000, Alexandru Elisei wrote:
...
> Interestingly though, when I try to run a test (either with ./run_tests.sh
> mte-sync, or by trying out your example), I get this error:
> 
> qemu-system-aarch64: MTE requested, but not supported by the guest CPU
> 
> My guess is that's caused by kvm-unit-tests defaulting to cortex-a57 as the
> model CPU. Changing the cpu to 'max' makes the test run. How are you getting
> around this on your end?
>

We can (and I think should) change to 'max' for the default model.

Thanks,
drew
