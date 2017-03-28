From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 0/9] arm64: KVM: Fix PMU exception generation
Date: Tue, 28 Mar 2017 15:37:18 +0200
Message-ID: <20170328133718.GA20211@cbox>
References: <20170327160345.12402-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD0ED40A6A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 09:35:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EZ1kw-FAbxpV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Mar 2017 09:35:22 -0400 (EDT)
Received: from mail-lf0-f49.google.com (mail-lf0-f49.google.com
 [209.85.215.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8365C40966
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 09:35:22 -0400 (EDT)
Received: by mail-lf0-f49.google.com with SMTP id h125so38262940lfe.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 06:37:21 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170327160345.12402-1-marc.zyngier@arm.com>
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

On Mon, Mar 27, 2017 at 05:03:36PM +0100, Marc Zyngier wrote:
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
> - Make all PMU illegal accesses inject an UNDEF
> - Make these illegal accesses a successful emulation w.r.t the rest of KVM.
> 
> In the process, we also squash an interesting bug in the 64bit CP
> access. Similar treatment is applied to the 32bit kernel, except that
> we don't ever inject an exception there (no PMU support yet).
> 

I have applied this series to queue (not next since I haven't tested
thoroughly yet), with the fixups agreed in the series.

Thanks,
-Christoffer
