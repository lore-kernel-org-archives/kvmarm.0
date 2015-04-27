From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 06/10] KVM: arm64: guest debug, add SW break point support
Date: Mon, 27 Apr 2015 22:57:34 +0100
Message-ID: <CAFEAcA-Kh7Tn+kw9psL=gqme9ogAn+mM8Uco_HcJy=cqg72hbw@mail.gmail.com>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-7-git-send-email-alex.bennee@linaro.org>
 <20150414082558.GS6186@cbox> <87y4li6hua.fsf@linaro.org> <20150427200407.GG23335@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150427200407.GG23335@cbox>
Sender: linux-doc-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>, Andrew Jones <drjones@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Zhichao Huang <zhichao.huang@linaro.org>, "J. Kiszka" <jan.kiszka@siemens.com>, David Hildenbrand <dahi@linux.vnet.ibm.com>, Bharat Bhushan <r65777@freescale.com>, bp@suse.de, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 27 April 2015 at 21:04, Christoffer Dall <christoffer.dall@linaro.or=
g> wrote:
> On Thu, Apr 23, 2015 at 03:26:53PM +0100, Alex Benn=C3=A9e wrote:
>>
>> Christoffer Dall <christoffer.dall@linaro.org> writes:
>>
>> > On Tue, Mar 31, 2015 at 04:08:04PM +0100, Alex Benn=C3=A9e wrote:
>> >> + * just need to report the PC and the HSR values to userspace.
>> >> + * Userspace may decide to re-inject the exception and deliver i=
t to
>> >> + * the guest if it wasn't for the host to deal with.
>> >
>> > now I'm confused - does userspace setup the guest to receive an
>> > exception or does it tell KVM to emulate an exception for the gues=
t or
>> > do we execute the breakpoint without trapping the debug exception?
>>
>> I've made it all go through userspace as we may have to translate th=
e
>> hypervisor visible exception code to what the guest was expecting to=
 see.
>>
>
> ok, so I think you should re-phrase something like:
>
> "Userspace may decide that this exception is caused by the guest usin=
g
> debugging itself, and may in that case emulate the guest debug except=
ion
> in userspace before resuming KVM."
>
> But does that really work?  Given that we don't support KVM-TCG
> migration, this sounds a little strange.  Did we test it?

The QEMU patches have a TODO note at the point where you'd want
to do this... Design-wise you can do the reinjection in the
kernel or in userspace (ppc QEMU does this in userspace, for
instance) because it's pretty much just setting registers to fake
up the exception-entry into EL1. Code-wise QEMU's ARM code isn't
set up to do it right now, but it shouldn't be too difficult to
persuade the TCG exception-entry code to work for this case too.

Does the kernel already have a conveniently implemented "inject
exception into guest" lump of code? If so it might be less effort
to do it that way round, maybe.

-- PMM
