Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CE31170A
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 15:16:40 +0000 (UTC)
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-41214998fc2so27335321cf.0
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 08:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1695050199; x=1695654999; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Ucvab0+WYvq4UufE5S4SV2ca9jdWUsP9GGHLs6BCgo=;
        b=Es+VaBjpGDjxjUTVB5qVZUr0MDx/EZB3yS03V0tRcrOwKuoB4a8kj5gcJILXMA/hxj
         JrccQpqn6tR5WHI+Ft1zWYUQjuNrQtsapTTmegJb50N2vkplGY1yDQbPTh+utOD9sdgx
         9wbQ9A8b04uh6IhYGssahvPRDsVB2ShjHR5zVhVvtT49B/eNENR20lMwnlNpIVuG1Ctd
         nJRIPDESqVJpclt5w9FT+cktQ/XiVZN+OBMaLu1uWp+AqxhPPr5Z1MvzzEMnTFA3+N21
         N/npxxQOxzVGgjLX+JhAaEVkIYjZ9hTp067wwSVgT9U3mR3egPWl6dE51Gykouju9ZBp
         Hdfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695050199; x=1695654999;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Ucvab0+WYvq4UufE5S4SV2ca9jdWUsP9GGHLs6BCgo=;
        b=npYDzQWh0meaDZGtrnuGeldMgAjKTubOsLOXWpmtz6e6shCu5RBgR2jvXaBhSo915u
         6zIt9+dvsUVZAfvaSKaCq8gV2gFQeFmJDN2pGjchCveWyCJOiQjpLiryxpkfOJcnVMbg
         I9vjmgADYwP9WGEnCr0Qupr/UmsizCKf0QelqN32ZrskkTvwZ7g/p1MMFgltH3FCgsn2
         XsLmztwczv5/2zYSLlqX/meM5rVpTBkBBlHz4A+RkEeCO5xhRBgQaClqt7LHkq4EXkJn
         YFhygF1r5Q3a4vpntuvlTojT7keLVOOVFJ0HQAcuVR86uXLoFo73GICGz+f4D59TJPy0
         DJ9Q==
X-Gm-Message-State: AOJu0YzZO7XNOjn3L+V/yyj5YnEVXp2/TQ1tHhmLOOI7CeEBAjfE2lrT
	iWpcchSj8QozeSoyq4rhbIJt4Q==
X-Google-Smtp-Source: AGHT+IE1nILLKPaFxe5im/MfVjUE0HuRytyibnYnzCmrjBnu/bqUhqldLHu9krEWO371lIWoHdHJrg==
X-Received: by 2002:ac8:5ac9:0:b0:403:ef0a:ac69 with SMTP id d9-20020ac85ac9000000b00403ef0aac69mr11892621qtd.62.1695050199490;
        Mon, 18 Sep 2023 08:16:39 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-26-201.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.26.201])
        by smtp.gmail.com with ESMTPSA id z22-20020ac87116000000b004108f6788a6sm3081779qto.41.2023.09.18.08.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 08:16:38 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1qiFzJ-0005Nh-7L;
	Mon, 18 Sep 2023 12:16:37 -0300
Date: Mon, 18 Sep 2023 12:16:37 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sean Christopherson <seanjc@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-mips@vger.kernel.org, kvm@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	Anish Ghulati <aghulati@google.com>,
	Venkatesh Srinivas <venkateshs@chromium.org>,
	Andrew Thornton <andrewth@google.com>
Subject: Re: [PATCH 01/26] vfio: Wrap KVM helpers with CONFIG_KVM instead of
 CONFIG_HAVE_KVM
Message-ID: <20230918151637.GF13795@ziepe.ca>
References: <20230916003118.2540661-1-seanjc@google.com>
 <20230916003118.2540661-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230916003118.2540661-2-seanjc@google.com>

On Fri, Sep 15, 2023 at 05:30:53PM -0700, Sean Christopherson wrote:
> Wrap the helpers for getting references to KVM instances with a check on
> CONFIG_KVM being enabled, not on CONFIG_HAVE_KVM being defined.  PPC does
> NOT select HAVE_KVM, despite obviously supporting KVM, and guarding code
> to get references to KVM based on whether or not the architecture supports
> KVM is nonsensical.
> 
> Drop the guard around linux/kvm_host.h entirely, conditionally including a
> generic headers is completely unnecessary.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/vfio/vfio.h      | 2 +-
>  drivers/vfio/vfio_main.c | 4 +---
>  2 files changed, 2 insertions(+), 4 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
