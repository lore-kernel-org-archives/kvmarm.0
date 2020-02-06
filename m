Return-Path: <SRS0=Is6r=32=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C593C35247
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 21:41:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C5C8B217BA
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 21:41:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vjE/8XjL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5C8B217BA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A3C54A591;
	Thu,  6 Feb 2020 16:41:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dyv35l3gwYtm; Thu,  6 Feb 2020 16:41:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CD384A3A3;
	Thu,  6 Feb 2020 16:41:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF1594A3A3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 16:41:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GSm7sDJgANFh for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Feb 2020 16:41:21 -0500 (EST)
Received: from mail-io1-f66.google.com (mail-io1-f66.google.com
 [209.85.166.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C2A84A389
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 16:41:21 -0500 (EST)
Received: by mail-io1-f66.google.com with SMTP id h8so7966839iob.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Feb 2020 13:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=kvVxq0r49Mqq4asBVI4NCDYI19hcfdO7wI2SNt5QJ9A=;
 b=vjE/8XjLWPicwX3CFGOsQ5nQfZDB9lS8l3stAVjyHSX8MRXbbJI/amrcU3tHU4Ncps
 cl45EDIGEtj2/UFLWMZCUhFXtjepvTsqql0gZ5VjYzm1iclCwBeb6UxtlkD5taX4JsAQ
 BmVIZOvjZs8kY+WubZYYJJ3c9DPHocNPaHwlV7o4J3uoBPDC+nHPgzdIC7f+0y0Db74l
 HnNWsNIIJjBB92rBK3mZtnlVYxpFAQ9b5SCkFEhfq9vXcclk1MIsqKKZPnvyRUHaEK1v
 GFuk4WluePJbRl4cqniAephhkFK5Cgn3woOhCxnZoSZbQV6Jebx6jVaRVFGH1U0TYGP4
 wZMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=kvVxq0r49Mqq4asBVI4NCDYI19hcfdO7wI2SNt5QJ9A=;
 b=dGJFjaODfR7lDIE4ghPRmxhC8JVTyp+/jwSQW3TesPvcj2Re7YxzoXhpVwU9FshEyd
 Et8h7uWUZNl5MG6RcC1kP3o8g+Kfc/5tokKKuMs3lqXZJx9J3/a1vcPSQVqwcDbU5QSP
 rHuaEgjYQtQ7cC0yHQB31ER1SVq20CFndINaOP94hevIi424kV4BfzbVxi4z1VDV+GmD
 3ihnbve+SQBet5c/Dq+WIqe+kIKFOmP8mAQVXkHRVHftQiWFwLw7J3SKTBIO4zjeoO50
 oCqeH4piQ1fHw026VJMEplUvZnWJJX5BCYesNGLSWh/FGR40Ka2ZJhRhwNpBctP+Y8Rz
 3sdA==
X-Gm-Message-State: APjAAAV8+yMB+pKZiIANEbxZS3LUCUFfJFv9KrwRCvD375XT5oHd8PVz
 cuCT2rzjNbuaosy0WCgmT98cjF7ArE5l0JP71bTyxoQwVQs=
X-Google-Smtp-Source: APXvYqyQCDWRRpkhqSVdBthGBigb1aUxsXt/uKE8cjGefkWSNZ4y57QZWPFq81DWzm7nnWwQEmDdLQcVncVKiCGHbaI=
X-Received: by 2002:a5d:9255:: with SMTP id e21mr280183iol.260.1581025280987; 
 Thu, 06 Feb 2020 13:41:20 -0800 (PST)
MIME-Version: 1.0
References: <20200129202441.12745-1-beata.michalska@linaro.org>
 <20200129202441.12745-2-beata.michalska@linaro.org>
 <20200204103447.naw26xl2y2zbyrqb@kamzik.brq.redhat.com>
In-Reply-To: <20200204103447.naw26xl2y2zbyrqb@kamzik.brq.redhat.com>
From: Beata Michalska <beata.michalska@linaro.org>
Date: Thu, 6 Feb 2020 21:41:10 +0000
Message-ID: <CADSWDzuQvZThaoFbeYM2QrDbwRPrZuiyDrVJV=jxiSMTW9O-rg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] target/arm: kvm: Inject events at the last stage
 of sync
To: Andrew Jones <drjones@redhat.com>
Cc: QEMU Developers <qemu-devel@nongnu.org>, qemu-arm <qemu-arm@nongnu.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, 4 Feb 2020 at 10:34, Andrew Jones <drjones@redhat.com> wrote:
>
> On Wed, Jan 29, 2020 at 08:24:40PM +0000, Beata Michalska wrote:
> > KVM_SET_VCPU_EVENTS might actually lead to vcpu registers being modified.
> > As such this should be the last step of sync to avoid potential overwriting
> > of whatever changes KVM might have done.
> >
> > Signed-off-by: Beata Michalska <beata.michalska@linaro.org>
> > ---
> >  target/arm/kvm32.c | 20 ++++++++++----------
> >  target/arm/kvm64.c | 20 ++++++++++----------
> >  2 files changed, 20 insertions(+), 20 deletions(-)
> >
> > diff --git a/target/arm/kvm32.c b/target/arm/kvm32.c
> > index 32bf8d6..cf2b47f 100644
> > --- a/target/arm/kvm32.c
> > +++ b/target/arm/kvm32.c
> > @@ -386,17 +386,17 @@ int kvm_arch_put_registers(CPUState *cs, int level)
> >          return ret;
> >      }
> >
> > -    ret = kvm_put_vcpu_events(cpu);
> > -    if (ret) {
> > -        return ret;
> > -    }
> > -
> >      write_cpustate_to_list(cpu, true);
> >
> >      if (!write_list_to_kvmstate(cpu, level)) {
> >          return EINVAL;
> >      }
> >
> > +    ret = kvm_put_vcpu_events(cpu);
> > +    if (ret) {
> > +        return ret;
> > +    }
> > +
>
> I think we should put a comment above this that says basically the same
> thing as the commit message in order to explain why kvm_put_vcpu_events()
> *must* be after write_list_to_kvmstate().
>
Will do that.

> >      kvm_arm_sync_mpstate_to_kvm(cpu);
> >
> >      return ret;
> > @@ -462,11 +462,6 @@ int kvm_arch_get_registers(CPUState *cs)
> >      }
> >      vfp_set_fpscr(env, fpscr);
> >
> > -    ret = kvm_get_vcpu_events(cpu);
> > -    if (ret) {
> > -        return ret;
> > -    }
> > -
> >      if (!write_kvmstate_to_list(cpu)) {
> >          return EINVAL;
> >      }
> > @@ -475,6 +470,11 @@ int kvm_arch_get_registers(CPUState *cs)
> >       */
> >      write_list_to_cpustate(cpu);
> >
> > +    ret = kvm_get_vcpu_events(cpu);
> > +    if (ret) {
> > +        return ret;
> > +    }
> > +
>
> Why are we moving kvm_get_vcpu_events()?

This is only to make things consistent with put_registeres.
There is no functional change per se.

BR

Beata

> >      kvm_arm_sync_mpstate_to_qemu(cpu);
> >
> >      return 0;
> > diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> > index 6344113..d06fd32 100644
> > --- a/target/arm/kvm64.c
> > +++ b/target/arm/kvm64.c
> > @@ -1043,17 +1043,17 @@ int kvm_arch_put_registers(CPUState *cs, int level)
> >          return ret;
> >      }
> >
> > -    ret = kvm_put_vcpu_events(cpu);
> > -    if (ret) {
> > -        return ret;
> > -    }
> > -
> >      write_cpustate_to_list(cpu, true);
> >
> >      if (!write_list_to_kvmstate(cpu, level)) {
> >          return -EINVAL;
> >      }
> >
> > +    ret = kvm_put_vcpu_events(cpu);
> > +    if (ret) {
> > +        return ret;
> > +    }
> > +
> >      kvm_arm_sync_mpstate_to_kvm(cpu);
> >
> >      return ret;
> > @@ -1251,11 +1251,6 @@ int kvm_arch_get_registers(CPUState *cs)
> >      }
> >      vfp_set_fpcr(env, fpr);
> >
> > -    ret = kvm_get_vcpu_events(cpu);
> > -    if (ret) {
> > -        return ret;
> > -    }
> > -
> >      if (!write_kvmstate_to_list(cpu)) {
> >          return -EINVAL;
> >      }
> > @@ -1264,6 +1259,11 @@ int kvm_arch_get_registers(CPUState *cs)
> >       */
> >      write_list_to_cpustate(cpu);
> >
> > +    ret = kvm_get_vcpu_events(cpu);
> > +    if (ret) {
> > +        return ret;
> > +    }
> > +
> >      kvm_arm_sync_mpstate_to_qemu(cpu);
> >
> >      /* TODO: other registers */
> > --
> > 2.7.4
> >
> >
>
> Same comments for kvm64.c as for kvm32.c
>
> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
