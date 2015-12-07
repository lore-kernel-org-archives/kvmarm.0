From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 0/4] KVM: arm64: BUG FIX: Correctly handle zero
 register transfers
Date: Mon, 7 Dec 2015 17:45:55 -0600
Message-ID: <20151207234555.GA2980@hawk.localdomain>
References: <cover.1449230499.git.p.fedin@samsung.com>
 <20151205003334.GB3117@hawk.localdomain>
 <011601d130ca$64cc9070$2e65b150$@samsung.com>
 <20151207223631.GJ4402@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151207223631.GJ4402@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 07, 2015 at 04:36:31PM -0600, Andrew Jones wrote:
> On Mon, Dec 07, 2015 at 11:36:28AM +0300, Pavel Fedin wrote:
> >  Hello!
> > 
> > > FYI, I tried writing test cases for this issue with kvm-unit-tests. The
> > > issue didn't reproduce for me. It's quite possible my test cases are
> > > flawed, so I'm not making any claims about the validity of the series
> > 
> >  This is indeed very interesting, so i'll take a look at it.
> >  For now i've just only took a quick glance at the code, and i have at least one suggestion. Could you happen to have sp == 0 in
> > check_xzr_sysreg()? In this case it will magically work.
> >  Also, you could try to write a test which tries to overwrite xzr. Something like:
> > 
> > volatile int *addr1;
> > volatile int *addr2;
> > 
> > asm volatile("str %3, [%1]\n\t"
> >              "ldr wzr, [%1]\n\t"
> >              "str wzr, [%2]\n\t",
> >              "ldr %0, [%2]\n\t"
> >              :"=r"(res):"r"(addr1), "r"(addr2), "r"(some_nonzero_val):"memory");
> > 
> >  Then check for res == some_nonzero_val. If they are equal, you've got the bug :)
> >
> 
> Besides the fixes mentioned in other mails, I did add this load to xzr
> tests too. For mmio we get the expected failure. mrs seems to work
> though, but maybe that's expected.
> 
> qemu-system-aarch64 -machine virt,accel=kvm -cpu host \
>   -device virtio-serial-device -device virtconsole,chardev=ctd \
>   -chardev testdev,id=ctd -display none -serial stdio \
>   -kernel arm/xzr-test.flat -smp 2
> 
> PASS: mmio: sanity check: read 0x55555555
> FAIL: mmio: 'str wzr' check: read 0x0badc0de
> FAIL: mmio: 'ldr wzr' check: read 0x0badc0de
> PASS: sysreg: sp = 0x00000000401affe0
> FAIL: sysreg: from xzr check: read 0xffffc0de0badc0de
> PASS: sysreg: to xzr check: read 0x0000000000000000
>

I messed up the "load into xzr" test royally in the last attached patch.
It was quite wrong. I have now tested

 asm volatile(
     "str %3, [%1]\n\t"
     "ldr wzr, [%1]\n\t"
     "str wzr, [%2]\n\t"
     "ldr %0, [%2]\n\t"
     :"=r"(val):"r"(addr), "r"(addr2), "r"(0x55555555):"memory");
report("mmio: 'ldr wzr' check: read 0x%08lx", val != 0x55555555, val);

which passes and

 val = readl(addr);
 printf("addr = 0x%08lx\n", val);
 val = readl(addr2);
 printf("addr2 = 0x%08lx\n", val);

gives

addr = 0x55555555
addr2 = 0x00000000

So it looks like we don't "change" xzr somehow with loads. Anyway, I
probably won't clean this test up and post it. I don't think we really
need to add it as a regression test, unless others disagree and would
like to see it added.

Thanks,
drew
