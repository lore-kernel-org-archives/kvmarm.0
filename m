Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD4BF17748
	for <kvmarm@lists.linux.dev>; Mon,  4 Mar 2024 08:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709542732; cv=none; b=a4HWFJOftCX9Ii/SR9pWHMWo9RFVlcXO4vfbdekyoainfXDKus4O+sD8YphmEmCnK6ePj1Z7jcKj6E+q3VOya1+ekJ627DjhjaMTni2WAqxiqDv+7c1xBavXniXArOStg+pQ+eUy01pdtlacu3TGF3/4HWaEpVS3in1on5Wokog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709542732; c=relaxed/simple;
	bh=XJsX7knfQUaj5fBx+J9W2LDGTKouPwiuKQY7UHAv7NM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EQW1mqBVk3uLlBUKj+fWa/stO+gI4S1XJK6jvVcAz5xDCpx4SgcQcVMnGHh9DqSG6Qrbybbuqpg9SkSDvTDyL8ezw+thFeD5wWGrwraXdYOdqedZi+sjmfQL9wXwCEUkCsgN5WGg5uBF8zsWtGS7zg3jqsmSmWav6CEYPuu49ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E1CE1FB;
	Mon,  4 Mar 2024 00:59:26 -0800 (PST)
Received: from [192.168.5.30] (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D39653F762;
	Mon,  4 Mar 2024 00:58:48 -0800 (PST)
Message-ID: <6fa02d80-b02c-4309-b8e7-1116335ebb38@arm.com>
Date: Mon, 4 Mar 2024 08:58:47 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 16/18] arm64: efi: Fix _start returns
 from failed _relocate
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, shahuang@redhat.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-36-andrew.jones@linux.dev>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20240227192109.487402-36-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/02/2024 19:21, Andrew Jones wrote:
> If _relocate fails we need to restore the frame pointer and the link
> register and return from _start. But we've pushed x0 and x1 on below
> the fp and lr, so, as the code was, we'd restore the wrong values.
> Revert parts of the code back to the way they are in gnu-efi and move
> the stack alignment below the loading of x0 and x1, after we've
> confirmed _relocate didn't fail.
> 
> Fixes: d231b539a41f ("arm64: Use code from the gnu-efi when booting with EFI")
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks,

Nikos

> ---
>   arm/efi/crt0-efi-aarch64.S | 25 +++++++++++++------------
>   1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/arm/efi/crt0-efi-aarch64.S b/arm/efi/crt0-efi-aarch64.S
> index 5d0dc04af54a..5fd3dc94dae8 100644
> --- a/arm/efi/crt0-efi-aarch64.S
> +++ b/arm/efi/crt0-efi-aarch64.S
> @@ -111,17 +111,10 @@ section_table:
>   
>   	.align		12
>   _start:
> -	stp		x29, x30, [sp, #-16]!
> -
> -	/* Align sp; this is necessary due to way we store cpu0's thread_info */
> +	stp		x29, x30, [sp, #-32]!
>   	mov		x29, sp
> -	mov		x30, sp
> -	and		x30, x30, #THREAD_MASK
> -	mov		sp, x30
> -	str		x29, [sp, #-16]!
> -
> -	stp		x0, x1, [sp, #-16]!
>   
> +	stp		x0, x1, [sp, #16]
>   	mov		x2, x0
>   	mov		x3, x1
>   	adr		x0, ImageBase
> @@ -130,12 +123,20 @@ _start:
>   	bl		_relocate
>   	cbnz		x0, 0f
>   
> -	ldp		x0, x1, [sp], #16
> +	ldp		x0, x1, [sp, #16]
> +
> +	/* Align sp; this is necessary due to way we store cpu0's thread_info */
> +	mov		x29, sp
> +	mov		x30, sp
> +	and		x30, x30, #THREAD_MASK
> +	mov		sp, x30
> +	str		x29, [sp, #-16]!
> +
>   	bl		efi_main
>   
>   	/* Restore sp */
>   	ldr		x30, [sp], #16
> -	mov             sp, x30
> +	mov		sp, x30
>   
> -0:	ldp		x29, x30, [sp], #16
> +0:	ldp		x29, x30, [sp], #32
>   	ret
