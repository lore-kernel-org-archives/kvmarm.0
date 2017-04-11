From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v4 08/22] KVM: arm64: ITS: Implement
 vgic_mmio_uaccess_write_its_iidr
Date: Tue, 11 Apr 2017 11:43:29 +0100
Message-ID: <CAFEAcA8oznK3-pmsd2xzrt+HzpM9xkkCfL-iHe4L55NOtMH8vw@mail.gmail.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
 <1490607072-21610-9-git-send-email-eric.auger@redhat.com>
 <864lxzch9o.fsf@arm.com>
 <5f1423fd-8f73-364a-9cf7-b4310957e2fd@redhat.com>
 <74d62f62-c0eb-b7eb-4e3a-96b1b6d0d66d@arm.com>
 <42ca421f-3c36-2f67-1e39-ec071cea3649@redhat.com>
 <e339c732-e1da-b620-ce09-8e141d2db376@arm.com>
 <dc02a006-cef8-ac75-7cfd-5fe5c220ea22@redhat.com>
 <CAFEAcA8XYUnC6zc+EF+amX8d1fP6sTF7Bypn455QkD++RsTRJA@mail.gmail.com>
 <5b2a8ed0-bfc7-852b-07d8-8474aef25b2a@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 855E940C43
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Apr 2017 06:41:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NfW1S5-aRsNf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Apr 2017 06:41:27 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 24C8540C35
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Apr 2017 06:41:27 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id o81so59824157wmb.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Apr 2017 03:43:51 -0700 (PDT)
In-Reply-To: <5b2a8ed0-bfc7-852b-07d8-8474aef25b2a@arm.com>
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
Cc: "prasun.kapoor" <Prasun.Kapoor@cavium.com>, kvm-devel <kvm@vger.kernel.org>, Juan Quintela <quintela@redhat.com>, Vijaya Kumar K <vijayak@caviumnetworks.com>, Andre Przywara <andre.przywara@arm.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "Kumar,
 Vijaya" <Vijaya.Kumar@cavium.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On 11 April 2017 at 11:29, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 11/04/17 11:16, Peter Maydell wrote:
>> On 11 April 2017 at 11:08, Auger Eric <eric.auger@redhat.com> wrote:
>>> On 11/04/2017 12:05, Marc Zyngier wrote:
>>>> On 10/04/17 16:17, Auger Eric wrote:
>>>>> A (v1) -> B (v1 & v2): migration OK
>>>>> B (v1 & v2) -> C (v1): migration NOK
>>>>
>>>> So what does IIDR report on B once the A->B migration has taken place?
>>>> Does it report v2?
>>>
>>> yes that was the plan
>>
>> Hmm, the IIDR value shouldn't change across a migration I think.
>> It's guest visible so the guest should see it still the same
>> value even after migration.
>
> That's my worry. But we then have a problem when this VM migrates again.
> How does userspace find out which ABI to use then?

Userspace shouldn't need to care; the idea of this scheme is
that if the kernel has to change its ABI then the kernel
is what has to deal with the change.

I think that means that if you can read the v1 format on input
you have to output it too, though.

thanks
-- PMM
