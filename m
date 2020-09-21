Return-Path: <SRS0=bMLL=C6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74D6CC43463
	for <kvmarm@archiver.kernel.org>; Mon, 21 Sep 2020 07:53:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C82252151B
	for <kvmarm@archiver.kernel.org>; Mon, 21 Sep 2020 07:53:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F2fLuibR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C82252151B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E9844B4D6;
	Mon, 21 Sep 2020 03:53:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 020X3Lw79fGB; Mon, 21 Sep 2020 03:53:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B7CD4B4FE;
	Mon, 21 Sep 2020 03:53:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 375AA4B4E5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2020 03:53:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uZLTTgnAHW2b for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Sep 2020 03:53:20 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED6A74B4B9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2020 03:53:20 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1600674800;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=+yU0qD4mrbo+E/JHts5fvuh+XEsnmFdemkkwXFLVy4I=;
 b=F2fLuibR76c2NZ59BPXz2LN9ws1KtBd4rR5oi9rk+n/lJmQbJz+8Bzyb8TIKubtakTI0qm
 Af35dWRqXpJaXzABQ1ZmdxHoUbaa9ZbERsWlIo2kP3KU3Ka+8ZOAUcPCfsWym6lR4crELE
 JZ7OHtZQl3cfEERrJT4m6q/4OsyYtLo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-NEEVvtwfM5axLizBzqIYLg-1; Mon, 21 Sep 2020 03:53:18 -0400
X-MC-Unique: NEEVvtwfM5axLizBzqIYLg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32B551018720;
 Mon, 21 Sep 2020 07:53:17 +0000 (UTC)
Received: from [10.36.112.29] (ovpn-112-29.ams2.redhat.com [10.36.112.29])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A1D87882C;
 Mon, 21 Sep 2020 07:53:12 +0000 (UTC)
Subject: Re: KVM_SET_DEVICE_ATTR failed
To: Zenghui Yu <yuzenghui@huawei.com>, qemu-arm@nongnu.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <1f70926e-27dd-9e30-3d0f-770130112777@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <d0c418f2-07a2-f090-e13d-f5ea299a009b@redhat.com>
Date: Mon, 21 Sep 2020 09:53:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1f70926e-27dd-9e30-3d0f-770130112777@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: Marc Zyngier <maz@kernel.org>, Alex Williamson <alex.williamson@redhat.com>
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

Hi Zenghui,

On 9/19/20 1:15 PM, Zenghui Yu wrote:
> Hi folks,
> 
> I had booted a guest with an assigned virtual function, with GICv4
> (direct MSI injection) enabled on my arm64 server. I got the following
> QEMU error message on its shutdown:
> 
> "qemu-system-aarch64: KVM_SET_DEVICE_ATTR failed: Group 4 attr
> 0x0000000000000001: Permission denied"
> 
> The problem is that the KVM_DEV_ARM_ITS_SAVE_TABLES ioctl failed while
> stopping the VM.
> 
> As for the kernel side, it turned out that an LPI with irq->hw=true was
> observed while saving ITT for the device. KVM simply failed the save
> operation by returning -EACCES to user-space. The reason is explained in
> the comment block of vgic_its_save_itt(), though I think the HW bit
> should actually be checked in the KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES
> ioctl rather than in the ITT saving, well, it isn't much related to this
> problem...
> 
> I had noticed that some vectors had been masked by guest VF-driver on
> shutdown, the correspond VLPIs had therefore been unmapped and irq->hw
> was cleared. But some other vectors were un-handled. I *guess* that VFIO
> released these vectors *after* the KVM_DEV_ARM_ITS_SAVE_TABLES ioctl so
> that we end-up trying to save the VLPI's state.
> 
> It may not be a big problem as the guest is going to shutdown anyway and
> the whole guest save/restore on the GICv4.x system is not supported for
> the time being... I'll look at how VFIO would release these vectors but
> post it early in case this is an already known issue (and this might be
> one thing need to be considered if one wants to implement migration on
> the GICv4.x system).

Thanks for reporting the issue. I will have a look at the QEMU sequence too


Eric
> 
> 
> Thanks,
> Zenghui
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
