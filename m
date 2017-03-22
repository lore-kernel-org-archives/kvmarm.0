From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 00/28] arm/arm64: KVM: Rework the hyp-stub API
Date: Wed, 22 Mar 2017 18:27:08 +0100
Message-ID: <20170322172708.GA17329@cbox>
References: <20170321192058.9300-1-marc.zyngier@arm.com>
 <20170322133724.GA10969@cbox>
 <3dab2f39-88c2-e10b-942c-58a1d8053b71@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66E6540BBB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Mar 2017 13:25:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ugyK84l6uEWM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Mar 2017 13:25:20 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA61440966
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Mar 2017 13:25:19 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id t189so44402205wmt.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Mar 2017 10:27:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <3dab2f39-88c2-e10b-942c-58a1d8053b71@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, Keerthy <j-keerthy@ti.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 22, 2017 at 04:14:44PM +0000, Marc Zyngier wrote:
> Hi Christoffer,
> 
> On 22/03/17 13:37, Christoffer Dall wrote:
> > Hi Marc,
> > 
> > 
> > On Tue, Mar 21, 2017 at 07:20:30PM +0000, Marc Zyngier wrote:
> >> As noticed by RMK in this thread[1], the hyp-stub API on 32bit ARM
> >> could do with some TLC (it cannot perform a soft-restart at HYP, and
> >> has holes in the hyp-stub support in a number of places). In general,
> >> it would be desirable for the 32bit behaviour to align on 64bit, if
> >> only to ease maintenance.
> >>
> >> This series implements the following:
> >> - Add HVC_[GS]ET_VECTORS and HVC_SOFT_RESTART to the 32bit code
> >> - Add HVC_RESET_VECTORS to both arm and arm64, removing the need for
> >>   __hyp_reset_vectors
> >> - Implement add the stub entry points in the KVM init code, which
> >>   didn't implement any so far
> >> - Convert the HYP code to use the init code stubs directly
> >> - Some general cleanup as a result of these changes (which includes
> >>   killing HVC_GET_VECTORS)
> >> - Add some API documentation that covers the above
> >>
> >> Patches 12 to 14 would be better squashed into 10 and 11, but I've
> >> kept them separate so that I can take the blame for everything I've
> >> broken.
> > 
> > This series looks great overall.  I'm still going through the details of
> > the patches, but one high level questions:
> > 
> > What if we formalized the way to call a function in Hyp mode, whatever
> > its current configuration may be, via a specific HVC number.  That would
> > mean that the documentation say nothing of a hypervisor specific
> > implementaiton.
> 
> Do you mean an actual function call indirected via an HVC? Similar to
> what we already do today for KVM when we want to call HYP functions?

Yes exactly.  One question would be how to standardize that if the
caller is not tied to the thing owning Hyp, making it unclear if it can
rely on the thing working or not, but I'm not sure if that's any worse
than what we have today.

> > Could we then use that to initialize hyp mode for a hypervisor, i.e.
> > KVM, without having to actually change the vectors?  Couldn't we simply
> > use the the hvc stub to call a function in the physical address space,
> > and be rid of the concept of hyp-init alltogether?
> 
> My problem here is when you say "in the physical space". Do you want to
> be able to call such a function from any context? That's certainly
> doable now, but I'm not completely sure of what we get.
> 
> Maybe I just don't see the use case - can you enlighten me?
> 

I don't think there is a great use case beyond what we already do, it
would just be to have one set of hyp vectors fewer, so that either the
hyp stub is in place, or a hypervisor is in place, not kvm-init vectors.

So instead of doing:
  __hyp_set_vectors(kvm_get_idmap_vector());
  hvc(); /* via the misused kvm_call_hyp thing */

you would do:

  __hyp_call_function(__kvm_hyp_init, arg1, arg2);

which would change the vector and initialize anything.

Not sure if that can work though, or if there are any downsides that I
haven't thought about?

Thanks,
-Christoffer
