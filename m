From: Prakash B <bjsprakash.linux@gmail.com>
Subject: Re: [PATCH v5 05/22] KVM: arm64: vgic-its: KVM_DEV_ARM_VGIC_GRP_ITS_REGS
 group
Date: Wed, 26 Apr 2017 16:53:00 +0530
Message-ID: <CACJhumchKeDYDQY9s0DO2GConjM9M625S1sNQ1aW0VfNuwF1Xw@mail.gmail.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com> <1492164934-988-6-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1492164934-988-6-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, Peter Maydell <peter.maydell@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 14, 2017 at 3:45 PM, Eric Auger <eric.auger@redhat.com> wrote:
> The ITS KVM device exposes a new KVM_DEV_ARM_VGIC_GRP_ITS_REGS
> group which allows the userspace to save/restore ITS registers.
>
> At this stage the get/set/has operations are not yet implemented.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
>

Tested-by: Prakash, Brahmajyosyula <Brahmajyosyula.Prakash@cavium.com>
