Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFB22F39AB
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 16:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780678665; cv=none; b=sszqj3h7UtnZaBSikevBxS3bxo2XDjiHsuUvB8WD9xPISiatI1GWM9Cvptno8YUGDnssrsGs79W0vwAJVZ3Q9DxGwh13PPOm/KvDNK446IaY09Z5UnqUKUWN1akIwnExwoMqRMT9AMAR25dDC8/rhVtGA2r8qnEtLZ7QZ/krirU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780678665; c=relaxed/simple;
	bh=I6pRPVOVidWrPYwV5YDyVfTkLWmo+EGe9HHblFwc4w0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IxuF6t9Z+UO89QFogUIuJtVtG0iC6t1fRxbBhzCWT1J+nHDfzcYD2I99MfhpKhZFX1FF2OhC04VapFFuFRXuXOMNGTr9oX3ySELm5U8kuj7YBwkENq0xgCnXOdWmVBdDLdC9wwvqSWxbxSDFCco1h5Ji36ynZVANswDrfxudceg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XjYrMwC/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XjYrMwC/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780678663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iKL2XhPJcTe92U+7kcTY+J0V1P0lR2YbYloV0NBdglw=;
	b=XjYrMwC/+n95mRfuZZVYfSKujIpVS2DKixCJUXZyecJLTgChUITaCFTcKdZk7drPuuFLao
	DN9KWbwLMjUMEf6hBoMxSvRujV05rrDJ8rFSIJa7FunJ9UKsFzbp9NmlHZqb4YAx6vJkOT
	/FE93L9KoPHwjx0ny+K0Pb+f1jnxm/A=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-_HjsdPhyMIyQRoy4cQ5dow-1; Fri, 05 Jun 2026 12:57:36 -0400
X-MC-Unique: _HjsdPhyMIyQRoy4cQ5dow-1
X-Mimecast-MFC-AGG-ID: _HjsdPhyMIyQRoy4cQ5dow_1780678656
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-45ef3aeeb41so1472717f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 05 Jun 2026 09:57:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780678655; x=1781283455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iKL2XhPJcTe92U+7kcTY+J0V1P0lR2YbYloV0NBdglw=;
        b=QPHl5j3vKBoCkQAJ2fdPOtMXkAjaUzZtKvQuOqdC3uc6KpklI95x35VQ++FzHJYfZ/
         4GfbL3XqN2OPSF4gOhySqMJ9jLk+6xAIX3s5b5aorIhPzqD348uKusWmzQEtkpL0r4Qo
         ZIo3tjiN0KO+HkaBpCP57lGl6R/VMMx8YXSXoAzGWn3sGN8otg9gDtoGt8yaANdG/i70
         5m82NdOoF35oycOKfzqIxlwudczIm0uYgUqYDAsKwcSh0QvJcdJZ9k5blgiwgoDoxnuH
         MUZiC/KAnMN2ujfYs/XWiWAwnLJD+e+xenJYUdRNjUrOVXPDUG5P5gZrbuwpqN8bBJma
         GlmQ==
X-Forwarded-Encrypted: i=1; AFNElJ+vv6ALa+kZmIMcjevpFF5djMcT/2zW180xYO/5RDSjnr/7rjmaTO4Q3FPLrVYJfX9KCojJCAs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxuPLOSqxxmvtfo8mnp5PvAEvAmDUHeQRtUfAm4WTUIS334gt0y
	tT+6M1E3vmmV6lqqUuKNDmFQd0pzoF6nc/uMfB+8jxJeTgEJ2J7k9My0+4gbczZJKhpGg2jnc/3
	WeKSG2CbrZpUnJA0g89JUcKbcyfhGPQ/e/7MryIOfB7vX4CzgpRnkhWjHlqVMhCImvG7KkcGszl
	aMVKyP3fcUsWy15hgDkdx36J/PuQws4ZTq
X-Gm-Gg: Acq92OHA7P3XCmEypY1ux89TCrAVvydqoi92wkd7l7Xww5+YxWNQf3ri2Qw2s1SP+18
	DGhp3pl2jm+fvMbp6NgpilrTvXQfN67Hrbpy85vAEMckvPLmSEvf3TLYfAiD9+3Q7xom4zvhpxA
	AoaEToHVJ0AO58FAO/bRHF+X5ETZpja1Z+/AUZz6e6iOMHgpFLaRTlSWn7d9jUXPZ7EJWQMpBdT
	OOyQYzvnPrU4oDVj2RCEnWpYYtsD52y5Kdo1Z0mEtfahI+M3T8swnEpdSdud3Lf1JWNomvwoyNK
	FrCfB4ZW04okPAOWiA==
X-Received: by 2002:a05:6000:1889:b0:460:1987:7bb9 with SMTP id ffacd0b85a97d-46030753534mr7686107f8f.29.1780678655542;
        Fri, 05 Jun 2026 09:57:35 -0700 (PDT)
X-Received: by 2002:a05:6000:1889:b0:460:1987:7bb9 with SMTP id
 ffacd0b85a97d-46030753534mr7686068f8f.29.1780678655186; Fri, 05 Jun 2026
 09:57:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260605164516.2214533-1-maz@kernel.org>
In-Reply-To: <20260605164516.2214533-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 5 Jun 2026 18:57:22 +0200
X-Gm-Features: AVVi8CdXD2dFjV3hwOcMaVAYJkQk2Ss55TNM_5tzf_zqwGUWPlvODfkGX82xJFw
Message-ID: <CABgObfakiK_xLU_buKA_TknQNMPiKKo_=GMhgP71i_r8jPPY7A@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 7.1, take #5
To: Marc Zyngier <maz@kernel.org>
Cc: Hyunwoo Kim <imv4bel@gmail.com>, Joey Gouly <joey.gouly@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: m5E4Lh-ZZwaztr0-OyrIQN4CKO4rpEjQSqfm-G-r--A_1780678656
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 5, 2026 at 6:45=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote:
>
> Paolo,
>
> Yes, I said that last week's pull request was the last. I really meant
> it, honest. But people (and their AI best mate) keep finding ugly
> stuff in dark corners, and I can't sit on this stuff much longer.
>
> So here we have an assorted mess of bad races, broken userspace, and
> architectural bugs. What's not to like? As usual, details in the tag
> below.

x86 isn't doing any better, so who am I to judge.

Pulled, thanks.

Paolo

>
> Please pull,
>
>         M.
>
> The following changes since commit 83726330748981372bde86ed5411d7b3066129=
91:
>
>   KVM: arm64: Correctly cap ZCR_EL2 provided by a guest hypervisor (2026-=
05-29 10:04:00 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-7.1-5
>
> for you to fetch changes up to 17f073f78fc43280891ecde8f8ec3f84f98bb37c:
>
>   KVM: arm64: Correctly identify executable PTEs at stage-2 (2026-06-05 1=
4:07:57 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 7.1, take #5
>
> - Correctly drop the ITS translation cache reference when it actually
>   gets invalidated
>
> - Take the SRCU lock for SW page table walks
>
> - Restore POR_EL0 access to host EL0, avoiding POR_EL0 becoming
>   inaccessible from EL0 after running a guest
>
> - Reassign nested_mmus array behind mmu_lock, ensuring that vcpu init
>   and MMU notifiers are mutually exclusive
>
> - Correctly handle FEAT_XNX at stage-2
>
> ----------------------------------------------------------------
> Hyunwoo Kim (3):
>       KVM: arm64: vgic-its: Drop the translation cache reference only for=
 the erased entry
>       KVM: arm64: Take the SRCU lock for page table walks in fault inject=
ion and AT emulation
>       KVM: arm64: Reassign nested_mmus array behind mmu_lock
>
> Joey Gouly (1):
>       KVM: arm64: Restore POR_EL0 access to host EL0
>
> Oliver Upton (2):
>       KVM: arm64: nv: Fix handling of XN[0] when !FEAT_XNX
>       KVM: arm64: Correctly identify executable PTEs at stage-2
>
>  arch/arm64/include/asm/kvm_nested.h     |  4 ++--
>  arch/arm64/kvm/at.c                     |  6 ++++--
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  2 ++
>  arch/arm64/kvm/hyp/pgtable.c            |  4 +++-
>  arch/arm64/kvm/nested.c                 | 33 ++++++++++++++++++++-------=
------
>  arch/arm64/kvm/vgic/vgic-its.c          |  6 ++++--
>  6 files changed, 35 insertions(+), 20 deletions(-)
>

