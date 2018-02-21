From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 18/40] KVM: arm64: Rewrite sysreg alternatives to
 static keys
Date: Wed, 21 Feb 2018 18:44:51 +0100
Message-ID: <20180221174451.4p24h2aqbymrjfqs@kamzik.brq.redhat.com>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-19-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 830204047F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Feb 2018 12:38:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J+20rrh77zhU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Feb 2018 12:38:17 -0500 (EST)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 65CF649DF1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Feb 2018 12:38:17 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20180215210332.8648-19-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, Yury Norov <ynorov@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 15, 2018 at 10:03:10PM +0100, Christoffer Dall wrote:
> As we are about to move calls around in the sysreg save/restore logic,
> let's first rewrite the alternative function callers, because it is
> going to make the next patches much easier to read.
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/kvm/hyp/sysreg-sr.c | 17 ++++-------------
>  1 file changed, 4 insertions(+), 13 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
