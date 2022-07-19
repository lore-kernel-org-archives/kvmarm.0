Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15771CCA479
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 23:40:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B21A4CD2F;
	Mon, 18 Jul 2022 19:40:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oSL4cp-l3VTw; Mon, 18 Jul 2022 19:40:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3427B4CD3E;
	Mon, 18 Jul 2022 19:40:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A71B94CD2B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 19:40:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VIeF9SuZpO8C for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 19:40:49 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77C6A4CD2A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 19:40:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1658187649;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=3dTnes+KzHJaFJH05bFK49SXDq+onLA3FIpvx1ZPC08=;
 b=T/zFfFE/aHIIxMMeiDjlaI5gecR09e8VYEspefs4J4me3Qg17TpfV+VdRILinCzmiK+8np
 /owgvKlhZCDtEk0Gx3IJpdOmNKsaiTw/fyACEDcx7DFLdT56Aa1pv3CX8f6Fcp3sO0TnGd
 9bS9BE65lxgmSKnE0q4rBRSTONYTJXI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-265-Oq18XETuPuGoD7EdNskPDQ-1; Mon, 18 Jul 2022 19:40:43 -0400
X-MC-Unique: Oq18XETuPuGoD7EdNskPDQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34759101A54E;
 Mon, 18 Jul 2022 23:40:43 +0000 (UTC)
Received: from [10.64.54.37] (vpn2-54-37.bne.redhat.com [10.64.54.37])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4916B1121314;
 Mon, 18 Jul 2022 23:40:38 +0000 (UTC)
Subject: Re: [PATCH v2] KVM: selftests: Fix target thread to be migrated in
 rseq_test
From: Gavin Shan <gshan@redhat.com>
To: oliver.upton@linux.dev, kvmarm@lists.cs.columbia.edu
References: <20220716144537.3436743-1-gshan@redhat.com>
 <385aa28ad559874da8429c40a68570df@linux.dev>
 <4bdaa1cd-39f4-97d7-ba33-ee5cdc7d609e@redhat.com>
Message-ID: <087c2e7e-998a-b807-0b4e-3c42aca1b5f7@redhat.com>
Date: Tue, 19 Jul 2022 11:40:18 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <4bdaa1cd-39f4-97d7-ba33-ee5cdc7d609e@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Cc: shan.gavin@gmail.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
 shuah@kernel.org
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

T24gNy8xNy8yMiAxOjExIFBNLCBHYXZpbiBTaGFuIHdyb3RlOgo+IE9uIDcvMTcvMjIgNzo0OCBB
TSwgb2xpdmVyLnVwdG9uQGxpbnV4LmRldiB3cm90ZToKPj4gSnVseSAxNiwgMjAyMiA3OjQ1IEFN
LCAiR2F2aW4gU2hhbiIgPGdzaGFuQHJlZGhhdC5jb20+IHdyb3RlOgo+Pj4gSW4gcnNlcV90ZXN0
LCB0aGVyZSBhcmUgdHdvIHRocmVhZHMsIHdoaWNoIGFyZSB0aHJlYWQgZ3JvdXAgbGVhZGVyCj4+
PiBhbmQgbWlncmF0aW9uIHdvcmtlci4gVGhlIG1pZ3JhdGlvbiB3b3JrZXIgcmVsaWVzIG9uIHNj
aGVkX3NldGFmZmluaXR5KCkKPj4+IHRvIGZvcmNlIG1pZ3JhdGlvbiBvbiB0aGUgdGhyZWFkIGdy
b3VwIGxlYWRlci4KPj4KPj4gSXQgbWF5IGJlIGNsZWFyZXIgdG8gZGVzY3JpYmUgaXQgYXMgYSB2
Q1BVIHRocmVhZCBhbmQgYSBtaWdyYXRpb24gd29ya2VyCj4+IHRocmVhZC4gVGhlIG1lYXQgb2Yg
dGhpcyB0ZXN0IGlzIHRvIGNhdGNoIGEgcmVncmVzc2lvbiBpbiBLVk0uCj4+Cj4+PiBVbmZvcnR1
bmF0ZWx5LCB3ZSBoYXZlCj4+Cj4+IHMvd2UgaGF2ZS90aGUgdGVzdCBoYXMgdGhlLwo+Pgo+Pj4g
d3JvbmcgcGFyYW1ldGVyICgwKSBwYXNzZWQgdG8gc2NoZWRfZ2V0YWZmaW5pdHkoKS4KPj4KPj4g
d3JvbmcgUElECj4+Cj4gCj4gWWVwLCBpdCdzIG11Y2ggY2xlYXJlciB0byBkZXNjcmliZSBpdCBh
cyB2Q1BVIHRocmVhZCBhbmQgbWlncmF0aW9uIHdvcmtlci4KPiAKPj4+IEl0J3MgYWN0dWFsbHkK
Pj4+IGZvcmNpbmcgbWlncmF0aW9uIG9uIHRoZSBtaWdyYXRpb24gd29ya2VyIGluc3RlYWQgb2Yg
dGhlIHRocmVhZCBncm91cAo+Pj4gbGVhZGVyLgo+Pgo+PiBXaGF0J3MgbWlzc2luZyBpcyBfd2h5
XyB0aGUgbWlncmF0aW9uIHdvcmtlciBpcyBnZXR0aW5nIG1vdmVkIGFyb3VuZCBieQo+PiB0aGUg
Y2FsbC4gUGVyaGFwcyBpbnN0ZWFkIGl0IGlzIGJldHRlciB0byBzdGF0ZSB3aGF0IGEgUElEIG9m
IDAgaW1wbGllcywKPj4gZm9yIHRob3NlIG9mIHVzIHdobyBoYXZlbid0IHJlYWQgdGhlaXIgbWFu
cGFnZXMgaW4gYSB3aGlsZSA7LSkKPj4KPiAKPiBZZXMsIGl0J3MgZ29vZCBpZGVhLiBJIHdpbGwg
aGF2ZSBzb21ldGhpbmcgbGlrZSBiZWxvdyBpbiBuZXh0IHJldmlzaW9uIDopCj4gCj4gIMKgwqDC
oCBJbiByc2VxX3Rlc3QsIHRoZXJlIGFyZSB0d28gdGhyZWFkcywgd2hpY2ggYXJlIHZDUFUgdGhy
ZWFkIGFuZCBtaWdyYXRpb24KPiAgwqDCoMKgIHdvcmtlciBzZXBhcmF0ZWx5LiBVbmZvcnR1bmF0
ZWx5LCB0aGUgdGVzdCBoYXMgdGhlIHdyb25nIFBJRCBwYXNzZWQgdG8KPiAgwqDCoMKgIHNjaGVk
X3NldGFmZmluaXR5KCkgaW4gdGhlIG1pZ3JhdGlvbiB3b3JrZXIuIEl0IGZvcmNlcyBtaWdyYXRp
b24gb24gdGhlCj4gIMKgwqDCoCBtaWdyYXRpb24gd29ya2VyIGJlY2F1c2UgemVyb2VkIFBJRCBy
ZXByZXNlbnRzIHRoZSBjYWxsaW5nIHRocmVhZCwgd2hpY2gKPiAgwqDCoMKgIGlzIHRoZSBtaWdy
YXRpb24gd29ya2VyIGl0c2VsZi4gSXQgbWVhbnMgdGhlIHZDUFUgdGhyZWFkIGlzIG5ldmVyIGVu
Zm9yY2VkCj4gIMKgwqDCoCB0byBtaWdyYXRpb24gYW5kIGl0IGNhbiBtaWdyYXRlIGF0IGFueSB0
aW1lLCB3aGljaCBldmVudHVhbGx5IGxlYWRzIHRvCj4gIMKgwqDCoCBmYWlsdXJlIGFzIHRoZSBm
b2xsb3dpbmcgbG9ncyBzaG93Lgo+ICDCoMKgwqDCoMKgwqDCoCA6Cj4gIMKgwqDCoMKgwqDCoMKg
IDoKPiAgwqDCoMKgIEZpeCB0aGUgaXNzdWUgYnkgcGFzc2luZyBjb3JyZWN0IHBhcmFtZXRlciwg
VElEIG9mIHRoZSB2Q1BVIHRocmVhZCwgdG8KPiAgwqDCoMKgIHNjaGVkX3NldGFmZmluaXR5KCkg
aW4gdGhlIG1pZ3JhdGlvbiB3b3JrZXIuCj4gCj4gCj4+PiBJdCBhbHNvIG1lYW5zIG1pZ3JhdGlv
biBjYW4gaGFwcGVuIG9uIHRoZSB0aHJlYWQgZ3JvdXAgbGVhZGVyCj4+PiBhdCBhbnkgdGltZSwg
d2hpY2ggZXZlbnR1YWxseSBsZWFkcyB0byBmYWlsdXJlIGFzIHRoZSBmb2xsb3dpbmcgbG9ncwo+
Pj4gc2hvdy4KPj4+Cj4+PiBob3N0IyB1bmFtZSAtcgo+Pj4gNS4xOS4wLXJjNi1nYXZpbisKPj4+
IGhvc3QjICMgY2F0IC9wcm9jL2NwdWluZm8gfCBncmVwIHByb2Nlc3NvciB8IHRhaWwgLW4gMQo+
Pj4gcHJvY2Vzc29yIDogMjIzCj4+PiBob3N0IyBwd2QKPj4+IC9ob21lL2dhdmluL3NhbmRib3gv
bGludXgubWFpbi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0KPj4+IGhvc3QjIGZvciBpIGlu
IGBzZXEgMSAxMDBgOyBcCj4+PiBkbyBlY2hvICItLS0tLS0tLT4gJGkiOyAuL3JzZXFfdGVzdDsg
ZG9uZQo+Pj4gLS0tLS0tLS0+IDEKPj4+IC0tLS0tLS0tPiAyCj4+PiAtLS0tLS0tLT4gMwo+Pj4g
LS0tLS0tLS0+IDQKPj4+IC0tLS0tLS0tPiA1Cj4+PiAtLS0tLS0tLT4gNgo+Pj4gPT09PSBUZXN0
IEFzc2VydGlvbiBGYWlsdXJlID09PT0KPj4+IHJzZXFfdGVzdC5jOjI2NTogcnNlcV9jcHUgPT0g
Y3B1Cj4+PiBwaWQ9MzkyNSB0aWQ9MzkyNSBlcnJubz00IC0gSW50ZXJydXB0ZWQgc3lzdGVtIGNh
bGwKPj4+IDEgMHgwMDAwMDAwMDAwNDAxOTYzOiBtYWluIGF0IHJzZXFfdGVzdC5jOjI2NSAoZGlz
Y3JpbWluYXRvciAyKQo+Pj4gMiAweDAwMDBmZmZmYjA0NGFmZmI6ID8/ID8/OjAKPj4+IDMgMHgw
MDAwZmZmZmIwNDRiMGM3OiA/PyA/PzowCj4+PiA0IDB4MDAwMDAwMDAwMDQwMWE2ZjogX3N0YXJ0
IGF0ID8/Oj8KPj4+IHJzZXEgQ1BVID0gNCwgc2NoZWQgQ1BVID0gMjcKPj4+Cj4+PiBUaGlzIGZp
eGVzIHRoZSBpc3N1ZSBieSBwYXNzaW5nIGNvcnJlY3QgcGFyYW1ldGVyLCB0aWQgb2YgdGhlIGdy
b3VwCj4+PiB0aHJlYWQgbGVhZGVyLCB0byBzY2hlZF9zZXRhZmZpbml0eSgpLgo+Pgo+PiBLZXJu
ZWwgY29tbWl0IG1lc3NhZ2VzIHNob3VsZCBoYXZlIGFuIGltcGVyYXRpdmUgdG9uZToKPj4KPj4g
Rml4IHRoZSBpc3N1ZSBieSAuLi4KPj4KPiAKPiBPay4gSSd2ZSBiZWVuIGhhdmluZyBteSBzdHls
ZSBmb3IgbG9uZyB0aW1lLiBBY3R1YWxseSwgdGhlIHN0eWxlIHdhcwo+IHNoYXJlZCBieSBzb21l
IG9uZSB3aGVuIEkgd29ya2VkIGZvciBJQk0gbG9uZyB0aW1lIGFnby4gSSB3aWxsIGJlYXIKPiBp
dCBpbiBtaW5kIHRvIHVzZSBpbXBlcmF0aXZlIGV4cHJlc3Npb24gc2luY2Ugbm93IG9uIDopCj4g
Cj4gQWxsIHlvdXIgY29tbWVudHMgd2lsbCBiZSBmaXhlZCBpbiBuZXh0IHJldmlzaW9uLCBidXQg
SSB3b3VsZCBkZWxheQo+IHRoZSBwb3N0aW5nIGEgYml0IHRvIHNlZSBTZWFuIG9yIFBhb2xvIGhh
dmUgbW9yZSBjb21tZW50cy4gSW4gdGhhdAo+IGNhc2UsIEkgY2FuIGZpeCBhbGwgb2YgdGhlbSBh
dCBvbmNlLgo+IAoKdjMgd2FzIGp1c3QgcG9zdGVkLgoKaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
a3ZtYXJtLzIwMjIwNzE5MDEzNTQwLjM0Nzc5NDYtMS1nc2hhbkByZWRoYXQuY29tL1QvI3UKCj4+
PiBGaXhlczogNjFlNTJmMTYzMGY1ICgiS1ZNOiBzZWxmdGVzdHM6IEFkZCBhIHRlc3QgZm9yIEtW
TV9SVU4rcnNlcSB0byBkZXRlY3QgdGFzayBtaWdyYXRpb24gYnVncyIpCj4+PiBTaWduZWQtb2Zm
LWJ5OiBHYXZpbiBTaGFuIDxnc2hhbkByZWRoYXQuY29tPgo+Pgo+PiBXaXRoIHRoZSBjb21tZW50
cyBvbiB0aGUgY29tbWl0IG1lc3NhZ2UgYWRkcmVzc2VkOgo+Pgo+PiBSZXZpZXdlZC1ieTogT2xp
dmVyIFVwdG9uIDxvbGl2ZXIudXB0b25AbGludXguZGV2Pgo+PgoKVGhhbmtzLApHYXZpbgoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxp
bmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29s
dW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
