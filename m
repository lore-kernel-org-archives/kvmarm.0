Return-Path: <SRS0=V360=D6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB646C388F9
	for <kvmarm@archiver.kernel.org>; Fri, 23 Oct 2020 09:17:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 189662225F
	for <kvmarm@archiver.kernel.org>; Fri, 23 Oct 2020 09:17:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="vEQRobT1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 189662225F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 517404B899;
	Fri, 23 Oct 2020 05:17:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FTVB32KAwakK; Fri, 23 Oct 2020 05:17:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F3CCF4B8A4;
	Fri, 23 Oct 2020 05:17:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C9A74B8A1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2020 05:17:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GuwUWv07hqm4 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Oct 2020 05:17:29 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F2D8D4B899
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2020 05:17:28 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A8DAD2192A;
 Fri, 23 Oct 2020 09:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603444647;
 bh=FKgiExT15JAeB4bOi4BzuZsaSQkmYMjVCrcA02RzMhA=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=vEQRobT1DeCq4TlLoCaaSv4akta6Mtpa+9Ycn/Uj9rp7XUorfknTnqpEB7BJe2pTg
 2uvdLHd3zmGtJCJbIl7nMiw7pAhgqBC1DxrYfuHg1+BFbqcl1vy/kmwsStv9zfYnTn
 +IjjWOb9F8HJVV2IYjWT1jIC1sFSLcQB+YE+sxQs=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kVtCP-003WiL-OK; Fri, 23 Oct 2020 10:17:25 +0100
MIME-Version: 1.0
Date: Fri, 23 Oct 2020 10:17:25 +0100
From: Marc Zyngier <maz@kernel.org>
To: Shaokun Zhang <zhangshaokun@hisilicon.com>
Subject: Re: [RFC] KVM: arm64: Don't force broadcast tlbi when guest is running
In-Reply-To: <0a7032a7-ff23-b537-fdbd-8189380d4f41@hisilicon.com>
References: <1603331829-33879-1-git-send-email-zhangshaokun@hisilicon.com>
 <be1d84d42df6203ad993e8d20d9bd6da@kernel.org>
 <0a7032a7-ff23-b537-fdbd-8189380d4f41@hisilicon.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <65c347bb6442ae003caee28c10467ae1@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhangshaokun@hisilicon.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 tangnianyao@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

T24gMjAyMC0xMC0yMyAwMjoyNiwgU2hhb2t1biBaaGFuZyB3cm90ZToKPiBIaSBNYXJj77yMCj4g
Cj4g5ZyoIDIwMjAvMTAvMjIgMjA6MDMsIE1hcmMgWnluZ2llciDlhpnpgZM6Cj4+IE9uIDIwMjAt
MTAtMjIgMDI6NTcsIFNoYW9rdW4gWmhhbmcgd3JvdGU6Cj4+PiBGcm9tOiBOaWFueWFvIFRhbmcg
PHRhbmduaWFueWFvQGh1YXdlaS5jb20+Cj4+PiAKPj4+IE5vdyBIQ1JfRUwyLkZCIGlzIHNldCB0
byBmb3JjZSBicm9hZGNhc3QgdGxiaSB0byBhbGwgb25saW5lIHBjcHVzLAo+Pj4gZXZlbiB0aG9z
ZSB2Y3B1IGRvIG5vdCByZXNpZGVudCBvbi4gSXQgd291bGQgZ2V0IHdvcnNlIGFzIHN5c3RlbQo+
Pj4gZ2V0cyBsYXJnZXIgYW5kIG1vcmUgcGNwdXMgZ2V0IG9ubGluZS4KPj4+IExldCdzIGRpc2Fi
bGUgZm9yY2UtYnJvYWRjYXN0LiBXZSBmbHVzaCB0bGJpIHdoZW4gbW92ZSB2Y3B1IHRvIGEKPj4+
IG5ldyBwY3B1LCBpbiBjYXNlIG9sZCBwYWdlIG1hcHBpbmcgc3RpbGwgZXhpc3RzIG9uIG5ldyBw
Y3B1Lgo+Pj4gCj4+PiBDYzogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4KPj4+IFNpZ25l
ZC1vZmYtYnk6IE5pYW55YW8gVGFuZyA8dGFuZ25pYW55YW9AaHVhd2VpLmNvbT4KPj4+IFNpZ25l
ZC1vZmYtYnk6IFNoYW9rdW4gWmhhbmcgPHpoYW5nc2hhb2t1bkBoaXNpbGljb24uY29tPgo+Pj4g
LS0tCj4+PiDCoGFyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2FybS5oIHwgMiArLQo+Pj4gwqBh
cmNoL2FybTY0L2t2bS9hcm0uY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDQgKysrLQo+Pj4g
wqAyIGZpbGVzIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKPj4+IAo+
Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2FybS5oIAo+Pj4gYi9h
cmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9hcm0uaAo+Pj4gaW5kZXggNjRjZTI5Mzc4NDY3Li5m
ODVlYTljNjQ5Y2IgMTAwNjQ0Cj4+PiAtLS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9h
cm0uaAo+Pj4gKysrIGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1fYXJtLmgKPj4+IEBAIC03
NSw3ICs3NSw3IEBACj4+PiDCoCAqIFBUVzrCoMKgwqDCoMKgwqDCoCBUYWtlIGEgc3RhZ2UyIGZh
dWx0IGlmIGEgc3RhZ2UxIHdhbGsgc3RlcHMgaW4gZGV2aWNlIAo+Pj4gbWVtb3J5Cj4+PiDCoCAq
Lwo+Pj4gwqAjZGVmaW5lIEhDUl9HVUVTVF9GTEFHUyAoSENSX1RTQyB8IEhDUl9UU1cgfCBIQ1Jf
VFdFIHwgSENSX1RXSSB8IAo+Pj4gSENSX1ZNIHwgXAo+Pj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBIQ1JfQlNVX0lTIHwgSENSX0ZCIHwgSENSX1RBQyB8IFwKPj4+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgSENSX0JTVV9JUyB8IEhDUl9UQUMgfCBcCj4+PiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBIQ1JfQU1PIHwgSENSX1NXSU8gfCBIQ1JfVElEQ1AgfCBIQ1JfUlcgfCBIQ1Jf
VExPUiB8IFwKPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEhDUl9GTU8gfCBIQ1JfSU1P
IHwgSENSX1BUVyApCj4+PiDCoCNkZWZpbmUgSENSX1ZJUlRfRVhDUF9NQVNLIChIQ1JfVlNFIHwg
SENSX1ZJIHwgSENSX1ZGKQo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2FybS5jIGIv
YXJjaC9hcm02NC9rdm0vYXJtLmMKPj4+IGluZGV4IGFjZjlhOTkzZGZiNi4uODQ1YmU5MTFmODg1
IDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vYXJtLmMKPj4+ICsrKyBiL2FyY2gvYXJt
NjQva3ZtL2FybS5jCj4+PiBAQCAtMzM0LDggKzMzNCwxMCBAQCB2b2lkIGt2bV9hcmNoX3ZjcHVf
bG9hZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIAo+Pj4gaW50IGNwdSkKPj4+IMKgwqDCoMKgIC8q
Cj4+PiDCoMKgwqDCoMKgICogV2UgbWlnaHQgZ2V0IHByZWVtcHRlZCBiZWZvcmUgdGhlIHZDUFUg
YWN0dWFsbHkgcnVucywgYnV0Cj4+PiDCoMKgwqDCoMKgICogb3Zlci1pbnZhbGlkYXRpb24gZG9l
c24ndCBhZmZlY3QgY29ycmVjdG5lc3MuCj4+PiArwqDCoMKgwqAgKiBEaXJ0eSB0bGIgbWlnaHQg
c3RpbGwgZXhpc3Qgd2hlbiB2Y3B1IHJhbiBvbiBvdGhlciBwY3B1Cj4+PiArwqDCoMKgwqAgKiBh
bmQgbW9kaWZpZWQgcGFnZSBtYXBwaW5nLgo+Pj4gwqDCoMKgwqDCoCAqLwo+Pj4gLcKgwqDCoCBp
ZiAoKmxhc3RfcmFuICE9IHZjcHUtPnZjcHVfaWQpIHsKPj4+ICvCoMKgwqAgaWYgKCpsYXN0X3Jh
biAhPSB2Y3B1LT52Y3B1X2lkIHx8IHZjcHUtPmNwdSAhPSBjcHUpIHsKPj4+IMKgwqDCoMKgwqDC
oMKgwqAga3ZtX2NhbGxfaHlwKF9fa3ZtX3RsYl9mbHVzaF9sb2NhbF92bWlkLCBtbXUpOwo+Pj4g
wqDCoMKgwqDCoMKgwqDCoCAqbGFzdF9yYW4gPSB2Y3B1LT52Y3B1X2lkOwo+Pj4gwqDCoMKgwqAg
fQo+PiAKPj4gVGhpcyBicmVha3MgdW5pcHJvY2Vzc29yIHNlbWFudGljcyBmb3IgSS1jYWNoZSBp
bnZhbGlkYXRpb24uIFdoYXQgCj4+IGNvdWxkCj4gCj4gT29wcywgSXQgc2hhbGwgY29uc2lkZXIg
dGhpcy4KPiAKPj4gcG9zc2libHkgZ28gd3Jvbmc/IFlvdSBhbHNvIGZhaWwgdG8gcHJvdmlkZSBh
bnkgZGF0YSB0aGF0IHdvdWxkIGJhY2sgCj4+IHVwCj4+IHlvdXIgY2xhaW0sIGFzIHVzdWFsLgo+
IAo+IFRlc3QgVW5peGJlbmNoIHNwYXduIGluIGVhY2ggNFU4RyB2bSBvbiBLdW5wZW5nIDkyMDoK
PiAoMSkgMjQgNFU4RyBWTXMsIGVhY2ggdmNwdSBpcyB0YXNrc2V0IHRvIG9uZSBwY3B1IHRvIG1h
a2Ugc3VyZQo+IGVhY2ggdm0gc2VwZXJhdGVkLgoKVGhhdCdzIGEgdmVyeSBuYXJyb3cgdXNlIGNh
c2UuCgo+ICgyKSAxIDRVOEcgVk0KPiBSZXN1bHQ6Cj4gKDEpIDgwMCAqIDI0Cj4gKDIpIDMyMDAK
CkkgZG9uJ3Qga25vdyB3aGF0IHRoZXNlIG51bWJlcnMgYXJlLgoKPiBCeSByZXN0cmljdGluZyBE
Vk0gYnJvYWRjYXN0aW5nIGFjcm9zcyBOVU1BLCByZXN1bHQgKDEpIGNhbgo+IGJlIGltcHJvdmVk
IHRvIDIzMDAgKiAyNC4gSW4gc3Bhd24gdGVzdGNhc2UsIHRsYmlpcyB1c2VkCj4gaW4gY3JlYXRp
bmcgcHJvY2Vzcy4KCkxpbnV4IGFsd2F5cyB1c2UgVExCSSBJUywgZXhjZXB0IGluIHNvbWUgdmVy
eSByYXJlIGNhc2VzLgpJZiB5b3VyIEhXIGJyb2FkY2FzdHMgaW52YWxpZGF0aW9ucyBhY3Jvc3Mg
dGhlIHdob2xlIHN5c3RlbQp3aXRob3V0IGFueSBmaWx0ZXJpbmcsIGl0IGlzIGJvdW5kIHRvIGJl
IGJhZC4KCj4gRnVydGhlciwgd2UgY29uc2lkZXIgcmVzdHJpY3RpbmcgdGxiaSBicm9hZGNhc3Qg
cmFuZ2UgYW5kIG1ha2UKPiB0bGJpIG1vcmUgYWNjdXJhdGUuCj4gT25lIHNjaGVtZSBpcyByZXBs
YWNpbmcgdGxiaWlzIHdpdGggaXBpICsgdGxiaSArIEhDUl9FTDIuRkI9MC4KCkFoLiBUaGF0IG9s
ZCB0aGluZyBhZ2Fpbi4gTm8sIHRoYW5rIHlvdS4gVGhlIHJpZ2h0IHRoaW5nIHRvIGRvCmlzIHRv
IGJ1aWxkIENQVXMgYW5kIGludGVyY29ubmVjdHMgdGhhdCBwcm9wZXJseSBkZWFscyB3aXRoCklT
IGludmFsaWRhdGlvbnMgYnkgbm90IHNlbmRpbmcgRFZNIG1lc3NhZ2VzIHRvIHBsYWNlcyB3aGVy
ZQp0aGluZ3MgZG9uJ3QgcnVuIChzbm9vcCBmaWx0ZXJzPykuIEkgYWxzbyBkb3VidCB0aGUgYXJt
NjQKbWFpbnRhaW5lcnMgd291bGQgYmUgc3ltcGF0aGV0aWMgdG8gdGhlIGlkZWEgYW55d2F5LgoK
PiBDb25zaWRlciBJLWNhY2hlIGludmFsaWRhdGlvbiwgS1ZNIGFsc28gbmVlZHMgdG8gaW52YWxp
ZCBpY2FjaGUKPiB3aGVuIG1vdmluZyB2Y3B1IHRvIGEgbmV3IHBjcHUuCj4gRG8gd2UgbWlzcyBh
bnkgY2FzZXMgdGhhdCBuZWVkIEhDUl9FTDIuRkIgPT0gMT8KPiBFdmVudHVhbGx5IHdlIGV4cGVj
dCBIQ1JfRUwyLkZCID09IDAgaWYgaXQgaXMgcG9zc2libGUuCgpJIGhhdmUgbm8gaW50ZW50aW9u
IHRvIGV2ZXIgc2V0IEZCIHRvIDAsIGFzIHRoaXMgd291bGQgcmVzdWx0CmluIG92ZXItaW52YWxp
ZGF0aW9uIGluIHRoZSBnZW5lcmFsIGNhc2UsIGFuZCB3b3JzZSBwZXJmb3JtYW5jZQpvbiB3ZWxs
IGRlc2lnbmVkIHN5c3RlbXMuCgogICAgICAgICBNLgotLSAKSmF6eiBpcyBub3QgZGVhZC4gSXQg
anVzdCBzbWVsbHMgZnVubnkuLi4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEu
ZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJt
Cg==
