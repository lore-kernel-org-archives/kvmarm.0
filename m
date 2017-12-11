From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH v2 00/36] Optimize KVM/ARM for VHE systems
Date: Mon, 11 Dec 2017 17:43:23 +0300
Message-ID: <20171211144323.firshrsx4dbumgou@yury-thinkpad>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CE5949D75
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 09:40:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WYBPljGAqreS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Dec 2017 09:40:23 -0500 (EST)
Received: from NAM01-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam01on0041.outbound.protection.outlook.com [104.47.32.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2D5D349D69
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 09:40:23 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171207170630.592-1-christoffer.dall@linaro.org>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On Thu, Dec 07, 2017 at 06:05:54PM +0100, Christoffer Dall wrote:
> This series redesigns parts of KVM/ARM to optimize the performance on
> VHE systems.  The general approach is to try to do as little work as
> possible when transitioning between the VM and the hypervisor.  This has
> the benefit of lower latency when waiting for interrupts and delivering
> virtual interrupts, and reduces the overhead of emulating behavior and
> I/O in the host kernel.
> 
> Patches 01 through 04 are not VHE specific, but rework parts of KVM/ARM
> that can be generally improved.  We then add infrastructure to move more
> logic into vcpu_load and vcpu_put, we improve handling of VFP and debug
> registers.
> 
> We then introduce a new world-switch function for VHE systems, which we
> can tweak and optimize for VHE systems.  To do that, we rework a lot of
> the system register save/restore handling and emulation code that may
> need access to system registers, so that we can defer as many system
> register save/restore operations to vcpu_load and vcpu_put, and move
> this logic out of the VHE world switch function.
> 
> We then optimize the configuration of traps.  On non-VHE systems, both
> the host and VM kernels run in EL1, but because the host kernel should
> have full access to the underlying hardware, but the VM kernel should
> not, we essentially make the host kernel more privileged than the VM
> kernel despite them both running at the same privilege level by enabling
> VE traps when entering the VM and disabling those traps when exiting the
> VM.  On VHE systems, the host kernel runs in EL2 and has full access to
> the hardware (as much as allowed by secure side software), and is
> unaffected by the trap configuration.  That means we can configure the
> traps for VMs running in EL1 once, and don't have to switch them on and
> off for every entry/exit to/from the VM.
> 
> Finally, we improve our VGIC handling by moving all save/restore logic
> out of the VHE world-switch, and we make it possible to truly only
> evaluate if the AP list is empty and not do *any* VGIC work if that is
> the case, and only do the minimal amount of work required in the course
> of the VGIC processing when we have virtual interrupts in flight.
> 
> The patches are based on v4.15-rc1 plus the fixes sent for v4.15-rc3
> [1], the level-triggered mapped interrupts support series [2], and the
> first five patches of James' SDEI series [3], a single SVE patch that
> moves the CPU ID reg trap setup out of the world-switch path, and v3 of
> my vcpu load/put series [4].
> 
> I've given the patches a fair amount of testing on Thunder-X, Mustang,
> Seattle, and TC2 (32-bit) for non-VHE testing, and tested VHE
> functionality on the Foundation model, running both 64-bit VMs and
> 32-bit VMs side-by-side and using both GICv3-on-GICv3 and
> GICv2-on-GICv3.
> 
> The patches are also available in the vhe-optimize-v2 branch on my
> kernel.org repository [5].
> 
> Changes since v1:
>  - Rebased on v4.15-rc1 and newer versions of other dependencies,
>    including the vcpu load/put approach taken for KVM.
>  - Addressed review comments from v1 (detailed changelogs are in the
>    individual patches).
> 
> Thanks,
> -Christoffer
> 
> [1]: git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm kvm-arm-fixes-for-v4.15-1
> [2]: git://git.kernel.org/pub/scm/linux/kernel/git/cdall/linux.git level-mapped-v6
> [3]: git://linux-arm.org/linux-jm.git sdei/v5/base
> [4]: git://git.kernel.org/pub/scm/linux/kernel/git/cdall/linux.git vcpu-load-put-v3
> [5]: git://git.kernel.org/pub/scm/linux/kernel/git/cdall/linux.git vhe-optimize-v2

I just submitted the benchmark I used to test your v1 and v2 series':
https://lkml.org/lkml/2017/12/11/364

On ThunderX2, 112 online CPUs test results for v1 are like this:

Host, v4.14:
Dry-run:          0         1
Self-IPI:         9        18
Normal IPI:      81       110
Broadcast IPI:    0      2106

Guest, v4.14:
Dry-run:          0         1
Self-IPI:        10        18
Normal IPI:     305       525
Broadcast IPI:    0      9729

Guest, v4.14 + VHE:
Dry-run:          0         1
Self-IPI:         9        18
Normal IPI:     176       343
Broadcast IPI:    0      9885

And for v2.

Host, v4.15:                   
Dry-run:          0         1
Self-IPI:         9        18
Normal IPI:      79       108
Broadcast IPI:    0      2102
                        
Guest, v4.15-rc:
Dry-run:          0         1
Self-IPI:         9        18
Normal IPI:     291       526
Broadcast IPI:    0     10439

Guest, v4.15-rc + VHE:
Dry-run:          0         2
Self-IPI:        14        28
Normal IPI:     370       569
Broadcast IPI:    0     11688

All times are normalized to v1 host dry-run time. Smaller - better.

Results for v1 and v2 may vary because kernel version is changed. 
What makes us worry is slowing down the "Normal IPI" test observed in 
v2 series.

Nevertheless, if you find test relevant, for v1 and v2,
Tested-by: Yury Norov <ynorov@caviumnetworks.com>
