From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v3 00/16] KVM: arm64: GICv3 ITS emulation
Date: Mon, 14 Mar 2016 17:29:44 +0000
Message-ID: <CAFEAcA8r5LDbNG0XVnHnsoYcrfcpfnR3FQ_u=-L7Dop1HFVgxw@mail.gmail.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
 <56E00A7E.4080101@semihalf.com> <20160313181608.GA15988@cbox>
 <56E69CCA.5070407@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E7A34113E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2016 13:29:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vehPeQNeKJbE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2016 13:29:46 -0400 (EDT)
Received: from mail-vk0-f48.google.com (mail-vk0-f48.google.com
 [209.85.213.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1FAAD410EB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2016 13:29:45 -0400 (EDT)
Received: by mail-vk0-f48.google.com with SMTP id k1so217962373vkb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2016 10:30:04 -0700 (PDT)
In-Reply-To: <56E69CCA.5070407@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 14 March 2016 at 11:13, Andre Przywara <andre.przywara@arm.com> wrote:
> So I see two ways to fix this:
> 1.) we find a KVM specific way of letting userland save and restore the
> ITS tables directly
> 2.) we implement the BASER<n> registers, but still use our "cache" for
> normal operations. On demand we would serialize KVM's virtual ITS data
> structures and put them into the guest's memory, so they could be
> saved/restored from there.

I feel like we're rehashing a bunch of design choices we talked
through way back in the last-but-one Connect. I don't suppose
anybody wrote down our rationales from back then?

(In particular I forget whether we decided the ITS tables were
large enough to need to allow some sort of before-the-VM-stops
migration of the data, which would be relatively doable with
option 2 but painful under option 1.)

>> Only caveat there I think was that we had to decide on a storage format
>> in those memory regions, to allow QEMU to understand the state and to
>> ensure back/forwards compatibility between KVM versions.
>
> Do we need QEMU to actually understand this? Can't we just leave this
> all to the kernel and QEMU just passes on the data? That would still
> require some ABI stability between kernel versions in this respect, but
> it's less problematic than exposing the data format to userland at all.

This would preclude ever being able to migrate a VM from KVM to
TCG QEMU, which seems a shame. (That doesn't work right now, but
I'm a bit wary of shutting the door to it forever.)

thanks
-- PMM
