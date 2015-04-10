From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH] arm64: KVM: remove fpsimd save/restore from the
 world switch
Date: Fri, 10 Apr 2015 11:12:15 +0200
Message-ID: <20150410091215.GC6186@cbox>
References: <1428598439-5217-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E40AA4C031
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 05:04:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZUUbOopNif+x for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2015 05:04:36 -0400 (EDT)
Received: from mail-lb0-f177.google.com (mail-lb0-f177.google.com
 [209.85.217.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ACA784C02C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 05:04:36 -0400 (EDT)
Received: by lbcga7 with SMTP id ga7so9056559lbc.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 02:12:14 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1428598439-5217-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 09, 2015 at 05:53:59PM +0100, Marc Zyngier wrote:
> The world switch spends quite some time dealing with the FP/SIMD
> registers, as the state is quite sizeable (32 128bit registers,
> plus some crumbs on the side). We save/restore them on each
> entry/exit, so that both the host and the guest always see
> the state they expect.
> 
> But let's face it: the host kernel doesn't care. It is the host
> userspace that actually cares about FP. An obvious improvement is
> to remove the save/restore from the world switch, and only perform
> it when we're about to enter/exit the guest (by plugging it into
> vcpu_load/vcpu_put). The effect is pretty spectacular when running
> hackbench (which is the only benchmark worth looking at):
> 
so the kernel never uses fp/simd registers for stuff like memcopies
etc.?

Can we also make a similar change for ARM on the 32-bit side?

-Christoffer
