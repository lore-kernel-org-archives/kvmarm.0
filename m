From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: VHE: Clear HCR_TGE when invalidating guest
 TLBs
Date: Thu, 2 Mar 2017 13:59:17 +0100
Message-ID: <20170302125917.GK1409@cbox>
References: <20170227152437.26261-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EECA40A54
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Mar 2017 07:58:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WpF8nbDzm2PP for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Mar 2017 07:58:24 -0500 (EST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 057AB40966
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Mar 2017 07:58:23 -0500 (EST)
Received: by mail-wm0-f41.google.com with SMTP id n11so24128815wma.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Mar 2017 04:59:36 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170227152437.26261-1-marc.zyngier@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, Tomasz Nowicki <tnowicki@caviumnetworks.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 27, 2017 at 03:24:37PM +0000, Marc Zyngier wrote:
> When invalidating guest TLBs, special care must be taken to
> actually shoot the guest TLBs and not the host ones if we're
> running on a VHE system.  This is controlled by the HCR_EL2.TGE
> bit, which we forget to clear before invalidating TLBs.
> 
> Address the issue by introducing two wrappers (__tlb_switch_to_guest
> and __tlb_switch_to_host) that take care of both the VTTBR_EL2
> and HCR_EL2.TGE switching.
> 
> Reported-by: Tomasz Nowicki <tnowicki@caviumnetworks.com>
> Tested-by: Tomasz Nowicki <tnowicki@caviumnetworks.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <cdall@linaro.org>
