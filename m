From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: Turn kvm_ksym_ref into a NOP on VHE
Date: Mon, 21 Mar 2016 13:42:16 +0100
Message-ID: <20160321124216.GA16859@cbox>
References: <1458321959-11728-1-git-send-email-marc.zyngier@arm.com>
 <CAKv+Gu_at5LXa5jxpM7h=ntxdJNNqmbtVE-bWn3SicMMMuT6Dg@mail.gmail.com>
 <56EFEABA.3010604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2328D40F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2016 08:41:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a+TLXA5YnlbM for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Mar 2016 08:41:14 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9876407AD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2016 08:41:13 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id l68so108376604wml.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2016 05:41:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <56EFEABA.3010604@redhat.com>
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
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 21, 2016 at 01:36:10PM +0100, Paolo Bonzini wrote:
> 
> 
> On 21/03/2016 09:47, Ard Biesheuvel wrote:
> > On 18 March 2016 at 18:25, Marc Zyngier <marc.zyngier@arm.com> wrote:
> >> When running with VHE, there is no need to translate kernel pointers
> >> to the EL2 memory space, since we're already there (and we have a much
> >> saner memory map to start with).
> >>
> >> Unfortunately, kvm_ksym_ref is getting in the way, and the first
> >> call into the "hypervisor" section is going to end up in fireworks,
> >> since we're now branching into nowhereland. Meh.
> >>
> >> A potential solution is to test if VHE is engaged or not, and only
> >> perform the translation in the negative case. With this in place,
> >> VHE is able to run again.
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > 
> > I think you need the & when initializing val, otherwise, it will
> > silently refer to the value rather than the address of a void* symbol
> > if we ever end up using this macro on one.
> > 
> > That was the whoie point of the opaque struct type in the original
> > patch that introduced this macro, to disallow references lacking the
> > &, but unfortunately, that was incompatible with the other VHE
> > changes.
> > 
> > With that fixed
> > 
> > Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> Marc, if you send a v2 I can merge it directly without a pull request.
> 
Marc is on holiday this week, but I put this (with the fix) on top of
Linus' master in the kvmarm/master branch:

git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git master

Do you want to just grab it from there?

Thanks,
-Christoffer
