From: Miriam Zimmerman <mutexlox@google.com>
Subject: Re: Timekeeping on ARM guests/hosts
Date: Wed, 10 Oct 2018 11:38:47 -0700
Message-ID: <CAHSjozBtan6L7eWypnB_aACqHSrBAykjU8LcxfM3Pv3QMSZnJw@mail.gmail.com>
References: <CAHSjozDb2_q9YgHsEerH_-2uc6S9W-cw_p2hTiafisQUTrwH6Q@mail.gmail.com>
 <cd4eeb25-50c6-329d-d6e8-26caf478a041@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ADCA4A1D8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Oct 2018 14:39:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VIqnFmAY3lxf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Oct 2018 14:39:00 -0400 (EDT)
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com
 [209.85.167.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D9FE4A1D0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Oct 2018 14:38:59 -0400 (EDT)
Received: by mail-oi1-f176.google.com with SMTP id p125-v6so4954964oic.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Oct 2018 11:38:59 -0700 (PDT)
In-Reply-To: <cd4eeb25-50c6-329d-d6e8-26caf478a041@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

(oops, sorry for lack of plaintext in the first email. must've
forgotten to click the button in my email client)

Until that happens, what's the best workaround? Just running an ntp
daemon in guest?

On Wed, Oct 10, 2018 at 3:01 AM Marc Zyngier <marc.zyngier@arm.com> wrote:
>
> Hi Myriam,
>
> On 10/10/18 00:39, Miriam Zimmerman wrote:
> > Hi,
> >
> > I'm working with an ARM device hosting an ARM guest. When the host is
> > suspended, guest time stops advancing and it doesn't get adjusted on resume.
>
> I know the feeling, my arm64 laptop gives me that kind of grief all the
> time... :-/
>
> > For an x86 machine, the CONFIG_KVM_GUEST flag would enable paravirt for
> > time and fix this problem, but CONFIG_KVM_GUEST isn't available on ARM.
> >
> > Is there a configuration option to enable paravirtualized timekeeping on
> > ARM? If not, how can I configure ARM guests to handle timekeeping properly?
>
> PV time (or rather stolen time) is a work in progress at the moment, and
> Christoffer has his hands in that particular pie.
>
> Thanks,
>
>         M.
> --
> Jazz is not dead. It just smells funny...
