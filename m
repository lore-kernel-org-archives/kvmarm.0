From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v10 0/6] QEMU support for KVM Guest Debug on arm64
Date: Tue, 15 Dec 2015 19:34:13 +0000
Message-ID: <CAFEAcA8xQzgz8oSL=WtammyRjckBbyJqvzvQo54TfCj9yovaTQ@mail.gmail.com>
References: <1449599553-24713-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1449599553-24713-1-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, qemu-arm <qemu-arm@nongnu.org>, Christoffer Dall <christoffer.dall@linaro.org>, Zhichao Huang <zhichao.huang@linaro.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 8 December 2015 at 18:32, Alex Benn=C3=A9e <alex.bennee@linaro.org> =
wrote:
> Hi,
>
> Here is the latest patch set to support debugging of KVM guests on
> arm64. The main changes are fixing arm32 compiles (mostly with stubs
> for the upcomming arm32 debug) and the usual bunch of minor tweaks an=
d
> clarifications following review.
>
> I've kept the GDB Python based test in tests/guest-debug and cleaned
> it up so it will work with python2/3 linked GDBs. It still isn't
> plumbed it in to the "make check" so can be dropped until we have a
> solution for testing against non-host binaries.
>
> So in summary the changes are:
>
>   - Fixed arm32 compile
>   - Use results of debug capability checks
>   - Whitespace and comment cleanups
>   - Py2/3 cleanliness for test script
>
> More detailed changelogs are attached to each patch.

Thanks, applied to target-arm.next. (I fixed a few typos
in comments and commit messages in a couple of places).

-- PMM
