From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH v3 0/2] KVM: ARM: Enable vtimers with user space gic
Date: Mon, 19 Sep 2016 12:51:46 +0200
Message-ID: <43020f1f-6367-6f11-2534-b26ced13b540@suse.de>
References: <1474007187-18673-1-git-send-email-agraf@suse.de>
 <57DBC782.7080305@arm.com> <7beb406b-6194-8451-2d92-9a4394ef91dd@redhat.com>
 <20160916123039.GB14140@cbox>
 <da8191ca-6fb1-f960-872c-d6bc27172db8@redhat.com>
 <20160916133027.GA27036@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160916133027.GA27036@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 16.09.16 15:30, Christoffer Dall wrote:
> On Fri, Sep 16, 2016 at 02:31:42PM +0200, Paolo Bonzini wrote:
>>
>>
>> On 16/09/2016 14:30, Christoffer Dall wrote:
>>>>>> This patch set allows user space to receive vtimer events as well as mask
>>>>>> them, so that we can handle all vtimer related interrupt injection from user
>>>>>> space, enabling us to use architected timer with user space gic emulation.
>>>>>
>>>>> I have already voiced my concerns in the past, including face to face,
>>>>> and I'm going to repeat it: I not keen at all on adding a new userspace
>>>>> interface that is going to bitrot extremely quickly.
>>>>
>>>> You don't have automated tests set up?  It's not going to bitrot if you
>>>> test it, either with kvm-unit-tests or just by smoke-testing Linux.
>>>> It's _for_ the raspi, but it's not limited to it.
>>>
>>> Our automated testing situation is not great, no.  Something we're
>>> looking at, but have resource problems with.
>>
>> But it's not a good reason to hold back a feature...
>>
> 
> I didn't say that exactly, but choosing not to merge something we cannot
> maintain and which we're not paid to look after and where there's a
> minimal interest, is not entirely unreasonable.
> 
> That being said, I'm not categorically against these patches, but I
> share Marc's view that we've already seen that non-vgic support had been
> broken for multiple versions without anyone complaining, and without
> automated testing or substantial interest in the work, the patches
> really are likely to bit-rot.

I know that it's very hard to grasp from an upstream maintainer
perspective, but keep in mind where the bulk of execution of kernel code
lies. The average life cycle of a "stable" Linux distribution's kernel
is a few years.

So far all regressions in the user space gic code have been found within
less than 1y of the respective code release. I'd say that counts for
quite a well used feature.

> But I haven't even looked at the patches in detail, I was just replying
> to the comment about testing.

Also keep in mind that without the architected timer support (and/or
without qemu patches than enable user space timers) the user space gic
support is pretty unusable to most people, so you obviously get less
reports.


Alex
