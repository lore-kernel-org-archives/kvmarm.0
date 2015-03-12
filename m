From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v5] hw/intc/arm_gic: Initialize the vgic in the realize
 function
Date: Thu, 12 Mar 2015 14:04:12 +0000
Message-ID: <CAFEAcA8WHzckjryeOBg6TjsrnSp0GTPK7QCzMAm6J9c_X8dhZg@mail.gmail.com>
References: <1426094226-8515-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7C6B48A58
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2015 09:58:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QqTWb7gF9orw for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Mar 2015 09:58:10 -0400 (EDT)
Received: from mail-lb0-f172.google.com (mail-lb0-f172.google.com
 [209.85.217.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9DF7748A57
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2015 09:58:10 -0400 (EDT)
Received: by lbiz11 with SMTP id z11so16188303lbi.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2015 07:04:32 -0700 (PDT)
In-Reply-To: <1426094226-8515-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: Patch Tracking <patches@linaro.org>, eric.auger@st.com, QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 11 March 2015 at 17:17, Eric Auger <eric.auger@linaro.org> wrote:
> This patch forces vgic initialization in the vgic realize function.
> It uses a new group/attribute that allows such operation:
> KVM_DEV_ARM_VGIC_GRP_CTRL/KVM_DEV_ARM_VGIC_CTRL_INIT
>
> This earlier initialization allows, for example, to setup VFIO
> signaling and irqfd after vgic initialization, on a reset notifier.
>
> Signed-off-by: Eric Auger <eric.auger@linaro.org>



Applied to target-arm.next, thanks.

-- PMM
