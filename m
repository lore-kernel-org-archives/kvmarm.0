Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1576F1CB9E1
	for <kvmarm@lists.linux.dev>; Thu, 21 Nov 2024 11:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732186885; cv=none; b=HosBksCFh8yKF/iOMjFidSfuR9lPuqW75bsty+iC/kCQvwtwLmhZ9/DEDTKbOA6JN5nL7uBARz6OZ+U+bMJUT7W8nfH+Wn5JSn5hGkfCMtdOYG8aWxXj/AC7cLj98tGH/P1pdCgy+A/boCth8W+OQm3AdX+Zih5nsOSLlVStQYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732186885; c=relaxed/simple;
	bh=tOuK6PhBFR67sFxNosi3HgKlYBFKqlwSZe2KlQVufCU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N1GqGTZxKiYKyU84PbahiUMGYa7IabM12Q9IxjS4K4VSzif86g4DYpD9F6tUzRJGhLyDB1SCBSFVTxa41MC2eNfLQ7rQIfGDpVPm2E+W+qRnhJZRRc1wdc33uVBi3XV33IgIbWVrDtAaWiX8QXg6+g7tVvJcmWO/86TGQMffSoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ekNH+aE/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ekNH+aE/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732186883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tOuK6PhBFR67sFxNosi3HgKlYBFKqlwSZe2KlQVufCU=;
	b=ekNH+aE/1og2DFbn5s82bHazEnYTO8RErtEC2YxKjMvBu4XhM9JjXep3xNFj9NkH4tXwHx
	B1G9ESwVXo77P+7roAKcYvwQsgLImuSACFzrZ5c4zFzYTUyCYuxvh36dNxVHKVcMcnsPxN
	+qYYYo+MjnNfFqZPcHSn2idzkwa5grw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-208-fD9BEiNYMWabDjrwnVGw6A-1; Thu, 21 Nov 2024 06:01:21 -0500
X-MC-Unique: fD9BEiNYMWabDjrwnVGw6A-1
X-Mimecast-MFC-AGG-ID: fD9BEiNYMWabDjrwnVGw6A
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4314f023f55so5142265e9.2
        for <kvmarm@lists.linux.dev>; Thu, 21 Nov 2024 03:01:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732186880; x=1732791680;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tOuK6PhBFR67sFxNosi3HgKlYBFKqlwSZe2KlQVufCU=;
        b=mw0LerOKv1hd+SJn4ZXw+gyXEkOgAmyvCYuqY0DS2vVZzhUd0ZFKBzpWe6Kl132ZSW
         goqOMujTNE362Gdg/2wV3/U/aEgJh2CcxEk75UaX2ZOSWTbyRnueu3+1Rf/dKyRvsnum
         aEjqmSg2a4IFTYZZsMtwgh4Y4Oeq0DVnX2cjNIPYWEFJHxzp9Q0wOLnLUZb/0hGb2ljY
         RF+jQNMEBjcnuP0PKTxQ55v004ZJS4d32nTmLowKhuxizB2LG/8yFT80sIngZvUyIyre
         QQd6wBAxRuOfleoRzK/trX/pJnkufEwsjwsv+ezybYwPRgGoJAazCXswIRwEvdLMryuP
         4qjg==
X-Forwarded-Encrypted: i=1; AJvYcCUc/J3JhhgWv1Eoq9ejb4Ltb0N8mzO22TQ/9Dz3zzARKPu9RuDKfGQCZIi7vmbMtcVAg2b0bPo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxGpFnPl1ouEa2rhyRZ+MZXbCgWRo4JDu/fiITRPkhAzMG1DVro
	I6a8K2Dps/igBrN6PiUCx/6kOZNQ88RPEGHbphzrKK8nf9r3KjPhHqtI8h5lx5bsN8CMmz8PQKj
	z7TGY947bg3sKJx4McWr6/J8pzO2qFGG8EM0J5PpxGUSlr7/qmB83amZVNqCSALYBdTwZwr+ony
	skBjANJkPS+qky4jBGii1IGAJaek73
X-Gm-Gg: ASbGnctbsny+U4yWb30shDlyf76DfTWlvzJb2P4IFTK7SZSeSfLrHVcGzng0CSt/eUs
	Me2zj9RTMjtjg4+HnnRtTh7WaeyeYXlI=
X-Received: by 2002:a5d:59a6:0:b0:382:4fa4:e539 with SMTP id ffacd0b85a97d-38254ade561mr5527276f8f.2.1732186880492;
        Thu, 21 Nov 2024 03:01:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHPsNju8DqEAsbUoBlH5FG7SPCdj1FPMazPqm9+bABcWR+xzSkUZWtpG5IoVakcOu1MFrAUc96srC1chIe7PMs=
X-Received: by 2002:a5d:59a6:0:b0:382:4fa4:e539 with SMTP id
 ffacd0b85a97d-38254ade561mr5527245f8f.2.1732186880092; Thu, 21 Nov 2024
 03:01:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Zz7vLEbLFXuRSPeo@linux.dev>
In-Reply-To: <Zz7vLEbLFXuRSPeo@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 21 Nov 2024 12:01:08 +0100
Message-ID: <CABgObfb+P7xaLqiPBzshMQTfSRg8B7LSYswzipNTk6bzWkbuXA@mail.gmail.com>
Subject: Re: [GIT PULL] First batch of KVM/arm64 fixes for 6.13
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Anup Patel <anup@brainfault.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FcYrBmwyTxReVH5a9USybZvz3wSnjPaMsImqIGtGK40_1732186880
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 21, 2024 at 9:28=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Paolo,
>
> Had a surprising amount of fixes turn up over the past few days so it is
> probably best to send the first batch your way. The LPI invalidation and
> compilation fix are particularly concerning, rest of the details found in
> the tag.

Sure. Anup, if your second PR is ready please send it already.

Paolo

