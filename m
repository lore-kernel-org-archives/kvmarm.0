From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 17/36] KVM: arm64: Introduce separate VHE/non-VHE
 sysreg save/restore functions
Date: Mon, 11 Dec 2017 10:22:34 +0000
Message-ID: <85c08278-268e-1bb8-60e1-9a85be5e61e4@arm.com>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
 <20171207170630.592-18-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1078B49D1F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 05:19:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WAUR4cxYSHvA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Dec 2017 05:19:12 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6E1B49D14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 05:19:11 -0500 (EST)
In-Reply-To: <20171207170630.592-18-christoffer.dall@linaro.org>
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
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/12/17 17:06, Christoffer Dall wrote:
> As we are about to handle system registers quite differently between VHE
> and non-VHE systems.  In preparation for that, we need to split some of
> the handling functions between VHE and non-VHE functionality.
> 
> For now, we simply copy the non-VHE functions, but we do change the use
> of static keys for VHE and non-VHE functionality now that we have
> separate functions.
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
