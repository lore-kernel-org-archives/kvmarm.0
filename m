Return-Path: <SRS0=lFwt=3J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 365EFC32771
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 03:47:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A7B5220684
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 03:47:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ozlabs.org header.i=@ozlabs.org header.b="JwTKZpUV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7B5220684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13FE64AED4;
	Sun, 19 Jan 2020 22:47:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ozlabs.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MnDPZSGgSav0; Sun, 19 Jan 2020 22:47:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05BA94AED5;
	Sun, 19 Jan 2020 22:47:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA40B4AECF
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jan 2020 22:47:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NRys7uwSrmji for <kvmarm@lists.cs.columbia.edu>;
 Sun, 19 Jan 2020 22:47:14 -0500 (EST)
Received: from ozlabs.org (bilbo.ozlabs.org [203.11.71.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8805E4AE9D
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jan 2020 22:47:14 -0500 (EST)
Received: by ozlabs.org (Postfix, from userid 1003)
 id 481Hfj74CGz9sRK; Mon, 20 Jan 2020 14:47:09 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
 t=1579492030; bh=1dfZ9T6ilNfzX2EqbpEQ5eAKgIEJ6P5R1+t5DDy1LSA=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=JwTKZpUVsDbJ4TcBhEsofl/FKEJ5tQrZ9Aj0R5fO2fk6ipXMh/Ze+fuyk+OikxvSN
 67/wLRnHG2mDyEw8LSp8oRMr2p5aKIS1bUJ4t3GOuRZbsLyzpzHmOuZ2qTHBGOqfbF
 moZ/eN5AqS9TPo6UXaN5U6ooTa7+OmIYkvdmFYWqpFVxDhUrMzJ34X8IxIDq0Ms2f6
 wkQCV272ypuxGDczKD0+9/Hd5WXIkWzuKDoo+s7KsL/R/o3ah5CvtNtzTmgEF5QLDA
 JoX9Oljp4OG49H/vTZPOusq/ctGjNpNJBsOmEo+EUk8lzjUU+oofoyANvdWbPRrwrC
 HNXz1928tQDng==
Date: Mon, 20 Jan 2020 14:46:58 +1100
From: Paul Mackerras <paulus@ozlabs.org>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 41/45] KVM: PPC: Move all vcpu init code into
 kvm_arch_vcpu_create()
Message-ID: <20200120034658.GD14307@blackberry>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-42-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191218215530.2280-42-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Christian Borntraeger <borntraeger@de.ibm.com>, Greg Kurz <groug@kaod.org>,
 linux-arm-kernel@lists.infradead.org, James Hogan <jhogan@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gV2VkLCBEZWMgMTgsIDIwMTkgYXQgMDE6NTU6MjZQTSAtMDgwMCwgU2VhbiBDaHJpc3RvcGhl
cnNvbiB3cm90ZToKPiBGb2xkIGluaXQoKSBpbnRvIGNyZWF0ZSgpIG5vdyB0aGF0IHRoZSB0d28g
YXJlIGNhbGxlZCBiYWNrLXRvLWJhY2sgYnkKPiBjb21tb24gS1ZNIGNvZGUgKGt2bV92Y3B1X2lu
aXQoKSBjYWxscyBrdm1fYXJjaF92Y3B1X2luaXQoKSBhcyBpdHMgbGFzdAo+IGFjdGlvbiwgYW5k
IGt2bV92bV9pb2N0bF9jcmVhdGVfdmNwdSgpIGNhbGxzIGt2bV9hcmNoX3ZjcHVfY3JlYXRlKCkK
PiBpbW1lZGlhdGVseSB0aGVyZWFmdGVyKS4gIFJpbnNlIGFuZCByZXBlYXQgZm9yIGt2bV9hcmNo
X3ZjcHVfdW5pbml0KCkKPiBhbmQga3ZtX2FyY2hfdmNwdV9kZXN0cm95KCkuICBUaGlzIHBhdmVz
IHRoZSB3YXkgZm9yIHJlbW92aW5nCj4ga3ZtX2FyY2hfdmNwdV97dW59aW5pdCgpIGVudGlyZWx5
Lgo+IAo+IE5vdGUsIGNhbGxpbmcga3ZtcHBjX21tdV9kZXN0cm95KCkgaWYga3ZtcHBjX2NvcmVf
dmNwdV9jcmVhdGUoKSBmYWlscwo+IG1heSBvciBtYXkgbm90IGJlIG5lY2Vzc2FyeS4gIE1vdmUg
aXQgYWxvbmcgd2l0aCB0aGUgbW9yZSBvYnZpb3VzIGNhbGwKPiB0byBrdm1wcGNfc3ViYXJjaF92
Y3B1X3VuaW5pdCgpIHNvIGFzIG5vdCB0byBpbmFkdmVydGFudGx5IGludHJvZHVjZSBhCj4gZnVu
Y3Rpb25hbCBjaGFuZ2UgYW5kL29yIGJ1Zy4KPiAKPiBObyBmdW5jdGlvbmFsIGNoYW5nZSBpbnRl
bmRlZC4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuLmouY2hy
aXN0b3BoZXJzb25AaW50ZWwuY29tPgoKVGhpcyBkb2Vzbid0IGNvbXBpbGUuICBJIGdldDoKCiAg
Q0MgW01dICBhcmNoL3Bvd2VycGMva3ZtL3Bvd2VycGMubwovaG9tZS9wYXVsdXMva2VybmVsL2t2
bS9hcmNoL3Bvd2VycGMva3ZtL3Bvd2VycGMuYzogSW4gZnVuY3Rpb24g4oCYa3ZtX2FyY2hfdmNw
dV9jcmVhdGXigJk6Ci9ob21lL3BhdWx1cy9rZXJuZWwva3ZtL2FyY2gvcG93ZXJwYy9rdm0vcG93
ZXJwYy5jOjczMzozNDogZXJyb3I6IOKAmGt2bXBwY19kZWNyZW1lbnRlcl93YWtldXDigJkgdW5k
ZWNsYXJlZCAoZmlyc3QgdXNlIGluIHRoaXMgZnVuY3Rpb24pCiAgdmNwdS0+YXJjaC5kZWNfdGlt
ZXIuZnVuY3Rpb24gPSBrdm1wcGNfZGVjcmVtZW50ZXJfd2FrZXVwOwogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgXgovaG9tZS9wYXVsdXMva2VybmVsL2t2bS9hcmNoL3Bvd2VycGMv
a3ZtL3Bvd2VycGMuYzo3MzM6MzQ6IG5vdGU6IGVhY2ggdW5kZWNsYXJlZCBpZGVudGlmaWVyIGlz
IHJlcG9ydGVkIG9ubHkgb25jZSBmb3IgZWFjaCBmdW5jdGlvbiBpdCBhcHBlYXJzIGluCi9ob21l
L3BhdWx1cy9rZXJuZWwva3ZtL2FyY2gvcG93ZXJwYy9rdm0vcG93ZXJwYy5jOiBBdCB0b3AgbGV2
ZWw6Ci9ob21lL3BhdWx1cy9rZXJuZWwva3ZtL2FyY2gvcG93ZXJwYy9rdm0vcG93ZXJwYy5jOjc5
NDoyOTogd2FybmluZzog4oCYa3ZtcHBjX2RlY3JlbWVudGVyX3dha2V1cOKAmSBkZWZpbmVkIGJ1
dCBub3QgdXNlZCBbLVd1bnVzZWQtZnVuY3Rpb25dCiBzdGF0aWMgZW51bSBocnRpbWVyX3Jlc3Rh
cnQga3ZtcHBjX2RlY3JlbWVudGVyX3dha2V1cChzdHJ1Y3QgaHJ0aW1lciAqdGltZXIpCiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgXgptYWtlWzNdOiAqKiogWy9ob21lL3BhdWx1cy9rZXJu
ZWwva3ZtL3NjcmlwdHMvTWFrZWZpbGUuYnVpbGQ6MjY2OiBhcmNoL3Bvd2VycGMva3ZtL3Bvd2Vy
cGMub10gRXJyb3IgMQoKVGhlIHByb2JsZW0gaXMgdGhhdCBrdm1wcGNfZGVjcmVtZW50ZXJfd2Fr
ZXVwKCkgaXMgYSBzdGF0aWMgZnVuY3Rpb24KZGVmaW5lZCBpbiB0aGlzIGZpbGUgKGFyY2gvcG93
ZXJwYy9rdm0vcG93ZXJwYy5jKSBhZnRlcgprdm1fYXJjaF92Y3B1X2NyZWF0ZSgpIGJ1dCBiZWZv
cmUga3ZtX2FyY2hfdmNwdV9pbml0KCkuICBZb3UgbmVlZCBhCmZvcndhcmQgc3RhdGljIGRlY2xh
cmF0aW9uIG9mIGt2bXBwY19kZWNyZW1lbnRlcl93YWtldXAoKSBiZWZvcmUKa3ZtX2FyY2hfdmNw
dV9jcmVhdGUoKSwgb3IgZWxzZSBtb3ZlIG9uZSBvciBvdGhlciBmdW5jdGlvbi4KClBhdWwuCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWls
aW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNv
bHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
