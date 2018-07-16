From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v6 2/8] KVM: arm/arm64: Re-factor setting the Stage 2
 entry to exec on fault
Date: Mon, 16 Jul 2018 13:46:43 +0100
Message-ID: <ee0a72a5-ffa9-6016-80e7-0abc6d65f514@arm.com>
References: <20180716110857.19310-1-punit.agrawal@arm.com>
 <20180716110857.19310-3-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61BE24A129
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 08:33:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J-auoNyVckDe for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Jul 2018 08:33:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 689744A105
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 08:33:48 -0400 (EDT)
In-Reply-To: <20180716110857.19310-3-punit.agrawal@arm.com>
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
To: Punit Agrawal <punit.agrawal@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 16/07/18 12:08, Punit Agrawal wrote:
> Stage 2 fault handler marks a page as executable if it is handling an
> execution fault or if it was a permission fault in which case the
> executable bit needs to be preserved.
> 
> The logic to decide if the page should be marked executable is
> duplicated for PMD and PTE entries. To avoid creating another copy
> when support for PUD hugepages is introduced refactor the code to
> share the checks needed to mark a page table entry as executable.
> 
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
