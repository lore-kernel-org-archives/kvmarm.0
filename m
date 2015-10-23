From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v5 0/7] KVM: arm64: Implement API for vGICv3 live migration
Date: Fri, 23 Oct 2015 15:20:16 +0100
Message-ID: <CAFEAcA_SpUa9Czk4=95h-0RpHTBKVVf8CkX_5S7XOO7kt7at-Q@mail.gmail.com>
References: <cover.1444638023.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <cover.1444638023.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 12 October 2015 at 09:29, Pavel Fedin <p.fedin@samsung.com> wrote:
> This patchset adds necessary userspace API in order to support vGICv3 live
> migration. GICv3 registers are accessed using device attribute ioctls,
> similar to GICv2.
>
> Whoever wants to test it, please note that this version is not
> binary-compatible with previous one, the API has been seriously changed.
> qemu patchess will be posted in some time.
>
> v4 => v5:
> - Adapted to new API by Peter Maydell, Marc Zyngier and Christoffer Dall.
>   Acked-by's on the documentation were dropped, just in case, because i
>   slightly adjusted it. Additionally, i merged all doc updates into one
>   patch.

Could you tell us what you changed in the doc patch from the version
that got sent out with the acks, please?

thanks
-- PMM
