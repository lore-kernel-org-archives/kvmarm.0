Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8022A1AAA1B
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 13:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733838977; cv=none; b=okm/DZtfvQ2GIt/GbKm7ULZqO3Jqs1TZtB8v+9bycyhB24ZMkLQMXvvrlKWSBhsYbmehsd7Om5I9Ef0sDxu90KMonHybNsV6gSscpdSJHfjXeO9XiwD2vMRbeBwF9IlCl9OfNNCRObcIZif1EDKgXH3k9VFc6Yb42sXrK5d/XzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733838977; c=relaxed/simple;
	bh=81SDwr+i7U7nSFtgaowgS3f+OVFldJCp5ag1L+YrymY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HyvqwXR+MGmhUkfJPwuRULGpq2z32YfWmA2wdgVQpd9xurnotsZ1OxAHSJqY8o6K+OPc1pr4Io0OWg0hKJnSZipJV10sfuPV1IdQsHj1DgQ+7a0ZedUaNiBrLeYkrI3CkpX2D/j7/Dbk12QDyKGpnyY49A+3ELTKjMPxuKl6UPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q9Dziher; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q9Dziher"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733838974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pSFsmOdcddKIbSt6Sh45W8nB+T2Eq7+gB4QNkOWTcWE=;
	b=Q9Dziheryldl+QVF0EqymzP5Zec23z42JHveQuHrgramDfb/rkb+EyT68aDO7TBISf6UZ2
	TgMTuyPnLu9rZLZDsZ1mZskXSdPRWuezzW3hcwbYI/qQLQ2Yi7s3F6mFsYPV8fyR6sYSqe
	L0GWoary69kzhVIq+taOfxoR3aodmp8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-i5rnwkhzNcqng7WfcpOZtg-1; Tue, 10 Dec 2024 08:56:11 -0500
X-MC-Unique: i5rnwkhzNcqng7WfcpOZtg-1
X-Mimecast-MFC-AGG-ID: i5rnwkhzNcqng7WfcpOZtg
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43619b135bcso1705135e9.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 05:56:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733838970; x=1734443770;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pSFsmOdcddKIbSt6Sh45W8nB+T2Eq7+gB4QNkOWTcWE=;
        b=ZkmWOfKwPskBNXXo1/SwW61eG38W9x4vnZPqX05hF/fWspJ5U6h5I8lYBJJr2Ym3iI
         k+ohYcIzMHyuyvC3lUgAQSzfHLv6FcoHLtMHZA0GWJimZsYzapLk0/ccXw1WZpkS/xX7
         gXFuM3Xc55sc6G5StqkPNIluV2R5Pcgm0z14AnixLacE20qGxyncwqbCDYP6/4XexrYP
         iA5ReQXySiBcMzC6aUrdGiLQLfmboP/FU0d0YBIvw6ALRurLvXDaB6rbe/fYF9X488Xo
         b3uozFicqijwcPuduuN0dEiedyqBfSnHJwoSyx4Ml8uIZwb4DHTZiIDYuJsX7QEWcPMx
         tN+A==
X-Gm-Message-State: AOJu0YxSr8IY1sWRXJl4TrSXgAwajseD5MAJ8xF00xNGsjFaDZgnsgUb
	rHwL82eFeFdT/we8gDQ8muc7cdv8a2ZHLatG3vQUL7aNg0Chb+fUZIf5UUrFpX019LfN6n/vcWW
	gA9/BEhP+Ub7AuRyB4pM3R2N1wajB9kE1+rgDuOT45BoH3TzI0Jd+hoqU6QNJbXf8DRvg8jYP/j
	T+wR+n+ruI2hXc1ndLviofkF+gk695
X-Gm-Gg: ASbGncsu1dWk573osE3g5aA8ilbCDhx6jZlefB6DBQs610CPQm9z5wUkz/7d3GRYngF
	ixTnbLTwK+m2HHG94RAO4pj3He8OVkBOJusE=
X-Received: by 2002:a05:600c:a46:b0:42c:b16e:7a22 with SMTP id 5b1f17b1804b1-434ddeb5573mr131813295e9.12.1733838970196;
        Tue, 10 Dec 2024 05:56:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGT6PKtby95Y/i0ysLL1kDTYIt+/yB6BbpbwY8jHyRrAnXXeBFggcg1I6c0FSATV4N/GlcZ6ogQmesGlCgDfo4=
X-Received: by 2002:a05:600c:a46:b0:42c:b16e:7a22 with SMTP id
 5b1f17b1804b1-434ddeb5573mr131813105e9.12.1733838969816; Tue, 10 Dec 2024
 05:56:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Z0-n5WnAg8tBjLhG@linux.dev>
In-Reply-To: <Z0-n5WnAg8tBjLhG@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 10 Dec 2024 14:55:56 +0100
Message-ID: <CABgObfZqKKAmJuL+awFFQ8Y1+GvTOWNuvPGav9Y0DVWRhC7EOw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.13, part #2
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Keisuke Nishimura <keisuke.nishimura@inria.fr>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Marc Zyngier <maz@kernel.org>, James Clark <james.clark@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E098FN3UqLsm3hhKl9RXLDEMk15EIutHm9UwdebdKoA_1733838970
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 1:53=E2=80=AFAM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> Hi Paolo,
>
> Another week, another batch of fixes. The most notable here is the MDCR_E=
L2
> change from James, which addresses a rather stupid regression I introduce=
d
> in 6.13.
>
> Please pull.

Done, thanks!

Paolo

>
> --
> Thanks,
> Oliver
>
> The following changes since commit 13905f4547b050316262d54a5391d50e83ce61=
3a:
>
>   KVM: arm64: Use MDCR_EL2.HPME to evaluate overflow of hyp counters (202=
4-11-20 17:23:32 -0800)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags=
/kvmarm-fixes-6.13-2
>
> for you to fetch changes up to be7e611274224b23776469d7f7ce50e25ac53142:
>
>   KVM: arm64: vgic-its: Add error handling in vgic_its_cache_translation =
(2024-12-03 16:22:10 -0800)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.13, part #2
>
>  - Fix confusion with implicitly-shifted MDCR_EL2 masks breaking
>    SPE/TRBE initialization
>
>  - Align nested page table walker with the intended memory attribute
>    combining rules of the architecture
>
>  - Prevent userspace from constraining the advertised ASID width,
>    avoiding horrors of guest TLBIs not matching the intended context in
>    hardware
>
>  - Don't leak references on LPIs when insertion into the translation
>    cache fails
>
> ----------------------------------------------------------------
> James Clark (1):
>       arm64: Fix usage of new shifted MDCR_EL2 values
>
> Keisuke Nishimura (1):
>       KVM: arm64: vgic-its: Add error handling in vgic_its_cache_translat=
ion
>
> Marc Zyngier (2):
>       KVM: arm64: Fix S1/S2 combination when FWB=3D=3D1 and S2 has Device=
 memory type
>       KVM: arm64: Do not allow ID_AA64MMFR0_EL1.ASIDbits to be overridden
>
>  arch/arm64/include/asm/el2_setup.h |  4 ++--
>  arch/arm64/kernel/hyp-stub.S       |  4 ++--
>  arch/arm64/kvm/at.c                | 11 +++++++++--
>  arch/arm64/kvm/hyp/nvhe/pkvm.c     |  4 ++--
>  arch/arm64/kvm/sys_regs.c          |  3 ++-
>  arch/arm64/kvm/vgic/vgic-its.c     | 12 +++++++++++-
>  6 files changed, 28 insertions(+), 10 deletions(-)
>

