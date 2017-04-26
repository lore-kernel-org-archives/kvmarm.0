From: Prakash B <bjsprakash.linux@gmail.com>
Subject: Re: [PATCH v5 17/22] KVM: arm64: vgic-its: Collection table save/restore
Date: Wed, 26 Apr 2017 17:03:06 +0530
Message-ID: <CACJhumdGJ4Y1SzEQDVNGRrp=NCQ1gX_ptfDTnUKhJ8WDhgw2_g@mail.gmail.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com> <1492164934-988-18-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1492164934-988-18-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, Peter Maydell <peter.maydell@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 14, 2017 at 3:45 PM, Eric Auger <eric.auger@redhat.com> wrote:
> The save path copies the collection entries into guest RAM
> at the GPA specified in the BASER register. This obviously
> requires the BASER to be set. The last written element is a
> dummy collection table entry.
>
> We do not index by collection ID as the collection entry
> can fit into 8 bytes while containing the collection ID.
>
> On restore path we re-allocate the collection objects.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Prakash, Brahmajyosyula <Brahmajyosyula.Prakash@cavium.com>
