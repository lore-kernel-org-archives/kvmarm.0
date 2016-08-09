From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC PATCH v2 0/4] arm/arm64: vgic-new: Implement API for vGICv3
 live migration
Date: Tue, 9 Aug 2016 12:52:54 +0100
Message-ID: <CAFEAcA-z+iM+=p0riWreJCewPPxw9wtHgg+_4MDtxV=ccwe-tg@mail.gmail.com>
References: <1470740326-27751-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C35149B65
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 07:46:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C2bl51TWHTnr for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2016 07:46:09 -0400 (EDT)
Received: from mail-ua0-f170.google.com (mail-ua0-f170.google.com
 [209.85.217.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C84A949B55
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 07:46:08 -0400 (EDT)
Received: by mail-ua0-f170.google.com with SMTP id k90so15468236uak.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Aug 2016 04:53:15 -0700 (PDT)
In-Reply-To: <1470740326-27751-1-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vijay Kilari <vijay.kilari@gmail.com>
Cc: "prasun.kapoor" <Prasun.Kapoor@cavium.com>, Marc Zyngier <marc.zyngier@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 9 August 2016 at 11:58,  <vijay.kilari@gmail.com> wrote:
> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>
> This patchset adds API for saving and restoring
> of VGICv3 registers to support live migration with new vgic feature.
> This API definition is as per version of VGICv3 specification
> http://lists.infradead.org/pipermail/linux-arm-kernel/2016-July/445611.html
>
> To test live migration with QEMU, use below patch series
> https://lists.gnu.org/archive/html/qemu-devel/2016-08/msg01444.html
>
> The patch 3 & 4 are picked from the Pavel's previous implementation.
> http://www.spinics.net/lists/kvm/msg122040.html
>
> v1 => v2:
>  - The init sequence change patch is no more required.
>    Fixed in patch 2 by using static vgic_io_dev regions structure instead
>    of using dynamic allocation pointer.
>  - Updated commit message of patch 4.
>  - Dropped usage of union to manage 32-bit and 64-bit access in patch 1.
>    Used local variable for 32-bit access.
>  - Updated macro __ARM64_SYS_REG and ARM64_SYS_REG in
>    arch/arm64/include/uapi/asm/kvm.h as per qemu requirements.

I only scanned briefly through this patchset, but I didn't
see any code implementing:
 * KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO
 * the different behaviour for accesses to GICD_STATUSR, GICR_STATUSR,
   GICD_ISPENDR, GICR_ISPENDR0, GICD_ICPENDR, and GICR_ICPENDR0, which
   don't act the same via this API as for a guest access to the register

Did I miss something?

thanks
-- PMM
