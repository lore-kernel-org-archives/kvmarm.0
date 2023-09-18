Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018241170A
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 15:17:12 +0000 (UTC)
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3a7f4f7a8easo2203897b6e.2
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 08:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1695050232; x=1695655032; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/NB9QogE7/hqQA3eAPgSewNzbsnZd2QFPin+QhCO7do=;
        b=J2Gfj6q4M/MBtU9WPY6f23cW2QCyngNjN292Dg0SQFF+TRpEIxjLdEwcqHISjj/pop
         3vZ7ikorf8WuGK5dVzklevOwiayaB1Jv1GuPnoRG5u6QS93i2fJOIfCbV52//6FAxpWc
         AmrtD1iRFLLFVCV9bmMtuEMQ5XGjkAHJ+PVL7JD+03HqCFYcy+wMy4FKz69hMYwkn+wr
         AHN6UvduzJ07vHL7ms6xC+VSxl2izEnybxUrnQnLXvXhfKLhUXHhbzHj8tEPkqysfwBl
         7Iwc9VNxqVtbwUh1NrNeKok8Cdi6UYTuMyo0ciPI+5ql73LFFxaxlAww6d4uGjdXFX98
         lUlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695050232; x=1695655032;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/NB9QogE7/hqQA3eAPgSewNzbsnZd2QFPin+QhCO7do=;
        b=SwwcGAh0psH+nIQ7LQQaoczFnqaJ8FDKhJvsNwLkdBrvKFpopGOSL4ujPNw1yQfMAA
         1SKhgGMH7tZNHdtcxXoI5g3cyM/5VB0gB/qCaLRn6scMPPTqbNbMoXiIgTTz7KwFYWml
         2fbPQBgLn2tiM4O5+DT2sWbUBO3ziS8LY7RjhQ85yD5s/kEx8SJwt9HD6QgJ4roeuZUq
         nhgESc+aPYQYXAlgq64ADG2i+k27XVBx+n24KoWPfI7RyjDVlOP3huBCrDXZ0cnpDgDn
         67kE+x9gqkTPXOwdoIOreeELd+G2YYGaWPQ4F1RLYac78xTL3gsXGCXfl/srkaDUOrGf
         5HFQ==
X-Gm-Message-State: AOJu0Yz0WO2uP8DFKarpJTOM0Vap9JP5rbjv6FoUYhbhfQIJf8Bg1uND
	WF8raWcu25C1YREJPro9qpC0mw==
X-Google-Smtp-Source: AGHT+IGk3T+gnY/Ry6RzP8KMpZ6etd0YaUlt1+KGAcu6zz40/S34i/NvbRLiXeftEMRhME9haaF4Dg==
X-Received: by 2002:a05:6870:b691:b0:1d5:b442:5de7 with SMTP id cy17-20020a056870b69100b001d5b4425de7mr10054844oab.35.1695050231963;
        Mon, 18 Sep 2023 08:17:11 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-26-201.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.26.201])
        by smtp.gmail.com with ESMTPSA id r13-20020a0ce28d000000b0064f50e2c551sm1477356qvl.1.2023.09.18.08.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 08:17:11 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1qiFzq-0005O4-IS;
	Mon, 18 Sep 2023 12:17:10 -0300
Date: Mon, 18 Sep 2023 12:17:10 -0300
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
Subject: Re: [PATCH 02/26] vfio: Move KVM get/put helpers to colocate it with
 other KVM related code
Message-ID: <20230918151710.GG13795@ziepe.ca>
References: <20230916003118.2540661-1-seanjc@google.com>
 <20230916003118.2540661-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230916003118.2540661-3-seanjc@google.com>

On Fri, Sep 15, 2023 at 05:30:54PM -0700, Sean Christopherson wrote:
> Move the definitions of vfio_device_get_kvm_safe() and vfio_device_put_kvm()
> down in vfio_main.c to colocate them with other KVM-specific functions,
> e.g. to allow wrapping them all with a single CONFIG_KVM check.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/vfio/vfio_main.c | 104 +++++++++++++++++++--------------------
>  1 file changed, 52 insertions(+), 52 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
