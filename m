From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 06/17] kvm-arm: Remove kvm_pud_huge()
Date: Fri, 8 Apr 2016 14:44:04 +0200
Message-ID: <20160408124404.GQ8961@cbox>
References: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
 <1459787177-12767-7-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5ECC940F9B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 08:42:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c0Ve+u8kgYeV for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2016 08:42:25 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1693F4053F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 08:42:24 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id l6so63204971wml.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2016 05:43:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1459787177-12767-7-git-send-email-suzuki.poulose@arm.com>
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

On Mon, Apr 04, 2016 at 05:26:06PM +0100, Suzuki K Poulose wrote:
> Get rid of kvm_pud_huge() which falls back to pud_huge. Use
> pud_huge instead.
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
