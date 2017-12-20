From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: add micro test
Date: Wed, 20 Dec 2017 18:00:30 +0100
Message-ID: <20171220170030.zvz3oounirnlhcfi@hawk.localdomain>
References: <1513372539-10180-1-git-send-email-shihwei@cs.columbia.edu>
 <1513372539-10180-2-git-send-email-shihwei@cs.columbia.edu>
 <20171218191037.wjocr7jbf5ua2duj@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171218191037.wjocr7jbf5ua2duj@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Shih-Wei Li <shihwei@cs.columbia.edu>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 18, 2017 at 08:10:37PM +0100, Andrew Jones wrote:
> I just tried on TCG now. It doesn't run. It gets
> 
> Timer Frequency 62500000 Hz (Output in timer count)
> Unhandled exception ec=0 (UNKNOWN)
> Vector: 4 (el1h_sync)
> ESR_EL1:         02000000, ec=0 (UNKNOWN)
> FAR_EL1: 0000000000000000 (not valid)
> Exception frame registers:
> pc : [<0000000040080088>] lr : [<00000000400803e8>] pstate: 800003c5
> sp : 00000000400aff90
> x29: 0000000000000000 x28: 0000000000000000 
> x27: 0000000040090000 x26: 0000000040090c60 
> x25: 0000000040090000 x24: 000000001fffffff 
> x23: 0000000000000000 x22: 0000000000000000 
> x21: 0000000000000040 x20: 0000000000000000 
> x19: 0000000000000000 x18: 00000000400b0000 
> x17: 0000000000000000 x16: 0000000000000000 
> x15: 00000000400afe8c x14: 00000000400b0000 
> x13: 00000000400afecc x12: 0000000000001680 
> x11: 0000000000000000 x10: 6666666666666667 
> x9 : 0000000000000030 x8 : 0000000000000030 
> x7 : 00000000400af670 x6 : 00000000400af673 
> x5 : 00000000400af678 x4 : 00000000000007b7 
> x3 : 00000000400af6ec x2 : 0000000040090000 
> x1 : 000000000015909e x0 : 000000004b000000
>

I looked into this. It's due to the hvc call. The exception goes away if
you add '-machine virtualization=yes' to the qemu command line. But as
there's no point in running it, and it's way too slow, then the
'accel = kvm' added in v2 of the patch is the right thing to do.

Thanks,
drew 
