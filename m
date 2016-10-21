From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: v4.9-rc1 fails booting as a guest on ARM64 Cavium ThunderX
Date: Fri, 21 Oct 2016 09:45:20 +0100
Message-ID: <de2acaca-f694-be1a-5d2c-93fcf3b25011@arm.com>
References: <924fd627-329a-54e0-694c-a9bdf979f696@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A27CD49B3D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 04:34:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bgampmHOivvF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Oct 2016 04:34:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8290949B2C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 04:34:55 -0400 (EDT)
In-Reply-To: <924fd627-329a-54e0-694c-a9bdf979f696@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Robert Richter <robert.richter@caviumnetworks.com>, daniel.thompson@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

+Robert

On 21/10/16 08:01, Auger Eric wrote:
> Hi,
> 
> I am not able to boot 4.9-rc1 as a guest on Cavium ThunderX (dt and acpi
> mode). Bisecting the guest shows that the problem shows up at
> 
> 91ef84428a86b75a52e15c6fe4f56b446ba75f93
> irqchip/gic-v3: Reset BPR during initialization
> 
> If I remove the write to the ICC_BPR1_EL1 register on guest, the VM boots.

That's very odd. A ICC_BPR1_EL1 access when HCR_EL2.IMO is set only
affects ICH_VMCR_EL2.VBPR1. It is not trapped, since we don't set
ICH_HCR_EL2.TALL1. It is a very boring sysreg!

So from a pure architectural point of view, I don't see how this can
fail. I've just run the same configuration on my Freescale board (GICv3
as well), and can't see any issue at all.

> Investigating KVM code ...

What is the failure syndrome? Do you see it crashing? Locking up? What
is the PC at that stage?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
