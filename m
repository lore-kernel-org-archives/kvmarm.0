Return-Path: <SRS0=0kEf=Z3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B71C2BD09
	for <kvmarm@archiver.kernel.org>; Thu,  5 Dec 2019 10:56:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C257624659
	for <kvmarm@archiver.kernel.org>; Thu,  5 Dec 2019 10:56:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hac7YA/6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C257624659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amsat.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FC344AE8D;
	Thu,  5 Dec 2019 05:56:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MLxyuXEmkRUU; Thu,  5 Dec 2019 05:56:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7C044AEB4;
	Thu,  5 Dec 2019 05:56:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5F2D4A5A0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Dec 2019 04:54:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jVbL3C0LCYaK for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Dec 2019 04:54:51 -0500 (EST)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 82B514A523
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Dec 2019 04:54:51 -0500 (EST)
Received: by mail-wm1-f66.google.com with SMTP id c20so1453002wmb.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 Dec 2019 01:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=sender:subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=DQAhGy9NIgRWmctc8n8PEHCVr8wavboJn+39LOkMnnE=;
 b=hac7YA/61scaeO1ZPDjnWRMzcy75dsYruAt43uzR4MuSNEz5hLw5EdT0z6Pk1oKaf2
 fTx/UHnJFbfc4yz5OxSDaux8zk2LpeT53fJ2LG+/5yqQgpjOTz3h53GTnIdVAcTKJu7t
 xG/FEOdrDW23jBF3o46Cmb8RLZ0MeIO1x8zWgY8AzwOkcpJXe8WvLpubqc2McKiHLLNr
 eXSDqObg1oCx4MHRo8Iua/WzAIC2j2e4ETJSFvHsUBnEfO5ALS1gU+pCdLNKtcDPo9fg
 ea2NuzaE3VVvgcbVAosn8fyIucElmMVU0IXGeAX739GIzKDJD5KlcSees5Ss3hDd40c5
 9IwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=DQAhGy9NIgRWmctc8n8PEHCVr8wavboJn+39LOkMnnE=;
 b=hSFgFH/wzJD36qPewHOaDE+jOrtoxH6g/zroEhuNNGNoBU5nrza4mgd36MooBP1uQK
 FNSQykJd4AA+ziHqRLt67LltO+hVono6stwKgm47LIccTeHvtIY4R6PaW1WPaLYADZtv
 pNSax1OGYcAHv5WNGtkw7OxgQTjK0q+rx61U/w6h9olKx+3306N29JPIagrMbGuHAZw6
 mvn+nZ0lO8kSMBOWc3yeDIJjJxHnSPJDfgqQ+dwq32nQeZfn4rP2cXjYKQ7CfcLia8qS
 ilRaOCK+kqqPHM0SaqtQOEL6hd/XBCBNqncfGdVHn6yxYZBeD8nJNLrfNARDMPVSDsRN
 tNsg==
X-Gm-Message-State: APjAAAUm9DMhCoG7f9t2MczuRItxpwWm4Nk86Vnbibz1/UoTpMz+fKbt
 tBFgslCc4VptZVsI3aR+rMM=
X-Google-Smtp-Source: APXvYqx3wMGWvFWz+VWzb3/gBJ7AfPMRQqK+25vc1Q2imL/LDYGpX95tPaj1m7INL2O5Ql2/5WubRg==
X-Received: by 2002:a05:600c:282:: with SMTP id 2mr3954319wmk.73.1575539690435; 
 Thu, 05 Dec 2019 01:54:50 -0800 (PST)
Received: from [192.168.1.35] (182.red-88-21-103.staticip.rima-tde.net.
 [88.21.103.182])
 by smtp.gmail.com with ESMTPSA id u26sm9723665wmj.9.2019.12.05.01.54.48
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 05 Dec 2019 01:54:49 -0800 (PST)
Subject: Re: [PATCH v3 08/15] KVM: Move setting of memslot into helper routine
To: Sean Christopherson <sean.j.christopherson@intel.com>,
 James Hogan <jhogan@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
 Marc Zyngier <maz@kernel.org>
References: <20191024230744.14543-1-sean.j.christopherson@intel.com>
 <20191024230744.14543-9-sean.j.christopherson@intel.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <a606c931-ffeb-95e9-79eb-df68fed7af65@amsat.org>
Date: Thu, 5 Dec 2019 10:54:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191024230744.14543-9-sean.j.christopherson@intel.com>
Content-Language: en-US
X-Mailman-Approved-At: Thu, 05 Dec 2019 05:56:16 -0500
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

T24gMTAvMjUvMTkgMTowNyBBTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToKPiBTcGxpdCBv
dXQgdGhlIGNvcmUgZnVuY3Rpb25hbGl0eSBvZiBzZXR0aW5nIGEgbWVtc2xvdCBpbnRvIGEgc2Vw
YXJhdGUKPiBoZWxwZXIgaW4gcHJlcGFyYXRpb24gZm9yIG1vdmluZyBtZW1zbG90IGRlbGV0aW9u
IGludG8gaXRzIG93biByb3V0aW5lLgo+IAo+IFRlc3RlZC1ieTogQ2hyaXN0b2ZmZXIgRGFsbCA8
Y2hyaXN0b2ZmZXIuZGFsbEBhcm0uY29tPgo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3Bo
ZXJzb24gPHNlYW4uai5jaHJpc3RvcGhlcnNvbkBpbnRlbC5jb20+Cj4gLS0tCj4gICB2aXJ0L2t2
bS9rdm1fbWFpbi5jIHwgMTA2ICsrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0t
LS0tLS0tCj4gICAxIGZpbGUgY2hhbmdlZCwgNjMgaW5zZXJ0aW9ucygrKSwgNDMgZGVsZXRpb25z
KC0pCj4gCj4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2t2bV9tYWluLmMgYi92aXJ0L2t2bS9rdm1f
bWFpbi5jCj4gaW5kZXggZTJmNDdkNjBmNjk2Li44NjBkZTRmYWRjZTYgMTAwNjQ0Cj4gLS0tIGEv
dmlydC9rdm0va3ZtX21haW4uYwo+ICsrKyBiL3ZpcnQva3ZtL2t2bV9tYWluLmMKPiBAQCAtOTIw
LDYgKzkyMCw2NiBAQCBzdGF0aWMgc3RydWN0IGt2bV9tZW1zbG90cyAqaW5zdGFsbF9uZXdfbWVt
c2xvdHMoc3RydWN0IGt2bSAqa3ZtLAo+ICAgCXJldHVybiBvbGRfbWVtc2xvdHM7Cj4gICB9Cj4g
ICAKPiArc3RhdGljIGludCBrdm1fc2V0X21lbXNsb3Qoc3RydWN0IGt2bSAqa3ZtLAo+ICsJCQkg
ICBjb25zdCBzdHJ1Y3Qga3ZtX3VzZXJzcGFjZV9tZW1vcnlfcmVnaW9uICptZW0sCj4gKwkJCSAg
IGNvbnN0IHN0cnVjdCBrdm1fbWVtb3J5X3Nsb3QgKm9sZCwKPiArCQkJICAgc3RydWN0IGt2bV9t
ZW1vcnlfc2xvdCAqbmV3LCBpbnQgYXNfaWQsCj4gKwkJCSAgIGVudW0ga3ZtX21yX2NoYW5nZSBj
aGFuZ2UpCj4gK3sKPiArCXN0cnVjdCBrdm1fbWVtb3J5X3Nsb3QgKnNsb3Q7Cj4gKwlzdHJ1Y3Qg
a3ZtX21lbXNsb3RzICpzbG90czsKPiArCWludCByOwo+ICsKPiArCXNsb3RzID0ga3Z6YWxsb2Mo
c2l6ZW9mKHN0cnVjdCBrdm1fbWVtc2xvdHMpLCBHRlBfS0VSTkVMX0FDQ09VTlQpOwo+ICsJaWYg
KCFzbG90cykKPiArCQlyZXR1cm4gLUVOT01FTTsKPiArCW1lbWNweShzbG90cywgX19rdm1fbWVt
c2xvdHMoa3ZtLCBhc19pZCksIHNpemVvZihzdHJ1Y3Qga3ZtX21lbXNsb3RzKSk7Cj4gKwo+ICsJ
aWYgKGNoYW5nZSA9PSBLVk1fTVJfREVMRVRFIHx8IGNoYW5nZSA9PSBLVk1fTVJfTU9WRSkgewo+
ICsJCS8qCj4gKwkJICogTm90ZSwgdGhlIElOVkFMSUQgZmxhZyBuZWVkcyB0byBiZSBpbiB0aGUg
YXBwcm9wcmlhdGUgZW50cnkKPiArCQkgKiBpbiB0aGUgZnJlc2hseSBhbGxvY2F0ZWQgbWVtc2xv
dHMsIG5vdCBpbiBAb2xkIG9yIEBuZXcuCj4gKwkJICovCj4gKwkJc2xvdCA9IGlkX3RvX21lbXNs
b3Qoc2xvdHMsIG9sZC0+aWQpOwo+ICsJCXNsb3QtPmZsYWdzIHw9IEtWTV9NRU1TTE9UX0lOVkFM
SUQ7Cj4gKwo+ICsJCS8qCj4gKwkJICogV2UgY2FuIHJlLXVzZSB0aGUgb2xkIG1lbXNsb3RzLCB0
aGUgb25seSBkaWZmZXJlbmNlIGZyb20gdGhlCj4gKwkJICogbmV3bHkgaW5zdGFsbGVkIG1lbXNs
b3RzIGlzIHRoZSBpbnZhbGlkIGZsYWcsIHdoaWNoIHdpbGwgZ2V0Cj4gKwkJICogZHJvcHBlZCBi
eSB1cGRhdGVfbWVtc2xvdHMgYW55d2F5LiAgV2UnbGwgYWxzbyByZXZlcnQgdG8gdGhlCj4gKwkJ
ICogb2xkIG1lbXNsb3RzIGlmIHByZXBhcmluZyB0aGUgbmV3IG1lbW9yeSByZWdpb24gZmFpbHMu
Cj4gKwkJICovCj4gKwkJc2xvdHMgPSBpbnN0YWxsX25ld19tZW1zbG90cyhrdm0sIGFzX2lkLCBz
bG90cyk7Cj4gKwo+ICsJCS8qIEZyb20gdGhpcyBwb2ludCBubyBuZXcgc2hhZG93IHBhZ2VzIHBv
aW50aW5nIHRvIGEgZGVsZXRlZCwKPiArCQkgKiBvciBtb3ZlZCwgbWVtc2xvdCB3aWxsIGJlIGNy
ZWF0ZWQuCj4gKwkJICoKPiArCQkgKiB2YWxpZGF0aW9uIG9mIHNwLT5nZm4gaGFwcGVucyBpbjoK
PiArCQkgKgktIGdmbl90b19odmEgKGt2bV9yZWFkX2d1ZXN0LCBnZm5fdG9fcGZuKQo+ICsJCSAq
CS0ga3ZtX2lzX3Zpc2libGVfZ2ZuIChtbXVfY2hlY2tfcm9vdHMpCj4gKwkJICovCj4gKwkJa3Zt
X2FyY2hfZmx1c2hfc2hhZG93X21lbXNsb3Qoa3ZtLCBzbG90KTsKPiArCX0KPiArCj4gKwlyID0g
a3ZtX2FyY2hfcHJlcGFyZV9tZW1vcnlfcmVnaW9uKGt2bSwgbmV3LCBtZW0sIGNoYW5nZSk7Cj4g
KwlpZiAocikKPiArCQlnb3RvIG91dF9zbG90czsKPiArCj4gKwl1cGRhdGVfbWVtc2xvdHMoc2xv
dHMsIG5ldywgY2hhbmdlKTsKPiArCXNsb3RzID0gaW5zdGFsbF9uZXdfbWVtc2xvdHMoa3ZtLCBh
c19pZCwgc2xvdHMpOwo+ICsKPiArCWt2bV9hcmNoX2NvbW1pdF9tZW1vcnlfcmVnaW9uKGt2bSwg
bWVtLCBvbGQsIG5ldywgY2hhbmdlKTsKPiArCj4gKwlrdmZyZWUoc2xvdHMpOwo+ICsJcmV0dXJu
IDA7Cj4gKwo+ICtvdXRfc2xvdHM6Cj4gKwlpZiAoY2hhbmdlID09IEtWTV9NUl9ERUxFVEUgfHwg
Y2hhbmdlID09IEtWTV9NUl9NT1ZFKQo+ICsJCXNsb3RzID0gaW5zdGFsbF9uZXdfbWVtc2xvdHMo
a3ZtLCBhc19pZCwgc2xvdHMpOwo+ICsJa3ZmcmVlKHNsb3RzKTsKPiArCXJldHVybiByOwo+ICt9
Cj4gKwo+ICAgLyoKPiAgICAqIEFsbG9jYXRlIHNvbWUgbWVtb3J5IGFuZCBnaXZlIGl0IGFuIGFk
ZHJlc3MgaW4gdGhlIGd1ZXN0IHBoeXNpY2FsIGFkZHJlc3MKPiAgICAqIHNwYWNlLgo+IEBAIC05
MzYsNyArOTk2LDYgQEAgaW50IF9fa3ZtX3NldF9tZW1vcnlfcmVnaW9uKHN0cnVjdCBrdm0gKmt2
bSwKPiAgIAl1bnNpZ25lZCBsb25nIG5wYWdlczsKPiAgIAlzdHJ1Y3Qga3ZtX21lbW9yeV9zbG90
ICpzbG90Owo+ICAgCXN0cnVjdCBrdm1fbWVtb3J5X3Nsb3Qgb2xkLCBuZXc7Cj4gLQlzdHJ1Y3Qg
a3ZtX21lbXNsb3RzICpzbG90czsKPiAgIAlpbnQgYXNfaWQsIGlkOwo+ICAgCWVudW0ga3ZtX21y
X2NoYW5nZSBjaGFuZ2U7Cj4gICAKPiBAQCAtMTAyMyw1OCArMTA4MiwxOSBAQCBpbnQgX19rdm1f
c2V0X21lbW9yeV9yZWdpb24oc3RydWN0IGt2bSAqa3ZtLAo+ICAgCQkJcmV0dXJuIHI7Cj4gICAJ
fQo+ICAgCj4gLQlzbG90cyA9IGt2emFsbG9jKHNpemVvZihzdHJ1Y3Qga3ZtX21lbXNsb3RzKSwg
R0ZQX0tFUk5FTF9BQ0NPVU5UKTsKPiAtCWlmICghc2xvdHMpIHsKPiAtCQlyID0gLUVOT01FTTsK
PiAtCQlnb3RvIG91dF9iaXRtYXA7Cj4gLQl9Cj4gLQltZW1jcHkoc2xvdHMsIF9fa3ZtX21lbXNs
b3RzKGt2bSwgYXNfaWQpLCBzaXplb2Yoc3RydWN0IGt2bV9tZW1zbG90cykpOwo+IC0KPiAtCWlm
ICgoY2hhbmdlID09IEtWTV9NUl9ERUxFVEUpIHx8IChjaGFuZ2UgPT0gS1ZNX01SX01PVkUpKSB7
Cj4gLQkJc2xvdCA9IGlkX3RvX21lbXNsb3Qoc2xvdHMsIGlkKTsKPiAtCQlzbG90LT5mbGFncyB8
PSBLVk1fTUVNU0xPVF9JTlZBTElEOwo+IC0KPiAtCQkvKgo+IC0JCSAqIFdlIGNhbiByZS11c2Ug
dGhlIG9sZCBtZW1zbG90cywgdGhlIG9ubHkgZGlmZmVyZW5jZSBmcm9tIHRoZQo+IC0JCSAqIG5l
d2x5IGluc3RhbGxlZCBtZW1zbG90cyBpcyB0aGUgaW52YWxpZCBmbGFnLCB3aGljaCB3aWxsIGdl
dAo+IC0JCSAqIGRyb3BwZWQgYnkgdXBkYXRlX21lbXNsb3RzIGFueXdheS4gIFdlJ2xsIGFsc28g
cmV2ZXJ0IHRvIHRoZQo+IC0JCSAqIG9sZCBtZW1zbG90cyBpZiBwcmVwYXJpbmcgdGhlIG5ldyBt
ZW1vcnkgcmVnaW9uIGZhaWxzLgo+IC0JCSAqLwo+IC0JCXNsb3RzID0gaW5zdGFsbF9uZXdfbWVt
c2xvdHMoa3ZtLCBhc19pZCwgc2xvdHMpOwo+IC0KPiAtCQkvKiBGcm9tIHRoaXMgcG9pbnQgbm8g
bmV3IHNoYWRvdyBwYWdlcyBwb2ludGluZyB0byBhIGRlbGV0ZWQsCj4gLQkJICogb3IgbW92ZWQs
IG1lbXNsb3Qgd2lsbCBiZSBjcmVhdGVkLgo+IC0JCSAqCj4gLQkJICogdmFsaWRhdGlvbiBvZiBz
cC0+Z2ZuIGhhcHBlbnMgaW46Cj4gLQkJICoJLSBnZm5fdG9faHZhIChrdm1fcmVhZF9ndWVzdCwg
Z2ZuX3RvX3BmbikKPiAtCQkgKgktIGt2bV9pc192aXNpYmxlX2dmbiAobW11X2NoZWNrX3Jvb3Rz
KQo+IC0JCSAqLwo+IC0JCWt2bV9hcmNoX2ZsdXNoX3NoYWRvd19tZW1zbG90KGt2bSwgc2xvdCk7
Cj4gLQl9Cj4gLQo+IC0JciA9IGt2bV9hcmNoX3ByZXBhcmVfbWVtb3J5X3JlZ2lvbihrdm0sICZu
ZXcsIG1lbSwgY2hhbmdlKTsKPiAtCWlmIChyKQo+IC0JCWdvdG8gb3V0X3Nsb3RzOwo+IC0KPiAg
IAkvKiBhY3R1YWwgbWVtb3J5IGlzIGZyZWVkIHZpYSBvbGQgaW4ga3ZtX2ZyZWVfbWVtc2xvdCBi
ZWxvdyAqLwo+ICAgCWlmIChjaGFuZ2UgPT0gS1ZNX01SX0RFTEVURSkgewo+ICAgCQluZXcuZGly
dHlfYml0bWFwID0gTlVMTDsKPiAgIAkJbWVtc2V0KCZuZXcuYXJjaCwgMCwgc2l6ZW9mKG5ldy5h
cmNoKSk7Cj4gICAJfQo+ICAgCj4gLQl1cGRhdGVfbWVtc2xvdHMoc2xvdHMsICZuZXcsIGNoYW5n
ZSk7Cj4gLQlzbG90cyA9IGluc3RhbGxfbmV3X21lbXNsb3RzKGt2bSwgYXNfaWQsIHNsb3RzKTsK
PiAtCj4gLQlrdm1fYXJjaF9jb21taXRfbWVtb3J5X3JlZ2lvbihrdm0sIG1lbSwgJm9sZCwgJm5l
dywgY2hhbmdlKTsKPiArCXIgPSBrdm1fc2V0X21lbXNsb3Qoa3ZtLCBtZW0sICZvbGQsICZuZXcs
IGFzX2lkLCBjaGFuZ2UpOwo+ICsJaWYgKHIpCj4gKwkJZ290byBvdXRfYml0bWFwOwo+ICAgCj4g
ICAJa3ZtX2ZyZWVfbWVtc2xvdChrdm0sICZvbGQsICZuZXcpOwo+IC0Ja3ZmcmVlKHNsb3RzKTsK
PiAgIAlyZXR1cm4gMDsKPiAgIAo+IC1vdXRfc2xvdHM6Cj4gLQlpZiAoY2hhbmdlID09IEtWTV9N
Ul9ERUxFVEUgfHwgY2hhbmdlID09IEtWTV9NUl9NT1ZFKQo+IC0JCXNsb3RzID0gaW5zdGFsbF9u
ZXdfbWVtc2xvdHMoa3ZtLCBhc19pZCwgc2xvdHMpOwo+IC0Ja3ZmcmVlKHNsb3RzKTsKPiAgIG91
dF9iaXRtYXA6Cj4gICAJaWYgKG5ldy5kaXJ0eV9iaXRtYXAgJiYgIW9sZC5kaXJ0eV9iaXRtYXAp
Cj4gICAJCWt2bV9kZXN0cm95X2RpcnR5X2JpdG1hcCgmbmV3KTsKPiAKClJldmlld2VkLWJ5OiBQ
aGlsaXBwZSBNYXRoaWV1LURhdWTDqSA8ZjRidWdAYW1zYXQub3JnPgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFy
bUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFp
bG1hbi9saXN0aW5mby9rdm1hcm0K
