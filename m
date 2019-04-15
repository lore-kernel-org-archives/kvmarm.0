From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v13 5/8] arm64: KVM: Enable !VHE support for :G/:H perf
 event modifiers
Date: Mon, 15 Apr 2019 14:02:59 +0100
Message-ID: <251d4e6c-2f92-62d3-59e9-980295303e87@arm.com>
References: <20190409192217.23459-1-andrew.murray@arm.com>
 <20190409192217.23459-6-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A721E4A492
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 09:03:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wf+6rqLqV4uy for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Apr 2019 09:03:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A02C24A484
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 09:03:02 -0400 (EDT)
In-Reply-To: <20190409192217.23459-6-andrew.murray@arm.com>
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
> Enable/disable event counters as appropriate when entering and exiting
> the guest to enable support for guest or host only event counting.
> 
> For both VHE and non-VHE we switch the counters between host/guest at
> EL2.
> 
> The PMU may be on when we change which counters are enabled however
> we avoid adding an isb as we instead rely on existing context
> synchronisation events: the eret to enter the guest (__guest_enter)
> and eret in kvm_call_hyp for __kvm_vcpu_run_nvhe on returning.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
