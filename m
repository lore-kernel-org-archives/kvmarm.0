Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FEE15494
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 15:18:07 +0000 (UTC)
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-411f5dd7912so31065551cf.3
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 08:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1695050286; x=1695655086; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=skILK3+RqLs29/E8NIb2upQKKLhMeBuYLpBX+o8j0o8=;
        b=NeGyEDAQUamBvGuZf9UHstJRgGQV1X24WUPvfXLiDEP4WYPuIjnmMOiL6i0gUiyVQ0
         4x5DUBOpeAPh8VqAOCvQm5eKiUW5n+Zlk3gzGyArM3Lcb59f2YO1z6aCJkDXCQ2od2X9
         7efrrQRjES9MPoF6v56Z66huZ4ziRP/KQE0JiP3YXjpQSu3sDVLDvyjTOkbv4uaiezrY
         rdxFArEiFEUTrSdj0p74l2gNVEDbn0coc6lQ8/ReABh9+4hQSpH8Njv1jiiM3Nko1BRa
         DVTj1s4VQ0li9ecXKM9vxGsfnAfZxEUUZhUT0ktP/+uBNXK1DmM5QYt1idN6ISGZlabA
         K5zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695050286; x=1695655086;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=skILK3+RqLs29/E8NIb2upQKKLhMeBuYLpBX+o8j0o8=;
        b=hZtf6lCaYfVZFqzcfRuR4aM87zCumLh6Ag2U6sUJSaGuCYvgtLDp9lzU3+1IylJDV1
         0ks/YdAzU9ML8rIKCgXmoVJEoU1/LABidGSwUJtinbprNa3IqMOPpm89B19JGY5d+AlI
         3uJWQ5PdZ6aT0S4f9gS3bXVnnIUwpJd8bwVGw3elclYmeYb0U5FL0Av1Zew+mbCbI30a
         hFyxzCimZC0zu0ADTUcmCeWCU7nukLlZkzhAyIRuSn9S+zpTYc3PzuviSjt6ZwDd6TwL
         a/gEsQLNv5fe3o8FnNDf2N6AjaB5AXQwNPeQtNOQz7UEcvh2C4tBH5N5mlENOzfQftbm
         Dt0w==
X-Gm-Message-State: AOJu0YyYUkZrjOFNaLYimWPwhBzcQEYfCB7eY3mV77jGFD57U/EJ2y3W
	8CkBgQWO2d1lr8+hQjIVC2vFdA==
X-Google-Smtp-Source: AGHT+IEPjZK20Aqh4DOH80nyWTVB2XY8RoIapnvcyiksM3wp5qxi6JV9wSTNi2A0D4DmrBL930vlSw==
X-Received: by 2002:ad4:458d:0:b0:63f:9aa3:867b with SMTP id x13-20020ad4458d000000b0063f9aa3867bmr9395365qvu.40.1695050286275;
        Mon, 18 Sep 2023 08:18:06 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-26-201.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.26.201])
        by smtp.gmail.com with ESMTPSA id r28-20020a0cb29c000000b0063d038df3f3sm3532215qve.52.2023.09.18.08.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 08:18:05 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1qiG0i-0005OR-Iy;
	Mon, 18 Sep 2023 12:18:04 -0300
Date: Mon, 18 Sep 2023 12:18:04 -0300
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
Subject: Re: [PATCH 03/26] virt: Declare and define vfio_file_set_kvm() iff
 CONFIG_KVM is enabled
Message-ID: <20230918151804.GH13795@ziepe.ca>
References: <20230916003118.2540661-1-seanjc@google.com>
 <20230916003118.2540661-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230916003118.2540661-4-seanjc@google.com>

On Fri, Sep 15, 2023 at 05:30:55PM -0700, Sean Christopherson wrote:
> Hide vfio_file_set_kvm() and its unique helpers if KVM is not enabled,
> nothing else in the kernel (or out of the kernel) should be using a
> KVM specific helper.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/vfio/vfio_main.c | 2 +-
>  include/linux/vfio.h     | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)

Patch subject should be vfio not virt

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

> @@ -1388,6 +1387,7 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
>  		vfio_device_file_set_kvm(file, kvm);
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
> +#endif

We could even put this in a symbol namespace..

Jason
