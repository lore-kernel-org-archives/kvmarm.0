From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 07/12] KVM: arm/arm64: simplify vgic_find_range() and
 callers
Date: Sat, 14 Mar 2015 15:44:03 +0100
Message-ID: <20150314144403.GM10935@cbox>
References: <1426263012-22935-1-git-send-email-andre.przywara@arm.com>
 <1426263012-22935-8-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C20D448D94
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Mar 2015 10:37:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e1OIdY50f89J for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Mar 2015 10:37:12 -0400 (EDT)
Received: from mail-la0-f41.google.com (mail-la0-f41.google.com
 [209.85.215.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C42AB48DB2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Mar 2015 10:37:11 -0400 (EDT)
Received: by lamx15 with SMTP id x15so9879267lam.3
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Mar 2015 07:43:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1426263012-22935-8-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 13, 2015 at 04:10:07PM +0000, Andre Przywara wrote:
> The vgic_find_range() function in vgic.c takes a struct kvm_exit_mmio
> argument, but actually only used the length field in there. Since we
> need to get rid of that structure in that part of the code anyway,
> let's rework the function (and it's callers) to pass the length
> argument to the function directly.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
