Return-Path: <SRS0=D5oV=NG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF77C4338F
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 00:20:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BDDC660F51
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 00:20:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BDDC660F51
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48CDF4B0D7;
	Sat, 14 Aug 2021 20:20:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2WZ637SKQ1+m; Sat, 14 Aug 2021 20:20:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F391E4B098;
	Sat, 14 Aug 2021 20:20:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A5ED4A198
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 20:20:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fWJ+QPR6SrHH for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Aug 2021 20:20:01 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B76749E8A
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 20:20:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628986801;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=oP82YO7+Ud/EWaS5q3iuRU5WSJgOBi/uyPbz0miSSSw=;
 b=FTbQTn8Y0Y4lyLbIly1hs6Qthv5DcHqEx98q5v77pHeZh19gNNHRH+PRsTmXlXDp0A4iaF
 6dMoiFKCb5hdM3PH6qIY5fxOlQViF5FRRGeop4mbZ59vYgHsqM/xtEHHVESgyJyK3vniWu
 SS6Dtc1j0p7+IN7OiULWgQOcb61yw88=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-Vt-w2ZTWP2Skp8E15Gp2eQ-1; Sat, 14 Aug 2021 20:19:57 -0400
X-MC-Unique: Vt-w2ZTWP2Skp8E15Gp2eQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6CE71801AC0;
 Sun, 15 Aug 2021 00:19:56 +0000 (UTC)
Received: from [10.64.54.103] (vpn2-54-103.bne.redhat.com [10.64.54.103])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8443B60C4A;
 Sun, 15 Aug 2021 00:19:52 +0000 (UTC)
Subject: Re: [PATCH v4 00/21] Support SDEI Virtualization
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
Message-ID: <eee7eeb2-cedf-e52f-1e5f-403d9edabd94@redhat.com>
Date: Sun, 15 Aug 2021 10:19:46 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20210815001352.81927-1-gshan@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, Jonathan.Cameron@huawei.com,
 pbonzini@redhat.com, will@kernel.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 8/15/21 10:13 AM, Gavin Shan wrote:
> This series intends to virtualize Software Delegated Exception Interface
> (SDEI), which is defined by DEN0054A. It allows the hypervisor to deliver
> NMI-alike event to guest and it's needed by asynchronous page fault to
> deliver page-not-present notification from hypervisor to guest. The code
> and the required qemu changes can be found from:
> 
>     https://developer.arm.com/documentation/den0054/latest
>     https://github.com/gwshan/linux    ("kvm/arm64_sdei")
>     https://github.com/gwshan/qemu     ("kvm/arm64_sdei")
> 
> The SDEI event is identified by a 32-bits number. Bits[31:24] are used
> to indicate the SDEI event properties while bits[23:0] are identifying
> the unique number. The implementation takes bits[23:22] to indicate the
> owner of the SDEI event. For example, those SDEI events owned by KVM
> should have these two bits set to 0b01. Besides, the implementation
> supports SDEI events owned by KVM only.
> 
> The design is pretty straightforward and the implementation is just
> following the SDEI specification, to support the defined SMCCC intefaces,
> except the IRQ binding stuff. There are several data structures introduced.
> Some of the objects have to be migrated by VMM. So their definitions are
> split up for VMM to include the corresponding states for migration.
> 
>     struct kvm_sdei_kvm
>        Associated with VM and used to track the KVM exposed SDEI events
>        and those registered by guest.
>     struct kvm_sdei_vcpu
>        Associated with vCPU and used to track SDEI event delivery. The
>        preempted context is saved prior to the delivery and restored
>        after that.
>     struct kvm_sdei_event
>        SDEI events exposed by KVM so that guest can register and enable.
>     struct kvm_sdei_kvm_event
>        SDEI events that have been registered by guest.
>     struct kvm_sdei_vcpu_event
>        SDEI events that have been queued to specific vCPU for delivery.
> 
> The series is organized as below:
> 
>     PATCH[01]    Introduces template for smccc_get_argx()
>     PATCH[02]    Introduces the data structures and infrastructure
>     PATCH[03-14] Supports various SDEI related hypercalls
>     PATCH[15]    Supports SDEI event notification
>     PATCH[16-17] Introduces ioctl command for migration
>     PATCH[18-19] Supports SDEI event injection and cancellation
>     PATCH[20]    Exports SDEI capability
>     PATCH[21]    Adds self-test case for SDEI virtualization
> 

[...]

I explicitly copied James Morse and Mark Rutland when posting the series,
but something unknown went wrong. I'm including them here to avoid
reposting the whole series.

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
