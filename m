From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] arm64/kvm: fix misleading kconfig text for 16K pages
Date: Fri, 2 Jun 2017 15:18:30 +0200
Message-ID: <20170602131830.GC397@cbox>
References: <1496401340-24802-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A19A640C4A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jun 2017 09:14:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U1PwMpWKK48J for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jun 2017 09:14:47 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6448E40C49
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jun 2017 09:14:47 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id m7so12161511wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Jun 2017 06:18:46 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1496401340-24802-1-git-send-email-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jun 02, 2017 at 12:02:20PM +0100, Mark Rutland wrote:
> We've supported KVM with 16K pages since commit:
> 
>   02e0b7600f835007 ("arm64: kvm: Add support for 16K pages")
> 
> ... yet the kconfig text says this combination is not supported.
> 
> Let's fix that by deleting the misleading text.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu

Acked-by: Christoffer Dall <cdall@linaro.org>
