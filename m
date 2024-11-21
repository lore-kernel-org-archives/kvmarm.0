Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BC42628D
	for <kvmarm@lists.linux.dev>; Thu, 21 Nov 2024 13:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732195867; cv=none; b=ShHPSmVxGoYEW8LO0+0F6swkqOCe5QWB2kBR8xCi8s0SNyt+14irGT85E3e2eJ0usuCPyayD0WdYJgoRuY7s8vBmRCcCNen6z7H5riroMPL+hhbqdJflRP1gCRSQbDFOpNudVsLOLNNSAvmpTPGiAyitOa2fS6iVGJ+fd/Ug/GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732195867; c=relaxed/simple;
	bh=166Tl1sVxhcT+YWie6DXtC1yX2qrj0utcgMeq/Ibp4A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ONVz65B3rG6OgWpOrqA4oFnXxXTVJKDFtaEAsDtlvmLx8J5a/KeQSTZomoP43pba/XSpkK4qqlQOlBiJ7V3bWNYc1rw7hmMS8w8/HpZ6868JZyGOmXKxS3O1JKhTynImYrDsdmdLqFxThlRFWWN2i1eqkBngxj7kUDcEJtHhZPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kU8f/f72; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kU8f/f72"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4315ee633dcso42595e9.1
        for <kvmarm@lists.linux.dev>; Thu, 21 Nov 2024 05:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732195864; x=1732800664; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w8uJwMTi4570DKam76I3XnvJS8bhpJu1dkIBLmqzP84=;
        b=kU8f/f72uI51jbC0rGSJl6BrafcBkNwD4vxOHoTQZqyetwLgA/nZufKxsYPhgP1GdU
         I7NiBXn1IwIeXub6kKdyLwgLNnE73RapWYM3RioywFs0jZs/id1TAiCkxC6+wHKkvfbP
         aKzL6b/RjW9qy1ZccY4pPWyPQ994+py92c/c9BCJazJAOmimt17jS6ZIp7MYMI8qagWm
         cDM3hYVB6HmDBW1HdQKm9Ca3w/KTZ0inVEsDT5qy+fXXFuRjHtifsA1NUfeHeEuXbG0M
         IP7Ma4PiwK7Vbv9+TwF2Y8UT8gwr1C6OCnuJbC1Kbs+7a4BSFXk2bp9c0H6qj0vUeKIU
         F18A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732195864; x=1732800664;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w8uJwMTi4570DKam76I3XnvJS8bhpJu1dkIBLmqzP84=;
        b=S4IhV3t+0ORAjdykrvDx12xkpN2DTv76aFXMiNjmsnAxq79MwCtrv7XkoqRQ7otd3x
         abcmLtzoLWixP/G4ecoaOrHksvJoLuvk6WmwZMaFWKcWqqzAbRIqankGCT8aEu0r85m8
         oMhTpHnKEzmgYL/Qr1NLDT9P03uQBXoCrYsFTexGnWGcNWaZ7c3TXmuakJeEeHrM7jDl
         T6W5AkXcCESwkIgkSjK0mx80KNbUFGEOMb5+QsNkJ8vOKeBaQy64NIN6Ft+gTSpg/D8J
         aWO+mGZgfGljvm5DUtgW3PJ1KxXZ4DKBdb0Uyk+B+UcDOJsBxRwheOccpG6/Tpq+HNBZ
         GHpQ==
X-Gm-Message-State: AOJu0YxFobyZ8h1SBoCZwvT0va6jirK3tGhT0S7VSF5h8HWdSdJRJfdr
	FHyH/CIJEVjxWPbTzjjmZ6XZEp7exJhK0Z3R8t/U2pkybKDYWZgGLGpj9hha3silRXET4qxzJtC
	UWTH7fCT5dsIJ7aAs+BJd7aLRnm8psCy6uG1B
X-Gm-Gg: ASbGncuORyw36xBEBbELaUkCv6DhGx0nTZcvD3yG3G0K/6d93ov2Rg7ccgz1JaZMnuE
	BABWKQpUdEBA5bd6mBC75Mj0DjKdATvTDUTThKHfookE3fEUSxhDJLeiYEhWH
X-Google-Smtp-Source: AGHT+IHrCfsQJARtvkGlSoORtXQ3uMbNnDwXIN5CoAh+JYQ8yNM3CL0C4nm/6GPxscmGMtMCji9BQilfxicJnaQd/q8=
X-Received: by 2002:a05:600c:3b9c:b0:431:43a1:4cac with SMTP id
 5b1f17b1804b1-433c6ce6ad9mr927095e9.3.1732195863680; Thu, 21 Nov 2024
 05:31:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241120105254.2842020-1-tabba@google.com> <20241120105254.2842020-11-tabba@google.com>
 <Zz7wBU3BHW-XNnbr@google.com> <CA+EHjTyGzjOnVnyqfS6LO5=_EhQY3CS18HyrnSmnfNF483yz6w@mail.gmail.com>
 <Zz8HB8KQtUyj8d9O@google.com>
In-Reply-To: <Zz8HB8KQtUyj8d9O@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 Nov 2024 13:30:27 +0000
Message-ID: <CA+EHjTw_NjrN63LXebPRha3tR6KjfXN-eh+eUeX7v5ksuVEG5g@mail.gmail.com>
Subject: Re: [PATCH v1 10/12] KVM: arm64: Calculate cptr_el2 traps on
 activating traps
To: Quentin Perret <qperret@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Quentin,

On Thu, 21 Nov 2024 at 10:10, Quentin Perret <qperret@google.com> wrote:
>
> On Thursday 21 Nov 2024 at 09:41:46 (+0000), Fuad Tabba wrote:
> > Hi Quentin,
> >
> > On Thu, 21 Nov 2024 at 08:32, Quentin Perret <qperret@google.com> wrote:
> > >
> > > Hi Fuad,
> > >
> > > On Wednesday 20 Nov 2024 at 10:52:52 (+0000), Fuad Tabba wrote:
> > > > -static void pvm_init_traps_cptr(struct kvm_vcpu *vcpu)
> > > > -{
> > > > -     struct kvm *kvm = vcpu->kvm;
> > > > -     u64 val = vcpu->arch.cptr_el2;
> > > > -
> > > > -     if (!has_hvhe()) {
> > > > -             val |= CPTR_NVHE_EL2_RES1;
> > > > -             val &= ~(CPTR_NVHE_EL2_RES0);
> > > > -     }
> > >
> > > To be on the safe side, should keep the RES1 stuff for nVHE?
> >
> > Sure. My thinking in removing this is that, once consolidated, it
> > would be easy to spot whether we could be clearing the wrong bit. But
> > I could reintroduce this when I respin.
>
> Actually, my bad, while checking how this worked for nVHE prior to your
> patch I've realised kvm_get_reset_cptr_el2() was already setting those
> bits correctly, which is arguably the right place to do it.

Actually, _my_ bad :) This patch is still not quite right,
kvm_get_reset_cptr_el2()
gets the reset value for the host, not for the guest, which the code
in this patch just works around. I'll respin this before the end of
the week, with a fix for this.

Cheers,
/fuad


>
> Thanks,
> Quentin
