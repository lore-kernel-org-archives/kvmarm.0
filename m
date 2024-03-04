Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE44F18EC3
	for <kvmarm@lists.linux.dev>; Mon,  4 Mar 2024 09:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709544946; cv=none; b=F4lE5tSirfq7Xa2E4lYkYjRyBhS3B6FBhT/BoAnhKCVvYnAcPgZv2r+ApNrW5b5OjYGx0iD8uk0MhcdNBPcoCggQtGopwTLNoQOy+EJaFR6+kyWtPDH2jW1I1jcRllv4l1OZmS3UtNMQqfcB8Urvj5MyNqCQIxxAEc3zx3aezxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709544946; c=relaxed/simple;
	bh=TmtoqtCD90+hu5haU1fOtO+gJCHRpT/5xAaKNLdSEDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fSdoB/YVJqz24WEQkY44o5EqZkuI/15VPk0nHoryiEQgGK0nroVXthRYOla4M6F8xVuS1PVHYQ/lOX94BVQkEa/JdYdV8gUr3IeOJwHAvAIbDZsrmxSm8mquaNUJjErfZrPd7u0QBJpNtbu9hMTp0RYBhQHOXd3jY77MrtZkWuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ie+X/buz; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ie+X/buz"
Date: Mon, 4 Mar 2024 10:35:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709544941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OR1BVIVJEjGitG9/qm9PEeUe6YVToGd+KX6pGKDiA5U=;
	b=Ie+X/buzgm477blXLM65wi7mURzs1uEDfuyEqEejQ+122E7kWjiyBCrUFxSoCfFzqEnJHt
	WrWAkm+tlZy0VqjEQw9ChpzCdaZk16ogVFQ2J4DI/z2cKDD4GleB+sd1JbemxpfPwiFumd
	R+CmAkLdAKgvWo+rPNTUcLkktkxgvhw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	eric.auger@redhat.com, shahuang@redhat.com, pbonzini@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 08/18] arm64: efi: Improve device tree
 discovery
Message-ID: <20240304-da434501d4e2e0685e6a954e@orel>
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-28-andrew.jones@linux.dev>
 <df9c5b95-0cc4-4d82-b8d9-603dc069f7de@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df9c5b95-0cc4-4d82-b8d9-603dc069f7de@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 04, 2024 at 07:34:44AM +0000, Nikos Nikoleris wrote:
> On 27/02/2024 19:21, Andrew Jones wrote:
> > Zero is a valid address for the device tree so add an fdt_valid data
> > member to determine when the address is valid or not. Also, check the
> > device tree GUID when the environment variable is missing. The latter
> > change allows directly loading the unit test with QEMU's '-kernel'
> > command line parameter, which is much faster than putting the test
> > in the EFI file system and then running it from the UEFI shell.
> > 
> 
> Out of curiosity, the fdt pointer can be zero just in KUT or zero is an
> address that efi_load_image or efi_get_system_config_table could return?
> Similar code in Linux treats 0 an non valid address https://elixir.bootlin.com/linux/latest/source/drivers/firmware/efi/libstub/fdt.c#L370

Actually, on second thought, it can't be zero. I momentarily forgot that
when we get the fdt pointer from EFI it'll be a virtual address (unlike
when we get it from x0). For v2, I'll drop the fdt_valid since fdt==NULL
is sufficient.

> 
> > Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> 
> In any case, this won't hurt:
> 
> Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks,
drew
