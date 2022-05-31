Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 179F4C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 31 May 2022 16:15:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 800754B41F;
	Tue, 31 May 2022 12:15:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bry9ZDyJuj8R; Tue, 31 May 2022 12:15:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 688894B410;
	Tue, 31 May 2022 12:15:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 419D24B404
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 May 2022 12:15:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w4Bi+aXOeyS7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 May 2022 12:15:16 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 15DE64B382
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 May 2022 12:15:16 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 9243AB81235;
 Tue, 31 May 2022 16:15:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CE2C385A9;
 Tue, 31 May 2022 16:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654013713;
 bh=ztvgCS8fRDKevpyO8kfxRzUmJyQtb9CbHw0LvkPe3z8=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=EwU9SA3Q0QwHRGV/O1ph9cWHDdnUrAclRMUVedLVhrPRlzuhpbrCVpq2LuZWeeajM
 CbM8hAQolPve4NGkntUaQOi4m3C0XGqZyF1+QJH52J90VAn8kbYe7uqgIBbqNnzAVT
 cVNU1lg0Dzj3RFeIahW5Wuc/qvyu3gVX5G9zLRgJd/G4WI3eXAvkP+5NlJgJ0j7D26
 ecPxdX00ITbttgrprGLmTJHKCNnLw818ybiWYvoY00dfyF3KToimQqt9fBE5UMGNm5
 whrex7z71U3f1kuqGbuWyIgu8DOwFZmFKA4W/Tl1LvpKyAGvIsz/J1MtLb2CUSqVKV
 vk732sDM0cgwQ==
Date: Tue, 31 May 2022 17:15:06 +0100
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 03/89] KVM: arm64: Return error from kvm_arch_init_vm()
 on allocation failure
Message-ID: <20220531161505.GD25502@willie-the-truck>
References: <20220519134204.5379-1-will@kernel.org>
 <20220519134204.5379-4-will@kernel.org>
 <Yoe6BxKzJPIaZ+pk@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yoe6BxKzJPIaZ+pk@monolith.localdoman>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, kernel-team@android.com,
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

On Fri, May 20, 2022 at 04:55:51PM +0100, Alexandru Elisei wrote:
> Hi,
> 
> On Thu, May 19, 2022 at 02:40:38PM +0100, Will Deacon wrote:
> > If we fail to allocate the 'supported_cpus' cpumask in kvm_arch_init_vm()
> > then be sure to return -ENOMEM instead of success (0) on the failure
> > path.
> > 
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/kvm/arm.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 523bc934fe2f..775b52871b51 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -146,8 +146,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >  	if (ret)
> >  		goto out_free_stage2_pgd;
> >  
> > -	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL))
> > +	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL)) {
> > +		ret = -ENOMEM;
> >  		goto out_free_stage2_pgd;
> > +	}
> >  	cpumask_copy(kvm->arch.supported_cpus, cpu_possible_mask);
> >  
> >  	kvm_vgic_early_init(kvm);
> 
> Thank you for the fix:
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks!

> This can go in independent of the series. I can send it after rc1 if you
> prefer to focus on something else.

Cheers, but I reckon I'll post the first 6 patches as their own series at
-rc1 anyway.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
