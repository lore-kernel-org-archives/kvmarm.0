From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 08/17] kvm-arm: arm: Introduce hyp page table empty checks
Date: Fri, 8 Apr 2016 15:15:43 +0200
Message-ID: <20160408131543.GS8961@cbox>
References: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
 <1459787177-12767-9-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D58FB40F90
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 09:14:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fIz2EcmUyjCI for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2016 09:14:04 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F3DFA40B58
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 09:14:03 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id v188so18022029wme.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2016 06:15:30 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1459787177-12767-9-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 04, 2016 at 05:26:08PM +0100, Suzuki K Poulose wrote:
> Introduce hyp_pxx_table_empty helpers for checking whether
> a given table entry is empty. This will be used explicitly
> once we switch to explicit routines for hyp page table walk.
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
