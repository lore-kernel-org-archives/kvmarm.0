From: Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH] arm64: dts: Fix GIC reg sizes for APM X-Gene
Date: Mon, 23 Feb 2015 07:24:04 -0500 (EST)
Message-ID: <898480616.21888431.1424694244176.JavaMail.zimbra@zmail15.collab.prod.int.phx2.redhat.com>
References: <1422342206-4750-1-git-send-email-psawargaonkar@apm.com>
 <CAL_JsqJQcuX2cp50oHod-QAbhdMg48TaRP+gLGEO2kbFnQ3B+A@mail.gmail.com>
 <20150219190348.GB24460@cbox>
 <CAL_JsqLcBOC+AnVe7oATjg2g6Fz2vqwacu8QzS4tXMaxxOP_Xg@mail.gmail.com>
 <20150223120744.GA5609@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61B1E464B3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Feb 2015 07:18:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZqlW9eU+Tqrk for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Feb 2015 07:18:44 -0500 (EST)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A10B46491
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Feb 2015 07:18:43 -0500 (EST)
In-Reply-To: <20150223120744.GA5609@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Feng Kan <fkan@apm.com>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, "patches@apm.com" <patches@apm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Rob Herring <robherring2@gmail.com>, Tushar Jagad <tjagad@apm.com>, Pranavkumar Sawargaonkar <psawargaonkar@apm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Sorry about top post. Quick comment in reply to Seattle point below - yes, it does indeed support 64K and already has the right DTS.

-- 
Computer Architect | Sent from my #ARM Powered Mobile Device

On Feb 23, 2015 4:14 AM, Christoffer Dall <christoffer.dall@linaro.org> wrote:
>
> On Sat, Feb 21, 2015 at 03:56:17PM -0600, Rob Herring wrote: 
> > On Thu, Feb 1On Sat, Feb 21, 2015 at 03:56:17PM -0600, Rob Herring wrote:
> On Thu, Feb 19, 2015 at 1:03 PM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > On Thu, Feb 19, 2015 at 12:23:15PM -0600, Rob Herring wrote:
> >> On Tue, Jan 27, 2015 at 1:03 AM, Pranavkumar Sawargaonkar
> >> <psawargaonkar@apm.com> wrote:
> >> > In APM X-Gene, GIC register space is 64K aligned while the sizes mentioned
> >> > in the dt are 4K aligned. This breaks KVM when kernel is built with 64K page
> >> > size due to size alignment checking in vgic driver for VCPU Control and
> >> > VCPU register.
> >> >
> >> > This patch corrects the sizes to be inline with the hardware spec.
> >>
> >> This does not make sense. The GIC regions are still only 4 or 8KB and
> >> the h/w description should reflect that. For implementations using
> >> gic-400 and the addressing decode trick, the rest of the register
> >> range is also not safe to access given it is multiple mapped. Also,
> >> this wastes virtual space, but I guess we don't care on 64-bit.
> >>
> >> KVM should be fixed to only check base address alignment. Size
> >> alignment does not matter (if it does, then you need to fix all
> >> register blocks).
> >>
> > It matters if you want to ensure that the 64K page you are assigning to
> > a guest for the GIC virtual CPU interface contains only GIC virtual CPU
> > mappings, and not other random stuff that the guest is not allowed to
> > touch.
> 
> Good point.
> 
> > How else should this be enforced?
> 
> Rely on correct h/w design? You'll have to repeat this every time you
> want to do pass-thru of a device.
> 
> What do you do if 64K mapping is not supported? Fallback to emulation
> of the CPU interface?

Agree with Peter on these two points.

> 
> Are there other DTSs that need to be fixed?
> 
Not sure really, AMD Seattle works with 64K pages IIRC.

Thanks,
-Christoffer
