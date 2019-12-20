Return-Path: <SRS0=zNRV=2K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95990C43603
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 16:03:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1F0E72465E
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 16:03:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eF++EM3P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F0E72465E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 969ED4A4A9;
	Fri, 20 Dec 2019 11:03:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JOmNqh0irCt7; Fri, 20 Dec 2019 11:03:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BB8D4A5A3;
	Fri, 20 Dec 2019 11:03:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88E864A576
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 11:03:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bc+Pj89WOeFA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Dec 2019 11:02:59 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E6ED4A4A9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 11:02:59 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1576857779;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Limel4VO1ZO8KIpqt7RZ5ENsq2TZL0E/VYpHsSOkzgY=;
 b=eF++EM3PKBb+GS+33uHkDobPJsw/nO5fOLSXQJbwJOd+sARaj0CYHbvN5AoXDWbDDsAtWX
 /JvkrcM8KtHXDX8RwZAxtNKhlmWdr7gbOainPe1nLuelkoRZKyAycuoc6FYwXdVVMYDAfm
 klRc9ja6g8Ul+IRTes21pB5sWTPs2ws=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-b1Oxt-77Nh-zF7_6vmGaow-1; Fri, 20 Dec 2019 11:02:57 -0500
X-MC-Unique: b1Oxt-77Nh-zF7_6vmGaow-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92EE2107ACCC;
 Fri, 20 Dec 2019 16:02:54 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
 by smtp.corp.redhat.com (Postfix) with ESMTP id AC82560BF3;
 Fri, 20 Dec 2019 16:02:48 +0000 (UTC)
Date: Fri, 20 Dec 2019 17:02:46 +0100
From: Cornelia Huck <cohuck@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 35/45] KVM: s390: Manually invoke vcpu setup during
 kvm_arch_vcpu_create()
Message-ID: <20191220170246.76ba681a.cohuck@redhat.com>
In-Reply-To: <20191220155607.GB20453@linux.intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-36-sean.j.christopherson@intel.com>
 <20191220110445.3a42041a.cohuck@redhat.com>
 <20191220155607.GB20453@linux.intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: Wanpeng Li <wanpengli@tencent.com>, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, David Hildenbrand <david@redhat.com>,
 linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Greg Kurz <groug@kaod.org>,
 linux-arm-kernel@lists.infradead.org, James Hogan <jhogan@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

On Fri, 20 Dec 2019 07:56:07 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> On Fri, Dec 20, 2019 at 11:04:45AM +0100, Cornelia Huck wrote:
> > On Wed, 18 Dec 2019 13:55:20 -0800
> > Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> >   
> > > Rename kvm_arch_vcpu_setup() to kvm_s390_vcpu_setup() and manually call
> > > the new function during kvm_arch_vcpu_create().  Define an empty
> > > kvm_arch_vcpu_setup() as it's still required for compilation.  This
> > > is effectively a nop as kvm_arch_vcpu_create() and kvm_arch_vcpu_setup()
> > > are called back-to-back by common KVM code.  Obsoleting
> > > kvm_arch_vcpu_setup() paves the way for its removal.
> > > 
> > > Note, gmap_remove() is now called if setup fails, as s390 was previously
> > > freeing it via kvm_arch_vcpu_destroy(), which is called by common KVM
> > > code if kvm_arch_vcpu_setup() fails.  
> > 
> > Yes, this looks like the only thing that needs to be undone
> > (sca_add_vcpu() is done later in the process.)
> > 
> > Maybe mention that gmap_remove() is for ucontrol only? I was confused
> > for a moment :)  
> 
> Will do.
> 
> Would it also make sense to open code __kvm_ucontrol_vcpu_init() in a
> separate patch immediately preceding this change?  That'd make it a little
> more obvious why gmap_remove() is called, and it would eliminate the
> "uninit" verbiage in the label, e.g.:

I'm a bit undecided here; especially as I'm not sure if there are any
future plans with ucontrol. I'll leave that for Christian and Janosch
to decide.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
