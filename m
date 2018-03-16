From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: arm64 kvm built with clang doesn't boot
Date: Fri, 16 Mar 2018 15:00:38 +0000
Message-ID: <2e84a842-96e8-aec4-8b85-9ee879bb323a@arm.com>
References: <CAAeHK+xjnXnrG0p06r-QRcUucYi5vcTJOn3mSS-JVxX9_TYg4w@mail.gmail.com>
 <26a25069-ea1d-5fb3-549c-ab653f454a30@arm.com>
 <CAAeHK+zq4-mw3pCNf3nob3gN-s+aWVq7vUy1p8yY4bU4QYNNMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAAeHK+zq4-mw3pCNf3nob3gN-s+aWVq7vUy1p8yY4bU4QYNNMg@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Stephen Hines <srhines@google.com>, Greg Hackmann <ghackmann@google.com>, Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, kernel-dynamic-tools <kernel-dynamic-tools@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/03/18 14:53, Andrey Konovalov wrote:
> On Fri, Mar 16, 2018 at 3:13 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> I wasn't aware of that discussion, but this is indeed quite annoying.
>> Note that you should be able to restrict this to arch/arm64/kvm/hyp/*
>> and virt/kvm/arm/hyp/*.
> 
> That works as well (tried it, the kernel boots). I've also tried
> compiling without the flag for virt/kvm/arm/hyp/*, it boots as well.

That's just luck. Anything in a hyp/ directory has the potential to be
executed at EL2, and thus could be generating these jump tables. It
could blow up at a later time, once you start running VMs...

	M.
-- 
Jazz is not dead. It just smells funny...
