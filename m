From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v5 1/9] clocksource: arm_arch_timer: Gather KVM specific
 information in a structure
Date: Wed, 6 Apr 2016 19:26:06 +0200
Message-ID: <20160406172606.GG8961@cbox>
References: <1459769860-6629-1-git-send-email-julien.grall@arm.com>
 <1459769860-6629-2-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3821640B58
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2016 13:24:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1MdvAzxOvF2V for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2016 13:24:35 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B6BB40B40
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2016 13:24:35 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id f198so83111241wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Apr 2016 10:25:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1459769860-6629-2-git-send-email-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 04, 2016 at 12:37:32PM +0100, Julien Grall wrote:
> Introduce a structure which are filled up by the arch timer driver and
> used by the virtual timer in KVM.
> 
> The first member of this structure will be the timecounter. More members
> will be added later.
> 
> A stub for the new helper isn't introduced because KVM requires the arch
> timer for both ARM64 and ARM32.
> 
> The function arch_timer_get_timecounter is kept for the time being and
> will be dropped in a subsequent patch.
> 
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> 
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
