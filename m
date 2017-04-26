From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 02/22] KVM: arm/arm64: Add GICV3 pending table save API
 documentation
Date: Wed, 26 Apr 2017 16:47:09 +0200
Message-ID: <c9ca5b5b-9e7c-301f-60a4-7a3c18b794d8@redhat.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-3-git-send-email-eric.auger@redhat.com>
 <CAFEAcA_0N9Jx5ym+=jjmxAzSaXPjt-m+gW1cq90of8Qhw3LOzg@mail.gmail.com>
 <a5ab9181-8398-f62b-12f1-032961b12c28@redhat.com>
 <CAFEAcA-u-sH+v-Pnr_3gRC3iSJP0ZK68+GqkDzmi3xe1-B2WAQ@mail.gmail.com>
 <20170426084830.GB2098@work-vm>
 <4dc866a0-582c-af69-916f-eb435988b5ec@redhat.com>
 <20170426130020.GM4104@cbox>
 <CAFEAcA8t0Y-UBu_Fx_YTsmnw8zvd4fctTfobdb-akjdx_81PWA@mail.gmail.com>
 <20170426131421.GA50776@lvm>
 <CAFEAcA-3QL-1=RYhZ-xo0rgYTjRvxhWJfBVrT1f2G_j5t8Wj7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA-3QL-1=RYhZ-xo0rgYTjRvxhWJfBVrT1f2G_j5t8Wj7A@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Christoffer Dall <cdall@linaro.org>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "prasun.kapoor" <Prasun.Kapoor@cavium.com>, Andrew Jones <drjones@redhat.com>, kvm-devel <kvm@vger.kernel.org>, Juan Quintela <quintela@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Vijaya Kumar K <vijayak@caviumnetworks.com>, "Kumar, Vijaya" <Vijaya.Kumar@cavium.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Peter, Christoffer,

On 26/04/2017 15:26, Peter Maydell wrote:
> On 26 April 2017 at 14:14, Christoffer Dall <christoffer.dall@linaro.org> wrote:
>> On Wed, Apr 26, 2017 at 02:01:55PM +0100, Peter Maydell wrote:
>>> On 26 April 2017 at 14:00, Christoffer Dall <cdall@linaro.org> wrote:
>>>> Alternatively we should mark a pending error notification to the guest
>>>> in KVM, so that when the guest boots it gets something like an SError
>>>> instead, given that presumably the guest wrote the weird value.  Except
>>>> of course if the problem is caused by QEMU fudging with the register
>>>> value for the PENDBASER.
>>>
>>> If we have scope for complaining at the guest we should do it at
>>> the point where the guest sets PENDBASER in the first place...
>>>
>>
>> Is that what the hardware would have done?
> 
> I think it's UNPREDICTABLE to enable the GIC with a bogus PENDBASER,
> but I can't find the bit in the spec that actually says that.
> I don't know what hardware actually does, but I imagine it will
> only notice that it's been handed bogus memory at the point where
> it tries to use it.
> 
>> Also, userspace could restore a bogus value in the PENDBASER (even
>> though the guest wrote something sane), so maybe we should just keep
>> this as is and handle it nicely in QEMU?
> 
> Yeah, I don't have a strong objection to doing it that way round.

OK. I will only update the QEMU code then.

For info, without talking about save/restore, the GICR_PENDBASER is
sync'ed on LPI enable. if the vITS gets an error on kvm_read_guest, we
currently abort the sync without reporting any error.

GICR_PROPBASER is read on cmd execution (MAPI, INV, INVALL). No error is
reported at the moment. My understanding is our implementation chose the
3d alternative of GICV3 arch spec (6.3.2), ie. "the data that generated
the error or errors is treated as having a legal value",  increment the
read cursor and currently we don't report any system error to the guest.

Thanks

Eric
> 
> thanks
> -- PMM
> 
