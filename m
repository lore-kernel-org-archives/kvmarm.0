Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D75538BD5
	for <kvmarm@lists.linux.dev>; Thu, 28 Sep 2023 22:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695939701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VYqIaFDftvj8+TDcTZgaXgu9cICTLPBd1GmPz49S0qk=;
	b=P/J1GSJdGdP+wYekWor9SaPZNYjnV+SDxw2YnSPeHVnIOUww/2MeAXS+7n0ni4X1IdAEM1
	rB+K80h0xf06LxCM5yfD0RQPUhyZfDWrdL/ncllewH91/Lj62kwYBnfiVDXAPPuw6U5pq8
	f+g3Qh/aT/HwRz4Wma7CjTDiGqY0YO0=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-8sL9_lWZOX6IU_FvGdTcnQ-1; Thu, 28 Sep 2023 18:21:39 -0400
X-MC-Unique: 8sL9_lWZOX6IU_FvGdTcnQ-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7a2632be370so58444839f.1
        for <kvmarm@lists.linux.dev>; Thu, 28 Sep 2023 15:21:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695939698; x=1696544498;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VYqIaFDftvj8+TDcTZgaXgu9cICTLPBd1GmPz49S0qk=;
        b=uVQnB79aHjr+lej5EXdcdo0LkLAQ4bo9/7cCQqAaOgYEZ6WsN8nJlhuihC6+aFtGB2
         XSn+mfNcSUejPy7G3pYc+affKaeVUEId03cKBeFRFfHsoERaChXXJBiTt23M4l0LF06D
         I2/4Zmtac6mnTzHBYS8S3ZOTjHsaUhZnAach6rGVssw6F8NHhYKlwYxzRk7ZSirSLeSp
         Lh07ZNyKhXqX9gVv7JCfCv0CvUR/A8txDvd5Q0FKuKr1bT0KxNwE3DzcDrV9mfKTVD1N
         dBfA0cygF9b/NqkrwuKSjBCqRXd09WX+ZHnNm/VAFiYYpNjxEBPcen3BN56gDOeE7ehd
         2dgw==
X-Gm-Message-State: AOJu0Yyw/tsaVBk6/G3WP2IRMotJFuHDaabgTYc8iOzxl7sYPXBtPG8m
	7rL03j3Wv0EhqesM4Z52U0WzyD+XA0l9nsutOUJDgCt0h9BqgZoTiH1ypg8sVjX0dZii22mdT4K
	dwKuZl+L+xc0SLqwQ
X-Received: by 2002:a05:6602:2211:b0:798:3cb5:ad30 with SMTP id n17-20020a056602221100b007983cb5ad30mr2909934ion.7.1695939698496;
        Thu, 28 Sep 2023 15:21:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEv0LRR9DkFI1OYy1PoOT1i3eAWQj2VngBzVVO4xeK3kF6WDlUiAdkJKTL/cdHqWL0xs+JJYA==
X-Received: by 2002:a05:6602:2211:b0:798:3cb5:ad30 with SMTP id n17-20020a056602221100b007983cb5ad30mr2909893ion.7.1695939698157;
        Thu, 28 Sep 2023 15:21:38 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id t23-20020a02c497000000b0042b10d42c90sm4610172jam.113.2023.09.28.15.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 15:21:37 -0700 (PDT)
Date: Thu, 28 Sep 2023 16:21:06 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon
 <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton
 <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, Michael
 Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, Paul
 Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, Claudio
 Imbrenda <imbrenda@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, Peter Zijlstra
 <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Paolo
 Bonzini <pbonzini@redhat.com>, Tony Krowiak <akrowiak@linux.ibm.com>, Halil
 Pasic <pasic@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>, Harald
 Freudenberger <freude@linux.ibm.com>, Andy Lutomirski <luto@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-mips@vger.kernel.org, kvm@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, Anish
 Ghulati <aghulati@google.com>, Venkatesh Srinivas
 <venkateshs@chromium.org>, Andrew Thornton <andrewth@google.com>
Subject: Re: [PATCH 03/26] virt: Declare and define vfio_file_set_kvm() iff
 CONFIG_KVM is enabled
Message-ID: <20230928162106.0b0de53c.alex.williamson@redhat.com>
In-Reply-To: <20230916003118.2540661-4-seanjc@google.com>
References: <20230916003118.2540661-1-seanjc@google.com>
	<20230916003118.2540661-4-seanjc@google.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 15 Sep 2023 17:30:55 -0700
Sean Christopherson <seanjc@google.com> wrote:

> Hide vfio_file_set_kvm() and its unique helpers if KVM is not enabled,
> nothing else in the kernel (or out of the kernel) should be using a
> KVM specific helper.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/vfio/vfio_main.c | 2 +-
>  include/linux/vfio.h     | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)


As Jason noted, s/virt/vfio/ in title.

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 6368eed7b7b2..124cc88966a7 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1352,7 +1352,6 @@ void vfio_device_put_kvm(struct vfio_device *device)
>  clear:
>  	device->kvm = NULL;
>  }
> -#endif
>  
>  static void vfio_device_file_set_kvm(struct file *file, struct kvm *kvm)
>  {
> @@ -1388,6 +1387,7 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
>  		vfio_device_file_set_kvm(file, kvm);
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
> +#endif
>  
>  /*
>   * Sub-module support
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 454e9295970c..e80955de266c 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -311,7 +311,9 @@ static inline bool vfio_file_has_dev(struct file *file, struct vfio_device *devi
>  #endif
>  bool vfio_file_is_valid(struct file *file);
>  bool vfio_file_enforced_coherent(struct file *file);
> +#if IS_ENABLED(CONFIG_KVM)
>  void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
> +#endif
>  
>  #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
>  

