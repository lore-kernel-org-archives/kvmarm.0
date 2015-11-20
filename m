From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v9 6/6] tests/guest-debug: introduce basic gdbstub tests
Date: Fri, 20 Nov 2015 16:17:19 +0000
Message-ID: <CAFEAcA9q1MpiM4vM+RH-YQ2RpB=eV-Xgyw1-yw6qHG0hbem6_Q@mail.gmail.com>
References: <1447345251-22625-1-git-send-email-alex.bennee@linaro.org> <1447345251-22625-7-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1447345251-22625-7-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, qemu-arm@nongnu.org, Christoffer Dall <christoffer.dall@linaro.org>, Zhichao Huang <zhichao.huang@linaro.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex@bennee.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 12 November 2015 at 16:20, Alex Benn=C3=A9e <alex.bennee@linaro.org>=
 wrote:
> From: Alex Benn=C3=A9e <alex@bennee.com>
>
> The aim of these tests is to combine with an appropriate kernel
> image (with symbol-file vmlinux) and check it behaves as it should.
> Given a kernel it checks:
>
>   - single step
>   - software breakpoint
>   - hardware breakpoint
>   - access, read and write watchpoints
>
> On success it returns 0 to the calling process.
>
> I've not plumbed this into the "make check" logic though as we need a
> solution for providing non-host binaries to the tests. However the te=
st
> is structured to work with pretty much any Linux kernel image as it
> uses the basic kernel_init code which is common across architectures.

Do these tests pass if you run them on the TCG QEMU, just out
of interest?

I'm not a great fan of tests that aren't in 'make check'
because IME they just bitrot, but as you say we have no
sensible approach for handling tests that need to run real
guest code :-(

thanks
-- PMM
