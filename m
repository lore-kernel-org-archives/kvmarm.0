Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763E022FAF8
	for <kvmarm@lists.linux.dev>; Sat, 10 May 2025 15:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746889851; cv=none; b=m1MQDWzX//NW9XgRQqdNlI5LcoxP8g45ByuzSZ3PgyYbA9dtS8otEr56mW00KRr4J6969qetvTuDu+x8mwo2ilfHsx2ii2kDJv2y7xlimWWLj654mzwphIzNoitm3YSER4ngaLkZXwIN/cJnP5d8RWR2seemaPs6MPwXjWVTT+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746889851; c=relaxed/simple;
	bh=qYJP1ocqOK8g0mqYCUIs+XsDUGAWsQBa4ZFg2UrZ58s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QVnLuRMa9zXKC6jJBYJ/ICHQR5IJv51vfKEPP1FxruJeOe05Sh3KktPcTKWIIdkxiJR8TizER8ByVGHdDAOlx6Wukjy6KO7tuYYw92AY+hZowql5E3dVa1TWZgzTQ4jt9OY7hoJ3NDIF0L7/nzwXangIudwwqx1NDxk11yBVa1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ffl2WUnm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ffl2WUnm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746889848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gYQJSjKMBtphEcdVsSmytVmx16FTbMzDliH0NXBgKhQ=;
	b=ffl2WUnmNTb7EX1HRSOPJkGji6b7bheDfAFulJWfAci6e32D2ev75uoLEYzw5/zH3HXItq
	fFaGOwGtc6w3f/+m616at7n3JkuffN3ZD0Z83B+72OWZrWHX6MuymAepv0PXNlf5filLxm
	3J5w3bUOYCqfUmmG8Rvi4XG0DOx1hbE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-478-cpAePixdPFKXX9dgRrNBdA-1; Sat, 10 May 2025 11:10:47 -0400
X-MC-Unique: cpAePixdPFKXX9dgRrNBdA-1
X-Mimecast-MFC-AGG-ID: cpAePixdPFKXX9dgRrNBdA_1746889846
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a0b7120290so1361927f8f.2
        for <kvmarm@lists.linux.dev>; Sat, 10 May 2025 08:10:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746889844; x=1747494644;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gYQJSjKMBtphEcdVsSmytVmx16FTbMzDliH0NXBgKhQ=;
        b=EcN0EdoLLZDdOlAORxkSY42LuXkzVqc1Kq4FFA9ChIwOLmxlXd3w2isBBelpIHpbPl
         f+8cI/L1CnIyV7U5ZowL7pEB1xjlmD/x/1mz8vokZGtYXGQKtDaJh2ST9Hv0JyQGzh76
         yLEcr5TGkBbUy/Npm+7K6J0ph8ZoOOdbBY0g7L7aiAniq3QmUiS+xA9vs9QnPRu/jEPc
         bGlNqOuCk72mtYJAwf23JxoFsMUNE/0U9aJm5PwRWgEwZMtd69Mr2dZs3fyUTxXuX/Ng
         V7932AcszewnMQ85OgT/m2AkqIn/55/oUz140HVCjoMcOnEx7AfN+3EdHGUmq9dPqdP1
         ++gA==
X-Forwarded-Encrypted: i=1; AJvYcCXk4oix416XzfXvzJ5eaNDa4RlJP4zgwlwoIkyOc3MEYhpCIoYZAqRDGdvuneVF1lIG1yVMzgQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzTGSQ17PDQ5tEqPt3Ps+xOMqn0mmQHbrMXNVYIXaZAVrHmWQP4
	uX+zrWNjOxRVUp4+QoU9mtVifjUHusCXbbJVLMWELmZHEz2WREb/Ozt9cA/RtawmByRjxJDF3Y7
	xf74g0OE9lZ4w46VY72Uwj72hypX+ynkWcypvzudwy3gUbj9Kzo/62wGDEHI+FgaGlJxQML6jul
	oBSoDSacymOtUhZUD4YSktl5XXNhvf
X-Gm-Gg: ASbGncsmb/xZAi4SAZYK0cUmdLCLHJiklQlUhxwkgcYc7WcOqKCSOOx5occfv4PDz3x
	qV6V66YN6/FDM7iY90TOY7r9JOKORIx2t507VA8Oe/dZu2wLcH+xE2+UFQOsQjEdnDxJ5
X-Received: by 2002:a05:6000:401e:b0:390:f9d0:5e3 with SMTP id ffacd0b85a97d-3a1f6429791mr5829584f8f.1.1746889844244;
        Sat, 10 May 2025 08:10:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG3HAv56tpX1CVaBoQBHwxapjvoQVSypdQHF0GsehA9SFm4L6nv5dBcvq0VTg87PrzIKt2S+xyvjaQizn1+piQ=
X-Received: by 2002:a05:6000:401e:b0:390:f9d0:5e3 with SMTP id
 ffacd0b85a97d-3a1f6429791mr5829571f8f.1.1746889843894; Sat, 10 May 2025
 08:10:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <aBsSAKYrVPjj4tSa@linux.dev>
In-Reply-To: <aBsSAKYrVPjj4tSa@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 10 May 2025 17:10:31 +0200
X-Gm-Features: AX0GCFu_zV9DLgki4e7TIUuAajYpsko6TKJilQU7WBzDjLLovkGTjsKLw2ynZBA
Message-ID: <CABgObfY4AHK-LFzfaMM0ydHghwEKsfiegqJ9FdfcsPXFYCtwRw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.15, round #3
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NbIXJgrMm8wOZvuV3deqvTe18dNITQEy_5hGvsAbqHo_1746889846
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 7, 2025 at 9:56=E2=80=AFAM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> Hi Paolo,
>
> This is probably the last batch of fixes I have for 6.15. The bug in
> user_mem_abort() getting fixed is likely to bite some folks. On top of
> that, Marc snuck in another erratum fix for AmpereOne with more to come
> on that front...
>
> Please pull.
>
> The following changes since commit b4432656b36e5cc1d50a1f2dc15357543add53=
0e:
>
>   Linux 6.15-rc4 (2025-04-27 15:19:23 -0700)

Done, thanks.

Paolo

> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags=
/kvmarm-fixes-6.15-3
>
> for you to fetch changes up to 3949e28786cd0afcd96a46ce6629245203f629e5:
>
>   KVM: arm64: Fix memory check in host_stage2_set_owner_locked() (2025-05=
-07 00:17:05 -0700)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.15, round #3
>
>  - Avoid use of uninitialized memcache pointer in user_mem_abort()
>
>  - Always set HCR_EL2.xMO bits when running in VHE, allowing interrupts
>    to be taken while TGE=3D0 and fixing an ugly bug on AmpereOne that
>    occurs when taking an interrupt while clearing the xMO bits
>    (AC03_CPU_36)
>
>  - Prevent VMMs from hiding support for AArch64 at any EL virtualized by
>    KVM
>
>  - Save/restore the host value for HCRX_EL2 instead of restoring an
>    incorrect fixed value
>
>  - Make host_stage2_set_owner_locked() check that the entire requested
>    range is memory rather than just the first page
>
> ----------------------------------------------------------------
> Marc Zyngier (5):
>       KVM: arm64: Force HCR_EL2.xMO to 1 at all times in VHE mode
>       KVM: arm64: Prevent userspace from disabling AArch64 support at any=
 virtualisable EL
>       KVM: arm64: selftest: Don't try to disable AArch64 support
>       KVM: arm64: Properly save/restore HCRX_EL2
>       KVM: arm64: Kill HCRX_HOST_FLAGS
>
> Mostafa Saleh (1):
>       KVM: arm64: Fix memory check in host_stage2_set_owner_locked()
>
> Sebastian Ott (1):
>       KVM: arm64: Fix uninitialized memcache pointer in user_mem_abort()
>
>  arch/arm64/include/asm/el2_setup.h              |  2 +-
>  arch/arm64/include/asm/kvm_arm.h                |  3 +--
>  arch/arm64/kvm/hyp/include/hyp/switch.h         | 13 +++++----
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c           |  2 +-
>  arch/arm64/kvm/hyp/vgic-v3-sr.c                 | 36 ++++++++++++++-----=
------
>  arch/arm64/kvm/mmu.c                            | 13 +++++----
>  arch/arm64/kvm/sys_regs.c                       |  6 +++++
>  tools/testing/selftests/kvm/arm64/set_id_regs.c |  8 +++---
>  8 files changed, 48 insertions(+), 35 deletions(-)
>

