From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Thu, 19 Feb 2015 18:57:24 +0100
Message-ID: <54E62404.9040702@redhat.com>
References: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
 <20150219165731.GA26965@hawk.usersys.redhat.com>
 <CAKv+Gu8Je3RRrgEFCZ7JUWtOgk3WqA_qdBEOPAMc3OqnKr1bwg@mail.gmail.com>
 <20150219175518.GB26965@hawk.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2B744610E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 12:52:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L-QPAIfcO7MJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Feb 2015 12:52:08 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9FEB460E6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 12:52:07 -0500 (EST)
In-Reply-To: <20150219175518.GB26965@hawk.usersys.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 19/02/2015 18:55, Andrew Jones wrote:
>> > > (I don't have an exact number for how many times it went to EL1 because
>> > >  access_mair() doesn't have a trace point.)
>> > > (I got the 62873 number by testing a 3rd kernel build that only had patch
>> > >  3/3 applied to the base, and counting kvm_toggle_cache events.)
>> > > (The number 50 is the number of kvm_toggle_cache events *without* 3/3
>> > >  applied.)
>> > >
>> > > I consider this bad news because, even considering it only goes to EL2,
>> > > it goes a ton more than it used to. I realize patch 3/3 isn't the final
>> > > plan for enabling traps though.

If a full guest boots, can you try timing a kernel compile?

Paolo
