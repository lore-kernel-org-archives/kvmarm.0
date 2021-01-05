Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2DFAC433E0
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 22:58:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 40BE922E00
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 22:58:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40BE922E00
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90FCA4B29E;
	Tue,  5 Jan 2021 17:58:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eP5h3IUGX-nd; Tue,  5 Jan 2021 17:58:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 913DB4B211;
	Tue,  5 Jan 2021 17:58:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A95B4B211
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 17:58:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XG2gCgh13v7m for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 17:58:14 -0500 (EST)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com
 [209.85.167.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 65F194B209
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 17:58:14 -0500 (EST)
Received: by mail-lf1-f52.google.com with SMTP id b26so2302527lff.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Jan 2021 14:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=V0w3x+GF3kWC39en8rTC64sEYL5cEKVSWAvdiQhAh+g=;
 b=ifbMOMA0QAFavhny0lYXm1SJM8oTqe5kwfdkomkcNtnMRZ7hqpbCYf/BFbqLUGQ/7m
 klL/Jb41VKOYiBD1oCv7ISIneKq2c+hOrhStgQ3EXqIlVVian9q1OV+T9/yJylLQqiwz
 5O+uXYQLa+LJx04q+ggcpvFWgRdW/RvEBhPBe3uC4GSrb6aekmJ9i29ZUI/5wJCgbPE9
 PW6mXK9hm2p4/b9rcPDZNAQBQMgDCVoJl1kYRGhXo228cYUFFhoKYyE7AtwAPIOXpzI2
 jAkrByB8+Xeb8oef1q888uTHrPCb/Zd4TpXO9vilCimB3h4E5VBc/B9R+9kJl4oxGN5w
 UCgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=V0w3x+GF3kWC39en8rTC64sEYL5cEKVSWAvdiQhAh+g=;
 b=dbHD5Xyf4EwXVIzere+IiVHZliiLPIBC30o4ZsaNK8/MHY4DcAwbGykw6wer0x6h80
 vPIMlKyEM28B1zv9rlR/u8HG1mbeDPn7V8DahuFvUOldR/LOY3it2mkILEB1pX6xxUAv
 lXbzM4Flnn/kR00duXTovAaATw2QvvCtFqauT0Ct8U2PnlEd1y1rGBMofI/wMOALcdL/
 ypOueO5ApdyrJLisjjTa6rla7v0096KWj4uE4O0ZFl2uCgaGucFK/mcxGS6doZSL5qfn
 ET2JBE2dv6uriX+XT0mUm4xd3jjGMFtx/FcJI6b+8JYYcloeeLbh/g7DLHjfM6l34cGo
 zA0w==
X-Gm-Message-State: AOAM531tM8GGQ15IAz6kIBl4zAi+Vg0E9WOVgEfjC9du82SsIh3/egnF
 hiaw63baTED8epBZoxEE/7thGjanvfxvS92s+8ZIvg==
X-Google-Smtp-Source: ABdhPJw5+M3swJ5BBVrtWfWGX6IzQ3BoRQHtMVe5KvigCycioLZjq1PTg3GEtv3mz6Qzoka9n5I7+uS7VcJ/nKjt/0w=
X-Received: by 2002:a2e:9ace:: with SMTP id p14mr714976ljj.439.1609887492944; 
 Tue, 05 Jan 2021 14:58:12 -0800 (PST)
MIME-Version: 1.0
References: <20210104135011.2063104-1-maz@kernel.org>
 <20210104135011.2063104-17-maz@kernel.org>
In-Reply-To: <20210104135011.2063104-17-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 5 Jan 2021 16:58:01 -0600
Message-ID: <CAAdAUti35S-1_h=nx+zGGLz7CTxcQghseobUrd7Jc+rY5g58Zg@mail.gmail.com>
Subject: Re: [PATCH v2 16/17] KVM: arm64: Document HVC_VHE_RESTART stub
 hypercall
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>,
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

On Mon, Jan 4, 2021 at 8:20 AM Marc Zyngier <maz@kernel.org> wrote:
>
> For completeness, let's document the HVC_VHE_RESTART stub.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  Documentation/virt/kvm/arm/hyp-abi.rst | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/Documentation/virt/kvm/arm/hyp-abi.rst b/Documentation/virt/kvm/arm/hyp-abi.rst
> index 83cadd8186fa..3961c529769b 100644
> --- a/Documentation/virt/kvm/arm/hyp-abi.rst
> +++ b/Documentation/virt/kvm/arm/hyp-abi.rst
> @@ -58,6 +58,15 @@ these functions (see arch/arm{,64}/include/asm/virt.h):
>    into place (arm64 only), and jump to the restart address while at HYP/EL2.
>    This hypercall is not expected to return to its caller.
>
> +* ::
> +
> +    x0 = HVC_VHE_RESTART (arm64 only)
> +
> +  Attempt to upgrade the kernel's exception level from EL1 to EL2 by enabling
> +  the VHE mode. This is conditionned by the CPU supporting VHE, the EL2 MMU
Typo: conditionned -> conditioned
> +  being off, and VHE not being disabled by any other mean (comment line option,
> +  for example).
> +
>  Any other value of r0/x0 triggers a hypervisor-specific handling,
>  which is not documented here.
>
> --
> 2.29.2
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
