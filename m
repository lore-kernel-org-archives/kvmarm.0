From: James Morse <james.morse@arm.com>
Subject: Re: Instruction/Cycle Counting in Guest Using the Kvm PMU
Date: Fri, 23 Nov 2018 17:36:22 +0000
Message-ID: <fff7692d-117d-9119-1ff7-8b9bf5369c24@arm.com>
References: <93B846538060DA46A9945E98A2E521E9A87A9C@DE02WEMBXB.internal.synopsys.com>
 <0e9adc4e-20e3-5648-3ef6-64c9e16f780d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B72D14A20D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Nov 2018 12:36:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r64M2dKUYqRa for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Nov 2018 12:36:25 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A4814A1DE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Nov 2018 12:36:25 -0500 (EST)
In-Reply-To: <0e9adc4e-20e3-5648-3ef6-64c9e16f780d@arm.com>
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
To: Jan Bolke <jan.bolke@synopsys.com>, Andrew Murray <andrew.murray@arm.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jan,

On 23/11/2018 12:29, James Morse wrote:
> On 23/11/2018 09:36, Jan Bolke wrote:
>> I am using the Kvm Api and try to integrate it as an instruction set sim=
ulator
>> in a SystemC environment.
> =

> =

>> I need some mechanism to count executed instructions in the guest (or cy=
cles).
>>
>> Currently I am trying to use the emulated PMU cycle counter in the guest=
 to get
>> the number of executed cycles in the guest.
>>
>> I am working on Arm64 and use Linux Kernel 4.14.33.
>>
>> I create the PMU device without creating a in-kernel vgic.
> =

>> I configure the counter, then start the counter, execute 3 or 4 dummy
>> instructions and read the counter again and then exit the guest with an =
exit_mmio.
>>
>> I assumed the value should be a very small number, as the guest only exe=
cuted a
>> few instructions.
> =

> (some of which are system register writes, which can take a long time)
> =

>> The thing is as I read the counter, the value is something like 2970 or 0
>> (changes in each run).

> You are missing some barriers in your assembly snippet. 0 is a good indic=
ation
> that the code you wanted to measure escaped the measurement-window!

This would be true on bare-metal, but for KVM I'm talking rubbish. Turns ou=
t KVM
traps all these registers, and emulates the lot.

kvm_arm_setup_debug() sets MDCR_EL2.TPM so almost all these accesses trap,
effectively putting an ISB after each one.


>> So to me it looks like the counter is also counting the cycles for instr=
uction
>> emulation in the host, am I right?
> =

> I'd assume not, but I don't know anything about the PMU.
> Andrew Murray posted a series[0] that did some stuff with starting/stoppi=
ng the
> the counters around the guest, but I think that was just for the host mak=
ing
> measurements of itself, or the guest.

> It might be easier to count instructions from outside the guest using per=
f. I
> think Andrew's series is making that more reliable.

>> Is it possible to just count the cycles in the guest from the guests=92s=
 point of
>> view?

This is what KVM is doing, by emulating the PMU with perf.
kvm_pmu_get_counter_value() looks like it should be doing the right thing...

As a sanity check, does the cycle counter work on your test machine?:
| perf stat -e cycles -- ls



Thanks,

James
