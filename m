Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AD657C9F
	for <kvmarm@lists.linux.dev>; Fri, 13 Dec 2024 16:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734107486; cv=none; b=gMxeTOUNGHD+tBCvIho0s/aW0yyj5+SiBAhwQekVDOb6xG3YMFv30z2tfJhw7/RrSniae+CqK/r+SYSyC+u2sAJWG0vueClY+7dgMLNABhHI/bN6oNC0fiN9yUIR/glripmywXO7IjzahSx4bCrDDk93osb5E340oVT95+jfAvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734107486; c=relaxed/simple;
	bh=p3/xnDJpLMBNaNxWDCIoa0OqWOlzD1iusnvOin0v22I=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=l5GaDWFJqW/XcRusLWARJyiSk9udTeH85vpOaUhZRG0s+Mfk9kcybLikUyZvdSTZYKdBtI5PtvI87+7Qi6UUIihv344NYojROMuv+tefA1y4iXndksDcYg3rHca0o0ve87+Uwz/hnjVDyny5PIfu22KwGn2K+ZHUvluKgWsnZug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h92Y+Da6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h92Y+Da6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734107483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p3/xnDJpLMBNaNxWDCIoa0OqWOlzD1iusnvOin0v22I=;
	b=h92Y+Da6sn0LxjEGLr3LUP2lu97qDFRpokzqhs0Ps2huVF/tjZ4FKWovruU5tZcWreftDY
	kKgQJgLW9TWX2dhHIBlKs5GBiODF/oUB+xwpg8h/MAlUhRN5PtmsxTe/q29NVuNofqgVHh
	sYq3rZ5AOTcH1qFQRR6GtOUa5zXJmPQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-V7W0bURMPDePAqEdMYC4ow-1; Fri, 13 Dec 2024 11:31:22 -0500
X-MC-Unique: V7W0bURMPDePAqEdMYC4ow-1
X-Mimecast-MFC-AGG-ID: V7W0bURMPDePAqEdMYC4ow
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3878ad4bf8cso1272599f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 13 Dec 2024 08:31:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734107481; x=1734712281;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p3/xnDJpLMBNaNxWDCIoa0OqWOlzD1iusnvOin0v22I=;
        b=HUa6OFMaFa6i+qqvOQH6NIo6YZLZNnI1pZO46jVU5QUk2Y9qH47gjbjmQ5crUcKVva
         3X6QmpAVIn/DpzsSasXGcG0Ba1xW/efID1iDuZS/ylYhUoppo2JBi5KfiljE492/7Bb8
         rLhLiaIozvlFm0D+EDAGZeQ76FFgOF2NEHE+x0jZlIZgHh7hev3LLjGKjLFpyqr7BXke
         HByttc7i4+ajBgpmh/VReGNR2XjrAfge4Rw++aisSWVq6dpYFf8QZSdSHG4kXGhSMpkR
         JcTN7O7RjMaVODG6V9QAqDCHlo88BOv3reBAjMJ5SyyxjSLvnH2y/LOe0tx57mt/UZxW
         +g+w==
X-Gm-Message-State: AOJu0Ywd7LU/R/pkoRhRhhvFni3q1CjubhZ/fH9azclzq12RCg0zFzc/
	e1k8R+m5wQenxjhBGJgZ0sqpd/+pYxUZbEACVLIrNzwIez9vpPk/vRMOtOyb2jI4Yo12G82cT5v
	8WSkZuZHJQqUwOR4BoFaZ081YY5WbH2I7Q3lpXrw1lgJNv2gMvJPKtg==
X-Gm-Gg: ASbGncsK0hH9jIbnVa1RxNDLBAesiwTLOLwIdpfaPSilYmr8XidF5/Gvp3vuhFdfgvS
	I3tDvjc3xxC3NUBVvaxfADBDY0slGB0PFmjNkimnJxqH7s9B85EG9Kelim6N9vWsI5qQix12OJi
	/WeN3KAjR1m445coTnNCQMak5i+aEFdGIUpCVrCjzkjvhE/m3gLjb1oo54S0QUrx+tl10yYeqYa
	reFgYoel+6A81Mc9SQQ/nsg9i4ul0e3OPgbOcBhnQdTTp6hRRlO1sUqXxOqRWSG3UqoJFf2f/H3
	dWUBlsPD2RQXJUg4MYAM74VDAz/g
X-Received: by 2002:a5d:64ab:0:b0:385:ed20:3be6 with SMTP id ffacd0b85a97d-3888e0ac6ebmr2695125f8f.22.1734107481384;
        Fri, 13 Dec 2024 08:31:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEVFCmPFbp57wTYLAPbI8HYsB9OAwsvaj5ytvcDH1OeBZBEdtlWfwdOAOyDHVc4IIscc4S02A==
X-Received: by 2002:a5d:64ab:0:b0:385:ed20:3be6 with SMTP id ffacd0b85a97d-3888e0ac6ebmr2695094f8f.22.1734107481057;
        Fri, 13 Dec 2024 08:31:21 -0800 (PST)
Received: from rh (p200300f6af0bca008282df582fad0b68.dip0.t-ipconnect.de. [2003:f6:af0b:ca00:8282:df58:2fad:b68])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38782514db8sm7671875f8f.84.2024.12.13.08.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2024 08:31:20 -0800 (PST)
Date: Fri, 13 Dec 2024 17:31:19 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev, 
    catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
    cohuck@redhat.com, eric.auger@redhat.com, yuzenghui@huawei.com, 
    wangzhou1@hisilicon.com, jiangkunkun@huawei.com, 
    jonathan.cameron@huawei.com, anthony.jebson@huawei.com, 
    linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v3 1/3] arm64: Modify _midr_range() functions to read
 MIDR/REVIDR internally
In-Reply-To: <20241209115311.40496-2-shameerali.kolothum.thodi@huawei.com>
Message-ID: <fa044f16-bfd1-7807-0810-301965e0f60a@redhat.com>
References: <20241209115311.40496-1-shameerali.kolothum.thodi@huawei.com> <20241209115311.40496-2-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: z1WC5YxW0-bma3c_M5j-Xaet6FEF0NPuusb14Tuwjbo_1734107481
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Mon, 9 Dec 2024, Shameer Kolothum wrote:
> These changes lay the groundwork for adding support for guest kernels,
> allowing them to leverage target CPU implementations provided by the
> VMM.
>
> No functional changes intended.
>
> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

