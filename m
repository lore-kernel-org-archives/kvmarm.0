Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079521F4727
	for <kvmarm@lists.linux.dev>; Tue, 21 Jan 2025 16:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737476953; cv=none; b=hoh16kNSDgHzMmbFFR5Q/HyLZ5o5xgc2eRekP2QX1XgriwGM4uhayTUlffPCceXvMnkkmum+P0hJVLIgIS9mCQHj0LhrDeGBzpOVWFlvFv36DAkYXW5rp1qiiObJdz+10e6QRL+R6q+VQwpwacuTKAQxztBaHZk9sqGyGDhS6Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737476953; c=relaxed/simple;
	bh=Cd4ClxN1iDpLO+SC7rVFebWK2XvFy9+eoC+/Izwx/4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DR6+11RSQP9rLNOSzdgdCA6HNWTx9nGxs+cpTABUAZi/hd27yRWeVsBwt9v2bVNNeApuvdxu1j1vuPxm7IbPrhlL3X6pGaafg/Bc0b1EF7z1xTeXMFpBEfL+QMQexF/XGdM51bjHkGUJSynX2BDaYB3Zp/ITkbSUnPXKsYTcssA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ThyApVdi; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ThyApVdi"
Date: Tue, 21 Jan 2025 17:29:04 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737476948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JHE1Ks4sha2VPulKTfL3JK8VfRv3tuso1k0l1+BbscY=;
	b=ThyApVdiP12DgYTi+kjvBSrSt+RXWw1HLWvA8u4utOlNQmE4yb5C1jYj6Orkv1Dp2iJeY6
	rXmAwK6G9lbo4TBQOEmzkgkXQ6luL3C4+iz9Dxnj3EwunsaPkUpMGfXE7oNug+SLD5DSrN
	ZWyxbw6bSnfEJir2ggCFGEDT9G1saMQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com, 
	andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 08/18] scripts/runtime: Detect kvmtool
 failure in premature_failure()
Message-ID: <20250121-ec03a2683ab979d2313e09ee@orel>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
 <20250120164316.31473-9-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250120164316.31473-9-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 20, 2025 at 04:43:06PM +0000, Alexandru Elisei wrote:
> kvm-unit-tests assumes that if the VMM is able to get to where it tries to
> load the kernel, then the VMM and the configuration parameters will also
> work for running the test. All of this is done in premature_failure().
> 
> Teach premature_failure() about the kvmtool's error message when it fails
> to load the dummy kernel.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  scripts/runtime.bash | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 451b5585f010..ee8a188b22ce 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -12,18 +12,27 @@ extract_summary()
>      tail -5 | grep '^SUMMARY: ' | sed 's/^SUMMARY: /(/;s/'"$cr"'\{0,1\}$/)/'
>  }
>  
> -# We assume that QEMU is going to work if it tried to load the kernel
> +# We assume that the VMM is going to work if it tried to load the kernel
>  premature_failure()
>  {
>      local log
>  
>      log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
>  
> -    echo "$log" | grep "_NO_FILE_4Uhere_" |
> -        grep -q -e "[Cc]ould not \(load\|open\) kernel" \
> -                -e "error loading" \
> -                -e "failed to load" &&
> -        return 1
> +    case "$TARGET" in
> +    qemu)
> +

extra blank line here

> +        echo "$log" | grep "_NO_FILE_4Uhere_" |
> +            grep -q -e "[Cc]ould not \(load\|open\) kernel" \
> +                    -e "error loading" \
> +                    -e "failed to load" &&
> +            return 1
> +        ;;
> +    kvmtool)
> +        echo "$log" | grep "Fatal: Unable to open kernel _NO_FILE_4Uhere_" &&
> +            return 1
> +        ;;
> +    esac

This looks good, but could possibly become

 eval echo "$log" | ${vmm_opts[$TARGET,premature_failure]} && return 1

if we got the vmm_opts route.

Thanks,
drew

>  
>      RUNTIME_log_stderr <<< "$log"
>  
> -- 
> 2.47.1
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
