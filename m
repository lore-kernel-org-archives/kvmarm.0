From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH V2 2/2] KVM: arm64: Increase number of user memslots to 508
Date: Thu, 2 Mar 2017 13:29:06 +0100
Message-ID: <20170302122906.GJ1409@cbox>
References: <1486538141-30627-1-git-send-email-linucherian@gmail.com>
 <1486538141-30627-3-git-send-email-linucherian@gmail.com>
 <20170223101407.GB1409@cbox>
 <CAGOz-0bKYbVB_Zu1J+fCnQ=icK9yNHjXjh_hBxj4AjATw7cEXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7A5B40A80
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Mar 2017 07:28:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x7k9wgUrJ33J for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Mar 2017 07:28:12 -0500 (EST)
Received: from mail-wr0-f179.google.com (mail-wr0-f179.google.com
 [209.85.128.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A24EA40966
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Mar 2017 07:28:12 -0500 (EST)
Received: by mail-wr0-f179.google.com with SMTP id u48so50945229wrc.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Mar 2017 04:29:25 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAGOz-0bKYbVB_Zu1J+fCnQ=icK9yNHjXjh_hBxj4AjATw7cEXg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Linu Cherian <linucherian@gmail.com>
Cc: sunil.goutham@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Linu Cherian <linu.cherian@cavium.com>, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Feb 26, 2017 at 12:36:58PM +0530, Linu Cherian wrote:
> On Thu, Feb 23, 2017 at 3:44 PM, Christoffer Dall <cdall@linaro.org> wrote:
> > On Wed, Feb 08, 2017 at 12:45:41PM +0530, linucherian@gmail.com wrote:
> >> From: Linu Cherian <linu.cherian@cavium.com>
> >>
> >> Having only 32 memslots is a real constraint for the maximum
> >> number of PCI devices that can be assigned to a single guest.
> >> Assuming each PCI device/virtual function having two memory BAR
> >> regions, we could assign only 15 devices/virtual functions to a
> >> guest.
> >>
> >> Hence increase KVM_USER_MEM_SLOTS to 508, so that KVM_MEM_SLOTS_NUM is
> >> 512 as done in other archs like x86 and powerpc.
> >
> > Actually on powerpc they just define KVM_USER_MEM_SLOTS as 512 directly.
> >
> > On x86 they define them as 509 and have 3 private mem slots.
> >
> > I don't understand the difference and as far as I can tell we don't have
> > any private memslots on arm/arm64, so this is just weird to me.
> >
> 
> Since the KVM_PRIVATE_MEM_SLOTS was already defined as 4, just kept
> it untouched. Should we remove this and keep KVM_USER_MEM_SLOTS as 512 ?

Do we have any use for KVM_PRIVATE_MEM_SLOTSA being 4?  I can't seem to
see this.

I think we should either get rid of the definition or at least make sure
we understand why we're doing things this way.

Thanks,
-Christoffer
