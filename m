From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v6 03/13] arm64: cpufeature: Detect CPU RAS Extentions
Date: Tue, 23 Jan 2018 17:06:53 +0800
Message-ID: <2fbdd6f2-3225-1993-cae5-0bc435189d36@huawei.com>
References: <20180115193906.30053-1-james.morse@arm.com>
 <20180115193906.30053-4-james.morse@arm.com>
 <78d4374a-f75c-6860-38ab-6373ffae3eee@huawei.com> <5A663C59.6030205@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7150049DAD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jan 2018 04:02:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QFxs4kzl7pf6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Jan 2018 04:02:27 -0500 (EST)
Received: from huawei.com (unknown [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F85B49D66
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jan 2018 04:02:27 -0500 (EST)
In-Reply-To: <5A663C59.6030205@arm.com>
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

Hi James,

On 2018/1/23 3:32, James Morse wrote:
>> it seems this "CONFIG_ARM64_RAS_EXTN" is not enabled in the "arch/arm64/configs/defconfig",
>> if not, I want to enable this config to enable RAS feature in the defconfig. do you agree?
> Sure. This series doesn't do a lot on its own, it expects firmware-first or
> kernel-first support, which may in turn depend-on this feature. It means we
> don't panic() when notified of corrected errors, until we get the
> {firmware,kernel}-first support.
> 
> Don't defconfig changes get collected by arm-soc? (I'm not sure how these get
> picked up...)

Now we should have supported firmware-first, do you mean we do not enable "CONFIG_ARM64_RAS_EXTN" in the
defconfig for ARM's SOC until kernel-first RAS is supported?

> 
> 
> James
