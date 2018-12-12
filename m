From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool 1/6] rtc: Initialize the Register D for MC146818
 RTC
Date: Wed, 12 Dec 2018 18:16:01 +0000
Message-ID: <20181212181601.7afcba1c@donnerap.cambridge.arm.com>
References: <1543922073-55530-1-git-send-email-julien.thierry@arm.com>
 <1543922073-55530-2-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08CF14A2BB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 13:16:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rHw3rsZ8HL+d for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Dec 2018 13:16:06 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B54884A200
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 13:16:06 -0500 (EST)
In-Reply-To: <1543922073-55530-2-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: Sami.Mujawar@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

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

This is quite interesting: we build the RTC emulation unconditionally
for every architecture, but don't expose it in the DT (for arm/arm64).
The Linux driver can't even be configured for arm64.
Interestingly it works if one pokes 0x70 and 0x71 directly in memory
from a guest. Which sounds hackish (do we want that?), but fits more a
less the firmware use case. We would just need to make sure it actually
works correctly on ARM, since nobody tested this properly before.

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
>  #define RTC_REG_C			0x0C
>  #define RTC_REG_D			0x0D
>  
> +/*
> + * Register D Bits
> + */
> +#define RTC_REG_D_VRT			(1 << 7)
> +
>  struct rtc_device {
>  	u8			cmos_idx;
>  	u8			cmos_data[128];
> @@ -140,6 +145,9 @@ int rtc__init(struct kvm *kvm)
>  		return r;
>  	}
>  
> +	/* Set the VRT bit in Register D to indicate valid RAM and
> time */
> +	rtc.cmos_data[RTC_REG_D] = RTC_REG_D_VRT;
> +
>  	return r;
>  }
>  dev_init(rtc__init);
