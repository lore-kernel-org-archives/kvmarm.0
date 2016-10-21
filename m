From: Robert Richter <robert.richter@cavium.com>
Subject: Re: v4.9-rc1 fails booting as a guest on ARM64 Cavium ThunderX
Date: Fri, 21 Oct 2016 18:34:07 +0200
Message-ID: <20161021163407.GM22012@rric.localdomain>
References: <924fd627-329a-54e0-694c-a9bdf979f696@redhat.com>
 <de2acaca-f694-be1a-5d2c-93fcf3b25011@arm.com>
 <99c7d3b5-0495-083f-b4b7-b58b20cf859e@redhat.com>
 <5a5e4ed5-a575-f720-36f0-acb545a170f4@arm.com>
 <e52f2867-102f-8aad-4815-2a682586f129@redhat.com>
 <20161021114951.gm3u6msvl4jz2kv7@kamzik.brq.redhat.com>
 <CAFEAcA-K+Fnw7Fwh3tK0nqLxhUrtLB7XrJVtswXwTb7d2X+Y+Q@mail.gmail.com>
 <20161021120732.bl5p5vji25zibap3@kamzik.brq.redhat.com>
 <bf32d77e-93e1-c943-e6b6-953b3d8c9e20@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A69B0411BE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 12:24:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RfD0b0loIHcj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Oct 2016 12:24:01 -0400 (EDT)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam02on0044.outbound.protection.outlook.com [104.47.36.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B829240C9D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 12:24:00 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <bf32d77e-93e1-c943-e6b6-953b3d8c9e20@arm.com>
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
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Daniel Thompson <daniel.thompson@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 21.10.16 13:52:43, Marc Zyngier wrote:
> On 21/10/16 13:07, Andrew Jones wrote:
> > On Fri, Oct 21, 2016 at 12:57:37PM +0100, Peter Maydell wrote:
> >> On 21 October 2016 at 12:49, Andrew Jones <drjones@redhat.com> wrote:
> >>> I also read the register before writing it and saw it was 3. I tried
> >>> writing 3 instead of 0 to see what would happen, but the failure
> >>> persisted. I did read back the register after writing it to confirm the
> >>> change took affect.
> >>
> >> So what does it read back as after you write 0? The GICv3 spec
> >> says it can't read back as zero...
> >>
> > 
> > I read back zero
> > 
> > pre-read  bpr1=3
> > post-read bpr1=0
> > FAIL: gicv3: ipi: self: Timed-out (5s). ACKS: missing=1 extra=0 unexpected=0
> 
> Gah... I guess we'll have to either roll a dice, or get someone from
> Cavium to tell us what's happening here. In the meantime, can you give
> the following patch a go? It doesn't fire on my FSL box, but everything
> hunky dory on it so far...

Marc, we are looking into this.

-Robert
