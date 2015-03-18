From: Andrew Jones <drjones@redhat.com>
Subject: Re: the arm cache coherency cluster "v2"
Date: Wed, 18 Mar 2015 20:18:20 +0100
Message-ID: <20150318191819.GB7077@hawk.usersys.redhat.com>
References: <1426705700-2564-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34D2C491D0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 15:11:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZmILWfLZE8Rd for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Mar 2015 15:11:53 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 11316491C7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 15:11:52 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1426705700-2564-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com
Cc: catalin.marinas@arm.com, lersek@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 18, 2015 at 03:08:20PM -0400, Andrew Jones wrote:
> In reply to this message I'll send two series' one for KVM and
> one for QEMU. The two series' are their respective component
> complements, and attempt to implement cache coherency for arm
> guests using emulated devices, where the emulator (qemu) uses
> cached memory for the device memory, but the guest uses
> uncached - as device memory is generally used. Right now I've
> just focused on VGA vram.
> 
> This approach is the "MADV_UNCACHED" type that Paolo suggested.
> This type of approach could also be described as "make userspace's
> memory access type match the expected access type of the guest",
> and Mario has suggested using a memory driver, which could have
> the same result.
> 
> The coming series' is inspired by both Paolo's and Mario's
> suggestions, but it uses a kvm memslot flag, rather than an
> madvise flag, and thus for the memory driver, it's just KVM.
> 
> See the thread
> 
> https://lists.gnu.org/archive/html/qemu-devel/2015-03/msg01254.html
> 
> for some more background.
> 
> Thanks in advance for comments.
> 
> drew

I forgot to mention that I've done some light testing with this.
It seems to work, and without (to eye) noticeable performance
degradation.

Thanks,
drew
