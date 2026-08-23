Received: from mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8921286D4D
	for <kvmarm@lists.linux.dev>; Sun, 23 Aug 2026 14:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787493608; cv=none; b=rpX4mVe3Gh/Kq6PZofs6HMQm9MisPOi1LpsSKdovSytyhQuJi9cHh/cbGJ2CWI5riTcIASoZLOdwsNuUDZaaMAZ1aJ6pmAqexN5qnIy7ZZjLV5Ese7440js//mcsDcttrZCB6iLefulGqtXQ6MnNxpK3CYVLnR+vdIzMaCGrX+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787493608; c=relaxed/simple;
	bh=ZHQPcbpeluN4Ir2HuHNeiOJd/qgEjE5WelnXY52IcA4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d+0z7IhyTruumpl+j0BH8KPOyUuCdI8hJaDP6XBl3+ldzmdnGkHoe7beSXJkiEGrBDWoAuRyhTYjRyy5rc7eEcMY6oyEGRErZ1Rbxb6SfqKVbN8oZd9ganC2siQDiqs3JEfS1VrWwxsbtu0FM3lmZrEmE/gGWZSdxkz578lHDYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pSKQjjdx; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pSKQjjdx"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ZHQPcbpeluN4Ir2HuHNeiOJd/qgEjE5WelnXY52IcA4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787493601; v=1; x=1788098401;
 b=pSKQjjdx1N81olxWD5dBnB5uwb6DHq8Zj0K3eqq+zHnNxIPF0W6fGATszqnm3R+SYzfGp0ul
 rAqlqUaqsKITgg/iiksxGkIKYqzCfPCUQQInTjkmAewgZCidpy//3O2GV8xpeezWUsorUSE6W4B
 rW5Bw0TTNPjuR5AyBRFhe7R0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f45.google.com (209.85.167.45)
	by smtp.migadu.com with ESMTPS id 59e22e0dfe14d2be;
	Sun, 23 Aug 2026 14:00:01 +0000
X-Mizu-Trace-ID: 59e22e0dfe14d2be
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5b2a8173142so5203e87.1
        for <kvmarm@lists.linux.dev>; Sun, 23 Aug 2026 06:59:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqFjfJ3VDDZOt05Hc+ULyNzdmS9BsfoLmU56J4Cr/OvJHPqwlyoc3qYgmOzkJ0bUthUvIdR+4A=@lists.linux.dev
X-Gm-Message-State: AFuF++myHDCi0jUoep/zRBL1uYM5byntVFMBYtFMdPTo1jv1r0whb0s7
	OL2DW9qMuZ1EWJIORSFGDBx5Xsso5XXldGGRP7xcoqPMOUvgLQwzlOqC1pFZ80Y5aPpWmUxFBmH
	8bPheDAvBPir0fp696nsluOHwfsL1C6VZZMFLARCu
X-Received: by 2002:a05:6512:23a5:b0:5a4:ec:53d9 with SMTP id
 2adb3069b0e04-5b48c2f7891mr125883e87.1.1787493596422; Sun, 23 Aug 2026
 06:59:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260820125053.2951078-1-fuad.tabba@linux.dev>
 <20260820125053.2951078-2-fuad.tabba@linux.dev> <20260820130616.1A7241F000E9@smtp.kernel.org>
 <CA+EHjTzf4C6bdwTGWNN1HeapFWEFWm-AJtxi5gQKHekRS2n8Aw@mail.gmail.com> <87ik51np8e.wl-maz@kernel.org>
In-Reply-To: <87ik51np8e.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 23 Aug 2026 14:59:20 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyaKjHpBHG3ZmwTPj93wZLa5pSVzYNT6YpboE40NaDERA@mail.gmail.com>
X-Gm-Features: AcwNN1XBeF4e-msnXL6i8e5TMflxrBt2ySrg3N_SRZJ1SYji8_1wNHZKc6XIADQ
Message-ID: <CA+EHjTyaKjHpBHG3ZmwTPj93wZLa5pSVzYNT6YpboE40NaDERA@mail.gmail.com>
Subject: Re: [PATCH 1/3] irqchip/gic-v4: Clear the domain and fwnode pointers
 after freeing them
To: Marc Zyngier <maz@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Sun, 23 Aug 2026 at 10:44, Marc Zyngier <maz@kernel.org> wrote:
...
> > The actual patch would factor the shared teardown tail into a helper
> > rather than duplicate it.
> >
> > If you (Marc) agree, I'll send this as a separate patch (after testing
> > it), or as part of a possible respin in a couple of days.
>
> Why isn't this as simple as:
>
> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
> index ed236f083f0d7..57a16530801c0 100644
> --- a/arch/arm64/kvm/vgic/vgic-v4.c
> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
> @@ -333,6 +333,8 @@ void vgic_v4_teardown(struct kvm *kvm)
>                 free_irq(irq, vcpu);
>         }
>
> +       /* Make sure we free all VM-wide, per-CPU resources */
> +       its_vm->nr_vpes = aromic_read(&kvm->online_vcpus);
>         its_free_vcpu_irqs(its_vm);
>         kfree(its_vm->vpes);
>         its_vm->nr_vpes = 0;

With the typo fixed, it is ;), but on top of patch 3 of this series.
Without that, a vgic_init() failing after vgic_v4_init() succeeded
leaves the vPE array behind while precreate still admits vCPUs, so
online_vcpus can outgrow the array. If you agree, I'll add it after
patch 3, noting the dependency in the commit message when I respin.

Separately, and I might be missing something: is there anything
stopping KVM_CREATE_VCPU from running concurrently with vgic_init()?
Coming from KVM_DEV_ARM_VGIC_CTRL_INIT it makes the same
created_vcpus/online_vcpus comparison as kvm_vgic_create(), but under
the config_lock alone, where kvm_vgic_create() holds kvm->lock and the
vCPU mutexes too. And precreate admits vCPUs until dist->initialized
is set at the end, so if one lands in the middle, vgic_v4_init() sizes
vpes[] from one read of online_vcpus and fills it from another. If
there isn't, I'll send a fix as a separate patch.

Cheers,
/fuad

> Thanks,
>
>         M.
>
> --
> Jazz isn't dead. It just smells funny.
