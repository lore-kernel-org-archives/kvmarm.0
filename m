Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C8B22E3F7
	for <kvmarm@lists.linux.dev>; Fri, 30 May 2025 15:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748617922; cv=none; b=VGbcZla8MWqg0ZJ4f1LvCDRJK3Zqm86ebQn98Egtu3nLlWTW6dBJ1Z+Q+tihIbLJFW/4owg8HfRXa7qggi0dFDNUhRYZEoL94f22Gtd2vMm5qh+4JUEWH59nO3RkPGIzxtuKeU9Ehs9Zg7yYbxSX45HGQrHOZzAsTErOf+FR5mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748617922; c=relaxed/simple;
	bh=yfqZ4uwCBedZ314UKTh8R56ds3rRmx+4qFuELqIHy8I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BpQbuwRvmP0J/QV6zBNoco8m1llVR/TufqGIdKAfK+lq2xJJkDIjdiV3r81QVmoW0JDviat5Y7LuC3VJsjZhARNSAtZAyranwKrWEPjNim0n8TdZCIoRHXG5gjUZqb8670WeEY9Ejb1BVYKqpnN6DGPgo3nirQMf1nGsD0O/Yd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gUkHyEmw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gUkHyEmw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748617918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yfqZ4uwCBedZ314UKTh8R56ds3rRmx+4qFuELqIHy8I=;
	b=gUkHyEmwTaEdHgT+rCKRr1uH1dvhT2oMZAAGfd3j76oOSZS2julNO8VsCUQ2HCbVyGERHo
	Ad5fMe1/vYBLrmDzYcvcXxu9Gbdl0iaNSyXh8hqMwLYxOS+qCdNkS+AAJ2b5L7+p6uIZkN
	JmXDafxSmXQPmDP+L9YM2stK/Gl0+Jg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-4nPPTX1cNP-q5R8T4SBTZA-1; Fri, 30 May 2025 11:11:56 -0400
X-MC-Unique: 4nPPTX1cNP-q5R8T4SBTZA-1
X-Mimecast-MFC-AGG-ID: 4nPPTX1cNP-q5R8T4SBTZA_1748617915
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4eb9c80deso1204901f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 30 May 2025 08:11:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748617915; x=1749222715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yfqZ4uwCBedZ314UKTh8R56ds3rRmx+4qFuELqIHy8I=;
        b=X49FT/tT8DHRmdGz4EtyX5Bt2M0d4qJnTSxfGDo5i22/8WriB7dD2gu2szjzt0fhuK
         2txGdeDcSM3uFD42h0Z3TQIOOLeyy61Ca2qkih4AB2iAzBBlnt5e7MAkyUaAr4QXvhMJ
         4lIeuGrpy10H0siR7BUXOddrw0wCU3Qgj98qq3AvD4ue8SQZEglNtKdXTo2incZ7ecuW
         PQWDchR29WQ+GIsh+1A7/z2rBwoeB4UIP9ONCKrjgi6flWTgGdo6pB7XSEOapufiSPJ6
         G5bt0TTSHdmFE8vtDZkXKiwo5tOFqr/KHMi0kRVuusYVWAXasfwDRv9/5D/dkXptie4z
         BS/A==
X-Forwarded-Encrypted: i=1; AJvYcCV86zF11cHLAr3ewifyszxZ/QsfxaK9krBqjNkKk7kshg+6w5yZzvSd0A/q+2biB+zUP5a6Q4c=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1dyz3kiqQaJG56vegyjLjmkJbEe3wSoDwTvf7peVgCe8kJV1R
	07LMkRV8PQ4udVNTo6yBIIToLJwfxapxHWF1FGn81a32sJFTakVodjUQDQvAQBwXF7FlCmesiEF
	xxaMREShpMgv3cO5txvoNlbXEKvb4lAXMwbr0HHDfvcnM54dxN6piQIGjggVnEjqKo68xFrN4dK
	ghXx+DxpJjL27UH8/mnBK/DctecfTqKE5P
X-Gm-Gg: ASbGncvTWC/rOzOgx/3qcPyUjPot1MK+B5h7kzBnrSdu0K2uB7iDbAhrJpz58gedZNo
	XZUiG6xxf8mT94J7YI+rWqKCEHsJQVWyvMIj1eOwnS4x1n528HGHhBXaxCQPe/qlgM8E=
X-Received: by 2002:a05:6000:2907:b0:3a4:f6b7:8b07 with SMTP id ffacd0b85a97d-3a4f89dd0e0mr2510030f8f.48.1748617915369;
        Fri, 30 May 2025 08:11:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0zplckeg0pZyVVtsF4Rx+t90b7lYELscoecfMN3axFdzklZzbvdq5/jQJWSDnQewmwTsExNb1LUaSwI9dMiY=
X-Received: by 2002:a05:6000:2907:b0:3a4:f6b7:8b07 with SMTP id
 ffacd0b85a97d-3a4f89dd0e0mr2509983f8f.48.1748617915000; Fri, 30 May 2025
 08:11:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250530095223.1153860-1-maz@kernel.org>
In-Reply-To: <20250530095223.1153860-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 30 May 2025 17:11:42 +0200
X-Gm-Features: AX0GCFs45z1db-bj9Xqr5W0smLTP6OZ81Z8ky2sMoDqJ9qQmYN3iiueiMy14ig8
Message-ID: <CABgObfb+MeNYmRpubfqf=KHWxNcK4bR7bHSsaKERF28ATYj6yQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.16, take #1
To: Marc Zyngier <maz@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Dan Carpenter <dan.carpenter@linaro.org>, D Scott Phillips <scott@os.amperecomputing.com>, 
	Jing Zhang <jingzhangos@google.com>, Mark Brown <broonie@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>, 
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mbt9ucrSMS6Uaw1G-uvvK7DTauTqJoSGEdvF4tgSEYw_1748617915
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2025 at 11:52=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Paolo,
>
> Here's the first batch of fixes for KVM/arm64. Nothing very exciting,
> except for yet another annoying race condition in the vgic init code
> spotted by everybody's favourite backtrace generator (syzkaller).

That was fast. :) Pulled, thanks.

Paolo

