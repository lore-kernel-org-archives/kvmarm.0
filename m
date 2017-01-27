From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v4 2/4] arm64: Work around Falkor erratum 1003
Date: Fri, 27 Jan 2017 14:38:49 +0000
Message-ID: <20170127143848.GA25899@leverpostej>
References: <20170125155232.10277-1-cov@codeaurora.org>
 <20170125155232.10277-2-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3B1D405DA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Jan 2017 09:39:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ND4aB2zyWSo5 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Jan 2017 09:39:43 -0500 (EST)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01on0068.outbound.protection.outlook.com [104.47.2.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E9074018B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Jan 2017 09:39:42 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170125155232.10277-2-cov@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>
Cc: Mark Langsdorf <mlangsdo@redhat.com>, linux-doc@vger.kernel.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, timur@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Neil Leeder <nleeder@codeaurora.org>, Jon Masters <jcm@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 25, 2017 at 10:52:30AM -0500, Christopher Covington wrote:
> The Qualcomm Datacenter Technologies Falkor v1 CPU may allocate TLB entries
> using an incorrect ASID when TTBRx_EL1 is being updated. When the erratum
> is triggered, page table entries using the new translation table base
> address (BADDR) will be allocated into the TLB using the old ASID. All
> circumstances leading to the incorrect ASID being cached in the TLB arise
> when software writes TTBRx_EL1[ASID] and TTBRx_EL1[BADDR], a memory
> operation is in the process of performing a translation using the specific
> TTBRx_EL1 being written, and the memory operation uses a translation table
> descriptor designated as non-global. EL2 and EL3 code changing the EL1&0
> ASID is not subject to this erratum because hardware is prohibited from
> performing translations from an out-of-context translation regime.
>
> Consider the following pseudo code.
>
>   write new BADDR and ASID values to TTBRx_EL1
>
> Replacing the above sequence with the one below will ensure that no TLB
> entries with an incorrect ASID are used by software.
>
>   write reserved value to TTBRx_EL1[ASID]
>   ISB
>   write new value to TTBRx_EL1[BADDR]
>   ISB
>   write new value to TTBRx_EL1[ASID]
>   ISB
>
> When the above sequence is used, page table entries using the new BADDR
> value may still be incorrectly allocated into the TLB using the reserved
> ASID. Yet this will not reduce functionality, since TLB entries incorrectly
> tagged with the reserved ASID will never be hit by a later instruction.

I agree that there should be no explicit accesses to the VAs for these
entries. So tasks should not see erroneous VAs, and we shouldn't see
synchronous TLB conflict aborts.

Regardless, can this allow conflicting TLB entries to be allocated to
the reserved ASID? e.g. if one task has a 4K mapping at a given VA, and
another has a 2M mapping which covers that VA, can both be allocated
into the TLBs under the reserved ASID?

Can that have any effect on asynchronous TLB lookups or page table
walks, e.g. for speculated accesses?

Thanks,
Mark.
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
