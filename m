From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 0/2] KVM: ARM: Enable vtimers with user space gic
Date: Fri, 16 Sep 2016 14:40:39 +0200
Message-ID: <6b92c411-8b27-a4c0-6969-38e32bbf18ab@redhat.com>
References: <1474007187-18673-1-git-send-email-agraf@suse.de>
 <57DBC782.7080305@arm.com> <060ADA14-786E-400E-9B11-61C34B7081B5@suse.de>
 <20160916122937.GA14140@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160916122937.GA14140@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Alexander Graf <agraf@suse.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 16/09/2016 14:29, Christoffer Dall wrote:
> > It may be useful for migrating a gicv2 VM to a gicv3 host without gicv2 emulation as well.
> 
> I don't see why you'd do this; the VGIC hardware can perfectly well be
> used for nesting as well, and this works rather well.

Can GICv3 emulate GICv2 in a guest?

Paolo
