From: "Chalamarla, Tirumalesh" <Tirumalesh.Chalamarla@caviumnetworks.com>
Subject: Re: [PATCH v4 04/12] KVM: arm64: handle ITS related GICv3
 redistributor registers
Date: Thu, 5 May 2016 18:06:59 +0000
Message-ID: <A36F639B-9E31-4B90-958D-D050E426BDF3@caviumnetworks.com>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
 <1458958450-19662-5-git-send-email-andre.przywara@arm.com>
 <57066682.5040404@arm.com> <57066775.10102@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4586F49B79
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2016 14:04:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XaDHLXxt5+VM for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 May 2016 14:04:20 -0400 (EDT)
Received: from na01-bn1-obe.outbound.protection.outlook.com
 (mail-bn1on0070.outbound.protection.outlook.com [157.56.110.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DC3C49B77
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2016 14:04:19 -0400 (EDT)
In-Reply-To: <57066775.10102@arm.com>
Content-Language: en-US
Content-ID: <A6114A7DA856F143896F9666A1FECF71@namprd07.prod.outlook.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu






On 4/7/16, 6:58 AM, "kvmarm-bounces@lists.cs.columbia.edu on behalf of Marc Zyngier" <kvmarm-bounces@lists.cs.columbia.edu on behalf of marc.zyngier@arm.com> wrote:

>On 07/04/16 14:54, Marc Zyngier wrote:
>> On 26/03/16 02:14, Andre Przywara wrote:
>>> In the GICv3 redistributor there are the PENDBASER and PROPBASER
>>> registers which we did not emulate so far, as they only make sense
>>> when having an ITS. In preparation for that emulate those MMIO
>>> accesses by storing the 64-bit data written into it into a variable
>>> which we later read in the ITS emulation.
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> ---
>>>  include/kvm/vgic/vgic.h       |  8 ++++++++
>>>  virt/kvm/arm/vgic/vgic_mmio.c | 26 ++++++++++++++++++++++----
>>>  2 files changed, 30 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
>>> index 11344e6..8ea5dd7 100644
>>> --- a/include/kvm/vgic/vgic.h
>>> +++ b/include/kvm/vgic/vgic.h
>>> @@ -145,6 +145,14 @@ struct vgic_dist {
>>>  
>>>  	struct vgic_io_device	*dist_iodevs;
>>>  	struct vgic_io_device	*redist_iodevs;
>>> +
>>> +	/* Address of LPI configuration table shared by all redistributors */
>>> +	u64			propbaser;
>>> +
>>> +	/* Addresses of LPI pending tables per redistributor */
>>> +	u64			*pendbaser;
>> 
>> All these should probably either be phys_addr_t or gpa_t.
>
>Also: these registers are per redistributor. They really should appear
>as such, and not be shoved in vgic_dist.
>
>As for GICR_PROPBASER being shared: this is an implementation choice.
>All the architecture mandates is that the same value is programmed in
>all the redistributors.
>
>Yes, you can share the storage, but I'd really want to see a field per
>redist.
+1


>
>Thanks,
>
>	M.
>-- 
>Jazz is not dead. It just smells funny...
>_______________________________________________
>kvmarm mailing list
>kvmarm@lists.cs.columbia.edu
>https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
