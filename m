From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH] arm64: KVM: remove fpsimd save/restore from the world
 switch
Date: Fri, 10 Apr 2015 10:36:40 +0100
Message-ID: <552799A8.1020307@arm.com>
References: <1428598439-5217-1-git-send-email-marc.zyngier@arm.com>
 <20150410091215.GC6186@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 634C24C047
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 05:29:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qEk7F2SgMHPT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2015 05:29:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3564F4C037
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 05:29:04 -0400 (EDT)
In-Reply-To: <20150410091215.GC6186@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/04/15 10:12, Christoffer Dall wrote:
> On Thu, Apr 09, 2015 at 05:53:59PM +0100, Marc Zyngier wrote:
>> The world switch spends quite some time dealing with the FP/SIMD
>> registers, as the state is quite sizeable (32 128bit registers,
>> plus some crumbs on the side). We save/restore them on each
>> entry/exit, so that both the host and the guest always see
>> the state they expect.
>>
>> But let's face it: the host kernel doesn't care. It is the host
>> userspace that actually cares about FP. An obvious improvement is
>> to remove the save/restore from the world switch, and only perform
>> it when we're about to enter/exit the guest (by plugging it into
>> vcpu_load/vcpu_put). The effect is pretty spectacular when running
>> hackbench (which is the only benchmark worth looking at):
>>
> so the kernel never uses fp/simd registers for stuff like memcopies
> etc.?

It can, but wraps it with kernel_neon_begin/kernel_neon_end, which does
its own save-restore. And when we perform our own save/restore, we do it
with interrupts disabled so that the kernel cannot change the state
during that time.

> Can we also make a similar change for ARM on the 32-bit side?

We could, but it is worth evaluating how much better this is compared to
what we have already.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
