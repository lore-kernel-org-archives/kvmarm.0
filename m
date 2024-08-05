Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6ADF1662FA
	for <kvmarm@lists.linux.dev>; Mon,  5 Aug 2024 22:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722895766; cv=none; b=Z1eQbxHUND/60+bPpjaHWXI6q+lgNzmpF7FSvJiBRdf5JH4LTzQAkK/iwGMeB8h6IzVKHBDVUQASlfafSgrH76G0ehhByfZ4kZrFpSixGXOvvcIy9iNnFI7LTXNJWX5Vb5dahfkEIcV3pDEf6x5RZbuXGJDfN0GJIjRmbbn5zYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722895766; c=relaxed/simple;
	bh=dmDvoV7DR66fW1rp/kKa2yAHHnKdcTd2T9VoWrRsnCs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=povm9c9ikSFINb+N4HVj39onMtyg4cXkleLUL6jo7rDP1TRqe+TPIGh3CTxA0U+iZz+8rIxG/UbtOZh1mpG60MneGlqcIsB6navUH0+gTY6jEn2mxu1L4Xn0EhUgBvf+Gjv+pKQwRTerBlMoPQ+/2vtGe7zBFg3vEOpDZ3dxCGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DLw/Q3TY; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DLw/Q3TY"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70d1c8d98baso10003219b3a.3
        for <kvmarm@lists.linux.dev>; Mon, 05 Aug 2024 15:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722895763; x=1723500563; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C2PiU8MTrEuvmn4oJRZEcNoPreaY/lLc5L+V0JuLroE=;
        b=DLw/Q3TYHOirric0vxX16GEYtS/bNyLHuuPbuRjWd7vbxaWjxtCg8YFmRPQWSW08PC
         GTR22DAGBFzMK/xZp+nc1aLRxigiWszgBXKy8cch22DiY1gN4CBSE2DFMOPRJhLAG+CY
         nP2bSAiy+Uvb9N5p63WgtYkmEhleGDywDvhbRI7F0umGday5nBVtqA4rFl3Ka5UQcoM8
         z2cBYZZANu9HXOrf7w80mNuV96/9mTqQNkk/JpvT+pWa+59UKRU328s0X7qjSRmKqBoS
         71LTFs4D4b8U3dXF5hFmkL2732Z1fT7TZKCtzkB5QyX10DW2p2GYXskyvtXZvMWoSkCM
         BhxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722895763; x=1723500563;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C2PiU8MTrEuvmn4oJRZEcNoPreaY/lLc5L+V0JuLroE=;
        b=h+jCqnOMp7kMd7mYFyO+6T+pCBaoWYL08zToXSFW9IwDTkpfE5FtxnHaKgf7Rvglkb
         gw4g/JpJYjnUT3C8g86BqlqbR2xAJuaoLYi4rex+qS5pbTWpufVyfJVPQulSZ0xME5CV
         W5XJCUfqALCFGVzF7/Mjo3yup7/SnEob19k8PTxjA3CK8IUqIkaraZlWxwhBd938UWfX
         sCeLYE6gtN4LHKgFRIY2da01gmaZrqzhcMvA/DUnDm5farlTCEHIa+Ylo5KQLeKJOkmw
         vliJTefsbgyDTM8IItrOOtqsYVHs/4LQxjCEauoM1IGIvHFgS0hZ/sXcb7/583thRamB
         /9HQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2Eb+pFOm3t7RAaXZ1WPslqj3rBAmIS0Oudw8m2YmY7B+pRVqzgwFZAMV7SY8mcPYvOGZNKD/+2kehshaPT6jWXk+BK4JG
X-Gm-Message-State: AOJu0YxTojHudsl8QFbbAkxPFcUXIHaXYMvrkK2Gl5w0Jegpxrzqr8x9
	ul9ayCwshFO4Y0xyQIkKJLOKsoXVXHDLRTrqxyqaTw7WtEXZuoLj2V3Z0EhDGTbPUvTK4dgn4Ev
	oVA==
X-Google-Smtp-Source: AGHT+IFHGqnQ2aZELEsNF/YUFUu/OdaSqANvJ2o5+KNT08fnEczrxRkzi5g08NacDnyiiIzp3YSr6oxKzK4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f0e:b0:710:4d08:e41f with SMTP id
 d2e1a72fcca58-7106d08296emr87588b3a.4.1722895762937; Mon, 05 Aug 2024
 15:09:22 -0700 (PDT)
Date: Mon, 5 Aug 2024 15:09:21 -0700
In-Reply-To: <yq5a5xsftna9.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-3-seanjc@google.com>
 <yq5aikwku25o.fsf@kernel.org> <ZqvNekQAjs-SN-se@google.com> <yq5a5xsftna9.fsf@kernel.org>
Message-ID: <ZrFNkSU4-0Hli7JC@google.com>
Subject: Re: [PATCH v12 02/84] KVM: arm64: Disallow copying MTE to guest
 memory while KVM is dirty logging
From: Sean Christopherson <seanjc@google.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 05, 2024, Aneesh Kumar K.V wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Thu, Aug 01, 2024, Aneesh Kumar K.V wrote:
> >> Sean Christopherson <seanjc@google.com> writes:
> >> 
> >> > Disallow copying MTE tags to guest memory while KVM is dirty logging, as
> >> > writing guest memory without marking the gfn as dirty in the memslot could
> >> > result in userspace failing to migrate the updated page.  Ideally (maybe?),
> >> > KVM would simply mark the gfn as dirty, but there is no vCPU to work with,
> >> > and presumably the only use case for copy MTE tags _to_ the guest is when
> >> > restoring state on the target.
> >> >
> >> > Fixes: f0376edb1ddc ("KVM: arm64: Add ioctl to fetch/store tags in a guest")
> >> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> >> > ---
> >> >  arch/arm64/kvm/guest.c | 5 +++++
> >> >  1 file changed, 5 insertions(+)
> >> >
> >> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> >> > index e1f0ff08836a..962f985977c2 100644
> >> > --- a/arch/arm64/kvm/guest.c
> >> > +++ b/arch/arm64/kvm/guest.c
> >> > @@ -1045,6 +1045,11 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> >> >  
> >> >  	mutex_lock(&kvm->slots_lock);
> >> >  
> >> > +	if (write && atomic_read(&kvm->nr_memslots_dirty_logging)) {
> >> > +		ret = -EBUSY;
> >> > +		goto out;
> >> > +	}
> >> > +
> >> >
> >> 
> >> is this equivalent to kvm_follow_pfn() with kfp->pin = 1 ?
> >
> > No, gfn_to_pfn_prot() == FOLL_GET, kfp->pin == FOLL_PIN.  But that's not really
> > relevant.
> 
> What I meant was, should we consider mte_copy_tags_from_user() as one
> that update the page contents (even though it is updating tags) and
> use kvm_follow_pfn() with kfp->pin = 1 instead?

Yes, that's my understanding as well.  However, this series is already ludicruosly
long, and I don't have the ability to test the affected code, so rather than blindly
churn more arch code, I opted to add a FIXME in patch 76 instead.

https://lore.kernel.org/all/20240726235234.228822-76-seanjc@google.com
