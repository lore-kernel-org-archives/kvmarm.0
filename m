From: Prakash B <bjsprakash.linux@gmail.com>
Subject: Re: [PATCH v5 06/22] KVM: arm/arm64: vgic: expose (un)lock_all_vcpus
Date: Wed, 26 Apr 2017 16:53:31 +0530
Message-ID: <CACJhume7fHb72Av=v78Whf47szu06Kwara4LYR4Cbdc8WLdjVA@mail.gmail.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com> <1492164934-988-7-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1492164934-988-7-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, Peter Maydell <peter.maydell@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 14, 2017 at 3:45 PM, Eric Auger <eric.auger@redhat.com> wrote:
> We need to use those helpers in vgic-its.c so let's
> expose them in the private vgic header.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Tested-by: Prakash, Brahmajyosyula <Brahmajyosyula.Prakash@cavium.com>
