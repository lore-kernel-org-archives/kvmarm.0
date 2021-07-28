Return-Path: <SRS0=xfyP=MU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17187C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 28 Jul 2021 19:02:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7BAF56101B
	for <kvmarm@archiver.kernel.org>; Wed, 28 Jul 2021 19:02:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7BAF56101B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D40D04A51D;
	Wed, 28 Jul 2021 15:02:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Unj3e2KPbVVs; Wed, 28 Jul 2021 15:02:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4AFC4A524;
	Wed, 28 Jul 2021 15:02:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6460D4AEDC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 15:02:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fTmeT-+d0Aa4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jul 2021 15:02:46 -0400 (EDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com
 [209.85.167.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 180BC49D50
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 15:02:46 -0400 (EDT)
Received: by mail-lf1-f50.google.com with SMTP id m13so5841924lfg.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 12:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=WxJfCRcm28Q2mtsiHw3xjSJ0DqRCRRYstcd9Q20/xQQ=;
 b=h1XD5KmacsdUAtbaHNScOkc4DLg84/eQEn/iMfLNe1maR49bt1wCDsB+EWz924QuhM
 yg7UwljEOJ8uTiBJCd5MaKIN9FcLfzEyk4sjhj/afJbP5n1aNqKQTWxRAew7fegon5ju
 yOjQTYyseuc2AAyc8ir3EXAnKfdZBqBPhAlQNqBsKsSXCvlmnd0naeobSxKW9xwxPSpn
 8xwpzF+pzAoouVn63N/KAEyp6KHPP/6HMjX0nwn0QU/VFR1P4dzUdp94aQ22t9qw3dQy
 ssDDge8K9XRwwy2Xqt1I6umnjyXtbdWtSeBwjq49+owOqUN6FnoJ1mwuf6g+iNyuOAAF
 HvGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=WxJfCRcm28Q2mtsiHw3xjSJ0DqRCRRYstcd9Q20/xQQ=;
 b=IhdosB+PDgMnMM+S3aOy0HLsxfAo9ux+RpUHg1Kjv4r/LTytrnrwm9TZCX5rk1zVFZ
 LMA3oepPcU3xC11f6wv/C/+m+hdcoVZSVS54ZstzbuUvy+o2dTcU4p9SJYvhDOBLIyk3
 13gI+Yk/oFQ6QW7YlRC1eOnnRVPwesIbebQK15ToxvmweaxbZM/KNII1eIH2IOkUv2/R
 gRZYFhkTAw7np9CiZzK79B1F/KwlTsiRr3EFc2AF8u4bC0SCBJxmQnpMKqBB3zR2KIe6
 moVp4vFq+UQvGjhwMNTBN/LvZtMrqCPbtPJAmS1kM/n518DKpFXZ/NNtemDMVZGeXG7m
 R/QQ==
X-Gm-Message-State: AOAM533oW/y9wV2fA6Rsx0RfEm7TZEZfFEpwW21vNbJ6noQenK1CwK8A
 Wq5r2YAMK1hdl8W8YTaK1JgzSTk9SPU4yHSPPobImA==
X-Google-Smtp-Source: ABdhPJz1ZBo2qfIXLXj9J9AuWps3bxG9GMcoWTo51fL/O5qgHVUFf00HxQNpDGyfKWNQadpw2tNsh9g2M3liJMGm4iE=
X-Received: by 2002:a05:6512:3b94:: with SMTP id
 g20mr784842lfv.0.1627498964165; 
 Wed, 28 Jul 2021 12:02:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210727103251.16561-1-pbonzini@redhat.com>
In-Reply-To: <20210727103251.16561-1-pbonzini@redhat.com>
From: Oliver Upton <oupton@google.com>
Date: Wed, 28 Jul 2021 12:02:33 -0700
Message-ID: <CAOQ_Qsg+mwmcuht=rQrqNdzaTGKgak0BQwFHzSj=9RZdK9tB5w@mail.gmail.com>
Subject: Re: [PATCH] KVM: ARM: count remote TLB flushes
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
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

On Tue, Jul 27, 2021 at 3:33 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> KVM/ARM has an architecture-specific implementation of
> kvm_flush_remote_tlbs; however, unlike the generic one,
> it does not count the flushes in kvm->stat.remote_tlb_flush,
> so that it inexorably remained stuck to zero.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  arch/arm64/kvm/mmu.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index c10207fed2f3..6cf16b43bfcc 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -81,6 +81,7 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
>  void kvm_flush_remote_tlbs(struct kvm *kvm)
>  {
>         kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
> +       ++kvm->stat.generic.remote_tlb_flush;
>  }
>
>  static bool kvm_is_device_pfn(unsigned long pfn)
> --
> 2.31.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
