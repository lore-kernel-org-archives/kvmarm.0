From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH v2 2/5] arm64: Work around Falkor erratum 1003
Date: Wed, 11 Jan 2017 08:11:08 -0500
Message-ID: <4bd902f7-4900-7ee6-6346-e3f4897afef2@codeaurora.org>
References: <20161229224335.13531-1-cov@codeaurora.org>
 <20161229224335.13531-2-cov@codeaurora.org> <20170104103322.GA20461@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E90E640295
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 08:09:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vpbqyKewE3OW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Jan 2017 08:09:28 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B522A4027C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 08:09:28 -0500 (EST)
In-Reply-To: <20170104103322.GA20461@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-doc@vger.kernel.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, timur@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 01/04/2017 05:33 AM, Christoffer Dall wrote:
> On Thu, Dec 29, 2016 at 05:43:32PM -0500, Christopher Covington wrote:
>> From: Shanker Donthineni <shankerd@codeaurora.org>
>>
>> On the Qualcomm Datacenter Technologies Falkor v1 CPU, memory accesses may
>> allocate TLB entries using an incorrect ASID when TTBRx_EL1 is being
>> updated. Changing the TTBRx_EL1[ASID] and TTBRx_EL1[BADDR] fields
>> separately using a reserved ASID will ensure that there are no TLB entries
>> with incorrect ASID after changing the the ASID.
> 
> When we restore guest state in KVM, we completely save and restore
> TTBRx_EL1 from EL2. Would that be affected by this erratum?

Good question, but apparently not. I'll add the following explanation to the
v3 commit message.

"EL2 and EL3 code changing the EL1&0 ASID is not subject to this erratum
because hardware is prohibited from performing translations from an
out-of-context translation regime."

Thanks,
Cov

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code
Aurora Forum, a Linux Foundation Collaborative Project.
