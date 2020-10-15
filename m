Return-Path: <SRS0=68gc=DW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA9B9C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 15 Oct 2020 14:41:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0373421D7F
	for <kvmarm@archiver.kernel.org>; Thu, 15 Oct 2020 14:41:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RH7MHpwT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0373421D7F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 046274B306;
	Thu, 15 Oct 2020 10:41:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zbjYIT-73l0B; Thu, 15 Oct 2020 10:41:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CBEB4B495;
	Thu, 15 Oct 2020 10:41:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56EA94B493
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2020 10:41:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6qSoeKOb8s+F for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Oct 2020 10:41:14 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 338DF4B306
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2020 10:41:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1602772874;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=t5RTNCrw0RODvdauKSr4JiAfyx2/X/h6Lfcvw2l0Yu4=;
 b=RH7MHpwTvlAyd9sypnrzv8Y1G3utLEMMEVt3IYn4j/YUVxPVz4X/E4dUZHCZEWEDQ2zbWU
 eP+RlzruIt+W26RWic5n8FPCzYM3WNSIdiBBdS8bTId5/bhN2G9u6Ks4UOLa2vje8Rt29X
 mi47gND0qf4ZLvZvO+87+6/zaEcCDQ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-6QZb6IlfNneyBb4Ko5Ho8Q-1; Thu, 15 Oct 2020 10:41:10 -0400
X-MC-Unique: 6QZb6IlfNneyBb4Ko5Ho8Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02CC780363D;
 Thu, 15 Oct 2020 14:41:09 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.132])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 01E2455798;
 Thu, 15 Oct 2020 14:41:06 +0000 (UTC)
Date: Thu, 15 Oct 2020 16:41:04 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: Kernel patch cases qemu live migration failed.
Message-ID: <20201015144104.ytwzpxjlsgyun3ob@kamzik.brq.redhat.com>
References: <20201015040639.70C6D414009F@webmail.sinamail.sina.com.cn>
 <7fecfc67da4caab1d677a8b4cd5386b3@kernel.org>
 <20201015133505.ubxvbrt6xyvl4362@kamzik.brq.redhat.com>
 <16400df4bdf79b8b22e824eb1a20e2b4@kernel.org>
MIME-Version: 1.0
In-Reply-To: <16400df4bdf79b8b22e824eb1a20e2b4@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: "Dave.Martin" <dave.martin@arm.com>, xu910121@sina.com,
 kvmarm <kvmarm@lists.cs.columbia.edu>, qemu-devel <qemu-devel@nongnu.org>
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

T24gVGh1LCBPY3QgMTUsIDIwMjAgYXQgMDI6NTI6MzRQTSArMDEwMCwgTWFyYyBaeW5naWVyIHdy
b3RlOgo+IE9uIDIwMjAtMTAtMTUgMTQ6MzUsIEFuZHJldyBKb25lcyB3cm90ZToKPiA+IE9uIFRo
dSwgT2N0IDE1LCAyMDIwIGF0IDEyOjI2OjEwUE0gKzAxMDAsIE1hcmMgWnluZ2llciB3cm90ZToK
PiA+ID4gSGkKPiA+ID4gCj4gPiA+IFBsZWFzZSBkb24ndCB1c2UgbXkgYXJtLmNvbSBhZGRyZXNz
IGFueW1vcmUsIG5vYm9keSByZWFkcyBpdC4uLgo+ID4gPiAKPiA+ID4gT24gMjAyMC0xMC0xNSAw
NTowNiwg5byg5Lic5petIHdyb3RlOgo+ID4gPiA+IEknbSBzbyBzb3JyeSBmb3IgZGlzdHVyYmlu
ZyB5b3UuCj4gPiA+ID4KPiA+ID4gPiBXaGVuIEkgYXBwbHkgdGhpcyBrZXJuZWwgcGF0Y2jvvJpL
Vk06IGFybTY0L3N2ZTogU3lzdGVtIHJlZ2lzdGVyCj4gPiA+ID4gY29udGV4dCBzd2l0Y2ggYW5k
IGFjY2VzcyBzdXBwb3J0Cj4gPiA+ID4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xp
bnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0L2NvbW1pdC9hcmNoL2FybTY0L2t2bS9z
eXNfcmVncy5jP2lkPTczNDMzNzYyZmNhZWI5ZDU5ZTg0ZDI5OTAyMWM2YjE1NDY2Yzk2ZGQKPiA+
ID4gCj4gPiA+IFRoaXMgcGF0Y2ggd2FzIG9ubHkgaW50cm9kdWNlZCBpbiA1LjIsIGFuZCB3YXNu
J3Qgc3VwcG9zZWQgdG8gYmUKPiA+ID4gYmFja3BvcnRlZCB0byBhbnl0aGluZyBlbHNlLgo+ID4g
Cj4gPiBBbGwgdXBzdHJlYW0gcGF0Y2hlcyBhcmUgYmFja3BvcnQgY2FuZGlkYXRlcy4gV2VsY29t
ZSB0byBSSEVMIDotKQo+IAo+IEdyZWF0ISBSSEVMIGdldHMgdG8ga2VlcCB0aGUgcGllY2VzISA7
LSkKPiAKPiA+IAo+ID4gPiAKPiA+ID4gPiBxZW11IGxpdmUgbWlncmF0aW9uIHdpbGwgZmFpbGVk
IHdpdGggbWVzc2FnZXPvvJoKPiA+ID4gPiAgICAgICAgICAgICAgIOKAi3FlbXUta3ZtOiBJbnZh
bGlkIHZhbHVlIDIzMyBleHBlY3RpbmcgcG9zaXRpdmUgdmFsdWUKPiA+ID4gPiA8PSAyMzIKPiA+
ID4gPiAgICAgICAgICAgICAgIHFlbXUta3ZtOiBGYWlsZWQgdG8gbG9hZCBjcHU6Y3ByZWdfdm1z
dGF0ZV9hcnJheV9sZW4KPiA+ID4gPiBOZXcgdmVyc2lvbiBrZXJuZWwgIGV4Y2x1ZGUgSURfQUE2
NFpGUjBfRUwxIHJlZ2lzdGVyIHdoZW4gaG9zdCBub3QKPiA+ID4gPiBzdXBwb3J0IFNWRSBmZWF0
dXJlLAo+ID4gPiA+IHNvIHFlbXUgaW9jdGwga3ZtKEtWTV9HRVRfUkVHX0xJU1QpIHdpbGwgbm90
IGNvbnRhaW4gSURfQUE2NFpGUjBfRUwxCj4gPiA+ID4gcmVnaXN0ZXIuCj4gPiA+ID4KPiA+ID4g
PiBJJ20gdXNpbmcgQ2VudE9TIExpbnV4IGtlcm5lbCwgb2xkIGtlcm5lbCB2ZXJzaW9u77yaNC4x
OC4wLTgwLjExLmVsOAo+ID4gPiA+IChtaWdyYXRpb24gc291cmNlKQo+ID4gPiA+ICAgICAgIG5l
dyBrZXJuZWwgdmVyc2lvbu+8mjQuMTguMC0xNDcuNS5lbDggKG1pZ3JhdGlvbiBkZXN0aW5hdGlv
bikKPiA+ID4gPgo+ID4gPiA+IENlbnRPUyBsaW51eCBrZXJuZWwgdmVyc2lvbiA0LjE4LjAtMTEx
LmVsOCBhcHBsaWVkIHRoaXMgcGF0Y2guIFNvCj4gPiA+ID4gNC4xOC4wLTE0Ny41LmVsOCBhbHNv
IGFwcGxpZWQgdGhpcyBwYXRjaC4KPiA+ID4gPgo+ID4gPiA+IE1pZ3JhdGlvbiBzb3VyY2UgYW5k
IGRlc3RpbmF0aW9uIGhvc3RzIGhhdmUgdGhlIHNhbWUgaGFyZHdhcmUsIGp1c3QKPiA+ID4gPiBr
ZXJuZWwgdmVyc2lvbiBpcyBkaWZmZXJlbnQsCj4gPiA+ID4gYW5kIHRoZSBoYXJkd2FyZSBvbiBl
aXRoZXIgc2lkZSBvZiB0aGUgbWlncmF0aW9uIG5vdCBzdXBwb3J0IFNWRS4KPiA+ID4gPgo+ID4g
PiA+IElzIHRoZXJlIHNvbWUgZ29vZCBzdWdnZXN0aW9uc++8jHdoaWNoIGNhbiBtYWtlIHN1cmUg
b2xkIHZlcnNpb24KPiA+ID4gPiBrZXJuZWwgbGl2ZSBtaWdyYXRpb24gdG8gbmV3IHZlcnNpb24g
a2VybmVsIHdpdGggcWVtdT8KPiA+ID4gCj4gPiA+IElbJ20gYWZyYWlkIHlvdSBzaG91bGQgdGFr
ZSB0aGlzIHdpdGggeW91ciBkaXN0cmlidXRpb24gb2YKPiA+ID4gY2hvaWNlLCB1bmxlc3MgeW91
IGNhbiByZXByb2R1Y2UgdGhlIHByb2JsZW0gd2l0aCBtYWlubGluZSBrZXJuZWxzLgo+ID4gCj4g
PiBJJ2xsIGJldCB0aGlzIHJlcHJvZHVjZXMgd2hlbiBtaWdyYXRpbmcgZnJvbSBhIG1haW5saW5l
IHByZSBTVkUgcmVnaXN0ZXIKPiA+IGZpbHRlcmluZyBrZXJuZWwgdG8gYSBtYWlubGluZSB0aGF0
IGRvZXMgdGhlIGZpbHRlcmluZy4gSSBkb24ndCBoYXZlCj4gPiB0aW1lIHRvIHRlc3QgdGhhdCB0
aG91Z2guCj4gCj4gUHJvYmFibHkuIEknbSBub3QgcmVhbGx5IHN1cmUgd2hlcmUgdG8gZmluZCBT
VkUgSFcgdGhvdWdoLCBvdGhlcgo+IHRoYW4gZW11bGF0aW9uLi4uCj4KClRoZSByZXBvcnRlciBz
dGF0ZXMgbmVpdGhlciB0aGUgc291cmNlIG5vciBkZXN0aW5hdGlvbiBoYXJkd2FyZSBzdXBwb3J0
cwpTVkUuIE15IGd1ZXNzIGlzIHRoYXQgd2hhdCdzIGhhcHBlbmluZyBpcyB0aGUgcmVzZXJ2ZWQg
SUQgcmVnaXN0ZXIKSURfVU5BTExPQ0FURUQoNCw0KSB3YXMgc2hvd2luZyB1cCBpbiB0aGUgS1ZN
X0dFVF9SRUdfTElTVCBjb3VudCBvbgp0aGUgb2xkIGtlcm5lbCwgYnV0IHRoZSBuZXcga2VybmVs
IGZpbHRlcnMgaXQgb3V0LiBNYXliZSBpdCBpcyBhCmJ1ZyB0byBmaWx0ZXIgaXQgb3V0IG9mIHRo
ZSBjb3VudCwgYXMgaXQncyBhIHJlc2VydmVkIElEIHJlZ2lzdGVyIGFuZApJIHN1cHBvc2UgdGhl
IG90aGVyIHJlc2VydmVkIElEIHJlZ2lzdGVycyBhcmUgc3RpbGwgc2hvd2luZyB1cD8KClRoYW5r
cywKZHJldyAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
