From: Christoffer Dall <cdall@linaro.org>
Subject: Re: KVM on ARM Cortex A53 in 32-bit Mode
Date: Fri, 17 Mar 2017 09:52:15 +0100
Message-ID: <20170317085215.GW1277@cbox>
References: <CAPn9co60wgUms-V_6PBB4CDKeWV_mJzHqg-5wjTchKFi4G9xkg@mail.gmail.com>
 <20170307095559.GB101711@lvm>
 <CAO=Ss3XeBW17XfXroKsS-KbHcJV1E7c8gDBP+CnhyNYDMpeXsg@mail.gmail.com>
 <20170316093849.GT1277@cbox>
 <CAO=Ss3WXPSOfMHd2gg0W2gngtH6c0hvatw-kKHZWb34JC=ba-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28EDA40A63
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Mar 2017 04:50:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 663rfusSmDCT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Mar 2017 04:50:52 -0400 (EDT)
Received: from mail-wr0-f181.google.com (mail-wr0-f181.google.com
 [209.85.128.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC67740905
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Mar 2017 04:50:51 -0400 (EDT)
Received: by mail-wr0-f181.google.com with SMTP id l37so47530465wrc.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Mar 2017 01:52:30 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAO=Ss3WXPSOfMHd2gg0W2gngtH6c0hvatw-kKHZWb34JC=ba-g@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Yasutaka, T" <skyfly0008@gmail.com>
Cc: Yasutaka Tanaka <yt2558@columbia.edu>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 17, 2017 at 01:09:22AM -0400, Yasutaka, T wrote:
> 2017-03-16 5:38 GMT-04:00 Christoffer Dall <cdall@linaro.org>:
> 
> > On Wed, Mar 15, 2017 at 07:50:36PM -0400, Yasutaka, T wrote:
> > > Hi Christopher and other KVM/ARM community members,
> > >
> > > I tried the following QEMU and Kernel combinations on Raspberry Pi 3
> > > (AArch64 mode) but failed:
> > >
> > > Latest commit of Alexander Graf's no-kvm-irqchip QEMU branch:
> > > https://github.com/agraf/qemu/tree/no-kvm-irqchip
> > >
> > > raspberrypi/linux's rpi-4.10.y branch (forked from Linux 4.10-rc8?)
> > latest
> > > commit bb0ff9d059c67e1611c7422f7982a6a4876efe67
> > > patched by $(git diff (linux 4.10-rc5 commit
> > > 7a308bb3016f57e5be11a677d15b821536419d36) (Christpher's irqs-to-user-v2
> > > latest commit d0a7cc725535df1b9cc64b442d246c20a9edb904) )
> > >
> > > and got the following error:
> > >
> > > pi@raspberrypi:~/os/graf/no-kvm-irqchip/aarch64-softmmu $
> > > qemu-system-aarch64 --enable-kvm -M virt
> > > "kvm" accelerator not found.
> > > No accelerator found!
> >
> > You'd need "-machine virt,kernel_irqchip=off" to use the userspace GIC
> > emulation.  Perhaps QEMU's error message for trying to initialize the
> > in-kernel GIC is just weird.
> >
> 
> I executed with the flag but still got the same error message (accelerator
> not found):
> 
> qemu-system-aarch64 --enable-kvm -cpu host -machine
> type=virt,kernel_irqchip=off -nographic -smp 1 -m 256 -kernel
> aarch64-linux-3.15rc2-buildroot.img --append "console=ttyAMA0"
> 
> 
> And I found out that an article saying recent OpenSUSE distro officialy
> supports KVM:
> https://news.opensuse.org/2016/12/05/opensuse-leap-42-2-gets-64-bit-raspberry-image/
> 
> The developer of this distro is the same as the kernel_irqchip=off QEMU
> patch author (Alexander Graf), and when I tried the above command on this
> [1] distro KVM-QEMU actually worked ("worked" means it reaches to the
> buildroot login prompt).
> 
> So I guess this distro applied your patches (it proves KVM/QEMU on RPI3 is
> actually feasible) and the central reason that my failure of KVM on
> Raspibian OS would be just a kernel config problem.
> 
> I set my .config file by make menuconfig, but it might need some other
> (potentially non-GUI?) configurations. My current config is:
> https://gist.github.com/caprice-j/836e3c7627f65c0f3a79e56a8d75368e

I thought you said you had /dev/kvm ?  Then I'm not sure why it wouldn't
work, or why you're looking at kernel config issues.

It would be worthwhile debugging QEMU and figuring out why you get that
error.

printf in QEMU should work just fine and there should also be mechanisms
to increase the log level and diagnostics in QEMU.

-Christoffer
