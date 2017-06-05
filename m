From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 03/25] KVM: arm64: Make kvm_condition_valid32()
 accessible from EL2
Date: Mon, 5 Jun 2017 10:23:21 +0200
Message-ID: <20170605082321.GA8984@cbox>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-4-marc.zyngier@arm.com>
 <20170604121129.GB9464@cbox>
 <394ef6fd-1123-0a1f-f462-ed5cb52e24da@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69B6D40962
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jun 2017 04:19:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NVFqBsurlTSN for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Jun 2017 04:19:34 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 696C940296
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jun 2017 04:19:33 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id 7so66988434wmo.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 05 Jun 2017 01:23:37 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <394ef6fd-1123-0a1f-f462-ed5cb52e24da@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 05, 2017 at 09:13:53AM +0100, Marc Zyngier wrote:
> On 04/06/17 13:11, Christoffer Dall wrote:
> > On Thu, Jun 01, 2017 at 11:20:55AM +0100, Marc Zyngier wrote:
> >> As we're about to trap CP15 accesses and handle them at EL2, we
> >> need to evaluate whether or not the condition flags are valid,
> >> as an implementation is allowed to trap despite the condition
> >> not being met.
> >>
> >> Tagging the function as __hyp_text allows this.
> > 
> > is the cc_map also guaranteed to work (by simple reference) in EL2 then?
> 
> Yes. By virtue of being const, this ends up in the read-only part of the
> kernel, which we always map at EL2.
> 

And why don't we have to do any address-translation-to-hyp tricks on the
address?  Are we guaranteed that it's a relative address and everything
is relocated with the same offset, or how was that again?

Thanks,
-Christoffer
