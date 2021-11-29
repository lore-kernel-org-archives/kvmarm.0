Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A60B1C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 13:01:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2344D4B1D4;
	Mon, 29 Nov 2021 08:01:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dm+QxqiML-5Z; Mon, 29 Nov 2021 08:01:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE40D4B25E;
	Mon, 29 Nov 2021 08:01:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1148F4B1D4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 08:01:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j25yk051XLK5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 08:01:07 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8F874B25A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 08:01:07 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1638190867;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=h1Stf5Vws0n2EejeKlEUNVuIDUq0vyjO3qRdJV6eojQ=;
 b=Dv07UTXZ6/bxv23Gcm0vfSE3FoK8/3oH9U6X5D+LIOKbOFu9COtnXYjp8YqDqnxlZyNEWZ
 tKJdxX9bct37On8S/z6PxqYnwYxxl06wH0+DjBriVgpuaGAtOBuZ2S3EAJ/QdEIAo7lRdn
 o4lPF3QXcqjdGlH+NNUNU6dv2XdYXFw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505-TKVpxDgSO3yVSpiVcRtqBQ-1; Mon, 29 Nov 2021 08:01:04 -0500
X-MC-Unique: TKVpxDgSO3yVSpiVcRtqBQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D67F1006AA2;
 Mon, 29 Nov 2021 13:01:02 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 56EC95C22B;
 Mon, 29 Nov 2021 13:01:01 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
 id 1E87241752B6; Mon, 29 Nov 2021 09:47:05 -0300 (-03)
Date: Mon, 29 Nov 2021 09:47:05 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Subject: Re: [RFC PATCH 2/2] KVM: arm64: export cntvoff in debugfs
Message-ID: <20211129124705.GB131894@fuller.cnet>
References: <20211119102117.22304-1-nsaenzju@redhat.com>
 <20211119102117.22304-3-nsaenzju@redhat.com>
 <87fsrs732b.wl-maz@kernel.org>
 <0e948a211bd8d63ba05594fb8c03bf3a77a227a0.camel@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0e948a211bd8d63ba05594fb8c03bf3a77a227a0.camel@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: will@kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, rostedt@goodmis.org, mingo@redhat.com,
 catalin.marinas@arm.com, nilal@redhat.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Nov 22, 2021 at 09:40:52PM +0100, Nicolas Saenz Julienne wrote:
> Hi Marc, thanks for the review.
> =

> On Fri, 2021-11-19 at 12:17 +0000, Marc Zyngier wrote:
> > On Fri, 19 Nov 2021 10:21:18 +0000,
> > Nicolas Saenz Julienne <nsaenzju@redhat.com> wrote:
> > > =

> > > While using cntvct as the raw clock for tracing, it's possible to
> > > synchronize host/guest traces just by knowing the virtual offset appl=
ied
> > > to the guest's virtual counter.
> > > =

> > > This is also the case on x86 when TSC is available. The offset is
> > > exposed in debugfs as 'tsc-offset' on a per vcpu basis. So let's
> > > implement the same for arm64.
> > =

> > How does this work with NV, where the guest hypervisor is in control
> > of the virtual offset? =

> =

> TBH I handn't thought about NV. Looking at it from that angle, I now see =
my
> approach doesn't work on hosts that use CNTVCT (regardless of NV). Upon
> entering into a guest, we change CNTVOFF before the host is done with tra=
cing,
> so traces like 'kvm_entry' will have weird timestamps. I was just lucky t=
hat
> the hosts I was testing with use CNTPCT.
> =

> I believe the solution would be to be able to force a 0 offset between
> guest/host. With that in mind, is there a reason why kvm_timer_vcpu_init()
> imposes a non-zero one by default? I checked out the commits that introdu=
ced
> that code, but couldn't find a compelling reason. VMMs can always change =
it
> through KVM_REG_ARM_TIMER_CNT afterwards.

One reason is that you leak information from host to guest (the hosts
TSC value).

Another reason would be that you introduce a configuration which is =

different from the what the hardware has, which can in theory trigger
guest bugs.

> > I also wonder why we need this when userspace already has direct access=
 to
> > that information without any extra kernel support (read the CNTVCT view=
 of
> > the vcpu using the ONEREG API, subtract it from the host view of the co=
unter,
> > job done).
> =

> Well IIUC, you're at the mercy of how long it takes to return from the ON=
EREG
> ioctl. The results will be skewed. For some workloads, where low latency =
is
> key, we really need high precision traces in the order of single digit us=
 or
> even 100s of ns. I'm not sure you'll be able to get there with that appro=
ach.

If the guest can read the host to guest HW clock offset already, it
could directly do the conversion.

> [...]
> =

> > > diff --git a/arch/arm64/kvm/debugfs.c b/arch/arm64/kvm/debugfs.c
> > > new file mode 100644
> > > index 000000000000..f0f5083ea8d4
> > > --- /dev/null
> > > +++ b/arch/arm64/kvm/debugfs.c
> > > @@ -0,0 +1,25 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/*
> > > + * Copyright (C) 2021 Red Hat Inc.
> > > + */
> > > +
> > > +#include <linux/kvm_host.h>
> > > +#include <linux/debugfs.h>
> > > +
> > > +#include <kvm/arm_arch_timer.h>
> > > +
> > > +static int vcpu_get_cntv_offset(void *data, u64 *val)
> > > +{
> > > +	struct kvm_vcpu *vcpu =3D (struct kvm_vcpu *)data;
> > > +
> > > +	*val =3D timer_get_offset(vcpu_vtimer(vcpu));
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +DEFINE_SIMPLE_ATTRIBUTE(vcpu_cntvoff_fops, vcpu_get_cntv_offset, NUL=
L, "%lld\n");
> > > +
> > > +void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dent=
ry *debugfs_dentry)
> > > +{
> > > +	debugfs_create_file("cntvoff", 0444, debugfs_dentry, vcpu, &vcpu_cn=
tvoff_fops);
> > > +}
> > =

> > This should be left in arch_timer.c until we actually need it for
> > multiple subsystems. When (and if) that happens, we will expose
> > per-subsystem debugfs initialisers instead of exposing the guts of the
> > timer code.
> =

> Noted.
> =

> -- =

> Nicol=E1s S=E1enz
> =

> =


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
