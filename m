Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC7033DED1
	for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 17:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777395832; cv=pass; b=SWETqyQrXcD3Esi3Kk5+qa7MgYHQ9OAmN0zti3DDIF524x+0waS2VyqsKudLo+zNci9lOtPyvBbTn1b1VVj8wdeUUH3iiC4H3E1sPGgpbpo34DtSWnYH6nBovPUDKgxFr1fxBemzlAAx78vQLkotXI1oXk/ZiTUNqPmlnla4xCE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777395832; c=relaxed/simple;
	bh=1zJiD6uVVjfJZKq1rBMnu25vKAHnwzgWRAcpLmQwMq4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dQ1GVRcFGeOMddF6PjprXlxYUtYlkAyg02fiXJJxnX98hRSnPiuPG/X8miHGF1yqFnXE6PhwoYmxoQPds8hP/Cwjm2JHRWBxw/mTbRwzIeVRWRfVzgPV7CkqbGYglKJvamp9kUx1LnmszRjTgljAJSzswwIJ7K/cBZU6q07tNZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X+ZN0Exc; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X+ZN0Exc"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-50d864c23bdso840131cf.1
        for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 10:03:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777395830; cv=none;
        d=google.com; s=arc-20240605;
        b=hUh1QPoZpTKxsm5Xu2SwYfT38+fCq5NiCS3dUOe3FDnZmOserlxQ8OmO2gWTxV3RQ1
         QIZIWjqokn8utaUdxZ+wyGVaQbrEqLlIExZPC+q53sBIyrGfCFIjuy/lTopcHE5aFobP
         xdbTlnbpypJtWNa1ol70wT3mTH5C86ALAlAsIElBHTRbBes1GSMZh1XJqkKx1ghXOB7J
         /hsxGG6dHKpBk1yfw2ZtcpmJY8GXyX3Lw54tSRTnN0a1bsbiP6pJaoDFp7vIDGWjFCkR
         J/ls3NvLyCUMAYwdkwtgKQbcV/uwVPnqtRZYq8q7LZPl3cbgWqMQpIgxPnAVCqplrk+S
         2zBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vRxyUyWR/bvwIckxaxOIFLoCtm5E8wIRuhM7yIvbG+w=;
        fh=Do5IvBzM5TaoKQARJ0yY+hNNkS61dyRAoZnQDCKTT3A=;
        b=LUfPHW0ujXTYzi5Gtor2kqXS/4HlLq7bRp/QNpOveF6/fIo4M0yWJxv/2tKWgWwwq/
         2esUPqnQYSDmL1Ip3Vp5DONGXBWqhuNZvl2Px4rAR32/aRlC9k2+TtylVfm0EPHGQnHB
         BLEzC7hqFkWElsBlyLcRbb9B+DuUYk931VKUdysog9Zbz20XA5SbvfCzgY3UswUz2lB4
         ZiGTrqxXxoTudnc1BAPEbyZkQDTDpX9iDlKG8eKIudnmM5290/FYRUCTAg9SAQK0UC+a
         jpRnt5lYrueIl0BHU04ZiwcMatHgQ8UDwB4tt+9hE0DUoT+TQts39djMO1sA+mHHLLTU
         ANuQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777395830; x=1778000630; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vRxyUyWR/bvwIckxaxOIFLoCtm5E8wIRuhM7yIvbG+w=;
        b=X+ZN0ExcUZe4TbuOHnIu0nxIZypTBVY5Qs/LEG5eJ7daoGDv8lwLef5CBFOjpXaUb7
         91gpTXGnuX7IOjBfneLKvymG+EYYKOK2ZQ9ax5/6czLve8ffUJQwtgOrc95Hin8BaOnJ
         cTcU9thmy4K7s6RCjSb5ulk5xd+76SS9akQKnINUwVHEdqSngfQ9bWeQCE2TKPARW9yK
         3mvDwns68OWFoZlvs/gOoWiesot2cZsfRS11OQPC1SVRZ2bV1itBQubmaxevHoew+HLX
         SgP48PstiZx/M7ERfE2jgrVFLB7qWjk9+px8Twas+EGniUT2wL8ECM1Mp1qEW1J+m1tH
         nqdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777395830; x=1778000630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vRxyUyWR/bvwIckxaxOIFLoCtm5E8wIRuhM7yIvbG+w=;
        b=mRvDKKl45hUDXb5Ndm0h/pQEiQX0ImD9MDOXQqJcMGC1vcEMjUhmQ9UVEo3nYM2BQr
         3HSmpPnGwdyssYbUvSHNbxJnNSmpFa+N1lhNE7I8Uq/kpHDCR9gfiARz1rReQhgGpHV4
         oCqiyeXPEeviHliQYWP6aDFwAPnOjDtaQpCqKg6b5GDicLjMh9hKOHXma+kMWNJjs06Y
         LRqQMkd1Jf88wWtC11ZG2D7fmxejfD2xNoOBOi/jyGOooO0PUs7eghRtyJEgl4E2IGId
         oe1nEYAWJI5oz/u3FONRH3inmb/JEayiX35a7IbPPiH31uR60sqjrARuPng4yuoFoS1I
         1E/A==
X-Forwarded-Encrypted: i=1; AFNElJ+EirJfQeqdu7CSSx402O/rCvRftq0tKxYOLmj4js+OsUg55xv7qzyRmyKj4j1u9871BqmjL9o=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZ6uR/Hn/vmJZ7gGbuYK3/y4esGGXmZLeacKfWiQNy7BDKengm
	F6yTwyf45DcLM8c8cNbTNe3LMvQr53P1ZwN40rMWfOVoTnf2DMTGOw2d6okRBu10dkYtgbL0w3S
	SClDdteFlmsqQAvjUwow0/1PyfAZXHz1zRv/OpNkI
X-Gm-Gg: AeBDievI1FalDhSJYBZEDmGsDaw+uIBiQIaUwzmthxtlTntmdvPV0OT1k8L5b2Jqiq5
	63C13ULFrturOC+MAnl+1BINLbDXgYg7zRQqyxTVDM7E1gm+rzoHKTKyW0nSRoQRhsxaC8YKrqb
	7ZSar5HaP43SbWRrTxE74/kVbuHrl7PTXklyguxrqOaL7IZmXKRvS3IRtKXlHXX6T+Zv9OT38Mo
	RLz/hPLXvcRecRAkq+NoddL5X+a6GsQg2l9KNDzZ0DhllcGkAQU0wGIZWYzBnI+ynf4zLyIoZX0
	G06TDg9+0MzfSWAT2gRA1LK3OR/VAQrcFfxu0pSAe3Jus+5q7/LsZr8xjkt8Fr4=
X-Received: by 2002:ac8:5dce:0:b0:508:fd42:fd05 with SMTP id
 d75a77b69052e-5100ddca71dmr16116641cf.15.1777395829071; Tue, 28 Apr 2026
 10:03:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260428103008.696141-1-tabba@google.com> <20260428103008.696141-7-tabba@google.com>
 <afC5_jrTEVRfJ77x@willie-the-truck> <CA+EHjTyTy2qLm=CbOOYR6rmjg5tH38PifAV+qAhbZxidY5szxQ@mail.gmail.com>
 <afDnCiQNJrP7UI2m@willie-the-truck>
In-Reply-To: <afDnCiQNJrP7UI2m@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 28 Apr 2026 18:03:11 +0100
X-Gm-Features: AVHnY4Iz1X_G7zdc-Gxn4ezijbkjPSVmpE0EY2ldntjmUXB-MEgat-SQsLz5Onc
Message-ID: <CA+EHjTzO1=LvBF0UFXu=ubO_-TezykxLap9c8CxxvuCT-=3SUQ@mail.gmail.com>
Subject: Re: [PATCH 6/8] KVM: arm64: Propagate stage-2 map failure on
 host->guest donation
To: Will Deacon <will@kernel.org>
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com, 
	vdonnefort@google.com, catalin.marinas@arm.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Apr 2026 at 17:57, Will Deacon <will@kernel.org> wrote:
>
> On Tue, Apr 28, 2026 at 03:36:43PM +0100, Fuad Tabba wrote:
> > On Tue, 28 Apr 2026 at 14:45, Will Deacon <will@kernel.org> wrote:
> > V2 will drop two patches (in addition to the HCR_EL2 one), and will be
> > as follows:
> >
> > 1. host->guest share and host->guest donate (kept, rewritten): add a
> >    memcache-sufficiency check during the existing pre-check pass
> >    (option 1) and return -ENOMEM cleanly without touching any state.
> >    Restore the WARN_ON() on the subsequent kvm_pgtable_stage2_map() =E2=
=80=94
> >    with the topup precheck it asserts an established invariant rather
> >    than ignoring a reachable error.
> >
> >    For the single-page donate, "topped up" is
> >    KVM_PGTABLE_LAST_LEVEL - vm->pgt.start_level (mirroring host EL1's
> >    kvm_mmu_cache_min_pages). For multi-page share I plan to use the
> >    conservative nr_pages * (LAST_LEVEL - start_level) bound and flag it
> >    as conservative in the commit message; happy to compute a tighter
> >    alignment-aware bound if you'd prefer.
>
> For now, I think we should just check against kvm_mmu_cache_min_pages()
> because that's what the host is using.

Ack,
/fuad
>
> Cheers,
>
> Will
