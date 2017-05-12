From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC kvm-unit-tests PATCH 5/8] Makefile: add explicit mkdir for
 .o targets
Date: Fri, 12 May 2017 12:36:32 +0200
Message-ID: <bac2056a-c771-6188-0066-7e3236719ff0@redhat.com>
References: <20170406190727.5624-1-alex.bennee@linaro.org>
 <20170406190727.5624-6-alex.bennee@linaro.org>
 <a8eb190a-3487-1a89-0069-789b62860b3e@redhat.com> <87mvaj4din.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A180E40905
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 May 2017 06:33:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xAJW1uSxmHFz for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 May 2017 06:33:18 -0400 (EDT)
Received: from mail-wr0-f196.google.com (mail-wr0-f196.google.com
 [209.85.128.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C62740017
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 May 2017 06:33:17 -0400 (EDT)
Received: by mail-wr0-f196.google.com with SMTP id v42so7065812wrc.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 May 2017 03:36:38 -0700 (PDT)
In-Reply-To: <87mvaj4din.fsf@linaro.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

CgpPbiAxMS8wNS8yMDE3IDE3OjMwLCBBbGV4IEJlbm7DqWUgd3JvdGU6Cj4+Pgo+Pj4gICUubzog
JS5TCj4+PiArCW1rZGlyIC1wICQoZGlyICRAKQo+PiBTaG91bGQgdGhpcyB1c2UgQCBmb3IgY2xl
YW5saW5lc3M/Cj4gPiBJJ20gbm90IHN1cmUgSSBmb2xsb3cuIERpZCB5b3UgbWVhbiB1c2UgJChA
RCkgZGlyZWN0bHk/CgpUaGF0IHRvbywgYnV0IEkgd2FzIHRoaW5raW5nIG9mIHVzaW5nICJAbWtk
aXIiIHRvIGF2b2lkIHNwYW1taW5nIHRoZQpvdXRwdXQgd2l0aCBta2RpciBjb21tYW5kcy4KClBh
b2xvCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFy
bSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3Rz
LmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
