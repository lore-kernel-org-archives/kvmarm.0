Return-Path: <SRS0=lFwt=3J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 565DFC32771
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 03:34:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C4E0820678
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 03:34:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ozlabs.org header.i=@ozlabs.org header.b="XhZomLA0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4E0820678
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 278724AEEB;
	Sun, 19 Jan 2020 22:34:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ozlabs.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Acj3CBK3NEml; Sun, 19 Jan 2020 22:34:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 189BB4AECC;
	Sun, 19 Jan 2020 22:34:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2BB24AEC3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jan 2020 22:34:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dgBZlnsNIoeb for <kvmarm@lists.cs.columbia.edu>;
 Sun, 19 Jan 2020 22:34:17 -0500 (EST)
Received: from ozlabs.org (ozlabs.org [203.11.71.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D8884ACF5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jan 2020 22:34:17 -0500 (EST)
Received: by ozlabs.org (Postfix, from userid 1003)
 id 481HMj19Cqz9sR1; Mon, 20 Jan 2020 14:34:09 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
 t=1579491249; bh=CYQ1aZ17JhSt3DjEaZvaRhmx5aaB56ZpLc9jKEgrQHg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=XhZomLA0ZQA5ksrIQZqTYTjoL3DPHU68CbqTHKmAYu16fL/fIE1BYH7UjUNBUUN96
 BOuEpy2CunYKbeiub7mIts8QMfAiWmeBeKcarVFg26ySQX+0isv7JeVEL1d4Z7b45d
 5m7sEPD4iauKp3dpRpTlihU23q+pd7On1gqkqYQPHrJPglWg+MBbDBmbYJkatU8xz0
 Uz3Fq5i/6DiaknB95EBdraZENg7mGA9XAyQVsRAdFWKMiy5SfqI7mq2lhpVa6uDvRO
 oWMfXTCMsTK2ig1sBV5Ak32Iy5mNr3ucrWW4O2iQ2wR/sSeHCe8APza70YCBWrJGVb
 GMaswqr6dHlKA==
Date: Mon, 20 Jan 2020 14:34:02 +1100
From: Paul Mackerras <paulus@ozlabs.org>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 15/45] KVM: PPC: Move kvm_vcpu_init() invocation to
 common code
Message-ID: <20200120033402.GC14307@blackberry>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-16-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191218215530.2280-16-sean.j.christopherson@intel.com>
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

T24gV2VkLCBEZWMgMTgsIDIwMTkgYXQgMDE6NTU6MDBQTSAtMDgwMCwgU2VhbiBDaHJpc3RvcGhl
cnNvbiB3cm90ZToKPiBNb3ZlIHRoZSBrdm1fY3B1X3t1bn1pbml0KCkgY2FsbHMgdG8gY29tbW9u
IFBQQyBjb2RlIGFzIGFuIGludGVybWVkaWF0ZQo+IHN0ZXAgdG93YXJkcyByZW1vdmluZyBrdm1f
Y3B1X3t1bn1pbml0KCkgYWx0b2dldGhlci4KPiAKPiBObyBmdW5jdGlvbmFsIGNoYW5nZSBpbnRl
bmRlZC4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuLmouY2hy
aXN0b3BoZXJzb25AaW50ZWwuY29tPgoKVGhpcyBkb2Vzbid0IGNvbXBpbGU6CgogIENDIFtNXSAg
YXJjaC9wb3dlcnBjL2t2bS9ib29rM3MubwovaG9tZS9wYXVsdXMva2VybmVsL2t2bS9hcmNoL3Bv
d2VycGMva3ZtL2Jvb2szcy5jOiBJbiBmdW5jdGlvbiDigJhrdm1wcGNfY29yZV92Y3B1X2NyZWF0
ZeKAmToKL2hvbWUvcGF1bHVzL2tlcm5lbC9rdm0vYXJjaC9wb3dlcnBjL2t2bS9ib29rM3MuYzo3
OTQ6OTogZXJyb3I6IOKAmGt2beKAmSB1bmRlY2xhcmVkIChmaXJzdCB1c2UgaW4gdGhpcyBmdW5j
dGlvbikKICByZXR1cm4ga3ZtLT5hcmNoLmt2bV9vcHMtPnZjcHVfY3JlYXRlKHZjcHUpOwogICAg
ICAgICBeCi9ob21lL3BhdWx1cy9rZXJuZWwva3ZtL2FyY2gvcG93ZXJwYy9rdm0vYm9vazNzLmM6
Nzk0Ojk6IG5vdGU6IGVhY2ggdW5kZWNsYXJlZCBpZGVudGlmaWVyIGlzIHJlcG9ydGVkIG9ubHkg
b25jZSBmb3IgZWFjaCBmdW5jdGlvbiBpdCBhcHBlYXJzIGluCi9ob21lL3BhdWx1cy9rZXJuZWwv
a3ZtL2FyY2gvcG93ZXJwYy9rdm0vYm9vazNzLmM6Nzk1OjE6IHdhcm5pbmc6IGNvbnRyb2wgcmVh
Y2hlcyBlbmQgb2Ygbm9uLXZvaWQgZnVuY3Rpb24gWy1XcmV0dXJuLXR5cGVdCiB9CiBeCm1ha2Vb
M106ICoqKiBbL2hvbWUvcGF1bHVzL2tlcm5lbC9rdm0vc2NyaXB0cy9NYWtlZmlsZS5idWlsZDoy
NjY6IGFyY2gvcG93ZXJwYy9rdm0vYm9vazNzLm9dIEVycm9yIDEKCj4gZGlmZiAtLWdpdCBhL2Fy
Y2gvcG93ZXJwYy9rdm0vYm9vazNzLmMgYi9hcmNoL3Bvd2VycGMva3ZtL2Jvb2szcy5jCj4gaW5k
ZXggMTMzODU2NTZiOTBkLi41YWQyMGZjMGM2YTEgMTAwNjQ0Cj4gLS0tIGEvYXJjaC9wb3dlcnBj
L2t2bS9ib29rM3MuYwo+ICsrKyBiL2FyY2gvcG93ZXJwYy9rdm0vYm9vazNzLmMKPiBAQCAtNzg5
LDEwICs3ODksOSBAQCB2b2lkIGt2bXBwY19kZWNyZW1lbnRlcl9mdW5jKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSkKPiAgCWt2bV92Y3B1X2tpY2sodmNwdSk7Cj4gIH0KPiAgCj4gLWludCBrdm1wcGNf
Y29yZV92Y3B1X2NyZWF0ZShzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwK
PiAtCQkJICAgIHVuc2lnbmVkIGludCBpZCkKPiAraW50IGt2bXBwY19jb3JlX3ZjcHVfY3JlYXRl
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKPiAgewo+IC0JcmV0dXJuIGt2bS0+YXJjaC5rdm1fb3Bz
LT52Y3B1X2NyZWF0ZShrdm0sIHZjcHUsIGlkKTsKPiArCXJldHVybiBrdm0tPmFyY2gua3ZtX29w
cy0+dmNwdV9jcmVhdGUodmNwdSk7CgpOZWVkcyBzL2t2bS92Y3B1LT5rdm0vIGhlcmUuCgpZb3Ug
YWxzbyBuZWVkIHRvIGNoYW5nZSB0aGUgZGVjbGFyYXRpb24gb2YgdGhlIHZjcHVfY3JlYXRlIGZ1
bmN0aW9uCnBvaW50ZXIgaW4gdGhlIGt2bXBwY19vcHMgc3RydWN0IGluIGt2bV9wcGMuaCB0byBo
YXZlIGp1c3QgdGhlIHZjcHUKcGFyYW1ldGVyIGluc3RlYWQgb2YgMyBwYXJhbWV0ZXJzLgoKUGF1
bC4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJt
IG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMu
Y3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
