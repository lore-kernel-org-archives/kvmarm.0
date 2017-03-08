From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 5/5] KVM: arm/arm64: allow userspace to set MPIDR
Date: Wed, 8 Mar 2017 09:21:59 -0800
Message-ID: <20170308172159.GD109908@lvm>
References: <20170227175504.15751-1-drjones@redhat.com>
 <20170227175504.15751-6-drjones@redhat.com>
 <20170308131907.GA109908@lvm>
 <CAFEAcA_2BtKUnFFciN1v2F3etkDVNvd4+wNOk-DX=hcWDwsCiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 668EF408EB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Mar 2017 12:20:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pI2JW1Yw3w0U for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Mar 2017 12:20:40 -0500 (EST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E7A2405DA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Mar 2017 12:20:39 -0500 (EST)
Received: by mail-wm0-f41.google.com with SMTP id t189so36567735wmt.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Mar 2017 09:22:03 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAFEAcA_2BtKUnFFciN1v2F3etkDVNvd4+wNOk-DX=hcWDwsCiA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Ashok Kumar <ashoks@broadcom.com>, Igor Mammedov <imammedo@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 08, 2017 at 03:27:28PM +0100, Peter Maydell wrote:
> On 8 March 2017 at 14:19, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> > Isn't this all super racy?  What prevents two VCPUs from getting the
> > same MPIDR at the same time?
> 
> From a userspace API point of view, I was expecting this to be
> "just don't do that then" territory, ie it's userspace's job
> to set the MPIDRs to something that makes sense. Does KVM
> actually care internally what the MPIDR presented to the guest is?
> (In theory I don't see why you shouldn't be able to present
> the guest with a bit of bogus hardware that claims the same
> MPIDR for all cores.)
> 

I think it's important that we maintain a strict mapping between an
MPIDR and a VCPU at any given time, because otherwise, we'll have
problems knowing which redestributor belongs to which VCPU and making
other qualified decisions in the KVM/ARM implementation.

Thanks,
-Christoffer
