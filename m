Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D89B2DB789
	for <kvmarm@lists.linux.dev>; Mon, 11 May 2026 11:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778500430; cv=pass; b=jyyl5WTUHI2xe+BhwsDqUxJQfi/AarpEv6IutfM26D0+ZaGFM8yDI0WNO+NHxv7BcCAbGxKLHqUU6F4KdfMvNI6csx8TlzJIq/F5QzQqBY5YZApclvMfY/cWh4Bv+6kmEbDQ8RqAkoxKldS4ztb3w1L6IfbVubIERXHFNJQ1yaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778500430; c=relaxed/simple;
	bh=EyEdGT/UwThY07rJVuH5QIYg5WfjYK/VMng0MYb/gWQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AQ1pxDJCgDGWievzXn92E+Jj4V4vL7/PZBnMEBEJo/SXWS9yzo0O1rTeswQdWBMSB5fxscUnqHdwCp3J96+LS7nXELo04FASyYT/bP9QhHNiYf+0IqyrhFzuKutggfFDkZCrvZrG1fOjBjQcXN8AEn+MlkIrY9Yod+w1ifYeRvQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C/gMUyFo; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C/gMUyFo"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50d864c23bdso7631cf.1
        for <kvmarm@lists.linux.dev>; Mon, 11 May 2026 04:53:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778500428; cv=none;
        d=google.com; s=arc-20240605;
        b=cJqBNZFUIeuKGjtOlrOaAUppHlP2j9DWg15a6s2ai/4uTwYfO4eyJ4ZVRfG7AejZ0B
         bx5UinBWY2k4TBOMLRXSzabTCEhdoZKxx3ljrhN05JPGUPe5lUjeBJEHZIesXR3SXwLv
         jB7ey8jj1SUjqvoZxkSUAXJ/hd4HrYs8kaTekP6avwFSCW8cWoUtwBLDouhpApkjUkrC
         bgrhrh2XvuvesLRRfEd4bHqP4rLM7Gw+S0GX0H+8y1CE6TWRjw7dLK9olHsVOZkOWF7D
         7hrwbR96gns9f7cnPL0NYILss2/cbg0FEj2MDLmhGZT32UOE2GNaiikh1cB6fcHk9cYa
         pZ8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EyEdGT/UwThY07rJVuH5QIYg5WfjYK/VMng0MYb/gWQ=;
        fh=00y9qRIPHJrOByFqpPcq2MqCVRr745LyukDhhdK4g8c=;
        b=EOLplpwdyQtnGy31gxu95dYeMgdf04+QXl8h5/My1nO9xPcJ+NssH/Jd5GEbr1TIas
         fU9VZlvJMLoMISdbLGgZqpYSH070qoS0UZVt+GILPeTJNUGr3XdjAl+4HMsPPikqpXny
         vFo4IA3zJviADoaK6V4DEV0sKI8tmAqU+7EK4+DLvUE6ULx5jNhPGfDl/ekzwfskvce+
         m41GAD2cpuHWbPLj7jXW10NDA/zP0mhrApgoYSOYdm95HKoLYLzYtkcGOU2iDlAkYjiq
         Nx9FDWto0gQmmlaqZ+7VYOWaqASexTCY/ACHmHsejOpMFAkUaPKStBauWL64vEYOfMJ3
         g1Rw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778500428; x=1779105228; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EyEdGT/UwThY07rJVuH5QIYg5WfjYK/VMng0MYb/gWQ=;
        b=C/gMUyFoCZOy89KAY9pOCMsw0hd09Lunov2FrgaSZMAcJnlZDEvy0AVkB97pkzuz3Q
         INwm10gxdhcVyzVoc0tG3YN//o5tKnN0SuU0LQRJk7WeuE5SZQBnJPXhzdXqkppx8raK
         bl1zl7bWhdAeZKm4y73CFkDcv1/ADGPIFadHsTjGSqUmYeAExtloCkssLo8cI2mRlmy0
         qOhJsbhVdW4DxYCcHBGxTkvCwdd8BvXirorjS65icg61hfDNrljwFNvDHXxOiQ0oRGsA
         6wUx38ymtG1UaLA8WDeVZl16V4i0axSlkhzd98t1xWB4l/ZDgm9m9fDA7ArDFBCiQCt6
         rJVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778500428; x=1779105228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EyEdGT/UwThY07rJVuH5QIYg5WfjYK/VMng0MYb/gWQ=;
        b=YJiLEd3QFhfFrU7t3FCQO9oMX42/UVSdhvv8kBxlIP6VVjgU2WDczQtVnWvnp1s4Ng
         TDNpP7HPXF1CCr9pgPnKFZigZOhOhh8NuBiAxF46YqC8NPiq2EAwYUVStS3gWgldY2E7
         Ike8ld7NDaJKGFBwJ0UIqNhGGiwBij4lrLaM/TwO/aUDyi3MAc7S0/BOikg0A2jpcMiK
         /ybS6FeLtQ0FGfvNWelXpX2LGKcF7S0HIgu6PlHAxAD6JYpTG65xncbr0Mabdm0mb9Iw
         ZOUQtqnXYMK8ntUbFg2mwtEycYj4mg0PV9+yD3Lwe9pPNeUw2entjXR7vOO3cs9XXumx
         ALlw==
X-Forwarded-Encrypted: i=1; AFNElJ9KBnr1k50dNfpZhxMU5gFTLbZARdXgDHx+Pjc4C3H36/8+wVnfOL5CVXQkSfeivYcblunzkJM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxUHBBwlULjlbcRoKpmjFsps0InN0z19f8UwQYQgQF2iEUOfR+r
	Us8XycuxDxvd8xjKAS6de4F9C1gwSPYX9LVAtTlX7E4HKRyE9kDPxO0bD6Nhg/HTG1oDeE8d7R1
	icZ0taN2nkUIhkzQyGCx2FqWvAo9kFYjq/mM3ppGW
X-Gm-Gg: Acq92OG2Wtln9WSNwHXIoGz22E9WCbSEoPCZ9ehug3BjJgiI0bWg6VGjakGddgLC2ND
	Hx29QvfAbRgtWszg6uTxiadWHLV1CTtglbW9kEhAPno/baTgDhq8gkLvBQWnwazaFWwhWqPLmje
	5fkcLbUCKEt6Jo1IuDuDekTv3hyeMD3x/tKr3ey64ElalqK4ZPW4fmVrLRQCTWvv84yUIFkZg2H
	9L1lzjcEewve4brLXSl9TTxWH0XVLnnWiC/FwfV4538YuP+pNZMZ6deMl28eL7u2pBZj1v3fR/Z
	jU4dwtd3h4wdGUiguj56aECGpaLXN7AWbYM43OzGTk97qKncRKrLMA9x9xVuxQ==
X-Received: by 2002:a05:622a:8d12:b0:50e:5c9d:49c7 with SMTP id
 d75a77b69052e-514a046fbc9mr19494131cf.7.1778500427992; Mon, 11 May 2026
 04:53:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260501111928.259252-1-smostafa@google.com> <20260501111928.259252-6-smostafa@google.com>
 <20260501124716.GD6912@ziepe.ca> <afiODW2sVMeOj3Ag@google.com>
 <afoagb/wVBJD1IX+@ziepe.ca> <afofSPQbepd_fpom@google.com> <afsQTwO3eW+Ks2fe@ziepe.ca>
 <afxlufh3t3hRe4-G@google.com> <20260509233443.GK9285@ziepe.ca>
In-Reply-To: <20260509233443.GK9285@ziepe.ca>
From: Mostafa Saleh <smostafa@google.com>
Date: Mon, 11 May 2026 12:53:36 +0100
X-Gm-Features: AVHnY4Iy01SZKx6-ZKVz0uRzPgk9VsXyMheNVJnPIgQawwYuBaPqoPjvouiwCBk
Message-ID: <CAFgf54rJqq_bJONpx85p+uB68i1oVAGZW40aZA1ufid_5fqwQw@mail.gmail.com>
Subject: Re: [PATCH v6 05/25] iommu/arm-smmu-v3: Move IDR parsing to common functions
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, joro@8bytes.org, 
	jean-philippe@linaro.org, mark.rutland@arm.com, qperret@google.com, 
	tabba@google.com, vdonnefort@google.com, sebastianene@google.com, 
	keirf@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 10, 2026 at 12:34=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> wro=
te:
>
> On Thu, May 07, 2026 at 10:13:13AM +0000, Mostafa Saleh wrote:
> > > I was thinking more like
> > >
> > > #define arm_smmu arm_pkvm_smmu
> > >
> > > Before the pkvm compile of the shared code.
> >
> > Oh, so we rely on arm_pkvm_smmu and arm_smmu having the same field
> > names and types?
>
> Just for the shared code, yes.
>
> For instance this patch would require the features field be present in
> both, and then all you do is directly copy all the smmu->features
> logic into the shared file and that's it.
>
> > I don=E2=80=99t think that=E2=80=99s better for maintainability, I can =
look into it
> > if Robin and Will are OK with that.
>
> I think maintainability here means pkvm minimizes how much it changes
> the code of the main driver.
>
> Copying a bunch of functions into a shared .c file exactly as it is,
> then compiling the shared file with some #ifdef'ery at is going to be
> long term better than trying to mangle the whole thing to avoid using
> any of the core types and not directly share the code, IMHO.
>

There isn't #ifdef'ery at the moment, that's what I was trying to
avoid by introducing shared code.
I believe that can be treated as a library as most of the shared code
is about HW description (commands, invalidation, IDR probing...)

> Like my tlbi point for instance, it is not a good idea to rip out a
> little bit of the invalidation logic then open code a pkvm
> version. Use the exact driver code. But to do this you need to pass an
> arm_smmu through to to the pkvm specific queue management functions.
>

What concerns me is how fragile that is, any change in the main struct
can easily break the hypervisor, unlike if we have a clear shared code
and defined API that is used by 2 entities.
I will think more about this before v7 and see how intrusive it is.

> > > How does pkvm compilation work anyhow? Is it all rolled into a unique
> > > link, or do you have to worry about symbol conflicts with the main
> > > kernel?
> >
> > All pkvm symbols are prefixed with __kvm_nvhe_ in the main kernel.
>
> So automatically with objcopy or something like that during the build?
>

Exactly: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git=
/tree/arch/arm64/kvm/hyp/nvhe/Makefile#n96

Thanks,
Mostafa

> Jason
