From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: kvm [2087]: load/store instruction decoding not implemented
Date: Tue, 24 Feb 2015 13:47:10 +0100
Message-ID: <20150224124710.GB21364@cbox>
References: <20150224115935.GA26241@redhat.com>
 <CAFEAcA-+xCkUNirq0zqQFotCSAjR25V25SkzPH7ktDOXQuhoFA@mail.gmail.com>
 <20150224122925.GL11603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F38B466F6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 07:41:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jnf4Xz-ARaUa for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Feb 2015 07:41:04 -0500 (EST)
Received: from mail-la0-f44.google.com (mail-la0-f44.google.com
 [209.85.215.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CFF9246609
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 07:41:03 -0500 (EST)
Received: by labhs14 with SMTP id hs14so2718080lab.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 04:46:44 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20150224122925.GL11603@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 24, 2015 at 12:29:25PM +0000, Richard W.M. Jones wrote:
> On Tue, Feb 24, 2015 at 09:15:18PM +0900, Peter Maydell wrote:
> > On 24 February 2015 at 20:59, Richard W.M. Jones <rjones@redhat.com> wrote:
> > >
> > > https://bugzilla.redhat.com/show_bug.cgi?id=1194366
> > >
> > > Has anyone seen this KVM error?  Or have suggestions how to debug it
> > > further?
> > >
> > >   kvm [2028]: load/store instruction decoding not implemented
> > 
> > This is a fairly common thing to run into and google is bound
> > to have references to past discussions. What has happened here
> > is that the guest has attempted a "complex" load/store instruction
> > to an area of RAM which is not mapped (ie not guest RAM).
> > For this class of instructions the hardware doesn't provide
> > syndrome information to allow us to figure out the address/size
> > etc of the access, so we would have to actually decode the
> > offending instruction and emulate it; this emulation isn't
> > implemented.
> > 
> > Complex insns are things like load-multiple (there's a complete
> > list in the ARM ARM somewhere). Generally this indicates a guest
> > bug because you really shouldn't be accessing devices with
> > weird instructions like that (and you shouldn't be accessing
> > unmapped memory at all).
> 
> I'm not super-familiar with the aarch64 instruction set, but
> according to qemu the instruction is:
> 
> b8004403        str     w3, [x0],#4
> 
> (in __copy_to_user).  My interpretation is this is storing the
> lower 32 bits of x3 into the storage pointed to by x0 (+ 4 bytes?)
> Is that one of the complicated ones?

Shouldn't be, I don't think aarch64 does any register write-back here.
This is an aarch64 userspace process, right?

You can try adding some more debugging info to the print to get us the
IPA it is failing on:

diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
index 5d3bfc0..e468937 100644
--- a/arch/arm/kvm/mmio.c
+++ b/arch/arm/kvm/mmio.c
@@ -182,7 +182,8 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		if (ret)
 			return ret;
 	} else {
-		kvm_err("load/store instruction decoding not implemented\n");
+		kvm_err("load/store instruction decoding not implemented (HSR: 0x%x, IPA: 0x%llx)\n",
+			kvm_vcpu_get_hsr(vcpu), fault_ipa);
 		return -ENOSYS;
 	}
 

I wonder why you're faulting on an address that your guest kernel is
doing __copy_to_user() on in the first place though, hmmm.

-Christoffer
