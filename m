From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH RFC 0/6] target-arm: KVM64: Cross type vCPU support
Date: Tue, 7 Feb 2017 15:45:08 +0000
Message-ID: <CAFEAcA_Sn+MSVv8VcjL=o9VNR1+6VpTFFUhf6Mmr1-YGxt5gvg@mail.gmail.com>
References: <1484558821-15512-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63BE840A66
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Feb 2017 10:45:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CbyKOUpB5EnJ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Feb 2017 10:44:58 -0500 (EST)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4F5F40783
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Feb 2017 10:44:58 -0500 (EST)
Received: by mail-wm0-f51.google.com with SMTP id v77so160254630wmv.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Feb 2017 07:45:30 -0800 (PST)
In-Reply-To: <1484558821-15512-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: QEMU Developers <qemu-devel@nongnu.org>, qemu-arm <qemu-arm@nongnu.org>, wu.wubin@huawei.com, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 16 January 2017 at 09:26, Shannon Zhao <zhaoshenglong@huawei.com> wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
>
> This patch set support use cross type vCPU when using KVM on ARM and add
> two new CPU types: generic and cortex-a72.
>
> You can test this patch set with QEMU using
> -cpu cortex-a53/cortex-a57/generic/cortex-a72
>
> These patches can be fetched from:
> https://git.linaro.org/people/shannon.zhao/qemu.git cross_vcpu_rfc
>
> You corresponding KVM patches can be fetched from:
> https://git.linaro.org/people/shannon.zhao/linux-mainline.git cross_vcpu_rfc

We should really document the "generic" option for -cpu somewhere
and what it means. Unfortunately I'm not entirely sure where
that should be :-(  Suggestions welcomed but this isn't a blocker
for this series.

thanks
-- PMM
