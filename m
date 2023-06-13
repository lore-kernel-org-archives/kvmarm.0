Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3611723DB
	for <kvmarm@lists.linux.dev>; Tue, 13 Jun 2023 16:27:36 +0000 (UTC)
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-3f81b83b8d5so95715e9.1
        for <kvmarm@lists.linux.dev>; Tue, 13 Jun 2023 09:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686673655; x=1689265655;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bb4r2L6AwZcib8eVRxm1j5QUlHnbK0ehOb0SKNt4SPU=;
        b=e1nUAZBxdwX20Geah9m+G2IuD80yh27ymA1hBhn7th6kdEYIhlb08tJahgei4NPXLE
         TlgGmEgc/p6XQ6zk4vL56FkhUwBSL2bytiyhe160o8dx4NCqmLjbae7t31KRCQRN5KNx
         3hhxUBhBgtAs7xhBDEFEufLFY2enbRYoWTN9q/jrnljkFWOGqQoYNSZT7gfzthNY+WR1
         4hcYZG9ZLw+0nMSl1O2pRZ17wkZjAUMR12qlZ8VWScwA7kRnDpTOd0fpeeb9vJ0IX5fB
         9qkvdJmUkTsAE0tRIFrrg7DjwsArDvIScL8EA1RoZxyN0KzqhZZR/IeLyckCMNlJx8dv
         8dVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686673655; x=1689265655;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bb4r2L6AwZcib8eVRxm1j5QUlHnbK0ehOb0SKNt4SPU=;
        b=kIBLNhY60tUkfyL7XlIZNC6ENB0djuyfNpOdwJJTEAjRt8JQ9BIjnzW6fet4J0Ze/V
         Q7a6TF3CLwtHUEwWP21WHTStRBbr/u5Fu9ovwBMbkAdtgOxidIy7wFsHL72e87Wed0UP
         HM7q/w6c57lFDZgy97tAmTi8USzb/gF0VaFSHblsWl7ovTIfGVLazTWUStNNX8MIS7Ph
         0zXRzOD2r6tWUwgheHpW7h007iH9w2ZW7Q6P4BSpvT2bAUDXvAUJrZffMxu8BLG8/pmO
         2yCR/giQItUSZ6q6lvmykrrn/fvFq3ELJWE4JGEYlKXnKV/9hgVUKzr6y3JG07XMk2Cw
         BjZQ==
X-Gm-Message-State: AC+VfDy4ymP0r6yH09FBgs+DVv/TqZzC8oCZsPnXrIgPaFp/g1cbzkuk
	zc6hJytvfv6+rxbZBaUpl+K+Vw==
X-Google-Smtp-Source: ACHHUZ7WP0YlatKkxy7A15OCib42caMtXP4jusH0MPAzWXQ3c89i4Ak3A54HsaSwRdX46YQ2Sv6VAA==
X-Received: by 2002:a05:600c:3c86:b0:3f7:3654:8d3 with SMTP id bg6-20020a05600c3c8600b003f7365408d3mr148549wmb.2.1686673655192;
        Tue, 13 Jun 2023 09:27:35 -0700 (PDT)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id t11-20020a7bc3cb000000b003f60eb72cf5sm14998338wmj.2.2023.06.13.09.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 09:27:34 -0700 (PDT)
Date: Tue, 13 Jun 2023 16:27:30 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, suzuki.poulose@arm.com,
	kaleshsingh@google.com, tabba@google.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, james.morse@arm.com, will@kernel.org
Subject: Re: [PATCH] KVM: arm64: Use different pointer authentication keys
 for pKVM
Message-ID: <ZIiY8lrLKv4amCu7@google.com>
References: <20230516141531.791492-1-smostafa@google.com>
 <168665854178.2681974.13725664134174024912.b4-ty@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168665854178.2681974.13725664134174024912.b4-ty@linux.dev>

Hi Oliver,

On Tue, Jun 13, 2023 at 12:16:02PM +0000, Oliver Upton wrote:
> On Tue, 16 May 2023 14:15:31 +0000, Mostafa Saleh wrote:
> > When the kernel is compiled with CONFIG_ARM64_PTR_AUTH_KERNEL, it
> > uses Armv8.3-Pauth for return address protection for the kernel code
> > including nvhe code in EL2.
> > 
> > Same keys are used in both kernel(EL1) and nvhe code(EL2), this is
> > fine for nvhe but not when running in protected mode(pKVM) as the host
> > can't be trusted.
> > 
> > [...]
> 
> Applied to kvmarm/next, thanks!
> 
> [1/1] KVM: arm64: Use different pointer authentication keys for pKVM
>       https://git.kernel.org/kvmarm/kvmarm/c/fb737685beee
> 
> --

Thanks! I did more testing and I found a bug in this patch.

It seems there is another entry point for the kenrel where pauth was
not handled properly "kvm_host_psci_cpu_entry", I will investigate this
further and send V2.

Sorry for the inconvenience!

Thanks,
Mostafa
