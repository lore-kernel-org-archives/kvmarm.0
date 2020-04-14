Return-Path: <SRS0=7dZW=56=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5930AC2BA19
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 08:19:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C6F30206E9
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 08:19:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PkTSlSFu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6F30206E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15E454B14E;
	Tue, 14 Apr 2020 04:19:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4iXjSgIJn00n; Tue, 14 Apr 2020 04:19:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 158B24B15C;
	Tue, 14 Apr 2020 04:19:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B1194B14E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 04:19:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aY8owNO2u4N4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2020 04:19:04 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84FB24B14C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 04:19:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586852344;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=5Wb7ghxdvKYdRHUeDIrwZRLDN53fs9i+DGns+KVd+no=;
 b=PkTSlSFuPa3VHPfkwulYvXZXNWKPSqnP6MKwyfdAH/CtMAG9ixUBadV96a2iIFtplJkuof
 +Pf/4L5xGmUNSBj0r5Chp14DGoHvwwK6QqPSk0BAuGfoNwVyZGDnAzZsIbiAq9nhfRGx0S
 oi0yCtUlTd5/6cqd7bzGEgCXIY46AdU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-DSY7EZP2OYal9mpV1xr0lA-1; Tue, 14 Apr 2020 04:19:02 -0400
X-MC-Unique: DSY7EZP2OYal9mpV1xr0lA-1
Received: by mail-wm1-f69.google.com with SMTP id f128so2267981wmf.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 01:19:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=TtBLM3c8JTLmBP2uDmSrWuT9/+Pwll6JJwpjBt6QX00=;
 b=Oy5Red8MWAyRw2RXaqNLdUh8Ewv52kLK0DoZhGKH9XrKNpM6PY2iipVkWbykKMfK5A
 gWojPoy8VGrBNB7qDDMAa4mPm79m7B0+LjRv5rsplrRRhSHFz6u7nwF+sRHqqs0P8J/J
 9OOuOGFtJYFTJFeWcAXU9gRp+/xODh+cP+u3Mt/2cb7n4dq+2Vbs3ZB8lwYeAvUvGv85
 gu6aaQnfbz0Nr5a/+2eWStI2CPW7yLeJn2DskvzmAo2dxPy0Mgfn4bH3YDZuP34LgkDx
 /ogl5P6eBhLgJ1ky0U1X5BcxC7RaOvtMaRycqNOD4MN8WC00uugueLcJqjCfkn4hmzHr
 BNKw==
X-Gm-Message-State: AGi0PuYQ8jsuJO+7BoCAKaiNYryorcixrQ5J2MKZsyEchWH9cKdAwiqW
 K2f6S26nmw2cAH+RuMidowrnWFzqWcBkwSlyV4qvRV2UUscHa5ysPzDDWJK1UAQAW51qKDE+WCv
 2KI1NJHRnRXzzIvjQEtWs2mTN
X-Received: by 2002:a05:6000:8b:: with SMTP id
 m11mr8390722wrx.168.1586852341262; 
 Tue, 14 Apr 2020 01:19:01 -0700 (PDT)
X-Google-Smtp-Source: APiQypKNVMzJLyv+Go05DzXWcde1VJnPobjfS5TpC3OSGCsAYJkHQBkL4kr8iyDzRWBXP64iQWFZGA==
X-Received: by 2002:a05:6000:8b:: with SMTP id
 m11mr8390681wrx.168.1586852340970; 
 Tue, 14 Apr 2020 01:19:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e159:eda1:c472:fcfa?
 ([2001:b07:6468:f312:e159:eda1:c472:fcfa])
 by smtp.gmail.com with ESMTPSA id o28sm3426907wra.84.2020.04.14.01.18.59
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 14 Apr 2020 01:19:00 -0700 (PDT)
Subject: Re: [PATCH] kvm_host: unify VM_STAT and VCPU_STAT definitions in a
 single place
To: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>, kvm@vger.kernel.org
References: <20200413140332.22896-1-eesposit@redhat.com>
 <03a481a8-bcf2-8755-d113-71ef393508bf@amsat.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bf870876-9f9a-7ba8-d941-a3883e519eed@redhat.com>
Date: Tue, 14 Apr 2020 10:18:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <03a481a8-bcf2-8755-d113-71ef393508bf@amsat.org>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Wanpeng Li <wanpengli@tencent.com>, David Hildenbrand <david@redhat.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 linuxppc-dev@lists.ozlabs.org
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

T24gMTMvMDQvMjAgMjM6MzQsIFBoaWxpcHBlIE1hdGhpZXUtRGF1ZMOpIHdyb3RlOgo+PiArI2Rl
ZmluZSBWTV9TVEFUKHgsIC4uLikgb2Zmc2V0b2Yoc3RydWN0IGt2bSwgc3RhdC54KSwgS1ZNX1NU
QVRfVk0sICMjIF9fVkFfQVJHU19fCj4+ICsjZGVmaW5lIFZDUFVfU1RBVCh4LCAuLi4pIG9mZnNl
dG9mKHN0cnVjdCBrdm1fdmNwdSwgc3RhdC54KSwgS1ZNX1NUQVRfVkNQVSwgIyMgX19WQV9BUkdT
X18KPiBJIGZpbmQgdGhpcyBtYWNybyBleHBhbmRpbmcgaW50byBtdWx0aXBsZSBmaWVsZHMgb2Rk
Li4uIE1heWJlIGEgbWF0dGVyCj4gb2YgdGFzdGUuIFN1Z2dnZXN0aW9uLCBoYXZlIHRoZSBtYWNy
byBkZWZpbmUgdGhlIGZ1bGwgc3RydWN0dXJlLCBhcyBpbgo+IHRoZSBhcm02NCBhcmNoOgo+IAo+
ICNkZWZpbmUgVk1fU1RBVChuLCB4LCAuLi4pIHsgbiwgb2Zmc2V0b2Yoc3RydWN0IGt2bSwgc3Rh
dC54KSwKPiBLVk1fU1RBVF9WTSwgIyMgX19WQV9BUkdTX18gfQo+IAo+IERpdHRvIGZvciBWQ1BV
X1NUQVQoKS4KPiAKClllcywgdGhhdCdzIGEgZ29vZCBpZGVhLiAgRW1hbnVlbGUsIGNhbiB5b3Ug
c3dpdGNoIGl0IHRvIHRoaXMgZm9ybWF0PwoKVGhhbmtzLAoKUGFvbG8KCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
