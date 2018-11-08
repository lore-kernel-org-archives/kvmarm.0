From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: Timekeeping on ARM guests/hosts
Date: Thu, 8 Nov 2018 11:26:35 +0100
Message-ID: <20181108102635.GE3835@e113682-lin.lund.arm.com>
References: <CAHSjozB1jQp4L==jx8pn222T7O991-d0H3Cd-5JPtJqQ8zQHAA@mail.gmail.com>
 <59a6562e-ad8d-3bf3-cde8-4ff9c8997c95@arm.com>
 <CAHSjozCGbjAfEuhKtJyCSqw5ByTgY3b9r=5smXGv_v0PBLerOQ@mail.gmail.com>
 <20181102143431.GZ12057@e113682-lin.lund.arm.com>
 <CAHSjozAJ0_W0o3865HsCVndgfr209h9uqeuUK1=Lx1+9m18eUw@mail.gmail.com>
 <CAHSjozD-5K3SgL8hxFh+hU3rUOZ9s=duFpj56jQ39VEBUdeXSQ@mail.gmail.com>
 <20181106074523.GC12057@e113682-lin.lund.arm.com>
 <CAHSjozBxtK5wnYBC-Eha8hDrB5-D6dx+8yKXHOXndD6pi-ML0Q@mail.gmail.com>
 <20181107094234.GA3835@e113682-lin.lund.arm.com>
 <CAHSjozAzRu7u+2TfuhuLEozmcEer54MsOq865-BuocgXp2O79w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 410994A32D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Nov 2018 05:26:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3DENekHYVmrj for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Nov 2018 05:26:38 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC62B4A31C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Nov 2018 05:26:38 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <CAHSjozAzRu7u+2TfuhuLEozmcEer54MsOq865-BuocgXp2O79w@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Miriam Zimmerman <mutexlox@google.com>
Cc: marc.zyngier@arm.com, lersek@redhat.com, steven.price@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 07, 2018 at 10:22:06AM -0800, Miriam Zimmerman wrote:
> On Wed, Nov 7, 2018 at 1:42 AM Christoffer Dall
> <christoffer.dall@arm.com> wrote:
> >
> > On Tue, Nov 06, 2018 at 10:37:21AM -0800, Miriam Zimmerman wrote:
> > > On Mon, Nov 5, 2018 at 11:45 PM Christoffer Dall
> > > <christoffer.dall@arm.com> wrote:
> > > >
> > > > On Fri, Nov 02, 2018 at 02:23:45PM -0700, Miriam Zimmerman wrote:
> > > > > In researching KVM_REG_ARM_TIMER_CNT, I discovered your commit 4b7a6bf
> > > > > ("target-arm: kvm: Differentiate registers based on write-back
> > > > > levels"), which seems to limit when the KVM_REG_ARM_TIMER_CNT is used
> > > > > to save time. Under what circumstances should this be saved in order
> > > > > to provide a consistent view of wall clock time (as given by `date` in
> > > > > the VM)?
> > > >
> > > > In general, and not specific to QEMU, I think that the virtual
> > > > counter value should stop counting when the entirety of the VM is not
> > > > running, for example when the host machine is suspended, or when the
> > > > entire VM is stopped/suspended, either as part of a suspend/resume
> > > > operation, debug operation, or as part of migration of some sort.
> > > >
> > > > Supporting these timekeeping semantics is not something anyone has tried
> > > > up until now with KVM/Arm, as far as I'm aware, and as such is 'new'
> > > > work.
> > >
> > > Hrm, that's perplexing to me. I thought you said that in your tests,
> > > going into S3 suspend on a host did *not* result in time drift on the
> > > guest? That would suggest to me that there is code that correctly
> > > handles it.
> >
> > I don't believe I've said that.  I haven't actually tried that myself,
> > but I know anecdotally from others that time jumps on the guest when you
> > suspend the host, leading to warnings in a guest.
> >
> > There must be some misunderstanding here.
> 
> Ah, indeed - Steven said that he tried this and saw time track
> properly in-guest on ARM. I misremembered and thought that was you.

What Steven said was:

  "On Arm, as far as I know, the guest's view of time is purely from the
  virtual counter. Since nothing saves/restores this during the pause,
  the counter continues to increment and the jump in time is visible to
  the guest."

So here he means that time in the guest jumps, which is not what the
guest expects, and thus you see warnings and problems from the guest,
even though date/time may be reported correctly in the guest for the
same reason.

Adjusting virtual time should prevent the guest from getting confused
wrt. watchdogs and starved processes etc.

However, I'm still not entirely clear on how the guest will correctly
observe wall-clock if we adjust virtual time.  Should it use the
physical counter?  Does PV take care of this?  Does it receive a
notification that it must update its clock via NTP?

Steve, any insight?


Thanks,

    Christoffer
