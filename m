Return-Path: <SRS0=p2dm=M2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA08C432BE
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 10:51:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C194E61037
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 10:51:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C194E61037
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4332D4086F;
	Tue,  3 Aug 2021 06:51:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id um19RNuCmtw7; Tue,  3 Aug 2021 06:51:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 394AE40874;
	Tue,  3 Aug 2021 06:51:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A41D40623
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 06:51:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hf-AoCv-9sC0 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Aug 2021 06:51:52 -0400 (EDT)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com
 [209.85.210.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E85E4086F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 06:51:52 -0400 (EDT)
Received: by mail-ot1-f51.google.com with SMTP id
 c2-20020a0568303482b029048bcf4c6bd9so20274638otu.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Aug 2021 03:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=WUxc5MB+Tq9hVrzE0x/FFFlgnTm10UXPxyV+GzRqkrU=;
 b=vEGntt1HAENdzj7VnMWn1fUB6jPHul3UT5wMP8S8Tb6a+ytZly9lG4RVFX/gfhuAng
 ARWKq53znmro8GS9NNAmLHkaTgkUuO8k85Ag/VbXZ5iKHpWVFt8fNh0VsYs8yV+MajiF
 uZjAnHsvi4AAm23IdbL96IZgZiQD6pEwQL4Fn3RgacC2PeQSLzbsDE8Q62jSHkvDXiBa
 FfSlcBIYI0w7/26HnO32BO3oEaMEXEQ4mxW+EibsRnAW7vinAxjvGtG+i2uYkASGVUTK
 fxG1ViAkBlY5o5sKtV7ntAKMPOsk0mJ/HbArVU1/HIgiDGYHsGaQwGWoHDIH3gxp9o20
 SUHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=WUxc5MB+Tq9hVrzE0x/FFFlgnTm10UXPxyV+GzRqkrU=;
 b=JUjnAKQwJPJ/AH308GuwnGZMrKOb3aYj7EnrqJhuzYlR3HrmM6NFdqXi3iPDmKYlyb
 T4h6zsDEykBPXFPg6fBkuL2fxNybPqHvP/axCZPZVWFGpSRmMCIHv+37yADqKn8dXrOT
 LUGH6knNObEm/I+D6qybAwNRzg8+HcVXImqGzYxox8UmXfwKCT4/8peMYKniTq76yfKr
 fpOwnJk5k/JdvrSeQAjs+pldp5pN4v72Ln2tyj88KgD4sqwpxCQH3KVx4hTgxFE+7Zfq
 0juDr37MBRxUFim44hN87YqDaeTTYQi6cwoQA2m121Ctgkfu2MXl19fI4r+sZ4mLfBTY
 8p7w==
X-Gm-Message-State: AOAM530x5FJtN++YwkwfiESDuuOeM6zckb0KN1vjVxyEBe+0SqdBpfU0
 hbG/WXyrktjb4bO4ik0z0o3ipvPdFQjkN9r3P+U0rg==
X-Google-Smtp-Source: ABdhPJxvZT6TZfQaKjA6ySTyD8WZ6X/uh3f6kHY+xaZ5tPnSjzoDuCwt+rtQflv2skumMaQuDNbtoJ1oPtX8ZEwIuV4=
X-Received: by 2002:a9d:202d:: with SMTP id n42mr1249812ota.52.1627987911567; 
 Tue, 03 Aug 2021 03:51:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
 <20210729132818.4091769-20-qperret@google.com>
 <CA+EHjTwWt+jvRZsk5KEhQWzn+XqdV2gZSq7oCuOCVXRa1=JiWw@mail.gmail.com>
 <YQkcUXnrqp7hsZZT@google.com>
In-Reply-To: <YQkcUXnrqp7hsZZT@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 3 Aug 2021 12:51:14 +0200
Message-ID: <CA+EHjTye7hA7XqGSx5DvqXAcVaA9HYkC-rqeQ5fnQY7MdpHkFw@mail.gmail.com>
Subject: Re: [PATCH v3 19/21] KVM: arm64: Refactor protected nVHE stage-1
 locking
To: Quentin Perret <qperret@google.com>
Cc: kernel-team@android.com, qwandor@google.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
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

Hi Quentin,

> > > +int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
> > > +{
> > > +       int ret;
> > > +
> > > +       hyp_spin_lock(&pkvm_pgd_lock);
> > > +       ret = pkvm_create_mappings_locked(from, to, prot);
> > > +       hyp_spin_unlock(&pkvm_pgd_lock);
> > > +
> > > +       return ret;
> > > +}
> > > +
> >
> > I'm wondering whether this patch should also refactor
> > __pkvm_create_mappings. It doesn't quite do the exact same thing and
> > has different parameters.
>
> Sorry, not sure I'm understanding your suggestion here. What do you
> think should be done to __pkvm_create_mappings?

Sorry, my comment wasn't very clear, and "refactor" is the wrong word.
I think it should probably be renamed, because __pkvm_create_mappings
isn't called by pkvm_create_mappings nor by
pkvm_create_mappings_locked. It also has different parameters and
behaves slightly differently.

Thanks,
/fuad

> Cheers,
> Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
