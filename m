From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 04/10] KVM: arm/arm64: vgic: Allow HW irq to be encoded in LR
Date: Wed, 17 Jun 2015 14:21:59 +0100
Message-ID: <CAFEAcA8idJehTx75G1OzcPpg5ewx_6X15srx7iV6sszmiqHNFw@mail.gmail.com>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
 <1433783045-8002-5-git-send-email-marc.zyngier@arm.com> <55815FA5.4010203@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55815FA5.4010203@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm-devel <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 17 June 2015 at 12:53, Eric Auger <eric.auger@linaro.org> wrote:
> shouldn't we test somewhere that the hwirq is between 16 and 1019.

Not directly related, but that reminds me that I noticed the
other day that we have VGIC_MAX_IRQS = 1024 (and use that as a
guard on how many irqs we let userspace configure and ask us
to deliver), but that doesn't account for the couple of magic
numbers at the top of the range. I think that lets userspace
cause us to do UNPREDICTABLE things to the GIC...

-- PMM
