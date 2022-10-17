Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF262C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 17 Oct 2022 23:11:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4857D4B77F;
	Mon, 17 Oct 2022 19:11:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kjt6NfRTyGGK; Mon, 17 Oct 2022 19:10:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6B424B743;
	Mon, 17 Oct 2022 19:10:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50C514B712
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 19:10:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5-+os-GDMMhD for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Oct 2022 19:10:57 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D493E4B6E2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 19:10:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1666048257;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=HK/sOYAOUF+Wgu2q9ChioZOCXwS8WyiwOj38FtjnWoQ=;
 b=MJyTzfHWlKXoD1bBQECT6V0xpR6mGtycedgOmplHeIClGSBjCNB9xircklo4LnonME7lcs
 744FXdi2klleSfIp9Rn41PQ2Fd/32I7stcgMN2t9KuXcZnTttVEPu8qC0ri9A1nKLk5tzl
 gYxJ6vZOjl9HUWCLFQKAWbEcwxq4t1c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-QxuXVbsQMOqllH4t79Mxvg-1; Mon, 17 Oct 2022 19:10:54 -0400
X-MC-Unique: QxuXVbsQMOqllH4t79Mxvg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D745811E75;
 Mon, 17 Oct 2022 23:10:53 +0000 (UTC)
Received: from [10.64.54.70] (vpn2-54-70.bne.redhat.com [10.64.54.70])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 522972027064;
 Mon, 17 Oct 2022 23:10:47 +0000 (UTC)
Subject: Re: [PATCH 5/6] KVM: selftests: memslot_perf_test: Consolidate memory
 sizes
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
 Sean Christopherson <seanjc@google.com>
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-6-gshan@redhat.com>
 <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
 <Y03ScGUUCA1KwlLF@google.com>
 <9781c88f-06f9-4d17-8fa6-3cd82a739ccb@redhat.com>
 <93529fb7-f558-cc5f-d5bd-7923eb4b492c@maciej.szmigiero.name>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <fd6287fc-c56f-4c08-0885-8ab32fdfeb7e@redhat.com>
Date: Tue, 18 Oct 2022 07:10:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <93529fb7-f558-cc5f-d5bd-7923eb4b492c@maciej.szmigiero.name>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 zhenyzha@redhat.com, shan.gavin@gmail.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
 ajones@ventanamicro.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

T24gMTAvMTgvMjIgNjo1NiBBTSwgTWFjaWVqIFMuIFN6bWlnaWVybyB3cm90ZToKPiBPbiAxOC4x
MC4yMDIyIDAwOjUxLCBHYXZpbiBTaGFuIHdyb3RlOgo+PiBPbiAxMC8xOC8yMiA2OjA4IEFNLCBT
ZWFuIENocmlzdG9waGVyc29uIHdyb3RlOgo+Pj4gT24gTW9uLCBPY3QgMTcsIDIwMjIsIE1hY2ll
aiBTLiBTem1pZ2llcm8gd3JvdGU6Cj4+Pj4+ICsjZGVmaW5lIE1FTV9FWFRSQV9TSVpFwqDCoMKg
wqDCoMKgwqAgMHgxMDAwMAo+Pj4+Cj4+Pj4gQWxzbywgYW4gZXhwcmVzc2lvbiBsaWtlICIoNjQg
PDwgMTApIiBpcyBtb3JlIHJlYWRhYmxlIHRoYW4gYSAiMSIKPj4+PiB3aXRoIGEgdGFpbCBvZiB6
ZXJvZXMgKGl0J3MgZWFzeSB0byBhZGQgb25lIHplcm8gdG9vIG1hbnkgb3IgYmUgb25lCj4+Pj4g
emVybyBzaG9ydCkuCj4+Pgo+Pj4gKzEgdG8gbm90IG9wZW4gY29kaW5nIHJhdyBudW1iZXJzLgo+
Pj4KPj4+IEkgdGhpbmsgaXQncyBoaWdoIHRpbWUgS1ZNIHNlbGZ0ZXN0cyBhZGQgI2RlZmluZXMg
Zm9yIHRoZSBjb21tb24gc2l6ZXMsIGUuZy4gU0laRV80S0IsCj4+PiAxNktCLCA2NEssIDJNQiwg
MUdCLCBldGMuLi4KPj4+Cj4+PiBBbHRlcm5hdGl2ZWx5IChvciBpbiBhZGRpdGlvbiksIGp1c3Qg
I2RlZmluZSAxS0IsIDFNQiwgMUdCLCBhbmQgMVRCLCBhbmQgdGhlbiBkbwo+Pj4gbWF0aCBvZmYg
b2YgdGhvc2UuCj4+Pgo+Pgo+PiBPay4gSSB3aWxsIGhhdmUgb25lIHNlcGFyYXRlIHBhdGNoIHRv
IGRlZmluZSB0aG9zZSBzaXplcyBpbiBrdm1fdXRpbF9iYXNlLmgsCj4+IHJpZ2h0IGFmdGVyICcj
ZGVmaW5lIE5TRUNfUEVSX1NFQyAxMDAwMDAwMDAwTCcuIFNlYW4sIGNvdWxkIHlvdSBsZXQgbWUg
a25vdwo+PiBpZiBpdCBsb29rcyBnb29kIHRvIHlvdT8KPj4KPj4gwqDCoMKgwqAgI2RlZmluZSBL
QsKgwqDCoMKgwqDCoMKgwqAgKDFVTCA8PCAxMCkKPj4gwqDCoMKgwqAgI2RlZmluZSBNQsKgwqDC
oMKgwqDCoMKgwqAgKDFVTCA8PCAyMCkKPj4gwqDCoMKgwqAgI2RlZmluZSBHQsKgwqDCoMKgwqDC
oMKgwqAgKDFVTCA8PCAzMCkKPj4gwqDCoMKgwqAgI2RlZmluZSBUQsKgwqDCoMKgwqDCoMKgwqAg
KDFVTCA8PCA0MCkKPj4KPj4gwqDCoMKgwqAgLyogQmFzZSBwYWdlIGFuZCBodWdlIHBhZ2Ugc2l6
ZSAqLwo+PiDCoMKgwqDCoCAjZGVmaW5lIFNJWkVfNEtCwqDCoCAowqAgNCAqIEtCKQo+PiDCoMKg
wqDCoCAjZGVmaW5lIFNJWkVfMTZLQsKgICggMTYgKiBLQikKPj4gwqDCoMKgwqAgI2RlZmluZSBT
SVpFXzY0S0LCoCAoIDY0ICogS0IpCj4+IMKgwqDCoMKgICNkZWZpbmUgU0laRV8yTULCoMKgICjC
oCAyICogTUIpCj4+IMKgwqDCoMKgICNkZWZpbmUgU0laRV8zMk1CwqAgKCAzMiAqIE1CKQo+PiDC
oMKgwqDCoCAjZGVmaW5lIFNJWkVfNTEyTUIgKDUxMiAqIE1CKQo+PiDCoMKgwqDCoCAjZGVmaW5l
IFNJWkVfMUdCwqDCoCAowqAgMSAqIEdCKQo+PiDCoMKgwqDCoCAjZGVmaW5lIFNJWkVfMTZHQsKg
ICggMTYgKiBHQikKPiAKPiBGWUksIFFFTVUgdXNlcyBLaUIsIE1pQiwgR2lCLCBldGMuLCBzZWUg
WzFdLgo+IAoKUmlnaHQuIEkgY2hlY2tlZCBRRU1VJ3MgZGVmaW5pdGlvbnMgYW5kIGl0IG1ha2Vz
IHNlbnNlIHRvIHVzZQpLaUIsIE1pQiwgR2lCLCBUaUIuIEkgZG9uJ3QgdGhpbmsgd2UgbmVlZCBQ
aUIgYW5kIEVpQiBiZWNhdXNlCm91ciB0ZXN0cyBkb24ndCB1c2UgdGhhdCBsYXJnZSBtZW1vcnku
Cgo+IAo+IFsxXTogaHR0cHM6Ly9naXQucWVtdS5vcmcvP3A9cWVtdS5naXQ7YT1ibG9iO2Y9aW5j
bHVkZS9xZW11L3VuaXRzLmg7aGI9SEVBRAo+IAoKVGhhbmtzLApHYXZpbgoKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdApr
dm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1
L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
