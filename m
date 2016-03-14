From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 00/16] KVM: arm64: GICv3 ITS emulation
Date: Mon, 14 Mar 2016 18:36:22 +0000
Message-ID: <56E704A6.7090901@arm.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
 <56E00A7E.4080101@semihalf.com> <20160313181608.GA15988@cbox>
 <56E69CCA.5070407@arm.com>
 <CAFEAcA8r5LDbNG0XVnHnsoYcrfcpfnR3FQ_u=-L7Dop1HFVgxw@mail.gmail.com>
 <56E6FAEB.1090306@arm.com> <56E700F4.4060308@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <56E700F4.4060308@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Peter Maydell <peter.maydell@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Tomasz Nowicki <tn@semihalf.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 14/03/16 18:20, Andre Przywara wrote:
> Hi,
> 
> On 14/03/16 17:54, Marc Zyngier wrote:
>> On 14/03/16 17:29, Peter Maydell wrote:
>>> On 14 March 2016 at 11:13, Andre Przywara <andre.przywara@arm.com> wrote:
>>>> So I see two ways to fix this:
>>>> 1.) we find a KVM specific way of letting userland save and restore the
>>>> ITS tables directly
>>>> 2.) we implement the BASER<n> registers, but still use our "cache" for
>>>> normal operations. On demand we would serialize KVM's virtual ITS data
>>>> structures and put them into the guest's memory, so they could be
>>>> saved/restored from there.
>>>
>>> I feel like we're rehashing a bunch of design choices we talked
>>> through way back in the last-but-one Connect. I don't suppose
>>> anybody wrote down our rationales from back then?
>>>
>>> (In particular I forget whether we decided the ITS tables were
>>> large enough to need to allow some sort of before-the-VM-stops
>>> migration of the data, which would be relatively doable with
>>> option 2 but painful under option 1.)
>>
>> I think only option 2 is valid here, and we must be able to shove most
>> of the routing information in the device/collection/IT tables. Common HW
>> seems to use 64bit of data per entry per table, so we should be able to
>> do the same with KVM.
> 
> All right, just skimmed over this and it looks doable.
> For the collection table we will most likely even get away with 32 bits
> per entry (compressed MPIDR or even VCPUIDs).
> Would the IPA of the ITTE suffice for each device table entry?

Yup. You can even loose the low 8 bits, as this is guaranteed to be 256
byte aligned. So for a 48bit IPA and 32bit of EventID, you end up only
using 45 bits, which leaves quite a few to spare, should we ever want a
larger IPA. Ideally, this should contain the relevant fields of the MAPD
command, with similar sizes.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
