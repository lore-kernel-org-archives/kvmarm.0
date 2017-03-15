From: Keerthy <j-keerthy@ti.com>
Subject: Re: [PATCH v3 00/25] arm/arm64: KVM: Rework the hyp-stub API
Date: Wed, 15 Mar 2017 07:55:49 +0530
Message-ID: <b9365064-d529-3957-f91c-da11d77f1abc@ti.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com>
 <8493dac7-c9be-fd3b-c5c0-83fbbfa4af10@ti.com>
 <8d2cf6fa-cac7-268b-bc26-2649f5696196@arm.com>
 <CAGo_u6rHmn676_PZYj+6LGf-bRBBxdn1=PYX32o-_ki=OBXs-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BCB440B40
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Mar 2017 22:24:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZInJogdbWfgm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Mar 2017 22:24:32 -0400 (EDT)
Received: from fllnx210.ext.ti.com (fllnx210.ext.ti.com [198.47.19.17])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 89EC140625
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Mar 2017 22:24:32 -0400 (EDT)
In-Reply-To: <CAGo_u6rHmn676_PZYj+6LGf-bRBBxdn1=PYX32o-_ki=OBXs-g@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Nishanth Menon <nm@ti.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: cdall@linaro.org, Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu



On Tuesday 14 March 2017 07:55 PM, Nishanth Menon wrote:
> On Tue, Mar 14, 2017 at 8:55 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> [...]
>>> Tested for kexec booting with the patch series applied on linux-next.
>>>
>>> kexec is working nicely with HYP and SVC modes. Tested for both modes by
>>> using different u-boot for booting in HYP and SVC modes. Kexec works well.
>>>
>>> Tested on DRA7-EVM, AM57XX-EVM and KEYSTONE-K2E-EVM.
>>>
>>> Tested-by: Keerthy <j-keerthy@ti.com>
>>
>> Thanks a lot. I assume this Tested-by applies to the 32bit patches in
>> this series?
> 
> Yes, the above platform list from Keerthy are all A15 32bit platforms.

Yes Marc. All are 32 bit platforms.

> 
> ---
> Regards,
> Nishanth Menon
> 
