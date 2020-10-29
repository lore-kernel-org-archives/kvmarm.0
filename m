Return-Path: <SRS0=BReL=EE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27304C2D0A3
	for <kvmarm@archiver.kernel.org>; Thu, 29 Oct 2020 20:25:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 53D1220725
	for <kvmarm@archiver.kernel.org>; Thu, 29 Oct 2020 20:25:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J4DS3BzT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53D1220725
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AFF54B692;
	Thu, 29 Oct 2020 16:25:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 76uktsS7QgwX; Thu, 29 Oct 2020 16:24:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72FF04B691;
	Thu, 29 Oct 2020 16:24:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07B804B691
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 16:24:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BRrzVCL0posJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Oct 2020 16:24:57 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DD334B68F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 16:24:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604003097;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=PEJzoaoz5VMGDeqxF/G2tWA8daQ/MCiANNC2CgTlcmM=;
 b=J4DS3BzTOrwfkvDnG3fNAxRUqKXKpdZc3xm7Zd97ebiL3Zhd7SKNUVcSxxLf98irPFxjBN
 WYm2S4Wv/YlS1X8++yUpWQjWy3yqxDTBVzXW2ClA+r/ifIhHdaG6EJ4YR24cMPHf8pzAQ4
 JqDSeDyOpJFZFbMzYexA9k2/So2xX8g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-3b9w05V-MBmfeqydHOkYTw-1; Thu, 29 Oct 2020 16:24:55 -0400
X-MC-Unique: 3b9w05V-MBmfeqydHOkYTw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A37708015A4;
 Thu, 29 Oct 2020 20:24:53 +0000 (UTC)
Received: from [10.36.112.194] (ovpn-112-194.ams2.redhat.com [10.36.112.194])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E5F7C5DA30;
 Thu, 29 Oct 2020 20:24:51 +0000 (UTC)
Subject: Re: [PATCH 0/4] KVM: selftests: Add get-reg-list regression test
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20201029201703.102716-1-drjones@redhat.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <e66c22cc-3b99-b367-97e4-7d299dae4ed8@redhat.com>
Date: Thu, 29 Oct 2020 21:24:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201029201703.102716-1-drjones@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: pbonzini@redhat.com, Dave.Martin@arm.com, maz@kernel.org
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



On 10/29/20 9:16 PM, Andrew Jones wrote:
> Since Eric complained in his KVM Forum talk that there weren't any
> aarch64-specific KVM selftests, now he gets to review one. 

okay ... :-)

Eric
This test
> was inspired by recent regression report about get-reg-list losing
> a register between an old kernel version and a new one.
> 
> Thanks,
> drew
> 
> 
> Andrew Jones (4):
>   KVM: selftests: Don't require THP to run tests
>   KVM: selftests: Add aarch64 get-reg-list test
>   KVM: selftests: Update aarch64 get-reg-list blessed list
>   KVM: selftests: Add blessed SVE registers to get-reg-list
> 
>  tools/testing/selftests/kvm/.gitignore        |   2 +
>  tools/testing/selftests/kvm/Makefile          |   2 +
>  .../selftests/kvm/aarch64/get-reg-list-sve.c  |   3 +
>  .../selftests/kvm/aarch64/get-reg-list.c      | 841 ++++++++++++++++++
>  .../testing/selftests/kvm/include/kvm_util.h  |   1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  52 +-
>  6 files changed, 894 insertions(+), 7 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
>  create mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list.c
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
