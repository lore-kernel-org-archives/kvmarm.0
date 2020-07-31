Return-Path: <SRS0=F5E6=BK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00202C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 22:55:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 69CC52072A
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 22:55:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="yz3cQ0qa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69CC52072A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAE504B249;
	Fri, 31 Jul 2020 18:55:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5DBeyQ9cXvSm; Fri, 31 Jul 2020 18:55:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7DC64B1CC;
	Fri, 31 Jul 2020 18:55:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAECB4B1BA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 18:55:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8+4s0cGRt4v8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 Jul 2020 18:55:41 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 17CD64B1A4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 18:55:41 -0400 (EDT)
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com
 [209.85.161.53])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 22BB922B42
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 22:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596236139;
 bh=ghMEH1GO6ahQLU9bD4XySRrfpoyCy8rcO1rNgTMBIe0=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=yz3cQ0qaR6fmr9rUc2QwUjqWwf4dAD+TgulADL03tT+NMBexpOC2RJIbGbWX+fQ+u
 yB+SkUcdMatRT38ZNKJPZ4+yUiezlfAxxtk9ZomTpxFoEym1R3cKvVQ8FSEmCAHOxD
 SlYsRj/9yOZMPBasJ/vu2K5676benp0bk69jem2g=
Received: by mail-oo1-f53.google.com with SMTP id z10so3340681ooi.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 15:55:39 -0700 (PDT)
X-Gm-Message-State: AOAM5322mgGPPq3rOHUJiNDfn5XgfMRZowhSScc7hRsRKCKdXGC1/1Nq
 iaYx2whwI5t+x2IM+2LDBlHk+3i9YXPw2T0LYA==
X-Google-Smtp-Source: ABdhPJxlJLtEGIpm/+Zqu84tYvc+2GV7B03TFpdIhESEDSUxef1FFIW4eI6IM8vt5auvi+1oYO79sm4gwMnETv7iLTQ=
X-Received: by 2002:a4a:9c0f:: with SMTP id y15mr5040222ooj.81.1596236138482; 
 Fri, 31 Jul 2020 15:55:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200717205233.903344-1-robh@kernel.org>
 <20200717205233.903344-4-robh@kernel.org>
 <20200729163800.GA24572@gaia> <20200730082227.GA24095@willie-the-truck>
In-Reply-To: <20200730082227.GA24095@willie-the-truck>
From: Rob Herring <robh@kernel.org>
Date: Fri, 31 Jul 2020 16:55:26 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKhytox6+rbZBbkgs2=Zgh3ZtXeYyzjqSWF6Picn-c27A@mail.gmail.com>
Message-ID: <CAL_JsqKhytox6+rbZBbkgs2=Zgh3ZtXeYyzjqSWF6Picn-c27A@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] arm64: Add workaround for Arm Cortex-A77 erratum
 1508412
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
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

On Thu, Jul 30, 2020 at 2:22 AM Will Deacon <will@kernel.org> wrote:
>
> On Wed, Jul 29, 2020 at 05:38:00PM +0100, Catalin Marinas wrote:
> > On Fri, Jul 17, 2020 at 02:52:33PM -0600, Rob Herring wrote:
> > > diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> > > index ce3080834bfa..ce5b0d9b12bf 100644
> > > --- a/arch/arm64/include/asm/kvm_hyp.h
> > > +++ b/arch/arm64/include/asm/kvm_hyp.h
> > > @@ -46,6 +46,17 @@
> > >  #define read_sysreg_el2(r) read_sysreg_elx(r, _EL2, _EL1)
> > >  #define write_sysreg_el2(v,r)      write_sysreg_elx(v, r, _EL2, _EL1)
> > >
> > > +static inline u64 __hyp_text read_sysreg_par(void)
> > > +{
> > > +   u64 par;
> > > +   if (cpus_have_const_cap(ARM64_WORKAROUND_1508412))
> > > +           dmb(sy);
> > > +   par = read_sysreg(par_el1);
> > > +   if (cpus_have_const_cap(ARM64_WORKAROUND_1508412))
> > > +           dmb(sy);
> > > +   return par;
> > > +}
> >
> > Even if that's not always called on a critical path, I agree with Andrew
> > that we could use alternatives here for dmb(sy).
>
> Even then, I'm not sure how this helps if the CPU can speculatively branch
> to the PAR access without executing the DMB. Is that not possible on A77?

I'm told by the h/w folks speculation is not possible in this case.

Rob
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
