From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 0/2] KVM: ARM: Enable vtimers with user space gic
Date: Fri, 16 Sep 2016 17:45:48 +0200
Message-ID: <b4cdb857-cdd3-2f80-4642-c41aaa5e762b@redhat.com>
References: <1474007187-18673-1-git-send-email-agraf@suse.de>
 <57DBC782.7080305@arm.com> <7beb406b-6194-8451-2d92-9a4394ef91dd@redhat.com>
 <20160916123039.GB14140@cbox>
 <da8191ca-6fb1-f960-872c-d6bc27172db8@redhat.com>
 <20160916133027.GA27036@cbox>
 <20160916134619.jjiaplhxgkkl5qri@kamzik.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C432649AFA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 11:37:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dm8T21l+ONl3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2016 11:36:59 -0400 (EDT)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 960C2413E1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 11:36:59 -0400 (EDT)
Received: by mail-wm0-f65.google.com with SMTP id b187so4325096wme.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 08:45:52 -0700 (PDT)
In-Reply-To: <20160916134619.jjiaplhxgkkl5qri@kamzik.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 16/09/2016 15:46, Andrew Jones wrote:
> > But I haven't even looked at the patches in detail, I was just replying
> > to the comment about testing.
>
> This may be a great time to start encouraging feature writers to submit
> kvm-unit-tests patches at the same time as the feature (Hi Alex :-) I'm
> happy to help when a test isn't easy to write due to a lack of framework,
> but don't have nearly enough bandwidth to write all the tests myself.

In this case really a kernel smoke test can just work.  But yes,
architectural timer tests would be nice too.

> As for additional motivation for this series, I'll point out that it's
> good for bug isolation. When a guest fails to boot over KVM I can try
> TCG. If that works, then I've likely narrowed it to KVM. If I can
> further try kernel_irqchip=no, then I may further narrow it down to
> the vgic implementation.

(Or vice versa to the userspace GIC if you're looking at a TCG bug).

Paolo
