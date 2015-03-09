From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 5/6] target-arm/kvm64: fix save/restore of SPSR regs
Date: Mon, 9 Mar 2015 20:31:44 +0100
Message-ID: <20150309193144.GG20559@cbox>
References: <1424880159-29348-1-git-send-email-alex.bennee@linaro.org>
 <1424880159-29348-7-git-send-email-alex.bennee@linaro.org>
 <20150302172212.GB10137@lvm>
 <874mq27222.fsf@linaro.org>
 <20150309125650.GA20559@cbox>
 <CAFEAcA_DqHx-sDMuhSr0-uQL20-uJzXXpBvr6YLUWmzMN2mL4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA_DqHx-sDMuhSr0-uQL20-uJzXXpBvr6YLUWmzMN2mL4w@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, QEMU Developers <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 09, 2015 at 10:31:19PM +0900, Peter Maydell wrote:
> On 9 March 2015 at 21:56, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> > this function, however, is not used only when migration, but should
> > generally cover the case where you want to synchronize QEMU's state into
> > KVM's state, right?  So while it may not be harmful in currently
> > supported use cases, is there ever a situation where (is_a64(env) && el
> > == 0) and env->spsr != banked_spsr[el], and where env->spsr is
> > out-of-date?
> 
> If EL == 0 then you can't access any SPSR, so env->spsr is by
> definition out of date.
> 
ok, never mind then.

-Christoffer
