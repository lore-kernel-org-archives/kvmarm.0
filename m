From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: Turn kvm_ksym_ref into a NOP on VHE
Date: Tue, 22 Mar 2016 08:33:36 +0100
Message-ID: <20160322073336.GA21047@cbox>
References: <1458321959-11728-1-git-send-email-marc.zyngier@arm.com>
 <CAKv+Gu_at5LXa5jxpM7h=ntxdJNNqmbtVE-bWn3SicMMMuT6Dg@mail.gmail.com>
 <56EFEABA.3010604@redhat.com> <20160321124216.GA16859@cbox>
 <56EFFEEB.8020800@redhat.com> <20160321185524.GD16859@cbox>
 <56F05FD7.9070706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF1DE40B40
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2016 03:32:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DeRZsEuWTPPQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2016 03:32:31 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 22157407A5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2016 03:32:30 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id l68so179634653wml.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2016 00:33:10 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <56F05FD7.9070706@redhat.com>
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

On Mon, Mar 21, 2016 at 09:55:51PM +0100, Paolo Bonzini wrote:
> 
> 
> On 21/03/2016 19:55, Christoffer Dall wrote:
> > > Since you have two more patches, I guess you can just send a pull
> > > request for all three.  I plan to send mine to Linus on Wednesday.
> > 
> > Sounds good, I'll send you one tomorrow (based on Linus' master branch
> > of today - if that works?)
> 
> Anything that you can test with works.  Even basing it on your last pull
> request is okay for me, and it's better for future bisection if there's
> some known breakage in Linus's master branch.
> 
The changes to kvm_ksym_ref() didn't apply to anything in the kvmarm
side of things but needed stuff from Catalin, so I just applied it on
top of Linus' master.

I'll send you the pull request later and just holler if I need to change
it somehow.

Thanks,
-Christoffer
