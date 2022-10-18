Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 643FEC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 18 Oct 2022 01:13:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDF834B7E6;
	Mon, 17 Oct 2022 21:13:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xnEjbOSSM6k0; Mon, 17 Oct 2022 21:13:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72E1F4B7B0;
	Mon, 17 Oct 2022 21:13:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA1454B733
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 21:13:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RZaSyhcrJ-Ux for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Oct 2022 21:13:30 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71D464B6EE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 21:13:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1666055610;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=PsBDvbs2M4mxVb7McFh5IYYbPQ7mymshNGX5zOJy4Eg=;
 b=LmolN/UYimv3c4uaZ0Iae7GRQwIGssOrO+4Hvdz4sOKfLKqv2tylqqiA91xsqNVAQBGzdn
 A0J2piF7muSVf3DaStVQ5btpmGL9rVKoYW0ic9hGq4p+foW2ZarDiH5rfAZhzzJxdAprND
 4xoHvFSdA3mx6mfmD/6Q6V/ww1jNHsA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-sHvPlOf4OcC8k6B_KEyumA-1; Mon, 17 Oct 2022 21:13:24 -0400
X-MC-Unique: sHvPlOf4OcC8k6B_KEyumA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6ACE833AEC;
 Tue, 18 Oct 2022 01:13:23 +0000 (UTC)
Received: from [10.64.54.70] (vpn2-54-70.bne.redhat.com [10.64.54.70])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F5BC14657C6;
 Tue, 18 Oct 2022 01:13:18 +0000 (UTC)
Subject: Re: [PATCH 5/6] KVM: selftests: memslot_perf_test: Consolidate memory
 sizes
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-6-gshan@redhat.com>
 <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <ac09476d-da8d-db0f-1af2-93dc41251bb0@redhat.com>
Date: Tue, 18 Oct 2022 09:13:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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

T24gMTAvMTgvMjIgNTozNiBBTSwgTWFjaWVqIFMuIFN6bWlnaWVybyB3cm90ZToKPiBPbiAxNC4x
MC4yMDIyIDA5OjE5LCBHYXZpbiBTaGFuIHdyb3RlOgo+PiBUaGUgYWRkcmVzc2VzIGFuZCBzaXpl
cyBwYXNzZWQgdG8gbWFkdmlzZSgpIGFuZCB2bV91c2Vyc3BhY2VfbWVtX3JlZ2lvbl9hZGQoKQo+
PiBzaG91bGQgYmUgYWxpZ25lZCB0byBob3N0IHBhZ2Ugc2l6ZSwgd2hpY2ggY2FuIGJlIDY0S0Ig
b24gYWFyY2g2NC4gU28gaXQncwo+PiB3cm9uZyBieSBwYXNzaW5nIGFkZGl0aW9uYWwgZml4ZWQg
NEtCIG1lbW9yeSBhcmVhIHRvIHZhcmlvdXMgdGVzdHMuCj4+Cj4+IEZpeCBpdCBieSBwYXNzaW5n
IGFkZGl0aW9uYWwgZml4ZWQgNjRLQiBtZW1vcnkgYXJlYSB0byB2YXJpb3VzIHRlc3RzLiBBZnRl
cgo+PiBpdCdzIGFwcGxpZWQsIHRoZSBmb2xsb3dpbmcgY29tbWFuZCB3b3JrcyBmaW5lIG9uIDY0
S0ItcGFnZS1zaXplLWhvc3QgYW5kCj4+IDRLQi1wYWdlLXNpemUtZ3Vlc3QuCj4+Cj4+IMKgwqAg
IyAuL21lbXNsb3RfcGVyZl90ZXN0IC12IC1zIDUxMgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBHYXZp
biBTaGFuIDxnc2hhbkByZWRoYXQuY29tPgo+PiAtLS0KPj4gwqAgLi4uL3Rlc3Rpbmcvc2VsZnRl
c3RzL2t2bS9tZW1zbG90X3BlcmZfdGVzdC5jwqAgfCAxOCArKysrKysrKysrLS0tLS0tLS0KPj4g
wqAgMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pCj4+Cj4+
IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vbWVtc2xvdF9wZXJmX3Rl
c3QuYyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9tZW1zbG90X3BlcmZfdGVzdC5jCj4+
IGluZGV4IGQ1ODdiZDk1MmZmOS4uZTZkMzQ3NDRiNDVkIDEwMDY0NAo+PiAtLS0gYS90b29scy90
ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vbWVtc2xvdF9wZXJmX3Rlc3QuYwo+PiArKysgYi90b29scy90
ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vbWVtc2xvdF9wZXJmX3Rlc3QuYwo+PiBAQCAtMjUsMTIgKzI1
LDE0IEBACj4+IMKgICNpbmNsdWRlIDxrdm1fdXRpbC5oPgo+PiDCoCAjaW5jbHVkZSA8cHJvY2Vz
c29yLmg+Cj4+IC0jZGVmaW5lIE1FTV9TSVpFwqDCoMKgwqDCoMKgwqAgKCg1MTJVIDw8IDIwKSAr
IDQwOTYpCj4+IC0jZGVmaW5lIE1FTV9HUEHCoMKgwqDCoMKgwqDCoCAweDEwMDAwMDAwVUwKPj4g
KyNkZWZpbmUgTUVNX0VYVFJBX1NJWkXCoMKgwqDCoMKgwqDCoCAweDEwMDAwCj4gCj4gU28gdGhl
IGJpZ2dlc3QgcGFnZSBzaXplIHN1cHBvcnRlZCByaWdodCBub3cgaXMgNjQgS2lCIC0gaXQgd291
bGQgYmUKPiBnb29kIHRvIGhhdmUgYW4gYXNzZXJ0IHNvbWV3aGVyZSB0byBleHBsaWNpdGx5IGNo
ZWNrIGZvciB0aGlzCj4gKHJlZ2FyZGxlc3Mgb2YgaW1wbGljaXQgY2hlY2tzIHByZXNlbnQgaW4g
b3RoZXIgY2FsY3VsYXRpb25zKS4KPiAKPiBBbHNvLCBhbiBleHByZXNzaW9uIGxpa2UgIig2NCA8
PCAxMCkiIGlzIG1vcmUgcmVhZGFibGUgdGhhbiBhICIxIgo+IHdpdGggYSB0YWlsIG9mIHplcm9l
cyAoaXQncyBlYXN5IHRvIGFkZCBvbmUgemVybyB0b28gbWFueSBvciBiZSBvbmUKPiB6ZXJvIHNo
b3J0KS4KPiAKClllcywgaXQgbWFrZXMgc2Vuc2UgdG8gbWUuIExldHMgYWRkIGNoZWNrIGluIGNo
ZWNrX21lbW9yeV9zaXplcygpLCB3aGljaAp3YXMgYWRkZWQgaW4gdGhlIHByZXZpb3VzIHBhdGNo
LCB0byBmYWlsIGVhcmx5IGlmIGhvc3QvZ3Vlc3QgcGFnZSBzaXplCmV4Y2VlZHMgNjRLQi4KCiAg
ICBpZiAoaG9zdF9wYWdlX3NpemUgPiBTSVpFXzY0S2lCIHx8IGd1ZXN0X3BhZ2Vfc2l6ZSA+IFNJ
WkVfNjRLaUIpIHsKICAgICAgIHByX2luZm8oIlVuc3VwcG9ydGVkIHBhZ2Ugc2l6ZSBvbiBob3N0
ICgweCV4KSBvciBndWVzdCAoMHgleClcbiIsCiAgICAgICAgICAgICAgIGhvc3RfcGFnZV9zaXpl
LCBndWVzdF9wYWdlX3NpemUpOwogICAgfQoKCkZvciB0aGUgbWFjcm9zLCBJIHRoaW5rIGFsbCBv
ZiB1cyBhZ3JlZSBvbiBLaUIsIE1pQiwgR2lCLCBUaUIgYW5kCnRoZWlyIHZhcmlhbnRzIDopCgpU
aGFua3MsCkdhdmluCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0
cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
