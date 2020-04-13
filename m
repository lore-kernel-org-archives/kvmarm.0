Return-Path: <SRS0=hjn/=55=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBBA0C2BA2B
	for <kvmarm@archiver.kernel.org>; Mon, 13 Apr 2020 23:37:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 558242072A
	for <kvmarm@archiver.kernel.org>; Mon, 13 Apr 2020 23:37:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="d9NwDt3I"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 558242072A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B80644B22D;
	Mon, 13 Apr 2020 19:37:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GjJVKmSjkksI; Mon, 13 Apr 2020 19:37:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A55BB4B227;
	Mon, 13 Apr 2020 19:37:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 334684B21A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2020 19:37:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JbPHWsgSitYo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2020 19:37:24 -0400 (EDT)
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com
 [209.85.215.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E661A4B133
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2020 19:37:23 -0400 (EDT)
Received: by mail-pg1-f194.google.com with SMTP id g32so5178458pgb.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2020 16:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=lMPIRjn0PE7jnqkkSuf3FQb+qv7klZT/6x17CMWdL34=;
 b=d9NwDt3IHShJ2ZFMU0WdEcCis4G+93NeL33oosLAJ0QBuuU2m6PWo3KMjSfpLJlU4I
 t06sp32EumYZEhSVDRcWGyPkyeetQP8+MvbdwRXYykzoH3+AITWvVP64YO93bwnOJxLF
 D5KfnhButbLosSN8/qU629tHEf6ViakscnvvxpZ3hhQXplpdLVNheOPeHCaq8xhmjbzn
 s6Z9ObCL9VQ4ioIaVHFzpurAEI0OZDQEdMmeCPFrIo58ZFT/7Xe0wdFRaU5Vdi3dQhlc
 rYQcrSsUKZOdKvzTe+NmJgyRZz7G74rogHaSGx7C4MrN6k8npbyfw+gF6whUx0hQek9X
 eQOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=lMPIRjn0PE7jnqkkSuf3FQb+qv7klZT/6x17CMWdL34=;
 b=HokALX0Hcxw1QLkr10DT3N6GlLHFXikBzZvKmpr0s4BZAUtWH9EPJboDsfSZJSCNFa
 zm+3W/pYBMWMQa8Xob6uC+xLWDEpjrNE6aqqPV1B89dk83q9GRrsz5IdcmiqBkD0+UhO
 644pxQ2xx3rw/q3NWo+u/XkD6Ur4MtWPbvKO7S4pTfcBtFseGRCFDzh0fln2RE4Lowgs
 g2uGATso8ZlI5iib++wjBcjSgKZnqNNdje4lzzhu5BI+CfnegAfAY3//804sCczPHDRb
 e3wucyGBGtu1bswQpXtd9KmVAd7L+kJq4LES28cgO/F+ozdjb4mOBW3TTlzGgmpE6Phz
 d8qw==
X-Gm-Message-State: AGi0PubxmsefMuOn0Mn7L41pbU7cKa4hpwvjgfy6qkEblryKXu31X10W
 dz60g0RG09+bEh6oyTgZJu3AdXJUrnLA+ItA/oZVmw==
X-Google-Smtp-Source: APiQypIIArEcMtBa+6lU3ecAVeDtyJ9+R/7AtvwXV6mkhFTgICAF71cY/Q7KBQ2W2N1aHsHsV6yeVXwI/BROaWewvSM=
X-Received: by 2002:a63:6604:: with SMTP id a4mr18265124pgc.381.1586821042616; 
 Mon, 13 Apr 2020 16:37:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200413231016.250737-1-maskray@google.com>
In-Reply-To: <20200413231016.250737-1-maskray@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 13 Apr 2020 16:37:10 -0700
Message-ID: <CAKwvOdn35v5LkvhWugfLmK_FjVsd0RdPtBCRSqVaM9EP_1KU7w@mail.gmail.com>
Subject: Re: [PATCH] arm64: kvm: Delete duplicated label: in invalid_vector
To: Fangrui Song <maskray@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 LKML <linux-kernel@vger.kernel.org>,
 clang-built-linux <clang-built-linux@googlegroups.com>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Mon, Apr 13, 2020 at 4:10 PM Fangrui Song <maskray@google.com> wrote:
>
> SYM_CODE_START defines \label , so it is redundant to define \label again.
> A redefinition at the same place is accepted by GNU as
> (https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=159fbb6088f17a341bcaaac960623cab881b4981)
> but rejected by the clang integrated assembler.
>
> Fixes: 617a2f392c92 ("arm64: kvm: Annotate assembly using modern annoations")

Thanks for the patch!  I think a more accurate Fixes tag would be:
Fixes: 2b28162cf65a ("arm64: KVM: HYP mode entry points")

With this patch applied, and your other arm64 integrated assembler
patch (https://lore.kernel.org/linux-arm-kernel/20200413033811.75074-1-maskray@google.com/T/#u),
I can now assemble arch/arm64/kvm/.

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>

> Link: https://github.com/ClangBuiltLinux/linux/issues/988
> Signed-off-by: Fangrui Song <maskray@google.com>
> ---
>  arch/arm64/kvm/hyp/hyp-entry.S | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> index c2a13ab3c471..9c5cfb04170e 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -198,7 +198,6 @@ SYM_CODE_END(__hyp_panic)
>  .macro invalid_vector  label, target = __hyp_panic
>         .align  2
>  SYM_CODE_START(\label)
> -\label:
>         b \target
>  SYM_CODE_END(\label)
>  .endm
> --
> 2.26.0.110.g2183baf09c-goog
>


-- 
Thanks,
~Nick Desaulniers
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
