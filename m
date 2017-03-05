From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 0/8] arm64: KVM: Fix PMU exception generation
Date: Sun, 5 Mar 2017 07:01:09 -0800
Message-ID: <20170305150109.GA1502@lvm>
References: <20170222114728.2472-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72916405DA
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Mar 2017 09:59:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LM4IVNmq+mLv for <kvmarm@lists.cs.columbia.edu>;
 Sun,  5 Mar 2017 09:59:54 -0500 (EST)
Received: from mail-wr0-f178.google.com (mail-wr0-f178.google.com
 [209.85.128.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C4BFC40430
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Mar 2017 09:59:54 -0500 (EST)
Received: by mail-wr0-f178.google.com with SMTP id u48so101101778wrc.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 05 Mar 2017 07:01:12 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170222114728.2472-1-marc.zyngier@arm.com>
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
Cc: Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On Wed, Feb 22, 2017 at 11:47:20AM +0000, Marc Zyngier wrote:
> Running the following code:
> 
> root@zomby-woof:~# cat test-pmu.c
> int main(int argc, char *argv[])
> {
> 	unsigned int val;
> 	asm ("mrc p15, 0, %0, c9, c13, 0\n" : "=r" (val));
> 	return val;
> }
> 
> in a 32bit guest (or a 64bit guest with a 32bit userspace) results in
> this surprising result:
> 
> [  120.347497] kvm [1150]: Unsupported guest CP15 access at: ab0945ae
> [  120.353689] kvm [1142]:  { Op0( 0), Op1( 0), CRn( 9), CRm(13), Op2( 0), func_read },
> 
> which is weird, because the guest behaves correctly:
> root@zomby-woof:~# ./test-pmu 
> [   16.184422] test-pmu[740]: undefined instruction: pc=00000000ab0945ae
> [   16.186043] Code: 00340001 b4800000 af00b085 60396078 (3f1dee19) 
> Illegal instruction
> 
> It gets the expected UNDEF, and all is fine. So what?
> 
> It turns out that the PMU emulation code is a bit lazy, and tells the
> rest of KVM that the emulation has failed, so that an exception gets
> delivered. Subtle differences in the 32bit vs 64bit handling make it
> spit an "Unsupported..." error.
> 
> This series tries to set things straight:
> - Allow an exception to be injected from an emulation handler
> - Make all PMU illegal accesses inject an UNDEF
> - Make these illegal accesses a successful emulation w.r.t the rest of KVM.
> 
> In the process, we also squash an interesting bug in the 64bit CP
> access. Similar treatment could be applied to the 32bit kernel, except
> that we don't ever inject an exception there (no PMU support yet).

I'm a bit confused about this series and not too thrilled of the
approach where we add a side-channel of the sys_reg param in the vcpu
structure, which may or may not contain valid data at any given point.

Couldn't we use a slightly bigger hammer (with cleaner semantics) and
let all system register handling (cp on 32-bit and 64-bit sys regs
alike) simply return true if they were emulated, in which case the
caller should advance the PC, or false ifsomething else happened, and
leave it up to the emulation of the individual registers to decide if
any exceptions should be injected.

I don't think we have that many places where we want to inject an
undefined exception in our handlers, and doing it explicitly might
actually be a good idea to make it more clear that we're emulating the
architecture properly.  What do you think?

Thanks,
-Christoffer
