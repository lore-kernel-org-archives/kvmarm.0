Return-Path: <SRS0=poro=PD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45061C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 09:49:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B1A3160241
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 09:49:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B1A3160241
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 213484B17B;
	Fri, 15 Oct 2021 05:49:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O7GI9EtEhhqI; Fri, 15 Oct 2021 05:49:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 213D04B17D;
	Fri, 15 Oct 2021 05:49:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6976C4B134
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 05:49:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bemifLwON1P8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Oct 2021 05:49:06 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 685BE4B0E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 05:49:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1634291346;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=TSbEB3BwDLmVM1HNWqG2yqBKy93uV1whZ1iCqAbBG74=;
 b=HpvHZkPjdaosInKeC4A0s4kyY5dkUsxTYMHg1yAFeZl9u6U5S0ojThgeDa/C8jcudXvNpf
 ltkfbRZA0jFx5t/ihUJNutPE2sWRl68kud46CpfTs+901Ij5ZgyEfimcHizgw9LL7O9+5T
 GMfJGCBu9xqcdfRjDdMs5N/oGLI4jBs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-r_G_tQohOuCiFi3xIDuOdw-1; Fri, 15 Oct 2021 05:49:03 -0400
X-MC-Unique: r_G_tQohOuCiFi3xIDuOdw-1
Received: by mail-wr1-f69.google.com with SMTP id
 s18-20020adfbc12000000b00160b2d4d5ebso5776442wrg.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 02:49:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=TSbEB3BwDLmVM1HNWqG2yqBKy93uV1whZ1iCqAbBG74=;
 b=z8yUmyKjOoz78XV4DMTjv3fCWGGXICeOBx57QvX8KayTRxdtBMD+WJ2+KfZ5GAxv5M
 Y+aPqWY9U9PEBg54kYkPezDBPzTJJyng/M7gFmF7nZGDvkAV4h8QCgfaj+rL+r1Q0ZPY
 hDcxbrMre5/ov+tB+vhOab5aFbZEbLdRLac//ZNou0O5PP/NbfayKz5ADQdwu/f00j++
 o7asQyHFnRu4IACWFh45MGmJwEev885DwOTQMQeaZ9NP0kRg48n43mafZkGRMRz69F7C
 uftq5IKrrsYqpdA1HqBc+DmAcbcJOdPClbQfs50d+5vr2BzmAbuCqrgIQIjNkx7rxxeQ
 D7xg==
X-Gm-Message-State: AOAM531Tc+qfffTjL8tkxi/g5/DOTrduLk9+p0V+MKOpdBV0cesbcYaS
 u8KFDgj+Yms9qSnWZRBtQwpnLwQUS0VhxBiRUboCpVPDi9L7Y5EZ7aGpwSsqAtEGfWkEVe1nRc3
 nLA15vEeoGLpLpnBiL8lWE4Ci
X-Received: by 2002:a05:600c:19cd:: with SMTP id
 u13mr24821929wmq.148.1634291342645; 
 Fri, 15 Oct 2021 02:49:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/ogUflpwRDRS8wet8Xt6zPTdVYv1xkvcDCuaGAdghDK+81/p8M1BGu38LZ6JUi9aJYEj8Iw==
X-Received: by 2002:a05:600c:19cd:: with SMTP id
 u13mr24821913wmq.148.1634291342470; 
 Fri, 15 Oct 2021 02:49:02 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id a127sm9710231wme.40.2021.10.15.02.49.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 15 Oct 2021 02:49:02 -0700 (PDT)
Date: Fri, 15 Oct 2021 11:49:00 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 0/5] KVM: arm64: Reorganise vcpu first run
Message-ID: <20211015094900.pl2gyysitpnszojy@gator>
References: <20211015090822.2994920-1-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211015090822.2994920-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

On Fri, Oct 15, 2021 at 10:08:17AM +0100, Marc Zyngier wrote:
> KVM/arm64 relies heavily on a bunch of things to be done on the first
> run of the vcpu. We also do a bunch of things on PID change. It turns
> out that these two things are pretty similar (the first PID change is
> also the first run).
> 
> This small series aims at simplifying all that, and to get rid of the
> vcpu->arch.has_run_once state.
> 
> Marc Zyngier (5):
>   KVM: arm64: Move SVE state mapping at HYP to finalize-time
>   KVM: arm64: Move kvm_arch_vcpu_run_pid_change() out of line
>   KVM: arm64: Merge kvm_arch_vcpu_run_pid_change() and
>     kvm_vcpu_first_run_init()
>   KVM: arm64: Restructure the point where has_run_once is advertised

Maybe do the restructuring before the merging in order to avoid the
potential for bizarre states?

>   KVM: arm64: Drop vcpu->arch.has_run_once for vcpu->pid
> 
>  arch/arm64/include/asm/kvm_host.h | 12 +++------
>  arch/arm64/kvm/arm.c              | 43 ++++++++++++++++++-------------
>  arch/arm64/kvm/fpsimd.c           | 11 --------
>  arch/arm64/kvm/reset.c            | 11 +++++++-
>  arch/arm64/kvm/vgic/vgic-init.c   |  2 +-
>  5 files changed, 39 insertions(+), 40 deletions(-)
> 
> -- 
> 2.30.2
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>

For the series

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
