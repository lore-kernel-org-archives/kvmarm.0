Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B13EEC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 07:05:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 32E7B61875
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 07:05:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 32E7B61875
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEBFC4B0E6;
	Thu, 30 Sep 2021 03:05:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tLoZcJC4BRGr; Thu, 30 Sep 2021 03:05:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9597E4B0F4;
	Thu, 30 Sep 2021 03:05:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84B764A3BF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 03:05:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gvfYMBAeZVJm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 03:05:52 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 867834A19F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 03:05:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632985552;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=NPxgFLmqZWu1Kx8EeiiAue/eLiILneW6MYMbx6p9Jvo=;
 b=Lnyp1Ucfrz3eBFaW48b+u0VpD6802BoF356HM5zDOSzVd2+wlIVHfj708Rm0iHWBwWOyN4
 IzYPZEmzcWdBLdnzH3ygVJ0SebS5al2TDJsYy1hvX0I46WxSyejSShQ2a5mTtHr4bcTy7p
 ImfEKk/0ESk1fThs0J6RTMwfejYG3+g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-zPOb76EtNfusLpFKBc0STw-1; Thu, 30 Sep 2021 03:05:51 -0400
X-MC-Unique: zPOb76EtNfusLpFKBc0STw-1
Received: by mail-wr1-f72.google.com with SMTP id
 t2-20020adf97c2000000b001608326aa2fso579247wrb.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 00:05:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=NPxgFLmqZWu1Kx8EeiiAue/eLiILneW6MYMbx6p9Jvo=;
 b=FVTXNwWNJ1DjJo3VHHUAfLUxL/83/lGvLUNHUxT/BvXELpMZjhPYftSOKKULLkOAFk
 RCSu7yayAZHuB/desvpU37QMcMYRJwvO0q1dLu+DC22UMqTgugwGO3q4kMLN49FQrGKS
 hA0SKvTt4BXR/JiEd+7zCUOj810+qviFRzngqJ0KlzR++fIg9Wt697A5HVokG5WAgSuF
 z+6F/7CvIlp8aoJNtV56bgn0aCh+hg4ZSCvYIT+n2remAcasgfy2LBvCqwjzGP6WCPGM
 VgwnjnOtSXDFSSJtohU1yLVFQXji+KCt8BP7bUEC8x9yGmsQyyQ/4m8lgoNY5rIDvqLs
 2hIQ==
X-Gm-Message-State: AOAM533qxaPspTdJK3tlGlICRr/WMjCDaMwOwaQ8TSg/S0GwXx1/AHxa
 LHE1V6ihG6kaeoUN80YJXB1xauiSWxhNc1Pg00tA9BqBY358D26t6IhQHkwvSMa2S7uD5tu1t8g
 11e2a1QK2l0Z5T0olxuzxhDQ4
X-Received: by 2002:adf:fe11:: with SMTP id n17mr4301786wrr.134.1632985549809; 
 Thu, 30 Sep 2021 00:05:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPFzm1+CNYCOyn9mGIKj/RMEWH6HvJ5lcr4FpM7YtYjgUAbjlCnpqy/qSj/9ubMkgG9Yyp/A==
X-Received: by 2002:adf:fe11:: with SMTP id n17mr4301747wrr.134.1632985549481; 
 Thu, 30 Sep 2021 00:05:49 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id g21sm1934742wmk.10.2021.09.30.00.05.48
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 30 Sep 2021 00:05:49 -0700 (PDT)
Subject: Re: [PATCH v3 02/10] KVM: arm64: vgic-v3: Check redist region is not
 above the VM IPA size
To: Ricardo Koller <ricarkol@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-3-ricarkol@google.com>
 <01a03d81-e98b-a504-f4b7-e4a56ffa78d5@redhat.com>
 <YVTWVf26yYNUUx2L@google.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <dac39cc1-16d7-caed-833f-03943b0e6211@redhat.com>
Date: Thu, 30 Sep 2021 09:05:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YVTWVf26yYNUUx2L@google.com>
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

SGksCgpPbiA5LzI5LzIxIDExOjEwIFBNLCBSaWNhcmRvIEtvbGxlciB3cm90ZToKPiBIaSBFcmlj
LAo+Cj4gT24gV2VkLCBTZXAgMjksIDIwMjEgYXQgMDY6MjM6MDRQTSArMDIwMCwgRXJpYyBBdWdl
ciB3cm90ZToKPj4gSGkgUmljYXJkbywKPj4KPj4gT24gOS8yOC8yMSA4OjQ3IFBNLCBSaWNhcmRv
IEtvbGxlciB3cm90ZToKPj4+IFZlcmlmeSB0aGF0IHRoZSByZWRpc3RyaWJ1dG9yIHJlZ2lvbnMg
ZG8gbm90IGV4dGVuZCBiZXlvbmQgdGhlCj4+PiBWTS1zcGVjaWZpZWQgSVBBIHJhbmdlIChwaHlz
X3NpemUpLiBUaGlzIGNhbiBoYXBwZW4gd2hlbiB1c2luZwo+Pj4gS1ZNX1ZHSUNfVjNfQUREUl9U
WVBFX1JFRElTVCBvciBLVk1fVkdJQ19WM19BRERSX1RZUEVfUkVESVNUX1JFR0lPTlMKPj4+IHdp
dGg6Cj4+Pgo+Pj4gICBiYXNlICsgc2l6ZSA+IHBoeXNfc2l6ZSBBTkQgYmFzZSA8IHBoeXNfc2l6
ZQo+Pj4KPj4+IEFkZCB0aGUgbWlzc2luZyBjaGVjayBpbnRvIHZnaWNfdjNfYWxsb2NfcmVkaXN0
X3JlZ2lvbigpIHdoaWNoIGlzIGNhbGxlZAo+Pj4gd2hlbiBzZXR0aW5nIHRoZSByZWdpb25zLCBh
bmQgaW50byB2Z2ljX3YzX2NoZWNrX2Jhc2UoKSB3aGljaCBpcyBjYWxsZWQKPj4+IHdoZW4gYXR0
ZW1wdGluZyB0aGUgZmlyc3QgdmNwdS1ydW4uIFRoZSB2Y3B1LXJ1biBjaGVjayBkb2VzIG5vdCBh
cHBseSB0bwo+Pj4gS1ZNX1ZHSUNfVjNfQUREUl9UWVBFX1JFRElTVF9SRUdJT05TIGJlY2F1c2Ug
dGhlIHJlZ2lvbnMgc2l6ZSBpcyBrbm93bgo+Pj4gYmVmb3JlIHRoZSBmaXJzdCB2Y3B1LXJ1bi4g
Tm90ZSB0aGF0IHVzaW5nIHRoZSBSRURJU1RfUkVHSU9OUyBBUEkKPj4+IHJlc3VsdHMgaW4gYSBk
aWZmZXJlbnQgY2hlY2ssIHdoaWNoIGFscmVhZHkgZXhpc3RzLCBhdCBmaXJzdCB2Y3B1IHJ1bjoK
Pj4+IHRoYXQgdGhlIG51bWJlciBvZiByZWRpc3QgcmVnaW9ucyBpcyBlbm91Z2ggZm9yIGFsbCB2
Y3B1cy4KPj4+Cj4+PiBGaW5hbGx5LCB0aGlzIHBhdGNoIGFsc28gZW5hYmxlcyBzb21lIGV4dHJh
IHRlc3RzIGluCj4+PiB2Z2ljX3YzX2FsbG9jX3JlZGlzdF9yZWdpb24oKSBieSBjYWxjdWxhdGlu
ZyAic2l6ZSIgZWFybHkgZm9yIHRoZSBsZWdhY3kKPj4+IHJlZGlzdCBhcGk6IGxpa2UgY2hlY2tp
bmcgdGhhdCB0aGUgUkVESVNUIHJlZ2lvbiBjYW4gZml0IGFsbCB0aGUgYWxyZWFkeQo+Pj4gY3Jl
YXRlZCB2Y3B1cy4KPj4+Cj4+PiBTaWduZWQtb2ZmLWJ5OiBSaWNhcmRvIEtvbGxlciA8cmljYXJr
b2xAZ29vZ2xlLmNvbT4KPj4+IC0tLQo+Pj4gIGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1tbWlv
LXYzLmMgfCA2ICsrKystLQo+Pj4gIGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12My5jICAgICAg
fCA0ICsrKysKPj4+ICAyIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlv
bnMoLSkKPj4+Cj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLW1taW8t
djMuYyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1tbWlvLXYzLmMKPj4+IGluZGV4IGEwOWNk
YzBiOTUzYy4uOWJlMDJiZjc4NjVlIDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdp
Yy92Z2ljLW1taW8tdjMuYwo+Pj4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLW1taW8t
djMuYwo+Pj4gQEAgLTc5Niw3ICs3OTYsOSBAQCBzdGF0aWMgaW50IHZnaWNfdjNfYWxsb2NfcmVk
aXN0X3JlZ2lvbihzdHJ1Y3Qga3ZtICprdm0sIHVpbnQzMl90IGluZGV4LAo+Pj4gIAlzdHJ1Y3Qg
dmdpY19kaXN0ICpkID0gJmt2bS0+YXJjaC52Z2ljOwo+Pj4gIAlzdHJ1Y3QgdmdpY19yZWRpc3Rf
cmVnaW9uICpyZHJlZzsKPj4+ICAJc3RydWN0IGxpc3RfaGVhZCAqcmRfcmVnaW9ucyA9ICZkLT5y
ZF9yZWdpb25zOwo+Pj4gLQlzaXplX3Qgc2l6ZSA9IGNvdW50ICogS1ZNX1ZHSUNfVjNfUkVESVNU
X1NJWkU7Cj4+PiArCWludCBucl92Y3B1cyA9IGF0b21pY19yZWFkKCZrdm0tPm9ubGluZV92Y3B1
cyk7Cj4+PiArCXNpemVfdCBzaXplID0gY291bnQgPyBjb3VudCAqIEtWTV9WR0lDX1YzX1JFRElT
VF9TSVpFCj4+PiArCQkJICAgIDogbnJfdmNwdXMgKiBLVk1fVkdJQ19WM19SRURJU1RfU0laRTsK
Pj4gVGhpcyBhY3R1YWxseSBmaXhlcyB0aGXCoCB2Z2ljX2Rpc3Rfb3ZlcmxhcChrdm0sIGJhc2Us
IHNpemU9MCkKPj4KPj4gaW4gY2FzZSB0aGUgbnVtYmVyIG9mIG9ubGluZS12Y3B1cyBhdCB0aGF0
IHRpbWUgaXMgbGVzcyB0aGFuIHRoZSBmaW5hbAo+PiBvbmUgKDFzdCBydW4pLCBpZiBjb3VudD0w
IChsZWdhY3kgQVBJKSBkbyB3ZSBldmVyIGNoZWNrIHRoYXQgdGhlIFJESVNUCj4+ICh3aXRoIGFj
Y3VtdWxhdGVkIHZjcHUgcmRpc3RzKSBkb2VzIG5vdCBvdmVybGFwIHdpdGggZGlzdC4KPj4gaW4g
b3RoZXIgd29yZHMgc2hvdWxkbid0IHdlIGNhbGwgdmdpY19kaXN0X292ZXJsYXAoa3ZtLCBiYXNl
LCBzaXplKQo+PiBhZ2FpbiBpbiB2Z2ljX3YzX2NoZWNrX2Jhc2UoKS4KPj4KPiBJIHRoaW5rIHdl
J3JlIGdvb2Q7IHRoYXQncyBjaGVja2VkIGJ5IHZnaWNfdjNfcmRpc3Rfb3ZlcmxhcChkaXN0X2Jh
c2UpCj4gaW4gdmdpY192M19jaGVja19iYXNlKCkuIFRoaXMgZnVuY3Rpb24gdXNlcyB0aGUgb25s
eSByZWdpb24gKGxlZ2FjeQo+IGNhc2UpIHVzaW5nIGEgc2l6ZSBiYXNlZCBvbiB0aGUgb25saW5l
X3ZjcHVzIChpbgo+IHZnaWNfdjNfcmRfcmVnaW9uX3NpemUoKSkuICBUaGlzIGV4YWN0IHNpdHVh
dGlvbiBpcyB0ZXN0ZWQgYnkKPiB0ZXN0X3ZnaWNfdGhlbl92Y3B1cygpIGluIHRoZSB2Z2ljX2lu
aXQgc2VsZnRlc3QuCkFoIE9LIHNvIHRoYXQncyBmaW5lIHRoZW4uCgpTbyBsb29rcyBnb29kIHRv
IG1lClJldmlld2VkLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+CgoKRXJp
YwoKCj4KPiBUaGFua3MsCj4gUmljYXJkbwo+Cj4+IFRoYW5rcwo+Pgo+PiBFcmljCj4+Cj4+PiAg
CWludCByZXQ7Cj4+PiAgCj4+PiAgCS8qIGNyb3NzIHRoZSBlbmQgb2YgbWVtb3J5ID8gKi8KPj4+
IEBAIC04NDAsNyArODQyLDcgQEAgc3RhdGljIGludCB2Z2ljX3YzX2FsbG9jX3JlZGlzdF9yZWdp
b24oc3RydWN0IGt2bSAqa3ZtLCB1aW50MzJfdCBpbmRleCwKPj4+ICAKPj4+ICAJcmRyZWctPmJh
c2UgPSBWR0lDX0FERFJfVU5ERUY7Cj4+PiAgCj4+PiAtCXJldCA9IHZnaWNfY2hlY2tfaW9hZGRy
KGt2bSwgJnJkcmVnLT5iYXNlLCBiYXNlLCBTWl82NEspOwo+Pj4gKwlyZXQgPSB2Z2ljX2NoZWNr
X2lvcmFuZ2Uoa3ZtLCAmcmRyZWctPmJhc2UsIGJhc2UsIFNaXzY0Sywgc2l6ZSk7Cj4+PiAgCWlm
IChyZXQpCj4+PiAgCQlnb3RvIGZyZWU7Cj4+PiAgCj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02
NC9rdm0vdmdpYy92Z2ljLXYzLmMgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMuYwo+Pj4g
aW5kZXggMjFhNjIwN2ZiMmVlLi4yN2VlNjc0NjMxYjMgMTAwNjQ0Cj4+PiAtLS0gYS9hcmNoL2Fy
bTY0L2t2bS92Z2ljL3ZnaWMtdjMuYwo+Pj4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2lj
LXYzLmMKPj4+IEBAIC00ODYsNiArNDg2LDEwIEBAIGJvb2wgdmdpY192M19jaGVja19iYXNlKHN0
cnVjdCBrdm0gKmt2bSkKPj4+ICAJCWlmIChyZHJlZy0+YmFzZSArIHZnaWNfdjNfcmRfcmVnaW9u
X3NpemUoa3ZtLCByZHJlZykgPAo+Pj4gIAkJCXJkcmVnLT5iYXNlKQo+Pj4gIAkJCXJldHVybiBm
YWxzZTsKPj4+ICsKPj4+ICsJCWlmIChyZHJlZy0+YmFzZSArIHZnaWNfdjNfcmRfcmVnaW9uX3Np
emUoa3ZtLCByZHJlZykgPgo+Pj4gKwkJCWt2bV9waHlzX3NpemUoa3ZtKSkKPj4+ICsJCQlyZXR1
cm4gZmFsc2U7Cj4+PiAgCX0KPj4+ICAKPj4+ICAJaWYgKElTX1ZHSUNfQUREUl9VTkRFRihkLT52
Z2ljX2Rpc3RfYmFzZSkpCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
