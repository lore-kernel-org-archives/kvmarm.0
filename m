From: Steve Capper <steve.capper@arm.com>
Subject: Re: [PATCH V2 2/7] arm64: mm: Flip kernel VA space
Date: Tue, 2 Jan 2018 08:57:08 +0000
Message-ID: <20180102085708.jbmyhvambtu5b7pa@capper-debian.cambridge.arm.com>
References: <20171218214736.13761-1-steve.capper@arm.com>
 <20171218214736.13761-3-steve.capper@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF42B40EA6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jan 2018 04:09:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RkRspEo+Jq-c for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Jan 2018 04:09:40 -0500 (EST)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01on0062.outbound.protection.outlook.com [104.47.0.62])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 44AAB40D25
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jan 2018 04:09:40 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171218214736.13761-3-steve.capper@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: catalin.marinas@arm.com, nd@arm.com, ard.biesheuvel@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 18, 2017 at 09:47:31PM +0000, Steve Capper wrote:
> Put the direct linear map in the lower addresses of the kernel VA range
> and everything else in the higher ranges.
> 
> This allows us to make room for an inline KASAN shadow that operates
> under both 48 and 52 bit kernel VA sizes. For example with a 52-bit VA,
> if KASAN_SHADOW_END < 0xFFF8000000000000 (it is in the lower addresses
> of the kernel VA range), this will be below the start of the minimum
> 48-bit kernel VA address of 0xFFFF000000000000.
> 
> We need to adjust:
>  *) KASAN shadow region placement logic,
>  *) KASAN_SHADOW_OFFSET computation logic,
>  *) virt_to_phys, phys_to_virt checks,
>  *) page table dumper.
> 
> These are all small changes, that need to take place atomically, so they
> are bundled into this commit.

I need to tweak this to include changes to the HYP map logic
(specifically change the first AND to an EOR).

Cheers,
-- 
Steve
