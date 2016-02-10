From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/8] arm64: KVM: Switch the sys_reg search to be a binary
 search
Date: Wed, 10 Feb 2016 13:44:28 +0100
Message-ID: <20160210124428.GH5171@cbox>
References: <1454931622-14902-1-git-send-email-marc.zyngier@arm.com>
 <1454931622-14902-2-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DD9549AE3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 07:38:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9iHyL4F0y6yV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Feb 2016 07:37:59 -0500 (EST)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78E0049AD4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 07:37:58 -0500 (EST)
Received: by mail-wm0-f49.google.com with SMTP id g62so25378809wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 04:43:50 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1454931622-14902-2-git-send-email-marc.zyngier@arm.com>
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

On Mon, Feb 08, 2016 at 11:40:15AM +0000, Marc Zyngier wrote:
> Our 64bit sys_reg table is about 90 entries long (so far, and the
> PMU support is likely to increase this). This means that on average,
> it takes 45 comparaisons to find the right entry (and actually the
> full 90 if we have to search the invariant table).
> 
> Not the most efficient thing. Specially when you think that this
> table is already sorted. Switching to a binary search effectively
> reduces the search to about 7 comparaisons. Slightly better!
> 
> As an added bonus, the comparaison is done by comparing all the

s/comparaison/comparison/

> fields at once, instead of one at a time.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
