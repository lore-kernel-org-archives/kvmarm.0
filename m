From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 03/13] arm64: cpufeature: Detect CPU RAS Extentions
Date: Tue, 23 Jan 2018 19:05:35 +0000
Message-ID: <5A67877F.5090300@arm.com>
References: <20180115193906.30053-1-james.morse@arm.com>
 <20180115193906.30053-4-james.morse@arm.com>
 <78d4374a-f75c-6860-38ab-6373ffae3eee@huawei.com> <5A663C59.6030205@arm.com>
 <2fbdd6f2-3225-1993-cae5-0bc435189d36@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A96EF49DC9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jan 2018 14:02:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AQZibeqtW0ON for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Jan 2018 14:02:37 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CB2049DA2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jan 2018 14:02:37 -0500 (EST)
In-Reply-To: <2fbdd6f2-3225-1993-cae5-0bc435189d36@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 23/01/18 09:06, gengdongjiu wrote:
> On 2018/1/23 3:32, James Morse wrote:
>>> it seems this "CONFIG_ARM64_RAS_EXTN" is not enabled in the "arch/arm64/configs/defconfig",
>>> if not, I want to enable this config to enable RAS feature in the defconfig. do you agree?
>> Sure. This series doesn't do a lot on its own, it expects firmware-first or
>> kernel-first support, which may in turn depend-on this feature. It means we
>> don't panic() when notified of corrected errors, until we get the
>> {firmware,kernel}-first support.
>>
>> Don't defconfig changes get collected by arm-soc? (I'm not sure how these get
>> picked up...)
> 
> Now we should have supported firmware-first,

For NOTIFY_SEI? We don't have that yet.
This series was about the minimal handling for systems with neither firmware or
kernel first handling. This stops us panic()ing on corrected errors.
It also enables IESB which benefits firmware first handling using the
notification types we already support. (SEA, POLL, IRQ etc)

>From here we can add KVM APIs, firmware-first notification support and
kernel-first support as independent series.


> do you mean we do not enable "CONFIG_ARM64_RAS_EXTN" in the
> defconfig for ARM's SOC until kernel-first RAS is supported?

I've no idea if or when we will do kernel-first, when I bring it up, its so we
don't build a hybrid model, and we consider how we going to add kernel-first
support if/when it comes along.

If you want it turned on in defconfig please submit a patch to do that. I
haven't because I don't know where they go!


Thanks,

James
