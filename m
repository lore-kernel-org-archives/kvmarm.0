Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2D53D96A
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 10:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708510941; cv=none; b=PeKBtG+4XGpVoybcA+HvxTHsWKrl63+0clZKLK4gjxtg4MMEHrfL0+t/i9IFff/7CIgNVdwbkMSccbrQbSD7pVDO6GrsA/y0CB+/TfYgPFIa/fQRglxN1mJ6cRVtYGbSJZ96X95Q54Nt7EjwlqdxBDIlX/WbwXn5vRTEFMjKNNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708510941; c=relaxed/simple;
	bh=MBN4tZLx9uqlClY2UUZIW6lED/pYey1dCXSJvx+odk4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=McF9LqHvBF16Rdi50i2Rmgk5yDKWU+uRTSDIDBdPS+zqpklwJ+kypDoJ6w7n5CoQtlgLCVzCGPGRftcJC1a72ebUK7OdIDCrT5/qEzDs7ffj+JnXXT5y6TGeIeiIJLXcYw+pEMHVHW9kFo8MGOA9IWPDBklBUNwmAXNN8aQwUv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=actkGSFE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="actkGSFE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708510938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MBN4tZLx9uqlClY2UUZIW6lED/pYey1dCXSJvx+odk4=;
	b=actkGSFEJENdMmNbP270rrI+k6981DItSU5DYK2bK4NvNSHS6jzQSs3yJ1WGHQ51khygek
	JiARMLlpwW+3pW0RcdmsRrVwpt1h2T4glf8Xv9GJBtl9iPhIcYxVbM06Elb91HCgO/DA8w
	GspoFWtAl1WrAVrOZ6jayltI3+YmRtM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-55-lKTCQFdKPyOuEDEy0hQxBw-1; Wed, 21 Feb 2024 05:22:16 -0500
X-MC-Unique: lKTCQFdKPyOuEDEy0hQxBw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33d36736772so1456905f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 02:22:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708510936; x=1709115736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MBN4tZLx9uqlClY2UUZIW6lED/pYey1dCXSJvx+odk4=;
        b=E6NmTrAhsZwdYMULSITtgcRavzgfx1rYxhoZJIgRW/S2i+jQk4bPsazEDRY1cibHCH
         chSfGKSvnPnoRkox9vx1oXJYom//s243cu0JofSNhEywsUwh+IWFU8nJIrT88aYlAoaH
         A577XQHH+oU5zDkMduz41M/72raeKsYoOK0MNWY2Sh7igVpGNSLRSb6PH7NwSa4eEl12
         zH5w6MtyBlwdCwMnjrDgpLs2UxJatJsPyt2YfcQ7f1fmyvqZu7IW9hGP0nEgi/80xEuZ
         mMrJGMtmO3qwug6NfM/OPvuGSVQlOK2Pr3Ka6YuTEV43asMj4syqbRes3scp6xMwmmYA
         N0Fg==
X-Forwarded-Encrypted: i=1; AJvYcCVZvGfMe41iCsPmdTs+/7hGt2ZQEv7suqdPP8T8BM8F4fVp8fySnlKZ8tguWvwrtMRLogIJhjlVYRzumhXk2opf5PhT6a8P
X-Gm-Message-State: AOJu0YxK2Y9vrTedqnv4E3IBZZhs1Eshf0RE1O3IEs2HxylCbNIekl22
	7LVxOfdx55YzW9W2DGGuREsd795MTx/lpoQ9vjS6TTG3Z04JKbPPGvlFZmdr21kCqn25VWzUFLW
	HIEvj7OJ97UArTKC3ZpmpXWMkuxM3KtRmg6TbxeeeMNkDzN6Ighz6KYZunW35le8n6M3YGTcb2E
	6E4tclX1bVOIPiBimSAJHRH6H8gMj3
X-Received: by 2002:adf:f187:0:b0:33d:82a:14af with SMTP id h7-20020adff187000000b0033d082a14afmr10422415wro.64.1708510935908;
        Wed, 21 Feb 2024 02:22:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEvDqSnBb58aQpo8cE5SEQccLaBDo+ZMPgrcp5t1F8E/OswfeRU0UTussQ1HTHhX/5fllx61sBxucn79Zk7EyY=
X-Received: by 2002:adf:f187:0:b0:33d:82a:14af with SMTP id
 h7-20020adff187000000b0033d082a14afmr10422408wro.64.1708510935638; Wed, 21
 Feb 2024 02:22:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240221101711.2105066-1-maz@kernel.org>
In-Reply-To: <20240221101711.2105066-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 21 Feb 2024 11:22:04 +0100
Message-ID: <CABgObfYhVK+qF25h8+hhuyCvbgfpocDo0UDac3CTEHghRGww+w@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.8, take #3
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 21, 2024 at 11:17=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Hey Paolo,
>
> Another week, another couple of fixes. This time, two fixes for the
> ITS emulation that could result in non-existent LPIs being used, with
> unpredictable consequences. Thanks to Oliver for spotting those as he
> was reworking the ITS translation cache.

The consequences would really be NULL pointer dereferences, wouldn't they?

Pulled, thanks (not pushed so that I can adjust the merge commit message).

Paolo

