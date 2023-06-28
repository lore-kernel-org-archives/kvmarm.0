Received: from out-61.mta1.migadu.com (out-61.mta1.migadu.com [95.215.58.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5336263C9
	for <kvmarm@lists.linux.dev>; Wed, 28 Jun 2023 08:19:05 +0000 (UTC)
Date: Wed, 28 Jun 2023 10:19:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687940343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8/NpNtfgHWocmA3JK1yueXlTaMV0/c7t/H+GYBwbgk8=;
	b=w0luHIs1GtcC3Fb18QLuSEHXxi8VN2DHsp/n/vfoWEnf+Ph48ZX9NYWwOW+F7qAGCVjjvv
	/6mTrqYVYSahEmf7Qn0VFFP/kIQFg2qlRWKXCdwIETWji/6e5VUBr7kNG1s+16vKrqGeEA
	zYQdagh8eoejIvz7uGqyf09BQ/w+PYs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	Nikos Nikoleris <nikos.nikoleris@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, Nadav Amit <namit@vmware.com>
Subject: Re: [PATCH] .debug ignore - to squash with efi:keep efi
Message-ID: <20230628-646da878865323f64fc52452@orel>
References: <20230628001356.2706-1-namit@vmware.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230628001356.2706-1-namit@vmware.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 28, 2023 at 12:13:48AM +0000, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>

Missing s-o-b.

> 
> ---
>  .gitignore | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/.gitignore b/.gitignore
> index 29f352c..2168e01 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -7,6 +7,7 @@ tags
>  *.flat
>  *.efi
>  *.elf
> +*.debug
>  *.patch
>  .pc
>  patches
> -- 
> 2.34.1
>

The patch threading is busted. Everything in the thread, including the
cover letter, is in reply to this patch.

Thanks,
drew
