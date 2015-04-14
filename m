From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [Linaro-uefi] UEFI on KVM fails to start on juno on cortex-a57
 cluster
Date: Tue, 14 Apr 2015 13:08:47 +0200
Message-ID: <CAKv+Gu92JaJjewRhgroTfd8C1bJZvFxJrkv329RC4FbYKCpP7g@mail.gmail.com>
References: <CAAqcGHmFGO8DaU-G0A6geOzDZDmWAtjHN6wOmJQVBjyi6_WVzQ@mail.gmail.com>
 <CAKv+Gu_W0sk6vR+frYYNBoMjWs6mBcxPwXjwzaHv1D0Sh7GtAw@mail.gmail.com>
 <CAKv+Gu8j0zWQcxiasCy2eozcLCJuT=FPY0rLeYG0z3Hjwf40=A@mail.gmail.com>
 <CAKv+Gu9VE8kdq2chs=QKHvyhOoSwBPy2CmJp-ra5kYLiiifVQg@mail.gmail.com>
 <CAAqcGHnNrnOLxfoTuGGMN4nwDupaaLK5sJ8TATTw33r1NMi0Dg@mail.gmail.com>
 <CAKv+Gu9djvNecwDGqyCNzdQG6-g=ivavfCGg-jqxrrZ+tnYDOQ@mail.gmail.com>
 <CAKv+Gu9BJ_+4ioE1SOp=ui6a8UQ_+HEGdcYgWdiyZACKr9Q+Nw@mail.gmail.com>
 <20150414110717.GC6186@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1389F4D037
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 07:00:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s1Jf+SbzCDHy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2015 07:00:57 -0400 (EDT)
Received: from mail-ig0-f170.google.com (mail-ig0-f170.google.com
 [209.85.213.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B25124D031
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 07:00:57 -0400 (EDT)
Received: by igbyr2 with SMTP id yr2so34742041igb.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 04:08:47 -0700 (PDT)
In-Reply-To: <20150414110717.GC6186@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Virtualization Team <virtualization@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Leif Lindholm <leif.lindholm@linaro.org>, Linaro UEFI Mailman List <linaro-uefi@lists.linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 14 April 2015 at 13:07, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> On Mon, Apr 13, 2015 at 11:04:00AM +0200, Ard Biesheuvel wrote:
>> On 27 March 2015 at 01:02, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> > On 26 March 2015 at 09:09, Riku Voipio <riku.voipio@linaro.org> wrote:
>> >> On 25 March 2015 at 21:32, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> >>> On 25 March 2015 at 17:14, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> >>>> On 25 March 2015 at 17:14, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> >>>>> On 25 March 2015 at 07:59, Riku Voipio <riku.voipio@linaro.org> wrote:
>> >>>>>> Hi,
>> >>>>>>
>> >>>>>> It appears on juno, I can start kvm with UEFI only on cortex-a53 cores:
>> >>>>>>
>> >>>>>>
>> >>>>>> taskset -c 0 qemu-system-aarch64 -m 1024 -cpu host -M virt -bios
>> >>>>>> QEMU_EFI.fd -enable-kvm -nographic
>> >>>>>> -> works:
>> >>>>>> UEFI Interactive Shell v2.0
>> >>>>>> taskset -c 1 qemu-system-aarch64 -m 1024 -cpu host -M virt -bios
>> >>>>>> QEMU_EFI.fd -enable-kvm -nographic
>> >>>>>> -> hangs at cpu spinning 100%
>> >>>>>> ...
>> >>>>>>
>> >>>>>
>> >>>>> I can reproduce the hang, both with your UEFI binary and my own release build.
>> >>>>> The debug build works fine, unfortunately...
>> >>>>>
>> >>>>
>> >>>> Tianocore built from master as of today, that is.
>> >>>>
>> >>>
>> >>> OK, it appears that we were missing some cache maintenance. It is not
>> >>> obvious how that should affect A57 only, but with these patches, I can
>> >>> now reliably run the release version on my Seattle A57
>> >>
>> >>> https://git.linaro.org/people/ard.biesheuvel/uefi-next.git/shortlog/refs/heads/qemu-xen-cache-maintenance
>> >>
>> >> Thanks. Do you know when there would be a new build on releases or snapshots?
>> >>
>> >
>> > Let me check with Leif. We have another candidate patch now that he
>> > could perhaps apply and kick off a build?
>> >
>>
>> I now have independent confirmation (from Laszlo Ersek) that the cache
>> maintenance patches I am proposing fix the issue on Seattle.
>
> Which patches are those?  For UEFI?
>

Yes, for Tianocore.
http://thread.gmane.org/gmane.comp.bios.tianocore.devel/13665

>> Hopefully this means Juno is fixed as well.
>>
>> I am trying to get a snapshot out asap, today or tomorrow perhaps?
>
> Thanks,
> -Christoffer
