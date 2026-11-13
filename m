Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794589747;
	b=jU3jCcXnoyQ8Pc3hlm5/tflzi7Vfy32AR9vCLnnsfHQ/0UH/2dgbrTYpqXGUBnsP7v5P
	 ibXoOtcfwy3egPCzX4oSfTjTiBSgUWgdwQm3/4XY0FLUYsaFQ5hQT5tLxTb2A6iB937Z6
	 HTxCTQB0yOQZDOyOmq8V6v1QVKQGpNk1A+iw8uI5zhGtONiwMS2RnNu9hSRn6s6z1VaKo
	 Qeh7rdfU1rae8fEca6MiDUaiJdBnyNr5GA2CudH4G8T5FVWv+zH3IAhSjfMQlc68s0yyC
	 +TnaRQXfp9oc7WXmV+s5hu95ArrYVJ13wnN9/b/qQt2B7PdGfPq5pbkM5RLzS6QFKSw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794589747;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=zTGaV1UloT0Chf0ol30qq10ZNwEvfaESId1U8G45Gn0=;
	b=iLu3WqjUCenpkyeSyd7uoH5wuyb4ugUi3VboL55pVTB9SVhSF9Mer6qDG3PBRDVrW2Fb
	 1Q0zqGctgdIHuP+Ledq+zOYqYK6A+la7hs2DJvr9OjlctIn1SUaiSaF7f2GCt+jU0exGd
	 Mqvs+dV7nYWZQI57ryLWQZYv67q5uOKGJfOc2tf26rm3XXXbKb/RE4gbVepK8gi0Tihvu
	 WevFMXAes1wU/qN4kKTtYwm0fcIb/E569mLOzBNKFrkGnQ6V5DOsyct7jtKCEUsZ3DE45
	 boPGU9H+jCjsiOTgpxXaWuzUWaSB+raJ9ANGE+COek4LfnUGCA1ErUEAWGVUvU7VJlw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WQUxNrJE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.51
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B68606A323
	for <kvmarm@lists.linux.dev>; Fri, 13 Nov 2026 17:09:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07B68606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WQUxNrJE
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-67be9601f48so331504d50.2
        for <kvmarm@lists.linux.dev>; Fri, 13 Nov 2026 09:09:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794589746; cv=none;
        d=google.com; s=arc-20260327;
        b=UXPVqZjCNcjMDl1QcTTirZBW9ln45rm8XzkIiL9ybMme2lVDq4rhNWAl3dDFMwS0Oh
         zn4lGQyW5ynV2jno3rsGDLNYPQqY7vg7mGNyA93Gp9tPoStgx2hI9dasJrWl9bSnfPhq
         MG27kPjGz8xSQeMfGexhFLOEK8SCWgdLSU124hwDGT7GU5atw1Bjl3EmtRGUQ8sum2We
         hBbTI9fbVnt8uEKRjfInmt6JPiERr5hPOBvAwBBRUM632ocdrayj8B/RkJwZ8myEmnVq
         Oq7zSIf8wAvBr6BB38jskLLGj7iSaVjDo0DrjnvzDuDl3O2jH18s+yuQY1aOy0qPHuNr
         TSQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=zTGaV1UloT0Chf0ol30qq10ZNwEvfaESId1U8G45Gn0=;
        fh=Cw7yOD/Kqyrqc0EWINltWiaAVOhOmDuRDB5mwM7AtkI=;
        b=h96olp85eQLbWRgVDyGTdLNWyjdAmfLm84WZ6F91xctMnCeeWAIDyeitEUfmWRIUj1
         xLmPuKBpme1mleKGpAoyIjsyG7g/38CjhinhbOVllEdzznEVlfQ01+0+RXdgbTHG43RG
         +JKfIaNwS77qPVCyZXg6U8QNCd4jFs5CESwm9mOepWGlvUVbsC8jb7Y5m7bi09rs9Lf0
         Uz6d1GBx/9nN677IUDkcPB1/LwF1xX2NS4GMR0/pezMbJLsMfOCAZhHhaVBz/sP3GFoZ
         N6ViG7/glspH7G5IDaKlr7d0holLxy+IyiVO9B8uu+WITMvHeZCOkEtVX/nYFhF3sMuo
         h5nw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794589746; x=1795194546; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zTGaV1UloT0Chf0ol30qq10ZNwEvfaESId1U8G45Gn0=;
        b=WQUxNrJExGBiYN/mzYcnBvNJTiYVjVwQIM8Cp4p0+jgPSXaviVFRSXmFzExbaFj7QM
         wzRS+avIbVDP2PlM2v3ctZ/EKW2vbrN1Ch20489D1LEG7uqUDmlehrNXUtBrILlfCXcF
         iGQa0SnN6IEaBkTkHdfKqz4VDUXE96NnwDMDoX9xKhXt1AMNNeJUEJ1tCmcqby7hHy3h
         5GVzEXVXUSOj4hojP8og7vrCLPwOqralYP/CCU9ipxT1Gcb39zr/DiOqYhCEWhieni47
         H8+sNMGdU0XQpajrTG6Z1gD9Iaz22G7Rj38WuE39rJS6J1kHrpXHrsrC2CnAmsmBoQLC
         T2pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794589746; x=1795194546;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=zTGaV1UloT0Chf0ol30qq10ZNwEvfaESId1U8G45Gn0=;
        b=LtVnEBW/4d2lbSlohMP56XSe0dyXgkNoItF3/fEt8WKRV3QqGtD7u9kg2aseOMLC4B
         rJzqv4QcRl+frWtoNFEMV9RRH2PhgiyMHlBfYEggeR6tVJpKP67J9qrOH8EXWNaO5/xN
         Fy9uftORfzmBWbiLmzxyWWdJU0Z8xOi/SJsWvEUpWr7RJTzDuILo44cF+Y4/Ii34yUr8
         ubFTKOpgfZvnVn2L08970fvSYU7IuO2sWBxvolc2munb5cF1ewksPOlTQNPZvTgzEQM7
         gWH8eQpfjwnRqSrb+NT7pdNTygfMYJKxjrlWf7oa4ShJiaQG1hI64ditRQasJfK6C9il
         SdYQ==
X-Forwarded-Encrypted: i=1; AL+hErHLANUrAKSIxVMsc3zGAy80nbPc/HxcqgRkBNNVPqTe1SzjbiS3Lx/CuMY+SuH+iR645VPTAiw=@lists.linux.dev
X-Gm-Message-State: APuU4Z/q8SFeILPrkvPie5dRtq+zT3Vnzb6RYvWLoATRenPgY8/peaFJ
	FjYeZT+Kd4jl7tv9h51waSeBv2OQrkXabU+/SSPOlFeypJ8G2Z0uJDdUl8tZ1PZ88v3fsvoHk4/
	M1zzsu4kal/tfNT2+SinGxeThWCCK8Kw=
X-Gm-Gg: AYBFou034nz0xhuFEOFsiAWRAhPpTsOd8dTVH+MGANS0XoL2KfVaikgjugIhO7WEzAz
	pCNX2LZi7Ju6YVxG2IDt8zbbnYpCF0djGfjM/X3Yv4y0X7YS1m4O2647kKBBT99Tiu4Z7HrLgs+
	tSh+xZXY6hRZrFcJTyfvLz7XD7jyf2ZV3GOMVFxh5kk3jP6dXegOH5WhgqS7C/ppFakRp5FjpMg
	CK35rl9qAHbNoSadFViUqSiK7P09mTLV6roVwfuqIJmdgPEA2BhVXD2ByYtnwYNhS25cOEgayoa
	Ee6BA9YUSxt/6jbjOBpeU5787W66f6M8w2vD+Je8zicftvMCmHUSqkac6s3EyO6j0dAnzg0AytJ
	0V+P0MqwYhBtNQB9UunvcXGme6dq4H119ZGaBhXCV2D21b1G+Lt2Paif+u89clTraTOTm3Hvo2m
	/LJyVjoeR50BrqQejyVZ76k74Z7VpKotUlFYlK9BEvmo10Su+3L1Y5sOhTiZoJe4N3aQVMWVHET
	r3UFyqF
X-Received: by 2002:a05:690e:b83:b0:67c:1fc:2a49 with SMTP id
 956f58d0204a3-67d970207c9mr377453d50.54.1794589746003; Fri, 13 Nov 2026
 09:09:06 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261023070110.1833446-1-fuad.tabba@linux.dev>
 <20261023070110.1833446-2-fuad.tabba@linux.dev> <86fqxwzul7.wl-maz@kernel.org>
 <CA+EHjTw08SZC_3Uodt6ew6vXVH-doW-8G41fVCF-rmaKsv+0fQ@mail.gmail.com>
 <86ecdgzp6m.wl-maz@kernel.org> <CA+EHjTy0jpY3sdVCENJRj_kfRDwbZ6TpkCAHQ2xUO-7ZuErpcA@mail.gmail.com>
 <ad724195-3452-495a-a50a-5e5c8093a483@app.fastmail.com> <CA+EHjTyLnAXanf9R7SuoL3gFZUNewX7QOnW=mc3qzwvaxg7jJg@mail.gmail.com>
 <040cf379-baba-4e3a-bf3d-6bc009a9e28d@app.fastmail.com> <20261112180741.17614-1-sidchintamaneni@gmail.com>
 <0a5e252e-1494-4b0f-a761-d984238c9d0d@app.fastmail.com>
In-Reply-To: <0a5e252e-1494-4b0f-a761-d984238c9d0d@app.fastmail.com>
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Date: Fri, 13 Nov 2026 09:08:54 -0800
X-Gm-Features: AclHuK_eSsuSs47N6QK3g2E7GgnMGVY8PMc7m7IxLZzX0JjkDZoYycjEKtYvyFw
Message-ID: <CAE5sdEjVx-eGz4hkN3bMMJAag_g0hm+J18G6JvFH814Z4_ZGaA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Hide FEAT_LS64_ACCDATA from guests
To: Arnd Bergmann <arnd@arndb.de>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Zhou Wang <wangzhou1@hisilicon.com>, Navneet Singh <navneetsingh@microsoft.com>, 
	apais@microsoft.com, rlmenge@gmail.com, hargar@linux.microsoft.com, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 13 Nov 2026 at 03:31, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Thu, Nov 12, 2026, at 19:07, Siddharth Chintamaneni wrote:
> > On Tue, Oct 27, 2026 at 02:48:29PM +0100, Arnd Bergmann wrote:
> >> On Sat, Oct 24, 2026, at 09:14, Fuad Tabba wrote:
> >> > On a host that runs at EL1 (nVHE or hVHE), this also requires
> >> > __init_el2_fgt to set nACCDATA_EL1 in HFGRTR_EL2 and HFGWTR_EL2, and
> >> > __init_el2_hcrx to set HCRX_EL2.EnAS0. Without them, the ACCDATA_EL1
> >> > access traps to EL2 and the hypervisor panics, and so does ST64BV0
> >> > once SCTLR_EL1.EnAS0 is set. Happy to write those and the KVM change
> >> > once you're ready to post this.
> >>
> >> Thanks for the offer, that part is definitely not my area.
> >
> > We are preparing to post the Microsoft Smart Data Accelerator (SDA) VF
> > dmaengine driver for Microsoft Cobalt SoCs, which uses IOMMU SVA with
> > direct EL0 ST64BV0 portal submissions carrying the process PASID in
> > ACCDATA_EL1.
> >
> > Now that Fuad's KVM guest FEAT_LS64_ACCDATA series is queued, are you
> > planning to post the host ST64BV0 SVA + EL2/KVM patches as a standalone
> > series soon?
>
> Yes, sorry for the delay on my side, I'll try to get it to you ASAP.
>
> For my understanding of your requirements:
>
> - Is that hardware using an SMMUv3 or a different type of IOMMU?

SMMUv3.


> - Do you have userspace calling ST64BV0 on the host, guest or possibly both?
>

We are focusing on guest VMs first, where guest userspace calls ST64BV0 on
the portal mmap'd by the guest VF driver (with bare-metal host follow later).

> > Either way, we have Cobalt hardware with FEAT_LS64_ACCDATA available and
> > would be happy to test your patches on silicon, or help put together and
> > carry any remaining pieces alongside our driver series if you prefer.
>
> Sounds good, thanks!
>
>     Arnd
