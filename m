Return-Path: <SRS0=ijLG=C2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C929C433E2
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 10:54:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8A228208DB
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 10:54:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J58JYOk4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A228208DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C08774B1CA;
	Thu, 17 Sep 2020 06:53:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id svjs9k-j0I2M; Thu, 17 Sep 2020 06:53:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01D134B1ED;
	Thu, 17 Sep 2020 06:53:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53F184B1CC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 06:53:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SafaSB-rAZiE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Sep 2020 06:53:54 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2F544B1CA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 06:53:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1600340034;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=S8C7t3NQHq9z3BC6UetbrQdCqNK9g2Cj1ZoGxibjTb0=;
 b=J58JYOk4F2qwNH6eFjJKGVi3S00wvUdQoc2UssRKY1k44qVRI5zN7kVruKMWkSGq3lvzey
 lBwvIfZtUFK9T7fsAD7lCokRowj3CWVMpu51p2eZoStVDteNdr9i47HHFeEhkPsI89bf+n
 KtxqwRJLdwHGzP2FXEu8THBP50d6F9E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-iHKfzHgYMma8RN14nP1alA-1; Thu, 17 Sep 2020 06:53:50 -0400
X-MC-Unique: iHKfzHgYMma8RN14nP1alA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFC4518BE168;
 Thu, 17 Sep 2020 10:53:48 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.179])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DBD5F1002D62;
 Thu, 17 Sep 2020 10:53:45 +0000 (UTC)
Date: Thu, 17 Sep 2020 12:53:43 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/2] kvm/arm: Add mp_affinity for arm vcpu
Message-ID: <20200917105343.de6z7ajccnx3zrld@kamzik.brq.redhat.com>
References: <20200917023033.1337-1-fangying1@huawei.com>
 <20200917023033.1337-3-fangying1@huawei.com>
 <7a924b0fb27505a0d8b00389fe2f02df@kernel.org>
 <20200917080429.jimidzdtdskwhbdx@kamzik.brq.redhat.com>
 <198c63d5e9e17ddb4c3848845891301c@kernel.org>
 <12a47a99-9857-b86d-6c45-39fdee08613e@arm.com>
 <b88c7988a00c25a9ae0fdd373ba45227@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b88c7988a00c25a9ae0fdd373ba45227@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: zhang.zhanghailiang@huawei.com, kvm@vger.kernel.org, alex.chen@huawei.com,
 Ying Fang <fangying1@huawei.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 17, 2020 at 11:01:39AM +0100, Marc Zyngier wrote:
> On 2020-09-17 10:47, Alexandru Elisei wrote:
> > Hi,
> > =

> > On 9/17/20 9:42 AM, Marc Zyngier wrote:
> > > On 2020-09-17 09:04, Andrew Jones wrote:
> > > > On Thu, Sep 17, 2020 at 08:47:42AM +0100, Marc Zyngier wrote:
> > > > > On 2020-09-17 03:30, Ying Fang wrote:
> > > > > > Allow userspace to set MPIDR using vcpu ioctl KVM_ARM_SET_MP_AF=
FINITY,
> > > > > > so that we can support cpu topology for arm.
> > > > > =

> > > > > MPIDR has *nothing* to do with CPU topology in the ARM architectu=
re.
> > > > > I encourage you to have a look at the ARM ARM and find out how of=
ten
> > > > > the word "topology" is used in conjunction with the
> > > > > MPIDR_EL1 register.
> > > > > =

> > > > =

> > > > Hi Marc,
> > > > =

> > > > I mostly agree. However, the CPU topology descriptions use MPIDR to
> > > > identify PEs. If userspace wants to build topology descriptions then
> > > > it either needs to
> > > > =

> > > > 1) build them after instantiating all KVM VCPUs in order to query K=
VM
> > > > =A0=A0 for each MPIDR, or
> > > > 2) have a way to ask KVM for an MPIDR of given VCPU ID in advance
> > > > =A0=A0 (maybe just a scratch VCPU), or
> > > > 3) have control over the MPIDRs so it can choose them when it likes,
> > > > =A0=A0 use them for topology descriptions, and then instantiate KVM=
 VCPUs
> > > > =A0=A0 with them.
> > > > =

> > > > I think (3) is the most robust approach, and it has the least
> > > > overhead.
> > > =

> > > I don't disagree with the goal, and not even with the choice of
> > > implementation (though I have huge reservations about its quality).
> > > =

> > > But the key word here is *userspace*. Only userspace has a notion of
> > > how MPIDR values map to the assumed topology. That's not something
> > > that KVM does nor should interpret (aside from the GIC-induced Aff0
> > > brain-damage). So talking of "topology" in a KVM kernel patch sends
> > > the wrong message, and that's all this remark was about.
> > =

> > There's also a patch queued for next which removes using MPIDR as a
> > source of
> > information about CPU topology [1]: "arm64: topology: Stop using MPIDR
> > for
> > topology information".
> > =

> > I'm not really sure how useful KVM fiddling with the guest MPIDR will be
> > going
> > forward, at least for a Linux guest.
> =

> I think these are two orthogonal things. There is value in setting MPIDR
> to something different as a way to replicate an existing system, for
> example. But deriving *any* sort of topology information from MPIDR isn't
> reliable at all, and is better expressed by firmware tables (and even
> that isn't great).
> =


Yes, this is my opinion as well and I'm glad to see the patch that
Alexandru pointed out, since it should stop the MPIDR abuse. Ying Fang
has also posted a QEMU series that populates DT and ACPI[*] to describe
CPU topology to the guest. The user controlled MPIDR is being proposed
in order to support that series.

[*] https://lists.gnu.org/archive/html/qemu-devel/2020-09/msg06027.html

Thanks,
drew

> As far as I am concerned, this patch fits in the "cosmetic" department.
> It's a "nice to have", but doesn't really solve much. Firmware tables
> and userspace placement of the vcpus are key.
> =

> Thanks,
> =

>         M.
> -- =

> Jazz is not dead. It just smells funny...
> =


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
