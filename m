From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC/RFT PATCH v2 1/3] arm/arm64: pageattr: add set_memory_nc
Date: Fri, 15 May 2015 07:51:01 -0700
Message-ID: <20150515145101.GA14144@lvm>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
 <1431516714-25816-2-git-send-email-drjones@redhat.com>
 <20150514110509.GP32765@cbox>
 <20150514134644.GF12812@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 700E251708
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 10:42:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b0XPY0CjUisE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 May 2015 10:42:01 -0400 (EDT)
Received: from mail-la0-f41.google.com (mail-la0-f41.google.com
 [209.85.215.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F17C151705
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 10:42:00 -0400 (EDT)
Received: by lagv1 with SMTP id v1so123138671lag.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 07:51:10 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150514134644.GF12812@localhost.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: ard.biesheuvel@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, qemu-devel@nongnu.org, pbonzini@redhat.com, lersek@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 14, 2015 at 03:46:44PM +0200, Andrew Jones wrote:
> On Thu, May 14, 2015 at 01:05:09PM +0200, Christoffer Dall wrote:
> > On Wed, May 13, 2015 at 01:31:52PM +0200, Andrew Jones wrote:
> > > Provide a method to change normal, cacheable memory to non-cacheable.
> > > KVM will make use of this to keep emulated device memory regions
> > > coherent with the guest.
> > > 
> > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > 
> > Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> > 
> > But you obviously need Russell and Will/Catalin to ack/merge this.
> 
> I guess this patch is going to go away in the next round. You've
> pointed out that I screwed stuff up royally with my over eagerness
> to reuse code. I need to reimplement change_memory_common, but a
> version that takes an mm, which is more or less what I did in the
> last version of this series, back when I was pinning pages.
> 
Yeah, I just read this one before looking at the others because it was a
simple one...

-Christoffer
