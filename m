Return-Path: <SRS0=DlSC=3K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 099FEC2D0CE
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 11:12:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7D21D2253D
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 11:12:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IqadHOdJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D21D2253D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CBD74AF6C;
	Tue, 21 Jan 2020 06:12:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Xl-CdxZ9e37h; Tue, 21 Jan 2020 06:12:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BCD14AFC2;
	Tue, 21 Jan 2020 06:12:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0154A4AFBD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 06:12:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zCYZqrDHnle8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 06:12:15 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32A054AF6C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 06:12:15 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579605134;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9wI+OtjZQZO6FFE1g0sfkBylA9HInh8CzN6tgRswnV4=;
 b=IqadHOdJ9rkbU7kz9hfxxTD2TrLO0RUm3Mz5fSzflXNDIyi9AoMeJsf80qmeeu0dUUXK8c
 6zrHxzByW7Gb497xTYLAfkKxMM2eM9OQSaiEuf/tzdlfm+dcCibW++sSurLmICvZAB6JB1
 /WPEObNBG43pt9rLXk9JlmmopOC0DI8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-fc3LdLLHP0yQ3PnRjPVJfg-1; Tue, 21 Jan 2020 06:12:13 -0500
Received: by mail-wr1-f72.google.com with SMTP id j4so1161368wrs.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 03:12:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=SUmH5ZMutw7kgyRL+tUGBiFKuqlrQTYA6wv/vKtVsig=;
 b=b0JMKto37btQjVR62qaAyC5UaZHwQgRrdZhC0H1kiPJSRI6muhfqBfHUyIuIlJmU+r
 iWizKbVxvpYcI6AvsqfFCw5fRJxoyQ9boYiuqQwQo/5qVHpXrIXVPl3/zidhPqgXompb
 AyAoM7bJ9C8ulPKCH66j7Dzp5CTyAjPJaETZ9Qy5epacMzVE+Ymm2NCSdZNkXp5rYl06
 gD48vYldid6pgUEALDhV3pO6Rj/ms7ZPjW63wrYajxW5vdLuYDxSME0B6vOvfFbBaOLO
 c5zKHViQ17sX2BfNL26uU0XOVXwIUSOKgTXxyKP6EagjKAjVzkYwCUj1JAvaT05qomUu
 CyBQ==
X-Gm-Message-State: APjAAAXwwWu72xyJUh4OEGCTYcJgNVlEtjLNpiMAeJBA+pmNOcCMFGcO
 SnKBcBRm3rnqUSFJj6Mv54Zb6fbxf+3xm1hzKbm4VV+zT0Pm8Y2dAt4Xvm5EPInz+EtDu3Sv7cn
 1p9+C5aBImXDyIs9rVRXGpgOi
X-Received: by 2002:a05:6000:11c9:: with SMTP id
 i9mr4806251wrx.164.1579605131971; 
 Tue, 21 Jan 2020 03:12:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqypfAKKGH/a848HhEdWp/8kNPn20JC8kc1fEqjae+lABJTb9oaxjSSRLWrYZHNDzVwQwM45Kg==
X-Received: by 2002:a05:6000:11c9:: with SMTP id
 i9mr4806191wrx.164.1579605131619; 
 Tue, 21 Jan 2020 03:12:11 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a?
 ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
 by smtp.gmail.com with ESMTPSA id z8sm51076203wrq.22.2020.01.21.03.12.09
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Jan 2020 03:12:11 -0800 (PST)
Subject: Re: [PATCH v2 41/45] KVM: PPC: Move all vcpu init code into
 kvm_arch_vcpu_create()
To: Paul Mackerras <paulus@ozlabs.org>,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-42-sean.j.christopherson@intel.com>
 <20200120034658.GD14307@blackberry>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d3d465b0-6a45-c754-0538-1e4d1e130357@redhat.com>
Date: Tue, 21 Jan 2020 12:12:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200120034658.GD14307@blackberry>
Content-Language: en-US
X-MC-Unique: fc3LdLLHP0yQ3PnRjPVJfg-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Christian Borntraeger <borntraeger@de.ibm.com>, Greg Kurz <groug@kaod.org>,
 linux-arm-kernel@lists.infradead.org, James Hogan <jhogan@kernel.org>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

T24gMjAvMDEvMjAgMDQ6NDYsIFBhdWwgTWFja2VycmFzIHdyb3RlOgo+IE9uIFdlZCwgRGVjIDE4
LCAyMDE5IGF0IDAxOjU1OjI2UE0gLTA4MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6Cj4+
IEZvbGQgaW5pdCgpIGludG8gY3JlYXRlKCkgbm93IHRoYXQgdGhlIHR3byBhcmUgY2FsbGVkIGJh
Y2stdG8tYmFjayBieQo+PiBjb21tb24gS1ZNIGNvZGUgKGt2bV92Y3B1X2luaXQoKSBjYWxscyBr
dm1fYXJjaF92Y3B1X2luaXQoKSBhcyBpdHMgbGFzdAo+PiBhY3Rpb24sIGFuZCBrdm1fdm1faW9j
dGxfY3JlYXRlX3ZjcHUoKSBjYWxscyBrdm1fYXJjaF92Y3B1X2NyZWF0ZSgpCj4+IGltbWVkaWF0
ZWx5IHRoZXJlYWZ0ZXIpLiAgUmluc2UgYW5kIHJlcGVhdCBmb3Iga3ZtX2FyY2hfdmNwdV91bmlu
aXQoKQo+PiBhbmQga3ZtX2FyY2hfdmNwdV9kZXN0cm95KCkuICBUaGlzIHBhdmVzIHRoZSB3YXkg
Zm9yIHJlbW92aW5nCj4+IGt2bV9hcmNoX3ZjcHVfe3VufWluaXQoKSBlbnRpcmVseS4KPj4KPj4g
Tm90ZSwgY2FsbGluZyBrdm1wcGNfbW11X2Rlc3Ryb3koKSBpZiBrdm1wcGNfY29yZV92Y3B1X2Ny
ZWF0ZSgpIGZhaWxzCj4+IG1heSBvciBtYXkgbm90IGJlIG5lY2Vzc2FyeS4gIE1vdmUgaXQgYWxv
bmcgd2l0aCB0aGUgbW9yZSBvYnZpb3VzIGNhbGwKPj4gdG8ga3ZtcHBjX3N1YmFyY2hfdmNwdV91
bmluaXQoKSBzbyBhcyBub3QgdG8gaW5hZHZlcnRhbnRseSBpbnRyb2R1Y2UgYQo+PiBmdW5jdGlv
bmFsIGNoYW5nZSBhbmQvb3IgYnVnLgo+Pgo+PiBObyBmdW5jdGlvbmFsIGNoYW5nZSBpbnRlbmRl
ZC4KPj4KPj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vhbi5qLmNocmlz
dG9waGVyc29uQGludGVsLmNvbT4KPiAKPiBUaGlzIGRvZXNuJ3QgY29tcGlsZS4gIEkgZ2V0Ogo+
IAo+ICAgQ0MgW01dICBhcmNoL3Bvd2VycGMva3ZtL3Bvd2VycGMubwo+IC9ob21lL3BhdWx1cy9r
ZXJuZWwva3ZtL2FyY2gvcG93ZXJwYy9rdm0vcG93ZXJwYy5jOiBJbiBmdW5jdGlvbiDigJhrdm1f
YXJjaF92Y3B1X2NyZWF0ZeKAmToKPiAvaG9tZS9wYXVsdXMva2VybmVsL2t2bS9hcmNoL3Bvd2Vy
cGMva3ZtL3Bvd2VycGMuYzo3MzM6MzQ6IGVycm9yOiDigJhrdm1wcGNfZGVjcmVtZW50ZXJfd2Fr
ZXVw4oCZIHVuZGVjbGFyZWQgKGZpcnN0IHVzZSBpbiB0aGlzIGZ1bmN0aW9uKQo+ICAgdmNwdS0+
YXJjaC5kZWNfdGltZXIuZnVuY3Rpb24gPSBrdm1wcGNfZGVjcmVtZW50ZXJfd2FrZXVwOwo+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBeCj4gL2hvbWUvcGF1bHVzL2tlcm5lbC9r
dm0vYXJjaC9wb3dlcnBjL2t2bS9wb3dlcnBjLmM6NzMzOjM0OiBub3RlOiBlYWNoIHVuZGVjbGFy
ZWQgaWRlbnRpZmllciBpcyByZXBvcnRlZCBvbmx5IG9uY2UgZm9yIGVhY2ggZnVuY3Rpb24gaXQg
YXBwZWFycyBpbgo+IC9ob21lL3BhdWx1cy9rZXJuZWwva3ZtL2FyY2gvcG93ZXJwYy9rdm0vcG93
ZXJwYy5jOiBBdCB0b3AgbGV2ZWw6Cj4gL2hvbWUvcGF1bHVzL2tlcm5lbC9rdm0vYXJjaC9wb3dl
cnBjL2t2bS9wb3dlcnBjLmM6Nzk0OjI5OiB3YXJuaW5nOiDigJhrdm1wcGNfZGVjcmVtZW50ZXJf
d2FrZXVw4oCZIGRlZmluZWQgYnV0IG5vdCB1c2VkIFstV3VudXNlZC1mdW5jdGlvbl0KPiAgc3Rh
dGljIGVudW0gaHJ0aW1lcl9yZXN0YXJ0IGt2bXBwY19kZWNyZW1lbnRlcl93YWtldXAoc3RydWN0
IGhydGltZXIgKnRpbWVyKQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXgo+IG1ha2Vb
M106ICoqKiBbL2hvbWUvcGF1bHVzL2tlcm5lbC9rdm0vc2NyaXB0cy9NYWtlZmlsZS5idWlsZDoy
NjY6IGFyY2gvcG93ZXJwYy9rdm0vcG93ZXJwYy5vXSBFcnJvciAxCj4gCj4gVGhlIHByb2JsZW0g
aXMgdGhhdCBrdm1wcGNfZGVjcmVtZW50ZXJfd2FrZXVwKCkgaXMgYSBzdGF0aWMgZnVuY3Rpb24K
PiBkZWZpbmVkIGluIHRoaXMgZmlsZSAoYXJjaC9wb3dlcnBjL2t2bS9wb3dlcnBjLmMpIGFmdGVy
Cj4ga3ZtX2FyY2hfdmNwdV9jcmVhdGUoKSBidXQgYmVmb3JlIGt2bV9hcmNoX3ZjcHVfaW5pdCgp
LiAgWW91IG5lZWQgYQo+IGZvcndhcmQgc3RhdGljIGRlY2xhcmF0aW9uIG9mIGt2bXBwY19kZWNy
ZW1lbnRlcl93YWtldXAoKSBiZWZvcmUKPiBrdm1fYXJjaF92Y3B1X2NyZWF0ZSgpLCBvciBlbHNl
IG1vdmUgb25lIG9yIG90aGVyIGZ1bmN0aW9uLgo+IAo+IFBhdWwuCj4gCgpTcXVhc2hlZDoKCmRp
ZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMva3ZtL3Bvd2VycGMuYyBiL2FyY2gvcG93ZXJwYy9rdm0v
cG93ZXJwYy5jCmluZGV4IDkxY2Y5NGQ0MTkxZS4uNGZiZjg2OTBiOGM1IDEwMDY0NAotLS0gYS9h
cmNoL3Bvd2VycGMva3ZtL3Bvd2VycGMuYworKysgYi9hcmNoL3Bvd2VycGMva3ZtL3Bvd2VycGMu
YwpAQCAtNzI1LDYgKzcyNSwxNiBAQCBpbnQga3ZtX2FyY2hfdmNwdV9wcmVjcmVhdGUoc3RydWN0
IGt2bSAqa3ZtLCB1bnNpZ25lZCBpbnQgaWQpCiAJcmV0dXJuIDA7CiB9CiAKK3N0YXRpYyBlbnVt
IGhydGltZXJfcmVzdGFydCBrdm1wcGNfZGVjcmVtZW50ZXJfd2FrZXVwKHN0cnVjdCBocnRpbWVy
ICp0aW1lcikKK3sKKwlzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHU7CisKKwl2Y3B1ID0gY29udGFpbmVy
X29mKHRpbWVyLCBzdHJ1Y3Qga3ZtX3ZjcHUsIGFyY2guZGVjX3RpbWVyKTsKKwlrdm1wcGNfZGVj
cmVtZW50ZXJfZnVuYyh2Y3B1KTsKKworCXJldHVybiBIUlRJTUVSX05PUkVTVEFSVDsKK30KKwog
aW50IGt2bV9hcmNoX3ZjcHVfY3JlYXRlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKIHsKIAlpbnQg
ZXJyOwpAQCAtNzkxLDE2ICs4MDEsNiBAQCBpbnQga3ZtX2NwdV9oYXNfcGVuZGluZ190aW1lcihz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCiAJcmV0dXJuIGt2bXBwY19jb3JlX3BlbmRpbmdfZGVjKHZj
cHUpOwogfQogCi1zdGF0aWMgZW51bSBocnRpbWVyX3Jlc3RhcnQga3ZtcHBjX2RlY3JlbWVudGVy
X3dha2V1cChzdHJ1Y3QgaHJ0aW1lciAqdGltZXIpCi17Ci0Jc3RydWN0IGt2bV92Y3B1ICp2Y3B1
OwotCi0JdmNwdSA9IGNvbnRhaW5lcl9vZih0aW1lciwgc3RydWN0IGt2bV92Y3B1LCBhcmNoLmRl
Y190aW1lcik7Ci0Ja3ZtcHBjX2RlY3JlbWVudGVyX2Z1bmModmNwdSk7Ci0KLQlyZXR1cm4gSFJU
SU1FUl9OT1JFU1RBUlQ7Ci19Ci0KIGludCBrdm1fYXJjaF92Y3B1X2luaXQoc3RydWN0IGt2bV92
Y3B1ICp2Y3B1KQogewogCXJldHVybiAwOwoKUGFvbG8KCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3Rz
LmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xp
c3RpbmZvL2t2bWFybQo=
