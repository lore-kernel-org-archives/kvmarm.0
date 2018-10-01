From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm/arm64: Rename kvm_arm_config_vm to
 kvm_arm_setup_stage2
Date: Mon, 1 Oct 2018 16:45:19 +0100
Message-ID: <9f463e06-ae91-216c-10cd-6b3d023c59d0@arm.com>
References: <20181001130656.36999-1-marc.zyngier@arm.com>
 <20181001130656.36999-2-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6362D4A1D1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Oct 2018 11:44:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BZ+heEnEMuFG for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Oct 2018 11:44:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54E9449E4C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Oct 2018 11:44:19 -0400 (EDT)
In-Reply-To: <20181001130656.36999-2-marc.zyngier@arm.com>
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
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 10/01/2018 02:06 PM, Marc Zyngier wrote:
> VM tends to be a very overloaded term in KVM, so let's keep it
> to describe the virtual machine. For the virtual memory setup,
> let's use the "stage2" suffix.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

The intention was that the function would serve as the backend check
for the vm_type argument. That said, I am fine with the changes, FWIW:

Reviewed-by : Suzuki K Poulose <suzuki.poulose@arm.com>
