From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v3 01/19] KVM: arm/arm64: Add vITS save/restore API
 documentation
Date: Mon, 13 Mar 2017 18:38:32 +0100
Message-ID: <CAFEAcA_VqJQ-BFQPpdnK07x6B=cN-HcPY7pBr7=J5UGXm4iSnQ@mail.gmail.com>
References: <1488800074-21991-1-git-send-email-eric.auger@redhat.com>
 <1488800074-21991-2-git-send-email-eric.auger@redhat.com>
 <CAFEAcA_hobSQZvOQHGgdoJYw9q099GNrY=5ffjYO5YeePtKdNA@mail.gmail.com>
 <6f86ec3f-6b9e-34ba-628a-c2ef7b8c3529@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B9B840AF9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Mar 2017 13:37:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EM87uPPGo1Em for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Mar 2017 13:37:21 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 80AE840430
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Mar 2017 13:37:21 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id t189so45930108wmt.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Mar 2017 10:38:54 -0700 (PDT)
In-Reply-To: <6f86ec3f-6b9e-34ba-628a-c2ef7b8c3529@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: "prasun.kapoor" <Prasun.Kapoor@cavium.com>, kvm-devel <kvm@vger.kernel.org>, Juan Quintela <quintela@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "Kumar,
 Vijaya" <Vijaya.Kumar@cavium.com>, Vijaya Kumar K <vijayak@caviumnetworks.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On 13 March 2017 at 15:42, Auger Eric <eric.auger@redhat.com> wrote:
> On 13/03/2017 14:08, Peter Maydell wrote:
>> These CTE/ITE/DTE formats don't seem to have any kind of
>> "escape hatch" for allowing backwards compatible extensions
>> to the format. Do we need one? (I think that's particularly
>> likely to be useful where there's an ITS feature we don't
>> currently implement but might perhaps want to in future,
>> like GICv4 virtual interrupt injection.)
>
> Maybe we could rely on the ITS registers (that must be restored before
> the tables) to get any info about the format used to encode the table
> entries. We have GITS_CTLR[1] that can help discriminate between GICv3/
> GICv4. GITS_BASER.Entry_size can be 8B for current implementation and
> 16B for an enhanced implementation. CTE[52:62] can be used to encode a
> format version.

Using the registers seems like a good idea, though I
don't know about the specific fields. The most obvious
place to keep something like this would be GITS_IIDR.Revision
I suppose. Using the "size of the table entry" fields would
work too.

If we have to make all these tables double the size if
we move to 16b/entry in future, is that a significant
increase in memory used, or a don't-really-care increase?

I guess what we should do is:
 * identify obviously imminently upcoming features (like
   GICv4 support, wider physaddrs) and make sure the format
   supports them
   [let's say, anything we think we're definitely likely
   to be adding in the next 12 months]
 * decide on our 'escape hatch' plan for anything
   more vague
 * test that we do correctly fail migration for an
   incoming ITS state that asks for an unsupported Revision
 * document how the 'escape hatch' is intended to work
   so we don't then invent a different approach in the
   future :-)

thanks
-- PMM
