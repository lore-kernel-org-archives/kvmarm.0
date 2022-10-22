Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFA17C
	for <kvmarm@lists.linux.dev>; Sat, 22 Oct 2022 07:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666423983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UD1oLm9Hn5bxNzWtEkUvZu/ox9ybbs3hLmz1f3bzisg=;
	b=cppRghMl3bOcK2nQm/xjJ34S2oe58OWr7B6P7/nyUykeZA+rhgkr/crHJ1s80u4BjN6Okg
	DFilhSItTPxdbLzgFdl9zP/FOgT7CvnlyPnAR/cmCs9RTI8+6UxFUGt8GZiyGpuCURJvi7
	xM4cJuRMome/Lj/ngHpsbef+KXLZ7cU=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-210-NF1niRUzND6SvswLUPS_Bw-1; Sat, 22 Oct 2022 03:33:02 -0400
X-MC-Unique: NF1niRUzND6SvswLUPS_Bw-1
Received: by mail-ua1-f70.google.com with SMTP id h11-20020ab0470b000000b003bf1da44886so2932743uac.17
        for <kvmarm@lists.linux.dev>; Sat, 22 Oct 2022 00:33:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UD1oLm9Hn5bxNzWtEkUvZu/ox9ybbs3hLmz1f3bzisg=;
        b=1dzgscV7U8wcVTmo5CuGcry2KTBwk3Ew20q8bMUVBvIJTvfDBJnUpdMxVSxIJp4Hgq
         SOZJ8INgr3mO2p744ZArxDuEihDT7mn+dEXmpJvWtHuLFTBlSxSD6upuEmlpgHVCKZfg
         mETmc/C2GKoLZF4vYsM6v8zycZge1LsZgw1BwznuDrv1LK/iP+rVE/+uRKAT4/o2mgcl
         hZ9FzFx8MMMoHGDECVVjjxpZic1luhloX11ZBy9o0RVFxTbGJ2AUYVhXM/IgIFz2MQLC
         piQo/t5/ked0yOmfXxV7TFk9gjSGf6XeT5QBzgvc0ukEoKOgGaqjRzdAHkC4KwrUDFLw
         bGYQ==
X-Gm-Message-State: ACrzQf1mjG4FoapXly+BJ6t1qr720LsZDRNUrxfT9iP/mjTwJfiUlnL0
	7nHan+8pZ7uofQpuWENz/UTnKRUh4DjRrplb6xRxxiZAL/Rft3ls5rTuvhj8kLdb1Usie6dKV+E
	C3CN9lYwVDdi7SRLLJa7X87zA8zqredUi
X-Received: by 2002:a05:6102:290f:b0:3a9:58e4:21e4 with SMTP id cz15-20020a056102290f00b003a958e421e4mr15185759vsb.16.1666423982082;
        Sat, 22 Oct 2022 00:33:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7n2r61OPuivZoFkcwGIIhNnUj6Oumoro17gWYamx6wmsyOrWyfDfcB7j2agdpVk+jXKxHd35lMn+Edv5flcH8=
X-Received: by 2002:a05:6102:290f:b0:3a9:58e4:21e4 with SMTP id
 cz15-20020a056102290f00b003a958e421e4mr15185746vsb.16.1666423981772; Sat, 22
 Oct 2022 00:33:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221013132830.1304947-1-maz@kernel.org>
In-Reply-To: <20221013132830.1304947-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 22 Oct 2022 09:32:50 +0200
Message-ID: <CABgObfaPLnwLVL3_QYwPw2ToaBJ331ihuSHqo2bqzr-mEauw5Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.1, take #1
To: Marc Zyngier <maz@kernel.org>
Cc: Gavin Shan <gshan@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Quentin Perret <qperret@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221022073250.BqO6_Kx6nTqRsByCSmj2W1XW8tLwLuluG4AN1Fgzhys@z>

On Thu, Oct 13, 2022 at 3:28 PM Marc Zyngier <maz@kernel.org> wrote:
> Paolo,
>
> Here's the first set of fixes for 6.1. The most interesting bit is
> Oliver's fix limiting the S2 invalidation batch size the the largest
> block mapping, solving (at least for now) the RCU stall problems we
> have been seeing for a while. We may have to find another solution
> when (and if) we decide to allow 4TB mapping at S2...
>
> The rest is a set of minor selftest fixes as well as enabling stack
> protection and profiling in the VHE code.
>
> Please pull,

Done, thanks.

Paolo

