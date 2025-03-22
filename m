Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95100AD27
	for <kvmarm@lists.linux.dev>; Sat, 22 Mar 2025 11:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742642726; cv=none; b=g4akldhWYBoGJTJwld6LyWJ2fp8gKPTUOeUTKL6XTZ47s+nb1DuYyPmNQGNBHQpwxw/CVZHJSJRRd7Gg2O/MJ2PZz1WryMDl0ojtTIN5olkTZqsrySgWWajcE1k4/Dn2gEli7cLzlyI1qHWeMddvp2sGxdluo9kGCN1qfVezOk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742642726; c=relaxed/simple;
	bh=tvjwqnEvt6QStVcfy4Rtfr52n68UsZuO9plyfyU7FrA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZWp9xON2+wgDDkfC39vnN4sA/0ZgucMgJSho2mV2Y5HZOHLaFNyaaedGLOfcoByNx3UHyOeNJUVSAJ83kkpTREmTdq3x1lqkOe5nQrFPytA+D5/hgnNCYCK03ZiDFCqIJ5DSw8yHAT0SBrDXqm/cuEf+w8qpv6gATvXgmEAVCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w8tD0vKS; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w8tD0vKS"
Date: Sat, 22 Mar 2025 12:25:02 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742642710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vkm0wuie4+J7Oy46hCMinD5wTVCsPYzKlHvlkij180U=;
	b=w8tD0vKSU1lQJ9NP40XB9yM0wVGnZ6HrC0Eolf/SvvqAyYTx585fgc/mUSp24IVCwCEJfb
	Vp/WCEYtHpAIMZ90MziuFkZJRN3151g4GRn0kALI3aQU4zeLGL5lKmJUuCUI3zmz7bk61e
	FqtAWwc9sypScHd0/FINLxpt3RfZuFU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	eric.auger@redhat.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 4/5] configure: Add --qemu-cpu option
Message-ID: <20250322-f2d94472d7ebc003a54d7a9d@orel>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-6-jean-philippe@linaro.org>
 <Z9wbKfRJ7P0tms6L@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9wbKfRJ7P0tms6L@raptor>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 20, 2025 at 01:42:01PM +0000, Alexandru Elisei wrote:
...
> >  mach=$MACHINE_OVERRIDE
> > -processor=$PROCESSOR_OVERRIDE
> > +qemu_cpu=$QEMU_CPU_OVERRIDE
> 
> The name QEMU_CPU_OVERRIDE makes more sense, but I think this will break
> existing setups where people use PROCESSOR_OVERRIDE to pass a particular
> -cpu value to qemu.
> 
> If I were to guess, the environment variable was added to pass a value to
> -cpu different than what it can be specified with ./configure --processor,
> which is exactly what --qemu-cpu does. But I'll let Drew comment on that.

Yeah, ideally we wouldn't rename environment variables, but I'll cross my
fingers that nobody will notice. Indeed, it was created to avoid needing
to reconfigure for experimenting with different QEMU cpu models, so, even
with --qemu-cpu we'll want something and the renaming here makes sense.

> 
> >  firmware=$FIRMWARE_OVERRIDE
> >  
> > -[ "$PROCESSOR" = "$ARCH" ] && PROCESSOR="max"
> > +[ -z "$QEMU_CPU" ] && QEMU_CPU="max"
> >  : "${mach:=virt}"
> > -: "${processor:=$PROCESSOR}"
> > +: "${qemu_cpu:=$QEMU_CPU}"
> >  : "${firmware:=$FIRMWARE}"
> >  [ "$firmware" ] && firmware="-bios $firmware"
> >  
> > @@ -32,7 +32,7 @@ fi
> >  mach="-machine $mach"
> >  
> >  command="$qemu -nodefaults -nographic -serial mon:stdio"
> > -command+=" $mach $acc $firmware -cpu $processor "
> > +command+=" $mach $acc $firmware -cpu $qemu_cpu "
> >  command="$(migration_cmd) $(timeout_cmd) $command"
> >  
> >  if [ "$UEFI_SHELL_RUN" = "y" ]; then
> > diff --git a/configure b/configure
> > index 5306bad3..d25bd23e 100755
> > --- a/configure
> > +++ b/configure
> > @@ -52,6 +52,7 @@ page_size=
> >  earlycon=
> >  efi=
> >  efi_direct=
> > +qemu_cpu=
> >  
> >  # Enable -Werror by default for git repositories only (i.e. developer builds)
> >  if [ -e "$srcdir"/.git ]; then
> > @@ -69,6 +70,8 @@ usage() {
> >  	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
> >  	                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
> >  	    --processor=PROCESSOR  processor to compile for ($processor)
> > +	    --qemu-cpu=CPU         the CPU model to run on. The default depends on
> > +	                           the configuration, usually it is "host" or "max".
> 
> Nitpick here, would you mind changing this to "The default value depends on
> the host system and the test configuration [..]", to make it clear that it also
> depends on the machine the tests are being run on?

I agree.

Thanks,
drew
