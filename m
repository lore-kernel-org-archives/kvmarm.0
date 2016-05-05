From: Tom Hanson <thomas.hanson@linaro.org>
Subject: Re: [PATCH v2 14/54] KVM: arm/arm64: vgic-new: Implement virtual IRQ
 injection
Date: Thu, 5 May 2016 10:34:48 -0600
Message-ID: <572B7628.4020608@linaro.org>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-15-git-send-email-andre.przywara@arm.com>
 <57293844.1060802@linaro.org> <572B2D88.3050504@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <572B2D88.3050504@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Eric Auger <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/05/2016 05:24 AM, Andre Przywara wrote:
> Hi Tom,
>
> thanks for looking at the patches!
>

You're quite welcome.  It's a great way to spin-up.

> The idea isn't too bad indeed.
> I see that we could use that in vgic_queue_irq_unlock() and
> vgic_mmio_write_sactive().
> But as Marc mentioned in a conversation yesterday we will have a mixture
> of wrapped locks and open coded lock sequences. See for instance
> vgic_prune_ap_list(), where we have the sequence, but we can't use
> vgic_lock_aplist_irq() because the IRQ lock is taken inside the loop
> while the ap_list_lock is taken once outside of it.

Agreed.  I looked at a few places where it wouldn't work. Definitely not a blanket solution but every little bit helps, especially if it helps avoid a bug such as a deadlock that may take hours to track down.  Been there, done that. :-)


