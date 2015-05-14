From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC/RFT PATCH v2 1/3] arm/arm64: pageattr: add set_memory_nc
Date: Thu, 14 May 2015 13:05:09 +0200
Message-ID: <20150514110509.GP32765@cbox>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
 <1431516714-25816-2-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B278151451
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 06:55:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AbgVhWoSamlz for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2015 06:55:51 -0400 (EDT)
Received: from mail-la0-f43.google.com (mail-la0-f43.google.com
 [209.85.215.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73AEC51450
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 06:55:51 -0400 (EDT)
Received: by labbd9 with SMTP id bd9so62166496lab.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 04:04:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1431516714-25816-2-git-send-email-drjones@redhat.com>
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

On Wed, May 13, 2015 at 01:31:52PM +0200, Andrew Jones wrote:
> Provide a method to change normal, cacheable memory to non-cacheable.
> KVM will make use of this to keep emulated device memory regions
> coherent with the guest.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

But you obviously need Russell and Will/Catalin to ack/merge this.

-Christoffer
