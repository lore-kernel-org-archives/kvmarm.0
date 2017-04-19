From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: fix races in kvm_psci_vcpu_on
Date: Wed, 19 Apr 2017 08:56:20 +0100
Message-ID: <1916ac65-e50a-2867-c198-b50be5a2b5fd@arm.com>
References: <20170418155958.13406-1-drjones@redhat.com>
 <20170418155958.13406-2-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F338E40C5D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Apr 2017 03:53:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DrMKHTdqp7pu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Apr 2017 03:53:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97CCC40C5A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Apr 2017 03:53:44 -0400 (EDT)
In-Reply-To: <20170418155958.13406-2-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu
Cc: cdall@linaro.org, lkurusa@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 18/04/17 16:59, Andrew Jones wrote:
> Fix potential races in kvm_psci_vcpu_on() by taking the kvm->lock
> mutex.  In general, it's a bad idea to allow more than one PSCI_CPU_ON
> to process the same target VCPU at the same time.  One such problem
> that may arise is that one PSCI_CPU_ON could be resetting the target
> vcpu, which fills the entire sys_regs array with a temporary value
> including the MPIDR register, while another looks up the VCPU based
> on the MPIDR value, resulting in no target VCPU found.  Resolves both
> races found with the kvm-unit-tests/arm/psci unit test.
> 
> Reported-by: Levente Kurusa <lkurusa@redhat.com>
> Suggested-by: Christoffer Dall <cdall@linaro.org>
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
