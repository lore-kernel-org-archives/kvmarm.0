From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Mon, 2 Mar 2015 18:05:19 +0100
Message-ID: <20150302170519.GB14186@hawk.usersys.redhat.com>
References: <20150219175518.GB26965@hawk.usersys.redhat.com>
 <54E62404.9040702@redhat.com>
 <20150220142905.GA10942@hawk.usersys.redhat.com>
 <CAKv+Gu-YUzmnACZQi98OPRgKKL+gAGqwWYq2-_dwCdNqcktNUg@mail.gmail.com>
 <20150220153626.GB10942@hawk.usersys.redhat.com>
 <20150224145529.GA5498@hawk.usersys.redhat.com>
 <CAKv+Gu-Uk2wg1OkoWgQe4da_EiFoEz_u8VuD8Ees6qU1UYMDvQ@mail.gmail.com>
 <20150302163146.GB9686@lvm> <54F49418.5070108@redhat.com>
 <54F49610.6090000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 846434760B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:59:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P23u6aejD05f for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Mar 2015 11:59:32 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AFDBF475D8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:59:32 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <54F49610.6090000@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Laszlo Ersek <lersek@redhat.com>
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 02, 2015 at 05:55:44PM +0100, Laszlo Ersek wrote:
> On 03/02/15 17:47, Paolo Bonzini wrote:
> > 
> > Also, we may want to invalidate the cache for dirty pages before
> > returning the dirty bitmap, and probably should do that directly in
> > KVM_GET_DIRTY_LOG.
> 
> "I agree."
> 
> If KVM_GET_DIRTY_LOG is supposed to be atomic fetch and clear (from
> userspace's aspect), then the cache invalidation should be an atomic
> part of it too (from the same aspect).
> 
> (Sorry if I just said something incredibly stupid.)
>

With the path I'm headed down, all cache maintenance operations will
be done before exiting to userspace (and after returning). I was
actually already letting a feature creep into this PoC by setting
KVM_MEM_LOG_DIRTY_PAGES when we see KVM_MEM_INCOHERENT has been set,
and the region isn't readonly. The dirty log would then be used by
KVM internally to know exactly which pages need to be invalidated
before the exit.

drew
