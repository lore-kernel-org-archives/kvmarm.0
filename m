Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81101C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 16:23:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 03F5B61439
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 16:23:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 03F5B61439
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C0814B0F1;
	Wed, 29 Sep 2021 12:23:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RvG0Y-yUJItm; Wed, 29 Sep 2021 12:23:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24FD84B12F;
	Wed, 29 Sep 2021 12:23:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34A704B0F1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 12:23:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HFn4IwxlMYqf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Sep 2021 12:23:11 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CB9B4B0E6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 12:23:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632932591;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=+j4qNtz3r10+MbmLFcntFcdy8mpU9rKxm1btg9WBj6Q=;
 b=gxXkVEqKWomO9g8ur/3j9Qbx4n1SLmPD1BcQMPXUPzQCxNOvivs3s8er+G289BAz25RjlX
 wMghOJfpLkt2S1pfs7bazGtjXN0eDs+HSQ12nejBtprESAAEgJk978muh194hJirTF2zKw
 G7pfAnSmEc8gsLKVjiZzhZgIhrxVFkU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-nFL-w1UiPTeKtt0pM81wfQ-1; Wed, 29 Sep 2021 12:23:09 -0400
X-MC-Unique: nFL-w1UiPTeKtt0pM81wfQ-1
Received: by mail-wr1-f71.google.com with SMTP id
 h25-20020adfa4d9000000b001607d12a0b0so579715wrb.21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 09:23:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=+j4qNtz3r10+MbmLFcntFcdy8mpU9rKxm1btg9WBj6Q=;
 b=3jzDg6e5EHP+t5puljzO1NAbK6S/K1s8UADmrq6RCJokmberrdA+ja1BU+hJRCI11k
 Cy6kPN1LCHh0HloNULqI8OMCofYggnrTzLRXHQPKp+9rk/r0hk+YQpNs8bVcFgWjJW2m
 joklPXAGxfuf4bRna8ewrW1aI/ZyywFMbOifsz7mkXuI3G00BTRj8PPZAROPoW/MZTsj
 qIRxQS1Xn2gCS8SbSOBJv8Rj9OHt72kQCCvZewy5WItynXIXhKrhqh+5L4qnICzkjlZR
 B+IJTkLDj0svKBcLNv7eLYipGWTdTVDqbyd+V3usBmQIZ/Cd/XafyjYarPmlzMIh6OW6
 3e0Q==
X-Gm-Message-State: AOAM530Jy1+DMkSQDtaVY1T67ycCQdWbudBZnLUWuXYEr8rUuAYvFELR
 5Sx4bAiT2A3jkDbBw0Dlmaha3etwaaSEsvOZIEyxLeGl1KjTWAqjXxZcIIxMkhaD7xJLx5Xaf1c
 cxA2JbFlHjIMZHN+rYOdBqBj0
X-Received: by 2002:adf:de02:: with SMTP id b2mr1006133wrm.42.1632932588226;
 Wed, 29 Sep 2021 09:23:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwx3JwfLqcKKCKR9kwsjaIijoJNrYWdDJUODQjYSa6EdVLozQeoWHYLjcTq72gUKI26harjsg==
X-Received: by 2002:adf:de02:: with SMTP id b2mr1006106wrm.42.1632932588013;
 Wed, 29 Sep 2021 09:23:08 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id u1sm362768wrn.66.2021.09.29.09.23.05
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 29 Sep 2021 09:23:07 -0700 (PDT)
Subject: Re: [PATCH v3 02/10] KVM: arm64: vgic-v3: Check redist region is not
 above the VM IPA size
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
 alexandru.elisei@arm.com
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-3-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <01a03d81-e98b-a504-f4b7-e4a56ffa78d5@redhat.com>
Date: Wed, 29 Sep 2021 18:23:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210928184803.2496885-3-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: eric.auger@redhat.com
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

SGkgUmljYXJkbywKCk9uIDkvMjgvMjEgODo0NyBQTSwgUmljYXJkbyBLb2xsZXIgd3JvdGU6Cj4g
VmVyaWZ5IHRoYXQgdGhlIHJlZGlzdHJpYnV0b3IgcmVnaW9ucyBkbyBub3QgZXh0ZW5kIGJleW9u
ZCB0aGUKPiBWTS1zcGVjaWZpZWQgSVBBIHJhbmdlIChwaHlzX3NpemUpLiBUaGlzIGNhbiBoYXBw
ZW4gd2hlbiB1c2luZwo+IEtWTV9WR0lDX1YzX0FERFJfVFlQRV9SRURJU1Qgb3IgS1ZNX1ZHSUNf
VjNfQUREUl9UWVBFX1JFRElTVF9SRUdJT05TCj4gd2l0aDoKPgo+ICAgYmFzZSArIHNpemUgPiBw
aHlzX3NpemUgQU5EIGJhc2UgPCBwaHlzX3NpemUKPgo+IEFkZCB0aGUgbWlzc2luZyBjaGVjayBp
bnRvIHZnaWNfdjNfYWxsb2NfcmVkaXN0X3JlZ2lvbigpIHdoaWNoIGlzIGNhbGxlZAo+IHdoZW4g
c2V0dGluZyB0aGUgcmVnaW9ucywgYW5kIGludG8gdmdpY192M19jaGVja19iYXNlKCkgd2hpY2gg
aXMgY2FsbGVkCj4gd2hlbiBhdHRlbXB0aW5nIHRoZSBmaXJzdCB2Y3B1LXJ1bi4gVGhlIHZjcHUt
cnVuIGNoZWNrIGRvZXMgbm90IGFwcGx5IHRvCj4gS1ZNX1ZHSUNfVjNfQUREUl9UWVBFX1JFRElT
VF9SRUdJT05TIGJlY2F1c2UgdGhlIHJlZ2lvbnMgc2l6ZSBpcyBrbm93bgo+IGJlZm9yZSB0aGUg
Zmlyc3QgdmNwdS1ydW4uIE5vdGUgdGhhdCB1c2luZyB0aGUgUkVESVNUX1JFR0lPTlMgQVBJCj4g
cmVzdWx0cyBpbiBhIGRpZmZlcmVudCBjaGVjaywgd2hpY2ggYWxyZWFkeSBleGlzdHMsIGF0IGZp
cnN0IHZjcHUgcnVuOgo+IHRoYXQgdGhlIG51bWJlciBvZiByZWRpc3QgcmVnaW9ucyBpcyBlbm91
Z2ggZm9yIGFsbCB2Y3B1cy4KPgo+IEZpbmFsbHksIHRoaXMgcGF0Y2ggYWxzbyBlbmFibGVzIHNv
bWUgZXh0cmEgdGVzdHMgaW4KPiB2Z2ljX3YzX2FsbG9jX3JlZGlzdF9yZWdpb24oKSBieSBjYWxj
dWxhdGluZyAic2l6ZSIgZWFybHkgZm9yIHRoZSBsZWdhY3kKPiByZWRpc3QgYXBpOiBsaWtlIGNo
ZWNraW5nIHRoYXQgdGhlIFJFRElTVCByZWdpb24gY2FuIGZpdCBhbGwgdGhlIGFscmVhZHkKPiBj
cmVhdGVkIHZjcHVzLgo+Cj4gU2lnbmVkLW9mZi1ieTogUmljYXJkbyBLb2xsZXIgPHJpY2Fya29s
QGdvb2dsZS5jb20+Cj4gLS0tCj4gIGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1tbWlvLXYzLmMg
fCA2ICsrKystLQo+ICBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMuYyAgICAgIHwgNCArKysr
Cj4gIDIgZmlsZXMgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+Cj4g
ZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1tbWlvLXYzLmMgYi9hcmNoL2Fy
bTY0L2t2bS92Z2ljL3ZnaWMtbW1pby12My5jCj4gaW5kZXggYTA5Y2RjMGI5NTNjLi45YmUwMmJm
Nzg2NWUgMTAwNjQ0Cj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLW1taW8tdjMuYwo+
ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1tbWlvLXYzLmMKPiBAQCAtNzk2LDcgKzc5
Niw5IEBAIHN0YXRpYyBpbnQgdmdpY192M19hbGxvY19yZWRpc3RfcmVnaW9uKHN0cnVjdCBrdm0g
Kmt2bSwgdWludDMyX3QgaW5kZXgsCj4gIAlzdHJ1Y3QgdmdpY19kaXN0ICpkID0gJmt2bS0+YXJj
aC52Z2ljOwo+ICAJc3RydWN0IHZnaWNfcmVkaXN0X3JlZ2lvbiAqcmRyZWc7Cj4gIAlzdHJ1Y3Qg
bGlzdF9oZWFkICpyZF9yZWdpb25zID0gJmQtPnJkX3JlZ2lvbnM7Cj4gLQlzaXplX3Qgc2l6ZSA9
IGNvdW50ICogS1ZNX1ZHSUNfVjNfUkVESVNUX1NJWkU7Cj4gKwlpbnQgbnJfdmNwdXMgPSBhdG9t
aWNfcmVhZCgma3ZtLT5vbmxpbmVfdmNwdXMpOwo+ICsJc2l6ZV90IHNpemUgPSBjb3VudCA/IGNv
dW50ICogS1ZNX1ZHSUNfVjNfUkVESVNUX1NJWkUKPiArCQkJICAgIDogbnJfdmNwdXMgKiBLVk1f
VkdJQ19WM19SRURJU1RfU0laRTsKClRoaXMgYWN0dWFsbHkgZml4ZXMgdGhlwqAgdmdpY19kaXN0
X292ZXJsYXAoa3ZtLCBiYXNlLCBzaXplPTApCgppbiBjYXNlIHRoZSBudW1iZXIgb2Ygb25saW5l
LXZjcHVzIGF0IHRoYXQgdGltZSBpcyBsZXNzIHRoYW4gdGhlIGZpbmFsCm9uZSAoMXN0IHJ1biks
IGlmIGNvdW50PTAgKGxlZ2FjeSBBUEkpIGRvIHdlIGV2ZXIgY2hlY2sgdGhhdCB0aGUgUkRJU1QK
KHdpdGggYWNjdW11bGF0ZWQgdmNwdSByZGlzdHMpIGRvZXMgbm90IG92ZXJsYXAgd2l0aCBkaXN0
LgppbiBvdGhlciB3b3JkcyBzaG91bGRuJ3Qgd2UgY2FsbCB2Z2ljX2Rpc3Rfb3ZlcmxhcChrdm0s
IGJhc2UsIHNpemUpCmFnYWluIGluIHZnaWNfdjNfY2hlY2tfYmFzZSgpLgoKVGhhbmtzCgpFcmlj
Cgo+ICAJaW50IHJldDsKPiAgCj4gIAkvKiBjcm9zcyB0aGUgZW5kIG9mIG1lbW9yeSA/ICovCj4g
QEAgLTg0MCw3ICs4NDIsNyBAQCBzdGF0aWMgaW50IHZnaWNfdjNfYWxsb2NfcmVkaXN0X3JlZ2lv
bihzdHJ1Y3Qga3ZtICprdm0sIHVpbnQzMl90IGluZGV4LAo+ICAKPiAgCXJkcmVnLT5iYXNlID0g
VkdJQ19BRERSX1VOREVGOwo+ICAKPiAtCXJldCA9IHZnaWNfY2hlY2tfaW9hZGRyKGt2bSwgJnJk
cmVnLT5iYXNlLCBiYXNlLCBTWl82NEspOwo+ICsJcmV0ID0gdmdpY19jaGVja19pb3JhbmdlKGt2
bSwgJnJkcmVnLT5iYXNlLCBiYXNlLCBTWl82NEssIHNpemUpOwo+ICAJaWYgKHJldCkKPiAgCQln
b3RvIGZyZWU7Cj4gIAo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMu
YyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12My5jCj4gaW5kZXggMjFhNjIwN2ZiMmVlLi4y
N2VlNjc0NjMxYjMgMTAwNjQ0Cj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYzLmMK
PiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMuYwo+IEBAIC00ODYsNiArNDg2LDEw
IEBAIGJvb2wgdmdpY192M19jaGVja19iYXNlKHN0cnVjdCBrdm0gKmt2bSkKPiAgCQlpZiAocmRy
ZWctPmJhc2UgKyB2Z2ljX3YzX3JkX3JlZ2lvbl9zaXplKGt2bSwgcmRyZWcpIDwKPiAgCQkJcmRy
ZWctPmJhc2UpCj4gIAkJCXJldHVybiBmYWxzZTsKPiArCj4gKwkJaWYgKHJkcmVnLT5iYXNlICsg
dmdpY192M19yZF9yZWdpb25fc2l6ZShrdm0sIHJkcmVnKSA+Cj4gKwkJCWt2bV9waHlzX3NpemUo
a3ZtKSkKPiArCQkJcmV0dXJuIGZhbHNlOwo+ICAJfQo+ICAKPiAgCWlmIChJU19WR0lDX0FERFJf
VU5ERUYoZC0+dmdpY19kaXN0X2Jhc2UpKQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29s
dW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8v
a3ZtYXJtCg==
