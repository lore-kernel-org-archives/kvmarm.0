From: Shih-Wei Li <shihwei@cs.columbia.edu>
Subject: Re: [PATCH kvm-unit-tests 2/2] arm64: add micro-bench
Date: Tue, 4 Sep 2018 11:02:43 -0400
Message-ID: <CAO+sbHG5yUR4oA6YPksKeLM6+mpAKuj47BjvMbeU=LZFMTOuEQ@mail.gmail.com>
References: <20180830141733.21725-1-drjones@redhat.com>
 <20180830141733.21725-3-drjones@redhat.com>
 <CAO+sbHHswsoUqhnwwzB5bGoc7G_cbkw24t6Br1=7bULVxoctaw@mail.gmail.com>
 <20180903163139.arpf6vpg4d2z7mju@kamzik.brq.redhat.com>
 <CAO+sbHET=Bgx2aUuhB0OoK7NJb==W7pxNhsFLs68x0XMQRvwdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9972F40A50
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Sep 2018 11:03:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YJrfutk+uU6Y for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Sep 2018 11:03:17 -0400 (EDT)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA05D4A1DC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Sep 2018 11:03:17 -0400 (EDT)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id w84F133S036802
 for <kvmarm@lists.cs.columbia.edu>; Tue, 4 Sep 2018 11:03:17 -0400
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 9034A82
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Sep 2018 11:03:17 -0400 (EDT)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id EECD183
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Sep 2018 11:03:15 -0400 (EDT)
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id w84F3Ehb032666
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Tue, 4 Sep 2018 11:03:15 -0400
Received: by mail-lj1-f200.google.com with SMTP id x86-v6so941956ljb.19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Sep 2018 08:03:15 -0700 (PDT)
In-Reply-To: <CAO+sbHET=Bgx2aUuhB0OoK7NJb==W7pxNhsFLs68x0XMQRvwdA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Christoffer Dall <cdall@cs.columbia.edu>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

I've tested patch v2 along with the fix in the switch case. The
performance numbers look sane on my seattle server.

Tested-by: Shih-Wei Li <shihwei@cs.columbia.edu>

Thanks,
Shih-Wei

On Mon, Sep 3, 2018 at 11:38 PM, Shih-Wei Li <shihwei@cs.columbia.edu> wrote:
> On Mon, Sep 3, 2018 at 12:31 PM, Andrew Jones <drjones@redhat.com> wrote:
>> On Mon, Sep 03, 2018 at 11:06:51AM -0400, Shih-Wei Li wrote:
>>> On Thu, Aug 30, 2018 at 10:17 AM, Andrew Jones <drjones@redhat.com> wrote:
>>> > +static bool test_init(void)
>>> > +{
>>> > +       int v = gic_init();
>>> > +
>>> > +       if (!v) {
>>> > +               printf("No supported gic present, skipping tests...\n");
>>> > +               return false;
>>> > +       }
>>> > +
>>> > +       if (nr_cpus < 2) {
>>> > +               printf("At least two cpus required, skipping tests...\n");
>>> > +               return false;
>>> > +       }
>>> > +
>>> > +       switch (v) {
>>> > +       case 2:
>>> > +               vgic_dist_base = gicv2_dist_base();
>>> > +               write_eoir = gicv2_write_eoir;
>>> > +       case 3:
>>> > +               vgic_dist_base = gicv3_dist_base();
>>> > +               write_eoir = gicv3_write_eoir;
>>> > +       }
>>>
>>> I think we'll need a "break" in the switch case body for gicv2 here
>>> otherwise it'll fall into the case body below and refer to the wrong
>>> symbols for gicv3.
>>>
>>> As I've tested on my seattle server hardware (with gicv2), this results
>>> to incorrect execution in mmio_read_vgic_exec and a crash in
>>> eoi_exec().
>>>
>>
>> Argh... Obviously my testing of this was pretty poor. You are certainly
>> right that I'm missing breaks in this switch. If you don't mind, please
>> add them, along with the fix in v2, to your local repo and test again.
>> I'll hold off on sending v3 until you've had a chance to test and review
>> more.
>>
>> Thanks,
>> drew
>
> I've added the break to the switch and it resolved the problems I
> mentioned earlier. I'll do more testing and reviewing, and will get
> back to you as soon as I can.
>
> Thanks for formalizing the new patch set for micro-test!
>
> Shih-Wei
