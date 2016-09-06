From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 4/7] arm64: KVM: Make kvm_skip_instr32 available to HYP
Date: Tue, 6 Sep 2016 12:53:45 +0200
Message-ID: <20160906105345.GL30513@cbox>
References: <1473150527-4729-1-git-send-email-marc.zyngier@arm.com>
 <1473150527-4729-5-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2D0C49B59
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 06:42:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S28qChSKyhfX for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 06:42:52 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C937049B49
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 06:42:52 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id i204so27478911wma.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Sep 2016 03:51:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1473150527-4729-5-git-send-email-marc.zyngier@arm.com>
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

On Tue, Sep 06, 2016 at 09:28:44AM +0100, Marc Zyngier wrote:
> As we plan to do some emulation at HYP, let's make kvm_skip_instr32
> as part of the hyp_text section. This doesn't preclude the kernel
> from using it.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
