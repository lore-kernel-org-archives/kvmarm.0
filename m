Return-Path: <SRS0=ioR1=HG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55127C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 14:37:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CBE1364F4D
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 14:37:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CBE1364F4D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 581A84B1C1;
	Thu,  4 Feb 2021 09:37:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MLjRanU-uiLY; Thu,  4 Feb 2021 09:37:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EAD34B1D0;
	Thu,  4 Feb 2021 09:37:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 641AB4B1A9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 09:37:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Aua0Pe6RupMm for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 09:37:33 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 580924B175
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 09:37:33 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96D7A64F42;
 Thu,  4 Feb 2021 14:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1612449452;
 bh=eX/1xnMdBH58oq4Cm//d2eH7lZEj/ruuIIGGb0auhuU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=lFUg2MhCGRwGCnWckleg2a585Xz+UPVroJoNasl+l4uT0swGpvGoFDX9tZU3lQU8T
 /yrQSfPWtuDwynUHzXjcNMRmcL3Hpe9GUojzRx7oLBzcEMnuf5Fugs46AmSYNirHm0
 GOMjZtv2zt6lmt5JUCXfTx3Ou8ZLooidFTn5ePcH+jLvp6JlcZ/wq3kED3EeiOTmV8
 JEyrlU6Zy1/rze1wxKk2PST5LR1xrcY/gBK6mtU2kGkZssp+m9Yz6Ihgp+3PZWtUtX
 O386OeZwIL5OOsEzKkiZf9BK0SHUN10bysPQh3rGOM9NhwGiYRKNzb5RJWkLPFQzp3
 CLQa41rKVOCfA==
Date: Thu, 4 Feb 2021 14:37:26 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH v2 26/26] KVM: arm64: Wrap the host with a stage 2
Message-ID: <20210204143725.GB20815@willie-the-truck>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-27-qperret@google.com>
 <20210203161146.GJ18974@willie-the-truck>
 <YBwEGx1tv8hob9ho@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YBwEGx1tv8hob9ho@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: devicetree@vger.kernel.org, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, Feb 04, 2021 at 02:26:35PM +0000, Quentin Perret wrote:
> On Wednesday 03 Feb 2021 at 16:11:47 (+0000), Will Deacon wrote:
> > On Fri, Jan 08, 2021 at 12:15:24PM +0000, Quentin Perret wrote:
> > > When KVM runs in protected nVHE mode, make use of a stage 2 page-table
> > > to give the hypervisor some control over the host memory accesses. At
> > > the moment all memory aborts from the host will be instantly idmapped
> > > RWX at stage 2 in a lazy fashion. Later patches will make use of that
> > > infrastructure to implement access control restrictions to e.g. protect
> > > guest memory from the host.
> > > 
> > > Signed-off-by: Quentin Perret <qperret@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_cpufeature.h       |   2 +
> > >  arch/arm64/kernel/image-vars.h                |   3 +
> > >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  33 +++
> > >  arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
> > >  arch/arm64/kvm/hyp/nvhe/hyp-init.S            |   1 +
> > >  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   6 +
> > >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 191 ++++++++++++++++++
> > >  arch/arm64/kvm/hyp/nvhe/setup.c               |   6 +
> > >  arch/arm64/kvm/hyp/nvhe/switch.c              |   7 +-
> > >  arch/arm64/kvm/hyp/nvhe/tlb.c                 |   4 +-
> > >  10 files changed, 248 insertions(+), 7 deletions(-)
> > >  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > >  create mode 100644 arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > 
> > [...]
> > 
> > > +void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
> > > +{
> > > +	enum kvm_pgtable_prot prot;
> > > +	u64 far, hpfar, esr, ipa;
> > > +	int ret;
> > > +
> > > +	esr = read_sysreg_el2(SYS_ESR);
> > > +	if (!__get_fault_info(esr, &far, &hpfar))
> > > +		hyp_panic();
> > > +
> > > +	prot = KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W | KVM_PGTABLE_PROT_X;
> > > +	ipa = (hpfar & HPFAR_MASK) << 8;
> > > +	ret = host_stage2_map(ipa, PAGE_SIZE, prot);
> > 
> > Can we try to put down a block mapping if the whole thing falls within
> > memory?
> 
> Yes we can! And in fact we can do that outside of memory too. It's
> queued for v3 already, so stay tuned ... :)

Awesome! The Stage-2 TLB thanks you.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
