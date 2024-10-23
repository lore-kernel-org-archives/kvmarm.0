Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932AA14EC62
	for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 20:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729715270; cv=none; b=swqXfPFWbT4ALtgzA0pIXAO5XG+BpC75A0L+jfmKEh+rSDMGD/pr7NIm+xvE73HaEq3pwddsOq9EYKVxax4xOz+EQUV4IlGKxEykhtrYngaw8nZVYSJ0H29adS8e0PNztoicOkCyfUL20B7dT1eBTVjSvgV61kln9f+kW5SYabc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729715270; c=relaxed/simple;
	bh=Dep7eDGQHxQCN5vkFrILaXybpyuGJYUBlX7I3AmmX7A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qbVJ8cf7wmGQTYbG99RCWAtwveSiD6iUX2iY7IFY2OvElF463EdxfJRX6CLqcf4kCDvG7xjgS/Kyayx1szyMMYcrYuEi5DKrvvCVqfYQvJm7z9m93X9gSaL8aADR8jdqlSwHYWthofqDGYPo+PdHrplUDSP3et7Y9B+bTIx8qpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FgeVmTFI; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FgeVmTFI"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-539ebb5a20aso168689e87.2
        for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 13:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729715267; x=1730320067; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q26rjq4zEqIRz8Vcg16r3D/o40rTFfW2jfuSpqI9ulo=;
        b=FgeVmTFIwtLKzEQE8ReiJf6CDyNa4MXFVfTfrle0R4wS7OS66U5230NkQ2HscFdwsU
         0g3Gs/f59FAhVd4Tqmfu8B59cWW4UI/KMxfINbhiJ/mCa9tjEsJvSBizGA94x//2DX0s
         E35PHHwRIZwCSicmVlwFbUrp6zPvjH3SJhTsiO3Bf9BGJoRqgOo1/phQqeFNWiRvQ8b9
         fiKbMwH7wKX2hXZRIX4JRN5Z04mmooLN+p8AQpt936TFYzPcY+AffRA8btokAbc14Lsf
         Pe0fgqPZHGR0bjg1ZFrd+64tw/oVBRUT+pYRsJoYrU2D9Rlqj8EA5nb91tNZtPWFK9mw
         elKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729715267; x=1730320067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q26rjq4zEqIRz8Vcg16r3D/o40rTFfW2jfuSpqI9ulo=;
        b=hw3XRr6YDf7pf2F+dRszLRnGZS6n+Ue8cjxeqXoD75XiXrcCpsqqYp8NA0vQcZ38id
         bP+o0SFesnxogvQwUkdWjxckIvuPjaGJePuOeRFcXQuG6by67/WyyONQMeyayKkN5GQq
         8294AmA8lxIStvRlhUvRETwHiug2ydtiOeZ0lb/mz67A9kHSgzBbOGwNxYwxeX+sujbY
         2bhWOOQAHffWPgnhU8Xpd3+wAN970iTG0D/OguMA56i1GEWX0SQebJIYjPUkxUETlg0E
         kf4baVJjO1A0rqJd9mh5uZMmtPal6oyoKXJ6mOTEic2oqL25f61LFhSKhzoVPOGomTd6
         zjwg==
X-Forwarded-Encrypted: i=1; AJvYcCXR7X9bAQtwzDc9TyOWWpcuTOFrNZT9gPAkHvWgT0nV7QMFa9w02G9DB2huS2Uo9lokbtjA7B8=@lists.linux.dev
X-Gm-Message-State: AOJu0YznptVCRP88z2N3ztnlR5g6IZN/NFPMjBt3U3q52vqaJYDKAwbW
	uNKg34QOmzmBWggutmXREIUU6YCLAaHu9Gw0Dt38W3/eLa1rLQCgsbEJid9Zxdz6jJaOwv2Dq8n
	qX9XjvT01CCKbuojKNuNaHUW7np0hgFMETFTb
X-Google-Smtp-Source: AGHT+IG+PCsts43OphHvhZhAIxkFG77LQ241b/e0BeNW2BtEwVtREehGvVJqVHr1dr/PkLFD1+MnSMDI9zjrCuj7re8=
X-Received: by 2002:a05:6512:1250:b0:539:959e:f0e8 with SMTP id
 2adb3069b0e04-53b1a3115bcmr2546071e87.21.1729715266559; Wed, 23 Oct 2024
 13:27:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240704142319.728-1-jiangkunkun@huawei.com> <20240704142319.728-4-jiangkunkun@huawei.com>
In-Reply-To: <20240704142319.728-4-jiangkunkun@huawei.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 23 Oct 2024 13:27:35 -0700
Message-ID: <CAAdAUtioh5DoZd+afryv+K1H4nPCVUoNpdFuu2vKpM92++Qqqw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: vgic-its: Clear ite when discard frees
 an ite
To: Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Eric Auger <eauger@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	wanghaibin.wang@huawei.com, lishusen2@huawei.com, tangnianyao@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kunkun,

On Thu, Jul 4, 2024 at 7:23=E2=80=AFAM Kunkun Jiang <jiangkunkun@huawei.com=
> wrote:
>
> When discard frees an ite, we do not invalidate the
> corresponding ite. In the scenario of continuous save and
> restore, there may be a situation where an ite is not saved
> but is restored. This is unreasonable and may cause restore
> to fail. This patch clears the corresponding ite when discard
> frees a ite.
nit: ite -> ITE
>
> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-it=
s.c
> index 223a5f1d6a3d..cf4a85a29504 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -782,6 +782,10 @@ static int vgic_its_cmd_handle_discard(struct kvm *k=
vm, struct vgic_its *its,
>
>         ite =3D find_ite(its, device_id, event_id);
>         if (ite && its_is_collection_mapped(ite->collection)) {
> +               struct its_device *device =3D find_its_device(its, device=
_id);
> +               int ite_esz =3D vgic_its_get_abi(its)->ite_esz;
> +               gpa_t gpa =3D device->itt_addr + ite->event_id * ite_esz;
> +               u64 val =3D 0;
>                 /*
>                  * Though the spec talks about removing the pending state=
, we
>                  * don't bother here since we clear the ITTE anyway and t=
he
> @@ -790,6 +794,11 @@ static int vgic_its_cmd_handle_discard(struct kvm *k=
vm, struct vgic_its *its,
>                 vgic_its_invalidate_cache(its);
>
>                 its_free_ite(kvm, ite);
> +
> +               if (KVM_BUG_ON(ite_esz !=3D sizeof(val), kvm))
> +                       return -EINVAL;
> +
> +               vgic_write_guest_lock(kvm, gpa, &val, ite_esz);
>                 return 0;
>         }
>
> --
> 2.27.0
>
>

Jing
