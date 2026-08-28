Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D915355814
	for <kvmarm@lists.linux.dev>; Fri, 28 Aug 2026 19:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787944542; cv=pass; b=eAVPwWO7xvzVPorpSIP0+z3tKBUWpn1SXEKVwAA1j8Ve8sMxiHqqYhCrsclxmiCoZSTCYfTJQvtPhqGTj20u93eJgsnO0oTtPn/YX1ne3tdOh78pZVWQKIAnTIGx7NkO4aLVDWQnw3TI1WtDkM3SZKA9RxfAwQAJw/35ZwuOWeA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787944542; c=relaxed/simple;
	bh=N1Nbw3ovgXhbS9LBKa33iZ8SPB+0x1h20hpoEb1DbDE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SkSiJblojfnmdxY+LvS7n1oS0F6HDr2OJY+bkZIJISqvNHJEdle7JjjS20Z7/nxqKA1e+t1U0AQ9l2kJVuq5FnmExzsQtbr7uuvaNsAU15cs6RPub58omnIgUrfujiqUQLzOgwfy6/s4F62lOcX2eVz+viAWhM4vSFP9+EIT4hQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gs7yAOPV; arc=pass smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gs7yAOPV"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cc1d57602e8so1207837a12.3
        for <kvmarm@lists.linux.dev>; Fri, 28 Aug 2026 12:15:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787944540; cv=none;
        d=google.com; s=arc-20260327;
        b=Q7JYoN2sTVFMH5dJIl10qhPFmVWF8xjwzAQUMNXZwdTtPTHpwb7pNynyCwcVay4hwe
         WczyCXbha2oTEhHIMiUwnQMoADr6S0jtCSedUSB1PzqgHQLaB66ey1NHw8upYTP8NUuw
         KYWpEBbAgHHT6w3XUVCbzFWzi0te9tFC0nvIdj4ZEhmVcEbgdrGuIdEaMQeEPnFyyZjl
         WPdFly6xs0/tzsETbyvNgPt3sfl4JGZXCnK4YH20po2SJasis2s9Wt/U/TOFIYFPMEl3
         SmOKR1bU3aLwEbh9FuNYQ4pKETyZb2FFAGANoqaXtsZaWUgs+8u+5SJyJMZfCxn1ew13
         EzhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kiyvKBshQ+wfh6yua+SMCW+QrMRbGzyCCyz1Zxa7SSM=;
        fh=IE95IvibIFF0X4XH6X7C3EYi3wBd+5bLKsSX6OCGElI=;
        b=j76pj6WDqUGitgPz5+jXHOsC2+tBKSB0Oqv/gShOWf7LFvzCO1Cajmn/0MziNDBKQQ
         HG8Y+tHUqjEKfXU8DmgespXXO6KR6ze44Vq/FT0ctAuWcO49qYzsXrEmvsqO/p52JzcC
         aMts6MoCZBHmz1jv/u7MyG9gcZHQ/ertJJDvlyTBrDbXsn7yorX2I5l1xXss+p1ZBieB
         32pDGSdfwE2ujAzPIrwNsJYvPvHV+CML10+YAdaYxQAjpEFFcHQ0N3CTA/8l9DYssR1I
         ucP6+cHYKIApO1rkrnLqDfjK4ITKV63rcXtMNy9e1ATn4ITI8fW4f3KNheOed3U7SOuV
         J4oA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787944540; x=1788549340; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kiyvKBshQ+wfh6yua+SMCW+QrMRbGzyCCyz1Zxa7SSM=;
        b=Gs7yAOPVH/sDTseZvCKaXInQFK4ORUEHscuk9RCLhN6j6n1b0/OEOe8ZMu4vfcaXQz
         hgHV2ueXjFu7u7fey2tgZ2jvFZJHuCKM3m2pI5a7pPlHJ01wWcZCpmx1GF78EH5UxREP
         9BB9jFlDN+M0dgZnXGP8SNor4N1RZ7zv2+U11brIZy6oG1YxF78dpXWZ19ZTOLIbB9js
         lpFGXscUazgZww7wTtPIiGfO9v6BvbeylVR9D1m8FP7XwA8fVF6D2KFej/EvCpwxpfai
         O7GMaYvnq1eDZ9JXsPymfmeU2uxAXJNS2NYMq12DE5us8FRS4WmYpomHaMZ3PIZQdVT1
         hzKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787944540; x=1788549340;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kiyvKBshQ+wfh6yua+SMCW+QrMRbGzyCCyz1Zxa7SSM=;
        b=ryGe71H36okd8vwrWqx3ylB9CMmvQJcg4bdodTt5BBedmhv4mVI0Y++eaNfdrBqkal
         cl06p3BaNfoJ2lbOhON6DBwy5g3TrhcoMv6LaXLmaoRENykVhVoWFEcXiDewgnRlbQ4A
         KJAbkhdqd7T9Ic84HfNNPEUFY1gdxx6tkt6bJZ3eYEA3R0E7Mh6ix9m1bSfKopTgaOYp
         pzlnb22uoxAaG5P+U/qsx/s1897wmLjcskEaHsaAZgqt1Y2e4U96zYkWMQSnEbG8yleO
         PRwiFY+g1csLt52YVoSCNwktg1WPtClQNF7rzu4eJ/HROJnvgSTOARkYpJZ4A3VwD77W
         X55g==
X-Forwarded-Encrypted: i=1; AHgh+RpNutLG/L3KLhQAABRsvLxRSae/HDVtN21hvpgN9c0dqw/rZIzfmVoCQzRK+UUL8zw5yWrz7Cc=@lists.linux.dev
X-Gm-Message-State: AFuF++k/kYjJsD3L+kVB17bLUtLzLu3sDe24Gblj+diDsiqIibSFyp4P
	Yhwo/Fz2lSATldTMrT2X2SNynM7MVtTviVhVma6DevdccpRUdDIXtXNw+hVt3kdZIH5VNhs8Cun
	7ZiAV20jId8E4n+ggcE6It54vW2YXy5W+3vPBWqqK
X-Gm-Gg: AR+sD10UF9h6cD2j8KAHWx/WNlmZEBQ5zu3MFfBtvay1amoPJ/wXIsEt0Ko5VUVshWJ
	bCy+K3EtTBTm+SFfqWPApVqPUQntYLsYC8JTPxXs8GK7ZfVi2i16UEa2EQeD/hXEo+iXVTDFjkh
	3dq2NTCaxK0wBZ43CIDT85zMNWGL+QecIiGgNt5hoDdWT3TYwNu91bs9fb5874aNKzUrbI1pddb
	QUxFddo3fgqJ+PdhiASH4vI/kyHTG6wMt4gRvI+nmx4GBe01diV/NEVcU3wrsyCIEKzAulsbw9L
	Llxm8lEsyRmK6pLStlJaPkVnT/BclDBxE6CPA9FsJaBcQuuVtSQeU9Mx//n0495T311jWyqOh+U
	=
X-Received: by 2002:a05:6a21:350f:b0:3d3:ae40:51e5 with SMTP id
 adf61e73a8af0-3d3ae405659mr3293243637.25.1787944539838; Fri, 28 Aug 2026
 12:15:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260818223422.367803-1-jingzhangos@google.com> <87v795ndhz.wl-maz@kernel.org>
In-Reply-To: <87v795ndhz.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Fri, 28 Aug 2026 12:15:26 -0700
X-Gm-Features: AcwNN1WrfuoxnPgMF7CmkqwFRNbRW29he8BaRItvN8ezR7fcwwGLFqlhRr6GqCg
Message-ID: <CAAdAUtiEKMW-Qx+afpFtQrVWgW3+Av0A0JVh+vSYqUg_q+ER1w@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: vgic-its: Fix O(C*I) loop in vgic_its_free_collection_list
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Steffen Eiden <seiden@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Faud,

Could you please include this patch in your series? I'll be out of
office until the end of September.

Thanks,
Jing

On Thu, Aug 20, 2026 at 6:08=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> [+Fuad, Steffen]
>
> Jing,
>
> Please make sure you add all the relevant reviewers in the Cc: list,
> specially as Fuad is doing a lot of work in that particular area.
>
> On Tue, 18 Aug 2026 23:34:22 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > When destroying the vgic-its collection list,
> > vgic_its_free_collection_list() iterates over every collection and for
> > each, calls vgic_its_free_collection(). This function walks every
> > Interrupt Translation Entry (ITE) across all devices via
> > for_each_lpi_its() to nullify the collection pointer.
> >
> > A guest can allocate up to 65536 collections and hundreds of thousands
> > of ITEs. By clearing GITS_CTLR.Enable and writing Valid=3D0 to
> > GITS_BASER1, the guest can trigger this teardown path from a single MMI=
O
> > exit. The resulting O(Collections * ITEs) nested loop executes billions
> > of iterations without a single cond_resched(). This pins a physical CPU
> > and stalls RCU grace periods for seconds or minutes on PREEMPT_NONE
> > kernels.
> >
> > Fix this by replacing the O(Collections * ITEs) teardown with an
> > O(Collections + ITEs) pass. Since the entire collection list is being
> > freed, we can safely bulk-clear the collection pointers from all ITEs i=
n
> > a single pass, and then free all the collections in a second pass.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-its.c | 16 ++++++++++++++--
> >  1 file changed, 14 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-=
its.c
> > index 36ab3e4929154..a8e819fe97898 100644
> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > @@ -1133,9 +1133,21 @@ static void vgic_its_free_device_list(struct kvm=
 *kvm, struct vgic_its *its)
> >  static void vgic_its_free_collection_list(struct kvm *kvm, struct vgic=
_its *its)
> >  {
> >       struct its_collection *cur, *temp;
> > +     struct its_device *device;
> > +     struct its_ite *ite;
> >
> > -     list_for_each_entry_safe(cur, temp, &its->collection_list, coll_l=
ist)
> > -             vgic_its_free_collection(its, cur->collection_id);
> > +     /*
> > +      * Bulk-clear the collection pointers for all ITEs.
> > +      * This transforms the teardown complexity from O(Collections * I=
TEs)
> > +      * to O(Collections + ITEs), avoiding guest-triggered host RCU st=
alls.
> > +      */
>
> I don't think this comment needs to describe this. You already have
> described it *extremely thoroughly* in the commit message, and that's
> probably enough. I'd rather see a justification of why this is *safe*.
>
> > +     for_each_lpi_its(device, ite, its)
> > +             ite->collection =3D NULL;
> > +
> > +     list_for_each_entry_safe(cur, temp, &its->collection_list, coll_l=
ist) {
> > +             list_del(&cur->coll_list);
> > +             kfree(cur);
> > +     }
>
> The other thing that is missing is the invalidation of the translation
> cache. Please see the discussion at [1], and whether this needs to be
> taken care of here or in Fuad's series.
>
> Thanks,
>
>         M.
>
> [1] https://lore.kernel.org/r/20260819102809.310708-2-fuad.tabba@linux.de=
v
>
> --
> Jazz isn't dead. It just smells funny.
