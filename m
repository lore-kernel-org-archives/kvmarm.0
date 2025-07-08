Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8794F2DC33F
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 14:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751986146; cv=none; b=uxng/wGeom84zyyZNZACucEEoEyjSih4wNBZMPPHBcdlH3WeEEUu/qPTSjiX66IkzWQSniichEPTakomJjdEhq5jyTc8aldaE2YD/RdyOHoKYxcII0haglpiza4qT9V4qsJWPTGmo77qNY+1NHpYuwNuiWuMnTaAMRe+zc9VdIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751986146; c=relaxed/simple;
	bh=q8spVkoLv2r7TKyH2WL1jNBqws9fnH4WQcFK7oE9C1s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Az10tepqvzmnQWeuZe5lE+W9mWfOoxgSrSa2Q2lLYFGWuW/ie9vYDcNiuiGgL2iN4fHWss076lnHM5kfc9/pQXiCsTO21t9JuUr37kWI22EmYopUVcM9mmZusVfYGIio5jK2Hd7pIhAkM0nXFz1yJLfadE/xyVSJDu45mEwsr+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vc3FcvVV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vc3FcvVV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751986143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ilLnM1nkDK5EG4IlWePIEBnogI1MpE46KJsgpSIvj2E=;
	b=Vc3FcvVVuuNO2J1oh2SUHtg4W3P3QeaFz3+tRl1ds7+1dfG+ncsg6f9bqxRyxjUFmaVXXy
	AYNGk94NKO1yVHK2IPkMYrAWQ23vjB32CyQ5iRnMEZis9/2n0U6q+QmguGIGCLGMFsfSX9
	9pMmlYjW+D/3t4lI6EM4vIGPo+QnlgQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-76szLN-YNBO4WuXbFAoWWQ-1; Tue, 08 Jul 2025 10:49:02 -0400
X-MC-Unique: 76szLN-YNBO4WuXbFAoWWQ-1
X-Mimecast-MFC-AGG-ID: 76szLN-YNBO4WuXbFAoWWQ_1751986141
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4f7f1b932so2954450f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 08 Jul 2025 07:49:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751986141; x=1752590941;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ilLnM1nkDK5EG4IlWePIEBnogI1MpE46KJsgpSIvj2E=;
        b=Zj3utkv3Cu3i+EUyUhC8zwK5MXkpTfxOF6kkHAIgq8cw4d4Jtty/jX/QbpZRUOltop
         vOkEkZC/6RnTau9EvHWymy0BYLyDnx/C8aOLmckSXyaBztJjwTKQytJahtUnC4Ep7mt4
         H+xMDVoGV0N4/j+GwDPHIQpw6zgiTuPB7263MPDZjvYeFP8tZ0rBDRXjE7kETsFrMPEC
         cS/7gM6IAIE/Htehw3izWfhLkbHSJh7G9liNIxinUDfjOCSl3/1Mm4Cs0+oLOC1nebpw
         UDKyvo3+Qeoe1uAzrCyoJ2pcQgZqUYvW7XSbd7+lOdaDkKn1YeQzenaiQdbZA59Ij55g
         sDeg==
X-Forwarded-Encrypted: i=1; AJvYcCXBkgmArs9YAH9i+Awe3AMCkB+AqpV7+iO9oHPcMSco8UEgS5agsII8BjH9qi+R8lr3f8LggjA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwXqDAu+Xb6ALG6DKiCTiW+sGW+J/DI1xwdpgyo6MG0L/LxR4zn
	VHHKB92tGTUhS5xXzMdt2szBWGxfEmQ2u062qPF5fM4Z5o5EkmapqTv66WCAtYQxDE3/ZZ8GHAe
	xZOEizbL56OxEY7aT12h+qagPDKIrDjigoVdwZ4hswM2DIedHxqGPZLv4nocXSvAKR8fuaNCwA8
	7Bz1jR2Dp761ArA2lOxqZB9ovgUYBBsqBU
X-Gm-Gg: ASbGncta1LP6HHd6ZMlCgql8KdvXqxg9vVyAZgdiRLKSMs8r8SsM0U4hU8yr8MSspeC
	I/lQEh9ev6yJRenFgxuDtBy1xVySb+xpc4RIjuJHa2B7Ux673pjUyYS1xPsZqLkSscDvHiw4e8z
	WLKw==
X-Received: by 2002:a05:6000:2281:b0:3b4:4876:9088 with SMTP id ffacd0b85a97d-3b49702e7e1mr13523183f8f.46.1751986140859;
        Tue, 08 Jul 2025 07:49:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHNmhF5tEibNLSO4zklVeukkffwYibjFI3qCmoKoreWsosWzDc7FRBfrG9K0f+Z6MixAgDUVST4ozCaCvN0Rx0=
X-Received: by 2002:a05:6000:2281:b0:3b4:4876:9088 with SMTP id
 ffacd0b85a97d-3b49702e7e1mr13523163f8f.46.1751986140408; Tue, 08 Jul 2025
 07:49:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250703100544.947908-1-maz@kernel.org>
In-Reply-To: <20250703100544.947908-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 8 Jul 2025 16:48:48 +0200
X-Gm-Features: Ac12FXyc1eDwUfgvyIyyq8lMwH--Dkal7I5XoAdK2HIbjIFxeLbn23IfObIwnEg
Message-ID: <CABgObfafDC6m303YirQvgYdfZxZ6fL0LmU4H0gKdkGGv9QvVeA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.16, take #5
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>, 
	Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UqUG2eqFhm9E8d8R3NHkZsNMAAfcNk0WCiOCV8DZeSs_1751986141
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 3, 2025 at 12:08=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> The one-fixes-PR-per-week trend continues, with ever decreasing levels
> of severity.
>
> This time, we drop some leftovers from past fixes, removing the EL1 S1
> mapping of the host FPSIMD state, and stop advertising bogus S2 base
> granule sizes to the guest.
>
> I expect you will bundle this with the kvmarm-fixes-6.16-4 PR from
> last week.

Indeed.  It'll get to Linus tomorrow after the KVM community call.

Paolo

