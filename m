Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A774A6CF6
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 20:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788469109; cv=none; b=YMrR+RlaUpA5YTNZz22DW1H2kSxiI0rfYRVPPkTRAmb9ltVjVYUQGEP7gnUf8CVG9QrIY1UEhC/tinDbdZROkX2DpK5140cymUYzZe3hNy55UY1hZAIfU5fqds9B7C2vBNy0i5rYaK6ezLwPLiEvtRp65LiUVLebgiC5El2/TBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788469109; c=relaxed/simple;
	bh=L632ql4Sd/RozUuu0s8fdwZF7MOouQPT9rB6yRaOm7Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EkPRM7iqBpSHQUtOkPVhRvoc3QOIHHhXLkcvanCK4pSJOq44o+SWYCxT4QmB6sFL7nZ9aFM1uWpL+Od6j29wuRR+2YGj4cOWzqSn70Etc/mPe3GjCNWHxcjE7qvIcBYu1ifOmTxkIDQvQw+1W80ULkk66c9ReJsS3dNU6OcyG4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gRqco5+C; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gRqco5+C"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d6f80c76e6so4663125ad.3
        for <kvmarm@lists.linux.dev>; Thu, 03 Sep 2026 13:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788469098; x=1789073898; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=L632ql4Sd/RozUuu0s8fdwZF7MOouQPT9rB6yRaOm7Q=;
        b=gRqco5+CmygNdzZD6oiAOr+CUY72T89wlZ/LvdeFFthNWhHdvZ8YnwggzyYj72hk5i
         gGIN+LuXVNOkS48x/lmm6C+HIq8KtFZvTtkWO2x4KKyfGp87Wdd2t3m45TmyO5joIbCm
         idP6sMObydxjYxYiWbPaI1kNVXEA+68esrRK9BZXbC80VkZGYLILaKdx3U9/PDAkmyp/
         iT2j3Ydl2qli+72/KtAJGxm2XZE1QPzEWiF0RVOreNj6KJiGAYzaXY8IbU8ZQi5yeWY/
         vEebfwOh/Hik1snw+vH+GjGk0qD/5C4siPrd9951OOqN0/2uvlePqQKdopo5fPmfiRg9
         esgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788469098; x=1789073898;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L632ql4Sd/RozUuu0s8fdwZF7MOouQPT9rB6yRaOm7Q=;
        b=KQMNWzByu4yZL+UX2PyTYYLtdFIiqtn3NeTmcrDX3eXK770rKaANQ0P++w9kOdXs7y
         E0WH8yFRmuFzcdZyLGDvU0HkvkDWtrTlNAyoISxN9e3uSc8Ogsl6EN2fw0QE9llwYMfg
         0nnJaRpdVv9U3X2SD0xD+QFKRmZpSTWlXyQHE7sbejQVOQLUFdfqOeoFsih1P6pNdQj1
         zBuojuKvAQGb9CUcCTcBQBw207xcFJOgAKZzzJpiuQXv8pHfBL/WcZeLymNxGPECYKsZ
         IP7bWTV92TiZria/cxULL3Xr/wtjnk4+qyaNKbXrkW1oRdA3rVl02b5F5yJi039p8/av
         iVjg==
X-Forwarded-Encrypted: i=1; AKwUvBwJjG3aGxIt3heBl2Zlv6gVs6vGdqMjkaFVcu/jpehJU7nUALyx9JEJHMQUf02FU19TQ2Lq+vI=@lists.linux.dev
X-Gm-Message-State: AFuF++mhU0DChWstZFz9mSf/3hK6O6kH06rz9yG2rVPukFsTclEXqLYj
	IhuPjO31V/YXN5GP5hRr2a3Gqz3TXZp/+shMhT8RH9TGbhgCMoMPMLykA1XEpq1is9f20IGCoiN
	MQ7WRZQ==
X-Received: from plxj7.prod.google.com ([2002:a17:902:da87:b0:2d9:1c43:7134])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:120d:b0:2d8:d4cc:be65
 with SMTP id d9443c01a7336-2db12873c1fmr17910145ad.18.1788469097697; Thu, 03
 Sep 2026 13:58:17 -0700 (PDT)
Date: Thu, 3 Sep 2026 13:58:17 -0700
In-Reply-To: <CABgObfZL-qNSaNkNZDj0Kk41zw6UZ30vkSxc6T8wb-pOKab9Wg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <apdweRfqt4dTxcU9@google.com> <20260902075028.231001-D-seiden@linux.ibm.com>
 <aphLXQL1H2zYZgTi@google.com> <20260903114241.33034-C-seiden@linux.ibm.com>
 <apmEi1NmOUvmUBFP@google.com> <apmFClPZ2WcDINmT@google.com>
 <apmIGgMEN8w-kQAm@google.com> <19d4feb1-d703-4c62-8622-a6d5e9d6394c@redhat.com>
 <apmYPMMPCNzK9ZEA@google.com> <CABgObfZL-qNSaNkNZDj0Kk41zw6UZ30vkSxc6T8wb-pOKab9Wg@mail.gmail.com>
Message-ID: <apnfaeWZoZTIsoZS@google.com>
Subject: Re: [PATCH v7 02/23] KVM: Make device name configurable
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Steffen Eiden <seiden@linux.ibm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Andreas Grapentin <gra@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@kernel.org>, 
	Friedrich Welter <fritz@linux.ibm.com>, Fuad Tabba <tabba@google.com>, 
	Gautam Gala <ggala@linux.ibm.com>, Hariharan Mari <hari55@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Hendrik Brueckner <brueckner@linux.ibm.com>, 
	Ilya Leoshkevich <iii@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Marc Zyngier <maz@kernel.org>, Nico Boehr <nrb@linux.ibm.com>, 
	Nina Schoetterl-Glausch <oss@nina.schoetterlglausch.eu>, Oliver Upton <oupton@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Ulrich Weigand <Ulrich.Weigand@de.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 03, 2026, Paolo Bonzini wrote:
> On Thu, Sep 3, 2026 at 5:54=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> > > I don't want KVM to be the. one that does things differently *once mo=
re*.
> >
> > Too late :-D
> >
> > arch/arm64/kvm/hyp/nvhe/Makefile:ccflags-y :=3D -D__KVM_NVHE_HYPERVISOR=
__ -D__DISABLE_EXPORTS -D__DISABLE_TRACE_MMIO__
> > arch/arm64/kvm/hyp/vhe/Makefile:ccflags-y :=3D -D__KVM_VHE_HYPERVISOR__
>=20
> Sure, VHE/nVHE is fair game because the nVHE case is in the same boat
> as vDSO, arch/*/boot, and so on.
>=20
> Looking at a grep for (cflags|CFLAGS).*\-D most are -DDEBUG,
> -DDISABLE_BRANCH_PROFILING, -DDEFAULT_SYMBOL_NAMESPACE, etc. and in
> most cases they seem like a bad idea. Don't do it for KVM please;
> requiring -D for all architectures and for random pieces of config,
> when you can put it in asm/kvm_host.h, is just as bad if not worse.

Boo, it's never fun when a parent shows up and takes away your toys :-D
