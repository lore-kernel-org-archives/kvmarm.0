From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] kvm:arm:Fix error handling in the function vgic_v3_probe
Date: Thu, 6 Aug 2015 14:08:50 +0200
Message-ID: <20150806120850.GD4657@cbox>
References: <1438793303-30228-1-git-send-email-xerofoify@gmail.com>
 <55C240D9.5060900@redhat.com> <55C242C6.6060200@gmail.com>
 <55C31582.4000809@arm.com> <55C34C77.7090303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B7235A1FA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Aug 2015 07:55:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZloMFlnFT0-S for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Aug 2015 07:55:16 -0400 (EDT)
Received: from mail-la0-f41.google.com (mail-la0-f41.google.com
 [209.85.215.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C5C15A1E1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Aug 2015 07:55:16 -0400 (EDT)
Received: by labow3 with SMTP id ow3so47749274lab.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Aug 2015 05:08:05 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <55C34C77.7090303@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: nick <xerofoify@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "gleb@kernel.org" <gleb@kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Aug 06, 2015 at 02:00:55PM +0200, Paolo Bonzini wrote:
> 
> 
> On 06/08/2015 10:06, Marc Zyngier wrote:
> > > If this structure of function pointers can handle function pointers with a return type of 
> > > void I will be glad to do what you request otherwise this would require a major rewrite
> > > of kvm arm subsystem for a very simple bug fix.
> > 
> > Just like Paolo said, the error you report should never happen, and
> > would be caught by a WARN_ON() the first time anyone boots the kernel.
> > Also, failing to register the device ops results in not being able to
> > instantiate a VGIC. No harm done. I really don't understand why you want
> > to rewrite the probe functions.
> 
> I think he just misunderstood my suggestion.  I didn't suggest making
> the probe functions return void.  I suggested that
> kvm_register_device_ops return void.
> 
s390 seems to actually deal with the return value of this function and
fail to init KVM at all if it fails, but on the other hand, this
function only fails if you're doing something truly stupid and
internal-to-kvm incoherent, so I think it's fair to just do a WARN_ON()
or even BUG_ON() and make the register function a void.

-Christoffer
