Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16211CF95
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 15:29:48 +0000 (UTC)
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-773ac11de71so231971685a.2
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 08:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1695050988; x=1695655788; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nmpxNm78kWfejPgZcglZLNttpcA+aOzIbjCglm6BlEY=;
        b=AmyVKgBVw1FV9w3+rDy+iemY+pf/A+Aw7kLqrhPU86abZeYA0AAA3Zw8pBsInQJhpB
         Tw4mmO9bjPmAoca+CezzCatJXaTooCO43WBP9ict0Y0lpMgaUOQRilnAlnG7UZAsF7Mt
         o+0pY/8CdT/LoEvDAEoqGvBi0tYwuyFhnpxIJE+tpq6TmEFhB70zL5kxaOAV3oiZsIGZ
         D+LOo3wYmXjp0xMrCClt20e7zJm5Yb/3CNqMcZOIDTDofr8L8BHz9jnXaZ4DazPKi9BJ
         HKov8xhG50lUYAA4q6r+oQ5gLkVTqENaFIkR4rDvlV8BemnJy9MrcI78+riYnw7JFU7c
         8PYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695050988; x=1695655788;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nmpxNm78kWfejPgZcglZLNttpcA+aOzIbjCglm6BlEY=;
        b=hxOrdfYWUl171syEr14UiDrBhvd3sObV0Sxis/xfJAYJjOJ2vLImN+EqpYdVNQCoPu
         6rxo2RZhKq2jvaF+sDn6oqzST5+IwjNSdLFGUK9X7Mv3V+WdeLWP/rUmX3LZSYJZy2PU
         H2o+LlA82YQkqGSwb9FmXDX9kTLoVoR5twGZqfgwEDpW7vHDOJBm2wQBu83LkcyUGpCQ
         aj8Vx/y5iMqvZzVuDy4pqogQ08E6aVb/mqYNqWaQSVq+z7fNq301dy4NYwiXmWXLiBQX
         9KOa6d2t5jvFMxfAiY6s6AeX8nO+46iO1wtFYs/u2gQsLi2Xepe+fhB0fbxoBn/lxAaa
         VT2g==
X-Gm-Message-State: AOJu0YybPxXvmTtkNjd85mZqa0vOVJ0q9eCoOq4oqZXWWrrtxjyIM4u4
	OVv+Ntln1U1leDW2eYmAmXI7cg==
X-Google-Smtp-Source: AGHT+IE5R1x821mq0T9l2iChMZP/v62/zLl2heVXzUEZigk+bm+oq/r6FG+m4/T/InbSxJxTjGr9mw==
X-Received: by 2002:a05:620a:2887:b0:76d:aa93:2e3c with SMTP id j7-20020a05620a288700b0076daa932e3cmr11157815qkp.24.1695050987781;
        Mon, 18 Sep 2023 08:29:47 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-26-201.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.26.201])
        by smtp.gmail.com with ESMTPSA id s4-20020a05620a16a400b0076d0312b8basm3183843qkj.131.2023.09.18.08.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 08:29:47 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1qiGC2-0005S2-Ku;
	Mon, 18 Sep 2023 12:29:46 -0300
Date: Mon, 18 Sep 2023 12:29:46 -0300
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
Subject: Re: [PATCH 06/26] KVM: Drop CONFIG_KVM_VFIO and just look at KVM+VFIO
Message-ID: <20230918152946.GJ13795@ziepe.ca>
References: <20230916003118.2540661-1-seanjc@google.com>
 <20230916003118.2540661-7-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230916003118.2540661-7-seanjc@google.com>

On Fri, Sep 15, 2023 at 05:30:58PM -0700, Sean Christopherson wrote:
> Drop KVM's KVM_VFIO Kconfig, and instead compile in VFIO support if
> and only if VFIO itself is enabled.  Similar to the recent change to have
> VFIO stop looking at HAVE_KVM, compiling in support for talking to VFIO
> just because the architecture supports VFIO is nonsensical.
> 
> This fixes a bug where RISC-V doesn't select KVM_VFIO, i.e. would silently
> fail to do connect KVM and VFIO, even though RISC-V supports VFIO.  The
> bug is benign as the only driver in all of Linux that actually uses the
> KVM reference provided by VFIO is KVM-GT, which is x86/Intel specific.

Hmm, I recall that all the S390 drivers need it as well.

static int vfio_ap_mdev_open_device(struct vfio_device *vdev)
{
        struct ap_matrix_mdev *matrix_mdev =
                container_of(vdev, struct ap_matrix_mdev, vdev);

        if (!vdev->kvm)
                return -EINVAL;

        return vfio_ap_mdev_set_kvm(matrix_mdev, vdev->kvm);


I wonder if we should be making the VFIO drivers that need the kvm to
ask for it? 'select CONFIG_NEED_VFIO_KVM' or something?

Regardless, I fully agree with getting rid of the arch flag.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

> --- a/virt/kvm/Makefile.kvm
> +++ b/virt/kvm/Makefile.kvm
> @@ -6,7 +6,9 @@
>  KVM ?= ../../../virt/kvm
>  
>  kvm-y := $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
> -kvm-$(CONFIG_KVM_VFIO) += $(KVM)/vfio.o
> +ifdef CONFIG_VFIO
> +kvm-y += $(KVM)/vfio.o
> +endif

I wonder if kvm-m magically works in kbuild so you don't need the ifdef?

Jason
