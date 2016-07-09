From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] updated: arm64: KVM: vgic: deal with GIC sub-page
 alignment
Date: Sat, 9 Jul 2016 11:08:49 +0100
Message-ID: <20160709110849.4d398647@arm.com>
References: <5775F854.3060306@riken.jp> <57762C8A.8060105@arm.com>
 <f2630ba4-1e97-ccfc-cfe2-525a21c215e6@riken.jp>
 <577635EE.1010002@arm.com>
 <d91a1d8b-8a83-e676-0d5c-decad046662f@riken.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF34749B37
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jul 2016 06:03:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X39mi7cR5Z4x for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 Jul 2016 06:03:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 546A949B35
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jul 2016 06:03:27 -0400 (EDT)
In-Reply-To: <d91a1d8b-8a83-e676-0d5c-decad046662f@riken.jp>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Itaru Kitayama <itaru.kitayama@riken.jp>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, 9 Jul 2016 09:27:21 +0900
Itaru Kitayama <itaru.kitayama@riken.jp> wrote:

Itaru,

> I'm at the latest commit, fa9301d in the gicv-align branch at the 
> moment, with that an unmodified QEMU guest boots fine on a 64Kb page 
> granular host, thanks to the trapping you introduced.

Please realize that this is a work in progress, and that I'm not even
sure I want to upstream this.

> (I wanted to get some performance statistics of the new feature with 
> perf, but on arm64 most of them are unsupported)

Care to mention which ones are missing?

> However, if I rebuild the kernel using defconfig with only the kernel 
> page size changed to 16Kb it does not boot at least on Overdrive 3000.

Only a few CPUs support 16kB pages, and Cortex-A57 is definitely not
one of them.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
