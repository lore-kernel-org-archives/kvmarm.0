From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] updated: arm64: KVM: vgic: deal with GIC sub-page
 alignment
Date: Sat, 9 Jul 2016 21:09:01 +0100
Message-ID: <20160709210901.6fea00e8@arm.com>
References: <5775F854.3060306@riken.jp> <57762C8A.8060105@arm.com>
 <f2630ba4-1e97-ccfc-cfe2-525a21c215e6@riken.jp>
 <577635EE.1010002@arm.com>
 <d91a1d8b-8a83-e676-0d5c-decad046662f@riken.jp>
 <20160709110849.4d398647@arm.com>
 <543776d0-fa4b-3105-a6f4-de3df847b9a7@riken.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D7DB41267
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jul 2016 16:03:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LqD0rQwIfrm7 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 Jul 2016 16:03:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70B9F412A2
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jul 2016 16:03:25 -0400 (EDT)
In-Reply-To: <543776d0-fa4b-3105-a6f4-de3df847b9a7@riken.jp>
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

On Sat, 9 Jul 2016 19:32:35 +0900
Itaru Kitayama <itaru.kitayama@riken.jp> wrote:

> On 7/9/16 7:08 PM, Marc Zyngier wrote:
> > Please realize that this is a work in progress, and that I'm not even
> > sure I want to upstream this.  
> 
> OK.
> 
> >> (I wanted to get some performance statistics of the new feature with
> >> perf, but on arm64 most of them are unsupported)  
> >
> > Care to mention which ones are missing?  
> 
> $ perf stat sleep 5
> 
>   Performance counter stats for 'sleep 5':
> 
>            0.589480      task-clock:u (msec)       #    0.000 CPUs 
> utilized
>                   0      context-switches:u        #    0.000 K/sec 
> 
>                   0      cpu-migrations:u          #    0.000 K/sec 
> 
>                  35      page-faults:u             #    0.059 M/sec 
> 
>     <not supported>      cycles:u 
> 
>     <not supported>      instructions:u 
> 
>     <not supported>      branches:u 
> 
>     <not supported>      branch-misses:u 
> 
> 
>         5.024683421 seconds time elapsed
> 
> Userland is Fedora 24.

I'm pretty sure your QEMU doesn't have PMU support. Can you show the
PMU probe messages in the guest? And/or dump the guest DTB?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
