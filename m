From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC/RFT PATCH v2 2/3] KVM: promote KVM_MEMSLOT_INCOHERENT to uapi
Date: Thu, 14 May 2015 12:34:33 +0200
Message-ID: <20150514103433.GN32765@cbox>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
 <1431516714-25816-3-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C757651437
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 06:25:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LK-i9kJtsB2p for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2015 06:25:15 -0400 (EDT)
Received: from mail-la0-f53.google.com (mail-la0-f53.google.com
 [209.85.215.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F0D15142E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 06:25:15 -0400 (EDT)
Received: by layy10 with SMTP id y10so61192055lay.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 03:34:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1431516714-25816-3-git-send-email-drjones@redhat.com>
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

On Wed, May 13, 2015 at 01:31:53PM +0200, Andrew Jones wrote:
> Commit 1050dcda30529 introduced KVM_MEMSLOT_INCOHERENT to flag memory
> regions that may have coherency issues due to mapping host system RAM
> as non-cacheable. This was introduced as a KVM internal flag, but now
> give KVM userspace access to it so that it may use it for hinting
> likely problematic regions. Also rename to KVM_MEM_UNCACHED.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
