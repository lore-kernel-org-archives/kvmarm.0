From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v9 3/8] KVM: arm/arm64: Introduce helpers to manipulate
 page table entries
Date: Mon, 10 Dec 2018 10:01:45 +0100
Message-ID: <20181210090145.GE30263@e113682-lin.lund.arm.com>
References: <20181031175745.18650-1-punit.agrawal@arm.com>
 <20181031175745.18650-4-punit.agrawal@arm.com>
 <396402d5-fddf-ab72-01c4-80dd1a0d4d44@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <396402d5-fddf-ab72-01c4-80dd1a0d4d44@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Punit Agrawal <punit.agrawal@arm.com>, kvmarm@lists.cs.columbia.edu, suzuki.poulose@arm.com, marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com, linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>, punitagrawal@gmail.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 03, 2018 at 07:20:08PM +0530, Anshuman Khandual wrote:
> 
> 
> On 10/31/2018 11:27 PM, Punit Agrawal wrote:
> > Introduce helpers to abstract architectural handling of the conversion
> > of pfn to page table entries and marking a PMD page table entry as a
> > block entry.
> 
> Why is this necessary ? we would still need to access PMD, PUD as is
> without any conversion. IOW KVM knows the breakdown of the page table
> at various levels. Is this something required from generic KVM code ?
>   
> > 
> > The helpers are introduced in preparation for supporting PUD hugepages
> > at stage 2 - which are supported on arm64 but do not exist on arm.
> 
> Some of these patches (including the earlier two) are good on it's
> own. Do we have still mention in commit message about the incoming PUD
> enablement as the reason for these cleanup patches ?
> 

Does it hurt?  What is your concern here?


Thanks,

    Christoffer
