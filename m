Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFC54C226E
	for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 11:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789732265; cv=pass; b=Edr/VMuPZXHirQGgOA6Ysqxx70ILIGkBb9kh/GxxArIaQViOWUS2gCrnIdR6cS6WA2GDu2qxQ67nY5KRs+yQ8mvbXdkOssS4cwu1WsE/pJC8oEvAzZaHkwL57snOR+iB2c9BIsHmaUcn6QQmI1PWpQku+f5VvU82Pi2byxY0vdo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789732265; c=relaxed/simple;
	bh=HR32eDowvoU7s9fv7SYXh2McaBai5hrd98uYm+h1guU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EbD7UHuFbk3QJsi0LGAfxqc/cqk9EF2NcE7iYI2sWcgja14pc9lvs79CQSFwo0/d0Fjaee8QVEvuLWdUVl8ZFLKadRrd34HjJPcMbiX6fRfUnNj2hxtKmmZPGTNhfwJqyFBkMQOZXyPuDCFouzlhRcw39fKaNOsLCVXCzNA2xc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r8UqKyrt; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r8UqKyrt"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f55efe5so96499166b.2
        for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 04:51:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789732262; cv=none;
        d=google.com; s=arc-20260327;
        b=pO0I0c2B717l7zr4t49IHOykjh15QC9tTGuC/Wkv+CeRGt1RgOI8FE6fC3MbOxPy7C
         cCD1E1jT9l5dddbLzIewmvmzdCEcq1X8YMGsyReXo47SndHPZs9IXUf2i1n+a/9tQbaP
         nejTuuLbrIvUB5xd7w0MqUlH+NgBeLHeYDrd/LeFD/kQ2Go0wsWp+n7WUiKdXgIHIQtc
         MNJAoO+4yI9NhyFl774aj4j6HG8WLER4gg5Y2bPREvJ95sY3qTa+POspB8pPjGPnY/4c
         fEz11c4EA37NENnLPTSjRbjjnDtF57HAi+rX0sjnEc8xfAbTCsNZAFzSsyBl13+dCFYd
         aIVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HR32eDowvoU7s9fv7SYXh2McaBai5hrd98uYm+h1guU=;
        fh=oTb5nDnYuJqEbG62fV1mmBNtVuLhVD3WUleJsSplxS0=;
        b=IoHCONUOd5eFGHwAhCUqqWekKsBAXGeFR1UxaYLVdkzA6vgkgXRlaA4h1P2QM8E70D
         gdPBmt2Ox8x4khnGbeV9b86c/VUq5wahE+xgFftl91TPTc4t7W14CodbNafSXb50N9bO
         7uKDr310EvvLegVV4qnDKpZk4cFg884mLTZHfXdisW9u/LmpRNSc0PYaKXa9yjAsEeCH
         q/3qV4sSy3fS2xvUwu+CUxU7UGhExaKi4ItKAeTqVsSMSYSZ/odWhroMs5Lw7UpVaMe0
         NsZBO39niEDeECHG4YaxlM6BuQoK4Si4cc7HnaT4HNEtLFCTaqUPm0aot0TvzlymJuS5
         Nx9w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789732262; x=1790337062; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HR32eDowvoU7s9fv7SYXh2McaBai5hrd98uYm+h1guU=;
        b=r8UqKyrtSESohhxflp/h00NzxHLNU9QRufYIqkuUldQDs/Cxqax7oGmlomzTu+gcBj
         6YByiJN9xXGSp/w18MWZ7HRcPvDKWD1r+sAHayCuigEOxb/nmuG7wHcdUesmL8zeR4du
         s6nkzCwDNw06XxMtNpXz+4yjZwVp+E0+PqyiPP2dLxvkxYR5dkXIBxSzQs9q7HYojOZa
         CdxKtiRXx4JHobuhL6gFN2KfFImNXE+hhv9kVKLgD2OndkoTgEF6v8ZWr5HeSL7hnnMv
         Cl8qVnKFVHzfmTwl2k0x4LvBGWUX3WQow95NaLwOk+/9NOiEZqLXpmC1DX33/cx9iWOn
         TLZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789732262; x=1790337062;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HR32eDowvoU7s9fv7SYXh2McaBai5hrd98uYm+h1guU=;
        b=VIt44aBuWPQt0nv6C1z8Kr7wE/P8v2eubrixtpqLr0hNJkfHKW/84xPYAqWVmN3vJD
         Y4fsA8ud4Eqn1U6jllDwfPH8qne3oYlGh1H3Xovimkiz7tBml6HiWZDYKsZal7KWYoky
         0EWFh13pa6EscRopuQume0XXtwSnAUpzGGRNUu5YZ6arPOgdfCeubRq/u0FWUbOxN263
         hsZlTay10tcaUDX7a5CrzQaTlaj+dJDZJqWho6U4unXcVW1V9yA5LmOBwAiMISUUuRcw
         dWkQC6nYZl1oF07yBdLkvDjmxyWFo4Q9SmFDCaogzvcCGURXv0MKmL+V5sXi4mWW55hS
         zoEQ==
X-Forwarded-Encrypted: i=1; AKwUvByrqLVBtMTnPd30PdSHqx7ZJhuysozw4OcdwQK4+v3oglr3QYNz0iEfzfe4elvLtgyhAslsoxM=@lists.linux.dev
X-Gm-Message-State: AFuF++lb3az3KzXihDXsXtPrK8Cp5wyoacyxqQj/CBc+I+qPbDBL00Un
	abnwPIERsSTSYOXpVViuAEFegYhqSNkYUAUDJNCWkXxf6f8qoXIP11TrqConbLvsRvDqWR07e5T
	woI5JpbodDXVGrEt+JvV5M00pR16sWCk=
X-Gm-Gg: AYBFou3KIYsQ8UqQp/R5V3HhOwgpItGHn9qzlLeEHz8rDXRmB/o2q7mi1BbY9X1Hk/G
	P7Wbn9XC4OLRZzXifRRhQU8wWLMwLL7ITdA9qgX3FVESm4cU2vg3gspzh6zteYFrNGqePYnBvj4
	FEnRmhEwuktZkecbsgynseWyhBDsSpzKqJ2ilLVga0nJGU+rAYRDLqdL3vRtZnJj1Lspx3wMYxF
	9EVngtoBvLXXw5H/ys+8/W/whAnMFrlTZACqIsQFN9IfIcoecB+a+gBXSWsPB3GaBiIhfLkAGPb
	wZYDRsSB70lp0vdil+p+bFNk1PxtBHPug/Xul/ItilMMfbCUgZj0L3kI5tE=
X-Received: by 2002:a17:907:970d:b0:c24:4128:c19f with SMTP id
 a640c23a62f3a-c2a15699fdcmr247289066b.11.1789732261931; Fri, 18 Sep 2026
 04:51:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260918040214.85580-1-ndaugoing@gmail.com> <20260918040214.85580-2-ndaugoing@gmail.com>
 <CA+EHjTx8zzvgqj99TKWfRD58X-M8v+hs9358_r_1zZonFNEsgw@mail.gmail.com>
In-Reply-To: <CA+EHjTx8zzvgqj99TKWfRD58X-M8v+hs9358_r_1zZonFNEsgw@mail.gmail.com>
From: Yuchao Zhang <ndaugoing@gmail.com>
Date: Fri, 18 Sep 2026 19:50:50 +0800
X-Gm-Features: AcwNN1Wto2_O0uy6UTTB6in3F4ALPKeKnrIKn4mv5wL6jmnw_dTYJHrXeQ1oo0Y
Message-ID: <CAC2BP3K-fvW2s2j2ys+kPMuxrzeMw9yc6MrAk7U7CqCpb2WePQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: vgic: Do not remove in-flight LPIs from AP
 list on disable
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Fuad,

Thanks a lot for pointing me to that thread! I was not aware of
Hyunwoo's earlier report and the discussion with Oliver and Marc.

I'll read through the thread and their rationale on the ap_list_lock
approach. I'm happy to defer to Hyunwoo's effort to avoid duplicate
work.

Thanks again for the pointer!

Best regards,
Yuchao

Fuad Tabba <fuad.tabba@linux.dev> =E4=BA=8E2026=E5=B9=B49=E6=9C=8818=E6=97=
=A5=E5=91=A8=E4=BA=94 15:22=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi Yuchao,
>
> On Fri, 18 Sep 2026 12:02:14 +0800, Yuchao Zhang <ndaugoing@gmail.com> wr=
ote:
>
> [...]
>
> > Note: this closes the primary race (the last_lr_irq node itself is no
> > longer unlinkable while in-flight), but the fold traversal can still
> > race with a remote flush unlinking a subsequent non-LR node in the
> > ap_list tail. Fully closing that window needs the fold side to take
> > references before dropping locks (in the spirit of the prune-side fix
> > in commit 7258770e5814 ("KVM: arm64: vgic: Handle race between
> > interrupt affinity change and LPI disabling")) and is left as a
> > follow-up.
>
> This is the same race Hyunwoo reported back in June [1]. You might
> want to have a look at that thread first: Oliver and Marc's view there
> was that the fix is to take the ap_list_lock in
> vgic_v3_fold_lr_state() [2][3], and Hyunwoo posted a draft of that
> [4].
>
> Cheers,
> /fuad
>
> [1] https://lore.kernel.org/r/aiHrGM1f8czcUby4@v4bel
> [2] https://lore.kernel.org/r/aiJi5a3JJ-TbWL-s@kernel.org
> [3] https://lore.kernel.org/r/87a4t99z9n.wl-maz@kernel.org
> [4] https://lore.kernel.org/r/aiXvwGD1hS6vwLEd@v4bel
