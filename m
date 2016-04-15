From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v7 1/6] KVM: arm/arm64: Add VGICv3 save/restore API documentation
Date: Fri, 15 Apr 2016 14:58:27 +0100
Message-ID: <CAFEAcA_N7F4r6fpQTW8Duyu577=uGcRyS7VhAMxumwTDN3khcw@mail.gmail.com>
References: <cover.1449491035.git.p.fedin@samsung.com> <204d6b178e611ee0b5aede2b945516e0a6048c3c.1449491035.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <204d6b178e611ee0b5aede2b945516e0a6048c3c.1449491035.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 7 December 2015 at 12:29, Pavel Fedin <p.fedin@samsung.com> wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
>
> Factor out the GICv3-specific documentation into a separate
> documentation file.  Add description for how to access distributor,
> redistributor, and CPU interface registers for GICv3 in this new file.
>
> Acked-by: Peter Maydell <peter.maydell@linaro.org>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>

Nothing in here describes a mechanism for reading or writing the
current interrupt line_level state from the kernel (which doesn't
matter for edge triggered interrupts but does for level triggered
interrupts). Do we need accessors for these or does somebody
have a good rationale for why we don't need to migrate that data?
(Christoffer?)

(GICv2 doesn't do this either and I suspect it's wrong too.)

thanks
-- PMM
