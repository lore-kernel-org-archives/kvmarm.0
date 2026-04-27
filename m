Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBD130DEA6
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 11:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777289791; cv=none; b=kF5WIdhA+zs2Z0KauVon9/8Ka28jfDnjQ/txIu6us1aGjO5v8LGijgfsORn32b6LPmtyeOgaXKB5nmSw2R1o3BOBh/jRtTw6ubJ07WUXBL6YMvz4YBf24hZdZWymSa4nnb//WzOLe4F7OKoIDg/5Yd8j3V9bpIwXjiaSWii6NiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777289791; c=relaxed/simple;
	bh=zChRhxhXTe3rtLHF7cTVBBRIKAVNaXM/phPTRduFOmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mQIrWwYgV8RTRB4GV/sIxr/52Q/uPGPZqPHiAtwCdD0J6ASpO1ksKwBsgNdFyfdMVqTH6PN1yx28Nbb+jhQjEF0+VqQIlOFsd+ViXVmjnmWSmIWFMo3uTK4eEzu5k7keM23BSL22dQ+OFsfnd8bq75Mf71Aa1p290UewCv7UjlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=brxV27xX; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="brxV27xX"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4891ca4ce02so890445e9.1
        for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 04:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777289789; x=1777894589; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KFQ7YWSxQTi8WSuVhErZPiSuizAww+UyP5IWNi9MsWE=;
        b=brxV27xXdy8fML1GK2if2trb+1R9Kf5/CWbp6fU6b1P3wcWqjWvE9Kqjm3RQDX+34J
         /WsH7uiCYLvqjHfbZZyID0zl/BsJLf4E7vXhEQ8IpfpJbtNcp+JYgD35nVnRXS39O3BW
         lVjDtOXWXRXLhRJkh1Mo4/ZTX/5rDROlb4w/9qrr1CXB5D0D9R9r9QaTwqBnKhp3+TVv
         oCSCwTLJpyOPXHRi7wxDB1HJ9aEeDIvLGGQGRJTV29VKTw6I0y36vEYdBvcPOAYiZX4L
         ZXKz3d2V1NaHWJvuTTv1Np1I394/LFvTAfJ//pKce/9Nu7KymnbZCU1UTtvqEI8TRxYz
         jAyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777289789; x=1777894589;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KFQ7YWSxQTi8WSuVhErZPiSuizAww+UyP5IWNi9MsWE=;
        b=A+kMZp6jLPUC1xtgmiQxMma3TSzrPu2fRCSslU46NsAACen4r+b3YgkOQHgtTxQdNA
         TPvVMSp7kLMpdnEH4ooQya3C0/+dwA9OsCWkTb31tRx7+X7DyQLuhihdOkuSm44AAimb
         Cdh7pFurg5IoiDRz9ljZRS+9ykt9dkYTC6ZMv1IfkapSHOTsrdHJJe1i8el//64YYY6J
         VTd/DAlktWVYsa8eJIFmFEjmXvo5hQ2q1/Cj5WL8So8LiGN84CIYXeu1TjpJlSx/COOS
         Oktn6jMqyqn46A3E5pthbhGNPP2yiYq2uWI5JeWnd7Ra5JT/Q2otNYKXjUYDPFywojWo
         /+bw==
X-Forwarded-Encrypted: i=1; AFNElJ9wLNu2h/JkwBR3M79pzkPUIwE5V4Z2h87LtyxD+w1XySRaXDl0YeTm1+O153+dKED2af57D3k=@lists.linux.dev
X-Gm-Message-State: AOJu0YxeToX8EszEgmhzbCLWZigdSOJUFVabPcdAhzUc9391LlCq8swi
	JtRHjYrJYoDqZMmJgT7uRi/WEwlGkUqmr5/Hg1jZ7B1VF7TFAkVWRBp0CR1aBN79Lw==
X-Gm-Gg: AeBDietKkPUbGeqN4S3+Qh9vd3fLnz+uEIl+8nAHhWlBnc82HXQNbdQjR5VNKWQYVPZ
	3fZbzlbufivT/LhIvUWuPFku3fJjsyuLdzbM1OmdlQ26jybnNRZ3MtrPoS4RxFS4u6riOujZI0e
	A6Ww5W3XstlbrJc0QXJYNAWkp1uqU0P9IpwVJHNsW+dUdIcP7L3Vn7YXg0PQyp1ufpUK2PLleZj
	y8paAzCnAS03ErcHneK+8cRtf+d215JABF52z4xh/1kRt/2Co/kFw0U4/rUU1RThkjgDl12bxRb
	Xr+GD9AGMJ9GSRSFPzcwJz6hPsJWgVMiEE9HYjGtx1C3Zyro4rVvZXOP6j5ZGCgih9l46YsA1tA
	7Vtb5CzOjyufiAADgATYUnZvfIsJp4VERqklr0TaPaW69P5sZdnw0yhNKhlZ1b6jXDW1zpA48dL
	Ya/OUwAutiVWxziUjRKofT6RtaqQmviZ2OkV8KT124CMU/7yIjem8vrW4ginDVv5a1+I1c7Vl7e
	IGeVjlcw1Na9Kp+Sz8=
X-Received: by 2002:a05:600c:35c7:b0:48a:5aa3:ac1e with SMTP id 5b1f17b1804b1-48a5aa3ade2mr8143875e9.3.1777289788273;
        Mon, 27 Apr 2026 04:36:28 -0700 (PDT)
Received: from google.com (117.15.199.104.bc.googleusercontent.com. [104.199.15.117])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a575ad67asm400794425e9.2.2026.04.27.04.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 04:36:27 -0700 (PDT)
Date: Mon, 27 Apr 2026 11:36:23 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Sudeep Holla <sudeep.holla@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, oupton@kernel.org, will@kernel.org,
	ayrton@google.com, catalin.marinas@arm.com, joey.gouly@arm.com,
	korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Validate the FF-A memory access descriptor
 placement
Message-ID: <ae9KN9nkOgDYJcGP@google.com>
References: <20260422102540.1433704-1-sebastianene@google.com>
 <86bjfb18v1.wl-maz@kernel.org>
 <aejOu98q1lEZoFfW@google.com>
 <20260422-jolly-curassow-of-amplitude-25fbaf@sudeepholla>
 <aenjvY5VJxFye52e@google.com>
 <20260423-just-mega-starfish-22309c@sudeepholla>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423-just-mega-starfish-22309c@sudeepholla>

On Thu, Apr 23, 2026 at 10:55:34AM +0100, Sudeep Holla wrote:
> On Thu, Apr 23, 2026 at 09:17:49AM +0000, Sebastian Ene wrote:
> > On Wed, Apr 22, 2026 at 08:29:06PM +0100, Sudeep Holla wrote:
> 
> [...]
> 
> > Hello Sudeep,
> > 
> > > That's just the current choice in the driver and can be changed in the future.
> > > 
> > > > and makes use of the same assumption in: ffa_mem_desc_offset().
> > > > https://elixir.bootlin.com/linux/v7.0/source/include/linux/arm_ffa.h#L448
> > > 
> > > Again this is just in the transmit path of the message the driver is
> > > constructing and hence it is a simple choice rather than wrong assumption.
> > >
> > > > The later one seems wrong IMO. because we should compute the offset
> > > > based on the value stored in ep_mem_offset and not adding it up with
> > > > sizeof(struct ffa_mem_region).
> > > > 
> > > 
> > > Sorry what am I missing as the driver is building these descriptors to
> > > send it across to SPMC, we are populating the field and it will be 0
> > > before it is initialised
> > 
> > Right, what I meant is having something like this since this function is not limited
> > to the driver scope and using it from other components would imply relying on the
> > assumption: 'ep_mem_offset == sizeof(struct ffa_mem_region)'. We will also have to validate
> > that the `ep_mem_offset` doesn't point outside of the mailbox designated buffer.
> > 
> 
> Sure, we can extend the function itself or add addition helper to get the
> functionality you are looking for the validation.
> 

Thanks, would it be ok to BUG_ON if the offset is out of range here ?
(we would probably have to pass the size of the buf as well in this
function)

> > ---
> > diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
> > index 81e603839c4a..62d67dae8b70 100644
> > --- a/include/linux/arm_ffa.h
> > +++ b/include/linux/arm_ffa.h
> > @@ -445,7 +445,7 @@ ffa_mem_desc_offset(struct ffa_mem_region *buf, int count, u32 ffa_version)
> >         if (!FFA_MEM_REGION_HAS_EP_MEM_OFFSET(ffa_version))
> >                 offset += offsetof(struct ffa_mem_region, ep_mem_offset);
> >         else
> > -               offset += sizeof(struct ffa_mem_region);
> > +               offset += buf->ep_mem_offset;
> >
> >         return offset;
> >  }
> > ---
> > 
> > And then move `ffa_mem_region_additional_setup` to be called earlier before `ffa_mem_desc_offset`:
> > (so that it can setup the value for ep_mem_offset)
> > 
> > ---
> > diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
> > index f2f94d4d533e..66de59c88aff 100644
> > --- a/drivers/firmware/arm_ffa/driver.c
> > +++ b/drivers/firmware/arm_ffa/driver.c
> > @@ -691,6 +691,8 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
> >         mem_region->flags = args->flags;
> >         mem_region->sender_id = drv_info->vm_id;
> >         mem_region->attributes = ffa_memory_attributes_get(func_id);
> > +
> > +       ffa_mem_region_additional_setup(drv_info->version, mem_region);
> 
> Ah this could do the trick. I need to check if all the usages are covered
> though.
>

I looked a bit at the call paths and I think we can use it like this.
Please let me know if you found it differently. I would like to re-spin
another version of this patch.


> >         composite_offset = ffa_mem_desc_offset(buffer, args->nattrs,
> >                                                drv_info->version);
> >  
> > @@ -708,7 +710,6 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
> >         }
> >         mem_region->handle = 0;
> >         mem_region->ep_count = args->nattrs;
> > -       ffa_mem_region_additional_setup(drv_info->version, mem_region);
> > ---
> > 
> > > 
> > > > Maybe this should be the fix instead and not the one in pKVM ? What do
> > > > you think ?
> > > > 
> > > 
> > > Can you share the diff you have in mind to understand your concern better
> > > or are you referring to this patch itself.
> > 
> > Sure, please let me know if you think this is wrong. I might have misunderstood it. 
> > 
> 
> Nope, the patch helped to understand it quicker. Thanks for that.
> 
> > > 
> > > > The current implementation in pKVM makes use of the
> > > > ffa_mem_desc_offset() to validate the first EMAD. If a compromised host
> > > > places an EMAD at a different offset than sizeof(struct ffa_mem_region),
> > > > then pKVM will not validate that EMAD.
> > > >
> > > 
> > > Calling the host as compromised if it chooses a different offset seems bit
> > > of extreme here. I am no sure if I am missing to understand something here.
> > > 
> > 
> > Sorry for not explaining it, in pKVM model we don't trust the host kernel so
> > we can assume that everything that doesn't pass the hypervisor validation(in
> > this case the ff-a memory transaction) can be a potential attack that wants
> > to compromise EL2.
> > 
> 
> I am aware of the principle in general, but this example with different offset
> can't be assumed as comprised host if the offset + size is well within the
> Tx buffer size boundaries. That should be the way for you to cross check for
> any compromise IHMO.
>

I agree, it cannot be assumed as a compromised host it can be perferctly
normal with another driver that places it at a different offset; that's
why I suggested patching ffa_mem_desc_offset instead and doing the
ep_mem_offset validation there.

> -- 
> Regards,
> Sudeep

Thanks,
Sebastian
