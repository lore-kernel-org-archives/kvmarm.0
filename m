From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v6 10/10] clocksource: arm_arch_timer: Remove
 arch_timer_get_timecounter
Date: Tue, 12 Apr 2016 14:15:11 +0200
Message-ID: <20160412121511.GB3039@cbox>
References: <1460388780-914-1-git-send-email-julien.grall@arm.com>
 <1460388780-914-11-git-send-email-julien.grall@arm.com>
 <20160412054447.GC16636@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD52740402
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 08:13:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bmYB3VUXeOwO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2016 08:13:16 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F1CFE400E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 08:13:15 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id f198so184941692wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 05:14:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160412054447.GC16636@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: al.stone@linaro.org, kvm@vger.kernel.org, hanjun.guo@linaro.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

Hi Daniel,

On Tue, Apr 12, 2016 at 07:44:47AM +0200, Daniel Lezcano wrote:
> On Mon, Apr 11, 2016 at 04:33:00PM +0100, Julien Grall wrote:
> > The only call of arch_timer_get_timecounter (in KVM) has been removed.
> > 
> > Signed-off-by: Julien Grall <julien.grall@arm.com>
> > Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> > 
> > ---
> > Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > 
> >     Changes in v4:
> >         - Add Christoffer's acked-by
> > 
> >     Changes in v3:
> >         - Patch added
> > ---
> 
> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

having acked these, do you want us to just take this a complete series
via the kvmarm tree or do you plan on merging the patches individually?

Thanks,
-Christoffer
