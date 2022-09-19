Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85BCAC6FA82
	for <kvmarm@archiver.kernel.org>; Mon, 19 Sep 2022 19:29:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEAB849F3B;
	Mon, 19 Sep 2022 15:29:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SEXxc30q+8Zh; Mon, 19 Sep 2022 15:29:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D0334B649;
	Mon, 19 Sep 2022 15:29:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 358774B646
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 15:29:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kI66YzMKGSvx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Sep 2022 15:29:19 -0400 (EDT)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
 [209.85.214.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB55249F3B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 15:29:18 -0400 (EDT)
Received: by mail-pl1-f174.google.com with SMTP id w13so173504plp.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 12:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date:from:to
 :cc:subject:date;
 bh=Dmji6WgZ7xPVoBunBQhcBqAmOM/CFg7OpLk7cNx+uc8=;
 b=d46SJWkeiDSnWutSydUXgew9qteyyKBJCMX7dT5wUkhHj4yXZv4QSaRTIP4boV4OZS
 mqqvUXpLbkFGFkEiK9eCv8NFZWCoTAo9PrUSCWWjDS0J9ObVikPpB8KA8INU02Fx2geN
 4gv66dh4SsimsRuPojY+fAYWWpG3lwY4HG58utPl9/e/tqA0+l/CHvTfGY0IZc0DysFu
 VbKS1pLZ81rhkZy7gjWxVsgKyRcU9kksvq7WFw14UIMaVQOsLb0ysekH4z9BDrzhYOZG
 3vgc7MuKNxAdMSb9tcc1X3lI4BIDOJkleeXpa1nQdnQOctRTynfDks7LaEow+Swb+fNm
 /NSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date;
 bh=Dmji6WgZ7xPVoBunBQhcBqAmOM/CFg7OpLk7cNx+uc8=;
 b=vZ8U0xNBPo0w7gUEoie67rOW/lZMOD/xxQIFs0wt1LHCEM6jOxRTHwFA24VcP3SmU4
 gTUtcTrRyZT0AZdqZsGrd/1CK4OghB2+UZc8X/EXc/5SRWHyZFyr6FjRzxl/m8i1sxNR
 wf4rpXhGmb+DUZHML18ZJw3Nr0oG9a2App21kPtWJ/v1B4eacYikf8WkV9+K5AmDKnKP
 0sMMPGyeLuQmOY1git/WzNd/in3RGCp2oO7v3UHHXrJvjNcgmIJOfPnleydZ0BJl8g0m
 Stoc4124Mzks0vyOv2oDc6zzZm92RqFQlN0sb2urJOwQ7wpvYCY6lLbPQ5soKX+whCF/
 3O9w==
X-Gm-Message-State: ACrzQf10RNsFMb5yv2NLKCfpZ/MQx5B0MHGCS9DscMJiAHRF1rDZPr8l
 6+vYB0rX5MbTJ1WwuilGMTE06A==
X-Google-Smtp-Source: AMsMyM5Oqrj1KGICJ2V8qLt8Rn5ylazcb1hHMnzGoS7sR/Pu1B8N4zBf1uOM+cWrKxXEfgatHaqV0g==
X-Received: by 2002:a17:90b:1e49:b0:203:38c:365a with SMTP id
 pi9-20020a17090b1e4900b00203038c365amr33037441pjb.133.1663615757758; 
 Mon, 19 Sep 2022 12:29:17 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 c199-20020a624ed0000000b0053ea0e5556esm20738942pfb.186.2022.09.19.12.29.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 19 Sep 2022 12:29:17 -0700 (PDT)
Date: Mon, 19 Sep 2022 12:29:13 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v6 09/13] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <YyjDCWCJ5j8c6T2h@google.com>
References: <20220906180930.230218-1-ricarkol@google.com>
 <20220906180930.230218-10-ricarkol@google.com>
 <YyZDBIQsux1g97zl@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YyZDBIQsux1g97zl@google.com>
Cc: kvm@vger.kernel.org, andrew.jones@linux.dev, maz@kernel.org,
 bgardon@google.com, pbonzini@redhat.com, axelrasmussen@google.com,
 kvmarm@lists.cs.columbia.edu, dmatlack@google.com
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

T24gU2F0LCBTZXAgMTcsIDIwMjIgYXQgMDk6NTg6MjhQTSArMDAwMCwgT2xpdmVyIFVwdG9uIHdy
b3RlOgo+IE9uIFR1ZSwgU2VwIDA2LCAyMDIyIGF0IDA2OjA5OjI2UE0gKzAwMDAsIFJpY2FyZG8g
S29sbGVyIHdyb3RlOgo+ID4gQWRkIGEgbmV3IHRlc3QgZm9yIHN0YWdlIDIgZmF1bHRzIHdoZW4g
dXNpbmcgZGlmZmVyZW50IGNvbWJpbmF0aW9ucyBvZgo+ID4gZ3Vlc3QgYWNjZXNzZXMgKGUuZy4s
IHdyaXRlLCBTMVBUVyksIGJhY2tpbmcgc291cmNlIHR5cGUgKGUuZy4sIGFub24pCj4gPiBhbmQg
dHlwZXMgb2YgZmF1bHRzIChlLmcuLCByZWFkIG9uIGh1Z2V0bGJmcyB3aXRoIGEgaG9sZSkuIFRo
ZSBuZXh0Cj4gPiBjb21taXRzIHdpbGwgYWRkIGRpZmZlcmVudCBoYW5kbGluZyBtZXRob2RzIGFu
ZCBtb3JlIGZhdWx0cyAoZS5nLiwgdWZmZAo+ID4gYW5kIGRpcnR5IGxvZ2dpbmcpLiBUaGlzIGZp
cnN0IGNvbW1pdCBzdGFydHMgYnkgYWRkaW5nIHR3byBzYW5pdHkgY2hlY2tzCj4gPiBmb3IgYWxs
IHR5cGVzIG9mIGFjY2Vzc2VzOiBBRiBzZXR0aW5nIGJ5IHRoZSBodywgYW5kIGFjY2Vzc2luZyBt
ZW1zbG90cwo+ID4gd2l0aCBob2xlcy4KPiA+IAo+ID4gU2lnbmVkLW9mZi1ieTogUmljYXJkbyBL
b2xsZXIgPHJpY2Fya29sQGdvb2dsZS5jb20+Cj4gCj4gSGV5IFJpY2FyZG8sCj4gCj4gWW91J2xs
IG5lZWQgdG8gdXBkYXRlIC5naXRpZ25vcmUgZm9yIHRoaXMgcGF0Y2guIEFkZGl0aW9uYWxseSwg
YnVpbGRpbmcKPiB0aGlzIHRlc3QgdGhyb3dzIHRoZSBmb2xsb3dpbmcgY29tcGlsZXIgd2Fybmlu
ZzoKPiAKPiBJbiBmdW5jdGlvbiDigJhsb2FkX2V4ZWNfY29kZV9mb3JfdGVzdOKAmSwKPiAgICAg
aW5saW5lZCBmcm9tIOKAmHJ1bl90ZXN04oCZIGF0IGFhcmNoNjQvcGFnZV9mYXVsdF90ZXN0LmM6
NzQ1OjI6Cj4gYWFyY2g2NC9wYWdlX2ZhdWx0X3Rlc3QuYzo1NDU6OTogd2FybmluZzogYXJyYXkg
c3Vic2NyaXB0IOKAmGxvbmcgdW5zaWduZWQgaW50WzBd4oCZIGlzIHBhcnRseSBvdXRzaWRlIGFy
cmF5IGJvdW5kcyBvZiDigJh1bnNpZ25lZCBjaGFyWzFd4oCZIFstV2FycmF5LWJvdW5kc10KPiAg
IDU0NSB8ICAgICAgICAgbWVtY3B5KGNvZGUsIGMsIDgpOwo+ICAgICAgIHwgICAgICAgICBefn5+
fn5+fn5+fn5+fn5+fn4KPiAKPiBJJ3ZlIGZpeGVkIGJvdGggb2YgdGhlc2UgaW4gdGhlIGFwcGVu
ZGVkIGRpZmYsIGZlZWwgZnJlZSB0byBzcXVhc2guCgpUaGFua3MsIHdpbGwgZG8gdGhhdC4KCj4g
Cj4gLS0KPiBUaGFua3MsCj4gT2xpdmVyCj4gCj4gRnJvbSAwYTVkMzcxMGI5MDQzYWU4ZmU1YTlk
N2NjNDhlYjg1NGQxYjdiNzQ2IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQo+IEZyb206IE9saXZl
ciBVcHRvbiA8b2xpdmVyLnVwdG9uQGxpbnV4LmRldj4KPiBEYXRlOiBTYXQsIDE3IFNlcCAyMDIy
IDIxOjM4OjExICswMDAwCj4gU3ViamVjdDogW1BBVENIXSBmaXh1cCEgS1ZNOiBzZWxmdGVzdHM6
IGFhcmNoNjQ6IEFkZCBhYXJjaDY0L3BhZ2VfZmF1bHRfdGVzdAo+IAo+IC0tLQo+ICB0b29scy90
ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vLmdpdGlnbm9yZSAgICAgICAgICAgICAgIHwgIDEgKwo+ICAu
Li4vdGVzdGluZy9zZWxmdGVzdHMva3ZtL2FhcmNoNjQvcGFnZV9mYXVsdF90ZXN0LmMgIHwgMTIg
KysrLS0tLS0tLS0tCj4gIDIgZmlsZXMgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA5IGRlbGV0
aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vLmdp
dGlnbm9yZSBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS8uZ2l0aWdub3JlCj4gaW5kZXgg
ZDYyNWEzZjgzNzgwLi43YTkwMjJjZmEwMzMgMTAwNjQ0Cj4gLS0tIGEvdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMva3ZtLy5naXRpZ25vcmUKPiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9r
dm0vLmdpdGlnbm9yZQo+IEBAIC0zLDYgKzMsNyBAQAo+ICAvYWFyY2g2NC9kZWJ1Zy1leGNlcHRp
b25zCj4gIC9hYXJjaDY0L2dldC1yZWctbGlzdAo+ICAvYWFyY2g2NC9oeXBlcmNhbGxzCj4gKy9h
YXJjaDY0L3BhZ2VfZmF1bHRfdGVzdAo+ICAvYWFyY2g2NC9wc2NpX3Rlc3QKPiAgL2FhcmNoNjQv
dmNwdV93aWR0aF9jb25maWcKPiAgL2FhcmNoNjQvdmdpY19pbml0Cj4gZGlmZiAtLWdpdCBhL3Rv
b2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9hYXJjaDY0L3BhZ2VfZmF1bHRfdGVzdC5jIGIvdG9v
bHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2FhcmNoNjQvcGFnZV9mYXVsdF90ZXN0LmMKPiBpbmRl
eCA2MGE2YThhNDVmYTQuLjVlZjJhN2I5NDFlYyAxMDA2NDQKPiAtLS0gYS90b29scy90ZXN0aW5n
L3NlbGZ0ZXN0cy9rdm0vYWFyY2g2NC9wYWdlX2ZhdWx0X3Rlc3QuYwo+ICsrKyBiL3Rvb2xzL3Rl
c3Rpbmcvc2VsZnRlc3RzL2t2bS9hYXJjaDY0L3BhZ2VfZmF1bHRfdGVzdC5jCj4gQEAgLTUxMiw3
ICs1MTIsNyBAQCB2b2lkIGZhaWxfdmNwdV9ydW5fbW1pb19ub19zeW5kcm9tZV9oYW5kbGVyKGlu
dCByZXQpCj4gIAlldmVudHMuZmFpbF92Y3B1X3J1bnMgKz0gMTsKPiAgfQo+ICAKPiAtZXh0ZXJu
IHVuc2lnbmVkIGNoYXIgX19leGVjX3Rlc3Q7Cj4gK2V4dGVybiB1aW50NjRfdCBfX2V4ZWNfdGVz
dDsKPiAgCj4gIHZvaWQgbm9pbmxpbmUgX19yZXR1cm5fMHg3Nyh2b2lkKQo+ICB7Cj4gQEAgLTUy
Niw3ICs1MjYsNyBAQCB2b2lkIG5vaW5saW5lIF9fcmV0dXJuXzB4Nzcodm9pZCkKPiAgICovCj4g
IHN0YXRpYyB2b2lkIGxvYWRfZXhlY19jb2RlX2Zvcl90ZXN0KHN0cnVjdCBrdm1fdm0gKnZtKQo+
ICB7Cj4gLQl1aW50NjRfdCAqY29kZSwgKmM7Cj4gKwl1aW50NjRfdCAqY29kZTsKPiAgCXN0cnVj
dCB1c2Vyc3BhY2VfbWVtX3JlZ2lvbiAqcmVnaW9uOwo+ICAJdm9pZCAqaHZhOwo+ICAKPiBAQCAt
NTM2LDEzICs1MzYsNyBAQCBzdGF0aWMgdm9pZCBsb2FkX2V4ZWNfY29kZV9mb3JfdGVzdChzdHJ1
Y3Qga3ZtX3ZtICp2bSkKPiAgCWFzc2VydChURVNUX0VYRUNfR1ZBIC0gVEVTVF9HVkEpOwo+ICAJ
Y29kZSA9IGh2YSArIDg7Cj4gIAo+IC0JLyoKPiAtCSAqIFdlIG5lZWQgdGhlIGNhc3QgdG8gYmUg
c2VwYXJhdGUgaW4gb3JkZXIgZm9yIHRoZSBjb21waWxlciB0byBub3QKPiAtCSAqIGNvbXBsYWlu
IHdpdGg6ICLigJhtZW1jcHnigJkgZm9ybWluZyBvZmZzZXQgWzEsIDddIGlzIG91dCBvZiB0aGUg
Ym91bmRzCj4gLQkgKiBbMCwgMV0gb2Ygb2JqZWN0IOKAmF9fZXhlY190ZXN04oCZIHdpdGggdHlw
ZSDigJh1bnNpZ25lZCBjaGFy4oCZIgo+IC0JICovCj4gLQljID0gKHVpbnQ2NF90ICopJl9fZXhl
Y190ZXN0Owo+IC0JbWVtY3B5KGNvZGUsIGMsIDgpOwo+ICsJKmNvZGUgPSBfX2V4ZWNfdGVzdDsK
CkkgcmVtZW1iZXIgdHJ5aW5nIG1hbnkgd2F5cyBvZiBnZXR0aW5nIHRoZSBjb21waWxlciB0byBu
b3QgY29tcGxhaW4sIEkKbXVzdCBoYXZlIHRyaWVkIHRoaXMgKHdvbmRlciB3aGF0IGhhcHBlbmVk
KS4gQW55d2F5LCBnY2MgYW5kIGNsYW5nIGFyZQpoYXBweSB3aXRoIGl0LgoKPiAgfQo+ICAKPiAg
c3RhdGljIHZvaWQgc2V0dXBfYWJvcnRfaGFuZGxlcnMoc3RydWN0IGt2bV92bSAqdm0sIHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSwKPiAtLSAKPiAyLjM3LjMuOTY4LmdhNmI0YjA4MGU0LWdvb2cKPiAK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1h
aWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
