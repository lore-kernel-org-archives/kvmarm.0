From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 2/8] ARM: KVM: Properly sort the invariant table
Date: Wed, 10 Feb 2016 13:44:36 +0100
Message-ID: <20160210124436.GI5171@cbox>
References: <1454931622-14902-1-git-send-email-marc.zyngier@arm.com>
 <1454931622-14902-3-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6C5449AD4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 07:38:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QOKvdyYRdz43 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Feb 2016 07:38:07 -0500 (EST)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EAF1049AE3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 07:38:06 -0500 (EST)
Received: by mail-wm0-f48.google.com with SMTP id p63so26713832wmp.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 04:43:58 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1454931622-14902-3-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 08, 2016 at 11:40:16AM +0000, Marc Zyngier wrote:
> Not having the invariant table properly sorted is an oddity, and
> may get in the way of future optimisations. Let's fix it.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
