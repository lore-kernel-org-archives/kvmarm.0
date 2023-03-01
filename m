Received: from out-25.mta0.migadu.com (out-25.mta0.migadu.com [91.218.175.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335A52588
	for <kvmarm@lists.linux.dev>; Wed,  1 Mar 2023 12:50:15 +0000 (UTC)
Date: Wed, 1 Mar 2023 13:50:04 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1677675013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fCApX7iz5dgT/qmgIa01Py+r2kxVH4oqCWLORW4PNTQ=;
	b=DDTl2Zl4yoMvYU4F+/6WIVQjfpWjwBjKCFTSZE7IS2oqJFttijOwKb+uwI9FoZd1GPu40y
	dd3u4QOUYe8PY/obz7nNM2+3GrxYunS+jt/WyYZnQyfAkX8B87wGfSRWVJg0Na9ctsS/eA
	nGiXsCw4OLPMziZq86+HNLSKAfv4r70=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: kvmarm@lists.linux.dev, "open list:ARM" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests] arm: Replace the obsolete qemu script
Message-ID: <20230301125004.d5giadtz4yaqdjam@orel>
References: <20230301071737.43760-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301071737.43760-1-shahuang@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 01, 2023 at 02:17:37AM -0500, Shaoqin Huang wrote:
> The qemu script used to detect the testdev is obsoleted, replace it
> with the modern way to detect if testdev exists.

Hi Shaoqin,

Can you please point out the oldest QEMU version for which the modern
way works?

> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>  arm/run | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arm/run b/arm/run
> index 1284891..9800cfb 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -59,8 +59,7 @@ if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
>  	exit 2
>  fi
>  
> -if $qemu $M -chardev testdev,id=id -initrd . 2>&1 \
> -		| grep backend > /dev/null; then
> +if ! $qemu $M -chardev '?' 2>&1 | grep testdev > /dev/null; then
                              ^ This shouldn't be necessary. afaict,
			        only stdio is used

We can change the 'grep testdev >/dev/null' to 'grep -q testdev'

>  	echo "$qemu doesn't support chr-testdev. Exiting."
>  	exit 2
>  fi
> -- 
> 2.39.1
> 

Thanks,
drew
