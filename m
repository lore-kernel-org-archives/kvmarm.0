Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8112E28D85C
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 17:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745516217; cv=none; b=VkTRxjsBkSMk6yA5hYI7vj0ubXDGVjdkwvLlPG8y/ZUYNcu3CAeTg/Tt72aLz1bc277ZnIVN7hzGR68caR9/aZZIxz8CShewIO+Rh79GUJ0Po0ysiy/SzExtzOt3deMoRegjjHxLdCPRSLj+PjzY5Holpdan2Xj5huX3DhEPKDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745516217; c=relaxed/simple;
	bh=lZoZzIu4SzmOx9ZR8NQErN8IG5FsxE1ZcCH+9ijYP7M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bxmIs0xx9vuo9obHAFO7nCAh4o4V579yKTtJ1WXBkoBFaTxcpb74hL7d6zoj6XHWc+D95IqhiWdX3NYrbMJtkWo0qitricmxAApXkdYHfMp9JbtrxdQFrpnzUNk+L+V/lLTIYmqIq5e6UFrhJtslEFxc3ySGjMxM9AYpN8RUHLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OrmfHhf4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OrmfHhf4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745516214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NBqK9fMqIBSDESBuCvkZEwLHI6yCeTSX1Y6Z0m9j4Sg=;
	b=OrmfHhf45oq9ppBKjuUBMxCRkKGkngGb6rCacLZ8/Ie50ZfJ4i+WshqKzGPUmvK/Z3CfKK
	KNZjPZLtNSUvdkSuGRLhlV14e2vgeEGCqeYDPHYAc/MmtBfiFm0BOnDQb8ZKO2LUM+/TXb
	DXPdIn9tCf372QZ+MbPH8aN+E0QIdtA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-13-sEG7hhdpNymf7eX-PACJEA-1; Thu, 24 Apr 2025 13:36:52 -0400
X-MC-Unique: sEG7hhdpNymf7eX-PACJEA-1
X-Mimecast-MFC-AGG-ID: sEG7hhdpNymf7eX-PACJEA_1745516212
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43efa869b0aso8505025e9.3
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 10:36:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745516211; x=1746121011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NBqK9fMqIBSDESBuCvkZEwLHI6yCeTSX1Y6Z0m9j4Sg=;
        b=aMuhNcNGXZJcg6xwIxv90xrn6blBcTqtG9aCvA2grlwNxcrEgbRK/2qaprTnsT8a1R
         pp2Q+QGxFAE+oy45VNesImDYyiFmBp0Oq6wDCLuD6vc8J8TKiI8cLmSHvSgdqW9fWpI1
         nfNiejn9qja6hGBNPJmaf5hSqC9k2evMOphd9LnsIWW99wT8cOYDs5vM+w4T1WhL6AyG
         brWDiC3uRTLaH1NIGOb73o4z6IBrDgpUHUwtpnef9isXOGfab8R51A5x2sDzjR0GP6eR
         GrEMx0uqA4DvpoCTaDPavnO8RuNzklL5skOdqsYR716L7suHM9JLsW7atDWBsxd+OO4R
         ZRUA==
X-Forwarded-Encrypted: i=1; AJvYcCUSiqloo7G5gn7n9eADoOM5B9XMEVr7CZiuhLg/TYRUYwmJ2mplgl50ze9Y9VSnC1i8qWwQb5Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YzP1No5QO+/eFEyGwdTiyDlXRoVOzJIAuA/Vn3xC9RDtH7QWVfs
	QWbeg63i4yORYCw74EWO3m1JqZy3Z469ybyr+IBNqOKYbMdV88LC3Vs9AZlDMnn4vwHyBwY65N3
	r2xNKJrPwNBhHhkn2R2i1iNdDCT5T5+uydhSG/8016kaYcfeyzxzj+frvowkaRx2vkPNGxMr9pc
	lQeqV4ZV3Qh4RfM6sS/nX7Gc/AWZTj
X-Gm-Gg: ASbGncuE4dymU4/vtFQKkaEXJ4iQRT6N6QQjpCvwp10CHZlifs6y/Y75D+8wQwOUbyj
	jiUT8n3WiZEoK8opKdSrz5xPH5oa7uCKbZR/JwZixelBtcML084vjvhioSCuy/4SlAd0=
X-Received: by 2002:a05:6000:430b:b0:39c:1257:cd41 with SMTP id ffacd0b85a97d-3a072c037c5mr182217f8f.59.1745516211575;
        Thu, 24 Apr 2025 10:36:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHU+QW9NBnJ+gaooLF6UkTfbCZ6u5CpxxIqFOeklcv47T+lKysC0aQ9W6aokAxSAY0FX+NSTDgLkJoz96SvQQ=
X-Received: by 2002:a05:6000:430b:b0:39c:1257:cd41 with SMTP id
 ffacd0b85a97d-3a072c037c5mr182205f8f.59.1745516211195; Thu, 24 Apr 2025
 10:36:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <aAK9xg9DMfCsCPux@linux.dev>
In-Reply-To: <aAK9xg9DMfCsCPux@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 24 Apr 2025 19:36:39 +0200
X-Gm-Features: ATxdqUHk1jfhP-87m-tPcfs6H_WLbPj5OnJMOLQCc-HQymmwOLcmUKumm3-4lBc
Message-ID: <CABgObfZvEgABLG420ofjH+iyrVEihhX0D9giCMfEC0SFQDjwDg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.15, round #2
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lm_-Kh_PQDn-Hme6Mb6WaOgachrJzaRVUiTqZ4DfBE0_1745516212
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 18, 2025 at 11:02=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> Hi Paolo,
>
> Here's a single rather urgent fix for 6.15 that addresses boot failures
> from the PV MIDR infrastructure. Catalin has reviewed the patch and
> asked I grab it since it's the end of the working week for him.

Done now, thanks for your patience.

Paolo

> Please pull.
>
> Thanks,
> Oliver
>
> The following changes since commit a344e258acb0a7f0e7ed10a795c52d1baf7051=
64:
>
>   KVM: arm64: Use acquire/release to communicate FF-A version negotiation=
 (2025-04-07 15:03:34 -0700)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags=
/kvmarm-fixes-6.15-2
>
> for you to fetch changes up to 117c3b21d3c79af56750f18a54f2c468f30c8a45:
>
>   arm64: Rework checks for broken Cavium HW in the PI code (2025-04-18 13=
:51:07 -0700)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.15, round #2
>
>  - Single fix for broken usage of 'multi-MIDR' infrastructure in PI
>    code, adding an open-coded erratum check for everyone's favorite pile
>    of sand: Cavium ThunderX
>
> ----------------------------------------------------------------
> Marc Zyngier (1):
>       arm64: Rework checks for broken Cavium HW in the PI code
>
>  arch/arm64/include/asm/mmu.h      | 11 -----------
>  arch/arm64/kernel/cpu_errata.c    |  2 +-
>  arch/arm64/kernel/image-vars.h    |  4 ----
>  arch/arm64/kernel/pi/map_kernel.c | 25 ++++++++++++++++++++++++-
>  4 files changed, 25 insertions(+), 17 deletions(-)
>

