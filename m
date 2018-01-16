From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v6 03/13] arm64: cpufeature: Detect CPU RAS Extentions
Date: Tue, 16 Jan 2018 10:26:47 +0000
Message-ID: <8bab61f5-828e-928e-f0af-a55f7871fa55@arm.com>
References: <20180115193906.30053-1-james.morse@arm.com>
 <20180115193906.30053-4-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A042B49DFD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 05:21:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6-EtFoCee9nI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jan 2018 05:21:53 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B3C649DDC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 05:21:53 -0500 (EST)
In-Reply-To: <20180115193906.30053-4-james.morse@arm.com>
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
To: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 15/01/18 19:38, James Morse wrote:
> From: Xie XiuQi <xiexiuqi@huawei.com>
> 
> ARM's v8.2 Extentions add support for Reliability, Availability and
> Serviceability (RAS). On CPUs with these extensions system software
> can use additional barriers to isolate errors and determine if faults
> are pending. Add cpufeature detection.
> 
> Platform level RAS support may require additional firmware support.
> 
> Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
> [Rebased added config option, reworded commit message]
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
