From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v10 6/8] arm/arm64: vgic: Implement VGICv3 CPU interface
 access
Date: Fri, 20 Jan 2017 20:27:49 +0100
Message-ID: <20170120192749.GG13531@cbox>
References: <1480576187-5012-1-git-send-email-vijay.kilari@gmail.com>
 <1480576187-5012-7-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E230D4095A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jan 2017 14:27:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6d8iqcPc24o0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Jan 2017 14:27:56 -0500 (EST)
Received: from mail-lf0-f51.google.com (mail-lf0-f51.google.com
 [209.85.215.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A975B40783
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jan 2017 14:27:56 -0500 (EST)
Received: by mail-lf0-f51.google.com with SMTP id k86so63774518lfi.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jan 2017 11:27:56 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1480576187-5012-7-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: vijay.kilari@gmail.com
Cc: marc.zyngier@arm.com, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 01, 2016 at 12:39:45PM +0530, vijay.kilari@gmail.com wrote:
> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> 
> VGICv3 CPU interface registers are accessed using
> KVM_DEV_ARM_VGIC_CPU_SYSREGS ioctl. These registers are accessed
> as 64-bit. The cpu MPIDR value is passed along with register id.
> is used to identify the cpu for registers access.
> 
> The VM that supports SEIs expect it on destination machine to handle
> guest aborts and hence checked for ICC_CTLR_EL1.SEIS compatibility.
> Similarly, VM that supports Affinity Level 3 that is required for AArch64
> mode, is required to be supported on destination machine. Hence checked
> for ICC_CTLR_EL1.A3V compatibility.
> 
> The arch/arm64/kvm/vgic-sys-reg-v3.c handles read and write of VGIC
> CPU registers for AArch64.
> 
> For AArch32 mode, arch/arm/kvm/vgic-v3-coproc.c file is created but
> APIs are not implemented.
> 
> Updated arch/arm/include/uapi/asm/kvm.h with new definitions
> required to compile for AArch32.
> 
> The version of VGIC v3 specification is define here
> Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> ---

With Eric's comments addressed on this patch, it now looks good to me.

-Christoffer
