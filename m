Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B64264F93
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 18:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740421230; cv=none; b=D+Iic4uwjxDKBzygDmpG9T1UrBzYr1L731ksfvva/KGryqkEjwRFyVl07ljWI5g7zf0UA1zRRpIrtS5pf1GGXPn21bNL25ir+pKMyjYe+jXpB9z/aKQaoAq57Wb6WBDfgHZlbRRwZZYMtmKI5FsEuXUCZCaAAA1q9Hc46KftYxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740421230; c=relaxed/simple;
	bh=+fWjvOFql4MYXWqia/zzl1L9GGvJoE/FTf4HrGaezp4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V9AJ88sjlO0EtpAN6cgRt+eeyC+zRhDGTxWHkPZkgn/+1Kwiuxz3HezbO8YcZiI4HpmQWDhryhR+5JMplBQrjS3HKRo22m8uEpE+ZQh/8Bm/MqUhFeGkwmZ1gBHB0+60tDe/jFVK+MbOYR/j6EqG6FT4BAbhZ3ZWUgJblCQL7M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XbqaJPa/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XbqaJPa/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740421228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iZrFNI4C7gp68g9l+kDtLtosIj+17mZI2t4068Zb7/k=;
	b=XbqaJPa/sUTQMNZZP9lDWr0Ej+xGDju8x7q4c1csViPQB3DaEzBvQwW34wX9g2Iwy0BcoI
	WLO7X7+mKvStSlc8VSijMQNq4k401ck6Kyao5mzrlhU1lFhpVYer1WeUnq3Es3JEr2Dpsh
	WR8VCzOmPNutp7+226fmeusy4m7dRpQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-TRs1IjV4O6qQqeK-z4qzEQ-1; Mon, 24 Feb 2025 13:20:27 -0500
X-MC-Unique: TRs1IjV4O6qQqeK-z4qzEQ-1
X-Mimecast-MFC-AGG-ID: TRs1IjV4O6qQqeK-z4qzEQ_1740421226
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43995bff469so39560945e9.2
        for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 10:20:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740421226; x=1741026026;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iZrFNI4C7gp68g9l+kDtLtosIj+17mZI2t4068Zb7/k=;
        b=mGx6i7wQzsWqv/Q4Osbqgm+OburRQAvCvlCIv40w6UVKp8LwyB1PXxU1Budt2aUMZ1
         e9lj4Q2qHr383eRwnIywdLrrSu82iZ6iQtesf5VcLMFK7buXXXVKMaD9T6hAvvAH/5be
         ct0k6c6hFjAPxwym6sxhf4mtgBtrHtWPhoiayUB+VHgq7NcZMkhnrVr8mUmZEFFWu1/+
         wyZKbOx8gwVv1JY2K87gg3CkcWJD735DMApBWAcvf0VykrH5FL0oKcPgHkheRNk51qWY
         OioWUUR+D/seP017mP588FC/FI8ZfRKMoF/pMG1dYcuGUkwHiXdS2PCgG0QbS03Erqoa
         MmRw==
X-Forwarded-Encrypted: i=1; AJvYcCWjnfObywK5xrnplVrv/hWWb9b9Yl6wOp5OXCHiATSNaJETiy1wOobN34j+aRUgXsIgh/m0gxc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxubxDaHdXX3AiT1CM4YcPhH0xkbrQPI1I3PvZ4xnnoITcrkslr
	qhtGvZXcTjY6iG2B8OKNddlIeqa7F7Cl6LFuqUx+ZRx8oitZzWCaJ6MZm0QsvERAAYlhAsRaf3K
	PQzFVnuDGJS8ohEmf+V6+sM0bqOs3Ygs5yLAoVSXPe/upVrsTK0dS/Ay2QXjorvs1JkxwYv0piv
	FzaKq2RknxMCGmIhEEOHCXC8FmkoLd
X-Gm-Gg: ASbGncu2ry5S8S7ON57PKma6zLBBZ/3AKnFeNwy0EBbUEQONJDmKnPxXHa5Jk9KLup5
	PS+zMQr6RXaGVxK3hLY3JhrR6N4pDG/nUycy2lwyTcCyYrpnglNuVKglCEm6IvKqibewR42PEPg
	==
X-Received: by 2002:a05:600c:1e15:b0:439:9cbc:7753 with SMTP id 5b1f17b1804b1-439b03246d2mr120217825e9.10.1740421225749;
        Mon, 24 Feb 2025 10:20:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEPgI3aLartuC/rneTquTEdyzyQpc0037VQO5E4VWeS/fDSQrV1vC9WSFvHP9NH6aMpcflu8dbApUxYsLMrEGk=
X-Received: by 2002:a05:600c:1e15:b0:439:9cbc:7753 with SMTP id
 5b1f17b1804b1-439b03246d2mr120217535e9.10.1740421225383; Mon, 24 Feb 2025
 10:20:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250220174406.749490-1-maz@kernel.org>
In-Reply-To: <20250220174406.749490-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 24 Feb 2025 19:20:14 +0100
X-Gm-Features: AWEUYZlnPj-9rOwF2Mzb1qT313FEPSpFv0way0dOS9rLvuEZKU9Q-G2Q2GVG6xs
Message-ID: <CABgObfbG1wWT0rCynqZOYr8mzqrAdZeTYiG+EDOy1BOqa3k+aA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.14, take #3
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Vladimir Murzin <vladimir.murzin@arm.com>, 
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oTWSGCGm9hThOSs9hdalOKlci_PJ_Wv9JcbPDCehQ0o_1740421226
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 20, 2025 at 6:44=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> Another week, another set of fixes.
>
> This time around, we have a focus on MMU bugs, with one bug affecting
> hVHE EL2 stage-1 and picking the ASID from the wrong register, while
> the other affects VHE and allows it to run with a stale VMID value.
>
> Either way, this is ugly.
>
> Please pull,

Pulled, thanks.

Paolo

>         M.
>
> The following changes since commit 0ad2507d5d93f39619fc42372c347d6006b643=
19:
>
>   Linux 6.14-rc3 (2025-02-16 14:02:44 -0800)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.14-3
>
> for you to fetch changes up to fa808ed4e199ed17d878eb75b110bda30dd52434:
>
>   KVM: arm64: Ensure a VMID is allocated before programming VTTBR_EL2 (20=
25-02-20 16:29:28 +0000)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.14, take #3
>
> - Fix TCR_EL2 configuration to not use the ASID in TTBR1_EL2
>   and not mess-up T1SZ/PS by using the HCR_EL2.E2H=3D=3D0 layout.
>
> - Bring back the VMID allocation to the vcpu_load phase, ensuring
>   that we only setup VTTBR_EL2 once on VHE. This cures an ugly
>   race that would lead to running with an unallocated VMID.
>
> ----------------------------------------------------------------
> Oliver Upton (1):
>       KVM: arm64: Ensure a VMID is allocated before programming VTTBR_EL2
>
> Will Deacon (1):
>       KVM: arm64: Fix tcr_el2 initialisation in hVHE mode
>
>  arch/arm64/include/asm/kvm_arm.h  |  2 +-
>  arch/arm64/include/asm/kvm_host.h |  2 +-
>  arch/arm64/kvm/arm.c              | 37 +++++++++++++++++----------------=
----
>  arch/arm64/kvm/vmid.c             | 11 +++--------
>  4 files changed, 22 insertions(+), 30 deletions(-)
>

