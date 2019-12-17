Return-Path: <SRS0=Hq6c=2H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36B9AC2D0D5
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 20:41:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E99A621582
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 20:40:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E99A621582
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A645B4AECA;
	Tue, 17 Dec 2019 15:40:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lepSM6S4tVyy; Tue, 17 Dec 2019 15:40:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82C194AECE;
	Tue, 17 Dec 2019 15:40:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8ED84AC88
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 15:40:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PZg8QD8y5uoE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Dec 2019 15:40:46 -0500 (EST)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 478C64A54B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 15:40:46 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
 by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 17 Dec 2019 12:40:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,326,1571727600"; d="scan'208";a="389952596"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by orsmga005.jf.intel.com with ESMTP; 17 Dec 2019 12:40:42 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: James Hogan <jhogan@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH v4 08/19] KVM: Refactor error handling for setting memory
 region
Date: Tue, 17 Dec 2019 12:40:30 -0800
Message-Id: <20191217204041.10815-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217204041.10815-1-sean.j.christopherson@intel.com>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: linux-arm-kernel@lists.infradead.org, Wanpeng Li <wanpengli@tencent.com>,
 =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Joerg Roedel <joro@8bytes.org>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
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

UmVwbGFjZSBhIGJpZyBwaWxlIG8nIGdvdG9zIHdpdGggcmV0dXJucyB0byBtYWtlIGl0IG1vcmUg
b2J2aW91cyB3aGF0CmVycm9yIGNvZGUgaXMgYmVpbmcgcmV0dXJuZWQsIGFuZCB0byBwcmVwYXJl
IGZvciByZWZhY3RvcmluZyB0aGUKZnVuY3Rpb25hbCwgaS5lLiBwb3N0LWNoZWNrcywgcG9ydGlv
biBvZiBfX2t2bV9zZXRfbWVtb3J5X3JlZ2lvbigpLgoKUmV2aWV3ZWQtYnk6IEphbm9zY2ggRnJh
bmsgPGZyYW5ramFAbGludXguaWJtLmNvbT4KUmV2aWV3ZWQtYnk6IFBoaWxpcHBlIE1hdGhpZXUt
RGF1ZMOpIDxmNGJ1Z0BhbXNhdC5vcmc+ClNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJz
b24gPHNlYW4uai5jaHJpc3RvcGhlcnNvbkBpbnRlbC5jb20+Ci0tLQogdmlydC9rdm0va3ZtX21h
aW4uYyB8IDQwICsrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIDEgZmls
ZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCAyMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS92aXJ0L2t2bS9rdm1fbWFpbi5jIGIvdmlydC9rdm0va3ZtX21haW4uYwppbmRleCA2YjIyNjFh
OWUxMzkuLjljNDg4YzY1MzI1NyAxMDA2NDQKLS0tIGEvdmlydC9rdm0va3ZtX21haW4uYworKysg
Yi92aXJ0L2t2bS9rdm1fbWFpbi5jCkBAIC0xMDA4LDM0ICsxMDA4LDMzIEBAIGludCBfX2t2bV9z
ZXRfbWVtb3J5X3JlZ2lvbihzdHJ1Y3Qga3ZtICprdm0sCiAKIAlyID0gY2hlY2tfbWVtb3J5X3Jl
Z2lvbl9mbGFncyhtZW0pOwogCWlmIChyKQotCQlnb3RvIG91dDsKKwkJcmV0dXJuIHI7CiAKLQly
ID0gLUVJTlZBTDsKIAlhc19pZCA9IG1lbS0+c2xvdCA+PiAxNjsKIAlpZCA9ICh1MTYpbWVtLT5z
bG90OwogCiAJLyogR2VuZXJhbCBzYW5pdHkgY2hlY2tzICovCiAJaWYgKG1lbS0+bWVtb3J5X3Np
emUgJiAoUEFHRV9TSVpFIC0gMSkpCi0JCWdvdG8gb3V0OworCQlyZXR1cm4gLUVJTlZBTDsKIAlp
ZiAobWVtLT5ndWVzdF9waHlzX2FkZHIgJiAoUEFHRV9TSVpFIC0gMSkpCi0JCWdvdG8gb3V0Owor
CQlyZXR1cm4gLUVJTlZBTDsKIAkvKiBXZSBjYW4gcmVhZCB0aGUgZ3Vlc3QgbWVtb3J5IHdpdGgg
X194eHhfdXNlcigpIGxhdGVyIG9uLiAqLwogCWlmICgoaWQgPCBLVk1fVVNFUl9NRU1fU0xPVFMp
ICYmCiAJICAgICgobWVtLT51c2Vyc3BhY2VfYWRkciAmIChQQUdFX1NJWkUgLSAxKSkgfHwKIAkg
ICAgICFhY2Nlc3Nfb2soKHZvaWQgX191c2VyICopKHVuc2lnbmVkIGxvbmcpbWVtLT51c2Vyc3Bh
Y2VfYWRkciwKIAkJCW1lbS0+bWVtb3J5X3NpemUpKSkKLQkJZ290byBvdXQ7CisJCXJldHVybiAt
RUlOVkFMOwogCWlmIChhc19pZCA+PSBLVk1fQUREUkVTU19TUEFDRV9OVU0gfHwgaWQgPj0gS1ZN
X01FTV9TTE9UU19OVU0pCi0JCWdvdG8gb3V0OworCQlyZXR1cm4gLUVJTlZBTDsKIAlpZiAobWVt
LT5ndWVzdF9waHlzX2FkZHIgKyBtZW0tPm1lbW9yeV9zaXplIDwgbWVtLT5ndWVzdF9waHlzX2Fk
ZHIpCi0JCWdvdG8gb3V0OworCQlyZXR1cm4gLUVJTlZBTDsKIAogCXNsb3QgPSBpZF90b19tZW1z
bG90KF9fa3ZtX21lbXNsb3RzKGt2bSwgYXNfaWQpLCBpZCk7CiAJYmFzZV9nZm4gPSBtZW0tPmd1
ZXN0X3BoeXNfYWRkciA+PiBQQUdFX1NISUZUOwogCW5wYWdlcyA9IG1lbS0+bWVtb3J5X3NpemUg
Pj4gUEFHRV9TSElGVDsKIAogCWlmIChucGFnZXMgPiBLVk1fTUVNX01BWF9OUl9QQUdFUykKLQkJ
Z290byBvdXQ7CisJCXJldHVybiAtRUlOVkFMOwogCiAJbmV3ID0gb2xkID0gKnNsb3Q7CiAKQEAg
LTEwNTIsMjAgKzEwNTEsMTggQEAgaW50IF9fa3ZtX3NldF9tZW1vcnlfcmVnaW9uKHN0cnVjdCBr
dm0gKmt2bSwKIAkJCWlmICgobmV3LnVzZXJzcGFjZV9hZGRyICE9IG9sZC51c2Vyc3BhY2VfYWRk
cikgfHwKIAkJCSAgICAobnBhZ2VzICE9IG9sZC5ucGFnZXMpIHx8CiAJCQkgICAgKChuZXcuZmxh
Z3MgXiBvbGQuZmxhZ3MpICYgS1ZNX01FTV9SRUFET05MWSkpCi0JCQkJZ290byBvdXQ7CisJCQkJ
cmV0dXJuIC1FSU5WQUw7CiAKIAkJCWlmIChiYXNlX2dmbiAhPSBvbGQuYmFzZV9nZm4pCiAJCQkJ
Y2hhbmdlID0gS1ZNX01SX01PVkU7CiAJCQllbHNlIGlmIChuZXcuZmxhZ3MgIT0gb2xkLmZsYWdz
KQogCQkJCWNoYW5nZSA9IEtWTV9NUl9GTEFHU19PTkxZOwotCQkJZWxzZSB7IC8qIE5vdGhpbmcg
dG8gY2hhbmdlLiAqLwotCQkJCXIgPSAwOwotCQkJCWdvdG8gb3V0OwotCQkJfQorCQkJZWxzZSAv
KiBOb3RoaW5nIHRvIGNoYW5nZS4gKi8KKwkJCQlyZXR1cm4gMDsKIAkJfQogCX0gZWxzZSB7CiAJ
CWlmICghb2xkLm5wYWdlcykKLQkJCWdvdG8gb3V0OworCQkJcmV0dXJuIC1FSU5WQUw7CiAKIAkJ
Y2hhbmdlID0gS1ZNX01SX0RFTEVURTsKIAkJbmV3LmJhc2VfZ2ZuID0gMDsKQEAgLTEwNzQsMjkg
KzEwNzEsMjkgQEAgaW50IF9fa3ZtX3NldF9tZW1vcnlfcmVnaW9uKHN0cnVjdCBrdm0gKmt2bSwK
IAogCWlmICgoY2hhbmdlID09IEtWTV9NUl9DUkVBVEUpIHx8IChjaGFuZ2UgPT0gS1ZNX01SX01P
VkUpKSB7CiAJCS8qIENoZWNrIGZvciBvdmVybGFwcyAqLwotCQlyID0gLUVFWElTVDsKIAkJa3Zt
X2Zvcl9lYWNoX21lbXNsb3Qoc2xvdCwgX19rdm1fbWVtc2xvdHMoa3ZtLCBhc19pZCkpIHsKIAkJ
CWlmIChzbG90LT5pZCA9PSBpZCkKIAkJCQljb250aW51ZTsKIAkJCWlmICghKChiYXNlX2dmbiAr
IG5wYWdlcyA8PSBzbG90LT5iYXNlX2dmbikgfHwKIAkJCSAgICAgIChiYXNlX2dmbiA+PSBzbG90
LT5iYXNlX2dmbiArIHNsb3QtPm5wYWdlcykpKQotCQkJCWdvdG8gb3V0OworCQkJCXJldHVybiAt
RUVYSVNUOwogCQl9CiAJfQogCi0JciA9IC1FTk9NRU07Ci0KIAkvKiBBbGxvY2F0ZS9mcmVlIHBh
Z2UgZGlydHkgYml0bWFwIGFzIG5lZWRlZCAqLwogCWlmICghKG5ldy5mbGFncyAmIEtWTV9NRU1f
TE9HX0RJUlRZX1BBR0VTKSkKIAkJbmV3LmRpcnR5X2JpdG1hcCA9IE5VTEw7CiAJZWxzZSBpZiAo
IW5ldy5kaXJ0eV9iaXRtYXApIHsKLQkJaWYgKGt2bV9jcmVhdGVfZGlydHlfYml0bWFwKCZuZXcp
IDwgMCkKLQkJCWdvdG8gb3V0OworCQlyID0ga3ZtX2NyZWF0ZV9kaXJ0eV9iaXRtYXAoJm5ldyk7
CisJCWlmIChyKQorCQkJcmV0dXJuIHI7CiAJfQogCiAJc2xvdHMgPSBrdnphbGxvYyhzaXplb2Yo
c3RydWN0IGt2bV9tZW1zbG90cyksIEdGUF9LRVJORUxfQUNDT1VOVCk7Ci0JaWYgKCFzbG90cykK
KwlpZiAoIXNsb3RzKSB7CisJCXIgPSAtRU5PTUVNOwogCQlnb3RvIG91dF9iaXRtYXA7CisJfQog
CW1lbWNweShzbG90cywgX19rdm1fbWVtc2xvdHMoa3ZtLCBhc19pZCksIHNpemVvZihzdHJ1Y3Qg
a3ZtX21lbXNsb3RzKSk7CiAKIAlpZiAoKGNoYW5nZSA9PSBLVk1fTVJfREVMRVRFKSB8fCAoY2hh
bmdlID09IEtWTV9NUl9NT1ZFKSkgewpAQCAtMTE0Nyw3ICsxMTQ0LDYgQEAgaW50IF9fa3ZtX3Nl
dF9tZW1vcnlfcmVnaW9uKHN0cnVjdCBrdm0gKmt2bSwKIG91dF9iaXRtYXA6CiAJaWYgKG5ldy5k
aXJ0eV9iaXRtYXAgJiYgIW9sZC5kaXJ0eV9iaXRtYXApCiAJCWt2bV9kZXN0cm95X2RpcnR5X2Jp
dG1hcCgmbmV3KTsKLW91dDoKIAlyZXR1cm4gcjsKIH0KIEVYUE9SVF9TWU1CT0xfR1BMKF9fa3Zt
X3NldF9tZW1vcnlfcmVnaW9uKTsKLS0gCjIuMjQuMQoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMu
Y3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlz
dGluZm8va3ZtYXJtCg==
