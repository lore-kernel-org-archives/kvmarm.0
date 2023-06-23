Received: from out-29.mta0.migadu.com (out-29.mta0.migadu.com [91.218.175.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9714D2E9
	for <kvmarm@lists.linux.dev>; Fri, 23 Jun 2023 15:38:21 +0000 (UTC)
Date: Fri, 23 Jun 2023 17:38:18 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687534700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ai1KH5TyFx0cLWkh3VdW0Whwq7iBoKMkwkfJ/cBlQtU=;
	b=hLqd+sPYgTHWlcVfeB9/W6M2NfZSLz/UK7Bb7pEaBNjoBCr24uTI5Thl0YvrSB6Ks6EHRW
	RdpRZjSoQnQGg/veMV51rMCCmmQjREpDzCpj/YlbxYbbGq9VzY4lfi6L1MVTAsTZGS5alB
	+hPMercGGyeF8ycmxMpLDjLXRVqW3fc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Thomas Huth <thuth@redhat.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] arm/flat.lds: Specify program headers
 with flags to avoid linker warnings
Message-ID: <20230623-1c78966b728c5abb3922bbdf@orel>
References: <20230623130528.483909-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230623130528.483909-1-thuth@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 23, 2023 at 03:05:28PM +0200, Thomas Huth wrote:
> With ld from binutils v2.40 I currently get warning messages like this:
> 
>  ld: warning: arm/spinlock-test.elf has a LOAD segment with RWX permissions
>  ld: warning: arm/selftest.elf has a LOAD segment with RWX permissions
>  ld: warning: arm/pci-test.elf has a LOAD segment with RWX permissions
>  ld: warning: arm/pmu.elf has a LOAD segment with RWX permissions
>  ...
> 
> Seems like these can be silenced by explicitly specifying the program
> headers with the appropriate flags (like we did in commit 0a06949aafac4a4
> on x86 and in commit 5126732d73aa75 on powerpc already).
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  arm/flat.lds | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arm/flat.lds b/arm/flat.lds
> index 47fcb649..f722c650 100644
> --- a/arm/flat.lds
> +++ b/arm/flat.lds
> @@ -22,10 +22,16 @@
>   *    +----------------------+   <-- physical address 0x0
>   */
>  
> +PHDRS
> +{
> +    text PT_LOAD FLAGS(5);
> +    data PT_LOAD FLAGS(6);
> +}
> +
>  SECTIONS
>  {
>      PROVIDE(_text = .);
> -    .text : { *(.init) *(.text) *(.text.*) }
> +    .text : { *(.init) *(.text) *(.text.*) } :text
>      . = ALIGN(64K);
>      PROVIDE(etext = .);
>  
> @@ -39,8 +45,8 @@ SECTIONS
>      .got      : { *(.got) *(.got.plt) }
>      .eh_frame : { *(.eh_frame) }
>  
> -    .rodata   : { *(.rodata*) }
> -    .data     : { *(.data) }
> +    .rodata   : { *(.rodata*) } :data
> +    .data     : { *(.data) } :data
>      . = ALIGN(16);
>      PROVIDE(bss = .);
>      .bss      : { *(.bss) }
> -- 
> 2.39.3
>

Applied to arm/queue

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew
