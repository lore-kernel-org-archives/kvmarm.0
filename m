Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2166626D4DF
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 14:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751986098; cv=none; b=azijH+qKtGlM+3LeQ0emaF08R8sCTIH0j2ZFH305FZRl6A16fHmLX7AFb55s4GaNoxSCo5k7/lSilVV9yiGXK3WqxMNJOpqMOkdPa0Yc/rqnsQe0JBNPFR1kmf7HRxKxzihrper61CnmZ8yqqNwhuPS2mgNF3w4R1WZDV8B9pgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751986098; c=relaxed/simple;
	bh=K6D0w4TlB1r2EMOgBoPLENgpbBMsqqcZbsDwAVdJIRg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pJvertBNk6eES4t8Ohgjh37U7EjVx+jrMl7mhIvFLEAhBDswjbQ0iU4ykxF2b4cWBrTxa+yrGYhUwFwkSs8hG9oU0Uswxj/WtSLdamGM4/RRbtWu/XsNxDbENXJM/fIkjPw2TJAfM1GC358lQjV8JERx1FGI9UaVTiuQTAgF8jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W4AmxOP/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W4AmxOP/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751986096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VYwFNZ7gJ7YL/bHRH7pGKeSkqhcvD8xNXSGdyMHjqaw=;
	b=W4AmxOP/b/rOln4svI+tHyspeH6aX7BEkX6HENZoN7ZlEt+m+6mXsLLcOsYg0nUgYPt0LE
	0ZPjWPrLmhz9bMggMu6NyqoBc23HV3EYw8yPIkdUzNNEeA0hPfx/o9vDCFm0MudYx8M5ih
	CA4yAbIfg5EFug5wvpDA1ORcaLWDyvM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-fO4_RqnCMM-CGBmnQ4CAuw-1; Tue, 08 Jul 2025 10:48:15 -0400
X-MC-Unique: fO4_RqnCMM-CGBmnQ4CAuw-1
X-Mimecast-MFC-AGG-ID: fO4_RqnCMM-CGBmnQ4CAuw_1751986094
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a503f28b09so2566465f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 08 Jul 2025 07:48:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751986094; x=1752590894;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VYwFNZ7gJ7YL/bHRH7pGKeSkqhcvD8xNXSGdyMHjqaw=;
        b=F8ZOnpBzxg0MxBzFFhZ6odyCur/zO1MtpmrPm9lsgsB6zNqg78Nst3Shib+/jVhNhp
         S5XMU86NGvHfbBTumJGC2kXqDigUXUzeYWEejn2TNScxGU1KIaHSfgKQDFDmvhgAwNk2
         ykbIMsQYuI+fuuOuUmerbvmW3d3MXqRGWBBYtWupnfyXXBPM/Bbc8I+isgQI9z05agha
         07ELf/ZcindYzSxelbQ12TyWh7rPrIGXf1SHN/aETeLAxKjvxsL190rToTDJmKuJor0m
         ZvCFQ76DjQnkup6V7r0Q/NKd21U+r8GVW50a7dkbUeVnCKI7JLYGWETSHTzLhz+yzpvu
         FSYw==
X-Forwarded-Encrypted: i=1; AJvYcCUbttDJ+30mh20vWr/wmJyOu4hPfoWszIfbB9MfFREMFywSfLgpc+jjEgTEYFeQyAUSmvfZU8k=@lists.linux.dev
X-Gm-Message-State: AOJu0YyHP6J7qiPF3yh4jTn5ac2aiyqK1VdV5Y6P7btUhCoH+ruItZqO
	Ky1HpOC66p9ygAu7y9fxPIcAFngXLv2tXzGztU0yVxttZh7XLIUGuWygyn8TbNuZOKQK13zgPCa
	E9GC4iSrzG4+mpHfIKJXhntj5dMGHewwtRAWqgDs7OF1e9RG8XRafvv3X4AfuFvhOdCEQznIKQW
	myCA2heNvrqV+/seUJupwW1ybf1Ng24Ct+
X-Gm-Gg: ASbGncv61gdBRGIq89rcHy34IbtCP2Sm99jLegzPJ1qkhBTE97XCcsp6eq7Z9M33SDV
	FayegIp1nUtT3na8pTHyL0cld2KBvxT6v9XWFFwkEIap8Jc8tDQnHyYK+pYmm+qk3HWcgO5LseB
	nN9w==
X-Received: by 2002:a05:6000:2303:b0:3a5:271e:c684 with SMTP id ffacd0b85a97d-3b5de020c32mr2975734f8f.24.1751986093511;
        Tue, 08 Jul 2025 07:48:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZiM0/9n6ueMPFfbYNFhT+fBviGPPImQB1n/AEnAcH0tJWdCzJAc7ZdV1DzjlOYDO19wxA0F443c++AksjL/c=
X-Received: by 2002:a05:6000:2303:b0:3a5:271e:c684 with SMTP id
 ffacd0b85a97d-3b5de020c32mr2975705f8f.24.1751986093032; Tue, 08 Jul 2025
 07:48:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250626152023.192347-1-maz@kernel.org>
In-Reply-To: <20250626152023.192347-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 8 Jul 2025 16:48:01 +0200
X-Gm-Features: Ac12FXzzshxqceQql3qnuEeB1aBk-3TKPKyjGfeEqol9jVWILuBd4g9oY4XHIv0
Message-ID: <CABgObfZ3RepTFAMVSB4v1cmuOg+JB7LAcqx04EZui6qF3q5QtA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.16, take #4
To: Marc Zyngier <maz@kernel.org>
Cc: Mostafa Saleh <smostafa@google.com>, Quentin Perret <qperret@google.com>, 
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4bvwzbVag9GFpG_64vxH8_O9jqLHaSrUSertSx6CEdI_1751986094
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 26, 2025 at 5:20=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> Another week, another set of fixes. Nothing major this time: allow
> pKVM to fail to initialise without taking the host down, make sure we
> are not mapping too much in the host S2 (another pKVM special), and a
> brown-paper-bag quality bug fix on the nested GICv3 emulation.
>
> Please pull,
>
>         M.
>
> The following changes since commit 04c5355b2a94ff3191ce63ab035fb7f04d0368=
69:
>
>   KVM: arm64: VHE: Centralize ISBs when returning to host (2025-06-19 13:=
34:59 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.16-4

Done now, thanks!  Note that in the meanwhile git:// is not working
anymore, so you probably want https:// in there.

Paolo

