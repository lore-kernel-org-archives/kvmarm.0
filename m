From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: A KVM kernel for FVP for ARM7
Date: Thu, 7 Jun 2018 09:34:26 +0200
Message-ID: <20180607073426.GA20446@C02W217FHV2R.local>
References: <CAPB=Z-qULLZUVOabsNDPRYxybC3M=O8ZrYpRo8Dfc0oT4nKcGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0C604048A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jun 2018 03:23:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kAOVMJWSPZ1i for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jun 2018 03:23:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2AFC40196
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jun 2018 03:23:12 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <CAPB=Z-qULLZUVOabsNDPRYxybC3M=O8ZrYpRo8Dfc0oT4nKcGQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Raz <raziebe@gmail.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jun 06, 2018 at 09:22:52AM +0300, Raz wrote:
> Hello
> KVM arm was introduced in 3.9. I wish to debug it through fast models.
> My problem is that FVP uses 3.4 kernel, and 3.9  from "git://
> git.kernel.org/pub/scm/virt/kvm/kvm.git " does not boot it.
> 
> Do you have a ready kernel for FVP ?

Mainline kernels should boot just fine on Arm fast models.  I strongly
recommend you use a much newer kernel version for anything KVM-related.

-Christoffer
