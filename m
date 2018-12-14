From: Sami Mujawar <Sami.Mujawar@arm.com>
Subject: RE: [PATCH kvmtool 1/6] rtc: Initialize the Register D for MC146818
 RTC
Date: Fri, 14 Dec 2018 18:58:13 +0000
Message-ID: <DB6PR0802MB2375C8F28CBDBF7DD7B38AF084A10@DB6PR0802MB2375.eurprd08.prod.outlook.com>
References: <1543922073-55530-1-git-send-email-julien.thierry@arm.com>
 <1543922073-55530-2-git-send-email-julien.thierry@arm.com>
 <20181212181601.7afcba1c@donnerap.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C82774A320
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Dec 2018 13:58:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gs4S1T5fL-eK for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Dec 2018 13:58:17 -0500 (EST)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-eopbgr80041.outbound.protection.outlook.com [40.107.8.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 563C24A2E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Dec 2018 13:58:17 -0500 (EST)
In-Reply-To: <20181212181601.7afcba1c@donnerap.cambridge.arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <Andre.Przywara@arm.com>, Julien Thierry <Julien.Thierry@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

We are using the edk2 PcAtChipsetPkg/PcatRealTimeClockRuntimeDxe RTC driver. This RTC driver derives the IO port values for the Index and Target register from Pcds (Platform Configuration Database), which can be considered as constants defined at build time, so sort of hardcoded.
We have also added MMIO capability to this driver (enabled by setting the PcdRtcUseMmio to TRUE). This change effectively performs MMIO accesses on 0x70 and 0x71.

Regards,

Sami Mujawar

-----Original Message-----
From: Andre Przywara <andre.przywara@arm.com>
Sent: 12 December 2018 06:16 PM
To: Julien Thierry <Julien.Thierry@arm.com>
Cc: kvm@vger.kernel.org; kvmarm@lists.cs.columbia.edu; Will Deacon <Will.Deacon@arm.com>; Sami Mujawar <Sami.Mujawar@arm.com>; Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [PATCH kvmtool 1/6] rtc: Initialize the Register D for MC146818 RTC

On Tue,  4 Dec 2018 11:14:28 +0000
Julien Thierry <julien.thierry@arm.com> wrote:

> From: Sami Mujawar <sami.mujawar@arm.com>
>
> Some software drivers check the VRT bit (BIT7) of Register D before
> using the MC146818 RTC. Initialized the VRT bit in rtc__init() to
> indicate that the RAM and time contents are valid.
>
> Signed-off-by: Sami Mujawar <sami.mujawar@arm.com>
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>

Checked against the data sheet.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

This is quite interesting: we build the RTC emulation unconditionally for every architecture, but don't expose it in the DT (for arm/arm64).
The Linux driver can't even be configured for arm64.
Interestingly it works if one pokes 0x70 and 0x71 directly in memory from a guest. Which sounds hackish (do we want that?), but fits more a less the firmware use case. We would just need to make sure it actually works correctly on ARM, since nobody tested this properly before.

I guess EDK2 would just hardcode the address?

Cheers,
Andre.

> ---
>  hw/rtc.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/hw/rtc.c b/hw/rtc.c
> index 0649b5d..c1fa72f 100644
> --- a/hw/rtc.c
> +++ b/hw/rtc.c
> @@ -25,6 +25,11 @@
>  #define RTC_REG_C0x0C
>  #define RTC_REG_D0x0D
>
> +/*
> + * Register D Bits
> + */
> +#define RTC_REG_D_VRT(1 << 7)
> +
>  struct rtc_device {
>  u8cmos_idx;
>  u8cmos_data[128];
> @@ -140,6 +145,9 @@ int rtc__init(struct kvm *kvm)
>  return r;
>  }
>
> +/* Set the VRT bit in Register D to indicate valid RAM and
> time */
> +rtc.cmos_data[RTC_REG_D] = RTC_REG_D_VRT;
> +
>  return r;
>  }
>  dev_init(rtc__init);

IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
