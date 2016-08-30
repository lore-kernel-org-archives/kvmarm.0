From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 0/2] arm{,64}/kvm: excise redundant cache maintenance
Date: Tue, 30 Aug 2016 19:00:20 +0100
Message-ID: <20160830180020.GB19315@leverpostej>
References: <1472573156-30414-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDDDA410B5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 13:52:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ue1H4VKP+DFN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2016 13:52:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E724740FA6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 13:52:26 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1472573156-30414-1-git-send-email-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 30, 2016 at 05:05:54PM +0100, Mark Rutland wrote:
> As noted in a jailhouse thread a short while ago [1,2], the presence of the
> virtualization extensions implies that page table walks are coherent, and do
> not require that updates are cleaned to the PoU.
> 
> These patches remove the redundant maintenance and related infrastructure.
> 
> As I do not have a suitably configured ARMv7 board, I have not been able to
> test the patches myself, and any testing would be appreciated.

Having been lent a TC2 booting in Hyp mode, I've now given this a spin
with a few VMs, which I left running hackbench to fault in guest memory.

All of that ran happily.

Thanks,
Mark.
