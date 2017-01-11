From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 2/5] arm64: Work around Falkor erratum 1003
Date: Wed, 11 Jan 2017 18:50:14 +0000
Message-ID: <1e9509cf-315d-f7cb-3ff5-cfa835b3720c@arm.com>
References: <20170111144118.17062-1-cov@codeaurora.org>
 <20170111144118.17062-2-cov@codeaurora.org>
 <20170111180627.GG20288@e104818-lin.cambridge.arm.com>
 <20170111183339.GC29247@leverpostej>
 <5da456f8-fcc5-b6e2-d58b-01a671da595b@codeaurora.org>
 <20170111183738.GD29247@leverpostej>
 <2069d58c-0b81-dad4-511f-05e7d002eb34@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7C804053D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 13:48:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3e9RPmlosTn3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Jan 2017 13:48:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B036C40296
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 13:48:33 -0500 (EST)
In-Reply-To: <2069d58c-0b81-dad4-511f-05e7d002eb34@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Timur Tabi <timur@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>
Cc: Mark Langsdorf <mlangsdo@redhat.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Jon Masters <jcm@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

[finally, some proper bikeshedding]

On 11/01/17 18:40, Timur Tabi wrote:
> On 01/11/2017 12:37 PM, Mark Rutland wrote:
>> The name, as it is, is perfectly descriptive.
>>
>> Let's not sacrifice legibility over a non-issue.
> 
> I don't want to kick a dead horse or anything, but changing it to 
> QCOM_FLKR_ERRATUM_1003 would eliminate all the spacing problems without 
> sacrificing anything.

Other than not being able to grep for the core name in the source tree,
how do you suggest we pronounce FLKR? Because so far, it rolls off the
tongue in an interesting way...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
