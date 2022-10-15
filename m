Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB5F7B
	for <kvmarm@lists.linux.dev>; Sat, 15 Oct 2022 02:41:45 +0000 (UTC)
Received: by mail-ot1-f48.google.com with SMTP id a16-20020a056830101000b006619dba7fd4so2879455otp.12
        for <kvmarm@lists.linux.dev>; Fri, 14 Oct 2022 19:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SIHNOBqgQyxjFMiIYqRn/5bMu0C03QCxB43mLGgsAkE=;
        b=H6yLwoJP1TNfqoVQ7sC13/34xLAcBcXJMYQu3IXPcqh/GBHacqdXAKxzaRuBJL1eT2
         NdDedDmjJMaXyfZFhCNbzRdEMWpgV13tMclsFOBBe8tQC1FdZ1yMdmuKMDldwATIMiIS
         14spzcEhav+VXCwBqg7ftD+dm3V7MZ84KHq4+aC1wFqlctDUUO3iz+R4sO+Vp0vQk+QW
         Kv5aSVG4hbYfXHiCt5oCTSKyQMjFX8pk1op/pfHdqV5NbwiHrU0uLOa50CaqRjY6M/kJ
         EV+SCi65nRcnIu6LK3/9B7SdQ4PZlM25VlhYqisflfZPNs+BW68YX4Tpk5eS40oYS8A9
         TyZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SIHNOBqgQyxjFMiIYqRn/5bMu0C03QCxB43mLGgsAkE=;
        b=povcqqxYJzYKWQHsnoxF1KWkuHdY0PEzovfbO4idGvH37RMFK1Ul6HqF52ZWG7GX4A
         BLrfOZLNDW3osagPLxZzeFJZYbThDToMz66WYl2jo1vbIL6iLkuoqk0PsBwZBFb0BNHY
         uacyCbcDOoCBLVfPw1Hzt0uqRI6sKy0rjEfuSiN3cjxEjplsNqvRSw4LvEcEfvWX/7zh
         GIibv6lnixy7iu2Ldp9ibKAO1672/Zg9ou5Tw0wN4ealWJPd2K4ehxbF4sQ6LWkD13Bh
         HQ6ZYUTtfLTh2ppu8VECeGh2FBgnObgo3Xppf0wWPMjhkuskFtqpNgoFY6AMKsJ52kbr
         MbnQ==
X-Gm-Message-State: ACrzQf1pzm8ThrnOqIunhCARS2evM/c8UFtyDs4WnAWe/dT8/qMPkCsL
	FO/fGYiCyX1hcUNfWG4z9fIH8xbM1UMHcetmqXI=
X-Google-Smtp-Source: AMsMyM6xPjUzqyFR68JWmrNv3ikJwycuentgPMgPtiMFiGJNqjEios6Rrnd5EAtBcuwCRUWAf7a6hy6JwcODLZCCblo=
X-Received: by 2002:a05:6830:148e:b0:661:9422:f0e1 with SMTP id
 s14-20020a056830148e00b006619422f0e1mr413585otq.205.1665801704408; Fri, 14
 Oct 2022 19:41:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <acd9f1643980fbd27cd22523d2d84ca7c9add84a.1665592448.git.renzhengeek@gmail.com>
 <87o7ughoyf.wl-maz@kernel.org> <7f071249-b402-9534-c127-40af9379756d@redhat.com>
 <87mt9yh43x.wl-maz@kernel.org>
In-Reply-To: <87mt9yh43x.wl-maz@kernel.org>
From: Eric Ren <renzhengeek@gmail.com>
Date: Sat, 15 Oct 2022 10:41:44 +0800
Message-ID: <CAKM4Aey4wLA=mRBB-S2i2dcdwXCOFPAwwR7gGjTnti7ZLt9S4g@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: vgic: fix wrong loop condition in scan_its_table()
To: Marc Zyngier <maz@kernel.org>
Cc: Eric Auger <eauger@redhat.com>, kvm@vger.kernel.org, 
	kvmarm <kvmarm@lists.cs.columbia.edu>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <Alexandru.Elisei@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221015024144.buqezYDD4NVCPUqtG60LSVmYM0bD2pK8Ntz9Xe3WgRQ@z>

Hi all,

snip...

> > > You'll have to spell it out for me here. If you have a very sparse
> > > device ID and you are only using a single level device table, you are
> > > bound to have a large len. Now, is the issue that 'size' is so large
> > > that it is negative as an 'int'? Describing the exact situation you're
> > > in would help a lot.
> > >

The problem happens when we have a very sparse device ID and use "2
level" device
tables, ie. GITS_BASERn.Indirect enabled.

For example,
1. L1 table has 2 entries;
2. and we are now scanning at L2 table entry index 2075 (pointed by L1
first entry)
3. if next device id is 9472, we will get a big offset: 7397;
4. with signed 'len', 'len -= offset * esz', len will underflow to a
positive number, mistakenly into next iteration with a bad GPA;
(It should break the current L2 table scanning, and jump into the next
L1 table entry)
5. that bad GPA fails the guest read.

hope this make it clean:-)
> > >>
> > >> Signed-off-by: Eric Ren <renzhengeek@gmail.com>
> > >> ---
> > >>  arch/arm64/kvm/vgic/vgic-its.c | 2 +-
> > >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > >>
> > >> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> > >> index 24d7778d1ce6..673554ef02f9 100644
> > >> --- a/arch/arm64/kvm/vgic/vgic-its.c
> > >> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > >> @@ -2141,7 +2141,7 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
> > >>                      int start_id, entry_fn_t fn, void *opaque)
> > >>  {
> > >>    struct kvm *kvm = its->dev->kvm;
> > >> -  unsigned long len = size;
> > >> +  ssize_t len = size;
> > >
> > > This feels wrong, really. If anything, all these types should be
> > > unsigned, not signed. Signed types in this context make very little
> > > sense...
> >
> > After digging into the code back again, I realized I told you something
> > wrong. The next_offset is the delta between the current device id and
> > the next one. The next device can perfectly be in a different L1 device
>
> A different L2 table, surely? By definition, we only have a single L1
> table.
>
> > table, - it is your case actually- , in which case the code is
> > definitely broken.
> >

Yes. You've got the point, hah.

> > So I guess we should rather have a
> > while (true) {
> >       ../..
> >       if (byte_offset >= len)
> >               break;
> >       len -= byte_offset;
> > }
> >

Thanks. This looks better. I'll send v2.

> > You can add a Fixes tag too:
> > Fixes: 920a7a8fa92a ("KVM: arm64: vgic-its: Add infrastructure for table
> > lookup")
> > and cc stable@vger.kernel.org
>
> Just to make it clear, do you mean this:

Yes, exactly.

>
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 9d3299a70242..e722cafdff60 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -2162,6 +2162,9 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
>                         return next_offset;
>
>                 byte_offset = next_offset * esz;
> +               if (byte_offset >= len)
> +                       break;
> +
>                 id += next_offset;
>                 gpa += byte_offset;
>                 len -= byte_offset;
>
>
> If so, then I agree that this is a sensible fix. EricR, do you mind
> respinning this ASAP so that I can get it merged and backported?

OK, please see V2:-)

Thanks all!
Eric



-- 
- Eric Ren

On Fri, 14 Oct 2022 at 22:28, Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 13 Oct 2022 17:42:31 +0100,
> Eric Auger <eauger@redhat.com> wrote:
> >
> > Hi Eric,
> >
> > On 10/12/22 20:33, Marc Zyngier wrote:
> > > Hi Eric,
> > >
> > > Before I comment on this patch, a couple of things that need
> > > addressing:
> > >
> > >> "Cc: marc.zyngier@arm.com, cdall@linaro.org"
> > >
> > > None of these two addresses are valid anymore, and haven't been for
> > > several years.
> > >
> > > Please consult the MAINTAINERS file for up-to-date addresses for
> > > current maintainers and reviewers, all of whom should be Cc'd on this
> > > email. I've now added them as well as Eric Auger who has written most
> > > of the ITS migration code, and the new mailing list (the Columbia list
> > > is about to be killed).
>
> Duh, I never CC'd the new list... Now hopefully done.
>
> > >
> > > On Wed, 12 Oct 2022 17:59:25 +0100,
> > > Eric Ren <renzhengeek@gmail.com> wrote:
> > >>
> > >> Reproducer hints:
> > >> 1. Create ARM virt VM with pxb-pcie bus which adds
> > >>    extra host bridges, with qemu command like:
> > >>
> > >> ```
> > >>   -device pxb-pcie,bus_nr=8,id=pci.x,numa_node=0,bus=pcie.0 \
> > >>   -device pcie-root-port,..,bus=pci.x \
> > >>   ...
> > >>   -device pxb-pcie,bus_nr=37,id=pci.y,numa_node=1,bus=pcie.0 \
> > >>   -device pcie-root-port,..,bus=pci.y \
> > >>   ...
> > >>
> > >> ```
> > >> 2. Perform VM migration which calls save/restore device tables.
> > >>
> > >> In that setup, we get a big "offset" between 2 device_ids (
> > >> one is small, another is big), which makes unsigned "len" round
> > >> up a big positive number, causing loop to continue exceptionally.
> > >
> > > You'll have to spell it out for me here. If you have a very sparse
> > > device ID and you are only using a single level device table, you are
> > > bound to have a large len. Now, is the issue that 'size' is so large
> > > that it is negative as an 'int'? Describing the exact situation you're
> > > in would help a lot.
> > >
> > >>
> > >> Signed-off-by: Eric Ren <renzhengeek@gmail.com>
> > >> ---
> > >>  arch/arm64/kvm/vgic/vgic-its.c | 2 +-
> > >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > >>
> > >> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> > >> index 24d7778d1ce6..673554ef02f9 100644
> > >> --- a/arch/arm64/kvm/vgic/vgic-its.c
> > >> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > >> @@ -2141,7 +2141,7 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
> > >>                      int start_id, entry_fn_t fn, void *opaque)
> > >>  {
> > >>    struct kvm *kvm = its->dev->kvm;
> > >> -  unsigned long len = size;
> > >> +  ssize_t len = size;
> > >
> > > This feels wrong, really. If anything, all these types should be
> > > unsigned, not signed. Signed types in this context make very little
> > > sense...
> >
> > After digging into the code back again, I realized I told you something
> > wrong. The next_offset is the delta between the current device id and
> > the next one. The next device can perfectly be in a different L1 device
>
> A different L2 table, surely? By definition, we only have a single L1
> table.
>
> > table, - it is your case actually- , in which case the code is
> > definitely broken.
> >
> > So I guess we should rather have a
> > while (true) {
> >       ../..
> >       if (byte_offset >= len)
> >               break;
> >       len -= byte_offset;
> > }
> >
> > You can add a Fixes tag too:
> > Fixes: 920a7a8fa92a ("KVM: arm64: vgic-its: Add infrastructure for table
> > lookup")
> > and cc stable@vger.kernel.org
>
> Just to make it clear, do you mean this:
>
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 9d3299a70242..e722cafdff60 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -2162,6 +2162,9 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
>                         return next_offset;
>
>                 byte_offset = next_offset * esz;
> +               if (byte_offset >= len)
> +                       break;
> +
>                 id += next_offset;
>                 gpa += byte_offset;
>                 len -= byte_offset;
>
>
> If so, then I agree that this is a sensible fix. EricR, do you mind
> respinning this ASAP so that I can get it merged and backported?
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.



-- 
- Eric Ren
