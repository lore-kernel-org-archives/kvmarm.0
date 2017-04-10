From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v4 08/22] KVM: arm64: ITS: Implement
 vgic_mmio_uaccess_write_its_iidr
Date: Mon, 10 Apr 2017 17:17:11 +0200
Message-ID: <42ca421f-3c36-2f67-1e39-ec071cea3649@redhat.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
 <1490607072-21610-9-git-send-email-eric.auger@redhat.com>
 <864lxzch9o.fsf@arm.com> <5f1423fd-8f73-364a-9cf7-b4310957e2fd@redhat.com>
 <74d62f62-c0eb-b7eb-4e3a-96b1b6d0d66d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <74d62f62-c0eb-b7eb-4e3a-96b1b6d0d66d@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: peter.maydell@linaro.org, drjones@redhat.com, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, vijayak@caviumnetworks.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, christoffer.dall@linaro.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 10/04/2017 16:57, Marc Zyngier wrote:
> On 10/04/17 15:32, Auger Eric wrote:
>> Hi Marc,
>>
>> On 08/04/2017 12:42, Marc Zyngier wrote:
>>> On Mon, Mar 27 2017 at 10:30:58 AM, Eric Auger <eric.auger@redhat.com> wrote:
>>>> The GITS_IIDR revision field is used to encode the version of the
>>>> table layout (ABI). So we need to restore it to check the table
>>>> layout to be restored is compatible with the destination vITS.
>>>>
>>>> The user selected revision is stored in the user_revision field.
>>>> It will be compared against the REV num at table restoration time.
>>>
>>> Why isn't it sufficient to keep it GITS_IIDR RO and let userspace find
>>> out about the ABI revision that the kernel understands?
>>>
>>> Or are we planning on supporting multiple ABIs in the kernel?
>> Yes as discussed with Peter, the plan is to allow several ABIs. So the
>> userspace informs the destination about the ABI revision of the stored
>> tables (contained by the GITS_IIDR). If the destination KVM does not
>> support this ABI revision, table restore will fail.
>>  If so, do
>>> we have a deprecation policy/plan? I don't mind either way, but it would
>>> be good to document it...
>>>
>>> Maybe it is documented already and I missed it (which is perfectly
>>> possible!).
>> Well this is partly documented in
>> Documentation/virtual/kvm/devices/arm-vgic-its.txt. No plan to
>> deprecate. migration from KVM supporting v1 to KVM supporting V2 would
>> be possible but not the contrary.
>>
>> Does it make sense?
> 
> Sort of. Say you have three systems: A and C, which only supports v1; B,
> which supports v1 and v2. Let's say you migrate from A to B, and from B
> to C. Is B mandated to be able to export the tables as v1 and v2? Or can
> it restrict what it can export?
At the moment migration from B to C will fail because source ABI rev =
v2 > destination support ABI = v1.

A (v1) -> B (v1 & v2): migration OK
B (v1 & v2) -> C (v1): migration NOK

What could be done if we want something clever is source KVM detects
which ABI is sufficient and choose the lowest revision for the save. for
instance if no vLPI choose rev1, otherwise rev2. rev2 typically is
needed for vLPI support for nested as we need to save/restore vPE table
and vLPIs in ITE (2x8 byte entries).

The problem is that once you have migrated to B and you start playing
with vLPIs and C do not know the table layout for vPE/vLPIs, you can't
migrate anymore.

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 
