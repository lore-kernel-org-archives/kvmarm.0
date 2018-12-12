From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v8 3/5] arm64: KVM: add accessors to track guest/host only
 counters
Date: Wed, 12 Dec 2018 10:56:11 +0000
Message-ID: <344aa2be-ea9d-24fe-b3e5-742b3344722d@arm.com>
References: <1544610573-28446-1-git-send-email-andrew.murray@arm.com>
 <1544610573-28446-4-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CF894A200
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 05:56:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z8c78i5D0Rg2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Dec 2018 05:56:15 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B8C04A1FA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 05:56:15 -0500 (EST)
In-Reply-To: <1544610573-28446-4-git-send-email-andrew.murray@arm.com>
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
To: Andrew Murray <andrew.murray@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 12/12/2018 10:29, Andrew Murray wrote:
> In order to effeciently enable/disable guest/host only perf counters
> at guest entry/exit we add bitfields to kvm_cpu_context for guest and
> host events as well as accessors for updating them.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
