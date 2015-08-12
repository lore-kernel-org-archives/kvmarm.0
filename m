From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 06/11] KVM: arm/arm64: vgic: Allow dynamic mapping of
 physical/virtual interrupts
Date: Wed, 12 Aug 2015 13:45:43 +0200
Message-ID: <20150812114543.GA15085@cbox>
References: <1438962347-17541-1-git-send-email-marc.zyngier@arm.com>
 <1438962347-17541-7-git-send-email-marc.zyngier@arm.com>
 <20150811074221.GC5007@lvm> <20150812105638.67de9423@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2E9E5AB52
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 07:31:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ry+IVo2Ohkpj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Aug 2015 07:31:44 -0400 (EDT)
Received: from mail-la0-f45.google.com (mail-la0-f45.google.com
 [209.85.215.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E0E545AB51
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 07:31:43 -0400 (EDT)
Received: by labd1 with SMTP id d1so7539272lab.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 04:44:48 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150812105638.67de9423@arm.com>
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
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Andre Przywara <Andre.Przywara@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 12, 2015 at 10:56:38AM +0100, Marc Zyngier wrote:
> On Tue, 11 Aug 2015 08:42:37 +0100
> Christoffer Dall <christoffer.dall@linaro.org> wrote:
> 
> > On Fri, Aug 07, 2015 at 04:45:42PM +0100, Marc Zyngier wrote:
> > > In order to be able to feed physical interrupts to a guest, we need
> > > to be able to establish the virtual-physical mapping between the two
> > > worlds.
> > > 
> > > The mappings are kept in a set of RCU lists, indexed by virtual interrupts.
> > > 
> > > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > 
> > Thanks for addressing all my concerns:
> > 
> > Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> Thanks a lot for all the reviewing, much appreciated.
> 
> Unless someone has an objection, I'm going put this series (minus
> the last patch) into -next so it gets a bit more exposure.
> 

Sounds good to me, when I'm back from this paper writing business
tomorrow/friday, I'll give it a spin and test the UEFI reboot issue with
it as well.

-Christoffer
