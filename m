Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74AE4C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 08:05:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DEDF861872
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 08:05:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DEDF861872
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DC884B2CF;
	Tue,  5 Oct 2021 04:05:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hY9W6YWE2G13; Tue,  5 Oct 2021 04:05:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CABE4B2B2;
	Tue,  5 Oct 2021 04:05:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EFDC4B2AE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 04:05:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e1A5baHd620h for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 04:05:01 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 637FB4B286
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 04:05:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633421101;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=gklNfVRGxQIjBCi8Hh1zAoj858irX/ymXQQZNwnJwkc=;
 b=imGToXyFD3WEatQNFI/yq+fHFfl+1/ZtNj/OxsQzEuTN7G6NV0XIWRYHc3JaLo77e5lkGy
 oLVcFrcJu5jnNXTp4UpjpRYsOXZ2RE7emQjfVJWmE/zsLXvacbQ/pC/TArGp+Y1fP7t3wJ
 uS5bysL3uiDYjYKanKIasuD8zPRGbmA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-Ierfz0ywN3WMFf5G9sQnww-1; Tue, 05 Oct 2021 04:05:00 -0400
X-MC-Unique: Ierfz0ywN3WMFf5G9sQnww-1
Received: by mail-wm1-f71.google.com with SMTP id
 f11-20020a7bcd0b000000b0030d72d5d0bcso1040648wmj.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 01:04:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=gklNfVRGxQIjBCi8Hh1zAoj858irX/ymXQQZNwnJwkc=;
 b=uzzZvOVEIGPZn1CSDZFkvBQzlISvCcjJIMwAQeUtEieEMxpT1Xrp00ukr8MFVuoJ1w
 AIQX7ZqqSC15R4n0N2D3lQueumNOibg0EaPxIPtUNLQnDYmSKwXm04T8b/p+I2SYrwqg
 AAKrUxeje+mefMPLls/4rlwjJ/B6PflPwuM9oINJYUS+OBnrItpdQfdJcJjqV2RXAKOS
 mPW5PMszl6XmmEcEXHEQNTaEyB6NbLIlkpmxTLZYwl8HCzhOl+eYsFrPqO0AOXhL3WlM
 D/QQaohNJJP1QYYwA8T5/05gdWV7z0pAQ2NQjPzsxJqstZOEBx2gCzKeBkRWmJpXj2cJ
 HKDw==
X-Gm-Message-State: AOAM530B8kP3k9TaGL6Bi2ZSDA+k9hs887yAdV1MYrKXey1dzNNYRk0p
 R7jTmMQJbnAITJcw2QhUwJkOG+KDe7e6l2L33YtzaYp3/nvRO9P11AgjkaBJlN/otMQWNerbVej
 SlZkbU4B6JeWnLfMTAWeyySwl
X-Received: by 2002:adf:a2c8:: with SMTP id t8mr20005782wra.215.1633421098140; 
 Tue, 05 Oct 2021 01:04:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlaPijAZfsA34o02kPUXvRBvIjJlj4e1qsBu/2dROHMbJpyeCYXCFroKPG5UkjU22RNIOuIg==
X-Received: by 2002:adf:a2c8:: with SMTP id t8mr20005572wra.215.1633421095940; 
 Tue, 05 Oct 2021 01:04:55 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id n17sm9626078wrw.16.2021.10.05.01.04.54
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 05 Oct 2021 01:04:55 -0700 (PDT)
Subject: Re: [PATCH v3 10/10] KVM: arm64: selftests: Add basic ITS device tests
To: Ricardo Koller <ricarkol@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210929001012.2539461-1-ricarkol@google.com>
 <a7df5700-ebef-9fd3-3067-ae35cbaaf3a9@redhat.com>
 <YVYZuBrvV7fnWTSs@google.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <3b7dfd42-5bb2-1fe1-3283-96a1141e68e4@redhat.com>
Date: Tue, 5 Oct 2021 10:04:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YVYZuBrvV7fnWTSs@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, maz@kernel.org, shuah@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

SGkgUmljYXJkbywKCk9uIDkvMzAvMjEgMTA6MTAgUE0sIFJpY2FyZG8gS29sbGVyIHdyb3RlOgo+
IEhpIEVyaWMsCj4KPiBPbiBUaHUsIFNlcCAzMCwgMjAyMSBhdCAxMToxNDowMkFNICswMjAwLCBF
cmljIEF1Z2VyIHdyb3RlOgo+PiBIaSBSaWNhcmRvLAo+Pgo+PiBPbiA5LzI5LzIxIDI6MTAgQU0s
IFJpY2FyZG8gS29sbGVyIHdyb3RlOgo+Pj4gQWRkIHNvbWUgSVRTIGRldmljZSB0ZXN0czogZ2Vu
ZXJhbCBLVk0gZGV2aWNlIHRlc3RzIChhZGRyZXNzIG5vdCBkZWZpbmVkCj4+PiBhbHJlYWR5LCBh
ZGRyZXNzIGFsaWduZWQpIGFuZCB0ZXN0cyBmb3IgdGhlIElUUyByZWdpb24gYmVpbmcgd2l0aGlu
IHRoZQo+Pj4gYWRkcmVzc2FibGUgSVBBIHJhbmdlLgo+Pj4KPj4+IFNpZ25lZC1vZmYtYnk6IFJp
Y2FyZG8gS29sbGVyIDxyaWNhcmtvbEBnb29nbGUuY29tPgo+Pj4gLS0tCj4+PiAgLi4uL3Rlc3Rp
bmcvc2VsZnRlc3RzL2t2bS9hYXJjaDY0L3ZnaWNfaW5pdC5jIHwgNDIgKysrKysrKysrKysrKysr
KysrKwo+Pj4gIDEgZmlsZSBjaGFuZ2VkLCA0MiBpbnNlcnRpb25zKCspCj4+Pgo+Pj4gZGlmZiAt
LWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9hYXJjaDY0L3ZnaWNfaW5pdC5jIGIv
dG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2FhcmNoNjQvdmdpY19pbml0LmMKPj4+IGluZGV4
IDQxN2E5YTUxNWNhZC4uMTgwMjIxZWMzMjVkIDEwMDY0NAo+Pj4gLS0tIGEvdG9vbHMvdGVzdGlu
Zy9zZWxmdGVzdHMva3ZtL2FhcmNoNjQvdmdpY19pbml0LmMKPj4+ICsrKyBiL3Rvb2xzL3Rlc3Rp
bmcvc2VsZnRlc3RzL2t2bS9hYXJjaDY0L3ZnaWNfaW5pdC5jCj4+PiBAQCAtNjAzLDYgKzYwMyw0
NyBAQCBzdGF0aWMgdm9pZCB0ZXN0X3YzX3JlZGlzdF9pcGFfcmFuZ2VfY2hlY2tfYXRfdmNwdV9y
dW4odm9pZCkKPj4+ICAJdm1fZ2ljX2Rlc3Ryb3koJnYpOwo+Pj4gIH0KPj4+ICAKPj4+ICtzdGF0
aWMgdm9pZCB0ZXN0X3YzX2l0c19yZWdpb24odm9pZCkKPj4+ICt7Cj4+PiArCXN0cnVjdCB2bV9n
aWMgdjsKPj4+ICsJdWludDY0X3QgYWRkcjsKPj4+ICsJaW50IGl0c19mZCwgcmV0Owo+Pj4gKwo+
Pj4gKwl2ID0gdm1fZ2ljX2NyZWF0ZV93aXRoX3ZjcHVzKEtWTV9ERVZfVFlQRV9BUk1fVkdJQ19W
MywgTlJfVkNQVVMpOwo+Pj4gKwlpdHNfZmQgPSBrdm1fY3JlYXRlX2RldmljZSh2LnZtLCBLVk1f
REVWX1RZUEVfQVJNX1ZHSUNfSVRTLCBmYWxzZSk7Cj4+IHRoaXMgbWF5IGZhaWwgaWYgdGhlIElU
UyBkZXZpY2UgaGFzIG5vdCBiZWVuIHJlZ2lzdGVyZWQgYnkgS1ZNIChob3N0IEdJQ3YyKQo+IEF0
IHRoZSBtb21lbnQgaXQncyBqdXN0IGNhbGxlZCBpbiB0aGUgR0lDdjMgY2FzZS4gSXQgc2VlbXMg
dGhhdApPSyBJIG1pc3NlZCB0aGF0LiBpbiB0aGF0IGNhc2UgdGhhdCdzIGZpbmUuCgpUaGFua3MK
CkVyaWMKPiByZWdpc3RlcmluZyBhIEdJQ3YzIGRldmljZSByZXN1bHRzIGluIGhhdmluZyBhbiBJ
VFMgcmVnaXN0ZXJlZCBhcyB3ZWxsCj4gKGZyb20ga3ZtX3JlZ2lzdGVyX3ZnaWNfZGV2aWNlKCkp
LiBJJ20gYXNzdW1pbmcgdGhpcyB3b24ndCBjaGFuZ2U7Cj4gd2UgbWlnaHQgYXMgd2VsbCBjaGVj
ayB0aGF0IGFzc3VtcHRpb24uIFdoYXQgZG8geW91IHRoaW5rPwo+Cj4gVGhhbmtzLAo+IFJpY2Fy
ZG8KPgo+PiBNYXliZSByZWZpbmUgdGhlIHBhdGNoIHRpdGxlIG1lbnRpb25uaW5nIHRoaXMgaXMg
YW4gSVRTIGRldmljZSAiaW5pdCIgdGVzdC4KPj4gYXMgcGVyIERvY3VtZW50YXRpb24vdmlydC9r
dm0vZGV2aWNlcy9hcm0tdmdpYy1pdHMucnN0IHdlIGNvdWxkIGFsc28gdHJ5Cj4+IGluc3RhbnRp
YXRpbmcgdGhlIElUUyBiZWZvcmUgdGhlIEdJQyBhbmQgdHJ5IGluc3RhbnRpYXRpbmcgc2V2ZXJh
bCBJVFNzCj4+IHdpdGggb3ZlcmxhcHBpbmcgYWRkcmVzc2VzLgo+PiBCdXQgSSB3b3VsZCB0b3Rh
bGx5IHVuZGVyc3RhbmQgaWYgeW91IGNvbnNpZGVyIHRoaXMgb3V0IG9mIHRoZSBzY29wZSBvZgo+
PiB5b3VywqAgZml4ZXMgKyB0ZXN0cy4KPj4KPj4gVGhhbmtzIQo+Pgo+PiBFcmljCj4+PiArCj4+
PiArCWFkZHIgPSAweDQwMTAwMDsKPj4+ICsJcmV0ID0gX2t2bV9kZXZpY2VfYWNjZXNzKGl0c19m
ZCwgS1ZNX0RFVl9BUk1fVkdJQ19HUlBfQUREUiwKPj4+ICsJCQkgIEtWTV9WR0lDX0lUU19BRERS
X1RZUEUsICZhZGRyLCB0cnVlKTsKPj4+ICsJVEVTVF9BU1NFUlQocmV0ICYmIGVycm5vID09IEVJ
TlZBTCwKPj4+ICsJCSJJVFMgcmVnaW9uIHdpdGggbWlzYWxpZ25lZCBhZGRyZXNzIik7Cj4+PiAr
Cj4+PiArCWFkZHIgPSBtYXhfcGh5c19zaXplOwo+Pj4gKwlyZXQgPSBfa3ZtX2RldmljZV9hY2Nl
c3MoaXRzX2ZkLCBLVk1fREVWX0FSTV9WR0lDX0dSUF9BRERSLAo+Pj4gKwkJCSAgS1ZNX1ZHSUNf
SVRTX0FERFJfVFlQRSwgJmFkZHIsIHRydWUpOwo+Pj4gKwlURVNUX0FTU0VSVChyZXQgJiYgZXJy
bm8gPT0gRTJCSUcsCj4+PiArCQkicmVnaXN0ZXIgSVRTIHJlZ2lvbiB3aXRoIGJhc2UgYWRkcmVz
cyBiZXlvbmQgSVBBIHJhbmdlIik7Cj4+PiArCj4+PiArCWFkZHIgPSBtYXhfcGh5c19zaXplIC0g
MHgxMDAwMDsKPj4+ICsJcmV0ID0gX2t2bV9kZXZpY2VfYWNjZXNzKGl0c19mZCwgS1ZNX0RFVl9B
Uk1fVkdJQ19HUlBfQUREUiwKPj4+ICsJCQkgIEtWTV9WR0lDX0lUU19BRERSX1RZUEUsICZhZGRy
LCB0cnVlKTsKPj4+ICsJVEVTVF9BU1NFUlQocmV0ICYmIGVycm5vID09IEUyQklHLAo+Pj4gKwkJ
IkhhbGYgb2YgSVRTIHJlZ2lvbiBpcyBiZXlvbmQgSVBBIHJhbmdlIik7Cj4+PiArCj4+PiArCS8q
IFRoaXMgb25lIHN1Y2NlZWRzIHNldHRpbmcgdGhlIElUUyBiYXNlICovCj4+PiArCWFkZHIgPSAw
eDQwMDAwMDsKPj4+ICsJa3ZtX2RldmljZV9hY2Nlc3MoaXRzX2ZkLCBLVk1fREVWX0FSTV9WR0lD
X0dSUF9BRERSLAo+Pj4gKwkJCSAgS1ZNX1ZHSUNfSVRTX0FERFJfVFlQRSwgJmFkZHIsIHRydWUp
Owo+Pj4gKwo+Pj4gKwlhZGRyID0gMHgzMDAwMDA7Cj4+PiArCXJldCA9IF9rdm1fZGV2aWNlX2Fj
Y2VzcyhpdHNfZmQsIEtWTV9ERVZfQVJNX1ZHSUNfR1JQX0FERFIsCj4+PiArCQkJICBLVk1fVkdJ
Q19JVFNfQUREUl9UWVBFLCAmYWRkciwgdHJ1ZSk7Cj4+PiArCVRFU1RfQVNTRVJUKHJldCAmJiBl
cnJubyA9PSBFRVhJU1QsICJJVFMgYmFzZSBzZXQgYWdhaW4iKTsKPj4+ICsKPj4+ICsJY2xvc2Uo
aXRzX2ZkKTsKPj4+ICsJdm1fZ2ljX2Rlc3Ryb3koJnYpOwo+Pj4gK30KPj4+ICsKPj4+ICAvKgo+
Pj4gICAqIFJldHVybnMgMCBpZiBpdCdzIHBvc3NpYmxlIHRvIGNyZWF0ZSBHSUMgZGV2aWNlIG9m
IGEgZ2l2ZW4gdHlwZSAoVjIgb3IgVjMpLgo+Pj4gICAqLwo+Pj4gQEAgLTY1NSw2ICs2OTYsNyBA
QCB2b2lkIHJ1bl90ZXN0cyh1aW50MzJfdCBnaWNfZGV2X3R5cGUpCj4+PiAgCQl0ZXN0X3YzX2xh
c3RfYml0X3JlZGlzdF9yZWdpb25zKCk7Cj4+PiAgCQl0ZXN0X3YzX2xhc3RfYml0X3NpbmdsZV9y
ZGlzdCgpOwo+Pj4gIAkJdGVzdF92M19yZWRpc3RfaXBhX3JhbmdlX2NoZWNrX2F0X3ZjcHVfcnVu
KCk7Cj4+PiArCQl0ZXN0X3YzX2l0c19yZWdpb24oKTsKPj4+ICAJfQo+Pj4gIH0KPj4+ICAKCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWls
aW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNv
bHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
