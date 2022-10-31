Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE08FA3741
	for <kvmarm@archiver.kernel.org>; Mon, 31 Oct 2022 22:51:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EF234BAC9;
	Mon, 31 Oct 2022 18:51:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VvT32q70Ph0A; Mon, 31 Oct 2022 18:49:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A1824BA59;
	Mon, 31 Oct 2022 18:49:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C1DD4BA3C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Oct 2022 18:49:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MCgOR+xwhjsa for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Oct 2022 18:48:58 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FF5C4BA33
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Oct 2022 18:48:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667256534;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=BC6zO98Q8uKfNSR6EZGsLuEsjcHYX+7BdvJInvGMYP0=;
 b=KH/shUwFjZL+JxeXiRQ7dHpmzCsXvLJ5Pnx0F7iqgVl9VKZjQvsyFoNdWjaY3ICw9XShig
 6kgtQVYYyeS8n9Yfe55mmCST4Am912WZoPDBnDYAdJ5JD2+vqjLSYEZCIGbCwTw/yJekh5
 TVK5dCTkljYkoMkJg3xlPEoI27/1g+8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269-3jRxnHRDO4ah6fqU3o_hDw-1; Mon, 31 Oct 2022 18:48:47 -0400
X-MC-Unique: 3jRxnHRDO4ah6fqU3o_hDw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BAD785A583;
 Mon, 31 Oct 2022 22:48:46 +0000 (UTC)
Received: from [10.64.54.151] (vpn2-54-151.bne.redhat.com [10.64.54.151])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BEB082166B29;
 Mon, 31 Oct 2022 22:48:39 +0000 (UTC)
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
To: Marc Zyngier <maz@kernel.org>, Sean Christopherson <seanjc@google.com>
References: <Y1LDRkrzPeQXUHTR@google.com> <87edv0gnb3.wl-maz@kernel.org>
 <Y1ckxYst3tc0LCqb@google.com> <Y1css8k0gtFkVwFQ@google.com>
 <878rl4gxzx.wl-maz@kernel.org> <Y1ghIKrAsRFwSFsO@google.com>
 <877d0lhdo9.wl-maz@kernel.org> <Y1rDkz6q8+ZgYFWW@google.com>
 <875yg5glvk.wl-maz@kernel.org>
 <36c97b96-1427-ce05-8fce-fd21c4711af9@redhat.com>
 <Y1wIj/sdJw7VMiY5@google.com> <9e57cd7616974c783cce5026d61d310b@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <b6ae2d5c-4974-6e1a-e65d-206104ba97ed@redhat.com>
Date: Tue, 1 Nov 2022 06:48:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <9e57cd7616974c783cce5026d61d310b@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Cc: shuah@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, dmatlack@google.com, shan.gavin@gmail.com,
 bgardon@google.com, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 zhenyzha@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

T24gMTAvMzEvMjIgNTowOCBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIwMjItMTAtMjgg
MTc6NTEsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6Cj4+IE9uIEZyaSwgT2N0IDI4LCAyMDIy
LCBHYXZpbiBTaGFuIHdyb3RlOgo+Pj4gT24gMTAvMjgvMjIgMjozMCBBTSwgTWFyYyBaeW5naWVy
IHdyb3RlOgo+Pj4gPiBPbiBUaHUsIDI3IE9jdCAyMDIyIDE4OjQ0OjUxICswMTAwLAo+Pj4gPiA+
IE9uIFRodSwgT2N0IDI3LCAyMDIyLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+PiA+ID4gPiBPbiBU
dWUsIDI1IE9jdCAyMDIyIDE4OjQ3OjEyICswMTAwLCBTZWFuIENocmlzdG9waGVyc29uIDxzZWFu
amNAZ29vZ2xlLmNvbT4gd3JvdGU6CgpbLi4uXQoKPj4+Cj4+PiBJdCdzIHJlYWxseSBhICdtYWpv
ciBzdXJnZXJ5JyBhbmQgSSB3b3VsZCBsaWtlIHRvIG1ha2Ugc3VyZSBJIGZ1bGx5IHVuZGVyc3Rh
bmQKPj4+ICdhIGNvbXBsZXRlbHkgc2VwYXJhdGUgQVBJIGZvciB3cml0aW5nIGd1ZXN0IG1lbW9y
eSB3aXRob3V0IGFuIGFzc29jaWF0ZWQgdkNQVSIsCj4+PiBiZWZvcmUgSSdtIGdvaW5nIHRvIHdv
cmtpbmcgb24gdjcgZm9yIHRoaXMuCj4+Pgo+Pj4gVGhlcmUgYXJlIDcgZnVuY3Rpb25zIGFuZCAy
IG1hY3JvcyBpbnZvbHZlZCBhcyBiZWxvdy4gSSBhc3N1bWUgU2VhbiBpcyBzdWdnZXN0aW5nCj4+
PiB0byBhZGQgYW5vdGhlciBhcmd1bWVudCwgd2hvc2UgbmFtZSBjYW4gYmUgJ2hhc192Y3B1Jywg
Zm9yIHRoZXNlIGZ1bmN0aW9ucyBhbmQgbWFjcm9zPwo+Pgo+PiBOby4KPj4KPj4gQXMgTWFyY2gg
c3VnZ2VzdGVkLCBmb3IgeW91ciBzZXJpZXMganVzdCBpbXBsZW1lbnQgdGhlIGhhY2t5IGFyY2gg
b3B0LW91dCwgZG9uJ3QKPiAKPiBQbGVhc2UgY2FsbCBtZSBBcHJpbC4KPiAKPj4gdHJ5IGFuZCBk
byBzdXJnZXJ5IGF0IHRoaXMgdGltZSBhcyB0aGF0J3MgbGlrZWx5IGdvaW5nIHRvIGJlIGEKPj4g
bW9udGhzLWxvbmcgZWZmb3J0Cj4+IHRoYXQgdG91Y2hlcyBhIGxvdCBvZiBjcm9zcy1hcmNoIGNv
ZGUuCj4+Cj4+IEUuZy4gSSBiZWxpZXZlIHRoZSBBUk0gb3B0LW91dCAob3B0LWluPykgZm9yIHRo
ZSBhYm92ZSBoYWNrIHdvdWxkIGJlCj4+Cj4+IGJvb2wga3ZtX2FyY2hfYWxsb3dfd3JpdGVfd2l0
aG91dF9ydW5uaW5nX3ZjcHUoc3RydWN0IGt2bSAqa3ZtKQo+PiB7Cj4+IMKgwqDCoMKgcmV0dXJu
IHZnaWNfaGFzX2l0cyhrdm0pOwo+PiB9Cj4gCj4gQWx0aG91Z2ggdGhhdCB3aWxsIHByb2JhYmx5
IGxlYWQgdG8gdGhlIGV4cGVjdGVkIGVmZmVjdCwKPiB0aGlzIGhlbHBlciBzaG91bGQgb25seSBy
ZXR1cm4gdHJ1ZSB3aGVuIHRoZSBJVFMgaXMgYWN0aXZlbHkKPiBkdW1wZWQuCj4gCgpUaGFua3Ms
IE1hcmMuIEl0IG1ha2VzIHNlbnNlIHRvIHJldHVybiB0cnVlIG9ubHkgd2hlbiB2Z2ljL2l0cyB0
YWJsZXMKYXJlIGJlaW5nIHNhdmVkLiBMZXRzIGhhdmUgbW9yZSBkaXNjdXNzaW9uIGluIFBBVENI
W3Y3IDUvOV0gc2luY2UgT2xpdmVyCmhhcyBvdGhlciBjb25jZXJucyB0aGVyZSA6KQoKVGhhbmtz
LApHYXZpbgoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
