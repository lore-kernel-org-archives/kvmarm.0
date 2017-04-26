From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 02/22] KVM: arm/arm64: Add GICV3 pending table save API
 documentation
Date: Wed, 26 Apr 2017 11:57:16 +0200
Message-ID: <4dc866a0-582c-af69-916f-eb435988b5ec@redhat.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-3-git-send-email-eric.auger@redhat.com>
 <CAFEAcA_0N9Jx5ym+=jjmxAzSaXPjt-m+gW1cq90of8Qhw3LOzg@mail.gmail.com>
 <a5ab9181-8398-f62b-12f1-032961b12c28@redhat.com>
 <CAFEAcA-u-sH+v-Pnr_3gRC3iSJP0ZK68+GqkDzmi3xe1-B2WAQ@mail.gmail.com>
 <20170426084830.GB2098@work-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170426084830.GB2098@work-vm>
Sender: kvm-owner@vger.kernel.org
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Peter Maydell <peter.maydell@linaro.org>
Cc: "prasun.kapoor" <Prasun.Kapoor@cavium.com>, Andrew Jones <drjones@redhat.com>, kvm-devel <kvm@vger.kernel.org>, Juan Quintela <quintela@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Vijaya Kumar K <vijayak@caviumnetworks.com>, "Kumar, Vijaya" <Vijaya.Kumar@cavium.com>, Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Peter, Dave,

On 26/04/2017 10:48, Dr. David Alan Gilbert wrote:
> * Peter Maydell (peter.maydell@linaro.org) wrote:
>> On 26 April 2017 at 09:26, Auger Eric <eric.auger@redhat.com> wrote:
>>> On 25/04/2017 12:43, Peter Maydell wrote:
>>>> When does the -EFAULT return happen? (if the guest points GITS_BASER<n>
>>>> etc at invalid memory, presumably?)
>>>
>>> Yes that's correct, when GICR_PENDBASER contains a bad GPA.
>>>
>>>>  How does the QEMU migration code
>>>> handle this case? Failing migration because the guest has done something
>>>> silly doesn't seem too palatable, but trying to avoid that could be
>>>> more effort than an obscure corner case really merits.
>>>
>>> The kvm_device_access will cause an abort() as for other errors returned
>>> by kvm_device_ioctl().
>>
>> That's pretty nasty. Guests shouldn't be able to provoke QEMU
>> into abort()ing, ideally. We don't necessarily have to produce
>> a successful migration, but we should at least fail it cleanly.
> 
> Yes, no abort()'s during migration due to guest behaviour.
> They always end up coming back around to being filed as migration
> bugs and people worry why they've got cores.
> 
> Ideally log a message into stderr to say that the guest state
> is inconsistent so that when someone comes to debug it then they
> can see it's obvious.

OK I agree. I will respin the QEMU part accordingly and in that
situation I won't abort and will print a message.

Thanks

Eric
> 
> Dave
> 
>> thanks
>> -- PMM
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
