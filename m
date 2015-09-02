From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 00/14] arm64: 16K translation granule support
Date: Wed, 2 Sep 2015 11:55:10 +0200
Message-ID: <CAKv+Gu-fbC9hFj4cvGWd4sEvxPaR-nfgWS7C+e+jdRTGKOtp4A@mail.gmail.com>
References: <1439465645-22584-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0662421ED
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2015 05:54:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gj-B5veXZ2DQ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2015 05:54:50 -0400 (EDT)
Received: from mail-io0-f176.google.com (mail-io0-f176.google.com
 [209.85.223.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C409A41F7F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2015 05:54:50 -0400 (EDT)
Received: by iofh134 with SMTP id h134so13909273iof.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Sep 2015 02:55:11 -0700 (PDT)
In-Reply-To: <1439465645-22584-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 13 August 2015 at 13:33, Suzuki K. Poulose <suzuki.poulose@arm.com> wrote:
> From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
>
> This series enables the 16K page size support on Linux for arm64.
> This series adds support for 48bit VA(4 level), 47bit VA(3 level) and
> 36bit VA(2 level) with 16K. 16K was a late addition to the architecture
> and is not implemented by all CPUs. Added a check to ensure the
> selected granule size is supported by the CPU, failing which the CPU
> won't proceed with booting.
>
> KVM bits have been tested on a fast model with GICv3 using Andre's kvmtool
> with gicv3 support[1].
>
> Patches 1-7 cleans up the kernel page size handling code.
> Patches 8-11 Fixes some issues with the KVM bits, mainly the fake PGD
>              handling code.
> Patch 12    Adds a check to ensure the CPU supports the selected granule size.
> Patch 13-14 Adds the 16k page size support bits.
>
> This series applies on top of for-next/core branch of the aarch64 tree and is
> also available here:
>
>         git://linux-arm.org/linux-skp.git  16k/v1
>


Hi Suzuki,

I have given this a spin on the FVP Base model to check UEFI booting,
and everything seems to work fine. (I tested 2-level and 3-level)
I didn't test the KVM changes, so for all patches except those:

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Regards,
Ard.
