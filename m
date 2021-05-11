Return-Path: <SRS0=u/VZ=KG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14176C433B4
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 17:41:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4732E61378
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 17:41:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4732E61378
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F2FD4B536;
	Tue, 11 May 2021 13:41:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U0hztyTycCFm; Tue, 11 May 2021 13:41:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 553FF4B53B;
	Tue, 11 May 2021 13:41:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D379C4B524
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 13:41:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wXzRFUa-JZX1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 May 2021 13:41:26 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE7544B512
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 13:41:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620754886;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=nl1zPJY8hVLVCv7ebg49anwE3iyxunve5gouX/dXQhM=;
 b=X1h6d3tg/bodM8EyItcUjahrQnrk/WJE1n+2Aj4AtSsI5zOIyeGZRDOKwKrEEQBAD4l0cT
 rfgGF4J42XJ3dUM+p4Vbkby1xeE1I6mysmqPvZdcZxFi8dTFZORXca4EY31gBwQ66p+POg
 540r7dLoVREg+B1bg/jWTf/Vmw6RKi4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-kZe0RGqZPZufQKLTYLDAHw-1; Tue, 11 May 2021 13:41:24 -0400
X-MC-Unique: kZe0RGqZPZufQKLTYLDAHw-1
Received: by mail-ed1-f70.google.com with SMTP id
 r19-20020a05640251d3b02903888eb31cafso11341179edd.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 10:41:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=nl1zPJY8hVLVCv7ebg49anwE3iyxunve5gouX/dXQhM=;
 b=MGQ7/CQVp3s2rTyazj2vcTkvfppI26pvhU1ghNo99Fc2Kdn5FOJJOwuV1wVSXk+y67
 VwgbbBjTTtufasGn72ABbHpGAgMEh9o+SPfVbwbyPFPBTnW2+hreKHBHDLsbkCh/L9Bz
 TKz6xCDGCjFwCn38ByHf0qSx1tKHHXZbLmFBvL+rjHv+bKlwZ+YFIqj8Wb3HuPpvTaUj
 lxU/hxlDdcO/jgwp0FDoYcMitrL5j+ZrTuKTO5bT9vQxQcwGg4mPNLT+3tKsjwljLBs+
 yRMnHJlvKSHS97Li76hoEgnnIAIfVIZi10fV8y5MBDa/3eMPTFMW9KZFzu0BvyDZRmP4
 fj6g==
X-Gm-Message-State: AOAM532KzcviWwGoN6DONA3/wVieRFThDtZWwDiSwVZ/HVLOj0PVlcCo
 flvDHxte1SwnTNENVhYJtC3Gmgj+1q5kIxbCan5FPM0z9XqV51DgyfG1NlYpl8Z1JlmFBVr2BmD
 LOkeAlFwjIiIJT6sqpVWxfP8iU3iGXAcMY1HPdx+BYugVSS5WLvLtbRyycjHVv11i8pdbZJjkX6
 HY
X-Received: by 2002:a17:906:33d8:: with SMTP id
 w24mr32367963eja.28.1620754882635; 
 Tue, 11 May 2021 10:41:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0LBBwBsEgNINK0RaplwIyoZX/ZACJ5Ix5sGIo4CtkV7Z+pIqTURIBWUmLAz0Z/hgsY1rAKA==
X-Received: by 2002:a17:906:33d8:: with SMTP id
 w24mr32367945eja.28.1620754882395; 
 Tue, 11 May 2021 10:41:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id p25sm791740eja.35.2021.05.11.10.41.21
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 11 May 2021 10:41:21 -0700 (PDT)
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 Thomas Huth <thuth@redhat.com>, Andrew Jones <drjones@redhat.com>,
 kvm-devel <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
References: <348f023d-f313-3d98-dc18-b53b6879fe45@arm.com>
 <604b1638-452f-e8e3-b674-014d634e2767@redhat.com>
 <05b5ce5d-4cd8-1fe3-1d2e-d34d4cf31384@arm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests BUG] lib/ldiv32.c breaks arm compilation
Message-ID: <b737d530-35e5-33af-0ea9-de6f507516aa@redhat.com>
Date: Tue, 11 May 2021 19:41:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <05b5ce5d-4cd8-1fe3-1d2e-d34d4cf31384@arm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMTEvMDUvMjEgMTk6MDMsIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6Cj4gSSB0aGluayBpdCdz
IGJlY2F1c2UgSSdtIHVzaW5nIHRoZSphcm0tbm9uZS1lYWJpKiAgdG9vbGNoYWluIGZvciBjb21w
aWxhdGlvbgo+IGluc3RlYWQgb2YgYXJtLWxpbnV4LWdudSwgdGhhdCdzIHRoZSB0b29sY2hhaW4g
Zm9yIGNyb3NzIGNvbXBpbGluZyBhcm0gY29kZSB0aGF0Cj4gaXMgcHJlc2VudCBpbiB0aGUgb2Zm
aWNpYWwgQXJjaCBMaW51eCByZXBvc2l0b3JpZXMuIElzIHRoYXQgdW5zdXBwb3J0ZWQ/IEkgZG9u
J3QKPiByZW1lbWJlciBhbnkgbWVudGlvbiBvZiBpdCBub3QgYmVpbmcgc3VwcG9ydGVkLCBidXQg
aXQncyBlbnRpcmVseSBwb3NzaWJsZSB0aGF0IEkKPiBqdXN0IGZvcmdvdC4KCk5vLCBpdCdzIGp1
c3QgdGhhdCB0aGVyZSB3YXMgbm8gZGlmZmVyZW5jZSB1bnRpbCBub3cuICBJZiB5b3UgY2FuIGFk
ZCBpdCAKdG8gQ0kgd2UgY2FuIG1ha2Ugc3VyZSBpdCBkb2Vzbid0IGJyZWFrLgoKPiBXaXRoIHJl
bSBpbml0aWFsaXplZCB0byAwIEkgZ2V0IHRoaXM6Cj4gCj4gcm0tbm9uZS1lYWJpLWxkIC1ub3N0
ZGxpYiAtVHRleHQ9NDAwMTAwMDAgLW8gYXJtL3NlbGZ0ZXN0LmVsZiAtVAo+IC9ob21lL2FsZXgv
ZGF0YS9yZXBvcy9rdm0tdW5pdC10ZXN0cy9hcm0vZmxhdC5sZHMgXAo+ICDCoMKgwqAgYXJtL3Nl
bGZ0ZXN0Lm8gYXJtL2NzdGFydC5vIGxpYi9saWJjZmxhdC5hIGxpYi9saWJmZHQvbGliZmR0LmEK
PiBsaWIvYXJtL2xpYmVhYmkuYSBhcm0vc2VsZnRlc3QuYXV4Lm8KPiBhcm0tbm9uZS1lYWJpLWxk
OiBsaWIvbGliY2ZsYXQuYShwcmludGYubyk6IGluIGZ1bmN0aW9uIGBwcmludF9pbnQnOgo+IC9o
b21lL2FsZXgvZGF0YS9yZXBvcy9rdm0tdW5pdC10ZXN0cy9saWIvcHJpbnRmLmM6NzI6IHVuZGVm
aW5lZCByZWZlcmVuY2UgdG8KPiBgX19hZWFiaV9sZGl2bW9kJwo+IGFybS1ub25lLWVhYmktbGQ6
IC9ob21lL2FsZXgvZGF0YS9yZXBvcy9rdm0tdW5pdC10ZXN0cy9saWIvcHJpbnRmLmM6NzM6IHVu
ZGVmaW5lZAo+IHJlZmVyZW5jZSB0byBgX19hZWFiaV9sZGl2bW9kJwo+IGFybS1ub25lLWVhYmkt
bGQ6IGxpYi9saWJjZmxhdC5hKHByaW50Zi5vKTogaW4gZnVuY3Rpb24gYHByaW50X3Vuc2lnbmVk
JzoKPiAvaG9tZS9hbGV4L2RhdGEvcmVwb3Mva3ZtLXVuaXQtdGVzdHMvbGliL3ByaW50Zi5jOjEw
MjogdW5kZWZpbmVkIHJlZmVyZW5jZSB0bwo+IGBfX2FlYWJpX3VsZGl2bW9kJwo+IGFybS1ub25l
LWVhYmktbGQ6IGxpYi9saWJjZmxhdC5hKGFsbG9jX3BhZ2Uubyk6IGluIGZ1bmN0aW9uIGBfcGFn
ZV9hbGxvY19pbml0X2FyZWEnOgo+IC9ob21lL2FsZXgvZGF0YS9yZXBvcy9rdm0tdW5pdC10ZXN0
cy9saWIvYWxsb2NfcGFnZS5jOjQ4MjogdW5kZWZpbmVkIHJlZmVyZW5jZSB0bwo+IGBfX2FlYWJp
X3VsZGl2bW9kJwo+IG1ha2U6ICoqKiBbL2hvbWUvYWxleC9kYXRhL3JlcG9zL2t2bS11bml0LXRl
c3RzL2FybS9NYWtlZmlsZS5jb21tb246NjU6Cj4gYXJtL3NlbGZ0ZXN0LmVsZl0gRXJyb3IgMQoK
U28gZm9yIHRoaXMgd2UgbmVlZCB0byBpbmNsdWRlIHRoZSB1bGRpdm1vZCBhbmQgbGRpdm1vZCBm
dW5jdGlvbnMgCnNpbWlsYXIgdG8gdGhvc2UgaW4gCmh0dHBzOi8vYW5kcm9pZC5nb29nbGVzb3Vy
Y2UuY29tL3Rvb2xjaGFpbi9jb21waWxlci1ydC8rL3JlbGVhc2VfMzIvbGliL2FybS4KClRoZSB1
bmluaXRpYWxpemVkIHdhcm5pbmcgaXMgYmVjYXVzZSBvZiB0aGUgZGl2aXNpb24gYnkgemVybyBj
YXNlLiAgSSd2ZSAKc2VudCBhIGNvdXBsZSBwYXRjaGVzIHRvIGZpeCBldmVyeXRoaW5nLCBwbGVh
c2UgcmV2aWV3IQoKUGFvbG8KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVk
dQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
