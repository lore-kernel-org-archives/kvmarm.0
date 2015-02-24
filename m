From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: kvm [2087]: load/store instruction decoding not implemented
Date: Tue, 24 Feb 2015 14:25:12 +0000
Message-ID: <20150224142512.GN11603@redhat.com>
References: <20150224115935.GA26241@redhat.com>
 <CAFEAcA-+xCkUNirq0zqQFotCSAjR25V25SkzPH7ktDOXQuhoFA@mail.gmail.com>
 <20150224122925.GL11603@redhat.com> <20150224124710.GB21364@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 107714674F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 09:19:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DLtBN+wboHXm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Feb 2015 09:19:36 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 03BD54670E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 09:19:35 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20150224124710.GB21364@cbox>
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
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 24, 2015 at 01:47:10PM +0100, Christoffer Dall wrote:
> On Tue, Feb 24, 2015 at 12:29:25PM +0000, Richard W.M. Jones wrote:
> > I'm not super-familiar with the aarch64 instruction set, but
> > according to qemu the instruction is:
> > 
> > b8004403        str     w3, [x0],#4
> > 
> > (in __copy_to_user).  My interpretation is this is storing the
> > lower 32 bits of x3 into the storage pointed to by x0 (+ 4 bytes?)
> > Is that one of the complicated ones?
> 
> Shouldn't be, I don't think aarch64 does any register write-back here.
> This is an aarch64 userspace process, right?
> 
> You can try adding some more debugging info to the print to get us the
> IPA it is failing on:
> 
> diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
> index 5d3bfc0..e468937 100644
> --- a/arch/arm/kvm/mmio.c
> +++ b/arch/arm/kvm/mmio.c
> @@ -182,7 +182,8 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		if (ret)
>  			return ret;
>  	} else {
> -		kvm_err("load/store instruction decoding not implemented\n");
> +		kvm_err("load/store instruction decoding not implemented (HSR: 0x%x, IPA: 0x%llx)\n",
> +			kvm_vcpu_get_hsr(vcpu), fault_ipa);
>  		return -ENOSYS;
>  	}

Sorry for the delay - I had to compile and install a new kernel with
your change.

The output is:

kvm [1568]: load/store instruction decoding not implemented (HSR: 0x92000046, IPA: 0x3c000020)

I'm not clear on what the "HSR" and "IPA" are, so I don't know what
other debug information could be valuable here, but the same guest
under gdb:

Program received signal SIGABRT, Aborted.
__copy_to_user () at arch/arm64/lib/copy_to_user.S:43
43	       USER(9f, str	w3, [x0], #4	)
(gdb) info registers 
x0             0xfffffdfffaa20020	-2199113301984
x1             0xfffffe0028343c20	-2198348743648
x2             0xfffffffffffffffc	-4
x3             0xd503201f		3573751839
x4             0xfffffdfffaa20024	-2199113301980
x5             0xffffffffffffffff	-1
x6             0xfffffe0000a1b5b0	-2199012657744
x7             0xfffffe0000a1b598	-2199012657768
x8             0xfffffe0000a1b580	-2199012657792
x9             0xfffffdfee01a4440	-2203853372352
x10            0x101010101010101	72340172838076673
x11            0x6			6
x12            0x0			0
x13            0xffffffffffffffff	-1
x14            0xffff000000000000	-281474976710656
x15            0xffffffffffffffff	-1
x16            0xfffffe000013a5e8	-2199021967896
x17            0x1			1
x18            0x0			0
x19            0x40000000000		4398046511104
x20            0xfffffdfffc000020	-2199090364384
x21            0x140			320
x22            0x0			0
x23            0xfffffe0000dc17d8	-2199008831528
x24            0xfffffe000009c5b0	-2199022615120
x25            0xfffffe0000f65000	-2199007113216
x26            0x0			0
x27            0x0			0
x28            0xfffffe0029110000	-2198334275584
x29            0xfffffe0028343bc0	-2198348743744
x30            0xfffffe00001a6560	-2199021525664
sp             0xfffffe0028343bc0	0xfffffe0028343bc0
pc             0xfffffe00003e306c	0xfffffe00003e306c <__copy_to_user+44>
cpsr           0x600001c5		1610613189
fpsr           0x0			0
fpcr           0x0			0

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-top is 'top' for virtual machines.  Tiny program with many
powerful monitoring features, net stats, disk stats, logging, etc.
http://people.redhat.com/~rjones/virt-top
