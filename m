From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 5/6] target-arm/kvm64: fix save/restore of SPSR regs
Date: Mon, 9 Mar 2015 22:31:19 +0900
Message-ID: <CAFEAcA_DqHx-sDMuhSr0-uQL20-uJzXXpBvr6YLUWmzMN2mL4w@mail.gmail.com>
References: <1424880159-29348-1-git-send-email-alex.bennee@linaro.org>
 <1424880159-29348-7-git-send-email-alex.bennee@linaro.org>
 <20150302172212.GB10137@lvm> <874mq27222.fsf@linaro.org> <20150309125650.GA20559@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150309125650.GA20559@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, QEMU Developers <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 9 March 2015 at 21:56, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> this function, however, is not used only when migration, but should
> generally cover the case where you want to synchronize QEMU's state into
> KVM's state, right?  So while it may not be harmful in currently
> supported use cases, is there ever a situation where (is_a64(env) && el
> == 0) and env->spsr != banked_spsr[el], and where env->spsr is
> out-of-date?

If EL == 0 then you can't access any SPSR, so env->spsr is by
definition out of date.

-- PMM
