Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD331C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 18 Mar 2022 05:27:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2125C49ECB;
	Fri, 18 Mar 2022 01:27:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aOeOIRjf1gQZ; Fri, 18 Mar 2022 01:27:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EBE849EC2;
	Fri, 18 Mar 2022 01:27:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3ADDD49EC2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 01:27:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B7CUN58eMza5 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Mar 2022 01:27:09 -0400 (EDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com
 [209.85.208.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 067E449E5F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 01:27:08 -0400 (EDT)
Received: by mail-ed1-f41.google.com with SMTP id g20so9006300edw.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 22:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:from:date:message-id:subject:to;
 bh=I2Klq0jUAW6SmsUfRBibu2q3PVe4spyAFc4g3m9nGbc=;
 b=dUIqTvQoAnVHEdYAl8NZGuoa571ubQxC+AIW2DaJWDqg9dQZDzbJCXqJYgxkV1dk/w
 wQJfzIDvi5CaRDVvzpfgliCxmQ2DlbqxgAffTnakG5oh9lWdjeBbapNELXXEL7TxsNNC
 J/UNpLWCC+CYb/5Ob+0nL6j00wrtvq3tQdgwlsBYlSKCrEx77rbGlt4o541Jm/Z4NzSe
 lxxCVX1QJrwHtjvhKOFUhkDPCEKxXkFR0ZEtkxH2ZoLqRHlhNMp+Dwi0TMxjuTMP4S00
 MMdkLWysifgpsDRFesDVxZQecXssKDrxsIao/0ZzDBRveyPkYY4ekYd8SnsOXGvpsQoI
 7CGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
 bh=I2Klq0jUAW6SmsUfRBibu2q3PVe4spyAFc4g3m9nGbc=;
 b=6O5R9SnZOmqhuJnV+jZY/vvyFMg+fUH731l6H29el1jR/mFvsPZShUdzZxP8L4Fij1
 SmUmodnsmoqqv9MPZN1WX2Ndc212h9LpTmlkgPMbWK3yYcRpFey5ikhJ3SdFuIBQmyDi
 P6q6l8zfjF5x1cAGZ4PyR1U8ZSGg8krXjIl0LGyQfGnUyS1QJ5vCEq55cT8sGI0okJkr
 6N30TyVi28HsiyQDbJUj9vGNPmDrWWudqPT+NZoC9DfK9mPCVt4PiohBatyG8yVpuTkB
 aW2TWuYCUXX1LK/YaITA3ztppX8+T9eNhkQr4Bn2avYr4dJUQ2ZzJOeJXSA8VkKIj3L8
 1MWQ==
X-Gm-Message-State: AOAM533MhopStQfbs/69515pxYICe6qKIsC3XPY2hYA7X8tOpJSlmIU4
 ScVeDxJs7Qy3jD9SkVmuDBfoVCiAlKGLFDc/9AYlBlcnBTPolg==
X-Google-Smtp-Source: ABdhPJzt+1k4Z9zdLYjtRihnw8aFIn+9bARMvO3NrpvEMJNKCbOrCXod5W+WgfL0dbFSPruuEn4qpbql+o2N9mqjJqA=
X-Received: by 2002:aa7:cac8:0:b0:410:cc6c:6512 with SMTP id
 l8-20020aa7cac8000000b00410cc6c6512mr7774931edt.408.1647581227535; Thu, 17
 Mar 2022 22:27:07 -0700 (PDT)
MIME-Version: 1.0
From: Ricardo Koller <ricarkol@google.com>
Date: Thu, 17 Mar 2022 22:26:56 -0700
Message-ID: <CAOHnOryT4A2QjX9Mg57vczoakyTT+7Dq1os_DUXHAQ+McDFpSA@mail.gmail.com>
Subject: Spectre - BHB
To: KVMARM <kvmarm@lists.cs.columbia.edu>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hello,

We've been talking internally about Spectre-BHB (disclosed a couple of
weeks ago [0])
and thought it could be interesting to start some discussion on the mailing
list, especially around the software mitigation.

As a start, here is the overhead of the mitigation [1] for some guest operations
on a Neoverse N1 core [0]. The table shows the avg. latency of each operation,
measured using kvm-unit-tests/arm/micro-bench.

Micro-bench          not-mitigated   mitigated
                     nsecs           nsecs           overhead
=============================================================
hvc                  292             317             8.56%
mmio_read_user       1609            1704            5.90%
mmio_read_vgic       419             444             5.97%
eoi                  29              29              0.00%
ipi                  1509            1548            2.58%
lpi                  1643            1758            7.00%
timer_10ms           798             844             5.76%

Some details:
- Using 56e337f2cf13 with and without MITIGATE_SPECTRE_BRANCH_HISTORY.
- Each test (row) runs for 1 minute in a tight loop.

We are still evaluating the effect of this on real workloads.

Thanks!
Ricardo

[0] Spectre-BHB white paper:
https://developer.arm.com/support/arm-security-updates/speculative-processor-vulnerability/spectre-bhb
[1] 558c303c9734af5a813739cd284879227f7297d2 arm64: Mitigate spectre
style branch history side channels
[2] the specific vector is spectre_bhb_k24 (Arm Neoverse-N1), from the
Spectre-BHB white paper in [0].
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
