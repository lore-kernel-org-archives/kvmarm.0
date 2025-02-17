Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9748018F2C3
	for <kvmarm@lists.linux.dev>; Mon, 17 Feb 2025 06:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739774466; cv=none; b=ZuN152DYdWLqynwvZDyR9tI0mKAo1ND7BelXh/Ku89weuNFgz98sFflBRGf9c03v3S7o1O29XhxGMJgjapPdgOgmVceao6VYvcLT7lCOyS6rPzmB09HnFxz4z8U/Is1eu1udXnioufqAD3qxm+SCV5b+p8o4bdMlOC8mTCOH4D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739774466; c=relaxed/simple;
	bh=QyVtFU0xdpInEPYan+aOJEYUTEb5vp2F9nMoL/TtoMQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rNggD819tVBySihiM9PcKx+9G6knhm04BLMVskUBTW1rzCXsyJSI8xbtQH39tp7FnReHu7aYdWMJd5Fa8wXiYCAhtTVt112rEgVfzD3t6iUiKJXGSjwm4nAu9g+NDeDn9krxIYRYKcd1fxfTifaTuDOS/ODu22GlFE+7djV4X/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lsf9tekV; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lsf9tekV"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-abb79af88afso262896166b.1
        for <kvmarm@lists.linux.dev>; Sun, 16 Feb 2025 22:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739774463; x=1740379263; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9BlNWjMvH32bt0VwRarRhttzzRaU06jOP281HprHsXs=;
        b=Lsf9tekVpbvPMR+Ep1dkfC6jgk/URCWvRuIrgpwvglrNyI6apVevb64m7RtChZN3nO
         LgkISnO79F31sG5UR2FQ1YLVyOF7IrZA2zMkXvemTI4tD7EcqrFLsdtrVTt0kdXTPGp8
         QewzYHkRoJ7GnM3PRAyC0DRB8Swx90PERZAADOM9Q7aQvvIPjgbIPAt0e73nSUvEl/It
         /5u/orEIdZ85mXCgem5WCJYz7qAK4swh0MEKtJ/wI3UO03WJ+GEl758NyWqIStLccWMo
         pKo0xcLuI7iwhXRXIJTN5blSicv2cDdTRGnViXwUMWlfRfrDq1VB1FAwzJZsvm2Wy88D
         QDTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739774463; x=1740379263;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9BlNWjMvH32bt0VwRarRhttzzRaU06jOP281HprHsXs=;
        b=PMMKcxJS81ip1C+zXOD21iCBJ5kI67iG/8faRdMGXKe20H6DNZprhCGB1DMmEHIqLB
         uqkXThlz535FOc6debiFxj5STEC4LWHOaoMcwBYkhPFZltk7eFAigxjJUzDKYpvrq4h8
         VzcXvWFVlC7EaM9UsihWz4Rz8eNzly2VMcBTmzzEO/DRbiagYa3gfelKDahk5qoOezKI
         dNk95acfF+XimbsF2dbuG5LA/lEnGJXfyBLam8VNtPJwfq0B+mzGxPFESKrOHNvxfLoU
         WXuhcz4CFEluBCS7J8J59QEb6oC58/6/ZhXIaxakPCX7LlZejx2g1h1Xy7RcEEUToJ2z
         Up+A==
X-Forwarded-Encrypted: i=1; AJvYcCVd8hTpMyRF8l9tsxuennwRXZb1Or3hbfTDmH/AjUMlHZObFdRrYeCxmgYLlbyQFgxS5NcgUPc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0gKSKlDzR11kzEsf7kJYqGkCZ8vfa740Y9UHOTWFCLaPvnIrW
	TkqKboQuQ9oQxub77qW0qAEqxUmNKc0XGJ3hVNBas7IGr73lvzwKO6XGwesEB416g/gOPPMjE8W
	nTmyP+EqewMMJz+HGhyVF6tzYs68=
X-Gm-Gg: ASbGncvLFRF0TERis0kPyFmhvxkaEu8Lh6IS+akhJGdU4bbHaNLx6x3rHLGDdmwUzW+
	HFG3Fz3KRZqXRkNpMEqrX8YfANeJ4ZQU9tsC/hhagg22utL8jAHK9EuXk0rzhV6chU4zFNfLP
X-Google-Smtp-Source: AGHT+IHEblpWy0E8o/GwtXXK/ARtPn4+t2mJ/jkAoJv43EWaA0zUoUZ//XGdmh3n9p1/b1WAK7vkij5W6JHPpq2qDSI=
X-Received: by 2002:a17:906:7312:b0:ab7:6c4b:920a with SMTP id
 a640c23a62f3a-abb70a7a67emr862003466b.6.1739774462705; Sun, 16 Feb 2025
 22:41:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250211143910.16775-1-sebott@redhat.com> <20250211143910.16775-2-sebott@redhat.com>
 <Z7BoydkyT_h0gwOV@linux.dev> <CAE2XoE_8ihJZQF856w-_F+cgJW7fLWGz7M7Ztoxzw2vE51_m1A@mail.gmail.com>
 <87v7tb17os.wl-maz@kernel.org> <CAE2XoE9=hjP+qpsy+FcYcSDectDajiXjtcMCVpacSo4cFOo=tQ@mail.gmail.com>
 <86jz9psqwd.wl-maz@kernel.org> <CAE2XoE8i=jPgSea5jXY0eOxas9Y_2pa7QheqS1xuw2qeTQDNyw@mail.gmail.com>
 <87pljh1zgj.wl-maz@kernel.org>
In-Reply-To: <87pljh1zgj.wl-maz@kernel.org>
Reply-To: luoyonggang@gmail.com
From: =?UTF-8?B?572X5YuH5YiaKFlvbmdnYW5nIEx1byk=?= <luoyonggang@gmail.com>
Date: Mon, 17 Feb 2025 14:40:51 +0800
X-Gm-Features: AWEUYZnfZwhUG_EoRZ2LP7nC3OQtiJSnvldFjppzrrBppJQq32TWm_4wX3cJYI4
Message-ID: <CAE2XoE9Xc0CeNiRZnwANU2Q9Mbg6f0hCOyrkNA+h5Jp-2mrsBA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] KVM: arm64: Allow userspace to change MIDR_EL1
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Sebastian Ott <sebott@redhat.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, 
	Cornelia Huck <cohuck@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Well, there is no magic. If you don't write to VPIDR_EL2, not much
> will happen. You need to apply Oliver's change instead of the first
> patch in this series.

Thanks, after applying Oliver's change, it's working, my concern post
at the beginning is to ask if
 Oliver's can resolve the issue:)
Now after testing Oliver's change, it's working, thanks
Sebastian,Oliver and Marc Zyngier:)

My test result now is:
```
/home/lygstate/work/qemu/build:/usr/local/sbin:/usr/local/bin:/usr/sbin:/us=
r/bin:/sbin:/bin
/home/lygstate/work/qemu/build/qemu-system-aarch64
+ qemu-system-aarch64 -cpu host,aarch64=3Doff -accel kvm -m 1024M -smp 1
-M virt,gic-version=3D3,midr=3D0x412fd050 -nographic -monitor none -serial
stdio -kernel /home/lygstate/work/debian/arm64-kvm-hello-world/bare-metal-a=
arch32-qemu/hello_world.elf
Get MIDR EL1 origin:0x410fd083
Set MIDR EL1:0x412fd050
Get MIDR EL1:0x412fd050
Hello World midr:0x412fd050
```


>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.



--=20
         =E6=AD=A4=E8=87=B4
=E7=A4=BC
=E7=BD=97=E5=8B=87=E5=88=9A
Yours
    sincerely,
Yonggang Luo
