Return-Path: <SRS0=LYRx=QG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 534E6C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 12:29:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC13761AD0
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 12:29:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AC13761AD0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37C4A4B131;
	Fri, 19 Nov 2021 07:29:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id krsXknifRfha; Fri, 19 Nov 2021 07:29:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27E854B0FC;
	Fri, 19 Nov 2021 07:29:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E9674B130
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 05:21:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sqWtrzvU5JRp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Nov 2021 05:21:46 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FA6D49E5F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 05:21:46 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637317305;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=yoOG1diMi0E/SvfVXv5alhyBNgdiAvTA9EtQDMJObdw=;
 b=SDVhLq68NSwH6f0zG6J06jcycbXs1CaQzUpPgizH0x+JxE2Q3wrNeQS9Hst1lBC0csvGku
 CBvvvivR9MF2ZMcEdeJNpjD0kI0x4Q1qxJomlJZv/tNm2a5rLRBloePC44oSzS9SSTpdWy
 qH1JOSTQ9OmJeRHzsWrZESbGnieMYHQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-dRClEdKlOI2BsFTc6lxoBg-1; Fri, 19 Nov 2021 05:21:44 -0500
X-MC-Unique: dRClEdKlOI2BsFTc6lxoBg-1
Received: by mail-wm1-f71.google.com with SMTP id
 187-20020a1c02c4000000b003335872db8dso3353208wmc.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 02:21:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=yoOG1diMi0E/SvfVXv5alhyBNgdiAvTA9EtQDMJObdw=;
 b=t+AFqYeVqEm3MFuVTiHI4WEuIB1h+vKZ8kzzsJzt1twxQWmkVvdOidjuTTu8XbyKr+
 unp24bPTiIfCnw00wEoiSawf0L9vuX8CxJtowTl2qGtVLK2Q2feI4zMBdEqShDhzRkuB
 cvwbX9mLKrAhewUnZyKQEspIaoUR48ixT727ZaXqmpf3dMP2TPd5mktnsUKLphH9dflF
 G643Wjs7dhxWpUoAg9Js7DUWD8pwnj1vxEENs4KFp9FLY5ZpDNZBmxukK4kAx+dZ1yhY
 XAx4MPaxXHJei4iLg+bMi3w0Im4SsVkjC3+G7GWYQDVlcop/D1jOL6H2VeXfCY/OtI4x
 JAhw==
X-Gm-Message-State: AOAM5318dTq2nSoIuuLtcUrLUvQbWYG6PoQGTHCOdxdGdTuRsQKBp8Bq
 ylgnqNwbU9q2LYPR1nNfp9n3V7x3jRnqS4M49D5F6iNz6hlek20SmLvpM+CByTHi6mduzAo6oA/
 no+lGkayUi+Wqbv9+XUVpl69C
X-Received: by 2002:a5d:63ca:: with SMTP id c10mr5840325wrw.124.1637317303377; 
 Fri, 19 Nov 2021 02:21:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwihTxczM5jqGJYFo9iUlthuKo/r0hHx/63+SRDngLpAOgUraQ7o+CZyQaRivyiAucHPrBPCQ==
X-Received: by 2002:a5d:63ca:: with SMTP id c10mr5840286wrw.124.1637317303163; 
 Fri, 19 Nov 2021 02:21:43 -0800 (PST)
Received: from vian.redhat.com ([2a0c:5a80:3c10:3400:3c70:6643:6e71:7eae])
 by smtp.gmail.com with ESMTPSA id k27sm14336026wms.41.2021.11.19.02.21.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 19 Nov 2021 02:21:42 -0800 (PST)
From: Nicolas Saenz Julienne <nsaenzju@redhat.com>
To: linux-arm-kernel@lists.infradead.org, maz@kernel.org, rostedt@goodmis.org
Subject: [RFC PATCH 0/2] KVM: arm64: Host/Guest trace syncronization
Date: Fri, 19 Nov 2021 11:21:16 +0100
Message-Id: <20211119102117.22304-1-nsaenzju@redhat.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nsaenzju@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Fri, 19 Nov 2021 07:29:31 -0500
Cc: will@kernel.org, catalin.marinas@arm.com, mtosatti@redhat.com,
 linux-kernel@vger.kernel.org, mingo@redhat.com, nsaenzju@redhat.com,
 nilal@redhat.com, kvmarm@lists.cs.columbia.edu
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

This small series introduces the necessary infrastructure to be able to
syncronize host and guest traces. The approach I'm following is a bit
biased since I tried to replicate the methods I've been using in the
past with x86.

This was tested on an Ampere Mt. Jade based machine.

---

Nicolas Saenz Julienne (2):
  arm64/tracing: add cntvct based trace clock
  KVM: arm64: export cntvoff in debugfs

 arch/arm64/include/asm/kvm_host.h    |  1 +
 arch/arm64/include/asm/trace_clock.h | 12 ++++++++++++
 arch/arm64/kernel/Makefile           |  2 +-
 arch/arm64/kernel/trace_clock.c      | 12 ++++++++++++
 arch/arm64/kvm/Makefile              |  2 +-
 arch/arm64/kvm/arch_timer.c          |  2 +-
 arch/arm64/kvm/debugfs.c             | 25 +++++++++++++++++++++++++
 include/kvm/arm_arch_timer.h         |  3 +++
 8 files changed, 56 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm64/include/asm/trace_clock.h
 create mode 100644 arch/arm64/kernel/trace_clock.c
 create mode 100644 arch/arm64/kvm/debugfs.c

-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
