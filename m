Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92C412E4A
	for <kvmarm@lists.linux.dev>; Wed, 29 Nov 2023 09:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qwB/BR8z"
Date: Wed, 29 Nov 2023 10:11:34 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701249098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JRJxZnwGjhIymnyBBk6Y0CVmxFGG/QUTFScRcfcAsVk=;
	b=qwB/BR8zmhZ0jMeS+cVo8foAK3xEFLSq4YUnhHe9e/mPCH2FOuPJVAHqc8d+syKwescfaO
	XD7HBc9RfGv8wjaC+RbtOXUOnzIcQjTDZm4ZJa5Cz6lgbRU/E5II0VOKInSCbDvN38nfQc
	9cAGSDxCDEE5dnpF7SGvGL61941Hhv4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: kvmarm@lists.linux.dev, Thomas Huth <thuth@redhat.com>, 
	Nico Boehr <nrb@linux.ibm.com>, Ricardo Koller <ricarkol@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Nina Schoetterl-Glausch <nsg@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 1/3] runtime: Fix the missing last_line
Message-ID: <20231129-54301cf86283b3d5a5a249ea@orel>
References: <20231129032123.2658343-1-shahuang@redhat.com>
 <20231129032123.2658343-2-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129032123.2658343-2-shahuang@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 28, 2023 at 10:21:21PM -0500, Shaoqin Huang wrote:
> The last_line is deleted by the 2607d2d6 ("arm64: Add an efi/run script").
> This lead to when SKIP test, the reason is missing. Fix the problem by
> adding last_line back.
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>

Fixes: 2607d2d6 ("arm64: Add an efi/run script")

> ---
>  scripts/runtime.bash | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index fc156f2f..d7054b80 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -148,6 +148,8 @@ function run()
>              fi
>          fi
>  
> +	last_line=$(tail -1 <<<"$log")
> +
>          if [ ${skip} == true ]; then
>              print_result "SKIP" $testname "" "$last_line"

We can just change this one use of $last_line to $(tail -1 <<<"$log")

>              return 77
> -- 
> 2.40.1
>

Thanks,
drew
