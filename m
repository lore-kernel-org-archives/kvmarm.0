From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] KVM: arm64: vgic-its: Remove VLA usage
Date: Fri, 29 Jun 2018 23:25:05 +0200
Message-ID: <CAK8P3a18SfxL5RfyrUuDGK9wr34kHEa2MxMxK1tHgRBBb7N3jQ@mail.gmail.com>
References: <20180629184618.GA37364@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180629184618.GA37364@beast>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jun 29, 2018 at 8:46 PM, Kees Cook <keescook@chromium.org> wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> switches to using a maximum size and adds sanity checks. Additionally
> cleans up some of the int-vs-u32 usage and adds additional bounds checking.
> As it currently stands, this will always be 8 bytes until the ABI changes.
>
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Andre Przywara <andre.przywara@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kvmarm@lists.cs.columbia.edu
> Signed-off-by: Kees Cook <keescook@chromium.org>


Looks good to me.

    Arnd
