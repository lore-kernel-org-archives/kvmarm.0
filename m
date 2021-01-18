Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F1CBC433E9
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 13:29:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 05CC4221FB
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 13:29:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05CC4221FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51B4B4B29F;
	Mon, 18 Jan 2021 08:29:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nTgTKwnbFovp; Mon, 18 Jan 2021 08:29:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 542774B2A3;
	Mon, 18 Jan 2021 08:29:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ADE44B29D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 08:29:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nHxaiM4pbPq9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2021 08:29:38 -0500 (EST)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com
 [209.85.128.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 15A024B26D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 08:29:38 -0500 (EST)
Received: by mail-wm1-f42.google.com with SMTP id g10so13780472wmh.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 05:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=azSUNypoUfXkpBNPZlINL/zcgEf9pXSAwHyqYLVciok=;
 b=Hdiq7ktUglPw2zVeBs7zzB+XtzIcpfitaPaWUCwOh9Lp9grsNlqjNfLEhWzbdqjyLr
 XwhO7yBQNhaa8PVRuXmwzBb4HoBM0FMU2kRFd1BKaZ4uX5qIute8XLIkw7aleByJtYGf
 BXUpgbwE6/LwYO5XnDY7K5pT8zQ7ng+PiUgi2+ewvj/+yl6NJJxZ448sKc8AC8xmExWX
 iyq8MLnxO818KbMz6m0jlISbSB5HOIgfxzwLAjOrQi8IDKamWFVMBQUCoTXjfam8WtZw
 NpPZUO8H3m3DlxZyqJQvFXYlVIjWbYG5/v1nBe7gt5DE1oDYURdCVacMi3U98mL76gyk
 ElPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=azSUNypoUfXkpBNPZlINL/zcgEf9pXSAwHyqYLVciok=;
 b=HeycWSLr6vB2JX2zSpJK8t+DmIu6HYkaDzZUoobViwR3st6K39tT7Q1dAQkjLFD5xB
 60R8JWTW+o4AwvYzUuIn2CHZnKMs9aHZZ+eHGCyMBTCvrfHSjOZzlrP5qUbJto4Cea2T
 warxasuFN4O4mwdmc/jg9ggWaeR5hIuzX12wPh2u8DfKpWBibMLBEjmBAc0DW+my8XIs
 k6uAqXnzgtzRDMva36X/qq4LlEY6CB4U2KabBWLNjdoZRZP5YMzy37Leo93IqUfFVYGs
 e2KSLwdGrnTxTKjFqr6Lm/vu+m8KFENvB6z2CHMG7ShM8YWOHhognwqjNCkBmftzdkrA
 pb8g==
X-Gm-Message-State: AOAM533sSBJ+3smB47OZWyZRA/gpGsirb93FQ2ZU0BHvE8mi2gnyz9KU
 BZUqVZeJ7Ulnmx6TLS9iCpkrpg==
X-Google-Smtp-Source: ABdhPJwuICFtdmLsGWmzfsOVlfdR9kik5BbE6wWl9u1IG/qQD53UckSQXbc/RrHmiYn+JKe9B1+ugg==
X-Received: by 2002:a1c:40d6:: with SMTP id n205mr21244747wma.0.1610976576985; 
 Mon, 18 Jan 2021 05:29:36 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:3d4d:985d:87b7:4d55])
 by smtp.gmail.com with ESMTPSA id g5sm30955277wro.60.2021.01.18.05.29.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Jan 2021 05:29:36 -0800 (PST)
Date: Mon, 18 Jan 2021 13:29:35 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v4 17/21] KVM: arm64: Document HVC_VHE_RESTART stub
 hypercall
Message-ID: <20210118132935.mutemf7j7wtyz7wz@google.com>
References: <20210118094533.2874082-1-maz@kernel.org>
 <20210118094533.2874082-18-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210118094533.2874082-18-maz@kernel.org>
Cc: kernel-team@android.com, Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, Ajay Patil <pajay@qti.qualcomm.com>,
 Prasad Sodagudi <psodagud@codeaurora.org>, Will Deacon <will@kernel.org>,
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

On Mon, Jan 18, 2021 at 09:45:29AM +0000, Marc Zyngier wrote:
> For completeness, let's document the HVC_VHE_RESTART stub.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: David Brazdil <dbrazdil@google.com>

> ---
>  Documentation/virt/kvm/arm/hyp-abi.rst | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/arm/hyp-abi.rst b/Documentation/virt/kvm/arm/hyp-abi.rst
> index 83cadd8186fa..1ba628baf11b 100644
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
> +  the VHE mode. This is conditioned by the CPU supporting VHE, the EL2 MMU
> +  being off, and VHE not being disabled by any other mean (comment line option,
'means' (both singular and plural), and 'command line'

> +  for example).
> +
>  Any other value of r0/x0 triggers a hypervisor-specific handling,
>  which is not documented here.
>  
> -- 
> 2.29.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
