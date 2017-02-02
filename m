From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC v3 09/10] KVM: arm64: Add the EL1 physical timer access
 handler
Date: Thu, 2 Feb 2017 11:31:03 +0100
Message-ID: <20170202103103.GH27852@cbox>
References: <1485970990-13775-1-git-send-email-jintack@cs.columbia.edu>
 <1485970990-13775-10-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D3EC40A66
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Feb 2017 05:30:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VSBKwOWXYTNt for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Feb 2017 05:30:45 -0500 (EST)
Received: from mail-lf0-f41.google.com (mail-lf0-f41.google.com
 [209.85.215.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B9F840296
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Feb 2017 05:30:45 -0500 (EST)
Received: by mail-lf0-f41.google.com with SMTP id z134so6065777lff.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Feb 2017 02:31:07 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1485970990-13775-10-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 01, 2017 at 12:43:09PM -0500, Jintack Lim wrote:
> KVM traps on the EL1 phys timer accesses from VMs, but it doesn't handle
> those traps. This results in terminating VMs. Instead, set a handler for
> the EL1 phys timer access, and inject an undefined exception as an
> intermediate step.
> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
