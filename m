Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A458827
	for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 18:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713810626; cv=none; b=UTSHxvKjEZIVwzjG0eIgv3TmMVWR5MPehx/3mdO/UUCfUSEyp+4i/+vifFJjLPI2n/G3+be4XDGaRtrn32/0SnxbgkMKUTRetQVHxhb2WTZmlLajn/R4KLOo4tHC1FVunUulND7aKfw6GsQe1hs8WSQivA1A8HeBabClKarIdDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713810626; c=relaxed/simple;
	bh=DQ4Fn6q/0TNojemjb6hW6j9mstuaSTf5i1k+JmHPZ1k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QtepR1bP3c2Gpi31CMXu1SRu5L2DGSMX7CSorXIvbsCTqWcqmTNSy9XKLyatXUo3efWLO+i3o5GnecJU9hZR4wFW8UVNEAPIXf076gKT5Wpq8Jk3vwHyVR2vA34f+AbwMIxnaOPixrdZbw0tfopGIXHnXCD3IZ0wdmmzG6iyW5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q364A3oR; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q364A3oR"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1e63ff880f5so67637265ad.1
        for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 11:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713810623; x=1714415423; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mu09QDEhK0ai6SdBoOYXj+wDztE4co8vi9Lh3C9vaD4=;
        b=q364A3oRC/HLTOukD7B1eXw2Yr7GbpObHMc/vWZYSLBuPFC+8AUPIw62lhBGn1O3Tm
         rhaG1/DQrAudHwyXvrhCo8ZnE1h9pHrDYXFXCwglhXRP0koB85ggnTLTMCUdAwP+8rZ9
         iMPEf7MthgeKyFox0+4SNSXbmbTn/PVG/NI6CbojeV07+OaPq+53sneD/LVv1fADkTkN
         ZlLwBBU/cYN1cjJVS0Qvoyr43Lwm8rP1+puh1p0MAssrWbeW9SHrNI70cO9Aa34zTk02
         vDD7jTWrJ3o0fujN5DYSVYn78RNoOSQEqXCPfDUvGNEqll0fE4zkzGSAIvoEcV8H++2D
         aWMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713810623; x=1714415423;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mu09QDEhK0ai6SdBoOYXj+wDztE4co8vi9Lh3C9vaD4=;
        b=r+nlNFtfqp98hxgqBQu3GD7EiJ6De9ghx9dzB4HNhAhVj3TIMvkC47EGa82b+nXfWW
         fHr9JiIAwAqWViOqMzzG0/l0S2wnKabdQTsHTW0sypkAr5Agkx+Ary0vUaVA+8Gl1XZC
         HZYaBTCo83ywJuRZBjTvw0nnGl/F6fDgiCSDZqHUY4mczOioU7qG4g0nqo0RAFCljx5A
         UFO0lM98m9f3ldtkpN1xbrI34ly+5gKK7ZyLHbETn2tjoAJSgxmKMgAO/Y1+Bsoyd0vl
         uoBsURbnDjBedvlxgUrXu8c1B0iTDJMG6u6FOt5nGPYDOFl5KgClA9N+le0vOLGAfC+f
         oX2g==
X-Gm-Message-State: AOJu0YzSv+VJssd/oPI8stEs7GzMNeUW5W1/FBlaq6eTsfTfaNwsyhBL
	I+AR3+tXwyaWzxEGD7kMmhWeLxqhqDkweg88D7T1D2bHO/zgtjSMCENxMwTAS75Ji6ihDQx0gZu
	00g==
X-Google-Smtp-Source: AGHT+IHHJ6kgJ5nuB8UUXK/hrJ0fV5SVk897Itn1HAKoNGNYO9jR68U2TIUZajuI6J/OKiEeMPn/AsB9J/I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea0f:b0:1e4:5973:dbdc with SMTP id
 s15-20020a170902ea0f00b001e45973dbdcmr1139163plg.7.1713810623229; Mon, 22 Apr
 2024 11:30:23 -0700 (PDT)
Date: Mon, 22 Apr 2024 11:30:21 -0700
In-Reply-To: <20240419223842.951452-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419223842.951452-1-oliver.upton@linux.dev> <20240419223842.951452-2-oliver.upton@linux.dev>
Message-ID: <ZiasvXKbunQwDgJ6@google.com>
Subject: Re: [PATCH v2 01/19] KVM: Treat the device list as an rculist
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Eric Auger <eric.auger@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 19, 2024, Oliver Upton wrote:
> A subsequent change to KVM/arm64 will necessitate walking the device
> list outside of the kvm->lock. Prepare by converting to an rculist. This
> has zero effect on the VM destruction path, as it is expected every
> reader is backed by a reference on the kvm struct.
> 
> On the other hand, ensure a given device is completely destroyed before
> dropping the kvm->lock in the release() path, as certain devices expect
> to be a singleton (e.g. the vfio-kvm device).

Oof, that vfio-kvm code is nasty.  To help prevent future breakage, and to make
it more obvious that this code *doesn't* introduce a bug in kvm_vfio_create(),
what about added a lockdep assertion?

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index ca24ce120906..bd9348a9fe33 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -366,6 +366,8 @@ static int kvm_vfio_create(struct kvm_device *dev, u32 type)
        struct kvm_device *tmp;
        struct kvm_vfio *kv;
 
+       lockdep_assert_held(dev->kvm->lock);
+
        /* Only one VFIO "device" per VM */
        list_for_each_entry(tmp, &dev->kvm->devices, vm_node)
                if (tmp->ops == &kvm_vfio_ops)
