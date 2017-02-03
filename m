From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC v3 00/10] Provide the EL1 physical timer to the VM
Date: Fri, 3 Feb 2017 14:34:37 +0100
Message-ID: <CAMJs5B8BF2TfZkQr_R2VfXjvyqL7EvGG1v8C+GsVi6WsEOEeMA@mail.gmail.com>
References: <1485970990-13775-1-git-send-email-jintack@cs.columbia.edu>
 <20170202123104.GJ27852@cbox>
 <CAHyh4xhsqS6CijRysFvg+NqGo0rBQU45OhAaZUuHDm4M0JufTg@mail.gmail.com>
 <20170203123320.GK27852@cbox>
 <CAHyh4xhtozK58v-rsWGQ6gwu1zs2E_PURiytS=_TLdQAdNV6nA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5DFC40838
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Feb 2017 08:34:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qUZ4cS63eUQf for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Feb 2017 08:34:14 -0500 (EST)
Received: from mail-yw0-f173.google.com (mail-yw0-f173.google.com
 [209.85.161.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4643F40284
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Feb 2017 08:34:13 -0500 (EST)
Received: by mail-yw0-f173.google.com with SMTP id v200so11215066ywc.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Feb 2017 05:34:38 -0800 (PST)
In-Reply-To: <CAHyh4xhtozK58v-rsWGQ6gwu1zs2E_PURiytS=_TLdQAdNV6nA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: KVM General <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, Andre Przywara <andre.przywara@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 3, 2017 at 2:14 PM, Jintack Lim <jintack@cs.columbia.edu> wrote:
> On Fri, Feb 3, 2017 at 7:33 AM, Christoffer Dall <cdall@linaro.org> wrote:
>> On Thu, Feb 02, 2017 at 09:51:13AM -0500, Jintack Lim wrote:
>>> On Thu, Feb 2, 2017 at 7:31 AM, Christoffer Dall <cdall@linaro.org> wrote:
>>> > Hi Jintack,
>>> >
>>> > On Wed, Feb 01, 2017 at 12:43:00PM -0500, Jintack Lim wrote:
>>> >> The ARM architecture defines the EL1 physical timer and the virtual timer,
>>> >> and it is reasonable for an OS to expect to be able to access both.
>>> >> However, the current KVM implementation does not provide the EL1 physical
>>> >> timer to VMs but terminates VMs on access to the timer.
>>> >>
>>> >> This patch series enables VMs to use the EL1 physical timer through
>>> >> trap-and-emulate.  The KVM host emulates each EL1 physical timer register
>>> >> access and sets up the background timer accordingly.  When the background
>>> >> timer expires, the KVM host injects EL1 physical timer interrupts to the
>>> >> VM.  Alternatively, it's also possible to allow VMs to access the EL1
>>> >> physical timer without trapping.  However, this requires somehow using the
>>> >> EL2 physical timer for the Linux host while running the VM instead of the
>>> >> EL1 physical timer.  Right now I just implemented trap-and-emulate because
>>> >> this was straightforward to do, and I leave it to future work to determine
>>> >> if transferring the EL1 physical timer state to the EL2 timer provides any
>>> >> performance benefit.
>>> >>
>>> >> This feature will be useful for any OS that wishes to access the EL1
>>> >> physical timer. Nested virtualization is one of those use cases. A nested
>>> >> hypervisor running inside a VM would think it has full access to the
>>> >> hardware and naturally tries to use the EL1 physical timer as Linux would
>>> >> do. Other nested hypervisors may try to use the EL2 physical timer as Xen
>>> >> would do, but supporting the EL2 physical timer to the VM is out of scope
>>> >> of this patch series. This patch series will make it easy to add the EL2
>>> >> timer support in the future, though.
>>> >>
>>> >> Note that Linux VMs booting in EL1 will be unaffected by this patch series
>>> >> and will continue to use only the virtual timer and this patch series will
>>> >> therefore not introduce any performance degredation as a result of
>>> >> trap-and-emulate.
>>> >>
>>> >> v2 => v3:
>>> >>  - Rebase on kvmarm/queue
>>> >>  - Take kvm->lock to synchronize cntvoff across all vtimers
>>> >>  - Remove unnecessary function parameters
>>> >>  - Add comments
>>> >
>>> > I just gave v3 a test run on my TC2 (32-bit platform) and my guest
>>> > quickly locks up trying to run cyclictest or when booting the machine it
>>> > stalls with RCU timeouts.
>>>
>>> Ok. It's my fault not to specify that the emulated physical timer is
>>> supported/tested on arm64.
>>> On 32-bit platform, it is supposed to show the same behavior as
>>> before, but I haven't tested.
>>> Were you using the physical timer or the virtual timer for the guest?
>>>
>>> >
>>> > Could you have a look?
>>>
>>> Sure, I'll have a look. I don't have access to my Cubietruck today,
>>> but I can work on that tomorrow.
>>>
>>
>> Don't bother, I've figured this out for you.
>
> Thanks a lot.
>
>>
>> You need the following fixup to your patch:
>
> Ok. I'll post v4 soon.
> You've already do "acked-by" for this commit. Do I need to change it
> to "signed-off-by"?
>

I guess so, technically.  I don't care deeply though.

-Christoffer
