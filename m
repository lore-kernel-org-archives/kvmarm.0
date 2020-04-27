Return-Path: <SRS0=evlJ=6L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1829BC5519E
	for <kvmarm@archiver.kernel.org>; Mon, 27 Apr 2020 06:18:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 90BF2206B6
	for <kvmarm@archiver.kernel.org>; Mon, 27 Apr 2020 06:18:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZNF4P+U8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90BF2206B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8F6B4B18A;
	Mon, 27 Apr 2020 02:18:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qMKopKw3GmBK; Mon, 27 Apr 2020 02:18:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E28E14B138;
	Mon, 27 Apr 2020 02:18:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE3F64B134
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2020 02:18:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5KnxB-wwPkF9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Apr 2020 02:18:36 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A63DC4B132
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2020 02:18:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1587968316;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=z9GxT9ibmzxXP3rSVkXz4GcBHwjbM4n+aVHQx3+API8=;
 b=ZNF4P+U8jVK5XhD6K7yBCy8ZjtLa0sjUKloKIRBjc7P9DNjN4Kd5TH4r3rd1RpihuTk742
 MoJxn5Okj9FALJ66kl/5bpJT45rLj6RHuFMzOF/g/s1xH/peZ5udSYwMh3lUAlBF71i1zb
 zTYBemCYEFLPGNShEAH7jwbWp8AjSqk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-48T284WyPxiX5ZkcYYpzVw-1; Mon, 27 Apr 2020 02:18:34 -0400
X-MC-Unique: 48T284WyPxiX5ZkcYYpzVw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB157464;
 Mon, 27 Apr 2020 06:18:32 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.184])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FB5A60C80;
 Mon, 27 Apr 2020 06:18:30 +0000 (UTC)
Date: Mon, 27 Apr 2020 08:18:27 +0200
From: Andrew Jones <drjones@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v4 1/2] target/arm: kvm: Handle DABT with no valid ISS
Message-ID: <20200427061827.s3fcyvdu3r3bfijj@kamzik.brq.redhat.com>
References: <20200323113227.3169-1-beata.michalska@linaro.org>
 <20200323113227.3169-2-beata.michalska@linaro.org>
 <CAFEAcA_uWS+cVRk=BKra8AhsD+B1syVzhXeCMttSKwQDdo=j3w@mail.gmail.com>
 <20200417131032.lcyunbjwofsn2nzz@kamzik.brq.redhat.com>
 <20200424121633.GF3106@work-vm>
 <d6f4b17c-1202-3aef-320a-247dc0295277@redhat.com>
MIME-Version: 1.0
In-Reply-To: <d6f4b17c-1202-3aef-320a-247dc0295277@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: quintela@redhat.com, QEMU Developers <qemu-devel@nongnu.org>,
 qemu-arm <qemu-arm@nongnu.org>, kvmarm@lists.cs.columbia.edu,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>
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

On Sat, Apr 25, 2020 at 11:24:14AM +0200, Paolo Bonzini wrote:
> On 24/04/20 14:16, Dr. David Alan Gilbert wrote:
> >>> I was trying to work out whether we need to migrate this state,
> >>> and I'm not sure. Andrew, do you know? I think this comes down
> >>> to "at what points in QEMU's kvm run loop can migration kick in",
> >>> and specifically if we get a KVM_EXIT_ARM_NISV do we definitely
> >>> go round the loop and KVM_RUN again without ever checking
> >>> to see if we should do a migration ?
> >>>
> >> I'd prefer a migration expert confirm this, so I've CC'ed David and Juan,
> >> but afaict there's no way to break out of the KVM_RUN loop after a
> >> successful (ret=0) call to kvm_arch_handle_exit() until after the next
> >> KVM_RUN ioctl. This is because even if migration kicks the vcpus between
> >> kvm_arch_handle_exit() and the next run, the signal won't do anything
> >> other than prepare the vcpu for an immediate exit.
> 
> As far as QEMU is concerned, this should be enough for Beata's patch to
> be safe.  If the signal causes KVM to exit before KVM_EXIT_ARM_NISV,
> it's of course okay.  If you get a KVM_EXIT_ARM_NISV, however, KVM_RUN
> will exit with return code 0 and kvm_cpu_exec will:
> 
> - set env->ext_dabt_pending
> 
> - go round the loop again
> 
> - notice cpu->exit_request and schedule an immediate exit
> 
> - call kvm_arch_put_registers
> 
> - call KVM_RUN again, which will exit with -EINTR
> 
> - exit the loop and allow migration to proceed

This was my understanding as well. Thanks for the confirmation.

> 
> However, I'm not sure that it's a good idea to
> 
> +        /* Clear instantly if the call was successful */
> +        env->ext_dabt_pending = 0;
> 
> Rather, this should be done by the next kvm_arch_get_registers when it
> calls KVM_GET_VCPU_EVENTS.  It's also possible to add an assertion in
> kvm_get_vcpu_events that it you always get zero, to justify that the
> field is not migrated.

I like the idea of a balanced API; keeping the 'set' abort pending
until the next 'get', but this event doesn't work that way.
Documentation/virt/kvm/api.rst states:

  It is not possible to read back a pending external abort (injected via
  KVM_SET_VCPU_EVENTS or otherwise) because such an exception is always
  delivered directly to the virtual CPU).

I think clearing the userspace copy instantly after a successful
KVM_SET_VCPU_EVENTS implements that correctly.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
