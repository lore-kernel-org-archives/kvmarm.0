From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v2 1/3] arm64: cacheinfo: add support for alternative
 format of CCSIDR_EL1
Date: Mon, 30 Jan 2017 17:19:18 +0000
Message-ID: <ca857fb8-15f9-4b03-3b5a-fbc16d5ff7d3@arm.com>
References: <1485793527-18028-1-git-send-email-sudeep.holla@arm.com>
 <ad552a58-4acd-f2ab-7d40-124b40c6c014@arm.com>
 <568a27c1-f910-46e8-7283-2040e28df380@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 349E740284
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:19:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5dhBO7t8h9RR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Jan 2017 12:19:03 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FE5E40190
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:19:03 -0500 (EST)
In-Reply-To: <568a27c1-f910-46e8-7283-2040e28df380@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 30/01/17 16:57, Sudeep Holla wrote:
>> Could this be static ? I could not see it used anywhere else outside
>> this file.
>
> Used in arch/arm64/kernel/cpuinfo.c

Ah, you're right.

Suzuki
