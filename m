Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505CE3E51C2
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 17:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773250954; cv=none; b=k3qNaJEOO6g1GO08Kq2LepJh18+cpOjeXy19kfJ2DK8XPLx2fvmhr8TchP0fwWNpvJpXVQ5ofl/5llcFtHJ/V4GQEz4ATow2WWl5WsC4bH5enpefMETiEyAKAkssbOr0l9DgEn/7x+zUnS6IFy7qhU4F5WUdha9ufiO4pMkkfJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773250954; c=relaxed/simple;
	bh=LLYPzxfgc41WbA2qy2EZKJW1VA/IzQfrt0W5nMgLqYk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uh7BWmrD9FaI8/LCiVgdTuWTYtVYvdDXT+eXQ0MANgF55KM3YVEi9tExgiFI2TXFtMrhxIcqd5LV/u5KhEsHSYZVHEtyb6pPsKNKw97s+qRNhMFja9M/nWNRPlcYjf6+e6oLcL7iVglUb1qKI/MALK9iYgGNJfm+3r7o4BrHW7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q4CpDG1V; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q4CpDG1V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773250951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F/YbJZ5mStPYPfrX4lrd1txozK+dMfvbgcpYGh/3eQE=;
	b=Q4CpDG1VykLGG+pRFoRcggNkWiPrxnmwWGCq0pE6AY+erlJYIkTv/6F8U333BJuaIqx0t3
	e7nlKajo14i9qjyhOAI67iy4fzyzD751HXmntUEMo9YKUeh7TzfjhYDdvBY8I3kj+kIENm
	XtEWGE17OKOwdlLR7sym3SkSg86r2ao=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-437--lrbQnV3Mlm-r1RoNYgelA-1; Wed, 11 Mar 2026 13:42:29 -0400
X-MC-Unique: -lrbQnV3Mlm-r1RoNYgelA-1
X-Mimecast-MFC-AGG-ID: -lrbQnV3Mlm-r1RoNYgelA_1773250949
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-439bcec86dfso144676f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 10:42:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773250948; x=1773855748;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F/YbJZ5mStPYPfrX4lrd1txozK+dMfvbgcpYGh/3eQE=;
        b=lq466SC5zedBEudAgNx7jbC32+Q9Ct/QzXqMrwbW74yIFQiUiUq1OGQemjJODO5hCU
         6xHDACt8t2Lodne4SplktcZDyG+U3KZLO/Zk5sdaPNIpbV2YvGSWosr+iTzL51n4wHbM
         5vYq9FDSTtlu0buu0cxnbHShmmJw7y5/MVwrdAxLiNYYSTDprWMz2b+ix+Gd7JlUDBQZ
         5iBZz868xiEkUkCGURHi99PLdJn6c3mgihCvCZJiGr87tSTnK9BLdPHQKItPbMkxnmsu
         B0RW4y70UIcdeUZyesJkRrcappincNN6pcCJEZxFam/DUaMnrU7GYaku7lV3xgNrJavj
         5mHA==
X-Forwarded-Encrypted: i=1; AJvYcCVL16MI/M7ksPVhHfdvKTQ4IBotwYv5szaEyPVVyhJRoy14AAVahN2GIShbdypT/bviFmyYLnM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzuqVusGZfHWHyPfi2d7L+eBBJez8N8EnWYkuiwiKplQK+NzhZb
	c7DlHXkuGU5q0uFQsBYMBK6D9zyfS3b0EUIm0Da0RB0okU78iTkRzIvXgeZFWpNewgqsM89eJ85
	24ufULsTP7shGJpYGlgKdADnrV5j3azsbs2j8kPPaQu61aWqGKcj7dwJv0auFZ1bHw53PyBcHFQ
	9HpqA75wG0RlMPj/F/RsegV0TvzEHfu1Ce
X-Gm-Gg: ATEYQzwj1bolQ3SxgnP2BRCCUVEMr7c5BltcyVM/XqXsT13oEXrCtWulsF/JBzMxzbE
	EK538J3hoQoVlag+aCNP+YiF7+lKfuxcLbaa0YwTqN7C6vw+AYbutKNDzNpCxphbxmqCoLbpBpC
	tXpdVwsdjLT5Rc+bfJLufA9r0l63TyxFPk1C+M8BwETI56JEg+LF4vNM0ss9zVdIxuNb8eLhzEC
	MJH8XfjZhMxvgJbtrDg73vWPwX9T/HsBDhBFoG+jUFfmhALqrAUhFHr1vgR9RC2jO4yGKihiklG
	PLGedgE=
X-Received: by 2002:adf:f745:0:b0:439:fdd5:10b5 with SMTP id ffacd0b85a97d-439fdd510eemr1093018f8f.39.1773250948579;
        Wed, 11 Mar 2026 10:42:28 -0700 (PDT)
X-Received: by 2002:adf:f745:0:b0:439:fdd5:10b5 with SMTP id
 ffacd0b85a97d-439fdd510eemr1092976f8f.39.1773250948152; Wed, 11 Mar 2026
 10:42:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260311173902.329537-1-maz@kernel.org>
In-Reply-To: <20260311173902.329537-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 11 Mar 2026 18:42:11 +0100
X-Gm-Features: AaiRm53T5yAtX5ypUWcyuTtUjMCgSXyDtjqh-7JRGZz496zaXdK-3JoiKSNnA38
Message-ID: <CABgObfbQrLf_UJHU58vmAOZx=FgbM3TVhvqq-FEabeaain1XXg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 7.0, take #3
To: Marc Zyngier <maz@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Valentine Burley <valentine.burley@collabora.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: z3VAtTXus5Wi9pMifmxkgktAXJyTZfXLxJLezkNfKlA_1773250949
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 11, 2026 at 6:39=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> Here's the third set of fixes for 7.0. Two fixes, both related to the
> pretty large vgic rewrite that went into 6.19. One is affecting
> interrupt deactivation, and therefore leading to guests locking
> up. The other is affecting CPU hotplug with pKVM, leading to the
> onlined CPU not booting at all.
>
> Please pull,

Done, thanks.

Paolo

>
>         M.
>
> Marc Zyngier (2):
>   KVM: arm64: vgic: Pick EOIcount deactivations from AP-list tail
>   KVM: arm64: pkvm: Don't reprobe for ICH_VTR_EL2.TDS on CPU hotplug
>
>  arch/arm64/include/asm/kvm_host.h |  3 +++
>  arch/arm64/kernel/cpufeature.c    |  9 +++++++++
>  arch/arm64/kvm/vgic/vgic-v2.c     |  4 ++--
>  arch/arm64/kvm/vgic/vgic-v3.c     | 12 ++++++------
>  arch/arm64/kvm/vgic/vgic.c        |  6 ++++++
>  5 files changed, 26 insertions(+), 8 deletions(-)
>
> --
> 2.47.3
>
> The following changes since commit 3599c714c08c324f0fcfa392bfb857c92c5754=
00:
>
>   KVM: arm64: Remove the redundant ISB in __kvm_at_s1e2() (2026-03-06 10:=
42:21 +0000)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-7.0-3
>
> for you to fetch changes up to a79f7b4aeb8e7562cd6dbf9c223e2c2a04b1a85f:
>
>   KVM: arm64: pkvm: Don't reprobe for ICH_VTR_EL2.TDS on CPU hotplug (202=
6-03-10 09:48:45 +0000)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 7.0, take #3
>
> - Correctly handle deeactivation of out-of-LRs interrupts by
>   starting the EOIcount deactivation walk *after* the last irq
>   that made it into an LR. This avoids deactivating irqs that
>   are in the LRs and that the vcpu hasn't deactivated yet.
>
> - Avoid calling into the stubs to probe for ICH_VTR_EL2.TDS when
>   pKVM is already enabled -- not only thhis isn't possible (pKVM
>   will reject the call), but it is also useless: this can only
>   happen for a CPU that has already booted once, and the capability
>   will not change.
>
> ----------------------------------------------------------------
> Marc Zyngier (2):
>       KVM: arm64: vgic: Pick EOIcount deactivations from AP-list tail
>       KVM: arm64: pkvm: Don't reprobe for ICH_VTR_EL2.TDS on CPU hotplug
>
>  arch/arm64/include/asm/kvm_host.h |  3 +++
>  arch/arm64/kernel/cpufeature.c    |  9 +++++++++
>  arch/arm64/kvm/vgic/vgic-v2.c     |  4 ++--
>  arch/arm64/kvm/vgic/vgic-v3.c     | 12 ++++++------
>  arch/arm64/kvm/vgic/vgic.c        |  6 ++++++
>  5 files changed, 26 insertions(+), 8 deletions(-)
>

