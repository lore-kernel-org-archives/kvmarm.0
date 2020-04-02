Return-Path: <SRS0=xSqk=5S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E3D9C43331
	for <kvmarm@archiver.kernel.org>; Thu,  2 Apr 2020 14:50:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 995E2206F5
	for <kvmarm@archiver.kernel.org>; Thu,  2 Apr 2020 14:50:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G6BDNB+2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 995E2206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C4C44B164;
	Thu,  2 Apr 2020 10:50:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Of3AylI7aext; Thu,  2 Apr 2020 10:50:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B3134B0AD;
	Thu,  2 Apr 2020 10:50:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9B754B0AD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2020 10:50:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uzkamW0pIvsE for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Apr 2020 10:50:37 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 192954A4BE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2020 10:50:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585839036;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=LXeAIFchhmL4/ru7L0y4E++LQmFqG0pq5fk9R9Cim7M=;
 b=G6BDNB+2hTNSQvauLVcaSiuxQhEcr+VYo/n1M4kNwmWL4ZwSzPbV2PoSTStRKTq71A0v9D
 n3+bgf6+o9LYhI59nWUwa25odztLg5P0ggSEpnug9TMXGNKnaSOynLn1uLksCJ8UNJN6es
 6OxJa4Vq5hIh6FSVuhwcBOatQlJKl3E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-9b33VLRaPM-MiGo3zfhLQQ-1; Thu, 02 Apr 2020 10:50:35 -0400
X-MC-Unique: 9b33VLRaPM-MiGo3zfhLQQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC446108838C;
 Thu,  2 Apr 2020 14:50:33 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.77])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BE3425D9C9;
 Thu,  2 Apr 2020 14:50:31 +0000 (UTC)
Date: Thu, 2 Apr 2020 16:50:28 +0200
From: Andrew Jones <drjones@redhat.com>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [kvm-unit-tests PATCH 0/2] arm/arm64: Add IPI/vtimer latency
Message-ID: <20200402145028.oma67w5tbjd44h2w@kamzik.brq.redhat.com>
References: <20200401100812.27616-1-wangjingyi11@huawei.com>
 <20200401122445.exyobwo3a3agnuhk@kamzik.brq.redhat.com>
 <bbcd3dc4-79c1-7ba2-ea54-96d083dfcef9@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <bbcd3dc4-79c1-7ba2-ea54-96d083dfcef9@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Thu, Apr 02, 2020 at 07:52:43PM +0800, Zenghui Yu wrote:
>   But what I'm actually interested in is the latency of the new GICv4.1
>   vSGIs (which will be directly injected through ITS).  To measure it,
>   we should first make KUT be GICv4.1-awareness, see [1] for details.
>   (This way, we can even have a look at the interrupt latency in HW
>   level. Is it possible to have this in kvm-unit-tests, Drew?)

I would certainly welcome gicv4 support in kvm-unit-tests. Let's get
Eric's ITS series merged first, but then patches welcome :-)

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
