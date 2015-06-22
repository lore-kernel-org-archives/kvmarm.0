From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH] arm64/kvm: Add generic v8 KVM target
Date: Mon, 22 Jun 2015 09:44:48 +0100
Message-ID: <CAFEAcA92uymQ3LjPQnuFiwvjSgc+jY54VrfK_Sh4v1DJ+=OPpw@mail.gmail.com>
References: <1434531646-4873-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 859D65613F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2015 04:34:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vRggr1wLzfcv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2015 04:34:21 -0400 (EDT)
Received: from mail-vn0-f50.google.com (mail-vn0-f50.google.com
 [209.85.216.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50239560FA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2015 04:34:20 -0400 (EDT)
Received: by vnbf129 with SMTP id f129so1356315vnb.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2015 01:45:11 -0700 (PDT)
In-Reply-To: <1434531646-4873-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, timur@codeaurora.org, vgandhi@codeaurora.org, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 17 June 2015 at 10:00, Suzuki K. Poulose <suzuki.poulose@arm.com> wrote:
> From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
>
> This patch adds a generic ARM v8 KVM target cpu type for use
> by the new CPUs which eventualy ends up using the common sys_reg
> table. For backward compatibility the existing targets have been
> preserved. Any new target CPU that can be covered by generic v8
> sys_reg tables should make use of the new generic target.

How do you intend this to work for cross-host migration?
Is the idea that the kernel guarantees that "generic" looks
100% the same to the guest regardless of host hardware? I'm
not sure that can be made to work, given impdef differences
in ID register values, bp/wp registers, and so on.

Given that, it seems to me that we still need to provide
KVM_ARM_TARGET_$THISCPU defines so userspace can request
a specific guest CPU flavour; so what does this patch
provide that isn't already provided by just having userspace
query for the "preferred" CPU type as it does already?

thanks
-- PMM
