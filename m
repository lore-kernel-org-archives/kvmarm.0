From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v7 1/6] KVM: arm/arm64: Add VGICv3 save/restore API documentation
Date: Thu, 21 Apr 2016 19:44:49 +0100
Message-ID: <CAFEAcA_DBA7c4T-rLpJW4CVrGoAiofZsm7iMVYB2pK46J+fQxg@mail.gmail.com>
References: <cover.1449491035.git.p.fedin@samsung.com> <204d6b178e611ee0b5aede2b945516e0a6048c3c.1449491035.git.p.fedin@samsung.com>
 <CAFEAcA_N7F4r6fpQTW8Duyu577=uGcRyS7VhAMxumwTDN3khcw@mail.gmail.com>
 <CAMJs5B8b1kpdeUDPGOcyaiNjSo+ZSzzUZOS4+wJ6cWmjtd58dg@mail.gmail.com>
 <CAFEAcA8mtkLqrTKVQsCCG9xyb0MsFasxXZM=8bZ=covrBd6VrQ@mail.gmail.com> <20160421183056.GA25288@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160421183056.GA25288@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Pavel Fedin <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 21 April 2016 at 19:30, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> So I agree about the latch state, that should be exported, if nothing
> else so that a VM can't use this particular change to detect a
> migration, for example.
>
> However, for the input level, I really do see this as a wire state
> between userspace and the kernel, and as something that userspace should
> re-establish after migration, since userspace already knows what the
> line level is, why does it need to pull it out of the kernel again?

I guess userspace could track the line level as well as telling the
kernel about it, but we would still need an API for telling the
kernel "here is your line level state after a migration", because
that's not the same as "the line level just changed because the
device signaled an interrupt". (For the former, we just want to set
your 'level' struct field value. For the latter, a 0->1 level change
may mean "set pending"; but for migration we're already telling you
the current pending state via a different ioctl and don't want to
mess that up when we're telling you about the 'level' info.)
And if we have to have migration API for directly writing level bits we
might as well have the corresponding directly-read-level-bits one...

thanks
-- PMM
