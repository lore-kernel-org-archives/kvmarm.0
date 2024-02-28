Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE403145341
	for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 13:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709127248; cv=none; b=gmwbJ7youuTKF+AaIu+fNF5b+NjAu1FtuORAGwcFREJLRq/2gBwTempd1g10rhMePqbSNrn52zPAjPZ5vxfkoe/gyS7EjPNTJX4uvT3432M4iti7KPh0ldGNNpAMulQIVGRy5rfyO2jjoUHAVYmZ9M0G8yxgPBUANXGq/Il8Dfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709127248; c=relaxed/simple;
	bh=1Z5GEE2jRYHSJRnYC7tg7IxQCI+nfsbBaarFpWs6BV8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I2RQ4w/pvR03quSAWaN0uKdJ1Dx9zfL6k9dB1n8CHEno1/JeQLJIBbAXalKWojLotSb1rlA7yUtNlHVHp06yIpaaHq3zQ5VQQSrL2Z6kIrolOPDanzFpQPwHZJQEGtQ41Q0ketmWm2PouWq7YhlHTCNhuQEpNlsUgDF7by49xmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O3srNkWs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O3srNkWs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709127246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HD7Zn+ooZwqBG8+gZ+aapSG0LC1/KKa9iGT5T2W+rNg=;
	b=O3srNkWswfNet5FUe1Da5F3p3GjtQGFICQ97VBuhoTgNpvSUnCGN0SF/hXkcEhmlWMpYyD
	yC5/tPtg97ymj7y2OZUdMuWDC/COUv43GcjTbR4NBgcfe1rwlwa6BsYx5x/4vKxiG8QFuQ
	Jt4i7qF1QC5vUZkoTq2cTQCYT0bE2H8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-bPI_D54UP_O7rFFUi_0zeA-1; Wed, 28 Feb 2024 08:34:03 -0500
X-MC-Unique: bPI_D54UP_O7rFFUi_0zeA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33dcd5d117fso444515f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 05:34:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709127242; x=1709732042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HD7Zn+ooZwqBG8+gZ+aapSG0LC1/KKa9iGT5T2W+rNg=;
        b=U17rOxwmZa8BwPUKLgHaaGIRN2r1nJHVVXI9pBjR89h6H/ttuieFfywzoYfUOtH3z7
         qxslqU4y0TNKXJg+PLBBquB7DSg722Mex0CzOVxYwHiXstZ/3vpPMHyCmTxkmG5Pwu4n
         bNjoyfB8v59USTIX3V7VulFMjyrne93mUWNwmdSXXFLviw27pYXrx7zRuoU2Yzza5Wfo
         R2ZhtRXJ1c2NrS3e9S6Vn1eNaK/0wnPvSulhqnJFHNzZs1EMo6oUvcnjnq8aOpNN5jeq
         0IZB7Gpu5Oe9FAxzAJxl2qj6V8UrWEfC0NN47dhq3f5T0LKbshIyQtyPh1aIhJa07nC4
         NnLg==
X-Gm-Message-State: AOJu0Yy7WsKx9BgROgYjIRG1seyPvX6gJUpVO9eL32npqxisYnT4mxm6
	h94+kYO3wUOF6XEaSEnAqP0WvP3H7pJsPMU9AfPZkh27+PjoaxOb8zSJWnsE4UxIjHkjD4CvBFS
	OR1j88hl0dMN11Lm6HSTZk+kex0F6uK38198SCTfbeGd5G2e3XGKgo2wKeU9bgP+PdTEqxP4ur3
	UB4FRml5fk8PONRPzXITMakKfcDqE0
X-Received: by 2002:a5d:4688:0:b0:33d:63b6:defd with SMTP id u8-20020a5d4688000000b0033d63b6defdmr2362104wrq.31.1709127242180;
        Wed, 28 Feb 2024 05:34:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEtd2tk6xgK4hLDCtzHuf402VyxUlubL2Xe7rXGKCIAn572NNPGmDD2cCArVWu4nLnU9YuNdDYNkGJjwt1sgKw=
X-Received: by 2002:a5d:4688:0:b0:33d:63b6:defd with SMTP id
 u8-20020a5d4688000000b0033d63b6defdmr2362079wrq.31.1709127241873; Wed, 28 Feb
 2024 05:34:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240227224249.2209194-1-oliver.upton@linux.dev> <20240227224249.2209194-2-oliver.upton@linux.dev>
In-Reply-To: <20240227224249.2209194-2-oliver.upton@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 28 Feb 2024 14:33:50 +0100
Message-ID: <CABgObfY=fLa2aDBEHBvnhATHdsVyJX7Mx6q3gLRCAUMaYh3=zw@mail.gmail.com>
Subject: Re: [PATCH 01/20] KVM: Treat the device list as an rculist
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Eric Auger <eric.auger@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 27, 2024 at 11:43=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
> A subsequent change to KVM/arm64 will necessitate walking the device
> list outside of the kvm->lock. Prepare by converting to an rculist.
> Note that this has zero effect the destruction path, as every reader
> should be protected by a valid reference on the KVM struct.
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Acked-by: Paolo Bonzini <pbonzini@redhat.com>


> ---
>  virt/kvm/kvm_main.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c681149c382a..a1423f8064b0 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1326,10 +1326,12 @@ static void kvm_destroy_devices(struct kvm *kvm)
>         /*
>          * We do not need to take the kvm->lock here, because nobody else
>          * has a reference to the struct kvm at this point and therefore
> -        * cannot access the devices list anyhow.
> +        * cannot access the devices list anyhow. Furthermore, there are =
no RCU
> +        * readers after the last reference is dropped, so there is no ne=
ed to
> +        * defer destruction until a grace period has elapsed.
>          */
>         list_for_each_entry_safe(dev, tmp, &kvm->devices, vm_node) {
> -               list_del(&dev->vm_node);
> +               list_del_rcu(&dev->vm_node);
>                 dev->ops->destroy(dev);
>         }
>  }
> @@ -4781,7 +4783,7 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
>                 kfree(dev);
>                 return ret;
>         }
> -       list_add(&dev->vm_node, &kvm->devices);
> +       list_add_rcu(&dev->vm_node, &kvm->devices);
>         mutex_unlock(&kvm->lock);
>
>         if (ops->init)
> --
> 2.44.0.rc1.240.g4c46232300-goog
>

