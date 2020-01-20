Return-Path: <SRS0=lFwt=3J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B22C32771
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 04:04:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6162B2070C
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 04:04:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ozlabs.org header.i=@ozlabs.org header.b="V/Pa+sHE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6162B2070C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD5DE4AF25;
	Sun, 19 Jan 2020 23:04:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ozlabs.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fZzwYrHGMSb9; Sun, 19 Jan 2020 23:04:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7CCC4AF1B;
	Sun, 19 Jan 2020 23:04:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 812974AF15
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jan 2020 23:04:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SbpSGXjkyg8c for <kvmarm@lists.cs.columbia.edu>;
 Sun, 19 Jan 2020 23:04:22 -0500 (EST)
Received: from ozlabs.org (bilbo.ozlabs.org [203.11.71.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 609694AF14
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jan 2020 23:04:22 -0500 (EST)
Received: by ozlabs.org (Postfix, from userid 1003)
 id 481J2T5VvKz9sRQ; Mon, 20 Jan 2020 15:04:17 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
 t=1579493057; bh=GlIncoWYmOYv5Dni23RSwo6uZojZl918YWnmGeGzyJI=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=V/Pa+sHEae+jG71OR9r2A404DaS5UBDnEl6W5GR08hXip3iEYMnPJKOgSS38mznMS
 QFzFYRElYmpf39vGFlmcBXqAVGdMsLFjm/U25lpx6q0fNhotMfBPwIAqSNRKv/jocP
 A5kGrOXz8juIsyZkgL8m65HZO5Fh3mx4+Y9Ux1ecPuIMT+sYjoMy+YSKDxMsJPTVPp
 HQfIaljJGxLrxk3xUQeJAE38M8fGC3e1O4wLIfYvDRR2aZSLUNac6unBI8qCtwWfOb
 HgwP/Q9WG5+8ApO9XCFy1bxiLQ13UNNmnGOK8PeEgB/i16xsXwKAaVRbebZ2djABCZ
 zP8/aQGwqo1nw==
Date: Mon, 20 Jan 2020 15:04:12 +1100
From: Paul Mackerras <paulus@ozlabs.org>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 12/45] KVM: PPC: Allocate vcpu struct in common PPC code
Message-ID: <20200120040412.GF14307@blackberry>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-13-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191218215530.2280-13-sean.j.christopherson@intel.com>
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

T24gV2VkLCBEZWMgMTgsIDIwMTkgYXQgMDE6NTQ6NTdQTSAtMDgwMCwgU2VhbiBDaHJpc3RvcGhl
cnNvbiB3cm90ZToKPiBNb3ZlIGFsbG9jYXRpb24gb2YgYWxsIGZsYXZvcnMgb2YgUFBDIHZDUFVz
IHRvIGNvbW1vbiBQUEMgY29kZS4gIEFsbAo+IHZhcmlhbnRzIGVpdGhlciBhbGxvY2F0ZSAnc3Ry
dWN0IGt2bV92Y3B1JyBkaXJlY3RseSwgb3IgcmVxdWlyZSB0aGF0Cj4gdGhlIGVtYmVkZGVkICdz
dHJ1Y3Qga3ZtX3ZjcHUnIG1lbWJlciBiZSBsb2NhdGVkIGF0IG9mZnNldCAwLCBpLmUuCj4gZ3Vh
cmFudGVlIHRoYXQgdGhlIGFsbG9jYXRpb24gY2FuIGJlIGRpcmVjdGx5IGludGVycHJldGVkIGFz
IGEgJ3N0cnVjdAo+IGt2bV92Y3B1JyBvYmplY3QuCj4gCj4gUmVtb3ZlIHRoZSBtZXNzYWdlIGZy
b20gdGhlIGJ1aWxkLXRpbWUgYXNzZXJ0aW9uIHJlZ2FyZGluZyBwbGFjZW1lbnQgb2YKPiB0aGUg
c3RydWN0LCBhcyBjb21wYXRpYmlsaXR5IHdpdGggdGhlIGFyY2ggdXNlcmNvcHkgcmVnaW9uIGlz
IG5vIGxvbmdlcgo+IHRoZSBzb2xlIGRlcGVuZGVudCBvbiAnc3RydWN0IGt2bV92Y3B1JyBiZWlu
ZyBhdCBvZmZzZXQgemVyby4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29u
IDxzZWFuLmouY2hyaXN0b3BoZXJzb25AaW50ZWwuY29tPgoKVGhpcyBmYWlscyB0byBjb21waWxl
IGZvciBCb29rIEUgY29uZmlnczoKCiAgQ0MgICAgICBhcmNoL3Bvd2VycGMva3ZtL2U1MDAubwov
aG9tZS9wYXVsdXMva2VybmVsL2t2bS9hcmNoL3Bvd2VycGMva3ZtL2U1MDAuYzogSW4gZnVuY3Rp
b24g4oCYa3ZtcHBjX2NvcmVfdmNwdV9jcmVhdGVfZTUwMOKAmToKL2hvbWUvcGF1bHVzL2tlcm5l
bC9rdm0vYXJjaC9wb3dlcnBjL2t2bS9lNTAwLmM6NDY0Ojk6IGVycm9yOiByZXR1cm4gbWFrZXMg
aW50ZWdlciBmcm9tIHBvaW50ZXIgd2l0aG91dCBhIGNhc3QgWy1XZXJyb3I9aW50LWNvbnZlcnNp
b25dCiAgcmV0dXJuIHZjcHU7CiAgICAgICAgIF4KY2MxOiBhbGwgd2FybmluZ3MgYmVpbmcgdHJl
YXRlZCBhcyBlcnJvcnMKbWFrZVszXTogKioqIFsvaG9tZS9wYXVsdXMva2VybmVsL2t2bS9zY3Jp
cHRzL01ha2VmaWxlLmJ1aWxkOjI2NjogYXJjaC9wb3dlcnBjL2t2bS9lNTAwLm9dIEVycm9yIDEK
ClRoZXJlIGlzIGEgInJldHVybiB2Y3B1IiBzdGF0ZW1lbnQgaW4ga3ZtcHBjX2NvcmVfdmNwdV9j
cmVhdGVfZTUwMCgpLAphbmQgYW5vdGhlciBpbiBrdm1wcGNfY29yZV92Y3B1X2NyZWF0ZV9lNTAw
bWMoKSwgd2hpY2ggYm90aCBuZWVkIHRvIGJlCmNoYW5nZWQgdG8gInJldHVybiAwIi4KCihCeSB0
aGUgd2F5LCBJIGRvIGFwcHJlY2lhdGUgeW91IGZpeGluZyB0aGUgUFBDIGNvZGUsIGV2ZW4gaWYg
dGhlcmUKYXJlIHNvbWUgZXJyb3JzLikKClBhdWwuCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3Rp
bmZvL2t2bWFybQo=
