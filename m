From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 23/26] KVM: arm/arm64: GICv4: Prevent a VM using GICv4
 from being saved
Date: Tue, 7 Nov 2017 16:34:04 +0000
Message-ID: <33f4de5f-004e-6b92-d4f6-651e536dc697@arm.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-24-marc.zyngier@arm.com>
 <1f75a11a-41c3-71b8-6abf-4aa2962e348e@redhat.com>
 <9c1e1c92-e0fa-737f-63ab-a335b93af6da@arm.com>
 <77d479e5-98f9-9081-a3a6-87bef1009775@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BED649D2B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 11:32:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fJiwWL0PLHqK for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Nov 2017 11:32:13 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3950649D29
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 11:32:12 -0500 (EST)
In-Reply-To: <77d479e5-98f9-9081-a3a6-87bef1009775@redhat.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 07/11/17 16:12, Auger Eric wrote:
> Hi Marc,
> 
> On 07/11/2017 16:38, Marc Zyngier wrote:
>> On 07/11/17 15:24, Auger Eric wrote:
>>> Hi Marc,
>>>
>>> Hi Marc,
>>> On 27/10/2017 16:28, Marc Zyngier wrote:
>>>> The GICv4 architecture doesn't make it easy for save/restore to
>>>> work, as it doesn't give any guarantee that the pending state
>>>> is written into the pending table.
>>>
>>> I don't understand where does the limitation exactly come from. Can't we
>>> use the GICR_VPENDBASER table data?
>> You can't. None of the tables that are written by either the ITS or the
>> redistributors are architected. All you know is that there is one bit
>> per vLPI, but that's it (you don't even know which one is which).
> Oh I thought the redistributor config and pending tables were fully
> specified (6.1.2 and 6.1.3 of the spec), except the 1kB of the pending
> table.

The property table is definitely architected. It is a lot less clear for
the pending table. The main issue is that you cannot really know when
the various bits have actually been flushed all the way from the
redistributor caches to memory to be introspected. Yes, it sucks.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
