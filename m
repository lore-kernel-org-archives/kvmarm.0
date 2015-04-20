From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 0/4] QEMU support for KVM Guest Debug on arm64
Date: Mon, 20 Apr 2015 16:17:11 +0100
Message-ID: <87egnex214.fsf@linaro.org>
References: <1427816446-31586-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1427816446-31586-1-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: qemu-devel@nongnu.org, peter.maydell@linaro.org, christoffer.dall@linaro.org, zhichao.huang@linaro.org
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu


Alex Benn=C3=A9e <alex.bennee@linaro.org> writes:

> Hi,
>
> I thought I'd sent V1 to the list but apparently not. Anyway this
> patch series provides the QEMU side of guest debug support for arm64.
> I'm assuming the first patch will be dropped when a proper merge of
> the linux-headers is done once the kernel side is upstreamed.
>
> There is nothing particularly special about the implementation detail=
s
> although some of the bit-fiddling is a little fiddly.
>
> GIT Repos:
>
> The patch series is based off a recent master and can be found at:
>
> https://github.com/stsquad/qemu
> branch: kvm/guest-debug-v2
>
> The kernel patches for this series are based off a v4.0-rc6 and can b=
e
> found at:
>
> https://git.linaro.org/people/alex.bennee/linux.git
> branch: guest-debug/4.0-rc6-v2
>
> Alex Benn=C3=A9e (4):
>   linux-headers: partial sync from my kernel tree (DEV)
>   target-arm: kvm - implement software breakpoints
>   target-arm: kvm - support for single step
>   target-arm: kvm - add support for HW assisted debug
>
<snip>

The kernel side has had two rounds of review and is getting into shape.
It would be nice if I could get some review of the QEMU side for balanc=
e
;-)

--=20
Alex Benn=C3=A9e
