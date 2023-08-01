Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121511110
	for <kvmarm@lists.linux.dev>; Tue,  1 Aug 2023 09:21:51 +0000 (UTC)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-98dfb3f9af6so860580366b.2
        for <kvmarm@lists.linux.dev>; Tue, 01 Aug 2023 02:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690881710; x=1691486510;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gm17gZxC0/vm/Jdu3xQH50fn0wnKiSVhKMApv17FsGQ=;
        b=dq5CAvhQQ+vveH4MSteCM4KpxWqvSjfMuOapn0LnoQqDOErjMIbbWNheVH/uLc2KIf
         UdBwINkexXsFRjBN8poea9hv+4sXzWagYJkGf39toFnDnN3gA3fyjhZTQCaYda/GblQa
         pkw6dcECiAkZW/+Wy1xwLXzUC7d0jC/4tRCVUhI1fyGS501AuV0YVethzHboQgI7CbyL
         M5k4ZKy5NVWRN6++5pgESXlnIknAxtut14Hcvq275w4blo8RZfULkrUqc81+6hPmItwP
         3fxQ350OyrMQNDnLyh3ELg4ylCq9dGO2couVM6uXKHIXQCaUruaeC2pK2fs6kliqSArs
         ZedQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690881710; x=1691486510;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gm17gZxC0/vm/Jdu3xQH50fn0wnKiSVhKMApv17FsGQ=;
        b=IEb6wO7G4sSemqsTkAWhl2e8Bh1oI1UjMd0m/tb6IAfECFaVLDW0OKCESo5chixRqI
         uy3/jjcxlBRqUcloNSrvUJgxnKPZcuTKq/xUrWBOxdkHYMdKE0jSxrJOrgBeAfu93JPG
         uC5c5B3l9KmNN/5233qF3hZ8mzR5+Ww/rz6svVgLukP/n9aXiycIstJbZ3RCAKUgH0wi
         DI6pndpAKJ5adxG6xW8ot4S6TcQwAwMj4geQkIspVc1vCwPLwibZJ2V2abHq9XRY+THL
         LfwAGOi5xAdutfh8XmIatsGH5VK53aNu6ZGfMktt9ze3S3FclD70LgKh/Fa0mW0c3oPU
         Ecrg==
X-Gm-Message-State: ABy/qLYYB7C26SFwv1AE/556g2+E2cOShVlgLoDcqcsh/mmvKSCvxFH1
	PSoZQ1LQ1DBlp1x8kYOeNXeGCQ==
X-Google-Smtp-Source: APBJJlGhr0BuIoveysf7HtzpSl2Jm+kRbIcFJ2Y03OXcder2XbQzIJjvsXJoXuSOYODVVZsM7UAnIg==
X-Received: by 2002:a17:906:518a:b0:99b:fdbb:31f1 with SMTP id y10-20020a170906518a00b0099bfdbb31f1mr2052678ejk.16.1690881710061;
        Tue, 01 Aug 2023 02:21:50 -0700 (PDT)
Received: from localhost (212-5-140-29.ip.btc-net.bg. [212.5.140.29])
        by smtp.gmail.com with ESMTPSA id m10-20020a17090607ca00b009931a3adf64sm7529760ejc.17.2023.08.01.02.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 02:21:49 -0700 (PDT)
Date: Tue, 1 Aug 2023 11:21:48 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH v4.1 1/3] KVM: selftests: Add arch ucall.h and inline
 simple arch hooks
Message-ID: <20230801-3ab43c432cbaafcadbffb092@orel>
References: <20230731203026.1192091-1-seanjc@google.com>
 <20230731203026.1192091-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230731203026.1192091-2-seanjc@google.com>

On Mon, Jul 31, 2023 at 01:30:24PM -0700, Sean Christopherson wrote:
> Add an architecture specific ucall.h and inline the simple arch hooks,
> e.g. the init hook for everything except ARM, and the actual "do ucall"
> hook for everything except x86 (which should be simple, but temporarily
> isn't due to carrying a workaround).
> 
> Having a per-arch ucall header will allow adding a #define for the
> expected KVM exit reason for a ucall that is colocated (for everything
> except x86) with the ucall itself.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/include/aarch64/ucall.h      | 18 ++++++++++++++++++
>  .../selftests/kvm/include/riscv/ucall.h        | 18 ++++++++++++++++++
>  .../selftests/kvm/include/s390x/ucall.h        | 17 +++++++++++++++++
>  .../selftests/kvm/include/ucall_common.h       |  1 +
>  .../selftests/kvm/include/x86_64/ucall.h       | 11 +++++++++++
>  .../testing/selftests/kvm/lib/aarch64/ucall.c  | 11 +----------
>  tools/testing/selftests/kvm/lib/riscv/ucall.c  | 11 -----------
>  tools/testing/selftests/kvm/lib/s390x/ucall.c  | 10 ----------
>  tools/testing/selftests/kvm/lib/x86_64/ucall.c |  4 ----
>  9 files changed, 66 insertions(+), 35 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/ucall.h
>  create mode 100644 tools/testing/selftests/kvm/include/riscv/ucall.h
>  create mode 100644 tools/testing/selftests/kvm/include/s390x/ucall.h
>  create mode 100644 tools/testing/selftests/kvm/include/x86_64/ucall.h
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
