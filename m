From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 00/16] KVM: arm64: GICv3 ITS emulation
Date: Fri, 18 Mar 2016 10:38:19 +0100
Message-ID: <20160318093819.GB10806@cbox>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
 <56E00A7E.4080101@semihalf.com> <20160313181608.GA15988@cbox>
 <56E69CCA.5070407@arm.com>
 <CAFEAcA8r5LDbNG0XVnHnsoYcrfcpfnR3FQ_u=-L7Dop1HFVgxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B5AA49B56
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2016 05:37:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eJeQM-ddnG+S for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Mar 2016 05:37:31 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DD21549B4E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2016 05:37:30 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id l68so60249877wml.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2016 02:37:59 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAFEAcA8r5LDbNG0XVnHnsoYcrfcpfnR3FQ_u=-L7Dop1HFVgxw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 14, 2016 at 05:29:44PM +0000, Peter Maydell wrote:
> On 14 March 2016 at 11:13, Andre Przywara <andre.przywara@arm.com> wrote:
> > So I see two ways to fix this:
> > 1.) we find a KVM specific way of letting userland save and restore the
> > ITS tables directly
> > 2.) we implement the BASER<n> registers, but still use our "cache" for
> > normal operations. On demand we would serialize KVM's virtual ITS data
> > structures and put them into the guest's memory, so they could be
> > saved/restored from there.
> 
> I feel like we're rehashing a bunch of design choices we talked
> through way back in the last-but-one Connect. I don't suppose
> anybody wrote down our rationales from back then?

Someone (not me) had the task to write it down, I don't recall if that
happened or not :)

> 
> (In particular I forget whether we decided the ITS tables were
> large enough to need to allow some sort of before-the-VM-stops
> migration of the data, which would be relatively doable with
> option 2 but painful under option 1.)

I think we concluded that it's not so much data that applying dirty
bitmaps stuff on there is strictly necessary, but that being able to do
this was probably a plus, and not very hard to do.

I am quite sure that we dismissed option 1, and were decided on option 2
though.

-Christoffer
