Return-Path: <SRS0=3CJn=MP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A97C4338F
	for <kvmarm@archiver.kernel.org>; Fri, 23 Jul 2021 08:08:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 047EF60F02
	for <kvmarm@archiver.kernel.org>; Fri, 23 Jul 2021 08:08:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 047EF60F02
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 616444B16A;
	Fri, 23 Jul 2021 04:08:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TvzXuP6lTX4v; Fri, 23 Jul 2021 04:08:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 56DBD4B126;
	Fri, 23 Jul 2021 04:08:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B2134A523
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jul 2021 15:34:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uTGd-XowUj8j for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Jul 2021 15:34:01 -0400 (EDT)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com
 [209.85.128.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 63A3240808
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jul 2021 15:34:01 -0400 (EDT)
Received: by mail-wm1-f42.google.com with SMTP id
 o5-20020a1c4d050000b02901fc3a62af78so2190636wmh.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jul 2021 12:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=jhYsOx1LWs0cX/jFmHSeQJdM5hC2M39ceQWiy7371d4=;
 b=KTUsRkXf4ffoeh8ZbMqm31lud2SqLwVvOFo7Cl2jnZ4J7pYL55bBrPIbwLHe7pbaIo
 QmdCWIukoUmVQDGqMENWtc6ektd6uNOD0Zx6uv2T51mssBNN+QkOjO2Kf02iUMGrSdFP
 rvHBMP34dGJ4DxuBpgwrmtNKsX0N6bwKa8S1iKjblT/SMsr/37cPbcPC5Qq4d2kyughj
 NRfdclkQgGSeOoeH2m4zQvPUyHu5Ljw7VTnHtEDlEu1QZCJVkS6wsAYhqdUjNad07ELy
 SvHcE1/bVW4/ZNw9ppykjxm++rFPjlt4PDvgUvZj5IpOG2vzz13X2TOIiU7OhY6ONeY1
 Cvmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=jhYsOx1LWs0cX/jFmHSeQJdM5hC2M39ceQWiy7371d4=;
 b=eXt7diJxM2rGcsHkg4ZZndc13UxTDY6B5tYsTmnqko25ENTi18M3UvCTJpNUloN6Mo
 +uGCP0hgX5gemhJX2qQQewbKSa1hFpRXrHDYNLwIXH50ScjUazztztuwci+a21jMj8qv
 DCSu6IV2dwu+sKM6XdzXOzMcI6409UrXrFmsV1B61Ef+c90zdzhljsZZrHEls7r62ONO
 3evrYuaGcQkisxePEIVSv3NT9ks7dnDP5oSHqQcED+tFJxHa3yukqPThlUa81Luh4UaC
 GqRi6jWOGC6uS4REiKhNGiZgsUy9kjVU2ptA1ryZhj7bDGOANfmLGMH/51QRYrOROQ/u
 7l0w==
X-Gm-Message-State: AOAM532ifAvdwnE+9tUNPGzLES/6FxuWhcuKyx9eMDUzMh++SyFgMQ14
 rWIOvoosE4ZJYbPW/n4xVID0bw==
X-Google-Smtp-Source: ABdhPJzAV0SGTymmduCOhJtF1fux4J5JcXs5+NUVNCIiqHcjF/y0IV5ZQ7B4UnjMDgV+7PIFPHmd6A==
X-Received: by 2002:a7b:c351:: with SMTP id l17mr1121772wmj.120.1626982440145; 
 Thu, 22 Jul 2021 12:34:00 -0700 (PDT)
Received: from elver.google.com ([2a00:79e0:15:13:f1d2:f5fd:de90:c735])
 by smtp.gmail.com with ESMTPSA id t6sm31102302wru.75.2021.07.22.12.33.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Jul 2021 12:33:59 -0700 (PDT)
Date: Thu, 22 Jul 2021 21:33:52 +0200
From: Marco Elver <elver@google.com>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v2 3/3] kvm/arm: Align the VMID allocation with the arm64
 ASID one
Message-ID: <YPnIIAARHNhx9npt@elver.google.com>
References: <20210616155606.2806-1-shameerali.kolothum.thodi@huawei.com>
 <20210616155606.2806-4-shameerali.kolothum.thodi@huawei.com>
 <20210721163138.GD11003@willie-the-truck>
 <f7d708704fb84380af85298a98f7a48c@huawei.com>
 <YPk2XqrOeP6dEtPL@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YPk2XqrOeP6dEtPL@google.com>
User-Agent: Mutt/2.0.5 (2021-01-21)
X-Mailman-Approved-At: Fri, 23 Jul 2021 04:08:00 -0400
Cc: "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Linuxarm <linuxarm@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

On Thu, Jul 22, 2021 at 10:11AM +0100, Quentin Perret wrote:
> On Thursday 22 Jul 2021 at 06:45:14 (+0000), Shameerali Kolothum Thodi wrote:
> > > From: Will Deacon [mailto:will@kernel.org]
> > > > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > > index 4b60c0056c04..a02c4877a055 100644
> > > > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > > @@ -106,8 +106,7 @@ int kvm_host_prepare_stage2(void *mem_pgt_pool,
> > > void *dev_pgt_pool)
> > > >  	mmu->pgd_phys = __hyp_pa(host_kvm.pgt.pgd);
> > > >  	mmu->arch = &host_kvm.arch;
> > > >  	mmu->pgt = &host_kvm.pgt;
> > > > -	mmu->vmid.vmid_gen = 0;
> > > > -	mmu->vmid.vmid = 0;
> > > > +	atomic64_set(&mmu->vmid.id, 0);
> > > 
> > > I think this is the first atomic64 use in the EL2 object, which may pull in
> > > some fatal KCSAN instrumentation. Quentin, have you run into this before?
> > > 
> > > Might be simple just to zero-initialise mmu for now, if it isn't already.
> > 
> > I will check that.
> 
> Yes I think what saves us here is that, AFAICT. arm64 doesn't support
> KCSAN yet. But the day it does, this should fail to link (hopefully)
> because of out-of-line calls into e.g. __kasan_check_write().
> 
> So yes, a simple zeroing here is probably preferable.

Note: Do not worry about hypothetically breaking with sanitizers here --
whether it's KASAN or KCSAN, they both instrument atomics. In files that
enable instrumentation but the atomic instrumentation should not be
pulled in, use the arch_ variants, but this doesn't apply here because
instrumentation shouldn't even be on.

The indicator that when KCSAN is supported on arm64, the Makefile here
just needs KCSAN_SANITIZE := n, is that all other instrumentation is
also killed entirely:

  $ grep -E "(PROFILE|SANITIZE|INSTRUMENT)" arch/arm64/kvm/hyp/nvhe/Makefile
  GCOV_PROFILE	:= n
  KASAN_SANITIZE	:= n
  UBSAN_SANITIZE	:= n
  KCOV_INSTRUMENT	:= n

KCSAN isn't supported on arm64 yet, and when it does, I believe Mark's
arm64 KCSAN series should take care of things like this.

Thanks,
-- Marco
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
