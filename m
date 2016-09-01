From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 0/2] arm{,64}/kvm: excise redundant cache maintenance
Date: Thu, 1 Sep 2016 13:15:45 +0200
Message-ID: <20160901111545.GC10162@cbox>
References: <1472573156-30414-1-git-send-email-mark.rutland@arm.com>
 <20160830180020.GB19315@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3199D40F9B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 07:05:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G2EVlukDe+Kx for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Sep 2016 07:05:14 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C54BD40BDA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 07:05:14 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id c133so72588687wmd.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Sep 2016 04:13:25 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160830180020.GB19315@leverpostej>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 30, 2016 at 07:00:20PM +0100, Mark Rutland wrote:
> On Tue, Aug 30, 2016 at 05:05:54PM +0100, Mark Rutland wrote:
> > As noted in a jailhouse thread a short while ago [1,2], the presence of the
> > virtualization extensions implies that page table walks are coherent, and do
> > not require that updates are cleaned to the PoU.
> > 
> > These patches remove the redundant maintenance and related infrastructure.
> > 
> > As I do not have a suitably configured ARMv7 board, I have not been able to
> > test the patches myself, and any testing would be appreciated.
> 
> Having been lent a TC2 booting in Hyp mode, I've now given this a spin
> with a few VMs, which I left running hackbench to fault in guest memory.
> 
> All of that ran happily.
> 
I've tested this on TC2 and CubieTruck as well, no problems as far as I
can see.

Applied.

Thanks,
-Christoffer
