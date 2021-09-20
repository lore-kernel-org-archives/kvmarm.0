Return-Path: <SRS0=SY58=OK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A5FDC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 20 Sep 2021 14:09:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BFE606109E
	for <kvmarm@archiver.kernel.org>; Mon, 20 Sep 2021 14:09:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BFE606109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49DFA40413;
	Mon, 20 Sep 2021 10:09:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZtjGFdE5tMpE; Mon, 20 Sep 2021 10:09:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 357F84B0B8;
	Mon, 20 Sep 2021 10:09:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14FC340413
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 10:09:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fg3Ccsdf6Jnl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Sep 2021 10:09:32 -0400 (EDT)
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com
 [209.85.161.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20D90402C0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 10:09:32 -0400 (EDT)
Received: by mail-oo1-f48.google.com with SMTP id
 u15-20020a4a970f000000b0029aed4b0e4eso3920537ooi.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 07:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=qzAdTsGqrarKrbZiLgQ+yqd08O5g2KPS2fQJ1adRAbE=;
 b=Lc5yTDdu4Z3ESLWgSn8P+Yyo1JXoXNnAwo7xIH57GWzVa7TVzjcFv4yNw2009ZQ5Zi
 qPA1ibsjJp5bIhAVuwjxCm+Io/CPD9HVF9biAgL65DiCGnM2XTe164wB+IYCSfsDWDMk
 DcyLd1ntMHf4fpszz2py6D2mpdB1vdmF37E/L3X8eMeFn/pBrbTbOe1RIETYK3xbIFzX
 ghTEMZjdySpQv9CTWdSzOTNizZM8UNm5hpPfuLRX0Wz6WSkFn4Mm2smHwmgdc90PHDvv
 j/GV4JfTTPPhj2rff2ZLrbFlVqSC4hudG78SAJBcHQvskuD3oP2bzCfDPf76nCRDOp+I
 W1cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=qzAdTsGqrarKrbZiLgQ+yqd08O5g2KPS2fQJ1adRAbE=;
 b=7PWKQ2+01kDbRCztso2UfIvHioFMJyNhSjDce2cO8b1wZlMiBRLT4RpQSXNTw82bUu
 TKEoJeL8NXJrBhGjJO1LlwsBjekKq81Mdhi7NBWzFd5B2hW2ru6vSEynbgS6SzLCULif
 iDnyakBc3yPn40PlomhvVlyog1hMASA/eamwXwDqDAwA8AA3VbxZKAp7RksW6mEQS8nu
 w9bdEQB89TAcK8WOAq1wwliAVCYCcaNnNwYsQ+k5rZPTcil0ijVyWM0EpXggG2u9jMJX
 /+jrM3OZ0mwMa7ypV6jSdOjL+L6UdGVTYI55ieDB7hl1vJm/krMChjIc5PKdJq8lmdRk
 dS5g==
X-Gm-Message-State: AOAM533v3iURAcHMQ1fqB20FlRc8Sl69ORVEjOgIhHA30WE9ow59CTR5
 CLK8wXofLJhx66vMFB22FlIMkVSvI1vXBFbo481HJw==
X-Google-Smtp-Source: ABdhPJzcGkhhRgG63cEAKiVJaDA4QJ+7e3xmIVMV1M65aTlgH1dCw2yj+iWheoNkqPW9cH7sK0KJqPYXfV3EypeyiR4=
X-Received: by 2002:a4a:b6c2:: with SMTP id w2mr17432044ooo.59.1632146971367; 
 Mon, 20 Sep 2021 07:09:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210827101609.2808181-1-tabba@google.com>
 <20210827101609.2808181-2-tabba@google.com>
 <87pmt3v15x.wl-maz@kernel.org>
In-Reply-To: <87pmt3v15x.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 20 Sep 2021 15:08:54 +0100
Message-ID: <CA+EHjTx3_rdfGn6d079ZG2W48eibknHiQyBZSCNyb9ukqHS63A@mail.gmail.com>
Subject: Re: [PATCH v5 1/8] KVM: arm64: Pass struct kvm to per-EC handlers
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, pbonzini@redhat.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > index 0397606c0951..7cbff0ee59a5 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -163,7 +163,7 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
> >   * If FP/SIMD is not implemented, handle the trap and inject an undefined
> >   * instruction exception to the guest. Similarly for trapped SVE accesses.
> >   */
> > -static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
> > +static inline bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
>
> No, please don't do that. We already have function pointers for each
> of these, so by doing that you are forcing the compiler to emit the
> code *twice*.
>
> Instead, call into the relevant EC handler by using the base array
> that already does the non-protected handling.
>
...
> > -static const exit_handler_fn *kvm_get_exit_handler_array(void);
> > +const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm);
>
> Why? What breaks if when this is static? There really shouldn't be
> anything else referencing this array.

For the two points above, the reason I did that is because later
patches call these functions from the newly added
arch/arm64/kvm/hyp/nvhe/sys_regs.c. That said, I think that the code
that calls them more naturally belongs in
arch/arm64/kvm/hyp/nvhe/switch.c instead.

I'll fix that, rebase on 5.15-rc2, and respin.

Thanks,
/fuad


> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
