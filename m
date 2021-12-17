Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42365C433F5
	for <kvmarm@archiver.kernel.org>; Sun, 19 Dec 2021 12:12:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F8A64B2E4;
	Sun, 19 Dec 2021 07:12:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 81g4x0gZVHD5; Sun, 19 Dec 2021 07:12:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 417B94B2D0;
	Sun, 19 Dec 2021 07:12:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAA074B2DA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 06:52:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oZFa2gdlgZ+L for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Dec 2021 06:52:03 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 005454B26F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 06:52:02 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1639741922;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=VbaoBagpyxB2kBwkaE/GX54RBymyP3RskJ4qz0SPZ7M=;
 b=g7lJAb3Jcqg91RdT9/aOpyolNXhn2ToVxPDZArEzwDXhSj0GoE6MOegSBV5lUp2P4VMbbB
 PcYe1JMIu6h2PbYUUeKo35T+sGPet/18BosuvNSr/0UNfVVQRZVeCluS8mVNIhu92iFZK4
 yzv1/FHcuQEw5kPn0ppPJ247xIJ2CBw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-j003rJv9NFC5lfSYcfqEPQ-1; Fri, 17 Dec 2021 06:51:59 -0500
X-MC-Unique: j003rJv9NFC5lfSYcfqEPQ-1
Received: by mail-wm1-f71.google.com with SMTP id
 a203-20020a1c7fd4000000b0034574187420so1914745wmd.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 03:51:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:subject:from:to:cc:date:user-agent
 :mime-version:content-transfer-encoding;
 bh=VbaoBagpyxB2kBwkaE/GX54RBymyP3RskJ4qz0SPZ7M=;
 b=ocEesu7azAIjFB+NOWxNqHjCA2Vm7SLJOTNq/XuY2Z5fBQ/t2pDHWvCKT7PQWZWXXY
 O3/x3znmu+/rYwishpBeOa2cl0fpLOc2emj1rVeNDAxtvnqPqhRdoPGf1F/s2CbbfOcH
 oYlqfGVuLmWJSLa3pFC00lzequIST0fAgyC7n0fOzQmrUdrj0hTzMuVyA2zU3j7xvMXI
 82ns0InYXcmNv0AfLvkBxGdLuN3zelGttuXUBZy70zLv1uu3uEffGsuypjIbni5yUwxF
 bBuytDs0FSdOK2p5iEPSdmoNAnuyDwl88LsiYSjLyXitphcdv/tj+7wqj4ZKN7GcvtJj
 7dNA==
X-Gm-Message-State: AOAM531oWQ7ztsv6lm/wieZKq92gACEB98iGARE+5eKG1Zf3ZI3S6ds9
 yR5TnqB55wkZetUWZTU6uEQL+3u2bFFukXHmg3h2ddwyMqZcE3vSr+RqtivN9Vu1vi1A2+SblyX
 n5zPB3viqb3VxzbhKbLEXnDX/
X-Received: by 2002:a5d:60d1:: with SMTP id x17mr2256897wrt.208.1639741918359; 
 Fri, 17 Dec 2021 03:51:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzuWJ1oAUOR9ZdBi/KYt7RPzUDX8mfw0bBNc+p+s/E8DzmY72v3omfLECQ4vU+R5FsDQMAaaQ==
X-Received: by 2002:a5d:60d1:: with SMTP id x17mr2256884wrt.208.1639741918131; 
 Fri, 17 Dec 2021 03:51:58 -0800 (PST)
Received: from ?IPv6:2a0c:5a80:3b0e:bd00:1099:cf34:d27f:de8a?
 ([2a0c:5a80:3b0e:bd00:1099:cf34:d27f:de8a])
 by smtp.gmail.com with ESMTPSA id f3sm7117441wrm.96.2021.12.17.03.51.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Dec 2021 03:51:57 -0800 (PST)
Message-ID: <d80e440375896f75d45e227d40af60ca7ba24ceb.camel@redhat.com>
Subject: Possible nohz-full/RCU issue in arm64 KVM
From: Nicolas Saenz Julienne <nsaenzju@redhat.com>
To: Mark Rutland <mark.rutland@arm.com>, maz <maz@kernel.org>
Date: Fri, 17 Dec 2021 12:51:57 +0100
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35)
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nsaenzju@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Sun, 19 Dec 2021 07:12:12 -0500
Cc: paulmck <paulmck@kernel.org>, frederic <frederic@kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>, rcu <rcu@vger.kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgQWxsLAphcm02NCdzIGd1ZXN0IGVudHJ5IGNvZGUgZG9lcyB0aGUgZm9sbG93aW5nOgoKaW50
IGt2bV9hcmNoX3ZjcHVfaW9jdGxfcnVuKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKewoJWy4uLl0K
CglndWVzdF9lbnRlcl9pcnFvZmYoKTsKCglyZXQgPSBrdm1fY2FsbF9oeXBfcmV0KF9fa3ZtX3Zj
cHVfcnVuLCB2Y3B1KTsKCglbLi4uXQoKCWxvY2FsX2lycV9lbmFibGUoKTsKCgkvKgoJICogV2Ug
ZG8gbG9jYWxfaXJxX2VuYWJsZSgpIGJlZm9yZSBjYWxsaW5nIGd1ZXN0X2V4aXQoKSBzbwoJICog
dGhhdCBpZiBhIHRpbWVyIGludGVycnVwdCBoaXRzIHdoaWxlIHJ1bm5pbmcgdGhlIGd1ZXN0IHdl
CgkgKiBhY2NvdW50IHRoYXQgdGljayBhcyBiZWluZyBzcGVudCBpbiB0aGUgZ3Vlc3QuICBXZSBl
bmFibGUKCSAqIHByZWVtcHRpb24gYWZ0ZXIgY2FsbGluZyBndWVzdF9leGl0KCkgc28gdGhhdCBp
ZiB3ZSBnZXQKCSAqIHByZWVtcHRlZCB3ZSBtYWtlIHN1cmUgdGlja3MgYWZ0ZXIgdGhhdCBpcyBu
b3QgY291bnRlZCBhcwoJICogZ3Vlc3QgdGltZS4KCSAqLwoJZ3Vlc3RfZXhpdCgpOwoJWy4uLl0K
fQoKCk9uIGEgbm9oei1mdWxsIENQVSwgZ3Vlc3Rfe2VudGVyLGV4aXR9KCkgZGVsaW1pdCBhbiBS
Q1UgZXh0ZW5kZWQgcXVpZXNjZW50CnN0YXRlIChFUVMpLiBBbnkgaW50ZXJydXB0IGhhcHBlbmlu
ZyBiZXR3ZWVuIGxvY2FsX2lycV9lbmFibGUoKSBhbmQKZ3Vlc3RfZXhpdCgpIHNob3VsZCBkaXNh
YmxlIHRoYXQgRVFTLiBOb3csIEFGQUlDVCBhbGwgZWwwIGludGVycnVwdCBoYW5kbGVycyBkbwp0
aGUgcmlnaHQgdGhpbmcgaWYgdHJnZ2VyZWQgaW4gdGhpcyBjb250ZXh0LCBidXQgZWwxJ3Mgd29u
J3QuIElzIGl0IHBvc3NpYmxlIHRvCmhpdCBhbiBlbDEgaGFuZGxlciAoZm9yIGV4YW1wbGUgX19l
bDFfaXJxKCkpIHRoZXJlPwoKVGhhbmtzLAoKLS0gCk5pY29sw6FzIFPDoWVuegoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlz
dAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEu
ZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
