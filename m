From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: KVM: VHE: Context switch MDSCR_EL1
Date: Tue, 19 Jul 2016 13:44:15 +0100
Message-ID: <578E209F.10107@arm.com>
References: <1468918664-19130-1-git-send-email-marc.zyngier@arm.com>
 <d1313d99-31dd-e799-7f5b-fb03f928cefd@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8E2B412D0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2016 08:38:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TopTyqZPCpZ1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2016 08:38:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7FA3412C2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2016 08:38:10 -0400 (EDT)
In-Reply-To: <d1313d99-31dd-e799-7f5b-fb03f928cefd@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Tirumalesh Chalamarla <Tirumalesh.Chalamarla@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 19/07/16 13:25, Paolo Bonzini wrote:
> 
> 
> On 19/07/2016 10:57, Marc Zyngier wrote:
>> The kprobe enablement work has uncovered that changes made by
>> a guest to MDSCR_EL1 were propagated to the host when VHE was
>> enabled, leading to unexpected exception being delivered.
>>
>> Moving this register to the list of registers that are always
>> context-switched fixes the issue.
>>
>> Reported-by: Tirumalesh Chalamarla <Tirumalesh.Chalamarla@cavium.com>
>> Tested-by: Tirumalesh Chalamarla <Tirumalesh.Chalamarla@cavium.com>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/hyp/sysreg-sr.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)

[...]

> Can you add Fixes and Cc: stable headers?  Thanks,

Ah, I missed that. Thanks for the heads up, v2 coming shortly.

	M.
-- 
Jazz is not dead. It just smells funny...
