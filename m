From: Christoffer Dall <cdall@linaro.org>
Subject: Re: KVM on ARM Cortex A53 in 32-bit Mode
Date: Thu, 16 Mar 2017 10:38:49 +0100
Message-ID: <20170316093849.GT1277@cbox>
References: <CAPn9co60wgUms-V_6PBB4CDKeWV_mJzHqg-5wjTchKFi4G9xkg@mail.gmail.com>
 <20170307095559.GB101711@lvm>
 <CAO=Ss3XeBW17XfXroKsS-KbHcJV1E7c8gDBP+CnhyNYDMpeXsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EC8340BAC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 05:37:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vD3XwHB9e3Dn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Mar 2017 05:37:26 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DD83B40B3E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 05:37:25 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id n11so42623823wma.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 02:39:03 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAO=Ss3XeBW17XfXroKsS-KbHcJV1E7c8gDBP+CnhyNYDMpeXsg@mail.gmail.com>
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

On Wed, Mar 15, 2017 at 07:50:36PM -0400, Yasutaka, T wrote:
> Hi Christopher and other KVM/ARM community members,
> 
> I tried the following QEMU and Kernel combinations on Raspberry Pi 3
> (AArch64 mode) but failed:
> 
> Latest commit of Alexander Graf's no-kvm-irqchip QEMU branch:
> https://github.com/agraf/qemu/tree/no-kvm-irqchip
> 
> raspberrypi/linux's rpi-4.10.y branch (forked from Linux 4.10-rc8?) latest
> commit bb0ff9d059c67e1611c7422f7982a6a4876efe67
> patched by $(git diff (linux 4.10-rc5 commit
> 7a308bb3016f57e5be11a677d15b821536419d36) (Christpher's irqs-to-user-v2
> latest commit d0a7cc725535df1b9cc64b442d246c20a9edb904) )
> 
> and got the following error:
> 
> pi@raspberrypi:~/os/graf/no-kvm-irqchip/aarch64-softmmu $
> qemu-system-aarch64 --enable-kvm -M virt
> "kvm" accelerator not found.
> No accelerator found!

You'd need "-machine virt,kernel_irqchip=off" to use the userspace GIC
emulation.  Perhaps QEMU's error message for trying to initialize the
in-kernel GIC is just weird.

> 
> pi@raspberrypi:~/os/graf/no-kvm-irqchip/aarch64-softmmu $ lkvm run test
>   # lkvm run -k test -m 448 -c 4 --name guest-1605
>   Error: Unsupported KVM extension detected: KVM_CAP_IRQCHIP
>   Fatal: Failed to create virtual GIC

I don't think kvmtool supports running on a system that doesn't have
in-kernel GIC support.

> 
> 
> which seems strange for me because dmesg shows kernel is 4.10.2-v8+ and
> Boot CPU is AArach64, all CPUs are initialized in HYP mode and /dev/kvm
> exists. So I thought GIC emulation is also enabled, or should I need to
> enable other config flags or do settings?

The RPI3 doesn't have a GIC, so you'll never get KVM emulation of the
GIC with that board.  Ever.  That's why you want the irqchip in
userspace patches.

> Or, is this way of applying patch
> wrong? Current config.gz is:
> https://gist.github.com/caprice-j/d6e144cb8727df813a4fbe716beac3cb
> 
> My other concerns are no kvm-ok command is available and /proc/cpuinfo does
> not show flags for virtualization support (I believe RPI3's cortex A53
> (ARMv8) has builtin virt support and does not show the support flag
> explicitly in /proc/cpuinfo ... but I'm unsure that is true)

If you have /dev/kvm then KVM as such is running on your system, no need
to worry further, just fix your setup to emulate the GIC in userspace.

Thanks,
-Christoffer
