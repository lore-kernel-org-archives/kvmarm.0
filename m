From: Miriam Zimmerman <mutexlox@google.com>
Subject: Re: Timekeeping on ARM guests/hosts
Date: Wed, 7 Nov 2018 10:22:06 -0800
Message-ID: <CAHSjozAzRu7u+2TfuhuLEozmcEer54MsOq865-BuocgXp2O79w@mail.gmail.com>
References: <86lg74ude3.wl-marc.zyngier@arm.com>
 <8088f91a-1a56-065d-1c8e-f9eccbb1b342@redhat.com>
 <CAHSjozB1jQp4L==jx8pn222T7O991-d0H3Cd-5JPtJqQ8zQHAA@mail.gmail.com>
 <59a6562e-ad8d-3bf3-cde8-4ff9c8997c95@arm.com>
 <CAHSjozCGbjAfEuhKtJyCSqw5ByTgY3b9r=5smXGv_v0PBLerOQ@mail.gmail.com>
 <20181102143431.GZ12057@e113682-lin.lund.arm.com>
 <CAHSjozAJ0_W0o3865HsCVndgfr209h9uqeuUK1=Lx1+9m18eUw@mail.gmail.com>
 <CAHSjozD-5K3SgL8hxFh+hU3rUOZ9s=duFpj56jQ39VEBUdeXSQ@mail.gmail.com>
 <20181106074523.GC12057@e113682-lin.lund.arm.com>
 <CAHSjozBxtK5wnYBC-Eha8hDrB5-D6dx+8yKXHOXndD6pi-ML0Q@mail.gmail.com>
 <20181107094234.GA3835@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91C244A312
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Nov 2018 13:22:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MQ0gFQ7mQpCr for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Nov 2018 13:22:19 -0500 (EST)
Received: from mail-ot1-f66.google.com (mail-ot1-f66.google.com
 [209.85.210.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8CC254A310
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Nov 2018 13:22:19 -0500 (EST)
Received: by mail-ot1-f66.google.com with SMTP id g10so15639815otl.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Nov 2018 10:22:19 -0800 (PST)
In-Reply-To: <20181107094234.GA3835@e113682-lin.lund.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@arm.com
Cc: marc.zyngier@arm.com, lersek@redhat.com, steven.price@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 7, 2018 at 1:42 AM Christoffer Dall
<christoffer.dall@arm.com> wrote:
>
> On Tue, Nov 06, 2018 at 10:37:21AM -0800, Miriam Zimmerman wrote:
> > On Mon, Nov 5, 2018 at 11:45 PM Christoffer Dall
> > <christoffer.dall@arm.com> wrote:
> > >
> > > On Fri, Nov 02, 2018 at 02:23:45PM -0700, Miriam Zimmerman wrote:
> > > > In researching KVM_REG_ARM_TIMER_CNT, I discovered your commit 4b7a6bf
> > > > ("target-arm: kvm: Differentiate registers based on write-back
> > > > levels"), which seems to limit when the KVM_REG_ARM_TIMER_CNT is used
> > > > to save time. Under what circumstances should this be saved in order
> > > > to provide a consistent view of wall clock time (as given by `date` in
> > > > the VM)?
> > >
> > > In general, and not specific to QEMU, I think that the virtual
> > > counter value should stop counting when the entirety of the VM is not
> > > running, for example when the host machine is suspended, or when the
> > > entire VM is stopped/suspended, either as part of a suspend/resume
> > > operation, debug operation, or as part of migration of some sort.
> > >
> > > Supporting these timekeeping semantics is not something anyone has tried
> > > up until now with KVM/Arm, as far as I'm aware, and as such is 'new'
> > > work.
> >
> > Hrm, that's perplexing to me. I thought you said that in your tests,
> > going into S3 suspend on a host did *not* result in time drift on the
> > guest? That would suggest to me that there is code that correctly
> > handles it.
>
> I don't believe I've said that.  I haven't actually tried that myself,
> but I know anecdotally from others that time jumps on the guest when you
> suspend the host, leading to warnings in a guest.
>
> There must be some misunderstanding here.

Ah, indeed - Steven said that he tried this and saw time track
properly in-guest on ARM. I misremembered and thought that was you.

> >
> > Upthread, you said:
> > > The key is whether the userspace program that controls the KVM VM
> > > (kvmtool, QEMU, crosvm) uses the KVM_REG_ARM_TIMER_CNT ioctl to save the
> > > VM view of virtual time, and to retore that at a later time.
> > Is this a description of current behavior of any of these userspace
> > programs, or a description of how they might opt to address the
> > time-drift-on-suspend issue?
> >
>
> That is how they might choose, using the current KVM/Arm api, to adjust
> for suspending the VM (different from suspending the host).

I understand this now; thanks. I was somewhat confused when I started
diving into qemu and didn't see anything like what you described :-).


> > > > The commit refers to 'machine initialization or on vmload
> > > > operations', but I'm having difficulty figuring out what a vmload
> > > > operation is on ARM. Does this include resume-from-sleep/suspend?
> > >
> > > I believe vmload is qemu-speak for loading in VM state from a stored
> > > migration stream, but you'd have to ask the QEMU folks or study the code
> > > more carefully to figure out when a vmload really happens.
> > I see, okay. I misread the patch's commit log and thought you had written it.
> >
>
> I did, but I'm (at best) a drive-by QEMU hacker, and I am not presently
> in a position to contribute to QEMU.  There is also always the
> possibility that my patch was wrong.  I think in this particular case,
> though, I was trying to solve a differnet problem with that patch and
> didn't realy consider the problem of virtual time back then.

Got it. Thanks, Christoffer!
> Hope this helps,
>
>     Christoffer
