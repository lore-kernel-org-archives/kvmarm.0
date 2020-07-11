Return-Path: <SRS0=gvHH=AW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEDD9C433E7
	for <kvmarm@archiver.kernel.org>; Sat, 11 Jul 2020 10:04:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 89E592077D
	for <kvmarm@archiver.kernel.org>; Sat, 11 Jul 2020 10:04:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZYjwT+Ww"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89E592077D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 425024B0D8;
	Sat, 11 Jul 2020 06:04:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pxzXuuiFj6A0; Sat, 11 Jul 2020 06:04:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6E7F4B128;
	Sat, 11 Jul 2020 06:04:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B414B4B120
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Jul 2020 06:04:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nTZaLcDY+woX for <kvmarm@lists.cs.columbia.edu>;
 Sat, 11 Jul 2020 06:04:46 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F05614B124
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Jul 2020 06:04:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1594461885;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=VKBB5okw8SKPQ8TKlGmPfFr4Jdt7zbRqxy7S7JmXFQw=;
 b=ZYjwT+WwzWVPmnb7Bfl7R788skj1/Wbb0VzdD86e+KlaH8ZMA8V63Hf7dI4yojYT/MwaMc
 f8fs1unEKQFBVpMsrJvmqIkT6lON9O1OkR+eS4nbEymYSYpWOPtbONO7pTvZZUmC9cJzUk
 /jhVtVbI6xTTKuhFD7AjiMpZsZtNBUU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135--wLag4N5OjCR61GbjcBMqQ-1; Sat, 11 Jul 2020 06:04:42 -0400
X-MC-Unique: -wLag4N5OjCR61GbjcBMqQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CC47100960F;
 Sat, 11 Jul 2020 10:04:37 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.42])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 970D019D61;
 Sat, 11 Jul 2020 10:04:35 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/5] KVM: arm64: pvtime: Fixes and a new cap
Date: Sat, 11 Jul 2020 12:04:29 +0200
Message-Id: <20200711100434.46660-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: pbonzini@redhat.com, steven.price@arm.com, maz@kernel.org
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

The first three patches in the series are fixes that come from testing
and reviewing pvtime code while writing the QEMU support (I'll reply
to this mail with a link to the QEMU patches after posting - which I'll
do shortly). The last patch is only a convenience for userspace, and I
wouldn't be heartbroken if it wasn't deemed worth it. The QEMU patches
I'll be posting are currently written without the cap. However, if the
cap is accepted, then I'll change the QEMU code to use it.

Thanks,
drew

Andrew Jones (5):
  KVM: arm64: pvtime: steal-time is only supported when configured
  KVM: arm64: pvtime: Fix potential loss of stolen time
  KVM: arm64: pvtime: Fix stolen time accounting across migration
  KVM: Documentation minor fixups
  arm64/x86: KVM: Introduce steal-time cap

 Documentation/virt/kvm/api.rst    | 20 ++++++++++++++++----
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/arm.c              |  3 +++
 arch/arm64/kvm/pvtime.c           | 31 +++++++++++++++----------------
 arch/x86/kvm/x86.c                |  3 +++
 include/linux/kvm_host.h          | 19 +++++++++++++++++++
 include/uapi/linux/kvm.h          |  1 +
 7 files changed, 58 insertions(+), 21 deletions(-)

-- 
2.25.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
