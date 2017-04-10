From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 08/22] KVM: arm64: ITS: Implement
 vgic_mmio_uaccess_write_its_iidr
Date: Mon, 10 Apr 2017 15:57:59 +0100
Message-ID: <74d62f62-c0eb-b7eb-4e3a-96b1b6d0d66d@arm.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
 <1490607072-21610-9-git-send-email-eric.auger@redhat.com>
 <864lxzch9o.fsf@arm.com> <5f1423fd-8f73-364a-9cf7-b4310957e2fd@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F56B40C2C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Apr 2017 10:55:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WyJ82sUDUqpa for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Apr 2017 10:55:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA38F40C25
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Apr 2017 10:55:41 -0400 (EDT)
In-Reply-To: <5f1423fd-8f73-364a-9cf7-b4310957e2fd@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, vijayak@caviumnetworks.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On 10/04/17 15:32, Auger Eric wrote:
> Hi Marc,
> 
> On 08/04/2017 12:42, Marc Zyngier wrote:
>> On Mon, Mar 27 2017 at 10:30:58 AM, Eric Auger <eric.auger@redhat.com> wrote:
>>> The GITS_IIDR revision field is used to encode the version of the
>>> table layout (ABI). So we need to restore it to check the table
>>> layout to be restored is compatible with the destination vITS.
>>>
>>> The user selected revision is stored in the user_revision field.
>>> It will be compared against the REV num at table restoration time.
>>
>> Why isn't it sufficient to keep it GITS_IIDR RO and let userspace find
>> out about the ABI revision that the kernel understands?
>>
>> Or are we planning on supporting multiple ABIs in the kernel?
> Yes as discussed with Peter, the plan is to allow several ABIs. So the
> userspace informs the destination about the ABI revision of the stored
> tables (contained by the GITS_IIDR). If the destination KVM does not
> support this ABI revision, table restore will fail.
>  If so, do
>> we have a deprecation policy/plan? I don't mind either way, but it would
>> be good to document it...
>>
>> Maybe it is documented already and I missed it (which is perfectly
>> possible!).
> Well this is partly documented in
> Documentation/virtual/kvm/devices/arm-vgic-its.txt. No plan to
> deprecate. migration from KVM supporting v1 to KVM supporting V2 would
> be possible but not the contrary.
> 
> Does it make sense?

Sort of. Say you have three systems: A and C, which only supports v1; B,
which supports v1 and v2. Let's say you migrate from A to B, and from B
to C. Is B mandated to be able to export the tables as v1 and v2? Or can
it restrict what it can export?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
