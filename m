From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v9 6/6] tests/guest-debug: introduce basic gdbstub tests
Date: Tue, 08 Dec 2015 12:02:11 +0000
Message-ID: <87poyhp2rg.fsf@linaro.org>
References: <1447345251-22625-1-git-send-email-alex.bennee@linaro.org> <1447345251-22625-7-git-send-email-alex.bennee@linaro.org> <CAFEAcA9q1MpiM4vM+RH-YQ2RpB=eV-Xgyw1-yw6qHG0hbem6_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <CAFEAcA9q1MpiM4vM+RH-YQ2RpB=eV-Xgyw1-yw6qHG0hbem6_Q@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, qemu-arm@nongnu.org, Christoffer Dall <christoffer.dall@linaro.org>, Zhichao Huang <zhichao.huang@linaro.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu


Peter Maydell <peter.maydell@linaro.org> writes:

> On 12 November 2015 at 16:20, Alex Benn=C3=A9e <alex.bennee@linaro.or=
g> wrote:
>> From: Alex Benn=C3=A9e <alex@bennee.com>
>>
>> The aim of these tests is to combine with an appropriate kernel
>> image (with symbol-file vmlinux) and check it behaves as it should.
>> Given a kernel it checks:
>>
>>   - single step
>>   - software breakpoint
>>   - hardware breakpoint
>>   - access, read and write watchpoints
>>
>> On success it returns 0 to the calling process.
>>
>> I've not plumbed this into the "make check" logic though as we need =
a
>> solution for providing non-host binaries to the tests. However the t=
est
>> is structured to work with pretty much any Linux kernel image as it
>> uses the basic kernel_init code which is common across architectures=
=2E
>
> Do these tests pass if you run them on the TCG QEMU, just out
> of interest?

You'll be glad to know they do.

> I'm not a great fan of tests that aren't in 'make check'
> because IME they just bitrot, but as you say we have no
> sensible approach for handling tests that need to run real
> guest code :-(

I was pondering if a git sub-project with large file support would work=
=2E
We could add pre-built binaries to the tree with appropriate meta-data
(src tree, version, config) to rebuild if required.

There would be some degree of trust implied in the original builder
though. Maybe a signed commit?

>
> thanks
> -- PMM


--
Alex Benn=C3=A9e
