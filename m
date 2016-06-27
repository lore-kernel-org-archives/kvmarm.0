From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Stop leaking vcpu pid references
Date: Mon, 27 Jun 2016 13:08:39 +0200
Message-ID: <20160627110839.GD26498@cbox>
References: <1465403085-2358-1-git-send-email-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EB9C4998D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 07:02:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MhRsMho1Vizg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jun 2016 07:02:46 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E18A41AF6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 07:02:46 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id r201so109828730wme.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 04:07:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1465403085-2358-1-git-send-email-james.morse@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jun 08, 2016 at 05:24:45PM +0100, James Morse wrote:
> kvm provides kvm_vcpu_uninit(), which amongst other things, releases the
> last reference to the struct pid of the task that was last running the vcpu.
> 
> On arm64 built with CONFIG_DEBUG_KMEMLEAK, starting a guest with kvmtool,
> then killing it with SIGKILL results (after some considerable time) in:
> > cat /sys/kernel/debug/kmemleak
> > unreferenced object 0xffff80007d5ea080 (size 128):
> >  comm "lkvm", pid 2025, jiffies 4294942645 (age 1107.776s)
> >  hex dump (first 32 bytes):
> >    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >  backtrace:
> >    [<ffff8000001b30ec>] create_object+0xfc/0x278
> >    [<ffff80000071da34>] kmemleak_alloc+0x34/0x70
> >    [<ffff80000019fa2c>] kmem_cache_alloc+0x16c/0x1d8
> >    [<ffff8000000d0474>] alloc_pid+0x34/0x4d0
> >    [<ffff8000000b5674>] copy_process.isra.6+0x79c/0x1338
> >    [<ffff8000000b633c>] _do_fork+0x74/0x320
> >    [<ffff8000000b66b0>] SyS_clone+0x18/0x20
> >    [<ffff800000085cb0>] el0_svc_naked+0x24/0x28
> >    [<ffffffffffffffff>] 0xffffffffffffffff
> 
> On x86 kvm_vcpu_uninit() is called on the path from kvm_arch_destroy_vm(),
> on arm no equivalent call is made. Add the call to kvm_arch_vcpu_free().
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Fixes: 749cf76c5a36 ("KVM: ARM: Initial skeleton to compile KVM support")
> Cc: <stable@vger.kernel.org> # 3.10+
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Applied, thanks.

-Christoffer
