From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: KVM on ARM Cortex A53 in 32-bit Mode
Date: Tue, 7 Mar 2017 01:55:59 -0800
Message-ID: <20170307095559.GB101711@lvm>
References: <CAPn9co60wgUms-V_6PBB4CDKeWV_mJzHqg-5wjTchKFi4G9xkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7035340A80
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Mar 2017 04:54:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id erWvp25+bp+i for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Mar 2017 04:54:40 -0500 (EST)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 49CFB40A54
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Mar 2017 04:54:40 -0500 (EST)
Received: by mail-wm0-f44.google.com with SMTP id v203so9114074wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Mar 2017 01:56:01 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAPn9co60wgUms-V_6PBB4CDKeWV_mJzHqg-5wjTchKFi4G9xkg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Yasutaka Tanaka <yt2558@columbia.edu>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Yasutaka,

On Thu, Mar 02, 2017 at 09:57:50AM -0500, Yasutaka Tanaka wrote:
> Hello KVM/ARM community,
> 
> I am now trying to execute KVM on Raspberry Pi 3 Model B (RPI3).
> Does anyone know whether KVM/ARM can run with 32-bit mode on ARM Cortex A53?

Theoretically, it should.

> 
> The CPU of RPI3 is ARM Cortex A53 which can be executed in both 32-bit and
> 64-bit mode. I've managed to display /dev/kvm on 64-bit mode execution
> (i.e. with a 64-bit linux kernel) on RPI3, but I failed to do so in 32-bit
> mode.
> 
> In 32-bit mode, an KVM error messages says CPU not supported. I guess the
> reason for the error message is KVM_ARM_TARGET_CORTEX_A53 is only returned
> in /arch/arm64/kvm/guest.c not under/arch/arm/kvm/guest.c.
> 
> So I'm wondering whether it's possible or not. 

It should be.  You may just have to add the minimal missing definitions
for a 32-bit A53 CPU support.

> What I'd like to do is to
> compare the execution speed of KVM between 32-bit and 64-bit mode. The
> second plan is to compare between KVMs of 32-bit RPI2 and 64-bit RPI3 (I
> have both), but since RPI2 spec is a little low and I'm worried that some
> numeric comparisons become unfair.

I would be careful here, since the RPI3 doesn't have the GIC and you'll
end up going to user space a lot for interrupt handling.  Especially
look out for SMP workloads in the VM which may generate a lot of IPIs
which are really going to suffer from having to go to userspace on the
host.

> 
> (I was also notified by an KVM/ARM expert that since RPI doesn't have a GIC
> and I need to apply some patches)

Yes, you need the "Support userspace irqchip with arch timers" series
and corresponding QEMU patches:

http://www.spinics.net/lists/kvm/msg144685.html

Good luck.
-Christoffer
