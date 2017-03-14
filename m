From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 00/25] arm/arm64: KVM: Rework the hyp-stub API
Date: Tue, 14 Mar 2017 13:55:22 +0000
Message-ID: <8d2cf6fa-cac7-268b-bc26-2649f5696196@arm.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com>
 <8493dac7-c9be-fd3b-c5c0-83fbbfa4af10@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E074400E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Mar 2017 09:53:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WynYtHtUrX85 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Mar 2017 09:53:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A4F540064
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Mar 2017 09:53:52 -0400 (EDT)
In-Reply-To: <8493dac7-c9be-fd3b-c5c0-83fbbfa4af10@ti.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Keerthy <j-keerthy@ti.com>, Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, cdall@linaro.org, james.morse@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


On 14/03/17 13:38, Keerthy wrote:
> 
> 
> On Monday 06 March 2017 07:54 PM, Marc Zyngier wrote:
>> As noticed by RMK in this thread[1], the hyp-stub API on 32bit ARM
>> could do with some TLC (it cannot perform a soft-restart at HYP, and
>> has holes in the hyp-stub support in a number of places). In general,
>> it would be desirable for the 32bit behaviour to align on 64bit, if
>> only to ease maintenance.
>>
>> This series implements the following:
>> - Add HVC_[GS]ET_VECTORS and HVC_SOFT_RESTART to the 32bit code
>> - Add HVC_RESET_VECTORS to both arm and arm64, removing the need for
>>   __hyp_reset_vectors
>> - Implement add the stub entry points in the KVM init code, which
>>   didn't implement any so far
>> - Convert the HYP code to use the init code stubs directly
>> - Some general cleanup as a result of these changes (which includes
>>   killing HVC_GET_VECTORS)
>> - Add some API documentation that covers the above
>>
>> Patches 9 to 11 would be better squashed into 7 and 8, but I've kept
>> separate so that I can take the blame for everything I've broken.
> 
> Tested for kexec booting with the patch series applied on linux-next.
> 
> kexec is working nicely with HYP and SVC modes. Tested for both modes by
> using different u-boot for booting in HYP and SVC modes. Kexec works well.
> 
> Tested on DRA7-EVM, AM57XX-EVM and KEYSTONE-K2E-EVM.
> 
> Tested-by: Keerthy <j-keerthy@ti.com>

Thanks a lot. I assume this Tested-by applies to the 32bit patches in
this series?

Cheers,

	M.
-- 
Jazz is not dead. It just smells funny...
