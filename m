From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 17/26] KVM: arm/arm64: GICv4: Handle INVALL applied to
 a vPE
Date: Fri, 10 Nov 2017 08:56:32 +0000
Message-ID: <2c791b55-f16d-5e2b-a876-126239cf04d1@arm.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-18-marc.zyngier@arm.com>
 <e247390a-c9d5-4c3a-5812-88b83e87ce10@redhat.com>
 <20171110084115.GJ14144@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F82749D1F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Nov 2017 03:54:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HOdLquYqGl7K for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Nov 2017 03:54:33 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D27340FB0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Nov 2017 03:54:33 -0500 (EST)
In-Reply-To: <20171110084115.GJ14144@cbox>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>, Auger Eric <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, Andre Przywara <Andre.Przywara@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/11/17 08:41, Christoffer Dall wrote:
> On Tue, Nov 07, 2017 at 10:23:25PM +0100, Auger Eric wrote:
>> Hi Marc,
>>
>> On 27/10/2017 16:28, Marc Zyngier wrote:
>>> Since when updating the properties one LPI at a time, there is no
>> Since we update the properties one LPI at a time, ... ?
>>> need to perform an INV each time we read one. Instead, we rely
>>> on the final VINVALL that gets sent to the ITS to do the work.
>> The commit message is not crystal clear for me.
>>
>> I understand in case of vgic_its_cmd_handle_invall you want to avoid
>> doing an invalidation for each physical irq but rather do an
>> its_invall_vpe at the end. So you add a new  @needs_inv arg to
>> update_lpi_config to tell whether the invalidation should be done or not.
> 
> I've reworded it to:
> 
>   There is no need to perform an INV for each interrupt when updating
>   multiple interrupts.  Instead, we can rely on the final VINVALL that
>   gets sent to the ITS to do the work for all of them.
> 
> 
> Shout quickly if you have any objections.

Works for me.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
