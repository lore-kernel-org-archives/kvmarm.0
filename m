Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919A941208
	for <kvmarm@lists.linux.dev>; Mon,  8 Jan 2024 12:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cX5bA1S2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704718438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gvglX5vfzLPGQZ0Qz47T67FC34QNQiEWEPjU/z3PgsI=;
	b=cX5bA1S2+G22uiUtvhH04zWp1cba4/7DjaaINIUDWoVikTalSMiMDLcv7Inot/6mkvpgah
	ace+gg3C0aMtwjtMJt7EJO8KiB6026CYoiGgQpzjzBisYGpWQkoQnGlXhPlcrQ04845vFF
	Ff0BlWT0/FP9ATBBAzgDom888E2QNLc=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-37-OZrrT9rDNwiF_SdB8zlQnA-1; Mon, 08 Jan 2024 07:53:52 -0500
X-MC-Unique: OZrrT9rDNwiF_SdB8zlQnA-1
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-7cc3e45ef28so487909241.2
        for <kvmarm@lists.linux.dev>; Mon, 08 Jan 2024 04:53:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704718432; x=1705323232;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gvglX5vfzLPGQZ0Qz47T67FC34QNQiEWEPjU/z3PgsI=;
        b=cUwT4tK8IsyHWNS01Br86Tyv899kjTEe8B8RMY5R5ayZF2FNDnNvru4EManZROL3YV
         31D64W9ex45Kv4PmJGUctocxJNeT0AnbRIycmKCIpIraOg3luOzkIzy4mxEBmTIxVm2L
         2JK0Kak0nkzNxsx7tmytqgW1ruKsJvIULYgVjXaam9z0KNo45FINvNW4Ozjv/LVi3e6R
         IHl/ZgkQkL0hjwyyQx1nZOgs8xTs+nvjqVlqLflaCnQQ5ifR22hoA7d5V9F5EtpTz0DK
         +zlUIUszyHtnME/ybIe8Xuc/UVV+BUSXF5VJk36pB4Wk2kJaRWwwSsM3QO3nrSekhyF5
         Fn1Q==
X-Gm-Message-State: AOJu0YxtjPTnp+8i1uDBX3lybdU3NgXO2qV1+MhvOV0E4Ssz7ArOq6dt
	pbmQ7qYHhf2WtERJZHok33oORUzt+xQeH2D4xdwSCAxtvfao+ECUpFU7rDkqRO1SeHb5eOaaJkz
	EfjHt0N1iw0PFUb8PVr/d4tyHKZ4eRL4EXA4wz/uK
X-Received: by 2002:a05:6102:f14:b0:467:d295:377b with SMTP id v20-20020a0561020f1400b00467d295377bmr696754vss.45.1704718431970;
        Mon, 08 Jan 2024 04:53:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH4iZj6Z4CtUJTRdLavXSn1LD4TkVBf4/0EakNdwjXOF+p2sj0LPVYqkUxZ0kYYFZzYyEj/WY2OkrttCyG+zzY=
X-Received: by 2002:a05:6102:f14:b0:467:d295:377b with SMTP id
 v20-20020a0561020f1400b00467d295377bmr696748vss.45.1704718431762; Mon, 08 Jan
 2024 04:53:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240105111756.930029-1-maz@kernel.org>
In-Reply-To: <20240105111756.930029-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 8 Jan 2024 13:53:39 +0100
Message-ID: <CABgObfZFccM6vH4r7oVHgRc3fhgyd=Z5iGKbCar5EEywiFOcUQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.8
To: Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Andre Przywara <andre.przywara@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Joey Gouly <joey.gouly@arm.com>, 
	Kunkun Jiang <jiangkunkun@huawei.com>, Mark Brown <broonie@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Quentin Perret <qperret@google.com>, Russell King <rmk+kernel@armlinux.org.uk>, 
	Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 5, 2024 at 12:18=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Hi Paolo,
>
> Here's the set of KVM/arm64 updates for 6.8. The highlight this time
> around is the LPA2 work by Ryan, bringing 52bit IPA/PA support to 4k
> and 16k page sizes. Also of note is an extensive FGT rework by Fuad
> and another set of NV patches, mostly focusing on supporting NV2.
>
> The rest is a small set of fixes, mostly addressing vgic issues.
>
> Note that this PR contains a branch shared with the arm64 tree (sysreg
> definition updates), and that the LPA2 series is also shared with
> arm64 to resolve some conflicts.
>
> Please pull,
>
>         M.

Pulled, thanks.

Paolo

