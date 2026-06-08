Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377183B777B
	for <kvmarm@lists.linux.dev>; Mon,  8 Jun 2026 17:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780941561; cv=none; b=UJuQf3hiKiqtgbW7K0mEpTDFsn+I5I8OsuNDlBfz34mZoWBGJdIQcRQm9h/nvWnSjYJmQJ97ZjmhdrGT0hkhPs+2OQpIZYTNZTEBZAxMmxdsdwyfl4QyBBvLDUGHIY4l4ao8K8D25jv12pIva9qVVjiRoHH4zw/PGYmnCnZiOko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780941561; c=relaxed/simple;
	bh=Yh2vF4TIAGag+raZttED/lbT/nnkLgvDu0weKA8pAqo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BkSzXJZXaEeB3WLC0bmVSwsVCQKktzouWFFeOCQbekhxLi3WcXU4qdomuAjcV26+sTOhcs/fKnMzUVjIgQIMzhY0Nx3oyRGFVJ9CsnfHGRVaJthw0fUh3SNF8E0d5Wun545Y0UPWQjEOUSLtQZKVDA/F1rRp9TjvVEuKyWudSDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=efCYMawm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="efCYMawm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780941559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B8d2xpklGhwQZIXzXL6uTt/rbyfEnaEp9dTHG5HoHQ0=;
	b=efCYMawm4kxlvgDS9yRKiiJmt0oecds8TNjEIgubIchTVPIM5Ai+CewaJ4IzoZOcwR/pqv
	LRCS9K01qODOKe2hx6ARCEklrNWjsPlErTNcZzoZ1P5bzvIfg8tvXmZBAodc0M6J4thCYN
	tcd/HsgDkDTr5nJeauaaMP4znfSV6wI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-185-tEdE_uZDPTu9K3t8lWCDrA-1; Mon, 08 Jun 2026 13:59:16 -0400
X-MC-Unique: tEdE_uZDPTu9K3t8lWCDrA-1
X-Mimecast-MFC-AGG-ID: tEdE_uZDPTu9K3t8lWCDrA_1780941555
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-45efa7755faso1744193f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 08 Jun 2026 10:59:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780941555; x=1781546355;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B8d2xpklGhwQZIXzXL6uTt/rbyfEnaEp9dTHG5HoHQ0=;
        b=Sed3k1R9wSObtR0pf49T33EMntiZzhGfoVvThl3r+2e77tcUVpWdSPMzNDjZb7ttG7
         iL90iGw3chTvhBXXVwiNX/xqBYFu9zYdih/UgmV7G2FugjI3zzzuuX9CjfIjONghHitN
         OgxxXvL+kZJHABXqiz6b7vY+16I9yiAaQY5Tvo9j0LymV+Q9PIKSsGeMLivrAFHREoP1
         jomZU7IrNggEIdihSqsbm+qQyGY2e6y+8TP1SQTVbFZjr86jEQsHecs2x96Ra/Fm1r1r
         xLH4STa7zN9T+KxSUadoW5n9QVsOpFfT0BzSp03xIlJcQom2jnQvqSkn6njFo3AHGLFN
         XTbA==
X-Forwarded-Encrypted: i=1; AFNElJ/t4gmhi1WGJrZJfbpV5lZ8c+SrtbFelEDPgIEq5wmFda7WnZYRihCVrXaY7For+2bgVH6ZxEc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzjqS2pMDQlPDSc3SYtspdbId3+i9nyMNhCozOPRbdIXVmrko9s
	1DwOSvNP6XSC/sV67IDv7L+jAaiajBOUga/7KwkenrKgQe0qfYUinvif5TseHw1P163sYnK6Eoz
	Uq80zgpAB3GRGzcdVb2m9huHgVyVaRDLxOR3hVk/w0FWd7171TFmLpEi7gmkpwa+821615ZkiwF
	06pSjMNM0iRDuPKIwBGV/5sskBU/CLsW4E
X-Gm-Gg: Acq92OEdc1uHXSkTUJNHC/fImXg0I1G5hJp4eqNa1ILddxDqFh+KCd5VqZSj5hQHS6I
	rFNXZceOGelBdotFVS2HE7mWoFu9tuMrR2GDAtgrMMo6szzAZcEMG+bsAAl4XO4MCCRkxojF4M6
	eRGu2gtPI9DpV0Gn/f6sh29K0POhYL5OrOBGGfCGjXfrwUYZJspyLNt1M7T9GmL18PhbHW6C1Ze
	obKqd9Fc3jrKKGc9PeSxy43yX+HYg0FzC0Av5aVSoLVq7rD1cN3etzQUquD6tSyn/OxhRvlTqXb
	GqSSYE+WAj4nIs8x
X-Received: by 2002:a05:600c:1908:b0:490:b5d0:598f with SMTP id 5b1f17b1804b1-490c25b5f6cmr285228245e9.13.1780941555103;
        Mon, 08 Jun 2026 10:59:15 -0700 (PDT)
X-Received: by 2002:a05:600c:1908:b0:490:b5d0:598f with SMTP id
 5b1f17b1804b1-490c25b5f6cmr285227865e9.13.1780941554714; Mon, 08 Jun 2026
 10:59:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260608144252.351443-1-joro@8bytes.org> <20260608144252.351443-36-joro@8bytes.org>
 <e7eb0dba-790a-4644-9895-5c9a7420d7fe@redhat.com> <aib8n5lO6HKbLC4Y@8bytes.org>
In-Reply-To: <aib8n5lO6HKbLC4Y@8bytes.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 8 Jun 2026 19:58:43 +0200
X-Gm-Features: AVVi8CcaSI98hh9wFoB_n6cKHV5EHNPF6kPS5m5gs3YdhiTjEhtRfK4vGBfAwzg
Message-ID: <CABgObfbUsDeStnZF-7oyR-W-Bvd4qTMoeUwGizgn10UTdKtZ2A@mail.gmail.com>
Subject: Re: [PATCH 35/60] kvm: Add VCPU plane-scheduling state and helpers
To: =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Cc: Sean Christopherson <seanjc@google.com>, Tom Lendacky <thomas.lendacky@amd.com>, ashish.kalra@amd.com, 
	michael.roth@amd.com, nsaenz@amazon.com, anelkz@amazon.de, 
	James.Bottomley@hansenpartnership.com, Melody Wang <huibo.wang@amd.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, x86@kernel.org, 
	coconut-svsm@lists.linux.dev, joerg.roedel@amd.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: w0N6UAlf9aK_NRL8KUGhCIRmjzIcIXZnUdpYmc1hAxU_1780941555
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 8, 2026 at 7:52=E2=80=AFPM J=C3=B6rg R=C3=B6del <joro@8bytes.or=
g> wrote:
> On Mon, Jun 08, 2026 at 06:47:54PM +0200, Paolo Bonzini wrote:
> > On 6/8/26 16:42, J=C3=B6rg R=C3=B6del wrote:
> > > The algorithm is to always run the lowest runnable plane. Plane
> > > switches are done by stopping the current plane and setting another
> > > runnable.
> >
> > This was left arbitrary in my version because for example Hyper-V VTLs =
use
> > highest-runnable instead.  It also made pure userspace scheduling possi=
ble,
> > though that may not be very important in the grand scheme of things.
>
> IIRC what Hyper-V does is always the run the highest-privileged runnable =
level,
> no?  Maybe in their numbering level 0 has the least privileges?

Yes, exactly.

> Anyway, I am happy to make changes here, also based on input from the VSM=
 side.

Related to this, let me know if you want me to pick up again the
common part, especially with Sashiko being hard at work on it.

> > Did you drop it because it didn't work, or just for simplicity?
>
> The user-space scheduling worked, my 6.17 planes implementation used it. =
But
> there are some problems with it going forward, because TDX Partitioning (=
and
> likely ARM CCA Planes as well) do not allow arbitrary switches forced by =
the
> hypervisor. All they allow is a forced switch to the highest privileged p=
lane,
> the SVSM on SNP will force the same constraints by making lower-privilege=
 VMSAs
> not-runnable when it executes.

The idea of the userspace scheduling was that you're not forced to use
it - the kernel can always choose to override it if it's using an
accelerated implementation of planes (and of plane switching). But it
also leaves some leeway to different accelerated implementations, each
of which can pick their own algorithm.

Conceptually I'd rather keep the possibility of userspace scheduling.
But maybe it doesn't add much.

Paolo

> So exposing an interface for user-space to chose which plane to run does =
seem
> to gain some weird, platform dependent semantics going forward. TDX and C=
CA
> also require in-kernel switching as they can switch planes without a VMEX=
IT, so
> I decided to have it from the start.
>
>
> -Joerg
>

