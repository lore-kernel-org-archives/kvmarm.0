From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC PATCH] arm64: KVM: remove fpsimd save/restore from the
 world switch
Date: Fri, 10 Apr 2015 11:20:45 +0100
Message-ID: <20150410102044.GC6854@e104818-lin.cambridge.arm.com>
References: <1428598439-5217-1-git-send-email-marc.zyngier@arm.com>
 <55278CAD.70302@redhat.com>
 <552793CF.8050904@arm.com>
 <CAFEAcA8J-kDHjkg9uFbHHAEu=zSSv+CB1Vmy1JBh==SmeiWL1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA8J-kDHjkg9uFbHHAEu=zSSv+CB1Vmy1JBh==SmeiWL1Q@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 10, 2015 at 11:01:36AM +0100, Peter Maydell wrote:
> On 10 April 2015 at 10:11, Marc Zyngier <marc.zyngier@arm.com> wrote:
> > I did some experimentations on arm64 a long while ago (see the
> > kvm-arm64/lazy-fp branch in my tree), and it wasn't that great,
> > apparently because aarch64 userspace tends to be much more FP happy than
> > aarch32, but I'm not completely sure about it.
> 
> Was that with the buggy version of the toolchain that had
> incorrect costs and so was much more inclined to spill
> integer values into the FPU than it should have been?
> It might be worth retesting with a freshly compiled
> userspace some day...

It really depends on what you mean by userspace (which benchmarks you
use). If for example you only care about Javascript heavy web
applications, all numbers are 64-bit floats. But I think it's worth
investigating.

We could also make it smarter and mark some tasks as FP heavy for a
limited time to avoid faults.

-- 
Catalin
