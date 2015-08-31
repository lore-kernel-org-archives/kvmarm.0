From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 9/9] arm/arm64: KVM: arch timer: Reset CNTV_CTL to 0
Date: Mon, 31 Aug 2015 11:02:53 +0200
Message-ID: <CAKv+Gu_f97gu+TftpdJDef4X89sjYB2udUybpmm=M113_TTiPw@mail.gmail.com>
References: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org>
	<1440942866-23802-10-git-send-email-christoffer.dall@linaro.org>
	<CAKv+Gu-4KKUUt7J==CPK6J79mWXLeMJFsG_fj85tYB2orzfrZg@mail.gmail.com>
	<20150831085752.GH24113@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150831085752.GH24113@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, KVM devel mailing list <kvm@vger.kernel.org>, Laszlo Ersek <lersek@redhat.com>, Drew Jones <drjones@redhat.com>, Wei Huang <wei@redhat.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 31 August 2015 at 10:57, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> On Mon, Aug 31, 2015 at 10:46:59AM +0200, Ard Biesheuvel wrote:
>> On 30 August 2015 at 15:54, Christoffer Dall
>> <christoffer.dall@linaro.org> wrote:
>> > Provide a better quality of implementation and be architecture compliant
>> > on ARMv7 for the architected timer by resetting the CNTV_CTL to 0 on
>> > reset of the timer, and call kvm_timer_update_state(vcpu) at the same
>> > time, ensuring the timer output is not asserted after, for example, a
>> > PSCI system reset.
>> >
>> > This change alone fixes the UEFI reset issue reported by Laszlo back in
>> > February.
>> >
>>
>> Do you have a link to that report? I can't quite remember the details ...
>>
> There was no public mailing list cc'ed on the report, and the bugzilla
> bug was created in a non-public Red Hat instance.
>
> But you were cc'ed on the original mail from Laszlo.  Look for an e-mail
> from February 5th with the subject "virtual timer interrupt stuck across
> guest firmware reboot on KVM".
>

Found it, thanks.
