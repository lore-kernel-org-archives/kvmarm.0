From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Thu, 19 Feb 2015 17:57:32 +0100
Message-ID: <20150219165731.GA26965@hawk.usersys.redhat.com>
References: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2811C45FC3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 11:52:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 76eFK-PZh4YO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Feb 2015 11:52:14 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E36B45FB4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 11:52:13 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, lersek@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 19, 2015 at 10:54:43AM +0000, Ard Biesheuvel wrote:
> This is a 0th order approximation of how we could potentially force the guest
> to avoid uncached mappings, at least from the moment the MMU is on. (Before
> that, all of memory is implicitly classified as Device-nGnRnE)
> 
> The idea (patch #2) is to trap writes to MAIR_EL1, and replace uncached mappings
> with cached ones. This way, there is no need to mangle any guest page tables.
> 
> The downside is that, to do this correctly, we need to always trap writes to
> the VM sysreg group, which includes registers that the guest may write to very
> often. To reduce the associated performance hit, patch #1 introduces a fast path
> for EL2 to perform trivial sysreg writes on behalf of the guest, without the
> need for a full world switch to the host and back.
> 
> The main purpose of these patches is to quantify the performance hit, and
> verify whether the MAIR_EL1 handling works correctly. 
> 
> Ard Biesheuvel (3):
>   arm64: KVM: handle some sysreg writes in EL2
>   arm64: KVM: mangle MAIR register to prevent uncached guest mappings
>   arm64: KVM: keep trapping of VM sysreg writes enabled

Hi Ard,

I took this series for test drive. Unfortunately I have bad news and worse
news. First, a description of the test; simply boot a guest, once at login,
login, and then shutdown with 'poweroff'. The guest boots through AAVMF using
a build from Laszlo that enables PCI, but does *not* have the 'map pci mmio
as cached' kludge. This test allows us to check for corrupt vram on the
graphical console, plus it completes a boot/shutdown cycle allowing us to
count sysreg traps of the boot/shutdown cycle.

So, the bad news

Before this series we trapped 50 times on sysreg writes with the test
described above. With this series we trap 62873 times. But, less than
20 required going to EL1.

(I don't have an exact number for how many times it went to EL1 because
 access_mair() doesn't have a trace point.)
(I got the 62873 number by testing a 3rd kernel build that only had patch
 3/3 applied to the base, and counting kvm_toggle_cache events.)
(The number 50 is the number of kvm_toggle_cache events *without* 3/3
 applied.)

I consider this bad news because, even considering it only goes to EL2,
it goes a ton more than it used to. I realize patch 3/3 isn't the final
plan for enabling traps though.

And, now the worse news

The vram corruption persists with this patch series.

drew


> 
>  arch/arm/kvm/mmu.c               |   2 +-
>  arch/arm64/include/asm/kvm_arm.h |   2 +-
>  arch/arm64/kvm/hyp.S             | 101 +++++++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c        |  63 ++++++++++++++++++++----
>  4 files changed, 156 insertions(+), 12 deletions(-)
> 
> -- 
> 1.8.3.2
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
