From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 20/21] KVM: arm64: Take any host SError before
 entering the guest
Date: Wed, 1 Nov 2017 05:55:50 +0100
Message-ID: <20171101045550.GB11166@lvm>
References: <20171019145807.23251-1-james.morse@arm.com>
 <20171019145807.23251-21-james.morse@arm.com>
 <20171031062315.GY2166@lvm> <59F861EE.4010505@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5791349D4E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Nov 2017 00:54:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GUbIiNFzJZqX for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Nov 2017 00:54:25 -0400 (EDT)
Received: from mail-lf0-f47.google.com (mail-lf0-f47.google.com
 [209.85.215.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2DA7F49D14
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Nov 2017 00:54:25 -0400 (EDT)
Received: by mail-lf0-f47.google.com with SMTP id a2so1182811lfh.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Oct 2017 21:56:02 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <59F861EE.4010505@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, linux-arm-kernel@lists.infradead.org, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 31, 2017 at 11:43:42AM +0000, James Morse wrote:
> Hi Christoffer,
> 
> On 31/10/17 06:23, Christoffer Dall wrote:
> > On Thu, Oct 19, 2017 at 03:58:06PM +0100, James Morse wrote:
> >> On VHE systems KVM masks SError before switching the VBAR value. Any
> >> host RAS error that the CPU knew about before world-switch may become
> >> pending as an SError during world-switch, and only be taken once we enter
> >> the guest.
> >>
> >> Until KVM can take RAS SErrors during world switch, add an ESB to
> >> force any RAS errors to be synchronised and taken on the host before
> >> we enter world switch.
> >>
> >> RAS errors that become pending during world switch are still taken
> >> once we enter the guest.
> 
> >> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> >> index cf5d78ba14b5..5dc6f2877762 100644
> >> --- a/arch/arm64/include/asm/kvm_host.h
> >> +++ b/arch/arm64/include/asm/kvm_host.h
> >> @@ -392,6 +392,7 @@ static inline void __cpu_init_stage2(void)
> >>  
> >>  static inline void kvm_arm_vhe_guest_enter(void)
> >>  {
> >> +	esb();
> 
> > I don't fully appreciate what the point of this is?
> > 
> > As I understand it, our fundamental goal here is to try to distinguish
> > between errors happening on the host or in the guest.
> 
> Not just host/guest, but also those we can and can't handle.
> 
> KVM can't currently take an SError during world switch, so a RAS error that the
> CPU was hoping to defer may spread from the host into KVM's
> no-SError:world-switch code. If this happens it will (almost certainly) have to
> be re-classified as uncontainable.
> 
> There is also a firmware-first angle here: NOTIFY_SEI can't be delivered if the
> normal world has SError masked, so any error that spreads past this point
> becomes a reboot-by-firmware instead of an OS notification and almost-helpful
> error message.
> 
> 
> > If that's correct, then why don't we do it at the last possible moment
> > when we still have a scratch register left, in the world switch code
> > itself, and in the case abort the guest entry and report back a "host
> > SError" return code.
> 
> We have IESB to run the error-barrier as we enter the guest. This would make any
> host error pending as an SError, and we would exit the guest immediately. But if
> there was an RAS error during world switch, by this point its likely to be
> classified as uncontainable.
> 
> This esb() is trying to keep this window of code as small as possible, to just
> errors that occur during world switch.
> 
> With your vcpu load/save this window becomes a lot smaller, it may be possible
> to get a VHE-host's arch-code SError handler to take errors from EL2, in which
> case this barrier can disappear.
> (note to self: guest may still own the debug hardware)
> 

ok, thanks for your detailed explanation.  I didn't consider that the
classification of a RAS error as containable vs. non-containable
depended on where we take the exception.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
