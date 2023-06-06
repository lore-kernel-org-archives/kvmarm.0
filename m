Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685A337B71
	for <kvmarm@lists.linux.dev>; Tue,  6 Jun 2023 14:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686061462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uyYUHdEGxl6Tc6JNqsaX5GWtexeV/uCDlYU9H9btqlo=;
	b=DxE9j0k/+GlWdDKAmCT/fxTrotP0rZ7OmgSgRnz9ivfGwKK6lU6slHUlK8S2YQemSgO0xk
	emVTGqjOI2EBk27DPn3d6uoU8PXQNA//B2EEwSLbgZqnasAKNtSYsa2vTI82D4UoprroHS
	33g+J8cfJ4e+sO68Vmu13RJuS18pGYk=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-OxoTfF24Mw2Fh-E2cSnhKw-1; Tue, 06 Jun 2023 10:24:19 -0400
X-MC-Unique: OxoTfF24Mw2Fh-E2cSnhKw-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-616731c798dso51671636d6.1
        for <kvmarm@lists.linux.dev>; Tue, 06 Jun 2023 07:24:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686061459; x=1688653459;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uyYUHdEGxl6Tc6JNqsaX5GWtexeV/uCDlYU9H9btqlo=;
        b=OEqcawV8zzamCmYXrQzp03xJClgKshx6k2wGbXZYWxVT3QungWH75FWohY3m9cki0T
         bLrnkBIWv8pFe9ZiTAIXVpFT33e7xiAOMHO+v6xeLfsTONsK0dRtke3Efu53hlzkQiWU
         o3YadS/IvO0nCmjfIrnFSrgIZgNI4L+uEzrqU1KbXsCnSDexXTNccZRVHKsjthNeUE00
         D/aFOJufv74hFe9vMrLVMy9+4jPfmeeODAjBf74QqK4AvJX896J43ROsIKKK68f57gsj
         XRIsmaiPxtK/Pz9yxyvCmbxRykrbIRxb/2yJ2YmCsmBIg82kK/iiOcJ8/nSh1L9YAwjX
         XDvA==
X-Gm-Message-State: AC+VfDwnD/5dYCUuXPieAFgBj18eCCW8kImGuDfgotb7m4019ZaC697N
	nfc8O8+NlrdN00jxVTOdNIX/XjVyTilsLGoauQkEYbwhdTHNZ4nrR+0FYSKBL5Wgnax9Dj10K/Q
	jbN0HcJDQukAYQJGE
X-Received: by 2002:a05:6214:622:b0:5f1:6a6a:f566 with SMTP id a2-20020a056214062200b005f16a6af566mr11497780qvx.19.1686061459544;
        Tue, 06 Jun 2023 07:24:19 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6QlmZ/u2ursJTvMQe0Ih1zztdLYF2L83thMnJjoAxEKAzxwRy27LF6DruCp7yoWEfEBU4IQw==
X-Received: by 2002:a05:6214:622:b0:5f1:6a6a:f566 with SMTP id a2-20020a056214062200b005f16a6af566mr11497762qvx.19.1686061459341;
        Tue, 06 Jun 2023 07:24:19 -0700 (PDT)
Received: from rh (p200300c93f2d6400aa29c1eaa0912abc.dip0.t-ipconnect.de. [2003:c9:3f2d:6400:aa29:c1ea:a091:2abc])
        by smtp.gmail.com with ESMTPSA id l16-20020ad44250000000b00626286e41ccsm5404728qvq.77.2023.06.06.07.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 07:24:19 -0700 (PDT)
Date: Tue, 6 Jun 2023 16:24:15 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
    Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix smp_processor_id() call in preemptible
 context
In-Reply-To: <ZH8+ZG7DOX9TYcIY@linux.dev>
Message-ID: <db6a7329-d8fa-5e5b-b271-2f89c25236d1@redhat.com>
References: <2f16f83e-ed60-fcb7-7f3d-0fa216c41cb9@redhat.com> <ZH8+ZG7DOX9TYcIY@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Tue, 6 Jun 2023, Oliver Upton wrote:
> The call from a preemptible context is intentional, so this really
> should just be raw_smp_processor_id(). Do you mind if we fix it with the
> following?

Works for me.

Thanks,
Sebastian

