Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89514201024
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 09:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080722; cv=none; b=pKzQ6dHtXaGajQaUKFHH2M602bPlW7cD3PI2IxNrUl1lFRKJi2OdLCl14wecvl2btkJqIV0yCLlCjh5ANlVWAbugdFbZEi2qDQZt0ACzlVxD/LOoqEdQro2h/uShg99zjlIviSXzd85jqlQCdvx0zOjxil1hlUE8GJ0vgqhEI2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080722; c=relaxed/simple;
	bh=IDjvk94rKZybQAlhAUWNC+KfSiGavH/5iMMsf+FGg0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KditSEcExSt/cmLOi5+gPgfsaKUsVQOXAunusspWnWxfUbo/AYu6Q46qw16coDDNIV37sxMs6v456ssUWjrfDgxPlH/EZJlIeS+r3gf0RzU4nMj1Y4SWpF7yajwCSDj3X+wgzqCvFbXeIDBaxoAzQmZmh5JOxPwFNdhxO0vv/1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T6gtLt1Q; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T6gtLt1Q"
Date: Tue, 4 Mar 2025 10:31:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741080717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p2F44jkdAl5d6Y7W7SiN0NSgO/b81SC9eWu/a3vDhv8=;
	b=T6gtLt1QOFeEE+xiGaE5fT9BfkFnXkZjtrFCpSRIz5I+0Kbjbwr+M403yWzs0UdhcFYNYn
	+jNkPtjr2ZPefO3qneSJblMV0G3yuxYulb7MdKorexIth3k+ZEKBVmVmIXxyTXE+tcs5As
	+snjIIVds315bfFuOpuW0SFaw22nYnQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, atishp@rivosinc.com, 
	cleger@rivosinc.com, pbonzini@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH 0/2] riscv: Run with other QEMU models
Message-ID: <20250304-47806ddca2d868f97d63de6b@orel>
References: <20250221162753.126290-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250221162753.126290-4-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 21, 2025 at 05:27:54PM +0100, Andrew Jones wrote:
> Provide a couple patches allowing a QEMU machine model other than 'virt'
> to be used. We just need to be able to override 'virt' in the command
> line and it's also nice to be able to specify a different UART address
> for any early (pre DT parsing) outputs. 
> 
> Andrew Jones (2):
>   configure: Allow earlycon for all architectures
>   riscv: Introduce MACHINE_OVERRIDE
> 
>  configure | 88 +++++++++++++++++++++++++++----------------------------
>  riscv/run |  6 ++--
>  2 files changed, 47 insertions(+), 47 deletions(-)
> 
> -- 
> 2.48.1

Merged.

Thanks,
drew
