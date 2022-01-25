Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 080D1C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 18:32:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F3F849EEF;
	Tue, 25 Jan 2022 13:32:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CPYZuuwHtiQm; Tue, 25 Jan 2022 13:32:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4661E49E42;
	Tue, 25 Jan 2022 13:32:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0A4749B12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 13:32:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NQd01ODS3drl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jan 2022 13:32:47 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 991AC49B0A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 13:32:47 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1643135567;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=2YHSY/Nkzf4Yub0Wgdnv3A9D/iLT4fHqA5QN1U3nZRw=;
 b=SMpX9cbi8wku4HV/i7TBV61B6lxN4ZCG+VX/p0ZqCucBeGAq5PrW8dOc8UIk16xGvsJjWX
 GbCRcGp2Z+q2X7MXBpxyVmZ8kleGJnuMAXLZ/jPPS2DQHfS6KNTYRsqs/CRwBGvWkOr/bp
 SrPwESNMMYScp1Lc45qOYjaAs1IBvkU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-n0z5zwdvPQChZTP3i9SSTA-1; Tue, 25 Jan 2022 13:32:45 -0500
X-MC-Unique: n0z5zwdvPQChZTP3i9SSTA-1
Received: by mail-wr1-f71.google.com with SMTP id
 h12-20020adfa4cc000000b001d474912698so3430311wrb.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 10:32:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=2YHSY/Nkzf4Yub0Wgdnv3A9D/iLT4fHqA5QN1U3nZRw=;
 b=PWYo9NGigs8S6bTUiRmB4+X9N/gqOJG/C2gPWHqtctMcgNAFK1NaLIhKcSngxRmTa/
 UByzT7X2zvo7g5QcwI3qryBT9d5PTCotUm5gfXZ8i8UovMxO68TIMrshobIz7aIhlf2V
 nqFzt4OFbuYrtiOcG5Kz22YTqMlv3kL5Bn5J0xpdL/7kmQbjNYx1EQ4yVi8x4Ui7t9bT
 CGM2YStkxndRcq2z6rhq3oQ+6CxiLsNTJx4ksbvHd2BNHrc0hK1alliIB4JXzJDWsQXN
 XLGEYKgfsgUn4S2sCOYSHhq3J+Gxzu6JXX5ZgN24z2vzo60TqjAopMugzAfkAq+w7zic
 SoEw==
X-Gm-Message-State: AOAM533wiOCQc6AhYDB4Re0FUIclLLEuk1k1GlQGgBVkNy24badHND9Q
 0gfMdZz0KZ3gwZN1IQ6RQ5ShwxG8IJJNmfB4Nmg8OZ5ekYPCo3RXRLM6OEaiGjK1BNRAH7INVTq
 s6FFDly51uWYvpmlkaoGkMDD/
X-Received: by 2002:a05:600c:2505:: with SMTP id
 d5mr4102643wma.36.1643135564374; 
 Tue, 25 Jan 2022 10:32:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyWAzVQFt8v++ktzP0X4IvFxbJMwGQJKw9tLIEla5bx4IKLla8MyJnZjdvqnp5cKa4sM0QpDw==
X-Received: by 2002:a05:600c:2505:: with SMTP id
 d5mr4102628wma.36.1643135564155; 
 Tue, 25 Jan 2022 10:32:44 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id l5sm1125913wmq.7.2022.01.25.10.32.43
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 25 Jan 2022 10:32:43 -0800 (PST)
Subject: Re: [PATCH v4 06/21] KVM: arm64: Support SDEI_EVENT_CONTEXT hypercall
To: Gavin Shan <gshan@redhat.com>, Shannon Zhao <shannon.zhaosl@gmail.com>,
 kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-7-gshan@redhat.com>
 <40d818a2-0c91-e06e-6ce8-ac8123b8d1d4@gmail.com>
 <798ecbb0-f369-f3e7-ad50-78acfd902d1d@redhat.com>
 <71b87778-ea60-b01d-9010-789feb1e16fa@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <11bbc0c9-b4b2-473f-1979-a7ea8994d15e@redhat.com>
Date: Tue, 25 Jan 2022 19:32:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <71b87778-ea60-b01d-9010-789feb1e16fa@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: maz@kernel.org, Jonathan.Cameron@huawei.com, will@kernel.org,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com
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

SGkgR2F2aW4sCgpPbiAxLzEzLzIyIDg6MTMgQU0sIEdhdmluIFNoYW4gd3JvdGU6Cj4gSGkgU2hh
bm5vbiwKPiAKPiBPbiAxLzEzLzIyIDM6MDIgUE0sIEdhdmluIFNoYW4gd3JvdGU6Cj4+IE9uIDEv
MTEvMjIgNTo0MyBQTSwgU2hhbm5vbiBaaGFvIHdyb3RlOgo+Pj4gT24gMjAyMS84LzE1IDg6MTMs
IEdhdmluIFNoYW4gd3JvdGU6Cj4+Pj4gK3N0YXRpYyB1bnNpZ25lZCBsb25nIGt2bV9zZGVpX2h5
cGVyY2FsbF9jb250ZXh0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKPj4+PiArewo+Pj4+ICvCoMKg
wqAgc3RydWN0IGt2bSAqa3ZtID0gdmNwdS0+a3ZtOwo+Pj4+ICvCoMKgwqAgc3RydWN0IGt2bV9z
ZGVpX2t2bSAqa3NkZWkgPSBrdm0tPmFyY2guc2RlaTsKPj4+PiArwqDCoMKgIHN0cnVjdCBrdm1f
c2RlaV92Y3B1ICp2c2RlaSA9IHZjcHUtPmFyY2guc2RlaTsKPj4+PiArwqDCoMKgIHN0cnVjdCBr
dm1fc2RlaV92Y3B1X3JlZ3MgKnJlZ3M7Cj4+Pj4gK8KgwqDCoCB1bnNpZ25lZCBsb25nIGluZGV4
ID0gc21jY2NfZ2V0X2FyZzEodmNwdSk7Cj4+Pj4gK8KgwqDCoCB1bnNpZ25lZCBsb25nIHJldCA9
IFNERUlfU1VDQ0VTUzsKPj4+PiArCj4+Pj4gK8KgwqDCoCAvKiBTYW5pdHkgY2hlY2sgKi8KPj4+
PiArwqDCoMKgIGlmICghKGtzZGVpICYmIHZzZGVpKSkgewo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBy
ZXQgPSBTREVJX05PVF9TVVBQT1JURUQ7Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgIGdvdG8gb3V0Owo+
Pj4+ICvCoMKgwqAgfQo+Pj4gTWF5YmUgd2UgY291bGQgbW92ZSB0aGVzZSBjb21tb24gc2FuaXR5
IGNoZWNrIGNvZGVzIHRvCj4+PiBrdm1fc2RlaV9oeXBlcmNhbGwgdG8gc2F2ZSBzb21lIGxpbmVz
Lgo+Pj4KPj4KPj4gTm90IGFsbCBoeXBlcmNhbGxzIG5lZWQgdGhpcyBjaGVjay4gRm9yIGV4YW1w
bGUsCj4+IENPTVBMRVRFL0NPTVBMRVRFX1JFU1VNRS9DT05URVhUIGRvbid0Cj4+IGhhdmUgU0RF
SSBldmVudCBudW1iZXIgYXMgdGhlIGFyZ3VtZW50LiBJZiB3ZSByZWFsbHkgd2FudCBtb3ZlIHRo
aXMKPj4gY2hlY2sgaW50byBmdW5jdGlvbgo+PiBrdm1fc2RlaV9oeXBlcmNhbGwoKSwgd2Ugd291
bGQgaGF2ZSBjb2RlIGxpa2UgYmVsb3cuIFRvbyBtdWNoCj4+IGR1cGxpY2F0ZWQgc25pcHBldHMg
d2lsbAo+PiBiZSBzZWVuLiBJIGRvbid0IHRoaW5rIGl0J3MgYmV0dGVyIHRoYW4gd2hhdCB3ZSBo
YXZlIGlmIEkgZnVsbHkKPj4gdW5kZXJzdGFuZCB5b3VyIGNvbW1lbnRzLgo+Pgo+IAo+IG9vcHMu
Li4gc29ycnkuIFBsZWFzZSBpZ25vcmUgbXkgcHJldmlvdXMgcmVwbHkuIEkgdGhvdWdodCB5b3Ug
dGFsayBhYm91dAo+IHRoZSBjaGVjayBvbiB0aGUgU0RFSSBldmVudCBudW1iZXIgd3JvbmdseS4g
WWVzLCB5b3UncmUgY29ycmVjdCB0aGF0IHRoZQo+IGNoZWNrIHNob3VsZCBiZSBtb3ZlZCB0byBr
dm1fc2RlaV9oeXBlcmNhbGwoKS4KCmV2ZW4gYmV0dGVyIHRoYW4gbXkgcHJldmlvdXMgcHJvcG9z
YWwgdGhlbgoKRXJpYwo+IAo+IFRoYW5rcywKPiBHYXZpbgo+IAo+IF9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCj4ga3ZtYXJtIG1haWxpbmcgbGlzdAo+IGt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKPiBodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVk
dS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29s
dW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8v
a3ZtYXJtCg==
