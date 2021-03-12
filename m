Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF2BBC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 17:28:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5295264F6D
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 17:28:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5295264F6D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCC0B4B542;
	Fri, 12 Mar 2021 12:28:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OilZjVUlUf+I; Fri, 12 Mar 2021 12:28:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C63AB4B524;
	Fri, 12 Mar 2021 12:28:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71AD24B524
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 12:28:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zNhjAtKSpsHM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 12:28:04 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72A424B517
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 12:28:04 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615570084;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Meg6RVmZcZsNMe9sfJqaNrr/X54eRIiKbY/MlA8VieE=;
 b=ZFDkizq3WKyTv/NJaO+eDdHQD9H2ssegOfjiOJCmsS8ETPK7aXerSTLOq13BERF3HLfojM
 /TWLAb/HHqoUhasxGkdj6DBdROoep6QvBzqpnUa2sPBU7aDD3QV3A4ZhMijS5+bADVapw0
 iUbzMQXIA+RGaGPS7iuC5+NlVEC/5bk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-knikhbGgMSGjKtfE4Sr1fQ-1; Fri, 12 Mar 2021 12:28:02 -0500
X-MC-Unique: knikhbGgMSGjKtfE4Sr1fQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 797078015BD;
 Fri, 12 Mar 2021 17:28:00 +0000 (UTC)
Received: from [10.36.112.254] (ovpn-112-254.ams2.redhat.com [10.36.112.254])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 39CFB5D9CC;
 Fri, 12 Mar 2021 17:27:56 +0000 (UTC)
Subject: Re: [PATCH 5/9] KVM: arm: move has_run_once after the map_resources
To: Alexandru Elisei <alexandru.elisei@arm.com>, eric.auger.pro@gmail.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-6-eric.auger@redhat.com>
 <0c9976a3-12ae-29b2-1f26-06ee52aa2ffe@arm.com>
 <3465e1e4-d202-ae36-5b61-87f796432428@redhat.com>
 <5590800f-f77d-52e1-e408-c1afe4e284a2@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <a0ca6c66-169b-381f-5630-f013d703f92c@redhat.com>
Date: Fri, 12 Mar 2021 18:27:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <5590800f-f77d-52e1-e408-c1afe4e284a2@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: shuah@kernel.org, pbonzini@redhat.com
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

SGkgQWxleGFuZHJ1LAoKT24gMS8yMC8yMSA0OjU2IFBNLCBBbGV4YW5kcnUgRWxpc2VpIHdyb3Rl
Ogo+IEhpIEVyaWMsCj4gCj4gT24gMS8xNC8yMSAxMDowMiBBTSwgQXVnZXIgRXJpYyB3cm90ZToK
Pj4gSGkgQWxleGFuZHJ1LAo+Pgo+PiBPbiAxLzEyLzIxIDM6NTUgUE0sIEFsZXhhbmRydSBFbGlz
ZWkgd3JvdGU6Cj4+PiBIaSBFcmljLAo+Pj4KPj4+IE9uIDEyLzEyLzIwIDY6NTAgUE0sIEVyaWMg
QXVnZXIgd3JvdGU6Cj4+Pj4gaGFzX3J1bl9vbmNlIGlzIHNldCB0byB0cnVlIGF0IHRoZSBiZWdp
bm5pbmcgb2YKPj4+PiBrdm1fdmNwdV9maXJzdF9ydW5faW5pdCgpLiBUaGlzIGdlbmVyYWxseSBp
cyBub3QgYW4gaXNzdWUKPj4+PiBleGNlcHQgd2hlbiBleGVyY2lzaW5nIHRoZSBjb2RlIHdpdGgg
S1ZNIHNlbGZ0ZXN0cy4gSW5kZWVkLAo+Pj4+IGlmIGt2bV92Z2ljX21hcF9yZXNvdXJjZXMoKSBm
YWlscyBkdWUgdG8gZXJyb25lb3VzIHVzZXIgc2V0dGluZ3MsCj4+Pj4gaGFzX3J1bl9vbmNlIGlz
IHNldCBhbmQgdGhpcyBwcmV2ZW50cyBmcm9tIGNvbnRpbnVpbmcKPj4+PiBleGVjdXRpbmcgdGhl
IHRlc3QuIFRoaXMgcGF0Y2ggbW92ZXMgdGhlIGFzc2lnbm1lbnQgYWZ0ZXIgdGhlCj4+Pj4ga3Zt
X3ZnaWNfbWFwX3Jlc291cmNlcygpLgo+Pj4+Cj4+Pj4gU2lnbmVkLW9mZi1ieTogRXJpYyBBdWdl
ciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgo+Pj4+IC0tLQo+Pj4+ICBhcmNoL2FybTY0L2t2bS9h
cm0uYyB8IDQgKystLQo+Pj4+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRl
bGV0aW9ucygtKQo+Pj4+Cj4+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2FybS5jIGIv
YXJjaC9hcm02NC9rdm0vYXJtLmMKPj4+PiBpbmRleCBjMGZmYjAxOWNhOGIuLjMzMWZhZTZiZmYz
MSAxMDA2NDQKPj4+PiAtLS0gYS9hcmNoL2FybTY0L2t2bS9hcm0uYwo+Pj4+ICsrKyBiL2FyY2gv
YXJtNjQva3ZtL2FybS5jCj4+Pj4gQEAgLTU0MCw4ICs1NDAsNiBAQCBzdGF0aWMgaW50IGt2bV92
Y3B1X2ZpcnN0X3J1bl9pbml0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKPj4+PiAgCWlmICgha3Zt
X2FybV92Y3B1X2lzX2ZpbmFsaXplZCh2Y3B1KSkKPj4+PiAgCQlyZXR1cm4gLUVQRVJNOwo+Pj4+
ICAKPj4+PiAtCXZjcHUtPmFyY2guaGFzX3J1bl9vbmNlID0gdHJ1ZTsKPj4+PiAtCj4+Pj4gIAlp
ZiAobGlrZWx5KGlycWNoaXBfaW5fa2VybmVsKGt2bSkpKSB7Cj4+Pj4gIAkJLyoKPj4+PiAgCQkg
KiBNYXAgdGhlIFZHSUMgaGFyZHdhcmUgcmVzb3VyY2VzIGJlZm9yZSBydW5uaW5nIGEgdmNwdSB0
aGUKPj4+PiBAQCAtNTYwLDYgKzU1OCw4IEBAIHN0YXRpYyBpbnQga3ZtX3ZjcHVfZmlyc3RfcnVu
X2luaXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+Pj4+ICAJCXN0YXRpY19icmFuY2hfaW5jKCZ1
c2Vyc3BhY2VfaXJxY2hpcF9pbl91c2UpOwo+Pj4+ICAJfQo+Pj4+ICAKPj4+PiArCXZjcHUtPmFy
Y2guaGFzX3J1bl9vbmNlID0gdHJ1ZTsKPj4+IEkgaGF2ZSBhIGZldyBjb25jZXJucyByZWdhcmRp
bmcgdGhpczoKPj4+Cj4+PiAxLiBNb3ZpbmcgaGFzX3J1bl9vbmNlID0gdHJ1ZSBoZXJlIHNlZW1z
IHZlcnkgYXJiaXRyYXJ5IHRvIG1lIC0ga3ZtX3RpbWVyX2VuYWJsZSgpCj4+PiBhbmQga3ZtX2Fy
bV9wbXVfdjNfZW5hYmxlKCksIGJlbG93IGl0LCBjYW4gYm90aCBmYWlsIGJlY2F1c2Ugb2YgZXJy
b25lb3VzIHVzZXIKPj4+IHZhbHVlcy4gSWYgdGhlcmUncyBhIHJlYXNvbiB3aHkgdGhlIGFzc2ln
bm1lbnQgY2Fubm90IGJlIG1vdmVkIGF0IHRoZSBlbmQgb2YgdGhlCj4+PiBmdW5jdGlvbiwgSSB0
aGluayBpdCBzaG91bGQgYmUgY2xlYXJseSBzdGF0ZWQgaW4gYSBjb21tZW50IGZvciB0aGUgcGVv
cGxlIHdobwo+Pj4gbWlnaHQgYmUgdGVtcHRlZCB0byB3cml0ZSBzaW1pbGFyIHRlc3RzIGZvciB0
aGUgdGltZXIgb3IgcG11Lgo+PiBTZXR0aW5nIGhhc19ydW5fb25jZSA9IHRydWUgYXQgdGhlIGVu
dHJ5IG9mIHRoZSBmdW5jdGlvbiBsb29rcyB0byBtZQo+PiBldmVuIG1vcmUgYXJiaXRyYXJ5LiBJ
IGFncmVlIHdpdGggeW91IHRoYXQgZXZlbnR1YWxseSBoYXNfcnVuX29uY2UgbWF5Cj4gCj4gT3Ig
aXQgY291bGQgYmUgaXQncyB0aGVyZSB0byBwcmV2ZW50IHRoZSB1c2VyIGZyb20gY2FsbGluZwo+
IGt2bV92Z2ljX21hcF9yZXNvdXJjZXMoKSBhIHNlY29uZCB0aW1lIGFmdGVyIGl0IGZhaWxlZC4g
VGhpcyBpcyB3aGF0IEknbSBjb25jZXJuZWQKPiBhYm91dCBhbmQgSSB0aGluayBkZXNlcnZlcyBt
b3JlIGludmVzdGlnYXRpb24uCgpJIGhhdmUgcmV3b3JrZWQgbXkga3ZtIHNlbGZ0ZXN0cyB0byBs
aXZlIHdpdGhvdXQgdGhhdCBjaGFuZ2UuCgpUaGFua3MKCkVyaWMKPiAKPiBUaGFua3MsCj4gQWxl
eAo+PiBiZSBtb3ZlZCBhdCB0aGUgdmVyeSBlbmQgYnV0IG1heWJlIHRoaXMgY2FuIGJlIGRvbmUg
bGF0ZXIgb25jZSB0aW1lciwKPj4gcG11IHRlc3RzIGhhdmVuIGJlbiB3cml0dGVuCj4+PiAyLiBU
aGVyZSBhcmUgbWFueSB3YXlzIHRoYXQga3ZtX3ZnaWNfbWFwX3Jlc291cmNlcygpIGNhbiBmYWls
LCBvdGhlciB0aGFuCj4+PiBpbmNvcnJlY3QgdXNlciBzZXR0aW5ncy4gSSBzdGFydGVkIGRpZ2dp
bmcgaW50byBob3cKPj4+IGt2bV92Z2ljX21hcF9yZXNvdXJjZXMoKS0+dmdpY192Ml9tYXBfcmVz
b3VyY2VzKCkgY2FuIGZhaWwgZm9yIGEgVkdJQyBWMiBhbmQgdGhpcwo+Pj4gaXMgd2hhdCBJIG1h
bmFnZWQgdG8gZmluZCBiZWZvcmUgSSBnYXZlIHVwOgo+Pj4KPj4+ICogdmdpY19pbml0KCkgY2Fu
IGZhaWwgaW46Cj4+PiDCoMKgwqAgLSBrdm1fdmdpY19kaXN0X2luaXQoKQo+Pj4gwqDCoMKgIC0g
dmdpY192M19pbml0KCkKPj4+IMKgwqDCoCAtIGt2bV92Z2ljX3NldHVwX2RlZmF1bHRfaXJxX3Jv
dXRpbmcoKQo+Pj4gKiB2Z2ljX3JlZ2lzdGVyX2Rpc3RfaW9kZXYoKSBjYW4gZmFpbCBpbjoKPj4+
IMKgwqDCoCAtIHZnaWNfdjNfaW5pdF9kaXN0X2lvZGV2KCkKPj4+IMKgwqDCoCAtIGt2bV9pb19i
dXNfcmVnaXN0ZXJfZGV2KCkoKikKPj4+ICoga3ZtX3BoeXNfYWRkcl9pb3JlbWFwKCkgY2FuIGZh
aWwgaW46Cj4+PiDCoMKgwqAgLSBrdm1fbW11X3RvcHVwX21lbW9yeV9jYWNoZSgpCj4+PiDCoMKg
wqAgLSBrdm1fcGd0YWJsZV9zdGFnZTJfbWFwKCkKPj4gSSBjaGFuZ2VkIHRoZSBjb21taXQgbXNn
IHNvIHRoYXQgImluY29ycmVjdCB1c2VyIHNldHRpbmdzIiBzb3VuZHMgYXMgYW4KPj4gZXhhbXBs
ZS4KPj4+IFNvIGlmIGFueSBvZiB0aGUgZnVuY3Rpb25zIGJlbG93IGZhaWwsIGFyZSB3ZSAxMDAl
IHN1cmUgaXQgaXMgc2FmZSB0byBhbGxvdyB0aGUKPj4+IHVzZXIgdG8gZXhlY3V0ZSBrdm1fdmdp
Y19tYXBfcmVzb3VyY2VzKCkgYWdhaW4/Cj4+IEkgdGhpbmsgYWRkaXRpb25hbCB0ZXN0cyB3aWxs
IGNvbmZpcm0gdGhpcy4gSG93ZXZlciBhdCB0aGUgbW9tZW50LAo+PiBtb3ZpbmcgdGhlIGFzc2ln
bm1lbnQsIHdoaWNoIGRvZXMgbm90IGxvb2sgd3JvbmcgdG8gbWUsIGFsbG93cyB0bwo+PiBncmVh
dGx5IHNpbXBsaWZ5IHRoZSB0ZXN0cyBzbyBJIHdvdWxkIHRlbmQgdG8gc2F5IHRoYXQgaXQgaXMg
d29ydGguCj4+PiAoKikgSXQgbG9va3MgdG8gbWUgbGlrZSBrdm1faW9fYnVzX3JlZ2lzdGVyX2Rl
digpIGRvZXNuJ3QgdGFrZSBpbnRvIGFjY291bnQgYQo+Pj4gY2FsbGVyIHRoYXQgdHJpZXMgdG8g
cmVnaXN0ZXIgdGhlIHNhbWUgZGV2aWNlIGFkZHJlc3MgcmFuZ2UgYW5kIGl0IHdpbGwgY3JlYXRl
Cj4+PiBhbm90aGVyIGlkZW50aWNhbCByYW5nZS4gSXMgdGhpcyBpbnRlbnRpb25hbD8gSXMgaXQg
YSBidWcgdGhhdCBzaG91bGQgYmUgZml4ZWQ/IE9yCj4+PiBhbSBJIG1pc3VuZGVyc3RhbmRpbmcg
dGhlIGZ1bmN0aW9uPwo+PiBkb2Vzbid0IGt2bV9pb19idXNfY21wKCkgZG8gdGhlIGNoZWNrPwo+
Pgo+PiBUaGFua3MKPj4KPj4gRXJpYwo+Pj4gVGhhbmtzLAo+Pj4gQWxleAo+Pj4+ICsKPj4+PiAg
CXJldCA9IGt2bV90aW1lcl9lbmFibGUodmNwdSk7Cj4+Pj4gIAlpZiAocmV0KQo+Pj4+ICAJCXJl
dHVybiByZXQ7Cj4gCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0
cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
