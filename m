Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08F92D0267
	for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 20:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746045059; cv=none; b=XLEmVIYgo5ZOdS5XDXlcytB1jzqoZ6Vx6km3swhKxeIaq9j8SeoR96hscrMjsFwjUiy/edtWlFvr4SOb4mXwVMmDhcxzfndJBwlp5CK5Q1qjloSQIA9z0XlHhkYRXMi8QDWwIhKDLnRpSgTjCOBMypqG64qbYs/6TCLvrLAjfE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746045059; c=relaxed/simple;
	bh=477PHwtL5TNDtw9yERMTqK+bm+SW5j6JJbM2jEsH4cs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PxzwA8S5USj4JqsORa68b5sONE8u3qMGISuefk+wyFqSEUW9z2kd0sxIzkzujP3X0V1JcZVecwkJqv5o41K1TaX+83/kUL99LbwFRcpTM3QEWhpymrYa5+AGukB58BVelpJKSlnZJ+VbrxXV0lvY+mRhDjGY6IRalhkCESHhrBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SG/touyu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SG/touyu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746045056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=477PHwtL5TNDtw9yERMTqK+bm+SW5j6JJbM2jEsH4cs=;
	b=SG/touyuWU8T26H/R6+Rjf3K8kQAvheDXhewyHARI9TePnN+ltaprjOhHOo66WCYDxXzI2
	zYdCFibtU6xQXVYEh/6n5kFRRi8UNJqYQQE95p/j7od0fE2lNzxIjPPXVtgwAYVCl7aYHD
	TQ+qUmajg6Sz6xXlNCJF/mU+pGIjKa4=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-263-l2p-Re9PNRSqDJndxK3z-Q-1; Wed, 30 Apr 2025 16:30:55 -0400
X-MC-Unique: l2p-Re9PNRSqDJndxK3z-Q-1
X-Mimecast-MFC-AGG-ID: l2p-Re9PNRSqDJndxK3z-Q_1746045054
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6e8feffbe08so7901476d6.0
        for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 13:30:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746045054; x=1746649854;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kLCLNjhH9N/SbhZgwe55OZ5mfyV+uMRJ+/FIl8sp4MU=;
        b=WVFi1OZQ4GehjKn/Oi8+4xy0JU1hjaWQ42uZyve5OfHhXqlwWZt3ziTOhEFVWC/Xk9
         nFC74gx77uFl8fHaUxilOM3SbNOV83p5MlVeRAL0g/oGmJkuPHqlcIklaIrg4YUGtboh
         N75foXEgv8HlQ6fXkxiMblpT9hbSEd8tcnUBpjXHlODU+q+qEaqWzIgmMFjDh+N0ePug
         01wEjVsquxaPfOSHCbev6YVgW3xULQ5xiJ4m8yfiDlcXWEJByqeM+TqYCwAFSDpina8d
         v38JrtqQ4LftM92uM2EP1JZTclRQEnULyqjQoIHpIVYo1VAgxwWu3ttrDXVf7wIMtlnd
         Bgnw==
X-Forwarded-Encrypted: i=1; AJvYcCXwj1oF0RDrwpkana1YLD1r5rMeauKWC3lb627MICAJbEmH612Ne/S8tLlFzhhFKmmulMpzPX4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxuP4QRftY/tVTq/xDxGiyB9wQZ9zbHDtzq7ZGM2gsxSJ1vzulD
	WaEK54t5Np8ERguj4dCmMPD4Vs4md7syddKfHx8eOabx2AdK1LZazTlUPjuhkna+4OtzBHIaSMN
	s2UvTZcMfNoJ8CfEYODqmlx+zOUduSbwAxA3/XyNQoepOFXwII3EHSQ==
X-Gm-Gg: ASbGncs8cK1z5Dnh7NYqaCFnp9S6CVU8zVdhGmRJKRUWYwANI7hNEFKDGwY+tvMh/aS
	Y9o1E0B0hdnuUl7ODtinBxBYJ56ZPtK7dJpXQOPGIKW71DDzr4r6yLx0hv1+QFzTfQMGxI8YZH+
	ODiHYyxzC/YKycys6BDgBNsN0SjGnctCbmFhNbhscjjTURtRbPacBrD39itDxlnNOoanHlRHpj/
	CglEe6HDKwusCE5JpFiA+UQullOEqGY+5zgVhlkY8oFSBqGV/dRCiPz1Aer72H+555im58Aeizg
	TdeVIAbfIZXUuiC6cXIcpiVtYoisWR6pHDyHbo0KJdtw+Mf90j7speICsBU=
X-Received: by 2002:a05:6214:2584:b0:6e8:fb92:dffa with SMTP id 6a1803df08f44-6f4fe081236mr60226396d6.25.1746045054719;
        Wed, 30 Apr 2025 13:30:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFqMC1VAUYkFR8BRk72B9YM6tHcI7coSFQe+I2l2BvKOrJizso3ayI0TGKXXExNYQxM53jAuA==
X-Received: by 2002:a05:6214:2584:b0:6e8:fb92:dffa with SMTP id 6a1803df08f44-6f4fe081236mr60225826d6.25.1746045054231;
        Wed, 30 Apr 2025 13:30:54 -0700 (PDT)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f4fe70a277sm12416546d6.55.2025.04.30.13.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 13:30:53 -0700 (PDT)
Message-ID: <53a26378fce90c8bbfa57a582992324560aa0274.camel@redhat.com>
Subject: Re: [PATCH v3 0/4] KVM: lockdep improvements
From: mlevitsk@redhat.com
To: kvm@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Randy Dunlap
 <rdunlap@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, Will Deacon
 <will@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Kunkun Jiang
 <jiangkunkun@huawei.com>, Jing Zhang <jingzhangos@google.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Keisuke Nishimura <keisuke.nishimura@inria.fr>, 
 Anup Patel <anup@brainfault.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Atish Patra <atishp@atishpatra.org>,
 kvmarm@lists.linux.dev, Waiman Long <longman@redhat.com>,  Boqun Feng
 <boqun.feng@gmail.com>, linux-arm-kernel@lists.infradead.org, Peter
 Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Sebastian Ott
 <sebott@redhat.com>, Andre Przywara <andre.przywara@arm.com>, Ingo Molnar
 <mingo@redhat.com>, Alexandre Ghiti <alex@ghiti.fr>, Bjorn Helgaas
 <bhelgaas@google.com>, Palmer Dabbelt <palmer@dabbelt.com>, Joey Gouly
 <joey.gouly@arm.com>, Borislav Petkov <bp@alien8.de>, Sean Christopherson
 <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Alexander Potapenko
 <glider@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 linux-kernel@vger.kernel.org,  linux-riscv@lists.infradead.org, Shusen Li
 <lishusen2@huawei.com>,  kvm-riscv@lists.infradead.org
Date: Wed, 30 Apr 2025 16:30:51 -0400
In-Reply-To: <20250430202311.364641-1-mlevitsk@redhat.com>
References: <20250430202311.364641-1-mlevitsk@redhat.com>
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0dFzTjXRF9L3xFrNEHX77BtXj3fW8IW5UDy1fHkTf7U_1746045054
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2025-04-30 at 16:23 -0400, Maxim Levitsky wrote:
> This is=09a continuation of my 'extract
> lock_all_vcpus/unlock_all_vcpus'
> patch series.
>=20
> Implement the suggestion of using lockdep's "nest_lock" feature
> when locking all KVM vCPUs by adding mutex_trylock_nest_lock() and
> mutex_lock_killable_nest_lock() and use these functions=09in the
> implementation of the
> kvm_trylock_all_vcpus()/kvm_lock_all_vcpus()/kvm_unlock_all_vcpus().
>=20
> Those changes allow removal of a custom workaround that was needed to
> silence the lockdep warning in the SEV code and also stop lockdep
> from
> complaining in case of ARM and RISC-V code which doesn't include the
> above
> mentioned workaround.
>=20
> Finally, it's worth noting that this patch series removes a fair
> amount of duplicate code by implementing the logic in one place.
>=20
> Best regards,
> =09Maxim Levitsky
>=20
> Maxim Levitsky (4):
> =C2=A0 arm64: KVM: use mutex_trylock_nest_lock when locking all vCPUs
> =C2=A0 RISC-V: KVM: switch to kvm_lock/unlock_all_vcpus
> =C2=A0 locking/mutex: implement mutex_lock_killable_nest_lock
> =C2=A0 x86: KVM: SEV: implement kvm_lock_all_vcpus and use it
>=20
> =C2=A0arch/arm64/include/asm/kvm_host.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3=
 --
> =C2=A0arch/arm64/kvm/arch_timer.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 +-
> =C2=A0arch/arm64/kvm/arm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 43 ------------=
----
> =C2=A0arch/arm64/kvm/vgic/vgic-init.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 |=C2=A0 4 +-
> =C2=A0arch/arm64/kvm/vgic/vgic-its.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 8 +--
> =C2=A0arch/arm64/kvm/vgic/vgic-kvm-device.c | 12 ++---
> =C2=A0arch/riscv/kvm/aia_device.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 34 +------------
> =C2=A0arch/x86/kvm/svm/sev.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 72 ++----------------------=
-
> --
> =C2=A0include/linux/kvm_host.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 ++
> =C2=A0include/linux/mutex.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 17 +++++--
> =C2=A0kernel/locking/mutex.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 7 +--
> =C2=A0virt/kvm/kvm_main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 59 +++++++++=
+++++++++++++
> =C2=A012 files changed, 100 insertions(+), 167 deletions(-)
>=20
> --=20
> 2.46.0
>=20
>=20


I forgot to send first patch in the series, resending.

Best regards,
=09Maxim Levitsky

