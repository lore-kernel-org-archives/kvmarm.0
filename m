Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE520130E24
	for <kvmarm@lists.linux.dev>; Fri, 16 Feb 2024 17:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708102981; cv=none; b=USckgunKaH7ZuKPz7xEAga5hGAEvHna5xqMgU08mUi7KjyBFaoOsL65bjiSlexzR0DjOUiUb9B6tIYvkvIz5VPqPWnZDJws/3B0iDuyCnHNq6CIwrh3xQtajR8iLB5ziE5Wi48hwmmtiUd0YH/drSVREGBdwK1BvJi0LdIVdg/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708102981; c=relaxed/simple;
	bh=zwGqJ2fkeXVi3yXrrkK8rAprQjwepMa3oWgrp7ecopE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wqkt82JdrrGkIIUAJye0+WhBl/Wn14XfLOmEShE34PugTy9QMtvK2LL133InFDtcRUJ0bXGp3HHwr40ks93AdtJNbL5Dkh7XYQKNpw8yZONm/lP/C0CV0DgeeNxOf4kg1m610ch5ZJ+YxNcb+ALDtV+LjbQ3IqcUXvRcVUkFgAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H7f59k/U; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H7f59k/U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708102978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XCF50IBRGmP/fByMsTs/u54G4bp+bCTmfaSrPpKQ1uo=;
	b=H7f59k/U0UWQSggKbwn4IgrZyRQqz8Uc43rIiDMyjd9JWQigYqsXF91+/dwtdqGhTOT6lM
	Int4YnPe7n4LOR54jIDKMBPxLBfVKlvqC8gcdi671xFw9J9vLTjQrK3FjxSVizMnFcJMTf
	gighQX8COCaE3tYpXvdBRWTvUzpi+yg=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-3-RE2vPKDHNrmJOhnTgJXruA-1; Fri, 16 Feb 2024 12:02:57 -0500
X-MC-Unique: RE2vPKDHNrmJOhnTgJXruA-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2d0ed64f06fso9371921fa.1
        for <kvmarm@lists.linux.dev>; Fri, 16 Feb 2024 09:02:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708102974; x=1708707774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XCF50IBRGmP/fByMsTs/u54G4bp+bCTmfaSrPpKQ1uo=;
        b=NYQS2NfrmeNY1RMN1DPJSh/vQmDjmM/iurqaHAfY+mRrgsPtRNBN1+JcBV57YUKsJ+
         MJkgef5l8f3a7rlNBezTlaRpRu5A/4MlaNMTFyV+YQHUGPsgGAgzwfAZiohgRN/5Cb/O
         kIOeEQ7Nosm4YJeNLNmTFfyHH7l4HlyRTapsH+1IxVbngEX95w+9FCpcA+TU4XzoDoRm
         6Yi5PtaS41BMAnpKLbLMqH6AobeNlACsptDvsuXRxD3zOjVC+rMEsJ+DCRQ3vpmcJG+T
         LBfjzyZcyurUpcTDZOPyDVAaGcozAmSW32suEPVjlHtIVAtnIiHRUpZFohzkqNrv/nFS
         Y5kA==
X-Forwarded-Encrypted: i=1; AJvYcCVd+xAjOFnjxSz+UCSVwlhi0LYO4xcjTW53sdqbrljuNbq/wiKpZ5kMUhrbqJWql0FQuuI+0tX8w/ssG9sbPosZDX3zIhjd
X-Gm-Message-State: AOJu0YwQhojd+Sbkzt/ghMedWfBrpDcEpuB48B6P5II+mC0cw1pkMWmW
	VxfigKuGX7+DNVYt/4XYw6KvYZl+EyJf/mH/dq5UZtHjkpQT0/Cenh5vrzXeBpDvw9DoPN12ckN
	j1vM0jlkJ1LiK9gz7AHfxrGl7NzzdAuuQDiKQqZcp84Tx9MkkjZGimpGHpd0axQIDhL6sAxP5bK
	e51o3KyOMuih/KOtCiZSlElaReicjY0tcA5glr
X-Received: by 2002:a2e:8812:0:b0:2d0:99b7:e68c with SMTP id x18-20020a2e8812000000b002d099b7e68cmr3187973ljh.15.1708102974549;
        Fri, 16 Feb 2024 09:02:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGGN6nw3gQobDUDZcnFDlf7+jbQOPBJzQ28faqnSRYOwwYW67ZgndKNx5rvCkm2md+nuH+eEh+bF32F9J7zeB4=
X-Received: by 2002:a2e:8812:0:b0:2d0:99b7:e68c with SMTP id
 x18-20020a2e8812000000b002d099b7e68cmr3187960ljh.15.1708102974223; Fri, 16
 Feb 2024 09:02:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240215152935.3093768-1-maz@kernel.org>
In-Reply-To: <20240215152935.3093768-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 16 Feb 2024 18:02:42 +0100
Message-ID: <CABgObfZAr77NxyoMCih1+hVQ9=Usu9p+yqkoqdCBQSuWwPvv1Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.8, take #2
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Ricardo Koller <ricarkol@google.com>, 
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 15, 2024 at 4:29=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Hi Paolo,
>
> Another week, another very small pull request. This time, the bug is
> irritating enough that I want it fixed and backported right away. It
> has only been found by inspection (thanks Will!), but once you've seen
> it, you can unsee it.
>
> If you haven't pulled the previous tag [1], you'll get both for free.
>
> Please pull,

Pulled, thanks.

Paolo

>         M.
>
> [1] https://lore.kernel.org/r/20240207144611.1128848-1-maz@kernel.org
>
>
> The following changes since commit 42dfa94d802a48c871e2017cbf86153270c866=
32:
>
>   KVM: arm64: Do not source virt/lib/Kconfig twice (2024-02-04 13:08:28 +=
0000)
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.8-2
>
> for you to fetch changes up to c60d847be7b8e69e419e02a2b3d19c2842a3c35d:
>
>   KVM: arm64: Fix double-free following kvm_pgtable_stage2_free_unlinked(=
) (2024-02-13 19:22:03 +0000)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.8, take #2
>
> - Avoid dropping the page refcount twice when freeing an unlinked
>   page-table subtree.
>
> ----------------------------------------------------------------
> Will Deacon (1):
>       KVM: arm64: Fix double-free following kvm_pgtable_stage2_free_unlin=
ked()
>
>  arch/arm64/kvm/hyp/pgtable.c | 2 --
>  1 file changed, 2 deletions(-)
>

