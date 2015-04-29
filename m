From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 06/10] KVM: arm64: guest debug, add SW break point support
Date: Wed, 29 Apr 2015 21:20:12 +0200
Message-ID: <CAMJs5B-qs9euMo4yW1-prnakBHo37qvhcDvtVPVXqPoyA_J1Ng@mail.gmail.com>
References: <20150414082558.GS6186@cbox>
	<87y4li6hua.fsf@linaro.org>
	<20150427200407.GG23335@cbox>
	<CAFEAcA-Kh7Tn+kw9psL=gqme9ogAn+mM8Uco_HcJy=cqg72hbw@mail.gmail.com>
	<87wq0wr6dd.fsf@linaro.org>
	<CAFEAcA85i_1JybEFBg91NA3-LpAzYh4RSDnqryOd=rZN7gZP5A@mail.gmail.com>
	<20150428125645.GA4137@cbox>
	<87tww0qqh9.fsf@linaro.org>
	<20150429081047.GB4137@cbox>
	<87r3r31eed.fsf@linaro.org>
	<20150429103814.GC4137@cbox>
	<87oam70y64.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87oam70y64.fsf@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>, Andrew Jones <drjones@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Zhichao Huang <zhichao.huang@linaro.org>, "J. Kiszka" <jan.kiszka@siemens.com>, David Hildenbrand <dahi@linux.vnet.ibm.com>, Bharat Bhushan <r65777@freescale.com>, bp@suse.de, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 29, 2015 at 5:08 PM, Alex Benn=C3=A9e <alex.bennee@linaro.o=
rg> wrote:
>
> Christoffer Dall <christoffer.dall@linaro.org> writes:
>
>> On Wed, Apr 29, 2015 at 10:18:18AM +0100, Alex Benn=C3=A9e wrote:
>>>
>>> Christoffer Dall <christoffer.dall@linaro.org> writes:
>>>
>>> > On Tue, Apr 28, 2015 at 03:37:01PM +0100, Alex Benn=C3=A9e wrote:
>>> >>
>>> >> Christoffer Dall <christoffer.dall@linaro.org> writes:
>>> >>
>>> >> > On Tue, Apr 28, 2015 at 10:34:12AM +0100, Peter Maydell wrote:
>>> >> >> On 28 April 2015 at 09:42, Alex Benn=C3=A9e <alex.bennee@lina=
ro.org> wrote:
>>> >> >> > Peter Maydell <peter.maydell@linaro.org> writes:
>>> >> >> >> Does the kernel already have a conveniently implemented "i=
nject
>>> >> >> >> exception into guest" lump of code? If so it might be less=
 effort
>>> >> >> >> to do it that way round, maybe.
>>> >> >> >
> <snip>
>>> >>
>>> >> Certainly there are some cases where the kernel doesn't have all=
 the
>>> >> information. For example it doesn't know if the soft break was i=
nserted
>>> >> by the guest or the host. That to me favours the "let userspace =
deal
>>> >> with the ugly" approach.
>>> >>
>>> > Not sure I follow.
>>> >
>>> > If it's an exception for the guest, then that must be because the=
 guest
>>> > put in the breakpoint instruction, right?
>>>
>>> No the host can add breakpoint instructions as well. They both gene=
rate
>>> the same (redirected) exception to the hypervisor which then has to
>>> figure out who planted the breakpoint and where the eventual except=
ion
>>> will be handled.
>>
>> I understand this; let's just rewind here.
>>
>> If you've concluded that the exception is for the guest, then the gu=
est
>> must have placed the breakpoint instruction there, correct?  Otherwi=
se,
>> the exception is for the hypervisor and the discussion about how to
>> inject an exception for the guest is invalid.
>
> But only userspace has enough information to make that conclusion (af=
ter
> searching the list of breakpoints it added to the code). So from
> userspace we can:
>
>   - re-enter KVM telling it to re-route the exception it just deliver=
ed
>     to userspace somehow
>
>   or
>
>   - make the changes to deliver the exception in userspace and re-ent=
er
>     KVM as normal.
>

ok, we agree and are talking about the same thing.  good.

> It seems to me if we have already exited into userspace it may as wel=
l
> clean up if it has all the information it needs?
>

depends on the complexity and size of the code really, imho.

>> Or are you talking about the corner case where the host uses a soft
>> breakpoint to get a breakpoint on an instruction which is also a
>> breakpoint in the guest?
>
> I think in this case host debugging just wins.
>
ok
