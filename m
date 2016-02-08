From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] KVM/ARM updates for 4.5-rc2
Date: Mon, 8 Feb 2016 16:23:07 +0100
Message-ID: <56B8B2DB.9020407@redhat.com>
References: <1453977038-13516-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8240498AB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2016 10:17:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AXnZUnLWWM6N for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Feb 2016 10:17:31 -0500 (EST)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BCA1F49899
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2016 10:17:31 -0500 (EST)
Received: by mail-wm0-f43.google.com with SMTP id c200so20648389wme.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Feb 2016 07:23:15 -0800 (PST)
In-Reply-To: <1453977038-13516-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Dave Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Shannon Zhao <shannon.zhao@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 28/01/2016 11:30, Marc Zyngier wrote:
> Hi Paolo,
> 
> Please find below the KVM/ARM updates for 4.5-rc2. Mostly fixes as a
> result of Shannon's work on PMU emulation, which has outlined a few
> nits here and there, plus a correctness fix from Dave.
> 
> Please pull!
> 
> Thanks,
> 
> 	M.
> 
> The following changes since commit 92e963f50fc74041b5e9e744c330dca48e04f08d:
> 
>   Linux 4.5-rc1 (2016-01-24 13:06:47 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4.5-rc2
> 
> for you to fetch changes up to 6327f35a2010c06a3bc2bfb14202a38764fb9920:
> 
>   arm64: KVM: Fix guest dead loop when register accessor returns false (2016-01-24 21:56:01 +0000)
> 
> ----------------------------------------------------------------
> KVM/ARM fixes for v4.5-rc2
> 
> A few random fixes, mostly coming from the PMU work by Shannon:
> 
> - fix for injecting faults coming from the guest's userspace
> - cleanup for our CPTR_EL2 accessors (reserved bits)
> - fix for a bug impacting perf (user/kernel discrimination)
> - fix for a 32bit sysreg handling bug
> 
> ----------------------------------------------------------------

Finally pulled, thanks.

Paolo
