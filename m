Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA66C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 17:03:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A22164DE0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 17:03:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A22164DE0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E38524B3FF;
	Mon, 15 Mar 2021 13:03:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YRssiZcRG3MZ; Mon, 15 Mar 2021 13:03:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 003164B3CE;
	Mon, 15 Mar 2021 13:03:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C1D44B3CE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 13:03:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mcs0FV69t3eZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 13:03:17 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6CFB44B2F3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 13:03:17 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F83764D9A;
 Mon, 15 Mar 2021 17:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615827796;
 bh=mQMzN2WAIpvMXAy9wRcyfDHn8betfQjTx6sPWE5hfOY=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=OauwNRykO0ltPWn1LrX9v3BP/5+tkjyQSzPhZ5T4OCEZvlIqijFKy/3lKoBsmOF2U
 rl0izM5DcoKA893WVk1Iu9srMke7oltRYGYKPo/dzCewyArFSbMlT5rtxXUfoBvEgK
 1cu83oCMRijYcrO3tEv50MnKxkwfJDIzQQZ2D1K+vQoIQWujzpFcCbfoQl94BLW3/V
 Zewyd9EV+odYwtSeUOaqiWSO3WSe8qYjnajRMlPwxTAzT+iHmAIqccNDNLtulypqZ9
 wbzy/dqMJvcG/f1pcie66L/IV8n+sGowT4+xQbk6fwHRs1zPVlF1fvjtXSr+xBwD7y
 NAfPddGD3+6Dg==
Date: Mon, 15 Mar 2021 17:03:10 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v5 14/36] KVM: arm64: Provide __flush_dcache_area at EL2
Message-ID: <20210315170310.GI3430@willie-the-truck>
References: <20210315143536.214621-1-qperret@google.com>
 <20210315143536.214621-15-qperret@google.com>
 <20210315163322.GE3430@willie-the-truck>
 <YE+RtegUL4ki2qa/@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YE+RtegUL4ki2qa/@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Mon, Mar 15, 2021 at 04:56:21PM +0000, Quentin Perret wrote:
> On Monday 15 Mar 2021 at 16:33:23 (+0000), Will Deacon wrote:
> > On Mon, Mar 15, 2021 at 02:35:14PM +0000, Quentin Perret wrote:
> > > We will need to do cache maintenance at EL2 soon, so compile a copy of
> > > __flush_dcache_area at EL2, and provide a copy of arm64_ftr_reg_ctrel0
> > > as it is needed by the read_ctr macro.
> > > 
> > > Signed-off-by: Quentin Perret <qperret@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_cpufeature.h |  2 ++
> > >  arch/arm64/kvm/hyp/nvhe/Makefile        |  3 ++-
> > >  arch/arm64/kvm/hyp/nvhe/cache.S         | 13 +++++++++++++
> > >  arch/arm64/kvm/sys_regs.c               |  1 +
> > >  4 files changed, 18 insertions(+), 1 deletion(-)
> > >  create mode 100644 arch/arm64/kvm/hyp/nvhe/cache.S
> > > 
> > > diff --git a/arch/arm64/include/asm/kvm_cpufeature.h b/arch/arm64/include/asm/kvm_cpufeature.h
> > > index 3fd9f60d2180..efba1b89b8a4 100644
> > > --- a/arch/arm64/include/asm/kvm_cpufeature.h
> > > +++ b/arch/arm64/include/asm/kvm_cpufeature.h
> > > @@ -13,3 +13,5 @@
> > >  #define KVM_HYP_CPU_FTR_REG(name) extern struct arm64_ftr_reg kvm_nvhe_sym(name)
> > >  #endif
> > >  #endif
> > > +
> > > +KVM_HYP_CPU_FTR_REG(arm64_ftr_reg_ctrel0);
> > 
> > I still think this is a bit weird. If you really want to macro-ise stuff,
> > then why not follow the sort of thing we do for e.g. per-cpu variables and
> > have separate DECLARE_HYP_CPU_FTR_REG and DEFINE_HYP_CPU_FTR_REG macros.
> > 
> > That way kvm_cpufeature.h can have header guards like a normal header and
> > we can drop the '#ifndef KVM_HYP_CPU_FTR_REG' altogether. I don't think
> > the duplication of the symbol name really matters -- it should fail at
> > build time if something is missing.
> 
> I just tend to hate unnecessary boilerplate, but if you feel strongly
> about it, happy to change :)

I don't like it either, but I prefer it to overriding macros like this! I
think having the "boilerplate" is a better starting point should we decide
to consolidate the definitions somehow.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
