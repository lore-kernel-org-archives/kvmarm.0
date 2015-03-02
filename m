From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Mon, 02 Mar 2015 17:47:20 +0100
Message-ID: <54F49418.5070108@redhat.com>
References: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
 <20150219165731.GA26965@hawk.usersys.redhat.com>
 <CAKv+Gu8Je3RRrgEFCZ7JUWtOgk3WqA_qdBEOPAMc3OqnKr1bwg@mail.gmail.com>
 <20150219175518.GB26965@hawk.usersys.redhat.com>
 <54E62404.9040702@redhat.com>
 <20150220142905.GA10942@hawk.usersys.redhat.com>
 <CAKv+Gu-YUzmnACZQi98OPRgKKL+gAGqwWYq2-_dwCdNqcktNUg@mail.gmail.com>
 <20150220153626.GB10942@hawk.usersys.redhat.com>
 <20150224145529.GA5498@hawk.usersys.redhat.com>
 <CAKv+Gu-Uk2wg1OkoWgQe4da_EiFoEz_u8VuD8Ees6qU1UYMDvQ@mail.gmail.com>
 <20150302163146.GB9686@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E394C47584
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:41:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9-FJIdeF+QgH for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Mar 2015 11:41:36 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 37C5947575
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:41:35 -0500 (EST)
In-Reply-To: <20150302163146.GB9686@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 02/03/2015 17:31, Christoffer Dall wrote:
> 2. While the code is probably as nice as this kind of stuff gets, it
> is non-trivial and extremely difficult to debug.  The counter-point here
> is that we may end up handling other stuff at EL2 for performanc reasons
> in the future.
> 
> Mainly because of point 1 above, I am leaning to thinking userspace
> should do the invalidation when it knows it needs to, either through KVM
> via a memslot flag or through some other syscall mechanism.

I'm okay with adding a KVM capability and ioctl that flushes the dcache
for a given gpa range.  However:

1) I'd like to have an implementation for QEMU and/or kvmtool before
accepting that ioctl.

2) I think the ioctl should work whatever the stage1 mapping is (e.g.
with and without Ard's patches, with and without Laszlo's OVMF patch, etc.).

Also, we may want to invalidate the cache for dirty pages before
returning the dirty bitmap, and probably should do that directly in
KVM_GET_DIRTY_LOG.

Paolo
