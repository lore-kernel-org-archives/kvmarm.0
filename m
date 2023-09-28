Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEDE31A9A
	for <kvmarm@lists.linux.dev>; Thu, 28 Sep 2023 22:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695939706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yJlZv5KfytnzZmRqZMI7mLTWvvegYQeNtr0CrdJHxrc=;
	b=Ez/Uh1kmKg7MrjRNPCLulA36pOVjQ5gy+yOz1Jj2F1p7YDVNjgYUbnohzK5m8M6UMihyZI
	5Nir5HLf1gp7t9/HQZBBB6HClzl4nxU3aSfeXGRqbjnDrAU/ebPMJyYLmqfB83zPhdfkUg
	YN8894ftLye1JsVY6MxPTN61qhGbvyI=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-0-UW8bgmNgS7Q-zSDe_zFQ-1; Thu, 28 Sep 2023 18:21:45 -0400
X-MC-Unique: 0-UW8bgmNgS7Q-zSDe_zFQ-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-79fc8c8b1dbso1190256239f.2
        for <kvmarm@lists.linux.dev>; Thu, 28 Sep 2023 15:21:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695939704; x=1696544504;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yJlZv5KfytnzZmRqZMI7mLTWvvegYQeNtr0CrdJHxrc=;
        b=DRmRajBiIbeyjtv9Hay/xrztjW3JlMcwKimGZiQQ+LRZCaaGTT1OwLMclwloh9kwv0
         vT+BCOFvsuO8xD6K8aJCZ5yFbUS6s04kcJYkGVn6xLc/vLZyfRgS7bAPCB/8V4Mupxnk
         V3IRZMfJWEJuUflMoe8SI396hngsadECdQ9q5SNeV94gHillwa47VaZVAU+sdBDHsOUT
         eraZ4jOjhYZDAOfcChlqy5ir1fuLfcBAgEFnIZ6q3nTJwKWgF0+xQAvrXukQNkxL/bQ9
         y61wo5d6Pw/xAPSA6XHjluwZP9scyCxyEpj09vRFCdqLKsmRRxJb/jLih8iz6mfb06xD
         7XvQ==
X-Gm-Message-State: AOJu0YxJ1h6L+fOUVfYMnCL0ZkkRBn8XR0iHHZmz3YK7ftSgUk2fyPmF
	5F76B/hc1zGiPl+1cWdDrojnczbmeb33b3Ebpbx3d61R8/o6A7OWyuYy5Xxa/w7wq5EaPwZVHzF
	120HkdVsEN+ShHx2C
X-Received: by 2002:a5e:9e09:0:b0:795:8805:1378 with SMTP id i9-20020a5e9e09000000b0079588051378mr2451951ioq.9.1695939704279;
        Thu, 28 Sep 2023 15:21:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGAEb9IDAtgYjj6uLy0BK3ZEot+uDPg45XlWdcKZXMCg89/F3JSTuwB2CMQYAcH0oVDsnNUFw==
X-Received: by 2002:a5e:9e09:0:b0:795:8805:1378 with SMTP id i9-20020a5e9e09000000b0079588051378mr2451906ioq.9.1695939703976;
        Thu, 28 Sep 2023 15:21:43 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id t23-20020a02c497000000b0042b10d42c90sm4610172jam.113.2023.09.28.15.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 15:21:42 -0700 (PDT)
Date: Thu, 28 Sep 2023 16:21:05 -0600
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
Subject: Re: [PATCH 02/26] vfio: Move KVM get/put helpers to colocate it
 with other KVM related code
Message-ID: <20230928162105.2e347cd5.alex.williamson@redhat.com>
In-Reply-To: <20230916003118.2540661-3-seanjc@google.com>
References: <20230916003118.2540661-1-seanjc@google.com>
	<20230916003118.2540661-3-seanjc@google.com>
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

On Fri, 15 Sep 2023 17:30:54 -0700
Sean Christopherson <seanjc@google.com> wrote:

> Move the definitions of vfio_device_get_kvm_safe() and vfio_device_put_kvm()
> down in vfio_main.c to colocate them with other KVM-specific functions,
> e.g. to allow wrapping them all with a single CONFIG_KVM check.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/vfio/vfio_main.c | 104 +++++++++++++++++++--------------------
>  1 file changed, 52 insertions(+), 52 deletions(-)


Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 80e39f7a6d8f..6368eed7b7b2 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -381,58 +381,6 @@ void vfio_unregister_group_dev(struct vfio_device *device)
>  }
>  EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
>  
> -#if IS_ENABLED(CONFIG_KVM)
> -void vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm)
> -{
> -	void (*pfn)(struct kvm *kvm);
> -	bool (*fn)(struct kvm *kvm);
> -	bool ret;
> -
> -	lockdep_assert_held(&device->dev_set->lock);
> -
> -	if (!kvm)
> -		return;
> -
> -	pfn = symbol_get(kvm_put_kvm);
> -	if (WARN_ON(!pfn))
> -		return;
> -
> -	fn = symbol_get(kvm_get_kvm_safe);
> -	if (WARN_ON(!fn)) {
> -		symbol_put(kvm_put_kvm);
> -		return;
> -	}
> -
> -	ret = fn(kvm);
> -	symbol_put(kvm_get_kvm_safe);
> -	if (!ret) {
> -		symbol_put(kvm_put_kvm);
> -		return;
> -	}
> -
> -	device->put_kvm = pfn;
> -	device->kvm = kvm;
> -}
> -
> -void vfio_device_put_kvm(struct vfio_device *device)
> -{
> -	lockdep_assert_held(&device->dev_set->lock);
> -
> -	if (!device->kvm)
> -		return;
> -
> -	if (WARN_ON(!device->put_kvm))
> -		goto clear;
> -
> -	device->put_kvm(device->kvm);
> -	device->put_kvm = NULL;
> -	symbol_put(kvm_put_kvm);
> -
> -clear:
> -	device->kvm = NULL;
> -}
> -#endif
> -
>  /* true if the vfio_device has open_device() called but not close_device() */
>  static bool vfio_assert_device_open(struct vfio_device *device)
>  {
> @@ -1354,6 +1302,58 @@ bool vfio_file_enforced_coherent(struct file *file)
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
>  
> +#if IS_ENABLED(CONFIG_KVM)
> +void vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm)
> +{
> +	void (*pfn)(struct kvm *kvm);
> +	bool (*fn)(struct kvm *kvm);
> +	bool ret;
> +
> +	lockdep_assert_held(&device->dev_set->lock);
> +
> +	if (!kvm)
> +		return;
> +
> +	pfn = symbol_get(kvm_put_kvm);
> +	if (WARN_ON(!pfn))
> +		return;
> +
> +	fn = symbol_get(kvm_get_kvm_safe);
> +	if (WARN_ON(!fn)) {
> +		symbol_put(kvm_put_kvm);
> +		return;
> +	}
> +
> +	ret = fn(kvm);
> +	symbol_put(kvm_get_kvm_safe);
> +	if (!ret) {
> +		symbol_put(kvm_put_kvm);
> +		return;
> +	}
> +
> +	device->put_kvm = pfn;
> +	device->kvm = kvm;
> +}
> +
> +void vfio_device_put_kvm(struct vfio_device *device)
> +{
> +	lockdep_assert_held(&device->dev_set->lock);
> +
> +	if (!device->kvm)
> +		return;
> +
> +	if (WARN_ON(!device->put_kvm))
> +		goto clear;
> +
> +	device->put_kvm(device->kvm);
> +	device->put_kvm = NULL;
> +	symbol_put(kvm_put_kvm);
> +
> +clear:
> +	device->kvm = NULL;
> +}
> +#endif
> +
>  static void vfio_device_file_set_kvm(struct file *file, struct kvm *kvm)
>  {
>  	struct vfio_device_file *df = file->private_data;

