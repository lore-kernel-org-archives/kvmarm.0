From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL 00/26] KVM/arm updates for 4.20
Date: Fri, 19 Oct 2018 15:23:31 +0200
Message-ID: <9af51d24-fe4a-32d9-3637-004ce9ed0e7d@redhat.com>
References: <20181019125901.185478-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 392C64A2BD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 09:23:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kSTwd+hEy9pP for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Oct 2018 09:23:43 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 33ADF4A2AC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 09:23:43 -0400 (EDT)
In-Reply-To: <20181019125901.185478-1-marc.zyngier@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: zhong jiang <zhongjiang@huawei.com>, kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 19/10/2018 14:58, Marc Zyngier wrote:
> Paolo, Radim,
> 
> This is the bulk of the KVM/arm changes for 4.20. This time, the
> biggest change by far is the support for variable addressing range in
> guests, allowing userspace to size arm64 VMs from 32 to 52bits instead
> of the hard-coded 40bits we've enjoyed so far. Other than that, we
> have a random selection of small fixes and cleanups.
> 
> Note that this will generate a few minor conflicts with the arm64 tree,
> which should be resolved as per this branch[1].

That's a bit annoying.  KVM parts of "Support Common Not Private
translations" should not have gone through the arm64 tree.  Instead,
Catalin should have placed the first patches in a topic branch for you
to pull.

This minimizes the effort for everyone else, basically.  Conflicts need
to be sorted out by Stephen Rothwell, myself and Linus/Greg, while topic
branches just work.

If it weren't for the include/uapi/linux/kvm.h change, where I have to
sort the capability numbers as they are assigned by the various
architecture maintainers(*), I would have told you to just send the pull
request to Catalin this time through (but that would just be a band-aid,
it should not be the norm).  Anyway, just remember this next time.

Thanks,

Paolo

	(*) That's also a bit suboptimal, because it complicates
	    debugging of new features after they're merged, but I have
	    no better idea.
