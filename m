From: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH 00/14] arm64: 16K translation granule support
Date: Wed, 02 Sep 2015 11:11:05 +0100
Message-ID: <55E6CB39.5000305@arm.com>
References: <1439465645-22584-1-git-send-email-suzuki.poulose@arm.com>
 <CAKv+Gu-fbC9hFj4cvGWd4sEvxPaR-nfgWS7C+e+jdRTGKOtp4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DD0941390
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2015 06:10:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yOGnHHYkGZ4N for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2015 06:10:47 -0400 (EDT)
Received: from eu-smtp-delivery-143.mimecast.com
 (eu-smtp-delivery-143.mimecast.com [207.82.80.143])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D05E34130B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2015 06:10:46 -0400 (EDT)
In-Reply-To: <CAKv+Gu-fbC9hFj4cvGWd4sEvxPaR-nfgWS7C+e+jdRTGKOtp4A@mail.gmail.com>
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
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 02/09/15 10:55, Ard Biesheuvel wrote:
> On 13 August 2015 at 13:33, Suzuki K. Poulose <suzuki.poulose@arm.com> wrote:
>> From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
>>

>> Patches 1-7 cleans up the kernel page size handling code.
>> Patches 8-11 Fixes some issues with the KVM bits, mainly the fake PGD
>>               handling code.
>> Patch 12    Adds a check to ensure the CPU supports the selected granule size.
>> Patch 13-14 Adds the 16k page size support bits.
>>
>> This series applies on top of for-next/core branch of the aarch64 tree and is
>> also available here:
>>
>>          git://linux-arm.org/linux-skp.git  16k/v1
>>
>
>
> Hi Suzuki,
>
> I have given this a spin on the FVP Base model to check UEFI booting,
> and everything seems to work fine. (I tested 2-level and 3-level)
> I didn't test the KVM changes, so for all patches except those:
>
> Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Thanks for the review and testing !!

Suzuki
