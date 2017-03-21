From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 8/9] KVM: arm/arm64: vgic: Don't check vgic_initialized
 in flush_hwstate
Date: Tue, 21 Mar 2017 13:30:51 +0100
Message-ID: <20170321123051.GF15920@cbox>
References: <20170320105818.20481-1-cdall@linaro.org>
 <20170320105818.20481-9-cdall@linaro.org>
 <96b0efe2-d764-7b52-8335-0383a9357a1f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8265C40C58
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 08:29:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lyYmIgd1974k for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 08:29:05 -0400 (EDT)
Received: from mail-wr0-f171.google.com (mail-wr0-f171.google.com
 [209.85.128.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 68D9840BDA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 08:29:05 -0400 (EDT)
Received: by mail-wr0-f171.google.com with SMTP id l37so111113400wrc.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 05:30:52 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <96b0efe2-d764-7b52-8335-0383a9357a1f@arm.com>
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
Cc: Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 21, 2017 at 12:08:15PM +0000, Marc Zyngier wrote:
> On 20/03/17 10:58, Christoffer Dall wrote:
> > Now when we do an early init of the static parts of the VGIC data
> > structures, we can do things like checking if the AP lists are empty
> > directly without having to explicitly check if the vgic is initialized
> > and reduce a bit of work in our criticial path.
> 
>                                   critical
> 
> > Note: list_empty is a single atomic read (uses READ_ONCE) and can
> > therefore check if a list is empty or not without the need to take the
> > spinlock protecting the list.
> 
> This note might be better placed in patch #2.

Agreed.

> 
> > 
> > Signed-off-by: Christoffer Dall <cdall@linaro.org>
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> 

Thanks,
-Christoffer
