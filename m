Return-Path: <SRS0=BtxD=GR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708E1C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 10:03:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B8A823A34
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 10:03:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B8A823A34
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9B864B19E;
	Thu, 14 Jan 2021 05:03:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LlmMphiPkGRz; Thu, 14 Jan 2021 05:03:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FEF14B173;
	Thu, 14 Jan 2021 05:03:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8CBB4B173
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 05:02:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uHOtX9dsnwcS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jan 2021 05:02:57 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2C024B171
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 05:02:57 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610618577;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=I6kXZaJLPh//1wn++dvxOkKXyMJT/X1CKDjOeutoUWE=;
 b=gSddS9l40C2CoGfHv5ST+s0CUZVu2k2SqpBi1TmyF+/TnBdPFORlIvmSbWhi0MPDtStyHJ
 B7rlaTWzPcyrgzECDBPgaVU5X8OX+3xR5soUGuYWxqDkGlktVhO+KVFYy80C1f5qih9BGX
 WutSt6liMx9hR2VODx9/TgcWrY50pYY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-mN2XwrPJPr6QI0rHP_ct8g-1; Thu, 14 Jan 2021 05:02:55 -0500
X-MC-Unique: mN2XwrPJPr6QI0rHP_ct8g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AE5E100C661;
 Thu, 14 Jan 2021 10:02:54 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 32C5B277AE;
 Thu, 14 Jan 2021 10:02:51 +0000 (UTC)
Subject: Re: [PATCH 5/9] KVM: arm: move has_run_once after the map_resources
To: Alexandru Elisei <alexandru.elisei@arm.com>, eric.auger.pro@gmail.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-6-eric.auger@redhat.com>
 <0c9976a3-12ae-29b2-1f26-06ee52aa2ffe@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <3465e1e4-d202-ae36-5b61-87f796432428@redhat.com>
Date: Thu, 14 Jan 2021 11:02:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <0c9976a3-12ae-29b2-1f26-06ee52aa2ffe@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

SGkgQWxleGFuZHJ1LAoKT24gMS8xMi8yMSAzOjU1IFBNLCBBbGV4YW5kcnUgRWxpc2VpIHdyb3Rl
Ogo+IEhpIEVyaWMsCj4gCj4gT24gMTIvMTIvMjAgNjo1MCBQTSwgRXJpYyBBdWdlciB3cm90ZToK
Pj4gaGFzX3J1bl9vbmNlIGlzIHNldCB0byB0cnVlIGF0IHRoZSBiZWdpbm5pbmcgb2YKPj4ga3Zt
X3ZjcHVfZmlyc3RfcnVuX2luaXQoKS4gVGhpcyBnZW5lcmFsbHkgaXMgbm90IGFuIGlzc3VlCj4+
IGV4Y2VwdCB3aGVuIGV4ZXJjaXNpbmcgdGhlIGNvZGUgd2l0aCBLVk0gc2VsZnRlc3RzLiBJbmRl
ZWQsCj4+IGlmIGt2bV92Z2ljX21hcF9yZXNvdXJjZXMoKSBmYWlscyBkdWUgdG8gZXJyb25lb3Vz
IHVzZXIgc2V0dGluZ3MsCj4+IGhhc19ydW5fb25jZSBpcyBzZXQgYW5kIHRoaXMgcHJldmVudHMg
ZnJvbSBjb250aW51aW5nCj4+IGV4ZWN1dGluZyB0aGUgdGVzdC4gVGhpcyBwYXRjaCBtb3ZlcyB0
aGUgYXNzaWdubWVudCBhZnRlciB0aGUKPj4ga3ZtX3ZnaWNfbWFwX3Jlc291cmNlcygpLgo+Pgo+
PiBTaWduZWQtb2ZmLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+Cj4+IC0t
LQo+PiAgYXJjaC9hcm02NC9rdm0vYXJtLmMgfCA0ICsrLS0KPj4gIDEgZmlsZSBjaGFuZ2VkLCAy
IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9hcmNoL2Fy
bTY0L2t2bS9hcm0uYyBiL2FyY2gvYXJtNjQva3ZtL2FybS5jCj4+IGluZGV4IGMwZmZiMDE5Y2E4
Yi4uMzMxZmFlNmJmZjMxIDEwMDY0NAo+PiAtLS0gYS9hcmNoL2FybTY0L2t2bS9hcm0uYwo+PiAr
KysgYi9hcmNoL2FybTY0L2t2bS9hcm0uYwo+PiBAQCAtNTQwLDggKzU0MCw2IEBAIHN0YXRpYyBp
bnQga3ZtX3ZjcHVfZmlyc3RfcnVuX2luaXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+PiAgCWlm
ICgha3ZtX2FybV92Y3B1X2lzX2ZpbmFsaXplZCh2Y3B1KSkKPj4gIAkJcmV0dXJuIC1FUEVSTTsK
Pj4gIAo+PiAtCXZjcHUtPmFyY2guaGFzX3J1bl9vbmNlID0gdHJ1ZTsKPj4gLQo+PiAgCWlmIChs
aWtlbHkoaXJxY2hpcF9pbl9rZXJuZWwoa3ZtKSkpIHsKPj4gIAkJLyoKPj4gIAkJICogTWFwIHRo
ZSBWR0lDIGhhcmR3YXJlIHJlc291cmNlcyBiZWZvcmUgcnVubmluZyBhIHZjcHUgdGhlCj4+IEBA
IC01NjAsNiArNTU4LDggQEAgc3RhdGljIGludCBrdm1fdmNwdV9maXJzdF9ydW5faW5pdChzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUpCj4+ICAJCXN0YXRpY19icmFuY2hfaW5jKCZ1c2Vyc3BhY2VfaXJx
Y2hpcF9pbl91c2UpOwo+PiAgCX0KPj4gIAo+PiArCXZjcHUtPmFyY2guaGFzX3J1bl9vbmNlID0g
dHJ1ZTsKPiAKPiBJIGhhdmUgYSBmZXcgY29uY2VybnMgcmVnYXJkaW5nIHRoaXM6Cj4gCj4gMS4g
TW92aW5nIGhhc19ydW5fb25jZSA9IHRydWUgaGVyZSBzZWVtcyB2ZXJ5IGFyYml0cmFyeSB0byBt
ZSAtIGt2bV90aW1lcl9lbmFibGUoKQo+IGFuZCBrdm1fYXJtX3BtdV92M19lbmFibGUoKSwgYmVs
b3cgaXQsIGNhbiBib3RoIGZhaWwgYmVjYXVzZSBvZiBlcnJvbmVvdXMgdXNlcgo+IHZhbHVlcy4g
SWYgdGhlcmUncyBhIHJlYXNvbiB3aHkgdGhlIGFzc2lnbm1lbnQgY2Fubm90IGJlIG1vdmVkIGF0
IHRoZSBlbmQgb2YgdGhlCj4gZnVuY3Rpb24sIEkgdGhpbmsgaXQgc2hvdWxkIGJlIGNsZWFybHkg
c3RhdGVkIGluIGEgY29tbWVudCBmb3IgdGhlIHBlb3BsZSB3aG8KPiBtaWdodCBiZSB0ZW1wdGVk
IHRvIHdyaXRlIHNpbWlsYXIgdGVzdHMgZm9yIHRoZSB0aW1lciBvciBwbXUuCgpTZXR0aW5nIGhh
c19ydW5fb25jZSA9IHRydWUgYXQgdGhlIGVudHJ5IG9mIHRoZSBmdW5jdGlvbiBsb29rcyB0byBt
ZQpldmVuIG1vcmUgYXJiaXRyYXJ5LiBJIGFncmVlIHdpdGggeW91IHRoYXQgZXZlbnR1YWxseSBo
YXNfcnVuX29uY2UgbWF5CmJlIG1vdmVkIGF0IHRoZSB2ZXJ5IGVuZCBidXQgbWF5YmUgdGhpcyBj
YW4gYmUgZG9uZSBsYXRlciBvbmNlIHRpbWVyLApwbXUgdGVzdHMgaGF2ZW4gYmVuIHdyaXR0ZW4K
PiAKPiAyLiBUaGVyZSBhcmUgbWFueSB3YXlzIHRoYXQga3ZtX3ZnaWNfbWFwX3Jlc291cmNlcygp
IGNhbiBmYWlsLCBvdGhlciB0aGFuCj4gaW5jb3JyZWN0IHVzZXIgc2V0dGluZ3MuIEkgc3RhcnRl
ZCBkaWdnaW5nIGludG8gaG93Cj4ga3ZtX3ZnaWNfbWFwX3Jlc291cmNlcygpLT52Z2ljX3YyX21h
cF9yZXNvdXJjZXMoKSBjYW4gZmFpbCBmb3IgYSBWR0lDIFYyIGFuZCB0aGlzCj4gaXMgd2hhdCBJ
IG1hbmFnZWQgdG8gZmluZCBiZWZvcmUgSSBnYXZlIHVwOgo+IAo+ICogdmdpY19pbml0KCkgY2Fu
IGZhaWwgaW46Cj4gwqDCoMKgIC0ga3ZtX3ZnaWNfZGlzdF9pbml0KCkKPiDCoMKgwqAgLSB2Z2lj
X3YzX2luaXQoKQo+IMKgwqDCoCAtIGt2bV92Z2ljX3NldHVwX2RlZmF1bHRfaXJxX3JvdXRpbmco
KQo+ICogdmdpY19yZWdpc3Rlcl9kaXN0X2lvZGV2KCkgY2FuIGZhaWwgaW46Cj4gwqDCoMKgIC0g
dmdpY192M19pbml0X2Rpc3RfaW9kZXYoKQo+IMKgwqDCoCAtIGt2bV9pb19idXNfcmVnaXN0ZXJf
ZGV2KCkoKikKPiAqIGt2bV9waHlzX2FkZHJfaW9yZW1hcCgpIGNhbiBmYWlsIGluOgo+IMKgwqDC
oCAtIGt2bV9tbXVfdG9wdXBfbWVtb3J5X2NhY2hlKCkKPiDCoMKgwqAgLSBrdm1fcGd0YWJsZV9z
dGFnZTJfbWFwKCkKCkkgY2hhbmdlZCB0aGUgY29tbWl0IG1zZyBzbyB0aGF0ICJpbmNvcnJlY3Qg
dXNlciBzZXR0aW5ncyIgc291bmRzIGFzIGFuCmV4YW1wbGUuCj4gCj4gU28gaWYgYW55IG9mIHRo
ZSBmdW5jdGlvbnMgYmVsb3cgZmFpbCwgYXJlIHdlIDEwMCUgc3VyZSBpdCBpcyBzYWZlIHRvIGFs
bG93IHRoZQo+IHVzZXIgdG8gZXhlY3V0ZSBrdm1fdmdpY19tYXBfcmVzb3VyY2VzKCkgYWdhaW4/
CgpJIHRoaW5rIGFkZGl0aW9uYWwgdGVzdHMgd2lsbCBjb25maXJtIHRoaXMuIEhvd2V2ZXIgYXQg
dGhlIG1vbWVudCwKbW92aW5nIHRoZSBhc3NpZ25tZW50LCB3aGljaCBkb2VzIG5vdCBsb29rIHdy
b25nIHRvIG1lLCBhbGxvd3MgdG8KZ3JlYXRseSBzaW1wbGlmeSB0aGUgdGVzdHMgc28gSSB3b3Vs
ZCB0ZW5kIHRvIHNheSB0aGF0IGl0IGlzIHdvcnRoLgo+IAo+ICgqKSBJdCBsb29rcyB0byBtZSBs
aWtlIGt2bV9pb19idXNfcmVnaXN0ZXJfZGV2KCkgZG9lc24ndCB0YWtlIGludG8gYWNjb3VudCBh
Cj4gY2FsbGVyIHRoYXQgdHJpZXMgdG8gcmVnaXN0ZXIgdGhlIHNhbWUgZGV2aWNlIGFkZHJlc3Mg
cmFuZ2UgYW5kIGl0IHdpbGwgY3JlYXRlCj4gYW5vdGhlciBpZGVudGljYWwgcmFuZ2UuIElzIHRo
aXMgaW50ZW50aW9uYWw/IElzIGl0IGEgYnVnIHRoYXQgc2hvdWxkIGJlIGZpeGVkPyBPcgo+IGFt
IEkgbWlzdW5kZXJzdGFuZGluZyB0aGUgZnVuY3Rpb24/Cgpkb2Vzbid0IGt2bV9pb19idXNfY21w
KCkgZG8gdGhlIGNoZWNrPwoKVGhhbmtzCgpFcmljCj4gCj4gVGhhbmtzLAo+IEFsZXgKPj4gKwo+
PiAgCXJldCA9IGt2bV90aW1lcl9lbmFibGUodmNwdSk7Cj4+ICAJaWYgKHJldCkKPj4gIAkJcmV0
dXJuIHJldDsKPiAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRw
czovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
