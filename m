From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 0/2] KVM: ARM: Enable vtimers with user space gic
Date: Fri, 16 Sep 2016 14:18:45 +0200
Message-ID: <7beb406b-6194-8451-2d92-9a4394ef91dd@redhat.com>
References: <1474007187-18673-1-git-send-email-agraf@suse.de>
 <57DBC782.7080305@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7D56411E3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 08:10:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q2ymKc0EcYAO for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2016 08:10:00 -0400 (EDT)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 504F041145
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 08:10:00 -0400 (EDT)
Received: by mail-wm0-f67.google.com with SMTP id 133so3494303wmq.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 05:18:52 -0700 (PDT)
In-Reply-To: <57DBC782.7080305@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 16/09/2016 12:20, Marc Zyngier wrote:
> > This patch set allows user space to receive vtimer events as well as mask
> > them, so that we can handle all vtimer related interrupt injection from user
> > space, enabling us to use architected timer with user space gic emulation.
>
> I have already voiced my concerns in the past, including face to face,
> and I'm going to repeat it: I not keen at all on adding a new userspace
> interface that is going to bitrot extremely quickly.

You don't have automated tests set up?  It's not going to bitrot if you
test it, either with kvm-unit-tests or just by smoke-testing Linux.
It's _for_ the raspi, but it's not limited to it.

Paolo
