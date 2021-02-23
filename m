Return-Path: <SRS0=rfx0=HZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB0CC433E0
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 09:44:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 89C5764E02
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 09:44:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89C5764E02
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D998E4B1C0;
	Tue, 23 Feb 2021 04:44:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G0Fi2ZxQjTgt; Tue, 23 Feb 2021 04:44:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B96E44B1C7;
	Tue, 23 Feb 2021 04:44:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA80D4B1B1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 04:44:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z1ZcYQ4tP4bk for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Feb 2021 04:44:07 -0500 (EST)
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com
 [209.85.166.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 973E04B092
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 04:44:07 -0500 (EST)
Received: by mail-io1-f51.google.com with SMTP id y202so16416076iof.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 01:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=JdsAw7/h4oboN/mNZWenmJqgLQu48+ys8E7jatHzI40=;
 b=puP4kCuFBTo4v5DZgeEJWwQTGfOd7XkA27KZA4hQlu3hZHrqqSMbPiOMp43dA9ZklD
 7/zp1hsnkE/ICFEoYgwACZK8M3iyXtvougYwA2yUfVEduBDH5Pik7MGMloLRaURIuWgI
 boqjpT80BC6CT2uXNTxnnJ1SdnZsn2BXh3v9LutgLhtjEFIYxUoEaTZXh/XBcsugeyJ2
 bbtBDGYcXJvU3Gl37zdWSTfqYGc4saEW5WjRDVooGTgcPY36SXpvsJucUSACU7sZ1lf+
 6OmCKY88AsekH1kCYT6TK47LeRR/OAsfFKpKNrV4SgsT2A52fSNDI43ix3W44/Lk78/T
 UD7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=JdsAw7/h4oboN/mNZWenmJqgLQu48+ys8E7jatHzI40=;
 b=deeXslx7nKHKgray3PHtV5tSn+wULiMB5bdVW+zNDS7SBOTHGE7E+5Z8s0aSAaKi59
 ALjCpfm6JEuhkguvaA1lviRa5LR0lH9SGEhivjayV0aZ0hjZzOO7jENCWfODPPQiaFWs
 jPDfIdne4pzhkvOI6MLRMlTTTl432nl3iODkvbkPZOnUpjlocojodeO7HR3/5SFNENIT
 t9X55kmqkxKZlYML+27v2DsUpCO/q3/LWBeoNvpuiEYLZONclT2r6xr2pHMq0aSjTmcO
 SeyrpW69JbgG2IbtYBPHjFKB4IpNCEjkOTy4hnJSqiVF5fKVW+1KQhvOdNkvEL8ogaHH
 W3kw==
X-Gm-Message-State: AOAM532bHQP31A7OJT9GdeLRejyi3NWJhMnbO0+Q5EoHPj8XGUXeRrzJ
 tvIlP6ssulHFuRY4Ak0qnjfenksyV0RCxEGNb8YE
X-Google-Smtp-Source: ABdhPJxu7RAynJq/1YTWqpI2BlKM2eHwZ1Ujeu1UDzeF/fK9xbZydWwxuIQobx87wJ9t28WDVeFaIgtnt7UTDt91xHA=
X-Received: by 2002:a5e:9612:: with SMTP id a18mr18931244ioq.13.1614073446969; 
 Tue, 23 Feb 2021 01:44:06 -0800 (PST)
MIME-Version: 1.0
References: <20201210160002.1407373-1-maz@kernel.org>
 <CAJc+Z1FQmUFS=5xEG8mPkJCUZ+ecBt4G=YbxGJTO4YFbfGMg3w@mail.gmail.com>
 <CAJc+Z1HE2oFWM8oerrM_3VDNuTOoc3D1Ao7sB2tYj7n6doNBbA@mail.gmail.com>
 <87blcis5ua.wl-maz@kernel.org>
In-Reply-To: <87blcis5ua.wl-maz@kernel.org>
From: Haibo Xu <haibo.xu@linaro.org>
Date: Tue, 23 Feb 2021 17:43:54 +0800
Message-ID: <CAJc+Z1HUeetx=7xm_U5S2Ay9GC5X93S6wh5LshvzKy1ZpVovFw@mail.gmail.com>
Subject: Re: [PATCH v3 00/66] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
To: Marc Zyngier <maz@kernel.org>
Cc: Andre Przywara <andre.przywara@arm.com>, kernel-team@android.com,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm@vger.kernel.org
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

On Thu, 18 Feb 2021 at 06:10, Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 04 Feb 2021 07:51:37 +0000,
> Haibo Xu <haibo.xu@linaro.org> wrote:
> >
> > Kindly ping!
> >
> > On Thu, 21 Jan 2021 at 11:03, Haibo Xu <haibo.xu@linaro.org> wrote:
> > >
> > > Re-send in case the previous email was blocked for the inlined hyper-link.
> > >
> > > Hi Marc,
> > >
> > > I have tried to enable the NV support in Qemu, and now I can
> > > successfully boot a L2 guest
> > > in Qemu KVM mode.
> > >
> > > This patch series looks good from the Qemu side except for two minor
> > > requirements:
> > > (1) Qemu will check whether a feature was supported by the KVM cap
> > > when the user tries to enable it in the command line, so a new
> > > capability was prefered for the NV(KVM_CAP_ARM_NV?).
>
> I have added KVM_CAP_ARM_EL2 (rather than NV) to that effect.
>
> > > (2) According to the Documentation/virt/kvm/api.rst, userspace can
> > > call KVM_ARM_VCPU_INIT multiple times for a given vcpu, but the
> > > kvm_vcpu_init_nested() do have some issue when called multiple
> > > times(please refer to the detailed comments in patch 63)
>
> This is now fixed, I believe.
>
> I have pushed out a branch [1] that addresses all the reported
> issues, though it currently lack some testing. Please let me know if
> it works for you.
>

Hi Marc,

I have verified the fix, and it works well with Qemu.

thanks,
Haibo

> Thanks,
>
>         M.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-5.12-WIP
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
