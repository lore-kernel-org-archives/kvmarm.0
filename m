From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v6 03/13] arm64: cpufeature: Detect CPU RAS Extentions
Date: Thu, 25 Jan 2018 16:27:45 +0800
Message-ID: <daa4f204-a089-75ed-fdf4-625d3a58f6bc@huawei.com>
References: <20180115193906.30053-1-james.morse@arm.com>
 <20180115193906.30053-4-james.morse@arm.com>
 <78d4374a-f75c-6860-38ab-6373ffae3eee@huawei.com> <5A663C59.6030205@arm.com>
 <2fbdd6f2-3225-1993-cae5-0bc435189d36@huawei.com> <5A67877F.5090300@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1415149DB1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jan 2018 03:23:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u2VDivtgMBii for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jan 2018 03:23:41 -0500 (EST)
Received: from huawei.com (unknown [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C1F749DF0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jan 2018 03:23:41 -0500 (EST)
In-Reply-To: <5A67877F.5090300@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 2018/1/24 3:05, James Morse wrote:
>> do you mean we do not enable "CONFIG_ARM64_RAS_EXTN" in the
>> defconfig for ARM's SOC until kernel-first RAS is supported?
> I've no idea if or when we will do kernel-first, when I bring it up, its so we
> don't build a hybrid model, and we consider how we going to add kernel-first
> support if/when it comes along.
> 
> If you want it turned on in defconfig please submit a patch to do that. I
sorry, it is my mistake,
In your patch, ARM64_RAS_EXTN is already turned on by default, so no need to turn on again.

+config ARM64_RAS_EXTN
+       bool "Enable support for RAS CPU Extensions"
+       default y
+       help
+         CPUs that support the Reliability, Availability and Serviceability


> haven't because I don't know where they go!
