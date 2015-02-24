From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: kvm [2087]: load/store instruction decoding not implemented
Date: Tue, 24 Feb 2015 15:20:39 +0000
Message-ID: <54EC96C7.8030309@arm.com>
References: <20150224115935.GA26241@redhat.com>
 <CAFEAcA-+xCkUNirq0zqQFotCSAjR25V25SkzPH7ktDOXQuhoFA@mail.gmail.com>
 <20150224122925.GL11603@redhat.com> <20150224124710.GB21364@cbox>
 <54EC78D1.3030703@arm.com> <20150224134533.GM11603@redhat.com>
 <54EC8654.1060905@arm.com> <20150224143608.GO11603@redhat.com>
 <54EC8DE6.8000105@arm.com> <20150224150911.GQ11603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C3C446789
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 10:15:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oSX4BE3RCEBF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Feb 2015 10:15:03 -0500 (EST)
Received: from usa-sjc-mx-foss1.foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5E6B46786
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 10:15:02 -0500 (EST)
In-Reply-To: <20150224150911.GQ11603@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 24/02/15 15:09, Richard W.M. Jones wrote:
>> On 24/02/15 14:36, Richard W.M. Jones wrote:
>>> I can probably bisect this given time, but I'm going to try putting
>>> some debug into the userspace process to find out which system call
>>> fails first.
> 
> Perhaps not surprisingly, it's the init_module syscall which causes
> the failure, ie. this line of code:
> 
>   https://github.com/libguestfs/supermin/blob/master/src/init.c#L436
> 
> I've no idea why that code would call copy_to_user.  It should be
> copying the other way ...
> 
> It also fails on the first call to init_module, so the fact that it's
> loading crc32-arm64.ko may just be a coincidence.
> 
> There are no other userspace processes running, but just to be sure
> that it's not some other process in the guest, I also added a sleep
> before the call to init_module, but same result as above.
> 
> I also looked at the implementation of init_module in glibc, but
> AFAICT init_module is a straight syscall and glibc is not involved.
> 
> I also looked to see if I was calling init_module correctly on aarch64
> (in case it has a different # of arguments of something) but it's
> called in the same way in the libkmod code, so I think we're OK.
> 
> Next up, I will have a go at bisecting the guest kernel.

After some quick debug, here's the backtrace:

[   13.276501] [<fffffe00003da0bc>] __copy_to_user+0x2c/0x60
[   13.276734] [<fffffe0000099f08>] __aarch64_insn_write+0x94/0xf8
[   13.276971] [<fffffe000009a0a0>] aarch64_insn_patch_text_nosync+0x18/0x58
[   13.277245] [<fffffe000009c4b0>] ftrace_make_nop+0x54/0x84
[   13.277457] [<fffffe0000164400>] ftrace_process_locs+0x3d0/0x5c8
[   13.277694] [<fffffe00001661ac>] ftrace_module_init+0x28/0x34
[   13.277968] [<fffffe0000135128>] load_module+0xbb8/0xfc4
[   13.278142] [<fffffe00001356f4>] SyS_finit_module+0x94/0xc4

Either ftrace or the patching code is buggy. Need to investigate.

BTW, if you want to be able to get that kind of trace:

diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
index 5d3bfc0..5b23917 100644
--- a/arch/arm/kvm/mmio.c
+++ b/arch/arm/kvm/mmio.c
@@ -183,7 +183,9 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			return ret;
 	} else {
 		kvm_err("load/store instruction decoding not implemented\n");
-		return -ENOSYS;
+		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+		return 1;
+		//return -ENOSYS;
 	}
 
 	rt = vcpu->arch.mmio_decode.rt;

Now trying to understand how we got there...

	M.
-- 
Jazz is not dead. It just smells funny...
