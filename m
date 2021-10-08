Return-Path: <SRS0=WrEh=O4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 577FFC433EF
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 07:27:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B6E2760F5D
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 07:27:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B6E2760F5D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CF3C4B172;
	Fri,  8 Oct 2021 03:27:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o+f1o1OEQhyH; Fri,  8 Oct 2021 03:27:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE8124B165;
	Fri,  8 Oct 2021 03:27:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2755F4B15C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 03:27:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g0xN8Y35I1Qr for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 03:27:30 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EEC414B162
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 03:27:29 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id F396360F46;
 Fri,  8 Oct 2021 07:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1633678047;
 bh=wFDMjD/zd8ON6fg3+aCqoqK0a82kKiqeikhfq4OqnQk=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=flojFq8QH7AiubGrNWOPyVJhPSr4kjFVTNree8hHOhVVOy8WAnv8sassASFMcolFh
 omoCLXZ+nFwf1cexBvg8e3yC0fDOPjKAUGk0y2hyZfxjEqwXoc5d86NcMFFKTHu0WS
 P1Ez3ogAn9i8qADA1P9UV4KIAXiJ0E6NOt5IDw58/ux2V9QymY6IXfu9JGhy/dFGgI
 0N/Q813Wi/6ezlgbTPzzfim7jT+MAOgz6co8D40CxfI0xZFW6a7/tgAqeUeIAYt9gJ
 MDxe+cwYPNDdJ8gL/87eKBn1/fsUj/CUsUZZTJ6cqbCTEgdO4W49nv0bk0mrbSpg2o
 jlIyOAmPGNIXg==
Date: Fri, 8 Oct 2021 08:27:22 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: arm64: Disable privileged hypercalls after
 pKVM finalisation
Message-ID: <20211008072722.GA32625@willie-the-truck>
References: <20211005113721.29441-1-will@kernel.org>
 <20211005113721.29441-6-will@kernel.org>
 <877depq9gw.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <877depq9gw.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Oct 07, 2021 at 01:56:47PM +0100, Marc Zyngier wrote:
> On Tue, 05 Oct 2021 12:37:21 +0100,
> Will Deacon <will@kernel.org> wrote:
> > 
> > After pKVM has been 'finalised' using the __pkvm_prot_finalize hypercall,
> > the calling CPU will have a Stage-2 translation enabled to prevent access
> > to memory pages owned by EL2.
> > 
> > Although this forms a significant part of the process to deprivilege the
> > host kernel, we also need to ensure that the hypercall interface is
> > reduced so that the EL2 code cannot, for example, be re-initialised using
> > a new set of vectors.
> > 
> > Re-order the hypercalls so that only a suffix remains available after
> > finalisation of pKVM.
> > 
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Quentin Perret <qperret@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h   | 43 ++++++++++++++++--------------
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 37 +++++++++++++++++--------
> >  2 files changed, 49 insertions(+), 31 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index e86045ac43ba..68630fd382c5 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -43,27 +43,30 @@
> >  
> >  #define KVM_HOST_SMCCC_FUNC(name) KVM_HOST_SMCCC_ID(__KVM_HOST_SMCCC_FUNC_##name)
> >  
> > +/* Hypercalls available only prior to pKVM finalisation */
> >  #define __KVM_HOST_SMCCC_FUNC___kvm_hyp_init			0
> > -#define __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run			1
> > -#define __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context		2
> > -#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa		3
> > -#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid		4
> > -#define __KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context		5
> > -#define __KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff		6
> > -#define __KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs			7
> > -#define __KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config		8
> > -#define __KVM_HOST_SMCCC_FUNC___vgic_v3_read_vmcr		9
> > -#define __KVM_HOST_SMCCC_FUNC___vgic_v3_write_vmcr		10
> > -#define __KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs		11
> > -#define __KVM_HOST_SMCCC_FUNC___kvm_get_mdcr_el2		12
> > -#define __KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs		13
> > -#define __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs		14
> > -#define __KVM_HOST_SMCCC_FUNC___pkvm_init			15
> > -#define __KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp		16
> > -#define __KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping	17
> > -#define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		18
> > -#define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		19
> > -#define __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc			20
> > +#define __KVM_HOST_SMCCC_FUNC___kvm_get_mdcr_el2		1
> > +#define __KVM_HOST_SMCCC_FUNC___pkvm_init			2
> > +#define __KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping	3
> > +#define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		4
> > +#define __KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs			5
> > +#define __KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs		6
> > +#define __KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config		7
> > +#define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		8
> > +
> > +/* Hypercalls available after pKVM finalisation */
> > +#define __KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp		9
> > +#define __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc			10
> > +#define __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run			11
> > +#define __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context		12
> > +#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa		13
> > +#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid		14
> > +#define __KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context		15
> > +#define __KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff		16
> > +#define __KVM_HOST_SMCCC_FUNC___vgic_v3_read_vmcr		17
> > +#define __KVM_HOST_SMCCC_FUNC___vgic_v3_write_vmcr		18
> > +#define __KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs		19
> > +#define __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs		20
> 
> This is no helping with the above, but can we *please* try to get rid
> of this #define insanity before moving things around? I came up with
> the following, which seems to build.
> 
> Thoughts?
> 
> 	M.
> 
> From 8a50c98489220d2ebaf02d4ffdbef3cf0d6634ee Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Thu, 7 Oct 2021 13:18:29 +0100
> Subject: [PATCH] KVM: arm64: Turn __KVM_HOST_SMCCC_FUNC_* into an enum
>  (mostly)
> 
> __KVM_HOST_SMCCC_FUNC_* is a royal pain, as there is a fair amount
> of churn around these #defines, and we avoid making it an enum
> only for the sake of the early init, low level code that requires
> __KVM_HOST_SMCCC_FUNC___kvm_hyp_init to be usable from assembly.
> 
> Let's be brave and turn everything but this symbol into an enum,
> using a bit of arithmetic to avoid any overlap.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_asm.h | 44 +++++++++++++++++---------------
>  1 file changed, 24 insertions(+), 20 deletions(-)

Looks fine to me:

Acked-by: Will Deacon <will@kernel.org>

Do you need me to respin my series on top of this?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
