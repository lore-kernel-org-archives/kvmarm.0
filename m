Return-Path: <SRS0=qtHs=O2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A3DC4332F
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 09:52:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 899EB61184
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 09:52:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 899EB61184
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD0AC4B261;
	Wed,  6 Oct 2021 05:52:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wMvbecg2eXVA; Wed,  6 Oct 2021 05:52:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2A0E4B29E;
	Wed,  6 Oct 2021 05:52:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ED6B4B267
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 05:52:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eLCDKyBVBYrf for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Oct 2021 05:52:31 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C0524B261
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 05:52:31 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633513951;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=UX+jJIMrW7zppHw65NjBMUn3Ls16NiPQRP3a7uQKNas=;
 b=goxqAZR4OY6ZDDvDFSDJSTeVGGzILL+KCKMkkvp3v2AtBO8M3Tt+z6jY4LqAaSutKN9e/d
 zsH2BUon9rTOGs68xTes5Ua3ecyCqCozHkdS0x1LOFiJy7EC97/4uMKo6PqoUTZFoaszaL
 zfIr9RpqBr9+ZjUHdYS4uTqoqmOTtPM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-zm--IOLJON6uYuV5mHZZAQ-1; Wed, 06 Oct 2021 05:52:30 -0400
X-MC-Unique: zm--IOLJON6uYuV5mHZZAQ-1
Received: by mail-ed1-f71.google.com with SMTP id
 x5-20020a50f185000000b003db0f796903so2085727edl.18
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Oct 2021 02:52:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=UX+jJIMrW7zppHw65NjBMUn3Ls16NiPQRP3a7uQKNas=;
 b=rTH+frv8T0XUHzao3KoN3Ntrc994YW/GBBL+VfTG1WXdQHTK584/E14RI8n3AH6Poh
 1AyS4ky6rx+bISUH7dLim33WkPESh6ebu0BhkEUb6j2QwuYau9M+k4S2Vx5RYLQX3Q2+
 vT2R49poVrgUJSxqdG8McikSsyivXHrRisOkY/eE/KRyaE/va8dPwawlj/WYVuiMmIN2
 DKX1ysPH43Hh7eKPqY5X3tIGte0qbe8+642oh0lvo05oL02Fw0oGdtTCneQC68y7wRdR
 By4QgJzlAEsVfmHUqJaI5bHqdZZy2PjGDAW/+N45/AZXE4YzWgkA97B3lMdHlz4kKC0Z
 4QhQ==
X-Gm-Message-State: AOAM531nK6YXN/VIhM77EXagQRwju+bpOmvNnv7m/WwkL55GOz3/2BiT
 Ciw/cEL2nAzab8oah1Gvc0PbcNha8v5+yeBHb+Cma6xqJlvFav7w8L5MYqMlQBeslIrESNMRXCp
 8aVIAZAn3MKFrYWA1zuOtAIo5
X-Received: by 2002:a50:fc97:: with SMTP id f23mr32904121edq.176.1633513949177; 
 Wed, 06 Oct 2021 02:52:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJym1bd3jelNNspsB1i1kHxfPV+2+86hum/hgtp7xNHYC9ga0Z22asV6hE/ZX0V3bZVSD3yHWg==
X-Received: by 2002:a50:fc97:: with SMTP id f23mr32904087edq.176.1633513948990; 
 Wed, 06 Oct 2021 02:52:28 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id f10sm9966872edu.70.2021.10.06.02.52.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Oct 2021 02:52:28 -0700 (PDT)
Date: Wed, 6 Oct 2021 11:52:26 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v4 08/11] KVM: arm64: selftests: Add some tests for GICv2
 in vgic_init
Message-ID: <20211006095226.ph5g5us7kecsyvqp@gator.home>
References: <20211005011921.437353-1-ricarkol@google.com>
 <20211005011921.437353-9-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20211005011921.437353-9-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: shuah@kernel.org, kvm@vger.kernel.org, maz@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Oct 04, 2021 at 06:19:18PM -0700, Ricardo Koller wrote:
> Add some GICv2 tests: general KVM device tests and DIST/CPUIF overlap
> tests.  Do this by making test_vcpus_then_vgic and test_vgic_then_vcpus
> in vgic_init GIC version agnostic.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 111 +++++++++++++-----
>  1 file changed, 79 insertions(+), 32 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
