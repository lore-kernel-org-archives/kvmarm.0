From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 03/40] KVM: arm64: Avoid storing the vcpu pointer on
 the stack
Date: Thu, 22 Feb 2018 11:24:18 +0100
Message-ID: <20180222102418.GK29376@cbox>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-4-christoffer.dall@linaro.org>
 <20180221173200.6vfv6a4hytibos3p@kamzik.brq.redhat.com>
 <20180222091034.GD29376@cbox>
 <20180222095641.w5isy5jt5a67jocp@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CC8E49E13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Feb 2018 05:18:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2K2oBIFDaSG6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Feb 2018 05:17:42 -0500 (EST)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6156D49E07
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Feb 2018 05:17:42 -0500 (EST)
Received: by mail-wm0-f43.google.com with SMTP id x21so2699457wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Feb 2018 02:24:22 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20180222095641.w5isy5jt5a67jocp@kamzik.brq.redhat.com>
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
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, Yury Norov <ynorov@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 22, 2018 at 10:56:41AM +0100, Andrew Jones wrote:
> On Thu, Feb 22, 2018 at 10:10:34AM +0100, Christoffer Dall wrote:
> > On Wed, Feb 21, 2018 at 06:32:00PM +0100, Andrew Jones wrote:
> > > 
> > > Besides my confusion on motivation, it looks good to me
> > > 
> > 
> > In that case, unless there's an argument that the code has become too
> > hard to understand, ...
> >
> 
> On the contrary, I think it's easier to read now than before. I just
> wasn't clear how it all tied together with this series. If its
> combination with other patches enables a speedup, then it certainly
> fits here. I was just comparing mrs+loads vs. a load from stack and

The comparison should be mrs+load, vs. str+load (you save the store on
the stack).

> it seemed it would actually cause a micro-performance-decrease.
> 

Thanks,
-Christoffer
