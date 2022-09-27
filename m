Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90DA1C07E9D
	for <kvmarm@archiver.kernel.org>; Tue, 27 Sep 2022 15:54:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB0B04B4D7;
	Tue, 27 Sep 2022 11:54:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PTF84V44b6dx; Tue, 27 Sep 2022 11:54:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B23644B63E;
	Tue, 27 Sep 2022 11:54:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E92714B4D7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 11:54:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dchUeMFcDmbd for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2022 11:54:39 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AF2E4B293
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 11:54:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1664294079;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Ig6ff3s+qaz6qZ/eoAJt38MgXkJ4N1+o+oKgI8RLbn8=;
 b=euHfhu+Dneap86UW+R0mT2hzM2wYY0QZNTfsPuEK1l1JtznoJgA0GX8bSVc5BVgjvZaDzY
 PoWG3rI3QptVoycgkUO7a5HGm7zeFRhF1gPeBO0Pg8TztNOPBytaAVJW3MaM9WMmLo1nNJ
 /DChPWWdz0sjLEhnkzNRtiqmkw4Z9B4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-537-8FTpF2TANhGSiS59ASbzUQ-1; Tue, 27 Sep 2022 11:54:38 -0400
X-MC-Unique: 8FTpF2TANhGSiS59ASbzUQ-1
Received: by mail-qk1-f197.google.com with SMTP id
 bl17-20020a05620a1a9100b006cdf19243acso7576639qkb.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 08:54:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=Ig6ff3s+qaz6qZ/eoAJt38MgXkJ4N1+o+oKgI8RLbn8=;
 b=fxJJqJ6T+gc72DnBETLO4I/h3EEeOgMNrzhwYP5/dOeCQkDw7lid8bV3bKAgc3WKUD
 WItCJ/qGZUSl0yYrFpfQnDMxgw2zm1jzgWQYC0q19dRNKqD1icCFTjPMrl35IGmIkX0G
 ZrTANpdZzpJXqR9OevkVAzrqiIqLXJzoGYA87t9URCd7uJ0xnzgiYLXSI6GGjTY1BxA9
 1vdtJUZA/dymNo6XDv4aMsUSTnkKCleEgUJIJrx9n12rVuGJ/UEP63kyjEiYfBtCrl23
 koqd50zOXYpb3NVsOnopKP2LVZM4a0e2wPQ3usPo2OljRKUxS3L607owDZAwK/eSpy3L
 oL7w==
X-Gm-Message-State: ACrzQf3KVEnXqmiUdIS0GQLBeAE6SxZ6n7FPCE5TfQchcz9NopEOEm4D
 3PjoCNB2bx0cKFz51PzFPUh1lj4PNq+DrYRifgeOk+5MyBRsUNf1Vw7Wuqfd1yFwvCD7At6nXbR
 yk+G5LBt7JHTSqXD1me0uytP7
X-Received: by 2002:ae9:ed86:0:b0:6cd:f5da:f133 with SMTP id
 c128-20020ae9ed86000000b006cdf5daf133mr18620933qkg.782.1664294077623; 
 Tue, 27 Sep 2022 08:54:37 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4xjk4/ceelvrxyUiJwWpr9g1wDD/8LYUgh2WXS4MZCJiGO8aqkBSJFdDz61sp/yQclkvpxug==
X-Received: by 2002:ae9:ed86:0:b0:6cd:f5da:f133 with SMTP id
 c128-20020ae9ed86000000b006cdf5daf133mr18620900qkg.782.1664294077304; 
 Tue, 27 Sep 2022 08:54:37 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 j4-20020a05620a410400b006cf7ecee246sm1226956qko.9.2022.09.27.08.54.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 27 Sep 2022 08:54:36 -0700 (PDT)
Date: Tue, 27 Sep 2022 11:54:32 -0400
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 0/6] KVM: Fix dirty-ring ordering on weakly ordered
 architectures
Message-ID: <YzMcuGnQGvpMy1km@x1n>
References: <20220926145120.27974-1-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20220926145120.27974-1-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 will@kernel.org, shan.gavin@gmail.com, bgardon@google.com, dmatlack@google.com,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

On Mon, Sep 26, 2022 at 03:51:14PM +0100, Marc Zyngier wrote:
> [Same distribution list as Gavin's dirty-ring on arm64 series]
> 
> This is an update on the initial series posted as [0].
> 
> As Gavin started posting patches enabling the dirty-ring infrastructure
> on arm64 [1], it quickly became apparent that the API was never intended
> to work on relaxed memory ordering architectures (owing to its x86
> origins).
> 
> This series tries to retrofit some ordering into the existing API by:
> 
> - relying on acquire/release semantics which are the default on x86,
>   but need to be explicit on arm64
> 
> - adding a new capability that indicate which flavor is supported, either
>   with explicit ordering (arm64) or both implicit and explicit (x86),
>   as suggested by Paolo at KVM Forum
> 
> - documenting the requirements for this new capability on weakly ordered
>   architectures
> 
> - updating the selftests to do the right thing
> 
> Ideally, this series should be a prefix of Gavin's, plus a small change
> to his series:
> 
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 0309b2d0f2da..7785379c5048 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -32,7 +32,7 @@ menuconfig KVM
>  	select KVM_VFIO
>  	select HAVE_KVM_EVENTFD
>  	select HAVE_KVM_IRQFD
> -	select HAVE_KVM_DIRTY_RING
> +	select HAVE_KVM_DIRTY_RING_ACQ_REL
>  	select HAVE_KVM_MSI
>  	select HAVE_KVM_IRQCHIP
>  	select HAVE_KVM_IRQ_ROUTING
> 
> This has been very lightly tested on an arm64 box with Gavin's v3 [2] series.
> 
> * From v1:
>   - Repainted the config symbols and new capability so that their
>     naming is more acceptable and causes less churn
>   - Fixed a couple of blunders as pointed out by Peter and Paolo
>   - Updated the documentation
> 
> [0] https://lore.kernel.org/r/20220922170133.2617189-1-maz@kernel.org
> [1] https://lore.kernel.org/lkml/YyiV%2Fl7O23aw5aaO@xz-m1.local/T/
> [2] https://lore.kernel.org/r/20220922003214.276736-1-gshan@redhat.com
> 
> Marc Zyngier (6):
>   KVM: Use acquire/release semantics when accessing dirty ring GFN state
>   KVM: Add KVM_CAP_DIRTY_LOG_RING_ACQ_REL capability and config option
>   KVM: x86: Select CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL
>   KVM: Document weakly ordered architecture requirements for dirty ring
>   KVM: selftests: dirty-log: Upgrade flag accesses to acquire/release
>     semantics
>   KVM: selftests: dirty-log: Use KVM_CAP_DIRTY_LOG_RING_ACQ_REL if
>     available

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks!

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
