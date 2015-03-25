From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 01/12] KVM: Redesign kvm_io_bus_ API to pass VCPU
 structure to the callbacks.
Date: Wed, 25 Mar 2015 16:56:34 +0000
Message-ID: <5512E8C2.9010708@arm.com>
References: <1427126309-11223-1-git-send-email-andre.przywara@arm.com>
 <1427126309-11223-2-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB30449A38
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2015 12:49:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8n1QNRQ-qGHp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Mar 2015 12:49:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 570D749A06
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2015 12:49:40 -0400 (EDT)
In-Reply-To: <1427126309-11223-2-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 23/03/15 15:58, Andre Przywara wrote:
> From: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
> 
> This is needed in e.g. ARM vGIC emulation, where the MMIO handling
> depends on the VCPU that does the access.
> 
> Signed-off-by: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
