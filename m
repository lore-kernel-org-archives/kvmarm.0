Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E041E504
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 14:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717423941; cv=none; b=jjJhCajV3PfF33pLryBZfpr+hD8ipphZPgYKYInl49qAAYQbfzGbbxuHug+88JswEuRfB1k/NXBCeEuwlWKFxIn4DJdkBXg3I4IDNmwoQWTxHsvzU7MATU5eXiwLYFZj3CpIteeJ/JSWCJj1U80TIzU08vQyIoKia/Ek+xiuE1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717423941; c=relaxed/simple;
	bh=TCSdlWH+9BgBZ2YnNJYRxexfppVXXsoDFnpDSVNkxq4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZNrArhc50HGjr2iQpfkMafDpOWBW38vMawThQXYQXjcnxGUtuIuhPEMQ+IP11qL+GzB5MjcIRkASAlfoivcPu31CIT+FjB0DMGCGbgiAaxmgY2jjqPeh2dKjpkvwNHIGCOJztNNyzVivVCh/4+SQoLSDKgg3W7Mjn4k548UN01E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qooH66KP; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qooH66KP"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3550134ef25so4126138f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 07:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717423938; x=1718028738; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=259U+kMJsN8fz24hN16dijXIcjtP/ovOa+wMuCYB1KA=;
        b=qooH66KPPh3Y6nPnskWsKUa+B/tEDAo4p+kOtk7Q/0XEzpJ/F4vyVew7/miD7T//bk
         93chVvw2Sf4IC2U3LW/1YUvfJYtRLzJmTupS+bzBbWWB37pq6i4fHm+lEIrv3X3KZ8Vc
         u9ny5Ry5nwUNvIDEYxZGMP+6JDkQMwERTPR4kwv0BPH6SDGjWBn2U9Fvgpyfzv82GebC
         0UOK7WmSjHWLaFJH+rCi1eKpG3KtdRBh3ksIW5Uo//UiN4TMzt+Wslx+2ZbYWsejsHr1
         QCszPTKBqBTbFK3bAyQvTrK2PZHEuV9sCLkA8KhEaRpdo0Kgv7UVEn5WT6i1AMf73IUz
         7ffQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717423938; x=1718028738;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=259U+kMJsN8fz24hN16dijXIcjtP/ovOa+wMuCYB1KA=;
        b=GeZEiANuS+bIH7j5rZmnM0S8e31d1BdxOvP/F3VhAwPxWZohv5rtO5aSDQoEZ/xM/u
         T3RS8pdTQa1xh/pCWoWSTsQbyIvclBOqtxg9juf1hYyqejknWRIShZ+sKNbCS/QCC7Tw
         MpAhD/z17t4t1O2bqo2flYId5IusjdKwK5JY2JX1CoRjPAkGMiwybCe5sVu4yr2ZrBbh
         pmCQxrqXeUE+oVWWoS3P3pVLg2oZliYt0dcPMq4yxHZDwpC9ApwqMucdEdmpzrLBgayO
         8a95gfHNfR3BBiOyqyMX5J57gPwwu20jtXPtniKza7yruBPDPUUVadmB005tSqJgW1U0
         wCpw==
X-Gm-Message-State: AOJu0YzBKw35KosZaCJEW6cCh5xXa2bauF4v1/dMqJvSOQM0l3thusuj
	W8nuIWwMCZcu6xQ+c8XWLNIc9exGzzYhegs56oNM0JSqwYKMW9OoJI4JBgonwaR/e2fnd1H5Xh/
	mnQsnHoTrSqBBeqc5+cnKXJcgytnJJFjC7fze
X-Google-Smtp-Source: AGHT+IF5meOBHRbtue+7XxdpYDL+/KwZLIBA5VkyHsn/NyAJuOSwmgEqlMlhz6eFIR7/LMyN1KRiIYIE6+HmAQ3UOJM=
X-Received: by 2002:a5d:4e88:0:b0:356:4cd8:850d with SMTP id
 ffacd0b85a97d-35e0f273f98mr6252849f8f.25.1717423937609; Mon, 03 Jun 2024
 07:12:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240603122852.3923848-1-tabba@google.com> <20240603122852.3923848-2-tabba@google.com>
 <8d33e86e-893c-45b8-b16c-61a4fb91cc30@sirena.org.uk>
In-Reply-To: <8d33e86e-893c-45b8-b16c-61a4fb91cc30@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 3 Jun 2024 15:11:38 +0100
Message-ID: <CA+EHjTytTLK=bzTPa71DL1SKejprYgCbacdu7Z==YNf2TJMijw@mail.gmail.com>
Subject: Re: [PATCH v4 1/9] KVM: arm64: Reintroduce __sve_save_state
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, will@kernel.org, qperret@google.com, seanjc@google.com, 
	alexandru.elisei@arm.com, catalin.marinas@arm.com, philmd@linaro.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, 
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Mon, Jun 3, 2024 at 2:55=E2=80=AFPM Mark Brown <broonie@kernel.org> wrot=
e:
>
> On Mon, Jun 03, 2024 at 01:28:43PM +0100, Fuad Tabba wrote:
>
> > +void __sve_save_state(void *sve_pffr, u32 *fpsr);
>
> > +SYM_FUNC_START(__sve_save_state)
> > +     mov     x2, #1
> > +     sve_save 0, x1, x2, 3
> > +     ret
> > +SYM_FUNC_END(__sve_save_state)
>
> This is still trying to use x2 as an argument here?

Since __sve_restore_state also has the same problem, I fixed both in
the following patch:

KVM: arm64: Fix prototype for __sve_save_state/__sve_restore_state
https://lore.kernel.org/all/20240603122852.3923848-3-tabba@google.com/

Cheers,
/fuad
