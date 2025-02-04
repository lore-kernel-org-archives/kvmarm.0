Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE2F28399
	for <kvmarm@lists.linux.dev>; Tue,  4 Feb 2025 16:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738687545; cv=none; b=Ti5QRMWStnTi2l7TjvNGCZyR1aAb2n+esG8Z8QCxG0om9EM3sGxaMKUcv7x9tBNc+7wcJCHG1V836U5NSzlwopeoWbchGFkNjMb7p7pjLZEwzwT2ztJOXAc6vbHzlJaEnq5zn6FyCK2UqF+p/cu8hIYlKQfjME2bKXMGjk3eiOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738687545; c=relaxed/simple;
	bh=MBCA0PjVurUxDHTE8tDaUdxdvdUZXPx5WXbFW3jRA9c=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=uFb6nDwtVaK23pjwIdwaxWytMf7bES1L0BIvVJTHApEWk1cromm5n4byDLQtReK9lILPNgeBfajfrsmoaizWeBD+Puc33XJoYToZbkHfDe6uvyXav0bopD++UxJ7cW/Rpc7EQPFelUDJDfBJGsWnGsHsZ1jdcqakJhVEBzja3UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XEmDbxCx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XEmDbxCx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738687542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MBCA0PjVurUxDHTE8tDaUdxdvdUZXPx5WXbFW3jRA9c=;
	b=XEmDbxCxpzV1BcL1O5+kpilomcS1XkhO9PKj4dqPM7NJyyjDyFD/MpI6B2dKSEQCrJ4fvx
	WwzclmZox4PIEwlZb5XGkAKxLodJM36/5cpEzPV2lzEhsL91cGfp+8EkX7kA0G4IBTEEMR
	S6twuj647irwy0q+LRsyBAKlp2/Gs8s=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-oFJJxWfVNM26mKxEQGVy7Q-1; Tue, 04 Feb 2025 11:45:41 -0500
X-MC-Unique: oFJJxWfVNM26mKxEQGVy7Q-1
X-Mimecast-MFC-AGG-ID: oFJJxWfVNM26mKxEQGVy7Q
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-38dabace77aso262323f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Feb 2025 08:45:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738687540; x=1739292340;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MBCA0PjVurUxDHTE8tDaUdxdvdUZXPx5WXbFW3jRA9c=;
        b=uiPX5rp8MU3CjAhEwUY9hxA2Y9iTA5l/dbBh7rH2YG+Sk/+Zlao+rD8JCWCb2PhbI+
         jmyHRoqOhwviPrl+vltlpumsMoI5RitKG0ovn0nv7mGM3MzSkmjlCzalI5+5hIesI70T
         iXIe1v99JXiL1IySxTUfyuvP2d/YcYL0n0jViT8A6R42fIG2cDrSESGSm6bxLMykBiJN
         EhkhOrmE3eRtQii+p9S9b8neWCqK4jrpdFmeGENwYwhteb4Wz6BfmT8os4hFbvyHbAqU
         56H1hxsHvOxAuVlnPXL4bIgyJE9GTabzQIR/7kY/M5RwfMPbCQYtIwHG2E7ckAXEhnoa
         Hc9g==
X-Gm-Message-State: AOJu0Yy+pI71LjL8zeCmkBk+nQrZqz413DglwtYo1T9gep5/Iqnkaymq
	fWkY8DA0d6C1mEEEYffQsPS9eBozhIvxxEtDXALyaNwKpvvhyQYIo21AtGqakv1Atth5wzL2A2E
	zLtyTavRcNSZG828euC7uFTNW6xdkfZb1vm1xNIltkJfYgFZV3/ZOdhtW6XZH+g==
X-Gm-Gg: ASbGncvUo+NXZ/HMJD+bDXwPKMiDskXYgblHVDYEoFLATvOWO9WgNUK25/oxjp6Qblo
	Fk1uPFJwNYbpluGrRKKCpG7zbv5aJrSzzR9qs7QyrV0AV7fn9TFr3iHSIcXEnDSKwp/Y384SGWQ
	E+6/5VApnWN/vRkvLF8wXUkbfLQ+tUFjAkm4B7QXRHtFQtVJKCBTD7XNCT0Or5wUtxMQwqOutzA
	mJ7IKZs+cODwM2jComf/PbaDIbE1lLzGlKfPir5ZFJKtOpc0JzlhxqN8qvK2rarutrApoqtUo+I
	GgO3FTBeoELWhOTtu30QGOlm1J750bPokGqPV5fKqOhiD5ktzEuwgA==
X-Received: by 2002:a5d:5f44:0:b0:385:e411:c894 with SMTP id ffacd0b85a97d-38c520938eemr25194915f8f.43.1738687539953;
        Tue, 04 Feb 2025 08:45:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE4pBkOX7fbB5E+46TakvY1pNF/mGFNJ7jtM/9pTutWHDSdXh7u0KEbKJApI78TVZPUVk1B6Q==
X-Received: by 2002:a5d:5f44:0:b0:385:e411:c894 with SMTP id ffacd0b85a97d-38c520938eemr25194886f8f.43.1738687539533;
        Tue, 04 Feb 2025 08:45:39 -0800 (PST)
Received: from rh (p200300f6af0e4d00dda53016e366575f.dip0.t-ipconnect.de. [2003:f6:af0e:4d00:dda5:3016:e366:575f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4390692a4bdsm18504135e9.0.2025.02.04.08.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 08:45:39 -0800 (PST)
Date: Tue, 4 Feb 2025 17:45:38 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev, 
    catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
    Cornelia Huck <cohuck@redhat.com>, eric.auger@redhat.com, 
    yuzenghui@huawei.com, wangzhou1@hisilicon.com, jiangkunkun@huawei.com, 
    jonathan.cameron@huawei.com, anthony.jebson@huawei.com, 
    linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v5 0/4] KVM: arm64: Errata management for VM Live
 migration
In-Reply-To: <20250124151732.6072-1-shameerali.kolothum.thodi@huawei.com>
Message-ID: <76172c57-aac6-d540-5b98-8de100c0886c@redhat.com>
References: <20250124151732.6072-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oGhKi067mzGYe6lYZHlgQQ1nLPlG6n7UkggPeeWPvOg_1738687541
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hey,

On Fri, 24 Jan 2025, Shameer Kolothum wrote:
> On ARM64 platforms most of the errata workarounds are based on CPU
> MIDR/REVIDR values and a number of these workarounds need to be
> implemented by the Guest kernel as well. This creates a problem when
> Guest needs to be migrated to a platform that differs in these
> MIDR/REVIDR values even if the VMM can come up with a common minimum
> feature list for the Guest using the recently introduced "Writable
> ID registers" support.

Currently MIDR/REVIDR are still RO and guest access is not trapped - so
even with the errata management patches in place the guest state would
change and a migration (between hosts that differ in these regs) would
not be possible. Are there any plans to allow to actually change these?

Thanks,
Sebastian

