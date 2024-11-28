Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE711B85C2
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 16:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732809996; cv=none; b=HRk0CKyasoJRuAlClJfLarCwUEGRuSuUGf6DGN69FOC0KGr0PAdz9LEN7hQ9mKZE5x2WKHD/4k5/F+Jc/MNnPESTZg8BsWnbTwrb0Qrdf7/lL75JK2LH8yfG2Dfe1v2NC5CO1QRz+uv+ml4gdb1dx4vMeM6q5AMxSJ0MAXgJNVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732809996; c=relaxed/simple;
	bh=Ir3JTo7TVjNjbRH3Tk0vjrvyaT/4J1kJDtTnrFc4Z/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOihd7cwXXlD/Nnb09ne1TejWtqCgGJwb2Dmuv5EVKWz/W0Th8xsAN3caYnlmN3gtQf2LQjQsNDrsnXIDw2Ru6NyUbAKVYDZbSWkGnupP5EaUzW5tfvKFyVnvzRTMAABEPIWL+3rfoAnJIIRI6VapqGpSf4zeWmP+t5U6o6Y72o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=H3uEE9o8; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="H3uEE9o8"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-382423e1f7aso646337f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 08:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1732809992; x=1733414792; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SE3hqx8PlRH6oR2vsIt6C8nLef92GwCrM14lVm2xh9k=;
        b=H3uEE9o8S4zWK5xjG6gFhCDZbkcm5iuTQDZ/lztLzb5WKj+EzcFuNtR//I7AfPQrbC
         8V0BPHXzsQVOJzFd9LfIqcykkmcgWCWntVrzW4DdpnQKeaA2JPPDOcvRgmTLbbrhxd8n
         9joEgwS1T4ymHfPo9O3Oos4W9jIfojEW3kd8+WhAVYpu+a2fa1cW9R4Sem8761P/vycU
         BD+o5FWxwfEoG8gehCy0Wt7g8kmbrXD1C3ge2ZQIiMbtS89WQL+3roISwpdIQkK7u7bx
         WZVRl3+eCaeSlyMsnCQAU6BLmTwVfZD7W3BiOCHSLtDJuT3mqDUX2Q2451ttIJdMjO+A
         sLsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732809992; x=1733414792;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SE3hqx8PlRH6oR2vsIt6C8nLef92GwCrM14lVm2xh9k=;
        b=tYycdtxDjYq5ZIQmp63gqLOdGwb9/h9wgyLAISXeuy+Zjtlv8KOBZmThJJwI9wEPdN
         B3hbwmR8/zMkkk2ofEknJ+dhSRIFE1M31CTwGG9u+qbJs6um03K26rpQw9vr7Ee3t5Q/
         tVP3uU+2t+2HAlEP3X2ndt+PDUASVdSV8FgckXNIuBjzsn8OdOaxzONVTjNc/kaV/vG4
         nwN8osYT6pFO+7lhpHzFsvVEdQ9akBu0+iN10B02OaDbDgu7wCJf0cBEKxrOPlh7utU+
         TF+ql36mtdjv0sn9zULErCHsHMv+SHTsW6ZC0ojgp0l4NovUiaENXDfSqLcyobcrT+Sr
         I5jg==
X-Forwarded-Encrypted: i=1; AJvYcCUk3t+8Sj4o0nK16jASehWLdHzNT/QEq78mQYpb43bLqJpsCJS+aFiJOosSIVeN1NRoL1GhZkY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3J0nxjtfokU6OTo5d3ze1jvbUkXConDzSVxkTzDGafsRkbt57
	umm+x+0UDEyEptp9rUkoxgbpcaFptm0LdHcPSl2hpJH1EjvWEDhyzLu80wht+Vg=
X-Gm-Gg: ASbGncteuXG0HBbUTOw8E+29l2rpbRmCNp5d3+m/eEz1rt2nRks1k+eJMza+qwhE3vd
	XeLWAJuKi1BokDO253zIP8PjCD4qCpo/1KTcyIeLsBaqvpa6yu7Sphdb1Cc6nVEAI1S7/m94Hvp
	RgWKnrSzFc9+FWJc+ddaUkN3HkxXn5fkxugjApdJb4hFRXJjQrOUSR9trp1Htoa4btXvenMbuOC
	Cfvn+iB4lLobopowZKZkSO+Ra06+v81vHxhvLA0GL7XVs74aQKJf2itIWp7ohH1BMsVAvLtLEtK
	sMe7iaugTyJCkJFN9Gkrc+dJqd7qdAceU8k=
X-Google-Smtp-Source: AGHT+IFG7K7Tcmhw/SgqiyfLkjWGDpN72liep7NaizvY+BomgXIHH7qnDKDhB0LbxLbY9up/D3Z4OQ==
X-Received: by 2002:a05:6000:42ca:b0:382:503f:a323 with SMTP id ffacd0b85a97d-385c6ebaa70mr4267236f8f.19.1732809992314;
        Thu, 28 Nov 2024 08:06:32 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-385ccd2dad8sm1975016f8f.18.2024.11.28.08.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2024 08:06:31 -0800 (PST)
Date: Thu, 28 Nov 2024 17:06:31 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev, 
	apatel@ventanamicro.com, andre.przywara@arm.com, suzuki.poulose@arm.com, 
	s.abdollahi22@imperial.ac.uk
Subject: Re: [PATCH kvmtool 2/4] arm: Check return value for
 host_to_guest_flat()
Message-ID: <20241128-7f4e0ab75188ff4684785d2b@orel>
References: <20241128151246.10858-1-alexandru.elisei@arm.com>
 <20241128151246.10858-3-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241128151246.10858-3-alexandru.elisei@arm.com>

On Thu, Nov 28, 2024 at 03:12:44PM +0000, Alexandru Elisei wrote:
> kvmtool, on arm and arm64, puts the kernel, DTB and initrd (if present) in
> a 256MB memory region that starts at the bottom of RAM.
> kvm__arch_load_kernel_image() copies the kernel at the start of RAM, the
> DTB is placed at the top of the region, and immediately below it the
> initrd.
> 
> When the initrd is specified by the user, kvmtool checks that it doesn't
> overlap with the kernel by computing the start address in the host's
> address space:
> 
> 	fstat(fd_initrd, &sb);
> 	pos = pos - (sb.st_size + INITRD_ALIGN);
> 	guest_addr = ALIGN(host_to_guest_flat(kvm, pos), INITRD_ALIGN); (a)
> 	pos = guest_flat_to_host(kvm, guest_addr); (b)
> 
> If the initrd is large enough to completely overwrite the kernel and start
> below the guest RAM (pos < kvm->ram_start), then kvmtool will omit the
> following errors:
> 
>   Warning: unable to translate host address 0xfffe849ffffc to guest (1)
>   Warning: unable to translate guest address 0x0 to host (2)
>   Fatal: initrd overlaps with kernel image. (3)
> 
> (1) is because (a) calls host_to_guest_flat(kvm, pos) with a 'pos'
> outside any of the memslots.
> 
> (2) is because guest_flat_to_host() is called at (b) with guest_addr=0,
> which is what host_to_guest_flat() returns if the supplied address is not
> found in any of the memslots. This warning is eliminated by this patch.
> 
> And finally, (3) is the most useful message, because it tells the user what
> the error is.
> 
> The issue is a more general pattern in kvm__arch_load_kernel_image():
> kvmtool doesn't check if host_to_guest_flat() returns 0, which means that
> the host address is not within any of the memslots. Add a check for that,
> which will at the very least remove the second warning.
> 
> This also fixes the following edge cases:
> 
> 1. The same warnings being emitted in a similar scenario with the DTB, when
> the RAM is smaller than FDT_MAX_SIZE + FDT_ALIGN.
> 
> 2. When copying the kernel, if the RAM size is smaller than the kernel
> offset, the start of the kernel (represented by the variable 'pos') will be
> outside the VA space allocated for the guest RAM.  limit - pos will wrap
> around, because gcc 14.1.1 wraps the pointers (void pointer arithmetic is
> undefined in C99). Then read_file()->..->read() will return -EFAULT because
> the destination address is unallocated (as per man 2 read, also reproduced
> during testing).
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/kvm.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/kvm.c b/arm/kvm.c
> index da0430c40c36..4beae69e1fb3 100644
> --- a/arm/kvm.c
> +++ b/arm/kvm.c
> @@ -113,6 +113,8 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
>  
>  	pos = kvm->ram_start + kvm__arch_get_kern_offset(kvm, fd_kernel);
>  	kvm->arch.kern_guest_start = host_to_guest_flat(kvm, pos);
> +	if (!kvm->arch.kern_guest_start)
> +			die("guest memory too small to contain the kernel");

Just doing a quick drive-by and noticed this indentation issue.

Thanks,
drew

>  	file_size = read_file(fd_kernel, pos, limit - pos);
>  	if (file_size < 0) {
>  		if (errno == ENOMEM)
> @@ -131,7 +133,10 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
>  	 */
>  	pos = limit;
>  	pos -= (FDT_MAX_SIZE + FDT_ALIGN);
> -	guest_addr = ALIGN(host_to_guest_flat(kvm, pos), FDT_ALIGN);
> +	guest_addr = host_to_guest_flat(kvm, pos);
> +	if (!guest_addr)
> +		die("fdt too big to contain in guest memory");
> +	guest_addr = ALIGN(guest_addr, FDT_ALIGN);
>  	pos = guest_flat_to_host(kvm, guest_addr);
>  	if (pos < kernel_end)
>  		die("fdt overlaps with kernel image.");
> @@ -151,7 +156,10 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
>  			die_perror("fstat");
>  
>  		pos -= (sb.st_size + INITRD_ALIGN);
> -		guest_addr = ALIGN(host_to_guest_flat(kvm, pos), INITRD_ALIGN);
> +		guest_addr = host_to_guest_flat(kvm, pos);
> +		if (!guest_addr)
> +			die("initrd too big to fit in the payload memory region");
> +		guest_addr = ALIGN(guest_addr, INITRD_ALIGN);
>  		pos = guest_flat_to_host(kvm, guest_addr);
>  		if (pos < kernel_end)
>  			die("initrd overlaps with kernel image.");
> -- 
> 2.47.0
> 
