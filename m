From: Graeme Gregory <graeme.gregory@linaro.org>
Subject: Re: [PATCH V2 0/5]  Enable ACPI support for KVM ARM
Date: Thu, 14 Jan 2016 00:27:13 +0000 (UTC)
Message-ID: <loom.20160114T012520-212@post.gmane.org>
References: <1433909767-12189-1-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A08E649AE9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2016 19:26:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dqF7WwOoPQsy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jan 2016 19:26:01 -0500 (EST)
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 91DCF497AC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2016 19:26:00 -0500 (EST)
Received: from list by plane.gmane.org with local (Exim 4.69)
 (envelope-from <gcekad-kvmarm@m.gmane.org>) id 1aJVni-0007Qp-Bv
 for kvmarm@lists.cs.columbia.edu; Thu, 14 Jan 2016 01:30:06 +0100
Received: from 79-66-3-221.dynamic.dsl.as9105.com ([79.66.3.221])
 by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
 id 1AlnuQ-0007hv-00
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2016 01:30:06 +0100
Received: from graeme.gregory by 79-66-3-221.dynamic.dsl.as9105.com with local
 (Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2016 01:30:06 +0100
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Wei Huang <wei <at> redhat.com> writes:

> 
> Initial ACPI support for ARM64 has been accepted into Linux kernel 
recently.
> Now it is a good time to re-visit ACPI support for KVM. This patchset
> enables ACPI for both arch_timer and vGIC by probing related ACPI 
tables
> and does necessary initialization.
> 
> Note that Alexander Spyridaki submitted similar patches before. Some 
of
> his ideas were borrowed in this patchset, but with substancial 
changes.
> In addition we extend support for both GICv2 and GICv3.
> 
> This patchset would work better on top of recent GIC/IRQCHIP patches 
by
> Hanjun Guo, who added support for gic_version in ACPI struct of GIC
> distributor (search "ACPICA: Introduce GIC version for arm based 
system").
> 
> This patchset can be applied cleanly on top of kvmarm.git queue 
branch.
> 

Is there a V3 of this patchset in the works? I think GIC stuff has 
calmed down a bit since you did this V2.

Thanks

Graeme
