From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 01/13] arm64: cpufeature: __this_cpu_has_cap()
 shouldn't stop early
Date: Tue, 16 Jan 2018 09:51:10 +0000
Message-ID: <36faafb1-44e4-c451-c26b-2aabdf5d0304@arm.com>
References: <20180115193906.30053-1-james.morse@arm.com>
 <20180115193906.30053-2-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82FFC49DED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 04:46:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JFoGNVu1atxR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jan 2018 04:46:13 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64B0649DE6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 04:46:13 -0500 (EST)
In-Reply-To: <20180115193906.30053-2-james.morse@arm.com>
Content-Language: en-GB
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
Cc: Jonathan.Zhang@cavium.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 15/01/18 19:38, James Morse wrote:
> this_cpu_has_cap() tests caps->desc not caps->matches, so it stops
> walking the list when it finds a 'silent' feature, instead of
> walking to the end of the list.
> 
> Prior to v4.6's 644c2ae198412 ("arm64: cpufeature: Test 'matches' pointer
> to find the end of the list") we always tested desc to find the end of
> a capability list. This was changed for dubious things like PAN_NOT_UAO.
> v4.7's e3661b128e53e ("arm64: Allow a capability to be checked on
> single CPU") added this_cpu_has_cap() using the old desc style test.
> 
> CC: Suzuki K Poulose <suzuki.poulose@arm.com>
> CC: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
