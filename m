From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 1/9] KVM: arm64: Allow creating the PMU without the
 in-kernel GIC
Date: Thu, 08 Jun 2017 15:00:44 +0100
Message-ID: <87fufainoz.fsf@arm.com>
References: <20170608133446.3875-1-cdall@linaro.org>
 <20170608133446.3875-2-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6F5240962
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jun 2017 09:56:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hQoP-I2nETbq for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Jun 2017 09:56:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99866405DA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jun 2017 09:56:38 -0400 (EDT)
In-Reply-To: <20170608133446.3875-2-cdall@linaro.org> (Christoffer Dall's
 message of "Thu, 8 Jun 2017 15:34:38 +0200")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 08 2017 at  3:34:38 pm BST, Christoffer Dall <cdall@linaro.org> wrote:
> Since we got support for devices in userspace which allows reporting the
> PMU overflow output status to userspace, we should actually allow
> creating the PMU on systems without an in-kernel irqchip, which in turn
> requires us to slightly clarify error codes for the ABI and move things
> around for the initialization phase.
>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead, it just smell funny.
