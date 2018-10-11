From: Miriam Zimmerman <mutexlox@google.com>
Subject: Re: Timekeeping on ARM guests/hosts
Date: Thu, 11 Oct 2018 11:40:57 -0700
Message-ID: <CAHSjozB1jQp4L==jx8pn222T7O991-d0H3Cd-5JPtJqQ8zQHAA@mail.gmail.com>
References: <CAHSjozDb2_q9YgHsEerH_-2uc6S9W-cw_p2hTiafisQUTrwH6Q@mail.gmail.com>
 <cd4eeb25-50c6-329d-d6e8-26caf478a041@arm.com>
 <CAHSjozBtan6L7eWypnB_aACqHSrBAykjU8LcxfM3Pv3QMSZnJw@mail.gmail.com>
 <86lg74ude3.wl-marc.zyngier@arm.com>
 <8088f91a-1a56-065d-1c8e-f9eccbb1b342@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFA6049E3E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Oct 2018 14:41:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SeGoam5kopT9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Oct 2018 14:41:09 -0400 (EDT)
Received: from mail-ot1-f65.google.com (mail-ot1-f65.google.com
 [209.85.210.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D4A740A6E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Oct 2018 14:41:09 -0400 (EDT)
Received: by mail-ot1-f65.google.com with SMTP id c23so8155855otl.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Oct 2018 11:41:09 -0700 (PDT)
In-Reply-To: <8088f91a-1a56-065d-1c8e-f9eccbb1b342@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: lersek@redhat.com
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 11, 2018 at 8:21 AM Laszlo Ersek <lersek@redhat.com> wrote:
>
> On 10/11/18 09:54, Marc Zyngier wrote:
> > Hi Miriam,
> >
> > On Wed, 10 Oct 2018 19:38:47 +0100,
> > Miriam Zimmerman <mutexlox@google.com> wrote:
> >>
> >> (oops, sorry for lack of plaintext in the first email. must've
> >> forgotten to click the button in my email client)
> >>
> >> Until that happens, what's the best workaround? Just running an ntp
> >> daemon in guest?
> >
> > Christoffer reminded me yesterday that stolen time accounting only
> > affects scheduling, and is not evaluated for
> >
> > An NTP daemon may not be the best course of action, as the guest is
> > going to see a massive jump anyway, which most NTP implementations are
> > not design to handle (they rightly assume that something else is
> > wrong). It would also mean that you'd have to run a NTP server
> > somewhere on the host, as you cannot always assume full connectivity.
> >
> > A popular way to solve this seems to be using the QEMU guest agent,
> > but I must admit I never really investigated that side of the problem.
>
> The guest agent method is documented here, for example:
>
> https://git.qemu.org/?p=qemu.git;a=blob;f=qga/qapi-schema.json;h=dfbc4a5e32bde4070f12497c23973c604accfa7d;hb=v3.0.0#l128
>
> and IIRC it is exposed (for example) via "virsh domtime" to the libvirt
> user (or to higher level mgmt tools).
>
> I suspect though that the guest agent method might introduce the same
> kind of jump to the guest clock.
>
> > I'm quite curious of how this is done on x86 though. KVM_GUEST mostly
> > seems to give the guest a PV clocksource, which is not going to help in
> > terms of wall clock. Do you have any idea?
>
> I've seen this question raised, specifically wrt. x86, with people
> closing their laptops' lids, and their guests losing correct track of
> time. AIUI, there is no easy answer. (I was surprised to see Miriam's
> initial statement that CONFIG_KVM_GUEST had solved it.) Some references:

Interesting; I haven't dug too much into the specifics of how the
timekeeping works, but I just did a quick experiment: I took two
laptops (one ARM and one x86) next to each other, ran "date" in VMs in
both, closed them for a few minutes, then reopened them and ran "date"
again. The x86 laptop had the correct time, whereas the ARM laptop
guest had (approximately) the same time as when I closed it.

I'm guessing this behavior is implemented in either
arch/x86/kernel/kvmclock.c or arch/x86/kernel/pvclock.c, but I'll
confess that I've only skimmed those.

I'll investigate how this works on x86 a bit. My plan had been to
workaround by using a guest agent that receives the correct wallclock
time on resume and adjusts the VM's clock as appropriate, but the
suspend option seems like a pretty good idea.

> https://bugs.launchpad.net/qemu/+bug/1174654
> https://bugzilla.redhat.com/show_bug.cgi?id=1352992
> https://bugzilla.redhat.com/show_bug.cgi?id=1380893
>
> I'll spare you the verbatim quoting of the emails that I produced back
> then :) ; a summary of workarounds is:
>
> * Before you suspend the host, suspend the guest first. This way the
> guest will not be surprised when it sees the physical clock (= whatever
> it thinks is a physical clock) jump. Another benefit is that, if the
> host fails to resume for some reason, data loss on the VM disks should
> be reasonably unlikely, because when the guest suspends, it will flush
> its stuff first.
>
> * Use "-rtc clock=vm" on the QEMU command line. (Equivalently, use
> <timer name='rtc' track='guest'/> in the libvirt domain XML.) See the
> QEMU manual, and the libvirt domain XML manual on these. Those settings
> decouple the guest's RTC from the host's time, bringing both benefits
> (no jumps in guest time) and drawbacks (the timelines diverge).
>
> * Also, I've heard rumors that libvirtd might put a suspend inhibitor in
> place (on the host) while some VMs are running. ("Suspend inhibitor" is
> a SystemD term, I think.) Not sure how/if that works in practice; either
> way it would solve the issue from a different perspective (namely, you
> couldn't suspend the host).
>
>
> Obviously I'm not trying to speak on this with any kind of "authority",
> so take it FWIW. I happen to be a fan of the first option (manual guest
> suspend).
>
> Thanks,
> Laszlo
