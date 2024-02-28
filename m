Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66347FBD7
	for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 17:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709140712; cv=none; b=GjuJfQ8CCLFA9oNaAieJCdTJaGe+20SsTqD69KbPDuEJAab5gjjMM7judrzR4LTHBbTtqWcSn8qmS7pHhdrigUKmDYHMH0dvgzF1LLQPfESy/4GlB/+M7Qg6evPMbzhQ3hfqmx4MJRv+fTafa3SZmRWvJScwX4C68kD128Db6Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709140712; c=relaxed/simple;
	bh=gdFLQtxmNl1zgubYebAtGvBdFMcqW1L9ozD/jkqzkA0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uDX3101aKPcjCFJNjYQJOxwEidIdWEJowbyI/pGYZ07rTaXpiuU+DAIpgcNG46VtSwDHQpFxmWtsmNEscGsRoKGINwA5ZO7InBYl8u63iEY5a6QtFuQ50mr1BbciN36Q0Gc3hT09jH6nIdoLdOtOfnfOkCXmphwGXdsBsREK00g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ozciiPZz; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ozciiPZz"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e4867c8ea5so4703477b3a.1
        for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 09:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709140710; x=1709745510; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Wwd3A5xmYab7uI61nAv21c7S/JtMuKnzWjHlvyxvYw=;
        b=ozciiPZzjWhI2ZBdD23LdEx0olAf7267hjweyS90FSIhPEcyKIwXBPt5KqfW3/YDrz
         Xzn8m2JsszS94lovlBP0xG6CbFMYPGKxGIbb51htiurTNg0RcsfcFHQqrb+RW1vE/s/B
         NM+i4gf3SDtTavEoKqZQ2O4qoCMvrdC3QJvLlHGQ8S2r1+EvsH3Deav4gllFuu7bs1Rt
         h4iBc8wdbv5a8Loh8+yJc5IFK0EwRjGEw6X89rP2pJy4SUIwyWo29HNsAUhq34hwP5Nj
         Rlr6OXSe+pRWCCj3t+qHXHHlt7/YZ53x4sGAh6ZP9y3FExq02EKJsCahXvlb8PcR7Nh0
         RrDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709140710; x=1709745510;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Wwd3A5xmYab7uI61nAv21c7S/JtMuKnzWjHlvyxvYw=;
        b=n9fr2eGrICy59PAgjoAH+j5N1tK22t6bTRazj2pM6cfkwfJ/va+rt3ZstwzwB3Z4ok
         x7jzNjfGppl0JfBUDFAJFwMXsjVcja3SjPgDs901ub/iCLATseLbgaWnlnvpBybn4b6f
         cDvArl2OByruwse3w0RMngZ4uX+XptDLWN1iXXN4XFRqyxey26cbLMFzOm19Wwugi4li
         wAOW/URcVhv6zc6j7AQlxBdFTfXciinDiDWnmNoo75D/MKnc9Rfnqx5YrOkYlA0OdTV8
         xsPOMd78ow+xDBYlHJva2pl7ibSQLxgj5CRdna9GIXHN9zHmlm3gY0RUWqtxIWM5CNGl
         la1A==
X-Gm-Message-State: AOJu0YxlzGNNuimMFfYgQcGn3ssR+AxXoy0IUftOttR188IFuXnkQy51
	WL3G94Nl32rmPfzBY4rXVGFHz6bE2l06BAyntmB1s6x/KE2ipZZIpn+ggKjNfUhZMn++avw/OQM
	7xg==
X-Google-Smtp-Source: AGHT+IHY3hfhNXeDtGP5NSA8+7LCTeObrtBft8/FQQX9fhmX2SiBjzDhRINwSxhE4e/94bcjHFqUyUh+s9Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1801:b0:6e5:3b98:b545 with SMTP id
 y1-20020a056a00180100b006e53b98b545mr10648pfa.1.1709140710076; Wed, 28 Feb
 2024 09:18:30 -0800 (PST)
Date: Wed, 28 Feb 2024 09:18:28 -0800
In-Reply-To: <20240227224249.2209194-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240227224249.2209194-1-oliver.upton@linux.dev> <20240227224249.2209194-2-oliver.upton@linux.dev>
Message-ID: <Zd9q5KbkLnh5Wddf@google.com>
Subject: Re: [PATCH 01/20] KVM: Treat the device list as an rculist
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Eric Auger <eric.auger@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 27, 2024, Oliver Upton wrote:
> A subsequent change to KVM/arm64 will necessitate walking the device
> list outside of the kvm->lock. Prepare by converting to an rculist.
> Note that this has zero effect the destruction path, as every reader
> should be protected by a valid reference on the KVM struct.

This should leave the destruction path alone then.  Simply using list_del_rcu()
doesn't convert this to an rculist, you need to actually synchronize against RCU
for this to have any meaning/protection.  The above alludes to this, and the
comment in kvm_destroy_devices() helps a little, but the code itself is actively
misleading.

I don't know how I feel about using list_add_rcu() in combination with list_del(),
but I like it a lot better than using list_del_rcu() in a way that is blatantly
wrong.

So if we don't have a better option, I would much rather do only the list_add_rcu(),
and add a comment _there_ explaining why KVM inserts with RCU protection, but
frees using regular ol' list_del().

> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  virt/kvm/kvm_main.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c681149c382a..a1423f8064b0 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1326,10 +1326,12 @@ static void kvm_destroy_devices(struct kvm *kvm)
>  	/*
>  	 * We do not need to take the kvm->lock here, because nobody else
>  	 * has a reference to the struct kvm at this point and therefore
> -	 * cannot access the devices list anyhow.
> +	 * cannot access the devices list anyhow. Furthermore, there are no RCU
> +	 * readers after the last reference is dropped, so there is no need to
> +	 * defer destruction until a grace period has elapsed.
>  	 */
>  	list_for_each_entry_safe(dev, tmp, &kvm->devices, vm_node) {
> -		list_del(&dev->vm_node);
> +		list_del_rcu(&dev->vm_node);
>  		dev->ops->destroy(dev);
>  	}
>  }
> @@ -4781,7 +4783,7 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
>  		kfree(dev);
>  		return ret;
>  	}
> -	list_add(&dev->vm_node, &kvm->devices);
> +	list_add_rcu(&dev->vm_node, &kvm->devices);
>  	mutex_unlock(&kvm->lock);
>  
>  	if (ops->init)
> -- 
> 2.44.0.rc1.240.g4c46232300-goog
> 
