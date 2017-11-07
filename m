From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 23/26] KVM: arm/arm64: GICv4: Prevent a VM using GICv4
 from being saved
Date: Tue, 7 Nov 2017 15:38:26 +0000
Message-ID: <9c1e1c92-e0fa-737f-63ab-a335b93af6da@arm.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-24-marc.zyngier@arm.com>
 <1f75a11a-41c3-71b8-6abf-4aa2962e348e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1f75a11a-41c3-71b8-6abf-4aa2962e348e@redhat.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Andre Przywara <Andre.Przywara@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Christoffer Dall <christoffer.dall@linaro.org>, Shanker Donthineni <shankerd@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 07/11/17 15:24, Auger Eric wrote:
> Hi Marc,
> 
> Hi Marc,
> On 27/10/2017 16:28, Marc Zyngier wrote:
>> The GICv4 architecture doesn't make it easy for save/restore to
>> work, as it doesn't give any guarantee that the pending state
>> is written into the pending table.
> 
> I don't understand where does the limitation exactly come from. Can't we
> use the GICR_VPENDBASER table data?
You can't. None of the tables that are written by either the ITS or the
redistributors are architected. All you know is that there is one bit
per vLPI, but that's it (you don't even know which one is which).

But that's not a big deal. I don't think you can realistically migrate a
VM that has a directly assigned device anyway. Or can we?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
