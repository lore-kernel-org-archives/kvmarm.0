From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: Re: [PATCH v3 08/11] KVM: arm: implement dirty bit mechanism for debug registers
Date: Thu, 09 Jul 2015 20:54:25 +0800
Message-ID: <8E4AB63C-514A-46D0-9FF6-2158B2834CC6@linaro.org>
References: <1434969694-7432-1-git-send-email-zhichao.huang@linaro.org> <1434969694-7432-9-git-send-email-zhichao.huang@linaro.org> <20150630092020.GP11332@cbox> <B3B5AB0D-020C-483D-A6DE-76E355865010@linaro.org> <20150703115611.GB14220@lvm> <5A7DE9A0-E7A6-40B0-80F9-896F7DED0E47@linaro.org> <20150707102405.GE23879@arm.com> <123AABA4-2C79-462D-91FC-56FB52DB972C@linaro.org> <20150708170855.GB6348@arm.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150708170855.GB6348@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <Marc.Zyngier@arm.com>, "alex.bennee@linaro.org" <alex.bennee@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, "huangzhichao@huawei.com" <huangzhichao@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu



On July 9, 2015 1:08:55 AM GMT+08:00, Will Deacon <will.deacon@arm.com> wrote:
>On Wed, Jul 08, 2015 at 11:50:22AM +0100, Zhichao Huang wrote:
>> Are you happy with this?:
>
>You miss the reserved breakpoint, I think.

Sorry, I can't quite understand. What is the reserved breakpoint?

When arch_[iu]ninstall_hw_breakpoint is called, it only set/clear the
brps and wrps slots.

>I also still don't understand why this is preferable to trapping.
>
>Will

-- 
Zhichao Huang
