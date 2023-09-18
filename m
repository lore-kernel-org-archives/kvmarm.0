Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0676B38F8A
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 15:21:12 +0000 (UTC)
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-770ef353b8fso303548085a.0
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 08:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1695050472; x=1695655272; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9iwt12QdmH2nPtcjR0iEq1G+1D18erLjJ1cQj58qe4I=;
        b=nkGldrEVhWhWvkjqnWXkhvDWz8BjGrujn8htTm1wzYjQvr6A5n/7kknqZdsd9hApSI
         mci7+yt9mjo5w9WdEb1pfsiwxtjp+QM4qU+53C3V1sgHyte/Q/N5kYCL+uWfSav3OX1e
         X4pcwAwgRRg/uXatXy6HahwMI8vVqaHepb1hnBj4k7b2IG8ojWPp7VRmWOijBwIjBhn4
         hNpWMIYGqIzGG0DcBs5rluPcLDnf+RqY051GOD146T4qsgOVJotlNq132HwhcxcJ6nEo
         S4fLC1e+Bb5VleBL4dt44ZtS9KbIu/E+MkyA1Caub2uYk9GUOKgeUosSB0bSgr4UYIQW
         l1kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695050472; x=1695655272;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9iwt12QdmH2nPtcjR0iEq1G+1D18erLjJ1cQj58qe4I=;
        b=sGSy+G9h2+pi7qxKQsREh8BOAD4bg2U3gL6RQAvE+SQYurKNiao1dGpHDdcZR5S+am
         kTDM4jzaYwmzCASyZ1ymAtk3s20EmcrkqIHpYVf24L4gPwUhjNGRwOfrC98jOyig3JLw
         1lTpzQ/0H8pXFOw3WiYVW9e95+1gWt7nDNLX0N5MSgXdMRGGF82T/iIJGoJaRIDX3M50
         weLSEuxd9jhN11LYhcUDXd8bPyjVyB08pdBzhz+hMvMCZfUJxwxQkCWPK03OgULhD3QK
         EBquBrL0mEXOFI7TZYTvxgRTzv/VmmF3WeK/5Txx0Sv/0bdH5LdX3tqq4dox+9zJQ+aE
         qrvw==
X-Gm-Message-State: AOJu0YwuUtZaeZKweqprPuIxNJYQiOXvD9WXhgZMShGcGWJlvOLXe2Yq
	XwmtKiqUX156mRxDM/9vepMsXg==
X-Google-Smtp-Source: AGHT+IEUJFa3aXEX1YodKfdMrwJPEEuzBhbA2hgycHy86i8DANtxQ0UmL29SlN96YZ1Wg+zGpbaj/w==
X-Received: by 2002:a05:620a:31a8:b0:76d:a110:856d with SMTP id bi40-20020a05620a31a800b0076da110856dmr11089993qkb.0.1695050471902;
        Mon, 18 Sep 2023 08:21:11 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-26-201.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.26.201])
        by smtp.gmail.com with ESMTPSA id i20-20020a05620a145400b0076f18be9a64sm3220186qkl.81.2023.09.18.08.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 08:21:11 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1qiG3i-0005PK-IY;
	Mon, 18 Sep 2023 12:21:10 -0300
Date: Mon, 18 Sep 2023 12:21:10 -0300
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
Subject: Re: [PATCH 05/26] vfio: KVM: Pass get/put helpers from KVM to VFIO,
 don't do circular lookup
Message-ID: <20230918152110.GI13795@ziepe.ca>
References: <20230916003118.2540661-1-seanjc@google.com>
 <20230916003118.2540661-6-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230916003118.2540661-6-seanjc@google.com>

On Fri, Sep 15, 2023 at 05:30:57PM -0700, Sean Christopherson wrote:
> Explicitly pass KVM's get/put helpers to VFIO when attaching a VM to
> VFIO instead of having VFIO do a symbol lookup back into KVM.  Having both
> KVM and VFIO do symbol lookups increases the overall complexity and places
> an unnecessary dependency on KVM (from VFIO) without adding any value.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/vfio/vfio.h      |  2 ++
>  drivers/vfio/vfio_main.c | 74 +++++++++++++++++++---------------------
>  include/linux/vfio.h     |  4 ++-
>  virt/kvm/vfio.c          |  9 +++--
>  4 files changed, 47 insertions(+), 42 deletions(-)

I don't mind this, but Christoph had disliked my prior attempt to do
this with function pointers..

The get can be inlined, IIRC, what about putting a pointer to the put
inside the kvm struct?

The the normal kvm get/put don't have to exported symbols at all?

Jason
