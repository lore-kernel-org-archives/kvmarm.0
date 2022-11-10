Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F5FC4332F
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 10:54:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 756214BA59;
	Thu, 10 Nov 2022 05:54:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FLpw3PYIenUT; Thu, 10 Nov 2022 05:54:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F1604BA61;
	Thu, 10 Nov 2022 05:54:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06D624BA37
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 05:54:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oBQXHHNLvFCi for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Nov 2022 05:54:25 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A266A4BA22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 05:54:25 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1668077665;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=NpgGU2I/tE+Cblp78lY33qKu10Xyg6kfJBT0/tIEJsk=;
 b=Igge6aljXd5v4zr4eAF4ID5vY/4wmAbvVK9Vn9PzLKqXa8L0g+SVATkrQ6dR3wOlcIyJDn
 CPbvTOxazJ8QjRRv4IownQ048NrYdxeheL4tvkVFpLOfySKROuDmPuLMJRVI9JBone0yXg
 PQ9f0uV2HTmpZGSJJgglX3cGCb526ok=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-317-7OyvaXjfPfyzXgoyEastcg-1; Thu, 10 Nov 2022 05:54:22 -0500
X-MC-Unique: 7OyvaXjfPfyzXgoyEastcg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6779F833AEF;
 Thu, 10 Nov 2022 10:54:21 +0000 (UTC)
Received: from [10.64.54.49] (vpn2-54-49.bne.redhat.com [10.64.54.49])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 44E19C1908A;
 Thu, 10 Nov 2022 10:54:15 +0000 (UTC)
Subject: Re: [PATCH v3 0/6] KVM: selftests: memslot_perf_test: aarch64
 cleanup/fixes
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
References: <20221020071209.559062-1-gshan@redhat.com>
 <91d563b6-5f1c-5ecc-0a40-7d8838770b22@maciej.szmigiero.name>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <3903eeef-e037-9651-6041-0d16c29d67b0@redhat.com>
Date: Thu, 10 Nov 2022 18:54:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <91d563b6-5f1c-5ecc-0a40-7d8838770b22@maciej.szmigiero.name>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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

SGkgTWFyYywKCk9uIDEwLzI1LzIyIDc6MTggQU0sIE1hY2llaiBTLiBTem1pZ2llcm8gd3JvdGU6
Cj4gT24gMjAuMTAuMjAyMiAwOToxMiwgR2F2aW4gU2hhbiB3cm90ZToKPj4ga3ZtL3NlbGZ0ZXN0
cy9tZW1zbG90c19wZXJmX3Rlc3QgZG9lc24ndCB3b3JrIHdpdGggNjRLQi1wYWdlLXNpemUtaG9z
dAo+PiBhbmQgNEtCLXBhZ2Utc2l6ZS1ndWVzdCBvbiBhYXJjaDY0LiBJbiB0aGUgaW1wbGVtZW50
YXRpb24sIHRoZSBob3N0IGFuZAo+PiBndWVzdCBwYWdlIHNpemUgaGF2ZSBiZWVuIGhhcmRjb2Rl
ZCB0byA0S0IuIEl0J3Mgb3ZiaW91c2x5IG5vdCB3b3JraW5nCj4+IG9uIGFhcmNoNjQgd2hpY2gg
c3VwcG9ydHMgNEtCLCAxNktCLCA2NEtCIGluZGl2aWR1YWxseSBvbiBob3N0IGFuZCBndWVzdC4K
Pj4KPj4gVGhpcyBzZXJpZXMgdHJpZXMgdG8gZml4IGl0LiBBZnRlciB0aGUgc2VyaWVzIGlzIGFw
cGxpZWQsIHRoZSB0ZXN0IHJ1bnMKPj4gc3VjY2Vzc2Z1bGx5IHdpdGggNjRLQi1wYWdlLXNpemUt
aG9zdCBhbmQgNEtCLXBhZ2Utc2l6ZS1ndWVzdC4KPj4KPj4gwqDCoMKgICMgLi9tZW1zbG90c19w
ZXJmX3Rlc3RzIC12IC1zIDUxMgo+Pgo+PiBTaW5jZSB3ZSdyZSBoZXJlLCB0aGUgY29kZSBpcyBj
bGVhbmVkIHVwIGEgYml0IGFzIFBBVENIWzEtM10gZG8uIFRoZQo+PiBvdGhlciBwYXRjaGVzIGFy
ZSBmaXhlcyB0byBoYW5kbGUgdGhlIG1pc21hdGNoZWQgaG9zdC9ndWVzdCBwYWdlCj4+IHNpemVk
Lgo+Pgo+PiB2MTogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtYXJtLzIwMjIxMDE0MDcxOTE0
LjIyNzEzNC0xLWdzaGFuQHJlZGhhdC5jb20vVC8jdAo+PiB2MjogaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcva3ZtYXJtLzIwMjIxMDE4MDQwNDU0LjQwNTcxOS0xLWdzaGFuQHJlZGhhdC5jb20vVC8j
dAo+Pgo+PiBDaGFuZ2Vsb2cKPj4gPT09PT09PT09Cj4+IHYzOgo+PiDCoMKgICogSW1wcm92ZWQg
Y29tbWVudHMgYWJvdXQgTUVNX1RFU1RfTU9WRV9TSVpFLCB3aGljaCBpcyBzZXQKPj4gwqDCoMKg
wqAgdG8gNjRLQiBpbiBQQVRDSFt2MyA0LzZdIGFuZCBmaW5hbGx5IGZpeGVkIHRvIDE5MktCIGlu
Cj4+IMKgwqDCoMKgIFBBVENIW3YzIDUvNl0uwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIChNYWNpZWopCj4+IMKgwqAgKiBVc2Ugc2l6ZSBpbnN0ZWFkIG9mIHBhZ2VzIHRvIGRvIHRo
ZSBjb21wYXJpc29uIGluCj4+IMKgwqDCoMKgIHRlc3RfbWVtc2xvdF9tb3ZlX3ByZXBhcmUoKcKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgKE1hY2llaikKPj4gwqDCoCAqIFVzZSB0b29scy9pbmNsdWRlL2xpbnV4L3NpemVzLmgg
aW5zdGVhZCBvZiBpbnZlbnRpbmcKPj4gwqDCoMKgwqAgb3VyIG93biBtYWNyb3MuwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAoT2xpdmVyKQo+PiB2MjoKPj4gwqDCoCAqIFBpY2sgdGhl
IHNtYWxsZXIgdmFsdWUgYmV0d2VlbiB0aGUgb25lcyBzcGVjaWZpZWQgYnkKPj4gwqDCoMKgwqAg
dXNlciBvciBwcm9iZWQgZnJvbSBLVk1fQ0FQX05SX01FTVNMT1RTIGluIFBBVENIW3YyIDMvNl3C
oMKgwqAgKE1hY2llaikKPj4gwqDCoCAqIEltcHJvdmVkIGNvbW1lbnRzIGFib3V0IE1FTV9URVNU
X01PVkVfU0laRSBpbgo+PiDCoMKgwqDCoCBQQVRDSFt2MiA0LzZdwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgKE1hY2llaikKPj4gwqDCoCAqIEF2b2lkIG1pc21hdGNoZWQgZ3Vl
c3QgcGFnZSBzaXplIGFmdGVyIFZNIGlzIHN0YXJ0ZWQgaW4KPj4gwqDCoMKgwqAgcHJlcGFyZV92
bSgpIGluIFBBVENIW3YyIDQvNl3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKE1hY2llaikKPj4gwqDCoCAqIEZpeCBjb25kaXRpb24g
dG8gY2hlY2sgTUVNX1RFU1Rfe1VOTUFQLCBVTk1BUF9DSFVOS31fU0laRQo+PiDCoMKgwqDCoCBp
biBjaGVja19tZW1vcnlfc2l6ZSgpIGluIFBBVENIW3YyIDQvNl3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIChNYWNpZWopCj4+IMKgwqAgKiBEZWZpbmUgYmFzZSBhbmQg
aHVnZSBwYWdlIHNpemUgaW4ga3ZtX3V0aWxfYmFzZS5oIGluCj4+IMKgwqDCoMKgIFBBVENIW3Yy
IDUvNl3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAoU2VhbikKPj4gwqDCoCAq
IEFkZCBjaGVja3Mgb24gaG9zdC9ndWVzdCBwYWdlIHNpemUgaW4gY2hlY2tfbWVtb3J5X3NpemUo
KQo+PiDCoMKgwqDCoCBhbmQgZmFpbCBlYXJseSBpZiBhbnkgb2YgdGhlbSBleGNlZWRzIDY0S0Ig
aW4gUEFUQ0hbdjIgNS82XSAoTWFjaWVqKQo+Pgo+Pgo+PiBHYXZpbiBTaGFuICg2KToKPj4gwqDC
oCBLVk06IHNlbGZ0ZXN0czogbWVtc2xvdF9wZXJmX3Rlc3Q6IFVzZSBkYXRhLT5uc2xvdHMgaW4g
cHJlcGFyZV92bSgpCj4+IMKgwqAgS1ZNOiBzZWxmdGVzdHM6IG1lbXNsb3RfcGVyZl90ZXN0OiBD
b25zb2xpZGF0ZSBsb29wIGNvbmRpdGlvbnMgaW4KPj4gwqDCoMKgwqAgcHJlcGFyZV92bSgpCj4+
IMKgwqAgS1ZNOiBzZWxmdGVzdHM6IG1lbXNsb3RfcGVyZl90ZXN0OiBQcm9iZSBtZW1vcnkgc2xv
dHMgZm9yIG9uY2UKPj4gwqDCoCBLVk06IHNlbGZ0ZXN0czogbWVtc2xvdF9wZXJmX3Rlc3Q6IFN1
cHBvcnQgdmFyaWFibGUgZ3Vlc3QgcGFnZSBzaXplCj4+IMKgwqAgS1ZNOiBzZWxmdGVzdHM6IG1l
bXNsb3RfcGVyZl90ZXN0OiBDb25zb2xpZGF0ZSBtZW1vcnkKPj4gwqDCoCBLVk06IHNlbGZ0ZXN0
czogbWVtc2xvdF9wZXJmX3Rlc3Q6IFJlcG9ydCBvcHRpbWFsIG1lbW9yeSBzbG90cwo+Pgo+IAo+
IFRoaXMgcGF0Y2ggc2V0IG5vdyBsb29rcyBnb29kIHRvIG1lLCBzbyBmb3IgdGhlIHdob2xlIHNl
cmllczoKPiBSZXZpZXdlZC1ieTogTWFjaWVqIFMuIFN6bWlnaWVybyA8bWFjaWVqLnN6bWlnaWVy
b0BvcmFjbGUuY29tPgo+IAoKSWYgcG9zc2libGUsIGNvdWxkIHlvdSBwbGVhc2UgbWVyZ2UgdGhp
cyBzZXJpZXMgdG8gJ25leHQnIGJyYW5jaCBlaXRoZXI/CkkgaG9wZSBpdCBjYW4gYmUgbWVyZ2Vk
IGVhcmx5IGJlY2F1c2Ugb3VyIGRvd25zdHJlYW0gbmVlZHMgdGhlIGZpeGVzIHRvCm1ha2UgdGhl
IHRlc3QgY2FzZSB3b3JrLiBJdCdzIGRlZmluaXRlbHkgZmluZSB0byB3YWl0IGZvciBtb3JlIGNv
bW1lbnRzLApidXQgSSBoYXZlbid0IHJlY2VpdmUgYW55IG1vcmUgY29tbWVudHMgaW4gbGFzdCBt
b250aCA6KQoKVGhhbmtzLApHYXZpbgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1i
aWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3Zt
YXJtCg==
