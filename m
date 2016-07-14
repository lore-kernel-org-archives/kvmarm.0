From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v9 14/17] KVM: arm64: allow updates of LPI configuration
 table
Date: Thu, 14 Jul 2016 11:00:04 +0100
Message-ID: <478c84bd-46e8-5f73-45d1-82d8c6bf38c1@arm.com>
References: <20160713015909.28793-1-andre.przywara@arm.com>
 <20160713015909.28793-15-andre.przywara@arm.com> <57875F8A.2070009@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0968649B1D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2016 05:53:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2gbNwvYL2QJG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2016 05:53:21 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3C0B49B1A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2016 05:53:20 -0400 (EDT)
In-Reply-To: <57875F8A.2070009@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 14/07/16 10:46, Marc Zyngier wrote:
> On 13/07/16 02:59, Andre Przywara wrote:
>> The (system-wide) LPI configuration table is held in a table in
>> (guest) memory. To achieve reasonable performance, we cache this data
>> in our struct vgic_irq. If the guest updates the configuration data
>> (which consists of the enable bit and the priority value), it issues
>> an INV or INVALL command to allow us to update our information.
>> Provide functions that update that information for one LPI or all LPIs
>> mapped to a specific collection.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-its.c | 39 +++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 39 insertions(+)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index f400ef1..60108f8 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -64,6 +64,45 @@ struct its_itte {
>>  
>>  #define CBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 12))
>>  #define PENDBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 16))
>> +#define PROPBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 12))
> 
> Again, these masks are wrong as we limit the ITS to 48 bits PA.

Those masks match the architecture description of the register. We limit
to 48 bits of PA when the guest writes to those registers. I'd like to
keep this limitation in one place only.

Cheers,
Andre.
