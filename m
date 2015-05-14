From: Laszlo Ersek <lersek@redhat.com>
Subject: Re: [RFC/RFT PATCH v2 0/3] KVM: Introduce KVM_MEM_UNCACHED
Date: Thu, 14 May 2015 15:33:57 +0200
Message-ID: <5554A445.8090709@redhat.com>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
 <20150514103150.GA12812@localhost.localdomain>
 <CAFEAcA_EEA=TZ1jxL_rptAx5_sGa8NLMffePAw3eb-3pBgdg5w@mail.gmail.com>
 <20150514130318.GC12812@localhost.localdomain>
 <CAFEAcA99J_Yq_6CyawSutD6DYB3mP-v=GtxiMvayqdUPC2cNrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB771514F6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 09:25:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ea2zYOwNZ9f7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2015 09:25:00 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FAD3514F5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 09:24:59 -0400 (EDT)
In-Reply-To: <CAFEAcA99J_Yq_6CyawSutD6DYB3mP-v=GtxiMvayqdUPC2cNrQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>, Andrew Jones <drjones@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, QEMU Developers <qemu-devel@nongnu.org>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/14/15 15:11, Peter Maydell wrote:
> On 14 May 2015 at 14:03, Andrew Jones <drjones@redhat.com> wrote:
>> On Thu, May 14, 2015 at 11:37:46AM +0100, Peter Maydell wrote:
>>> On 14 May 2015 at 11:31, Andrew Jones <drjones@redhat.com> wrote:
>>>> Forgot to (4): switch from setting userspace's mapping to
>>>> device memory to normal, non-cacheable. Using device memory
>>>> caused a problem that Alex Graf found, and Peter Maydell suggested
>>>> using normal, non-cacheable instead.
>>>
>>> Did you check that non-cacheable is definitely the correct
>>> kind of Normal memory attribute we want? (ie not write-through).
>>
>> I was concerned that write-through wouldn't be sufficient. If the
>> guest writes to its non-cached memory, and QEMU needs to see what
>> it wrote, then won't write-through fail to work? Unless we some
>> how invalidate the cache first?
> 
> Well, I meant more that the correct mapping for userspace is
> the same as the guest, whatever that is, and so somebody needs
> to look at what the guest actually does

I think Ard explored this earlier, by tracking the MAIRs and stuff.
Can't recall what the findings were though. (Or I could be simply
confused, sorry.)

Laszlo

> rather than merely
> hoping NormalNC is OK. (For instance, do we need to provide
> support for QEMU to map both NC and writethrough?)
> 
> -- PMM
> 
