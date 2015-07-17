From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 0/2] arm/arm64: KVM: Optimize arm64 fp/simd, saves
 30-50% on exits
Date: Fri, 17 Jul 2015 11:28:23 +0200
Message-ID: <20150717092823.GG14024@cbox>
References: <1437082178-11039-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DED8158BBC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 05:16:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P1Ta3gcKAxaU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2015 05:16:11 -0400 (EDT)
Received: from mail-lb0-f172.google.com (mail-lb0-f172.google.com
 [209.85.217.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A287258BBB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 05:16:11 -0400 (EDT)
Received: by lbbyj8 with SMTP id yj8so58060341lbb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 02:28:06 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1437082178-11039-1-git-send-email-m.smarduch@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jul 16, 2015 at 02:29:36PM -0700, Mario Smarduch wrote:
> Currently we save/restore fp/simd on each exit. The first patch optimizes arm64
> save/restore, we only do so on Guest access. hackbench and several lmbench
> tests show anywhere from 30% to 50% of exits don't context switch the vfp/simd
> registers.
> 
> For second patch 32-bit handler is updated to keep exit handling consistent
> with 64-bit code.
> 

For the series:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
