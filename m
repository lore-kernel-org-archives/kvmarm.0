From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v7 01/24] KVM: arm/arm64: Add ITS save/restore API
 documentation
Date: Sun, 7 May 2017 19:05:59 +0200
Message-ID: <c2e1492b-bfb3-d8de-ca7a-0f925093f713@redhat.com>
References: <1494084283-12723-1-git-send-email-eric.auger@redhat.com>
 <1494084283-12723-2-git-send-email-eric.auger@redhat.com>
 <87inlclw4t.fsf@on-the-bus.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A968F40A69
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 May 2017 13:02:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oDVQMyhqzTrj for <kvmarm@lists.cs.columbia.edu>;
 Sun,  7 May 2017 13:02:57 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A16F4095A
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 May 2017 13:02:57 -0400 (EDT)
In-Reply-To: <87inlclw4t.fsf@on-the-bus.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, vijayak@caviumnetworks.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 07/05/2017 13:54, Marc Zyngier wrote:
> On Sat, May 06 2017 at  4:24:20 pm BST, Eric Auger <eric.auger@redhat.com> wrote:
>> Add description for how to access ITS registers and how to save/restore
>> ITS tables into/from memory.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v6 -> v7:
>> - rephrase ordering sequence + few cosmetic changes
>>
>> v5 -> v6:
>> - add restoration ordering
>> - 256B -> 256 Byte aligned
>> - DTE Size is number of bits for the EVENTID
>> - s/GITS_READR/GITS_CREADR
>>
>> v4 -> v5:
>> - take into account Christoffer's comments
>> - pending table save on GICV3 side now
>>
>> v3 -> v4:
>> - take into account Peter's comments:
>>   - typos
>>   - KVM_DEV_ARM_VGIC_GRP_ITS_TABLES kvm_device_attr = 0
>>   - add a validity bit in DTE
>>   - document all fields in CTE and ITE
>>   - document ABI revision
>> - take into account Andre's comments:
>>   - document restrictions about GITS_CREADR writing and GITS_IIDR
>>   - document -EBUSY error if one or more VCPUS are runnning
>>   - document 64b registers only can be accessed with 64b access
>> - itt_addr field matches bits [51:8] of the itt_addr
>>
>> v1 -> v2:
>> - DTE and ITE now are 8 bytes
>> - DTE and ITE now indexed by deviceid/eventid
>> - use ITE name instead of ITTE
>> - mentions ITT_addr matches bits [51:8] of the actual address
>> - mentions LE layout
>> ---
>>  Documentation/virtual/kvm/devices/arm-vgic-its.txt | 120 +++++++++++++++++++++
>>  1 file changed, 120 insertions(+)
>>
>> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-its.txt b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
>> index 6081a5b..ba132e9 100644
>> --- a/Documentation/virtual/kvm/devices/arm-vgic-its.txt
>> +++ b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
> [...]
> 
>> + ITS Table ABI REV0:
>> + -------------------
>> +
>> + Revision 0 of the ABI only supports physical LPIs.
> 
> Nit: these are no more physical than any other interrupt that KVM deals
> with. If you're hinting at the lack of GICv4 support, it wouldn't
> necessarily invalidate this ABI. It is actually even likely that the ABI
> could stay the same (until we start supporting GICv4 in a nested
> configuration).
I understood vLPI are associated to vPE and not to collections. As such
ITE would need to be updated, wouldn't it?
> 
>> +
>> + The device table and ITT are indexed by the deviceid and eventid,
>> + respectively. The collection table is not indexed by collectionid:
>> + CTEs are written in the table in the order of collection creation. All
> 
> Is this order really relevant? Can we relax it? Would something break if
> collections were in a random order?
Christoffer asked me to mention the exact storage order or at least I
understood his comment that way. Nothing would break if we change the order.

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 
