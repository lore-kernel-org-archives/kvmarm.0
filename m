From: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v6 01/10] clocksource: arm_arch_timer: Gather KVM
 specific information in a structure
Date: Tue, 12 Apr 2016 07:43:13 +0200
Message-ID: <20160412054313.GA16636@linaro.org>
References: <1460388780-914-1-git-send-email-julien.grall@arm.com>
 <1460388780-914-2-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DC98407A5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 01:41:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cPWNV9lYWNKH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2016 01:41:42 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE5A1400E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 01:41:41 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id u206so12565222wme.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 22:43:18 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1460388780-914-2-git-send-email-julien.grall@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, al.stone@linaro.org, kvm@vger.kernel.org, hanjun.guo@linaro.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 11, 2016 at 04:32:51PM +0100, Julien Grall wrote:
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
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> 

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
