Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7505F1FBBE8
	for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 15:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736780541; cv=none; b=Dsd4OtdSgf55NzJtQpLsvnPfoyPYqmICq4UxCRkMu0MIGA9KSGpYLx2pfeBJYCzIiERSQnU0xn5jx624+S4zDzOS3FVdow4pxg7izK7c2GwHDQtF5NQsSCi+1/cKU/hiMMGhvD+RQ2urUadLVsDIJ8WA+KWgDXRze2/Bm50mGX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736780541; c=relaxed/simple;
	bh=jReV93cCbYPy83WgD/3sAghiioBKnnwhpLE7WasF130=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=THMGqBH1X2gHznH/h6hSmZATVymevz/N1eyedCumu5kBDQcON7EidaZ3CiT0niemhbCsed0r6uQosF+nujdS6m+VkPSb6byJc1bDGG3ArbEFF1GhTEupP7IV/8avErypiw+iQBxDQkvV9ImVvRsIWn1NsrITCeHtuVrK8Dx3ezs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VgUr5y4b; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VgUr5y4b"
Date: Mon, 13 Jan 2025 16:01:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736780522;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KwFSzUI7AdO7FN349dbUBnEYz5JimFOvpyWuoBOACSs=;
	b=VgUr5y4bQO1Br7MsgRdM1yCg/KVoRF6a29p+gYXkeY6gfIyCy+x35yMDZCFlI5dFxc3uid
	JtEpJHj3e3C8PLPpr9BNvSyShTJt3K0xoqNMpByq1XfH+tJUKm4mzI5Q+UAPA//+02zQa1
	COW1rZcCyiE9+UKnRWMTecZzncHIwj8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v1 1/5] configure: Document that the
 architecture name 'aarch64' is also supported
Message-ID: <20250113-0fe04c6089726d1d06a254ec@orel>
References: <20250110135848.35465-1-alexandru.elisei@arm.com>
 <20250110135848.35465-2-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250110135848.35465-2-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 10, 2025 at 01:58:44PM +0000, Alexandru Elisei wrote:
> $arch, on arm64, defaults to 'aarch64', and later in the script is replaced
> by 'arm64'. Intentional or not, document that the name 'aarch64' is also
> supported when configuring for the arm64 architecture. This has been the
> case since the initial commit that added support for the arm64
> architecture, commit 39ac3f8494be ("arm64: initial drop").
> 
> The help text for --arch changes from*:
> 
>    --arch=ARCH            architecture to compile for (aarch64). ARCH can be one of:
>                            arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
> 
> to:
> 
>     --arch=ARCH            architecture to compile for (aarch64). ARCH can be one of:
>                            arm, arm64/aarch64, i386, ppc64, riscv32, riscv64, s390x, x86_64
> 
> *Worth pointing out that the default architecture is 'aarch64', even though
> the rest of the help text doesn't have it as one of the supported
> architectures.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  configure | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/configure b/configure
> index 86cf1da36467..5b0a2d7f39c0 100755
> --- a/configure
> +++ b/configure
> @@ -47,7 +47,7 @@ usage() {
>  
>  	Options include:
>  	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
> -	                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
> +	                           arm, arm64/aarch64, i386, ppc64, riscv32, riscv64, s390x, x86_64
>  	    --processor=PROCESSOR  processor to compile for ($arch)
>  	    --target=TARGET        target platform that the tests will be running on (qemu or
>  	                           kvmtool, default is qemu) (arm/arm64 only)
> -- 
> 2.47.1
>

I'd prefer to support --arch=aarch64, but then always refer to it as only
arm64 everywhere else. We need to support arch=aarch64 since that's what
'uname -m' returns, but I don't think we need to change the help text for
it. If we don't want to trust our users to figure out arm64==aarch64,
then we can do something like

@@ -216,12 +197,12 @@ while [[ $optno -le $argc ]]; do
            werror=
            ;;
        --help)
-           usage
+           do_help=1
            ;;
        *)
            echo "Unknown option '$opt'"
            echo
-           usage
+           do_help=1
            ;;
     esac
 done

And then only do

 if [ $do_help ]; then
    usage
 fi

after $arch and other variables have had a chance to be converted.

Thanks,
drew
