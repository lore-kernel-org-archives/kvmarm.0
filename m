Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6732BB13
	for <kvmarm@lists.linux.dev>; Sun, 20 Oct 2024 11:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729423938; cv=none; b=G/y8+HWLZQ/B4v2vqtgqpIk/MdBMG8N/j7urclQOPjj8e534TJ6N4mEK9FqPwyZFrEg01q3fRShreiBFAZvBjMSHtAAmL5LlS0hJvrpHh1EDcuVCzwJlEGA2suZh8fhwa+BaoWYbSKH2BblPn4IWH15K/l3qwY0dhaRws0nt3Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729423938; c=relaxed/simple;
	bh=WYTnYtLUrp1UonGsCRaDfMccjMsa5EIq4iXmxBhDlM8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tGC3f50PS4zKL7P3ohfb8aGuTIu0axMzEnyZwnwodfMIgFoxzGc9LVgRtcvhjqxMK4uWVOf6TI0rX8KsyuGdnGB90YPvgqzD0MDSDupWwr48x/emSnfjnNZitzR6neqLQtwsB/Q6GniaekN+bHQ0ObyHqeFyUNyeAfjk9OdTXH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AujJL0QS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AujJL0QS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729423933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cR5Ak4fLmy8lCm0vtn/DmhtT5ICPa7cJEzdj3P8fRQI=;
	b=AujJL0QSgpmZh5C8C1mcxjYbQUYqqvhJfXMEMMslIEvp7iwwgbDw1bTFp9nBiTK2rn9Krv
	87g/w1TE64SbWTvMjIP7v0uV+T7BVtlRr4PTmIChxu4JP3ufQi27QOVy0eHPtonALRx5IG
	RdvoTadY2KB+fzJSFF70mkXhoY8hWNo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-8NzINeJjP6qZu6bjfPB_Lg-1; Sun, 20 Oct 2024 07:32:10 -0400
X-MC-Unique: 8NzINeJjP6qZu6bjfPB_Lg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-37d504759d0so2187855f8f.0
        for <kvmarm@lists.linux.dev>; Sun, 20 Oct 2024 04:32:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729423929; x=1730028729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cR5Ak4fLmy8lCm0vtn/DmhtT5ICPa7cJEzdj3P8fRQI=;
        b=qziazHxae2LUwYQDFuddUHcRw+joAH+VK8pvfYAkdKD/nj3vCq5lydi56u5Be4o4NL
         EHl0BSQKATzvWGR6LJdr/LDNUL5/eXp3S6vmV+w+dVquey59xgbC6JRNvgC4Y0sSfkjU
         Z9+NCxa7js6aKmHNSi95SkX6/4w2kvbwU5KxfqBpsOaJuPVbIKBtAYIf9AtotXaxlwig
         Q7FtJ5czL7HpJ2w0ZjC9nBU0G6fxf3GH74pLYY19pi88FvYdrdgBV5ESLq9K+UBhOC9r
         W5JxFeOOoYaac6ns+raxdwZmnU7K7K30TMXilyRnHWY0NVGdZcovKK39xwiXOpDccRD4
         ZWqg==
X-Forwarded-Encrypted: i=1; AJvYcCVkUocVWQdEs/aR7xtoAUbeVcP44glMnIDPD8BbkMSZVvbID+tyXiKCAbC2X+f+JKDinYHyuhI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6a+bm72w7PhjzZjvAKuBqZPcUgf1cwnZ2XrzW3lnFETeVCJfx
	TIvZTp897+6ZDo78BruDAxIAZqjsbb6o5JsTR9cRGg9Dl+X4OsVW+aylcA4vsrxm4++trke9n9N
	p/dErQTy4KL/dC93u41cm8jOB1T8RS+aWO8jeVAnpNpucL6GbDdvZCn2AuJ18SrC4q4ebe2SuaR
	3VHC+3C44JE7iMxCDFNVAseIPIHISI
X-Received: by 2002:a5d:46cf:0:b0:37d:2de3:bf8a with SMTP id ffacd0b85a97d-37eab4cbc1cmr7777084f8f.26.1729423928689;
        Sun, 20 Oct 2024 04:32:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhcTwGkAc85d3818flM3w9+1IWExGJgHFjEhLi36KDSMqNEFQFutB10iL0qeJciXQ9Ql/B197qipBgzP9G/0Y=
X-Received: by 2002:a5d:46cf:0:b0:37d:2de3:bf8a with SMTP id
 ffacd0b85a97d-37eab4cbc1cmr7777063f8f.26.1729423928364; Sun, 20 Oct 2024
 04:32:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241017090956.954040-1-maz@kernel.org>
In-Reply-To: <20241017090956.954040-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 20 Oct 2024 13:31:54 +0200
Message-ID: <CABgObfZpfARP6yg9LwQ=pitaenJetyp80KgK35xsKoAczVqQrg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.12, take #3
To: Marc Zyngier <maz@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, Gavin Shan <gshan@redhat.com>, 
	Ilkka Koskinen <ilkka@os.amperecomputing.com>, Nathan Chancellor <nathan@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2024 at 11:10=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Paolo,
>
> Here's another set of fixes for KVM/arm64, addressing another vgic
> init race as well as a build error (full details in the tag below).
>
> I notice that you haven't pulled [1] yet, so hopefully this will also
> serve as a gentle reminder.
>
> Please pull,
>
>         M.

Pulled both, thanks.

Paolo

> [1] https://lore.kernel.org/r/20241011132756.3793137-1-maz@kernel.org
>
> The following changes since commit df5fd75ee305cb5927e0b1a0b46cc988ad8db2=
b1:
>
>   KVM: arm64: Don't eagerly teardown the vgic on init error (2024-10-11 1=
3:40:25 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.12-3
>
> for you to fetch changes up to 78a00555550042ed77b33ace7423aced228b3b4e:
>
>   KVM: arm64: Ensure vgic_ready() is ordered against MMIO registration (2=
024-10-17 09:20:48 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.12, take #3
>
> - Stop wasting space in the HYP idmap, as we are dangerously close
>   to the 4kB limit, and this has already exploded in -next
>
> - Fix another race in vgic_init()
>
> - Fix a UBSAN error when faking the cache topology with MTE
>   enabled
>
> ----------------------------------------------------------------
> Ilkka Koskinen (1):
>       KVM: arm64: Fix shift-out-of-bounds bug
>
> Marc Zyngier (1):
>       KVM: arm64: Shave a few bytes from the EL2 idmap code
>
> Oliver Upton (2):
>       KVM: arm64: vgic: Don't check for vgic_ready() when setting NR_IRQS
>       KVM: arm64: Ensure vgic_ready() is ordered against MMIO registratio=
n
>
>  arch/arm64/include/asm/kvm_asm.h      |  1 +
>  arch/arm64/kernel/asm-offsets.c       |  1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S    | 52 +++++++++++++++++++----------=
------
>  arch/arm64/kvm/sys_regs.c             |  2 +-
>  arch/arm64/kvm/vgic/vgic-init.c       | 13 +++++++--
>  arch/arm64/kvm/vgic/vgic-kvm-device.c |  7 ++++-
>  6 files changed, 49 insertions(+), 27 deletions(-)
>

