From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: GICv3 stride issue with many VCPUs
Date: Mon, 3 Sep 2018 15:15:07 +0200
Message-ID: <20180903131507.GM4029@e113682-lin.lund.arm.com>
References: <20180903111130.GG4029@e113682-lin.lund.arm.com>
 <b6988290-7dec-cc86-d84c-d4eb36f1f97f@redhat.com>
 <20180903123119.2z5tko3kaqcezfai@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FF704A1D2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 09:15:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5+VENcvTcnud for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Sep 2018 09:15:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89B654A0CC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 09:15:10 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180903123119.2z5tko3kaqcezfai@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Sep 03, 2018 at 02:31:19PM +0200, Andrew Jones wrote:
> On Mon, Sep 03, 2018 at 01:39:12PM +0200, Auger Eric wrote:
> > Hi Christoffer,
> > 
> > On 09/03/2018 01:11 PM, Christoffer Dall wrote:
> > > Hi,
> > > 
> > > I recently ran kvm-unit-tests on TX2, and I got an error from gicv3-ipi,
> > > with this in the log:
> > > 
> > >   % cat logs/gicv3-ipi.log
> > >   timeout -k 1s --foreground 90s ../src/qemu/build/aarch64-softmmu/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host,accel=kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/gic.flat -smp 224 -machine gic-version=3 -append ipi # -initrd /tmp/tmp.Xy3T5zjn9n
> > >   lib/arm/gic-v3.c:25: assert failed: 0
> > >           STACK:
> > 
> > Quickly looking at gicv3_set_redist_base(), I noted a single contiguous
> > redistributor region seems to be used: void *ptr =
> > gicv3_data.redist_base[0];
> > 
> > Supporting more than 123 vcpus requires to use the 2 separate
> > redistributor regions exposed by lastest QEMU mach-virt. I suspect the
> > kvm-unit-test is not using both redist regions yet.
> 
> Nope. I didn't have any hardware to test that on yet :-) I can write a
> patch, though, and send it to Christoffer to test. Or, if Christoffer
> doesn't mind hacking kvm-unit-tests, I'd be happy to review his patch :-)
> 

I'm quite caugt up at the moment, so if you could write a patch, I'll be
happy to test.

Thanks,

    Christoffer
