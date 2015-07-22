From: Claudio Fontana <claudio.fontana@huawei.com>
Subject: Re: [PATCH v2] target-arm: kvm: Differentiate registers based on
 write-back levels
Date: Wed, 22 Jul 2015 14:56:11 +0200
Message-ID: <55AF92EB.9050909@huawei.com>
References: <1437046488-10773-1-git-send-email-christoffer.dall@linaro.org>
 <CAFEAcA_cyXztq2E007cOjmm7usq_KNJ4AsUXRCkNwyETibcfqg@mail.gmail.com>
 <20150717153901.GD14024@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1B9358F8D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2015 08:44:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kWfsaECQ7o49 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jul 2015 08:44:16 -0400 (EDT)
Received: from lhrrgout.huawei.com (lhrrgout.huawei.com [194.213.3.17])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EAA8E58F8B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2015 08:44:15 -0400 (EDT)
In-Reply-To: <20150717153901.GD14024@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Jan Kiszka <jan.kiszka@web.de>, QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 17.07.2015 17:39, Christoffer Dall wrote:
> On Fri, Jul 17, 2015 at 03:29:56PM +0100, Peter Maydell wrote:
>> On 16 July 2015 at 12:34, Christoffer Dall <christoffer.dall@linaro.org>=
 wrote:
>>> Some registers like the CNTVCT register should only be written to the
>>> kernel as part of machine initialization or on vmload operations, but
>>> never during runtime, as this can potentially make time go backwards or
>>> create inconsistent time observations between VCPUs.
>>>
>>> Introduce a list of registers that should not be written back at runtime
>>> and check this list on syncing the register state to the KVM state.
>>
>> Thanks. I think this should go into QEMU 2.4, given that it fixes
>> a bug with time misbehaving in guests. Are you happy that it's
>> received enough testing? (I have given 32-bit KVM a spin but have
>> no convenient 64-bit box to test with, and besides, I didn't notice the
>> bug in the first place :-))
> =

> I tested this on both Juno and Mustang, with a simple loop kernel
> booting and doing hackbench test, but if we want to be on the extra
> careful side, perhaps Alex can run it through his migration test setup?
> I don't think that's necessary though.
> =

>>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>>> ---
>>> Changes since RFC:
>>>  - Move cpreg_level to kvm_arm_cpreg_level and into kvm32.c and kvm64.c
>>>  - Changed struct name and declare as static const
>>
>> I have a couple of minor comments on the comments below, and you
>> forgot to update the stub version of write_list_to_kvmstate().
>> I can just fix these up as I put it into target-arm.next, though.
>> Fixed up version at:
>>
>>  https://git.linaro.org/people/peter.maydell/qemu-arm.git target-arm.next
>>
>> If interested parties could test that by end-of-Monday that
>> would be nice (since rc2 is scheduled for Tuesday).
>>
>>>  dtc                  |  2 +-
>>>  target-arm/kvm.c     |  6 +++++-
>>>  target-arm/kvm32.c   | 30 +++++++++++++++++++++++++++++-
>>>  target-arm/kvm64.c   | 30 +++++++++++++++++++++++++++++-
>>>  target-arm/kvm_arm.h | 12 +++++++++++-
>>>  target-arm/machine.c |  2 +-
>>>  6 files changed, 76 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/dtc b/dtc
>>> index 65cc4d2..bc895d6 160000
>>> --- a/dtc
>>> +++ b/dtc
>>> @@ -1 +1 @@
>>> -Subproject commit 65cc4d2748a2c2e6f27f1cf39e07a5dbabd80ebf
>>> +Subproject commit bc895d6d09695d05ceb8b52486ffe861d6cfbdde
>>
>> Stray submodule change :-)
>>
> =

> Damn, keeps happening to me.  ok, I'll stop using git commit -a for qemu
> changes.
> =

>>> diff --git a/target-arm/kvm32.c b/target-arm/kvm32.c
>>> index d7e7d68..6769815 100644
>>> --- a/target-arm/kvm32.c
>>> +++ b/target-arm/kvm32.c
>>> @@ -153,6 +153,34 @@ bool kvm_arm_reg_syncs_via_cpreg_list(uint64_t reg=
idx)
>>>      }
>>>  }
>>>
>>> +typedef struct CPRegStateLevel {
>>> +    uint64_t regidx;
>>> +    int level;
>>> +} CPRegStateLevel;
>>> +
>>> +/* All coprocessor registers not listed in the following table are ass=
umed to
>>> + * be of the level KVM_PUT_RUNTIME_STATE, a register should be written=
 less
>>
>> ". If a register".
>>
>>> + * often, you must add it to this table with a state of either
>>> + * KVM_PUT_RESET_STATE or KVM_PUT_FULL_STATE.
>>> + */
>>> +static const CPRegStateLevel non_runtime_cpregs[] =3D {
>>> +    { KVM_REG_ARM_TIMER_CNT, KVM_PUT_FULL_STATE },
>>> +};
>>
>>> diff --git a/target-arm/kvm64.c b/target-arm/kvm64.c
>>> index ac34f51..d59f41c 100644
>>> --- a/target-arm/kvm64.c
>>> +++ b/target-arm/kvm64.c
>>> @@ -139,6 +139,34 @@ bool kvm_arm_reg_syncs_via_cpreg_list(uint64_t reg=
idx)
>>>      }
>>>  }
>>>
>>> +typedef struct CPRegStateLevel {
>>> +    uint64_t regidx;
>>> +    int level;
>>> +} CPRegStateLevel;
>>> +
>>> +/* All system not listed in the following table are assumed to be of t=
he level
>>
>> "system registers"
>>
>>> + * KVM_PUT_RUNTIME_STATE, a register should be written less often, you=
 must
>>
>> ". If a register"
>>
>>> + * add it to this table with a state of either KVM_PUT_RESET_STATE or
>>> + * KVM_PUT_FULL_STATE.
>>> + */
>>> +static const CPRegStateLevel non_runtime_cpregs[] =3D {
>>> +    { KVM_REG_ARM_TIMER_CNT, KVM_PUT_FULL_STATE },
>>> +};
>>
>>> --- a/target-arm/kvm_arm.h
>>> +++ b/target-arm/kvm_arm.h
>>
>>> @@ -83,7 +93,7 @@ bool kvm_arm_reg_syncs_via_cpreg_list(uint64_t regidx=
);
>>>  * Note that we do not stop early on failure -- we will attempt
>>>   * writing all registers in the list.
>>>  */
>>> -bool write_list_to_kvmstate(ARMCPU *cpu);
>>> +bool write_list_to_kvmstate(ARMCPU *cpu, int level);
>>
>> You forgot to update the stub function in target-arm/kvm-stub.c,
>> so this breaks compilation on non-ARM hosts.
>>
> whoops, who cares about non-ARM hosts anyway.
> =

> Thanks for fixing these up, the fixed up version looks good.
> -Christoffer
> =


Hi,

I can if you want check if this patch actually fixes the problem without th=
e KVM workaround.
Is this the version I am supposed to test, or should I wait for the next re=
spin?

Thanks,

Claudio



-- =

Claudio Fontana
Server Virtualization Architect
Huawei Technologies Duesseldorf GmbH
Riesstra=DFe 25 - 80992 M=FCnchen
