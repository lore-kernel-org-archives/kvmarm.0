From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH v3 7/9] KVM: arm/arm64: Only clean the dcache on
 translation fault
Date: Tue, 21 Aug 2018 15:35:14 +0200
Message-ID: <bfeee11e-f8bf-78f2-ab61-27e43781e2e3@suse.de>
References: <20171023161122.15291-1-marc.zyngier@arm.com>
 <20171023161122.15291-8-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 403644A219
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Aug 2018 09:35:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KHEfOCE6monq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Aug 2018 09:35:16 -0400 (EDT)
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B2CD4A1DB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Aug 2018 09:35:16 -0400 (EDT)
In-Reply-To: <20171023161122.15291-8-marc.zyngier@arm.com>
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
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 10/23/2017 06:11 PM, Marc Zyngier wrote:
> The only case where we actually need to perform a dcache maintenance
> is when we map the page for the first time, and subsequent permission
> faults do not require cache maintenance. Let's make it conditional
> on not being a permission fault (and thus a translation fault).
>
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

This patch unfortunately breaks something on Hi1616 SoCs when running 
32bit guests. With this patch applied (and thus with 4.18) I get random 
illegal instruction warnings from 32bit code inside VMs. I do not know 
at this point whether this affects other CPUs as well.

If anyone is interested in a reproducer, I have something handy. But for 
now I believe we should just revert this patch.


Alex
