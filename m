From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 05/10] KVM: arm: introduce kvm_arch_setup/clear_debug()
Date: Mon, 13 Apr 2015 16:48:43 +0200
Message-ID: <20150413144843.GQ6186@cbox>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-6-git-send-email-alex.bennee@linaro.org>
 <20150413143623.GP6186@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AC764C4B2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 10:40:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kq9aszZeB8Be for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2015 10:40:51 -0400 (EDT)
Received: from mail-la0-f48.google.com (mail-la0-f48.google.com
 [209.85.215.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 613FF4C4B0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 10:40:50 -0400 (EDT)
Received: by labbd9 with SMTP id bd9so59263533lab.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 07:48:37 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150413143623.GP6186@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, marc.zyngier@arm.com, jan.kiszka@siemens.com, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com, Andre Przywara <andre.przywara@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, zhichao.huang@linaro.org, r65777@freescale.com, pbonzini@redhat.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 13, 2015 at 04:36:23PM +0200, Christoffer Dall wrote:

[...]

> > +
> > +/**
> > + * kvm_arch_setup_debug - set-up debug related stuff
> 
> nit: I think you want "set up" when it's a verb.
> 
> > + *
> > + * @vcpu:	the vcpu pointer
> > + *
> > + * This is called before each entry in to the hypervisor to setup any
> 
> s/in to/into/
> s/setup/set up/
> 
> > + * debug related registers. Currently this just ensures we will trap
> > + * access to:
> 
> guest accesses to:
> 
> > + *  - Performance monitors (MDCR_EL2_TPM/MDCR_EL2_TPMCR)
> > + *  - Debug ROM Address (MDCR_EL2_TDRA)
> > + *  - Power down debug registers (MDCR_EL2_TDOSA)
> > + *
> > + * Additionally the hypervisor lazily saves/restores the debug
> > + * register state. If it is not currently doing so (arch.debug_flags)
> > + * then we also need to ensure we trap if the guest messes with them
> > + * so we know we need to save them.
> 
> This paragraph is a little hard to make sense of.  If I understand it
> correctly, the point is that when debugging the guest we need to make
> sure guest accesses to the debug registers traps?  If so, I would
> suggest something like:
> 
>   Additionally, KVM only traps guest accesses to the debug registers if
>   the guest is not actively using them (see the KVM_ARM64_DEBUG_DIRTY
>   flag on vcpu->arch.debug_flags).  Since the guest must not interfere
>   with the hardware state when debugging the guest, we must ensure that
>   trapping is enabled whenever we are debugging the guest.
> 

thinking about this, I don't think we're enforcing this yet, but maybe
that will come in the later patches or I misread the original paragraph.

-Christoffer
