From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v13 8/8] arm64: docs: document perf event attributes
Date: Mon, 15 Apr 2019 15:05:34 +0100
Message-ID: <cb6d86d9-5bbf-e7fa-c7b6-b4d04d6aef1c@arm.com>
References: <20190409192217.23459-1-andrew.murray@arm.com>
 <20190409192217.23459-9-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEE834A486
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 10:05:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ekWz9PA+znng for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Apr 2019 10:05:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CCAC4A3BF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 10:05:38 -0400 (EDT)
In-Reply-To: <20190409192217.23459-9-andrew.murray@arm.com>
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
To: andrew.murray@arm.com, christoffer.dall@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 09/04/2019 20:22, Andrew Murray wrote:
> The interaction between the exclude_{host,guest} flags,
> exclude_{user,kernel,hv} flags and presence of VHE can result in
> different exception levels being filtered by the ARMv8 PMU. As this
> can be confusing let's document how they work on arm64.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---

Thats really helpful ! Thanks for writing one  !

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
