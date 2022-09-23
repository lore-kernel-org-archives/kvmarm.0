Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED3C6C6FA82
	for <kvmarm@archiver.kernel.org>; Fri, 23 Sep 2022 14:22:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BC2A40B6C;
	Fri, 23 Sep 2022 10:22:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fH8c0jZtyKf0; Fri, 23 Sep 2022 10:22:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19F2040C52;
	Fri, 23 Sep 2022 10:22:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68C8440BFA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2022 10:22:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mMCbH8S93FT4 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Sep 2022 10:22:34 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 391B440B6C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2022 10:22:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1663942953;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=xJ7NvBNqMyAjonIBYUaUOjGEw+4M/heegLtpVu08Dzc=;
 b=NbqgqTIp3LmZT3Mpiu6v5zqj4wmzEj5j3XrX+oa8x1CKCqfV1RCzxZRLHQzD3PIkdrzuAi
 uuliMBnszLbMsfHCEFp7n2s8Ox+LkBs7qtvYpE2b5mXPQI4dBglSrsMKFzzD6W+meypSJv
 1QG/Si3EPCeeeHebD9eLoXfBmezyNTw=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-605-YNnLfLHwMLimVFz4g6axxQ-1; Fri, 23 Sep 2022 10:22:32 -0400
X-MC-Unique: YNnLfLHwMLimVFz4g6axxQ-1
Received: by mail-qk1-f200.google.com with SMTP id
 f12-20020a05620a408c00b006ced53b80e5so108024qko.17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2022 07:22:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=xJ7NvBNqMyAjonIBYUaUOjGEw+4M/heegLtpVu08Dzc=;
 b=rrYgaJOaEQVM/Uf770WuHA+Vyg4aiXwRiG+fDllbm9gHJXZp8qdPu76h+Gxh/q1gRG
 ggln8KWCqW2vjH2e2oOj6xixPIFPR3CIC0pr9P1jC4koN4OS2Oc4kVllebx9IYNOxiFf
 ECw8pQvoOT4fTB52vios9Urhvr6i1a6NLPKlutkJ4/0UlovDUuWfrBBPTAvXHoQDnzU9
 MRuPZDxmUEaqrHy7FokAudaqIeVFc/URdQrkbFUcCoDvK9oNNTI+519WcVAnU1eO4NmM
 0sOg7POPcvtcrP/EbJBVITFWkl1CMuJUct8dLOVvVsaMZqEwcpsv6IDZxv+JBVuNa4N9
 Qc2A==
X-Gm-Message-State: ACrzQf1X8WGFywivVeNKcmpSfQCFE1p8sngdnbsD7QHZ0SHZBe2o0uRz
 OrsTJy0fqkhEtCMEIT2ma/XgKjyAkIxCGwVLl8vTM3xJeWym+ZxmFTjYDgW1X1U738WMdYhcrih
 qCV7QhYK4Kdq3YZfKTLIlh+0AbwG9yKOFOLwYROQr
X-Received: by 2002:a05:622a:138c:b0:35c:e9d2:8d76 with SMTP id
 o12-20020a05622a138c00b0035ce9d28d76mr7419967qtk.463.1663942952210; 
 Fri, 23 Sep 2022 07:22:32 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5U63XjjsWCKo/SDdgvyLMGUUVGC9LLE0uEX7Hqm+64kfM+1tiDckgPMyWf276UjUFrP0+Pcg+GxDuU1uEhlYw=
X-Received: by 2002:a05:622a:138c:b0:35c:e9d2:8d76 with SMTP id
 o12-20020a05622a138c00b0035ce9d28d76mr7419940qtk.463.1663942951968; Fri, 23
 Sep 2022 07:22:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220922170133.2617189-1-maz@kernel.org>
 <20220922170133.2617189-2-maz@kernel.org>
 <YyzV2Q/PZHPFMD6y@xz-m1.local> <87edw2jhpv.wl-maz@kernel.org>
In-Reply-To: <87edw2jhpv.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 23 Sep 2022 16:22:20 +0200
Message-ID: <CABgObfbRb_rPNqL+=yPVWc7e8a7uumATR6cEEdvYrkEKUS1_2A@mail.gmail.com>
Subject: Re: [PATCH 1/6] KVM: Use acquire/release semantics when accessing
 dirty ring GFN state
To: Marc Zyngier <maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 will@kernel.org, shan.gavin@gmail.com, bgardon@google.com, dmatlack@google.com,
 zhenyzha@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Fri, Sep 23, 2022 at 4:20 PM Marc Zyngier <maz@kernel.org> wrote:
> > > This is only a partial fix as the userspace side also need upgrading.
> >
> > Paolo has one fix 4802bf910e ("KVM: dirty ring: add missing memory
> > barrier", 2022-09-01) which has already landed.
>
> What is this commit? It doesn't exist in the kernel as far as I can see.

That's the load_acquire in QEMU, and the store_release part is in 7.2
as well (commit 52281c6d11, "KVM: use store-release to mark dirty
pages as harvested", 2022-09-18).

So all that QEMU is missing is the new capability.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
