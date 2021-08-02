Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F69C4320E
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 13:11:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4D29F60F6D
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 13:11:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4D29F60F6D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEC0B4A4A4;
	Mon,  2 Aug 2021 09:11:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CVcmcWRHlk8v; Mon,  2 Aug 2021 09:11:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CC5C4A17F;
	Mon,  2 Aug 2021 09:11:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA7CB40CF8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 09:11:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zVed6b0S9Nms for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 09:11:13 -0400 (EDT)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
 [209.85.128.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E522140856
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 09:11:12 -0400 (EDT)
Received: by mail-wm1-f47.google.com with SMTP id n11so10392440wmd.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Aug 2021 06:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Y+0uaIcI0mf0ejSXXUrubCKbBMCdNsNKojVgct2vGJc=;
 b=byi63PIOkTLrQ3+UVW6t6Nu8bIplNFnTeI8Al2gNkJj/Ntg9CXWWhVqe2Y6WGtrj74
 Zjt2WO0HgkRiXwOm2DP9hu5N+igm0XJwOM52BYAcf2rTDeYhwNOpAT80bBzwkuNlw0dm
 VwiIz+l+w/zRklTygHBpoulOMIPVMDfUD2wl7HDy0F8hEmdzlUAabcdkOEehUB45MTrP
 iEAc+DG+MTBDD483So934wmNTSUVZGKVPgVT/s6va8wV/Zs5HrZZgKxu9QiqSis3XAft
 IqltpSp2l22oHBbjTLkroYFTLhjkAbn+h2gWjiHlqsk28mNjMjLuKEC+rcuSrSrOKtn/
 UPbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Y+0uaIcI0mf0ejSXXUrubCKbBMCdNsNKojVgct2vGJc=;
 b=Oa3AwzqDfb3fvK/pN1njZrz6hLDKTW8KLFkK51Xl6F3pyJRSJMgtbLsRBDEvEVKnsQ
 ZIxiFys+K3dw+Y4EVkKKaHdT83EkhrULiKlyg/QF7EiTi8DF74Feb0Q+isKm4Y2V+clA
 GREcWVfZXT3LnIYr4IZ1GKzhqH610/5yfasoGETxGZxEs2HFl7qyaaQOBz3D0PwOx0e8
 +GZKiZVl6ydIyTDF28QZ/5BpzPQS5Za4oKSF8efIlw/014/ldeKspNBs/DBP9cctobFJ
 IWgaX53HI4dnt35e4aia7CqX6Bw9g9T+v3UwASSpCiMnQJhFTPX94QnQl0u4cggo1/FD
 PCtQ==
X-Gm-Message-State: AOAM531idxpNpyiVm7wKfnQ4gtT8qlTZkHppZBOZ4sm7GnWb9EaEgl9N
 5QI+61nYXeKywGt6fS1SN63YnA==
X-Google-Smtp-Source: ABdhPJy6LhSB+zaOl8biQZCLEmpra28+MUW1EPrRJ99jo7BMsfeo2ldRPESQWWEITnMPTAsaU2dASA==
X-Received: by 2002:a1c:4409:: with SMTP id r9mr16799679wma.150.1627909870168; 
 Mon, 02 Aug 2021 06:11:10 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:44fe:c9a8:c2b2:3798])
 by smtp.gmail.com with ESMTPSA id d5sm11047663wre.77.2021.08.02.06.11.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 02 Aug 2021 06:11:09 -0700 (PDT)
Date: Mon, 2 Aug 2021 14:11:07 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 1/2] arm64: Move .hyp.rodata outside of the
 _sdata.._edata range
Message-ID: <YQfu6+3uo6qlxrpv@google.com>
References: <20210802123830.2195174-1-maz@kernel.org>
 <20210802123830.2195174-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210802123830.2195174-2-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Marc,

On Monday 02 Aug 2021 at 13:38:29 (+0100), Marc Zyngier wrote:
> The HYP rodata section is currently lumped together with the BSS,
> which isn't exactly what is expected (it gets registered with
> kmemleak, for example).
> 
> Move it away so that it is actually marked RO. As an added
> benefit, it isn't registered with kmemleak anymore.

2d7bf218ca73 ("KVM: arm64: Add .hyp.data..ro_after_init ELF section")
states explicitly that the hyp ro_after_init section should remain RW in
the host as it is expected to modify it before initializing EL2. But I
can't seem to trigger anything with this patch applied, so I'll look
into this a bit more.

> Fixes: 380e18ade4a5 ("KVM: arm64: Introduce a BSS section for use at Hyp")

Not sure this is the patch to blame?

> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org #5.13
> ---
>  arch/arm64/kernel/vmlinux.lds.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> index 709d2c433c5e..f6b1a88245db 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -181,6 +181,8 @@ SECTIONS
>  	/* everything from this point to __init_begin will be marked RO NX */
>  	RO_DATA(PAGE_SIZE)
>  
> +	HYPERVISOR_DATA_SECTIONS
> +
>  	idmap_pg_dir = .;
>  	. += IDMAP_DIR_SIZE;
>  	idmap_pg_end = .;
> @@ -260,8 +262,6 @@ SECTIONS
>  	_sdata = .;
>  	RW_DATA(L1_CACHE_BYTES, PAGE_SIZE, THREAD_ALIGN)
>  
> -	HYPERVISOR_DATA_SECTIONS
> -
>  	/*
>  	 * Data written with the MMU off but read with the MMU on requires
>  	 * cache lines to be invalidated, discarding up to a Cache Writeback
> -- 
> 2.30.2

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
