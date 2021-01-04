Return-Path: <SRS0=G82f=GH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F3EC433E0
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 16:28:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2112622473
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 16:28:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2112622473
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C003F4B2D4;
	Mon,  4 Jan 2021 11:27:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NaqR+K2HWSon; Mon,  4 Jan 2021 11:27:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8601B4B2E5;
	Mon,  4 Jan 2021 11:27:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4E4A4B20C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2021 11:22:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i7pA31d+KBCT for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Jan 2021 11:22:13 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA6034B1BF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2021 11:22:13 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1609777333;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=1Q1DvyIxrkPxXGrCAY0p7IMPCUH81g19jkyhBrpKkfA=;
 b=RZuCDVSVhxoSLjtshLccArsfX8d7EiwKl1HjfxuDL+GPnJQ0PfqsZTnxB2XssIiA/51KkI
 z8QAZZ9CPIZ/J1JXHXOlZVmaLQ8/VV9Ei5uIMqjn9ynpoGeXaq6FxQ/nUOT4uTpEj/i7B9
 gboqiHrFg4TZBCnxU9TQZr33lLze2rM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-dMp1c77MMje3HQvVfpmXyg-1; Mon, 04 Jan 2021 11:22:09 -0500
X-MC-Unique: dMp1c77MMje3HQvVfpmXyg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8758F107ACE8;
 Mon,  4 Jan 2021 16:22:07 +0000 (UTC)
Received: from ovpn-66-203.rdu2.redhat.com (unknown [10.10.67.203])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 5E88B1971B;
 Mon,  4 Jan 2021 16:22:06 +0000 (UTC)
Message-ID: <f4300d00b9d2540bf90a6b1baadf030a2e4c92ed.camel@redhat.com>
Subject: Re: [PATCH] KVM: arm64: Don't access PMCR_EL0 when no PMU is available
From: Qian Cai <qcai@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Date: Mon, 04 Jan 2021 11:22:05 -0500
In-Reply-To: <579c839a0016107af66e704f147f9814@kernel.org>
References: <20201210083059.1277162-1-maz@kernel.org>
 <703e1b5f2db1631e8f9c55619909fe66eb069f25.camel@redhat.com>
 <579c839a0016107af66e704f147f9814@kernel.org>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Mailman-Approved-At: Mon, 04 Jan 2021 11:27:56 -0500
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
 Linux Next Mailing List <linux-next@vger.kernel.org>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, 2021-01-04 at 16:08 +0000, Marc Zyngier wrote:
> On 2021-01-04 15:47, Qian Cai wrote:
> > On Thu, 2020-12-10 at 08:30 +0000, Marc Zyngier wrote:
> > > We reset the guest's view of PMCR_EL0 unconditionally, based on
> > > the host's view of this register. It is however legal for an
> > > imnplementation not to provide any PMU, resulting in an UNDEF.
> > > 
> > > The obvious fix is to skip the reset of this shadow register
> > > when no PMU is available, sidestepping the issue entirely.
> > > If no PMU is available, the guest is not able to request
> > > a virtual PMU anyway, so not doing nothing is the right thing
> > > to do!
> > > 
> > > It is unlikely that this bug can hit any HW implementation
> > > though, as they all provide a PMU. It has been found using nested
> > > virt with the host KVM not implementing the PMU itself.
> > > 
> > > Fixes: ab9468340d2bc ("arm64: KVM: Add access handler for PMCR 
> > > register")
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > 
> > Reverting this commit on the top of today's linux-next fixed a qemu-kvm 
> > coredump
> > issue on TX2 while starting a guest.
> > 
> > - host kernel .config:
> > https://cailca.coding.net/public/linux/mm/git/files/master/arm64.config
> > 
> > # /usr/libexec/qemu-kvm -name ubuntu-20.04-server-cloudimg -cpu host
> > -smp 2 -m 2g
> > -drive 
> > if=none,format=qcow2,file=./ubuntu-20.04-server-cloudimg.qcow2,id=hd
> > -device virtio-scsi -device scsi-hd,drive=hd -cdrom
> > ./ubuntu-20.04-server-cloudimg.iso
> > -bios /usr/share/AAVMF/AAVMF_CODE.fd -M gic-version=host -nographic
> > -nic user,model=virtio,hostfwd=tcp::2222-:22
> > 
> > qemu-kvm: /builddir/build/BUILD/qemu-4.2.0/target/arm/helper.c:1812:
> > pmevcntr_rawwrite: Assertion `counter < pmu_num_counters(env)' failed.
> 
> You don't have KVM_ARM_PMU selected in your config, so QEMU cannot
> access the PMU registers, and no counters are exposed.

Well, isn't it the rule that don't break the userspace? qemu works fine with
KVM_ARM_PMU=n until this commit.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
