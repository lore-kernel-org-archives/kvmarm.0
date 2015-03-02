From: Laszlo Ersek <lersek@redhat.com>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Mon, 02 Mar 2015 17:55:44 +0100
Message-ID: <54F49610.6090000@redhat.com>
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
 <20150302163146.GB9686@lvm> <54F49418.5070108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05000475A5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:49:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QXWydit4VWPp for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Mar 2015 11:49:57 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78331475A0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:49:57 -0500 (EST)
In-Reply-To: <54F49418.5070108@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 03/02/15 17:47, Paolo Bonzini wrote:
> 
> Also, we may want to invalidate the cache for dirty pages before
> returning the dirty bitmap, and probably should do that directly in
> KVM_GET_DIRTY_LOG.

"I agree."

If KVM_GET_DIRTY_LOG is supposed to be atomic fetch and clear (from
userspace's aspect), then the cache invalidation should be an atomic
part of it too (from the same aspect).

(Sorry if I just said something incredibly stupid.)

Laszlo
