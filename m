Received: from out-27.mta0.migadu.com (out-27.mta0.migadu.com [91.218.175.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5032C952
	for <kvmarm@lists.linux.dev>; Tue, 21 Mar 2023 14:49:26 +0000 (UTC)
Date: Tue, 21 Mar 2023 15:49:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679410164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qbQfRBfczUJav6FHt3ZKMjH+csQpxkzMB8JxUvxdhEg=;
	b=hfMGnzoG6xzWlox+ufsQX1egceC/3JbHyhVSilkiaV+C05kj5/k/2jyb75UTOgfVe9SVO8
	Dv0iKHcJVeJyPZTUhDUpu/N3qpFLSn6BX4v4acfZSWDNG2UvylXHh1RokgUtIlbvvCkTkz
	NlbjZ3Xw03ajFpUmCbPcF375angm+zo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
	qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.linux.dev,
	qemu-arm@nongnu.org
Subject: Re: [kvm-unit-tests PATCH v10 1/7] Makefile: add GNU global tags
 support
Message-ID: <20230321144922.kiptey3aiwnz7j65@orel>
References: <20230307112845.452053-1-alex.bennee@linaro.org>
 <20230307112845.452053-2-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230307112845.452053-2-alex.bennee@linaro.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 07, 2023 at 11:28:39AM +0000, Alex Bennée wrote:
> If you have ctags you might as well offer gtags as a target.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Message-Id: <20211118184650.661575-4-alex.bennee@linaro.org>
> 
> ---
> v10
>   - update .gitignore
> ---
>  Makefile   | 5 ++++-
>  .gitignore | 3 +++
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 6ed5deac..f22179de 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -145,6 +145,9 @@ cscope:
>  		-name '*.[chsS]' -exec realpath --relative-base=$(CURDIR) {} \; | sort -u > ./cscope.files
>  	cscope -bk
>  
> -.PHONY: tags
> +.PHONY: tags gtags
>  tags:
>  	ctags -R
> +
> +gtags:
> +	gtags
> diff --git a/.gitignore b/.gitignore
> index 33529b65..4d5f460f 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -12,6 +12,9 @@ tags
>  patches
>  .stgit-*
>  cscope.*
> +GPATH
> +GRTAGS
> +GTAGS
>  *.swp
>  /lib/asm
>  /lib/config.h
> -- 
> 2.39.2
>

Acked-by: Andrew Jones <andrew.jones@linux.dev>
