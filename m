From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 5/5] KVM: arm/arm64: allow userspace to set MPIDR
Date: Wed, 8 Mar 2017 15:27:28 +0100
Message-ID: <CAFEAcA_2BtKUnFFciN1v2F3etkDVNvd4+wNOk-DX=hcWDwsCiA@mail.gmail.com>
References: <20170227175504.15751-1-drjones@redhat.com>
 <20170227175504.15751-6-drjones@redhat.com>
 <20170308131907.GA109908@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E70C140BBB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Mar 2017 09:26:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sItA9ZOZUrij for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Mar 2017 09:26:26 -0500 (EST)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9818240296
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Mar 2017 09:26:26 -0500 (EST)
Received: by mail-wm0-f47.google.com with SMTP id 196so30450577wmm.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Mar 2017 06:27:49 -0800 (PST)
In-Reply-To: <20170308131907.GA109908@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Ashok Kumar <ashoks@broadcom.com>, Igor Mammedov <imammedo@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 8 March 2017 at 14:19, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> Isn't this all super racy?  What prevents two VCPUs from getting the
> same MPIDR at the same time?

>From a userspace API point of view, I was expecting this to be
"just don't do that then" territory, ie it's userspace's job
to set the MPIDRs to something that makes sense. Does KVM
actually care internally what the MPIDR presented to the guest is?
(In theory I don't see why you shouldn't be able to present
the guest with a bit of bogus hardware that claims the same
MPIDR for all cores.)

thanks
-- PMM
