From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/5] KVM/ARM: Fixes for 4.12-rc1
Date: Tue, 2 May 2017 16:44:34 +0200
Message-ID: <75f031d5-d16e-6311-af44-f2c5af5bded4@redhat.com>
References: <20170502133041.10980-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECD2240BBB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 May 2017 10:41:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RWlRIFqHSYZw for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 May 2017 10:41:36 -0400 (EDT)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0143F40BAC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 May 2017 10:41:35 -0400 (EDT)
Received: by mail-wm0-f65.google.com with SMTP id u65so5106265wmu.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 May 2017 07:44:38 -0700 (PDT)
In-Reply-To: <20170502133041.10980-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 02/05/2017 15:30, Marc Zyngier wrote:
> Here's a handful of random fixes I've queued locally that didn't have
> a chance to make it in 4.11.
> 
> The first two patches avoid stack-protector messing with the HYP code,
> as this ends up being a complete disaster.
> 
> The following two patches fix a bug introduced in the new vgic, where
> we may queue HW interrupts with the Pending+Active state, which is
> illegal.
> 
> The final patch fixes a misinterpretation of the spec, where we
> compute the number of APxRn register based on the number of priorities
> instead of using the number of preemption levels.
> 
> I've tagged the first 4 patches for stable, given that we're doing
> something potentially harmful. The last patch is more of a theoretical
> issue at this stage, so probably need for a backport.

Would you like me to apply them, or are you looking for reviews and
going to send them in a pull request?

I can wait a couple days before sending my own pull request to Linus.

Paolo
