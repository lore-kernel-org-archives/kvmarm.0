Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC0DC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 08:51:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 324E761994
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 08:51:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 324E761994
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F23D4B0ED;
	Thu, 30 Sep 2021 04:51:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gAg1a5pXLeGW; Thu, 30 Sep 2021 04:51:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 603D64B0AC;
	Thu, 30 Sep 2021 04:51:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80F1C4A5A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 04:51:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vEgt1FNr0V9g for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 04:51:10 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B60949DE7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 04:51:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632991870;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=enboltUA+a2UXyd2ev7IOjW3eWnVQILj4KtkTqyYnes=;
 b=gkI1PGbJEhgd5hXecWfxhUUFCErGBW7IU3QcAhWy/5PKiT+VDjF9T4HFcFEuJxk7dgGBgW
 1gyyuQ0r6lMo4Ct57C4gU22FkuS9DWdfprs8o4OasF2HPxb4uPtwwrTqybS7SlPYDt8Eyd
 Ka8ARVLBtm2KwnehBIs9jEA2tuet0lE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-HFKhlcK5NaSRHadjADHG-A-1; Thu, 30 Sep 2021 04:51:08 -0400
X-MC-Unique: HFKhlcK5NaSRHadjADHG-A-1
Received: by mail-wm1-f71.google.com with SMTP id
 r66-20020a1c4445000000b0030cf0c97157so2621888wma.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 01:51:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=enboltUA+a2UXyd2ev7IOjW3eWnVQILj4KtkTqyYnes=;
 b=ttw5JGGA+Kwup59y93sx7KkFSvAVw61U2MrESfCZJiDipU/vD2DWVJZ7hUWFbBSDAf
 W0tylIJsO4WHwJK+9ObL0clQwXU85aPPLVJXg/Fxu7aJfrsMvpSqCo/LM0GzGhtfA9js
 BEW45nOx8z2cd73NsE80IGpq23hFCjjS2wmgr4jX4tZjXeg8gF81vPBgOE2eiwfvn5cF
 F7RkQAPuzg2NTvmf2svoYJk0y6xuAAqAXZLQr8JRyFAsHfs4tJCEH9Rv9brhZgqqYYXq
 5H2A3br59k8sPujGO6p6cE5gwwxGtX+JSntDT7Dm7H591Y7LEYWhIWl06UajYcHvg4D6
 ItwA==
X-Gm-Message-State: AOAM532k3m0v1Z/Vu7wy8L+yzlBVuc4p3UddV0OxJO3nfFecghsE42pA
 UMOMtb2XcJ+ueeAp0OsM5CIzpdMsTsBB0b16Hlc4F/MgUIrjVE63NRPCj0Rfj97xlzLX0g3jYj6
 Rz0H8imm27wd4OpLQ2XDBOTZt
X-Received: by 2002:a5d:5552:: with SMTP id g18mr4749189wrw.188.1632991867662; 
 Thu, 30 Sep 2021 01:51:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJRtTvop+yA+0hkKKZHSCU+xbXl8QpnQFT7wUWD5EhjNiBLYscMcOCJ9ssbH/VORwXH9Iz1A==
X-Received: by 2002:a5d:5552:: with SMTP id g18mr4749162wrw.188.1632991867471; 
 Thu, 30 Sep 2021 01:51:07 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id i92sm2300002wri.28.2021.09.30.01.51.05
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 30 Sep 2021 01:51:06 -0700 (PDT)
Subject: Re: [PATCH v3 08/10] KVM: arm64: selftests: Add tests for GIC
 redist/cpuif partially above IPA range
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
 alexandru.elisei@arm.com
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-9-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <420f5eb6-4ed4-7c0b-266c-03b62a441b95@redhat.com>
Date: Thu, 30 Sep 2021 10:51:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210928184803.2496885-9-ricarkol@google.com>
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

SGkgUmljYXJkbywKCk9uIDkvMjgvMjEgODo0OCBQTSwgUmljYXJkbyBLb2xsZXIgd3JvdGU6Cj4g
QWRkIHRlc3RzIGZvciBjaGVja2luZyB0aGF0IEtWTSByZXR1cm5zIHRoZSByaWdodCBlcnJvciB3
aGVuIHRyeWluZyB0bwo+IHNldCBHSUN2MiBDUFUgaW50ZXJmYWNlcyBvciBHSUN2MyBSZWRpc3Ry
aWJ1dG9ycyBwYXJ0aWFsbHkgYWJvdmUgdGhlCj4gYWRkcmVzc2FibGUgSVBBIHJhbmdlLiBBbHNv
IHRpZ2h0ZW4gdGhlIElQQSByYW5nZSBieSByZXBsYWNpbmcKPiBLVk1fQ0FQX0FSTV9WTV9JUEFf
U0laRSB3aXRoIHRoZSBJUEEgcmFuZ2UgY3VycmVudGx5IGNvbmZpZ3VyZWQgZm9yIHRoZQo+IGd1
ZXN0IChpLmUuLCB0aGUgZGVmYXVsdCkuCj4KPiBUaGUgY2hlY2sgZm9yIHRoZSBHSUN2MyByZWRp
c3RyaWJ1dG9yIGNyZWF0ZWQgdXNpbmcgdGhlIFJFRElTVCBsZWdhY3kKPiBBUEkgaXMgbm90IHN1
ZmZpY2llbnQgYXMgdGhpcyBuZXcgdGVzdCBvbmx5IGNoZWNrcyB0aGUgY2hlY2sgZG9uZSB1c2lu
Zwo+IHZjcHVzIGFscmVhZHkgY3JlYXRlZCB3aGVuIHNldHRpbmcgdGhlIGJhc2UuIFRoZSBuZXh0
IGNvbW1pdCB3aWxsIGFkZAo+IHRoZSBtaXNzaW5nIHRlc3Qgd2hpY2ggdmVyaWZpZXMgdGhhdCB0
aGUgS1ZNIGNoZWNrIGlzIGRvbmUgYXQgZmlyc3QgdmNwdQo+IHJ1bi4KPgo+IFNpZ25lZC1vZmYt
Ynk6IFJpY2FyZG8gS29sbGVyIDxyaWNhcmtvbEBnb29nbGUuY29tPgo+IC0tLQo+ICAuLi4vdGVz
dGluZy9zZWxmdGVzdHMva3ZtL2FhcmNoNjQvdmdpY19pbml0LmMgfCA0NiArKysrKysrKysrKysr
Ky0tLS0tCj4gIDEgZmlsZSBjaGFuZ2VkLCAzNSBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMo
LSkKPgo+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vYWFyY2g2NC92
Z2ljX2luaXQuYyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9hYXJjaDY0L3ZnaWNfaW5p
dC5jCj4gaW5kZXggOTJmNWM2Y2E2YjhiLi43N2ExOTQxZTYxZmEgMTAwNjQ0Cj4gLS0tIGEvdG9v
bHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2FhcmNoNjQvdmdpY19pbml0LmMKPiArKysgYi90b29s
cy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vYWFyY2g2NC92Z2ljX2luaXQuYwo+IEBAIC0zMSw3ICsz
MSw3IEBAIHN0cnVjdCB2bV9naWMgewo+ICAJdWludDMyX3QgZ2ljX2Rldl90eXBlOwo+ICB9Owo+
ICAKPiAtc3RhdGljIGludCBtYXhfaXBhX2JpdHM7Cj4gK3N0YXRpYyB1aW50NjRfdCBtYXhfcGh5
c19zaXplOwo+ICAKPiAgLyogaGVscGVyIHRvIGFjY2VzcyBhIHJlZGlzdHJpYnV0b3IgcmVnaXN0
ZXIgKi8KPiAgc3RhdGljIGludCBhY2Nlc3NfdjNfcmVkaXN0X3JlZyhpbnQgZ2ljdjNfZmQsIGlu
dCB2Y3B1LCBpbnQgb2Zmc2V0LAo+IEBAIC0xNTAsMTYgKzE1MCwyMSBAQCBzdGF0aWMgdm9pZCBz
dWJ0ZXN0X2Rpc3RfcmRpc3Qoc3RydWN0IHZtX2dpYyAqdikKPiAgCVRFU1RfQVNTRVJUKHJldCAm
JiBlcnJubyA9PSBFSU5WQUwsICJHSUMgcmVkaXN0L2NwdSBiYXNlIG5vdCBhbGlnbmVkIik7Cj4g
IAo+ICAJLyogb3V0IG9mIHJhbmdlIGFkZHJlc3MgKi8KPiAtCWlmIChtYXhfaXBhX2JpdHMpIHsK
PiAtCQlhZGRyID0gMVVMTCA8PCBtYXhfaXBhX2JpdHM7Cj4gLQkJcmV0ID0gX2t2bV9kZXZpY2Vf
YWNjZXNzKHYtPmdpY19mZCwgS1ZNX0RFVl9BUk1fVkdJQ19HUlBfQUREUiwKPiAtCQkJCQkgZGlz
dC5hdHRyLCAmYWRkciwgdHJ1ZSk7Cj4gLQkJVEVTVF9BU1NFUlQocmV0ICYmIGVycm5vID09IEUy
QklHLCAiZGlzdCBhZGRyZXNzIGJleW9uZCBJUEEgbGltaXQiKTsKPiArCWFkZHIgPSBtYXhfcGh5
c19zaXplOwo+ICsJcmV0ID0gX2t2bV9kZXZpY2VfYWNjZXNzKHYtPmdpY19mZCwgS1ZNX0RFVl9B
Uk1fVkdJQ19HUlBfQUREUiwKPiArCQkJCSBkaXN0LmF0dHIsICZhZGRyLCB0cnVlKTsKPiArCVRF
U1RfQVNTRVJUKHJldCAmJiBlcnJubyA9PSBFMkJJRywgImRpc3QgYWRkcmVzcyBiZXlvbmQgSVBB
IGxpbWl0Iik7Cj4gIAo+IC0JCXJldCA9IF9rdm1fZGV2aWNlX2FjY2Vzcyh2LT5naWNfZmQsIEtW
TV9ERVZfQVJNX1ZHSUNfR1JQX0FERFIsCj4gLQkJCQkJIHJkaXN0LmF0dHIsICZhZGRyLCB0cnVl
KTsKPiAtCQlURVNUX0FTU0VSVChyZXQgJiYgZXJybm8gPT0gRTJCSUcsICJyZWRpc3QgYWRkcmVz
cyBiZXlvbmQgSVBBIGxpbWl0Iik7Cj4gLQl9Cj4gKwlyZXQgPSBfa3ZtX2RldmljZV9hY2Nlc3Mo
di0+Z2ljX2ZkLCBLVk1fREVWX0FSTV9WR0lDX0dSUF9BRERSLAo+ICsJCQkJIHJkaXN0LmF0dHIs
ICZhZGRyLCB0cnVlKTsKPiArCVRFU1RfQVNTRVJUKHJldCAmJiBlcnJubyA9PSBFMkJJRywgInJl
ZGlzdCBhZGRyZXNzIGJleW9uZCBJUEEgbGltaXQiKTsKPiArCj4gKwkvKiBTcGFjZSBmb3IgaGFs
ZiBhIHJkaXN0IChhIHJkaXN0IGlzOiAyICogcmRpc3QuYWxpZ25tZW50KS4gKi8KPiArCWFkZHIg
PSBtYXhfcGh5c19zaXplIC0gZGlzdC5hbGlnbm1lbnQ7Cj4gKwlyZXQgPSBfa3ZtX2RldmljZV9h
Y2Nlc3Modi0+Z2ljX2ZkLCBLVk1fREVWX0FSTV9WR0lDX0dSUF9BRERSLAo+ICsJCQkJIHJkaXN0
LmF0dHIsICZhZGRyLCB0cnVlKTsKPiArCVRFU1RfQVNTRVJUKHJldCAmJiBlcnJubyA9PSBFMkJJ
RywKPiArCQkJImhhbGYgb2YgdGhlIHJlZGlzdCBpcyBiZXlvbmQgSVBBIGxpbWl0Iik7Cj4gIAo+
ICAJLyogc2V0IFJFRElTVCBiYXNlIGFkZHJlc3MgQDB4MCovCj4gIAlhZGRyID0gMHgwMDAwMDsK
PiBAQCAtMjQ4LDcgKzI1MywyMSBAQCBzdGF0aWMgdm9pZCBzdWJ0ZXN0X3YzX3JlZGlzdF9yZWdp
b25zKHN0cnVjdCB2bV9naWMgKnYpCj4gIAlrdm1fZGV2aWNlX2FjY2Vzcyh2LT5naWNfZmQsIEtW
TV9ERVZfQVJNX1ZHSUNfR1JQX0FERFIsCj4gIAkJCSAgS1ZNX1ZHSUNfVjNfQUREUl9UWVBFX1JF
RElTVF9SRUdJT04sICZhZGRyLCB0cnVlKTsKPiAgCj4gLQlhZGRyID0gUkVESVNUX1JFR0lPTl9B
VFRSX0FERFIoMSwgMVVMTCA8PCBtYXhfaXBhX2JpdHMsIDAsIDIpOwo+ICsJYWRkciA9IFJFRElT
VF9SRUdJT05fQVRUUl9BRERSKDEsIG1heF9waHlzX3NpemUsIDAsIDIpOwo+ICsJcmV0ID0gX2t2
bV9kZXZpY2VfYWNjZXNzKHYtPmdpY19mZCwgS1ZNX0RFVl9BUk1fVkdJQ19HUlBfQUREUiwKPiAr
CQkJCSBLVk1fVkdJQ19WM19BRERSX1RZUEVfUkVESVNUX1JFR0lPTiwgJmFkZHIsIHRydWUpOwo+
ICsJVEVTVF9BU1NFUlQocmV0ICYmIGVycm5vID09IEUyQklHLAo+ICsJCSAgICAicmVnaXN0ZXIg
cmVkaXN0IHJlZ2lvbiB3aXRoIGJhc2UgYWRkcmVzcyBiZXlvbmQgSVBBIHJhbmdlIik7Cj4gKwo+
ICsJLyogVGhlIGxhc3QgcmVkaXN0IGlzIGFib3ZlIHRoZSBwYSByYW5nZS4gKi8KPiArCWFkZHIg
PSBSRURJU1RfUkVHSU9OX0FUVFJfQUREUigxLCBtYXhfcGh5c19zaXplIC0gMHgxMDAwMCwgMCwg
Mik7Cj4gKwlyZXQgPSBfa3ZtX2RldmljZV9hY2Nlc3Modi0+Z2ljX2ZkLCBLVk1fREVWX0FSTV9W
R0lDX0dSUF9BRERSLAo+ICsJCQkJIEtWTV9WR0lDX1YzX0FERFJfVFlQRV9SRURJU1RfUkVHSU9O
LCAmYWRkciwgdHJ1ZSk7Cj4gKwlURVNUX0FTU0VSVChyZXQgJiYgZXJybm8gPT0gRTJCSUcsCj4g
KwkJICAgICJyZWdpc3RlciByZWRpc3QgcmVnaW9uIHdpdGggYmFzZSBhZGRyZXNzIGJleW9uZCBJ
UEEgcmFuZ2UiKTsKcy9iYXNlIGFkZHJlc3MvdG9wIGFkZHJlc3MKPiArCj4gKwkvKiBUaGUgbGFz
dCByZWRpc3QgaXMgYWJvdmUgdGhlIHBhIHJhbmdlLiAqLwo+ICsJYWRkciA9IFJFRElTVF9SRUdJ
T05fQVRUUl9BRERSKDIsIG1heF9waHlzX3NpemUgLSAweDMwMDAwLCAwLCAyKTsKPiAgCXJldCA9
IF9rdm1fZGV2aWNlX2FjY2Vzcyh2LT5naWNfZmQsIEtWTV9ERVZfQVJNX1ZHSUNfR1JQX0FERFIs
Cj4gIAkJCQkgS1ZNX1ZHSUNfVjNfQUREUl9UWVBFX1JFRElTVF9SRUdJT04sICZhZGRyLCB0cnVl
KTsKV2h5IHRoaXMgc2Vjb25kIGNoZWNrPwo+ICAJVEVTVF9BU1NFUlQocmV0ICYmIGVycm5vID09
IEUyQklHLAo+IEBAIC02MDgsOCArNjI3LDEzIEBAIHZvaWQgcnVuX3Rlc3RzKHVpbnQzMl90IGdp
Y19kZXZfdHlwZSkKPiAgaW50IG1haW4oaW50IGFjLCBjaGFyICoqYXYpCj4gIHsKPiAgCWludCBy
ZXQ7Cj4gKwlpbnQgbWF4X2lwYV9iaXRzLCBwYV9iaXRzOwo+ICAKPiAgCW1heF9pcGFfYml0cyA9
IGt2bV9jaGVja19jYXAoS1ZNX0NBUF9BUk1fVk1fSVBBX1NJWkUpOwo+ICsJcGFfYml0cyA9IHZt
X2d1ZXN0X21vZGVfcGFyYW1zW1ZNX01PREVfREVGQVVMVF0ucGFfYml0czsKPiArCVRFU1RfQVNT
RVJUKG1heF9pcGFfYml0cyAmJiBwYV9iaXRzIDw9IG1heF9pcGFfYml0cywKPiArCQkiVGhlIGRl
ZmF1bHQgUEEgcmFuZ2Ugc2hvdWxkIG5vdCBiZSBsYXJnZXIgdGhhbiB0aGUgbWF4LiIpOwpJc24n
dCBpdCBhbHJlYWR5IGVuZm9yY2VkIGluIHRoZSB0ZXN0IGluZnJhIGluc3RlYWQ/Ckkgc2VlIGlu
IGxpYi9rdm1fdXRpbC5jCgojaWZkZWYgX19hYXJjaDY0X18KwqDCoMKgwqDCoMKgwqAgaWYgKHZt
LT5wYV9iaXRzICE9IDQwKQrCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdm0tPnR5cGUg
PSBLVk1fVk1fVFlQRV9BUk1fSVBBX1NJWkUodm0tPnBhX2JpdHMpOwojZW5kaWYKCnZtX29wZW4o
KQo+ICsJbWF4X3BoeXNfc2l6ZSA9IDFVTEwgPDwgcGFfYml0czsKPiAgCj4gIAlyZXQgPSB0ZXN0
X2t2bV9kZXZpY2UoS1ZNX0RFVl9UWVBFX0FSTV9WR0lDX1YzKTsKPiAgCWlmICghcmV0KSB7CkVy
aWMKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFy
bSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3Rz
LmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
