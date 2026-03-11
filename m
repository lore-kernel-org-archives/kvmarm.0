Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0887E31F99A
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 16:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773248306; cv=none; b=n16n80e8VgD0difw0/p3+zbFoc9CvEHnvaoeEzpnTsoP42FcjPW6wN2Pb1h+tNN2LrA26JpYzo4KUmoXD8vwd0nYUUc5J3RGF/vJbNKO9VD8ucc5/bHnIlsUfQDUMNayXBrbJYPm5UR6XP6352J/Myc+mQHY6X91S3C7FzbO6XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773248306; c=relaxed/simple;
	bh=yB8eckpxqLTfm0m7JZgR9uwgsENotliNu4GC0dI5J24=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HEwVr4X4br8EOEW9zHwfvZKt+2VAYMgP8GLFdUAsJVxSmF9LMbdl0TKdThVHOsK3S+73DvDS8ynylSVJ2l0BYeSQrd83Je1JKfJIGYA5e1VNbzWcVaGuqdbE2GHZQlmZfsGJ494BZgbxCBE0Nrtm1t7jGil8GXDxdwoQ+LE9yBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RyuiNT2f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RyuiNT2f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773248304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H+ve22NUc/82DrGKVPMAAR5+gY8/ChLtz+87jud+TMA=;
	b=RyuiNT2frQYrJE+av9MsxOoDEqpQzOkXEO8juWRcKNrC4r9xHLUTZH+uFOdeiB5Vc9pFe6
	3QOrvOfQjhh2TGl33um/nLRpcpwA3hlrgq0jSOkzLjkO4g1gfYbesPN9Zl3x8Yb7SEhDkQ
	kECtmQGDlKTcSSIuBmZmwPsR861AFbQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-e4R_a4HNNcOYNipzcPLMuw-1; Wed, 11 Mar 2026 12:58:22 -0400
X-MC-Unique: e4R_a4HNNcOYNipzcPLMuw-1
X-Mimecast-MFC-AGG-ID: e4R_a4HNNcOYNipzcPLMuw_1773248301
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48531e8ae62so372985e9.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 09:58:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773248301; x=1773853101;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H+ve22NUc/82DrGKVPMAAR5+gY8/ChLtz+87jud+TMA=;
        b=g/JKp6c/4LxlIjzFcXZ0XVVqaQ7R1NwXh0M9oWjmFM6hH6Nf5fhVy5C5fMEE5+Rg1+
         ADidCYpQH3kwTGbiInU+dp825LPtpW8+bnAladvb72nQDAF8mChb19I/7phJR7Nk+E7e
         Spbwn2lINM+06XU9LHogKE4pIutfF/+fEieZl92VARgIzR6T0rFEkgRFFiVBKPtuaQrC
         Xq5tymfbG7/DUClch3VTozeCZHvXJW5ms2BIv+jObkJ9vUzZK5NbDhyTxUxiVgrFbUSl
         ri9xb95smn2YNgDw51fTRsUP8Rq9lqv0g2J4tDScQDI7L8z13fshsw17QpoFeGy2VCJd
         dAGw==
X-Forwarded-Encrypted: i=1; AJvYcCU/yExTzrBNBT7ByeeiBdNMQuVaC+/QtmhzosbXxqitVpY6JJIktawTSion6GgKn+2cHkNcER0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwjQvwD1CA/Kz5CUXER6wtdIrmD7dc6u8bTMuOtMSgIb+ddNn0k
	d54PRlhI7dLW6U5jtHt1zDqGj8QWmJ0QjmC++7UMFgaEQ1b0LpbKvhjUreyM8JedVvZCH4Rsxp9
	3COYGQR8r4bJSqgPbFSGZq4old79SugF9s6P5LtXXOgZYjdZhGJCGGUCUp39ZWFqDiQPaLWCWSi
	lLp9Wjso8sZ0FMRUyUQERn+5CIf7j4rrwU
X-Gm-Gg: ATEYQzwwLDICXyHKmQ+RsWuTe2lAAhfEo6SoSqRb9NE+0WtDkpyZJ/4Zv8nT/j5aNEY
	lJXaRIWLgeealFrMfJabmrsUI2o8hh36e+fv3kagiI0U7qr0Eq45BRCwEnJ4IKrhNBYExUSSvOo
	p1XG/Tr2zLQKfoGMHQhMMLQ3IDEJrTB9a+bhKqAUEiOK3QqzEmPHgRs8rsiRZBqvstiUVhpnXFO
	2A5tP6WE369TVJBaAsD1baCA/40YiEjPKfhfJohV6gug3b6Vd6qaFHfMA5IXJfbbfKT/hVoc7ig
	KMUxhuw=
X-Received: by 2002:a05:600c:6090:b0:485:4278:24fb with SMTP id 5b1f17b1804b1-4854b13c02emr57397905e9.32.1773248301257;
        Wed, 11 Mar 2026 09:58:21 -0700 (PDT)
X-Received: by 2002:a05:600c:6090:b0:485:4278:24fb with SMTP id
 5b1f17b1804b1-4854b13c02emr57397665e9.32.1773248300826; Wed, 11 Mar 2026
 09:58:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260306112231.3201502-1-maz@kernel.org>
In-Reply-To: <20260306112231.3201502-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 11 Mar 2026 17:58:08 +0100
X-Gm-Features: AaiRm51PO38kqfZhsYIxd7YNAH5su9wzPy7usJFrA0GOUWAfWq8bIhgO0jdmos0
Message-ID: <CABgObfYJqhj3xiM4_+7gCE1x5v5JQhyS0ox4+obrsZwA2W4GYg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 7.0, take #2
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Quentin Perret <qperret@google.com>, 
	Yuan Yao <yaoyuan@linux.alibaba.com>, Zenghui Yu <zenghui.yu@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SRExcJzhJXacdGhCS0OtoCUUhzZang52_Xq4AVsAGZo_1773248301
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 6, 2026 at 12:23=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> Here's the second set of fixes for 7.0. The only interesting fix is
> one affecting pKVM and preventing the host from making forward
> progress when a memblock is not page-aligned.
>
> The rest is a bunch of low-severity fixes affecting the page-table
> code, some of which Fuad has promised to start cleaning up!
>
> Please pull,

Pulled, thanks.

Paolo

>
>         M.
>
> The following changes since commit 11439c4635edd669ae435eec308f4ab8a08048=
08:
>
>   Linux 7.0-rc2 (2026-03-01 15:39:31 -0800)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-7.0-2
>
> for you to fetch changes up to 3599c714c08c324f0fcfa392bfb857c92c575400:
>
>   KVM: arm64: Remove the redundant ISB in __kvm_at_s1e2() (2026-03-06 10:=
42:21 +0000)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 7.0, take #2
>
> - Fix a couple of low-severity bugs in our S2 fault handling path,
>   affecting the recently introduced LS64 handling and the even more
>   esoteric handling of hwpoison in a nested context
>
> - Address yet another syzkaller finding in the vgic initialisation,
>   were we would end-up destroying an uninitialised vgic, with nasty
>   consequences
>
> - Address an annoying case of pKVM failing to boot when some of the
>   memblock regions that the host is faulting in are not page-aligned
>
> - Inject some sanity in the NV stage-2 walker by checking the limits
>   against the advertised PA size, and correctly report the resulting
>   faults
>
> - Drop an unnecessary ISB when emulating an EL2 S1 address translation
>
> ----------------------------------------------------------------
> Fuad Tabba (2):
>       KVM: arm64: Fix page leak in user_mem_abort() on atomic fault
>       KVM: arm64: Fix vma_shift staleness on nested hwpoison path
>
> Marc Zyngier (2):
>       KVM: arm64: Eagerly init vgic dist/redist on vgic creation
>       KVM: arm64: pkvm: Fallback to level-3 mapping on host stage-2 fault
>
> Zenghui Yu (Huawei) (4):
>       KVM: arm64: nv: Check S2 limits based on implemented PA size
>       KVM: arm64: nv: Report addrsz fault at level 0 with a bad VTTBR.BAD=
DR
>       KVM: arm64: nv: Inject a SEA if failed to read the descriptor
>       KVM: arm64: Remove the redundant ISB in __kvm_at_s1e2()
>
>  arch/arm64/kvm/at.c                   |  2 --
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c |  2 +-
>  arch/arm64/kvm/mmu.c                  | 14 +++++++++-----
>  arch/arm64/kvm/nested.c               | 27 ++++++++++++++++-----------
>  arch/arm64/kvm/vgic/vgic-init.c       | 32 ++++++++++++++++-------------=
---
>  5 files changed, 42 insertions(+), 35 deletions(-)
>

