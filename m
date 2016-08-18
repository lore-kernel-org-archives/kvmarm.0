From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 0/7] Add support for monitoring guest TLB operations
Date: Thu, 18 Aug 2016 09:04:47 +0200
Message-ID: <93b02f65-25cd-13b0-f5ef-6b286b328aad@redhat.com>
References: <1471344312-26685-1-git-send-email-punit.agrawal@arm.com>
 <ed9ce98d-67d2-f01b-6bb0-5c5c842129a5@redhat.com>
 <87fuq3tjmv.fsf@e105922-lin.cambridge.arm.com>
 <a553745d-a527-b2ba-7cfa-f688786d5dc3@redhat.com>
 <878tvvtir5.fsf@e105922-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFE38410D7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Aug 2016 02:57:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6MH+x9ACihGJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Aug 2016 02:57:21 -0400 (EDT)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C28A840C9A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Aug 2016 02:57:20 -0400 (EDT)
Received: by mail-wm0-f65.google.com with SMTP id i138so3408092wmf.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Aug 2016 00:04:52 -0700 (PDT)
In-Reply-To: <878tvvtir5.fsf@e105922-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 17/08/2016 19:20, Punit Agrawal wrote:
> > > Having the ability to monitor the usage of guest TLB invalidations in
> > > the host can be useful to diagnose performance issues on such systems.
> >
> > Are there hardware performance counters for these operations?
> 
> That would have been ideal! There are PMU events defined for TLB
> accesses and refills but unhelpfully none of them track maintenance
> operations.

I guess the patches do make sense then. :)

Paolo
