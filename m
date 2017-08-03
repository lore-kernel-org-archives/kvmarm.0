From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC PATCH v2 00/38] Nested Virtualization on KVM/ARM
Date: Thu, 3 Aug 2017 19:41:58 +0200
Message-ID: <20170803174157.7sw4fcqr4o3imxry@kamzik.brq.redhat.com>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
 <CAHyh4xjkT+JNJL0kxmEjz4qU8kD2-ZwYgVB8VgwsSYjpjTc3LA@mail.gmail.com>
 <jpgshhg7227.fsf@linux.bootlegged.copy>
 <CAHyh4xjhJ+uXSek3cayf9E-xjCYY2vt1L+KH2yWAoj469sXaXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3A3349C28
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Aug 2017 13:40:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U7a-6KTBvUMy for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Aug 2017 13:40:45 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D688740D8B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Aug 2017 13:40:44 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <CAHyh4xjhJ+uXSek3cayf9E-xjCYY2vt1L+KH2yWAoj469sXaXA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack.lim@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Bandan Das <bsd@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

(I trimmed the long CC list)

On Fri, Jul 28, 2017 at 05:45:01PM -0400, Jintack Lim wrote:
> On Fri, Jul 28, 2017 at 4:13 PM, Bandan Das <bsd@redhat.com> wrote:
> > Jintack Lim <jintack.lim@linaro.org> writes:
> > ...
> >>>
> >>> I'll share my experiment setup shortly.
> >>
> >> I summarized my experiment setup here.
> >>
> >> https://github.com/columbia/nesting-pub/wiki/Nested-virtualization-on-ARM-setup
> >
> > Thanks Jintack! I was able to test L2 boot up with these instructions.
> 
> Thanks for the confirmation!
> 
> >
> > Next, I will try to run some simple tests. Any suggestions on reducing the L2 bootup
> > time in my test setup ? I think I will try to make the L2 kernel print
> > less messages; and maybe just get rid of some of the userspace services.
> > I also applied the patch to reduce the timer frequency btw.
> 
> I think you can try to use those kernel parameters: "loglevel=1", with
> which the kernel print (almost) nothing during the boot process but
> the init process will print something,  or "console=none", with which
> you don't see anything but the login message.  I didn't used them
> because I wanted to see the L2 boot message as soon as possible :)
>

For some quick testing, kvm-unit-tests can be used as an L2 guest. Just
copy the repository with compiled unit tests to the L1 disk image and
then run

 $ ./run_tests.sh

Also, I've just added some support to it, available on this branch

 https://github.com/rhdrjones/kvm-unit-tests/commits/arm64/hyp-mode

that may make it somewhat useful for L1 guest testing too. I've only
tested on TCG (which supports starting CPUs in EL2 by setting the virt
model's virtualization property)

To use it for L1 guest testing, copy the repository with compiled unit
tests to the L0 disk image and run

 $ QEMU=/path/to/nested-qemu ./run_tests -- -cpu host,nested=true

I've also added tests that are specifically for L1 guest testing. Below
is the output of running them on TCG

 $ ./run_tests.sh -g hyp -- -machine virtualization=on
 PASS hyp (4 tests)
 $ cat logs/hyp.log 
 timeout -k 1s --foreground 90s /home/drjones/code/rhdrjones/build/q/aarch64-softmmu/qemu-system-aarch64 -nodefaults -machine virt,accel=tcg -cpu cortex-a57 -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/hyp.flat -smp 4 -machine virtualization=on # -initrd /tmp/tmp.hDF1mV9Ck8
 INFO: hyp: NR_CPUS=4
 PASS: hyp: started EL2
 PASS: hyp: el2: hvc
 PASS: hyp: eret to EL1
 PASS: hyp: el1: hvc
 PASS: hyp: reset: started EL2
 PASS: hyp: reset: el2: hvc
 PASS: hyp: reset: eret to EL1
 PASS: hyp: reset: el1: hvc
 SUMMARY: 4 tests

s/-machine virtualization=on/-cpu host,nested=true/ for the FastModel
environment. Maybe it'll work...

Thanks,
drew
