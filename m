From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 11/17] kvm-arm: Use explicit stage2 helper routines
Date: Fri, 8 Apr 2016 15:16:05 +0200
Message-ID: <20160408131605.GV8961@cbox>
References: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
 <1459787177-12767-12-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AA2840FA6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 09:14:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EoGKxkI2f17g for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2016 09:14:26 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20C6A40B58
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 09:14:26 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id n3so22244176wmn.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2016 06:15:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1459787177-12767-12-git-send-email-suzuki.poulose@arm.com>
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

On Mon, Apr 04, 2016 at 05:26:11PM +0100, Suzuki K Poulose wrote:
> We have stage2 page table helpers for both arm and arm64. Switch to
> the stage2 helpers for routines that only deal with stage2 page table.
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
