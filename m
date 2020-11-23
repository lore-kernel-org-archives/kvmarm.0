Return-Path: <SRS0=PaY3=E5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9045CC56202
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 09:18:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C841420758
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 09:18:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="zL0RtJ76"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C841420758
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 243944BAE2;
	Mon, 23 Nov 2020 04:18:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id enVOGG48Zeog; Mon, 23 Nov 2020 04:18:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B340A4B99C;
	Mon, 23 Nov 2020 04:18:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6CDA4B7ED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 04:18:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rDmzrDfMaqof for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Nov 2020 04:18:33 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 74B704B7E8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 04:18:33 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1F88B20756;
 Mon, 23 Nov 2020 09:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606123112;
 bh=C/lxpp7FZiY5qUG7l0C+bvs6KtaP5gm2+UNhTyakw90=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=zL0RtJ76w/RcGBo6LYyu2dL+g9/Myj0NLlpLkQxp9QHkYvyucxrn9RRexgpzCHSBb
 4rbJtKhuSJz62Viua0gYXO/TeIMCOJkvYvvo2RCMsiNeSFDe9+NL7OtSye3tFFgCnw
 BhNc8j5c/xQcFOi2JX+9+lELUJviA+g+R6EtT6TU=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kh7zR-00Cro8-Th; Mon, 23 Nov 2020 09:18:30 +0000
MIME-Version: 1.0
Date: Mon, 23 Nov 2020 09:18:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: Shenming Lu <lushenming@huawei.com>
Subject: Re: [RFC PATCH v1 2/4] KVM: arm64: GICv4.1: Try to save hw pending
 state in save_pending_tables
In-Reply-To: <20201123065410.1915-3-lushenming@huawei.com>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-3-lushenming@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <f3ea1b24436bb86b5a5633f8ccc9b3d1@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lushenming@huawei.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, christoffer.dall@arm.com,
 alex.williamson@redhat.com, kwankhede@nvidia.com, cohuck@redhat.com,
 cjia@nvidia.com, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Neo Jia <cjia@nvidia.com>, kvm@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Kirti Wankhede <kwankhede@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAyMC0xMS0yMyAwNjo1NCwgU2hlbm1pbmcgTHUgd3JvdGU6Cj4gQWZ0ZXIgcGF1c2luZyBh
bGwgdkNQVXMgYW5kIGRldmljZXMgY2FwYWJsZSBvZiBpbnRlcnJ1cHRpbmcsIGluIG9yZGVyCiAg
ICAgICAgIF5eXl5eXl5eXl5eXl5eXl5eClNlZSBteSBjb21tZW50IGJlbG93IGFib3V0IHRoaXMu
Cgo+IHRvIHNhdmUgdGhlIGluZm9ybWF0aW9uIG9mIGFsbCBpbnRlcnJ1cHRzLCBiZXNpZGVzIGZs
dXNoaW5nIHRoZSBwZW5kaW5nCj4gc3RhdGVzIGluIGt2beKAmXMgdmdpYywgd2UgYWxzbyB0cnkg
dG8gZmx1c2ggdGhlIHN0YXRlcyBvZiBWTFBJcyBpbiB0aGUKPiB2aXJ0dWFsIHBlbmRpbmcgdGFi
bGVzIGludG8gZ3Vlc3QgUkFNLCBidXQgd2UgbmVlZCB0byBoYXZlIEdJQ3Y0LjEgYW5kCj4gc2Fm
ZWx5IHVubWFwIHRoZSB2UEVzIGZpcnN0Lgo+IAo+IFNpZ25lZC1vZmYtYnk6IFNoZW5taW5nIEx1
IDxsdXNoZW5taW5nQGh1YXdlaS5jb20+Cj4gLS0tCj4gIGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdp
Yy12My5jIHwgNjIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0KPiAgMSBmaWxl
IGNoYW5nZWQsIDU2IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdp
dCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12My5jIAo+IGIvYXJjaC9hcm02NC9rdm0vdmdp
Yy92Z2ljLXYzLmMKPiBpbmRleCA5Y2RmMzlhOTRhNjMuLmUxYjNhYTRiMmIxMiAxMDA2NDQKPiAt
LS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMuYwo+ICsrKyBiL2FyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy12My5jCj4gQEAgLTEsNiArMSw4IEBACj4gIC8vIFNQRFgtTGljZW5zZS1JZGVu
dGlmaWVyOiBHUEwtMi4wLW9ubHkKPiAKPiAgI2luY2x1ZGUgPGxpbnV4L2lycWNoaXAvYXJtLWdp
Yy12My5oPgo+ICsjaW5jbHVkZSA8bGludXgvaXJxLmg+Cj4gKyNpbmNsdWRlIDxsaW51eC9pcnFk
b21haW4uaD4KPiAgI2luY2x1ZGUgPGxpbnV4L2t2bS5oPgo+ICAjaW5jbHVkZSA8bGludXgva3Zt
X2hvc3QuaD4KPiAgI2luY2x1ZGUgPGt2bS9hcm1fdmdpYy5oPgo+IEBAIC0zNTYsNiArMzU4LDM5
IEBAIGludCB2Z2ljX3YzX2xwaV9zeW5jX3BlbmRpbmdfc3RhdHVzKHN0cnVjdCBrdm0KPiAqa3Zt
LCBzdHJ1Y3QgdmdpY19pcnEgKmlycSkKPiAgCXJldHVybiAwOwo+ICB9Cj4gCj4gKy8qCj4gKyAq
IFdpdGggR0lDdjQuMSwgd2UgY2FuIGdldCB0aGUgVkxQSSdzIHBlbmRpbmcgc3RhdGUgYWZ0ZXIg
dW5tYXBwaW5nCj4gKyAqIHRoZSB2UEUuIFRoZSBkZWFjdGl2YXRpb24gb2YgdGhlIGRvb3JiZWxs
IGludGVycnVwdCB3aWxsIHRyaWdnZXIKPiArICogdGhlIHVubWFwcGluZyBvZiB0aGUgYXNzb2Np
YXRlZCB2UEUuCj4gKyAqLwo+ICtzdGF0aWMgdm9pZCBnZXRfdmxwaV9zdGF0ZV9wcmUoc3RydWN0
IHZnaWNfZGlzdCAqZGlzdCkKPiArewo+ICsJc3RydWN0IGlycV9kZXNjICpkZXNjOwo+ICsJaW50
IGk7Cj4gKwo+ICsJaWYgKCFrdm1fdmdpY19nbG9iYWxfc3RhdGUuaGFzX2dpY3Y0XzEpCj4gKwkJ
cmV0dXJuOwo+ICsKPiArCWZvciAoaSA9IDA7IGkgPCBkaXN0LT5pdHNfdm0ubnJfdnBlczsgaSsr
KSB7Cj4gKwkJZGVzYyA9IGlycV90b19kZXNjKGRpc3QtPml0c192bS52cGVzW2ldLT5pcnEpOwo+
ICsJCWlycV9kb21haW5fZGVhY3RpdmF0ZV9pcnEoaXJxX2Rlc2NfZ2V0X2lycV9kYXRhKGRlc2Mp
KTsKPiArCX0KPiArfQo+ICsKPiArc3RhdGljIHZvaWQgZ2V0X3ZscGlfc3RhdGVfcG9zdChzdHJ1
Y3QgdmdpY19kaXN0ICpkaXN0KQoKbml0OiB0aGUgbmFtaW5nIGZlZWxzIGEgYml0Li4uIG9kZC4g
UHJlL3Bvc3Qgd2hhdD8KCj4gK3sKPiArCXN0cnVjdCBpcnFfZGVzYyAqZGVzYzsKPiArCWludCBp
Owo+ICsKPiArCWlmICgha3ZtX3ZnaWNfZ2xvYmFsX3N0YXRlLmhhc19naWN2NF8xKQo+ICsJCXJl
dHVybjsKPiArCj4gKwlmb3IgKGkgPSAwOyBpIDwgZGlzdC0+aXRzX3ZtLm5yX3ZwZXM7IGkrKykg
ewo+ICsJCWRlc2MgPSBpcnFfdG9fZGVzYyhkaXN0LT5pdHNfdm0udnBlc1tpXS0+aXJxKTsKPiAr
CQlpcnFfZG9tYWluX2FjdGl2YXRlX2lycShpcnFfZGVzY19nZXRfaXJxX2RhdGEoZGVzYyksIGZh
bHNlKTsKPiArCX0KPiArfQo+ICsKPiAgLyoqCj4gICAqIHZnaWNfdjNfc2F2ZV9wZW5kaW5nX3Rh
YmxlcyAtIFNhdmUgdGhlIHBlbmRpbmcgdGFibGVzIGludG8gZ3Vlc3QgCj4gUkFNCj4gICAqIGt2
bSBsb2NrIGFuZCBhbGwgdmNwdSBsb2NrIG11c3QgYmUgaGVsZAo+IEBAIC0zNjUsMTQgKzQwMCwx
NyBAQCBpbnQgdmdpY192M19zYXZlX3BlbmRpbmdfdGFibGVzKHN0cnVjdCBrdm0gKmt2bSkKPiAg
CXN0cnVjdCB2Z2ljX2Rpc3QgKmRpc3QgPSAma3ZtLT5hcmNoLnZnaWM7Cj4gIAlzdHJ1Y3Qgdmdp
Y19pcnEgKmlycTsKPiAgCWdwYV90IGxhc3RfcHRyID0gfihncGFfdCkwOwo+IC0JaW50IHJldDsK
PiArCWludCByZXQgPSAwOwo+ICAJdTggdmFsOwo+IAo+ICsJZ2V0X3ZscGlfc3RhdGVfcHJlKGRp
c3QpOwo+ICsKPiAgCWxpc3RfZm9yX2VhY2hfZW50cnkoaXJxLCAmZGlzdC0+bHBpX2xpc3RfaGVh
ZCwgbHBpX2xpc3QpIHsKPiAgCQlpbnQgYnl0ZV9vZmZzZXQsIGJpdF9ucjsKPiAgCQlzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHU7Cj4gIAkJZ3BhX3QgcGVuZGJhc2UsIHB0cjsKPiAgCQlib29sIHN0b3Jl
ZDsKPiArCQlib29sIGlzX3BlbmRpbmcgPSBpcnEtPnBlbmRpbmdfbGF0Y2g7Cj4gCj4gIAkJdmNw
dSA9IGlycS0+dGFyZ2V0X3ZjcHU7Cj4gIAkJaWYgKCF2Y3B1KQo+IEBAIC0zODcsMjQgKzQyNSwz
NiBAQCBpbnQgdmdpY192M19zYXZlX3BlbmRpbmdfdGFibGVzKHN0cnVjdCBrdm0gKmt2bSkKPiAg
CQlpZiAocHRyICE9IGxhc3RfcHRyKSB7Cj4gIAkJCXJldCA9IGt2bV9yZWFkX2d1ZXN0X2xvY2so
a3ZtLCBwdHIsICZ2YWwsIDEpOwo+ICAJCQlpZiAocmV0KQo+IC0JCQkJcmV0dXJuIHJldDsKPiAr
CQkJCWdvdG8gb3V0Owo+ICAJCQlsYXN0X3B0ciA9IHB0cjsKPiAgCQl9Cj4gCj4gIAkJc3RvcmVk
ID0gdmFsICYgKDFVIDw8IGJpdF9ucik7Cj4gLQkJaWYgKHN0b3JlZCA9PSBpcnEtPnBlbmRpbmdf
bGF0Y2gpCj4gKwo+ICsJCS8qIGFsc28gZmx1c2ggaHcgcGVuZGluZyBzdGF0ZSAqLwoKVGhpcyBj
b21tZW50IGxvb2tzIG91dCBvZiBwbGFjZSwgYXMgd2UgYXJlbid0IGZsdXNoaW5nIGFueXRoaW5n
LgoKPiArCQlpZiAoaXJxLT5odykgewo+ICsJCQlXQVJOX1JBVEVMSU1JVChpcnFfZ2V0X2lycWNo
aXBfc3RhdGUoaXJxLT5ob3N0X2lycSwKPiArCQkJCQkJSVJRQ0hJUF9TVEFURV9QRU5ESU5HLCAm
aXNfcGVuZGluZyksCj4gKwkJCQkgICAgICAgIklSUSAlZCIsIGlycS0+aG9zdF9pcnEpOwoKSXNu
J3QgdGhpcyBnb2luZyB0byB3YXJuIGxpa2UgbWFkIG9uIGEgR0lDdjQuMCBzeXN0ZW0gd2hlcmUg
dGhpcywgYnkgCmRlZmluaXRpb24sCndpbGwgZ2VuZXJhdGUgYW4gZXJyb3I/Cgo+ICsJCX0KPiAr
Cj4gKwkJaWYgKHN0b3JlZCA9PSBpc19wZW5kaW5nKQo+ICAJCQljb250aW51ZTsKPiAKPiAtCQlp
ZiAoaXJxLT5wZW5kaW5nX2xhdGNoKQo+ICsJCWlmIChpc19wZW5kaW5nKQo+ICAJCQl2YWwgfD0g
MSA8PCBiaXRfbnI7Cj4gIAkJZWxzZQo+ICAJCQl2YWwgJj0gfigxIDw8IGJpdF9ucik7Cj4gCj4g
IAkJcmV0ID0ga3ZtX3dyaXRlX2d1ZXN0X2xvY2soa3ZtLCBwdHIsICZ2YWwsIDEpOwo+ICAJCWlm
IChyZXQpCj4gLQkJCXJldHVybiByZXQ7Cj4gKwkJCWdvdG8gb3V0Owo+ICAJfQo+IC0JcmV0dXJu
IDA7Cj4gKwo+ICtvdXQ6Cj4gKwlnZXRfdmxwaV9zdGF0ZV9wb3N0KGRpc3QpOwoKVGhpcyBiaXQg
d29ycmllcyBtZTogeW91IGhhdmUgdW5tYXBwZWQgdGhlIFZQRXMsIHNvIGFueSBpbnRlcnJ1cHQg
dGhhdCAKaGFzIGJlZW4KZ2VuZXJhdGVkIGR1cmluZyB0aGF0IHBoYXNlIGlzIG5vdyBmb3JldmVy
IGxvc3QgKHRoZSBHSUMgZG9lc24ndCBoYXZlIApvd25lcnNoaXAKb2YgdGhlIHBlbmRpbmcgdGFi
bGVzKS4KCkRvIHlvdSByZWFsbHkgZXhwZWN0IHRoZSBWTSB0byBiZSByZXN0YXJ0YWJsZSBmcm9t
IHRoYXQgcG9pbnQ/IEkgZG9uJ3QgCnNlZSBob3cKdGhpcyBpcyBwb3NzaWJsZS4KCj4gKwo+ICsJ
cmV0dXJuIHJldDsKPiAgfQo+IAo+ICAvKioKClRoYW5rcywKCiAgICAgICAgIE0uCi0tIApKYXp6
IGlzIG5vdCBkZWFkLiBJdCBqdXN0IHNtZWxscyBmdW5ueS4uLgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBs
aXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1h
bi9saXN0aW5mby9rdm1hcm0K
