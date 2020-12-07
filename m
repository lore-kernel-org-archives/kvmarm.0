Return-Path: <SRS0=wPN+=FL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8496DC4361B
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 10:20:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DC79423123
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 10:20:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC79423123
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 412F64B267;
	Mon,  7 Dec 2020 05:20:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g8AHoMqpRZaL; Mon,  7 Dec 2020 05:20:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 338724B276;
	Mon,  7 Dec 2020 05:20:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC8504B275
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 05:20:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hbsYOY-YCnLt for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2020 05:20:10 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B53F94B267
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 05:20:10 -0500 (EST)
Date: Mon, 7 Dec 2020 10:20:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1607336409;
 bh=Li8eED23jwkjCXrIrIn4+IUiJ6tDcvVO2vCH088mQUY=;
 h=From:To:Cc:Subject:References:In-Reply-To:From;
 b=K0FLanr1uDR47XUL7aujD4qaGGbywqubDEU6lzDVlMfvD//mkVCklE2WbkUreeRsF
 ncinZWVrT2AwhNXtAEu7udfm5Ra44P7u6N9cLOu/LTTtGgycvdW1qNx4sraOioIoZa
 Da8B9TcxWiwOV9b6KYOOrEl8DkLL8fOXAlVl3poIBu2FmWmwSifU2/yOUzhHm9V9a5
 IHbrCePeoiha2DCMfA9Y2DmGUWeOiHG51ryLDmLYje36rUYJpCcefNliCtTfAzSYBy
 7wY+z4MDM/D1pz+TTNx8Xpg/glPzWozfh9TkevI0IP/OMkug1QZ34pk3+XhTTjugpZ
 dykDvjQEoh9qQ==
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH 16/27] KVM: arm64: Prepare Hyp memory protection
Message-ID: <20201207102002.GA3825@willie-the-truck>
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-17-qperret@google.com>
 <CA+EHjTyJnZ8e=AN7H_k+oZb0VTWAgMicMY8Rqe2Di_3A87hm0A@mail.gmail.com>
 <X8p5kLSIq2MoQZ24@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <X8p5kLSIq2MoQZ24@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>,
 "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, kernel-team@android.com,
 Android KVM <android-kvm@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
 Fuad Tabba <tabba@google.com>, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

On Fri, Dec 04, 2020 at 06:01:52PM +0000, Quentin Perret wrote:
> On Thursday 03 Dec 2020 at 12:57:33 (+0000), Fuad Tabba wrote:
> <snip>
> > > +int hyp_create_idmap(void);
> > > +int hyp_map_vectors(void);
> > > +int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back);
> > > +int hyp_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
> > > +int hyp_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
> > > +int __hyp_create_mappings(unsigned long start, unsigned long size,
> > > +                         unsigned long phys, unsigned long prot);
> > > +unsigned long __hyp_create_private_mapping(phys_addr_t phys, size_t size,
> > > +                                          unsigned long prot);
> > > +
> > 
> > nit: I also thought that the hyp_create_mappings function names are a
> > bit confusing, since there's the create_hyp_mappings functions which
> > use the aforementioned *hyp_pgtable.
> 
> Sure, happy to re-name those (and hyp_pgtable above). Any suggestions?
> 
> 
> <snip>
> > > +SYM_FUNC_START(__kvm_init_switch_pgd)
> > > +       /* Turn the MMU off */
> > > +       pre_disable_mmu_workaround
> > > +       mrs     x2, sctlr_el2
> > > +       bic     x3, x2, #SCTLR_ELx_M
> > > +       msr     sctlr_el2, x3
> > > +       isb
> > > +
> > > +       tlbi    alle2
> > > +
> > > +       /* Install the new pgtables */
> > > +       ldr     x3, [x0, #NVHE_INIT_PGD_PA]
> > > +       phys_to_ttbr x4, x3
> > > +alternative_if ARM64_HAS_CNP
> > > +       orr     x4, x4, #TTBR_CNP_BIT
> > > +alternative_else_nop_endif
> > > +       msr     ttbr0_el2, x4
> > > +
> > > +       /* Set the new stack pointer */
> > > +       ldr     x0, [x0, #NVHE_INIT_STACK_HYP_VA]
> > > +       mov     sp, x0
> > > +
> > > +       /* And turn the MMU back on! */
> > > +       dsb     nsh
> > > +       isb
> > > +       msr     sctlr_el2, x2
> > > +       isb
> > > +       ret     x1
> > > +SYM_FUNC_END(__kvm_init_switch_pgd)
> > > +
> > 
> > Should the instruction cache be flushed here (ic iallu), to discard
> > speculatively fetched instructions?
> 
> Hmm, Will? Thoughts?

The I-cache is physically tagged, so not sure what invalidation would
achieve here. Fuad -- what do you think could go wrong specifically?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
