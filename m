From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 6/6] KVM: arm/arm64: vgic: Allow configuration of
 interrupt groups
Date: Tue, 10 Jul 2018 10:17:24 +0100
Message-ID: <CAFEAcA_UFkHi=tMcLQXjODewuU9d01Kuv4cT2STjyF3YwhH5Pw@mail.gmail.com>
References: <1530697100-22419-1-git-send-email-christoffer.dall@arm.com>
 <1530697100-22419-7-git-send-email-christoffer.dall@arm.com>
 <7f875ead-d3cb-1fec-bc84-56e64526e6a7@arm.com>
 <20180709224836.GA26579@u002843.usa.arm.com>
 <51bb02d7-61d8-41bc-33e2-342364f659b5@arm.com>
 <01925c40-7087-9b52-c59d-2a85005de642@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FE9549F88
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jul 2018 05:05:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q+TsBrnrKZSR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Jul 2018 05:05:02 -0400 (EDT)
Received: from mail-oi0-f66.google.com (mail-oi0-f66.google.com
 [209.85.218.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4242D40672
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jul 2018 05:05:02 -0400 (EDT)
Received: by mail-oi0-f66.google.com with SMTP id i12-v6so41292529oik.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jul 2018 02:17:45 -0700 (PDT)
In-Reply-To: <01925c40-7087-9b52-c59d-2a85005de642@redhat.com>
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
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 10 July 2018 at 10:12, Auger Eric <eric.auger@redhat.com> wrote:
> Hi Christoffer, Marc,
>
> On 07/10/2018 10:33 AM, Marc Zyngier wrote:
>> On 09/07/18 23:48, Christoffer Dall wrote:
>>> What I would really like to know is whether this is really an issue or
>>> not.  Do people who run products based on KVM, such as RHEV, have any
>>> expectations about cross-kernel version migration?
>>
>> I'd like to know as well.
>
> Sorry I did not have time to review the series properly. My
> understanding is we generally care about migration between different
> kernels. For the ITS, we made the IIDR writable too to manage the ABI
> version properly. See ab01c6bdacc43c41c6b326889f4358f5afc38bf9. But
> maybe I missed the crux of the matter.

I think the question is whether we're doing this because
we think hypothetical users care, or because we know actual
real in-production users really care...

thanks
-- PMM
