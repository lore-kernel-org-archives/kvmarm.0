From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH v3 2/5] arm64: Work around Falkor erratum 1003
Date: Tue, 24 Jan 2017 09:27:44 -0500
Message-ID: <ab7d621e-0ba2-f113-22fc-2866f9cba5f5@codeaurora.org>
References: <20170111144118.17062-1-cov@codeaurora.org>
 <20170111144118.17062-2-cov@codeaurora.org>
 <20170111180627.GG20288@e104818-lin.cambridge.arm.com>
 <278a45c0-bd49-b8a2-63ae-80ad851bab9b@arm.com>
 <20170111184052.GE29247@leverpostej>
 <20170112154548.twj2ktbfzbsarzbc@localhost>
 <20170112161214.GB12583@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170112161214.GB12583@leverpostej>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Langsdorf <mlangsdo@redhat.com>, kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <marc.zyngier@arm.com>, Jon Masters <jcm@redhat.com>, timur@codeaurora.org, linux-doc@vger.kernel.org, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 01/12/2017 11:12 AM, Mark Rutland wrote:
> On Thu, Jan 12, 2017 at 03:45:48PM +0000, Catalin Marinas wrote:
>> On Wed, Jan 11, 2017 at 06:40:52PM +0000, Mark Rutland wrote:
> 
>>> Likewise, I beleive we may need to modify cpu_set_reserved_ttbr0().
>>
>> This may be fine if my assumptions about this erratum are correct. In
>> the cpu_set_reserved_ttbr0() case we set TTBR0_EL1 to a table without
>> any entries, so no new entries could be tagged with the old ASID.
> 
> For some reason, I was under the impression that the issue was old table
> entries being allocated to the new ASID. Looking over the series again,
> it's not clear to me precisely which cases can occur.
> 
> It would be good to see that clarified.

I'll add more general background the commit message in the next revision
and I've also asked directly about this. The answer is that page table
entries using the new translation table base address will be allocated
into the TLB using the old ASID. If employing the workaround, it's
possible for page table entries using the new translation table base
to be allocated into the TLB using the reserved ASID.

Cov

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code
Aurora Forum, a Linux Foundation Collaborative Project.
