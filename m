Return-Path: <SRS0=Hq6c=2H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C2AC2D0BF
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 20:41:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E44AA2176D
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 20:41:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E44AA2176D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99D594AEB3;
	Tue, 17 Dec 2019 15:41:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pk+rrmphCJSE; Tue, 17 Dec 2019 15:41:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2153C4AEDE;
	Tue, 17 Dec 2019 15:40:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4686B4A535
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 15:40:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3Sq65jWuvf8Y for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Dec 2019 15:40:47 -0500 (EST)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 72DF14A94D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 15:40:46 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
 by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 17 Dec 2019 12:40:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,326,1571727600"; d="scan'208";a="389952600"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by orsmga005.jf.intel.com with ESMTP; 17 Dec 2019 12:40:42 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: James Hogan <jhogan@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH v4 09/19] KVM: Move setting of memslot into helper routine
Date: Tue, 17 Dec 2019 12:40:31 -0800
Message-Id: <20191217204041.10815-10-sean.j.christopherson@intel.com>
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

U3BsaXQgb3V0IHRoZSBjb3JlIGZ1bmN0aW9uYWxpdHkgb2Ygc2V0dGluZyBhIG1lbXNsb3QgaW50
byBhIHNlcGFyYXRlCmhlbHBlciBpbiBwcmVwYXJhdGlvbiBmb3IgbW92aW5nIG1lbXNsb3QgZGVs
ZXRpb24gaW50byBpdHMgb3duIHJvdXRpbmUuCgpUZXN0ZWQtYnk6IENocmlzdG9mZmVyIERhbGwg
PGNocmlzdG9mZmVyLmRhbGxAYXJtLmNvbT4KUmV2aWV3ZWQtYnk6IFBoaWxpcHBlIE1hdGhpZXUt
RGF1ZMOpIDxmNGJ1Z0BhbXNhdC5vcmc+ClNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJz
b24gPHNlYW4uai5jaHJpc3RvcGhlcnNvbkBpbnRlbC5jb20+Ci0tLQogdmlydC9rdm0va3ZtX21h
aW4uYyB8IDEwNiArKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLQog
MSBmaWxlIGNoYW5nZWQsIDYzIGluc2VydGlvbnMoKyksIDQzIGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL3ZpcnQva3ZtL2t2bV9tYWluLmMgYi92aXJ0L2t2bS9rdm1fbWFpbi5jCmluZGV4IDlj
NDg4YzY1MzI1Ny4uMzY2M2FjMjI5YzRkIDEwMDY0NAotLS0gYS92aXJ0L2t2bS9rdm1fbWFpbi5j
CisrKyBiL3ZpcnQva3ZtL2t2bV9tYWluLmMKQEAgLTk4Niw2ICs5ODYsNjYgQEAgc3RhdGljIHN0
cnVjdCBrdm1fbWVtc2xvdHMgKmluc3RhbGxfbmV3X21lbXNsb3RzKHN0cnVjdCBrdm0gKmt2bSwK
IAlyZXR1cm4gb2xkX21lbXNsb3RzOwogfQogCitzdGF0aWMgaW50IGt2bV9zZXRfbWVtc2xvdChz
dHJ1Y3Qga3ZtICprdm0sCisJCQkgICBjb25zdCBzdHJ1Y3Qga3ZtX3VzZXJzcGFjZV9tZW1vcnlf
cmVnaW9uICptZW0sCisJCQkgICBjb25zdCBzdHJ1Y3Qga3ZtX21lbW9yeV9zbG90ICpvbGQsCisJ
CQkgICBzdHJ1Y3Qga3ZtX21lbW9yeV9zbG90ICpuZXcsIGludCBhc19pZCwKKwkJCSAgIGVudW0g
a3ZtX21yX2NoYW5nZSBjaGFuZ2UpCit7CisJc3RydWN0IGt2bV9tZW1vcnlfc2xvdCAqc2xvdDsK
KwlzdHJ1Y3Qga3ZtX21lbXNsb3RzICpzbG90czsKKwlpbnQgcjsKKworCXNsb3RzID0ga3Z6YWxs
b2Moc2l6ZW9mKHN0cnVjdCBrdm1fbWVtc2xvdHMpLCBHRlBfS0VSTkVMX0FDQ09VTlQpOworCWlm
ICghc2xvdHMpCisJCXJldHVybiAtRU5PTUVNOworCW1lbWNweShzbG90cywgX19rdm1fbWVtc2xv
dHMoa3ZtLCBhc19pZCksIHNpemVvZihzdHJ1Y3Qga3ZtX21lbXNsb3RzKSk7CisKKwlpZiAoY2hh
bmdlID09IEtWTV9NUl9ERUxFVEUgfHwgY2hhbmdlID09IEtWTV9NUl9NT1ZFKSB7CisJCS8qCisJ
CSAqIE5vdGUsIHRoZSBJTlZBTElEIGZsYWcgbmVlZHMgdG8gYmUgaW4gdGhlIGFwcHJvcHJpYXRl
IGVudHJ5CisJCSAqIGluIHRoZSBmcmVzaGx5IGFsbG9jYXRlZCBtZW1zbG90cywgbm90IGluIEBv
bGQgb3IgQG5ldy4KKwkJICovCisJCXNsb3QgPSBpZF90b19tZW1zbG90KHNsb3RzLCBvbGQtPmlk
KTsKKwkJc2xvdC0+ZmxhZ3MgfD0gS1ZNX01FTVNMT1RfSU5WQUxJRDsKKworCQkvKgorCQkgKiBX
ZSBjYW4gcmUtdXNlIHRoZSBvbGQgbWVtc2xvdHMsIHRoZSBvbmx5IGRpZmZlcmVuY2UgZnJvbSB0
aGUKKwkJICogbmV3bHkgaW5zdGFsbGVkIG1lbXNsb3RzIGlzIHRoZSBpbnZhbGlkIGZsYWcsIHdo
aWNoIHdpbGwgZ2V0CisJCSAqIGRyb3BwZWQgYnkgdXBkYXRlX21lbXNsb3RzIGFueXdheS4gIFdl
J2xsIGFsc28gcmV2ZXJ0IHRvIHRoZQorCQkgKiBvbGQgbWVtc2xvdHMgaWYgcHJlcGFyaW5nIHRo
ZSBuZXcgbWVtb3J5IHJlZ2lvbiBmYWlscy4KKwkJICovCisJCXNsb3RzID0gaW5zdGFsbF9uZXdf
bWVtc2xvdHMoa3ZtLCBhc19pZCwgc2xvdHMpOworCisJCS8qIEZyb20gdGhpcyBwb2ludCBubyBu
ZXcgc2hhZG93IHBhZ2VzIHBvaW50aW5nIHRvIGEgZGVsZXRlZCwKKwkJICogb3IgbW92ZWQsIG1l
bXNsb3Qgd2lsbCBiZSBjcmVhdGVkLgorCQkgKgorCQkgKiB2YWxpZGF0aW9uIG9mIHNwLT5nZm4g
aGFwcGVucyBpbjoKKwkJICoJLSBnZm5fdG9faHZhIChrdm1fcmVhZF9ndWVzdCwgZ2ZuX3RvX3Bm
bikKKwkJICoJLSBrdm1faXNfdmlzaWJsZV9nZm4gKG1tdV9jaGVja19yb290cykKKwkJICovCisJ
CWt2bV9hcmNoX2ZsdXNoX3NoYWRvd19tZW1zbG90KGt2bSwgc2xvdCk7CisJfQorCisJciA9IGt2
bV9hcmNoX3ByZXBhcmVfbWVtb3J5X3JlZ2lvbihrdm0sIG5ldywgbWVtLCBjaGFuZ2UpOworCWlm
IChyKQorCQlnb3RvIG91dF9zbG90czsKKworCXVwZGF0ZV9tZW1zbG90cyhzbG90cywgbmV3LCBj
aGFuZ2UpOworCXNsb3RzID0gaW5zdGFsbF9uZXdfbWVtc2xvdHMoa3ZtLCBhc19pZCwgc2xvdHMp
OworCisJa3ZtX2FyY2hfY29tbWl0X21lbW9yeV9yZWdpb24oa3ZtLCBtZW0sIG9sZCwgbmV3LCBj
aGFuZ2UpOworCisJa3ZmcmVlKHNsb3RzKTsKKwlyZXR1cm4gMDsKKworb3V0X3Nsb3RzOgorCWlm
IChjaGFuZ2UgPT0gS1ZNX01SX0RFTEVURSB8fCBjaGFuZ2UgPT0gS1ZNX01SX01PVkUpCisJCXNs
b3RzID0gaW5zdGFsbF9uZXdfbWVtc2xvdHMoa3ZtLCBhc19pZCwgc2xvdHMpOworCWt2ZnJlZShz
bG90cyk7CisJcmV0dXJuIHI7Cit9CisKIC8qCiAgKiBBbGxvY2F0ZSBzb21lIG1lbW9yeSBhbmQg
Z2l2ZSBpdCBhbiBhZGRyZXNzIGluIHRoZSBndWVzdCBwaHlzaWNhbCBhZGRyZXNzCiAgKiBzcGFj
ZS4KQEAgLTEwMDIsNyArMTA2Miw2IEBAIGludCBfX2t2bV9zZXRfbWVtb3J5X3JlZ2lvbihzdHJ1
Y3Qga3ZtICprdm0sCiAJdW5zaWduZWQgbG9uZyBucGFnZXM7CiAJc3RydWN0IGt2bV9tZW1vcnlf
c2xvdCAqc2xvdDsKIAlzdHJ1Y3Qga3ZtX21lbW9yeV9zbG90IG9sZCwgbmV3OwotCXN0cnVjdCBr
dm1fbWVtc2xvdHMgKnNsb3RzOwogCWludCBhc19pZCwgaWQ7CiAJZW51bSBrdm1fbXJfY2hhbmdl
IGNoYW5nZTsKIApAQCAtMTA4OSw1OCArMTE0OCwxOSBAQCBpbnQgX19rdm1fc2V0X21lbW9yeV9y
ZWdpb24oc3RydWN0IGt2bSAqa3ZtLAogCQkJcmV0dXJuIHI7CiAJfQogCi0Jc2xvdHMgPSBrdnph
bGxvYyhzaXplb2Yoc3RydWN0IGt2bV9tZW1zbG90cyksIEdGUF9LRVJORUxfQUNDT1VOVCk7Ci0J
aWYgKCFzbG90cykgewotCQlyID0gLUVOT01FTTsKLQkJZ290byBvdXRfYml0bWFwOwotCX0KLQlt
ZW1jcHkoc2xvdHMsIF9fa3ZtX21lbXNsb3RzKGt2bSwgYXNfaWQpLCBzaXplb2Yoc3RydWN0IGt2
bV9tZW1zbG90cykpOwotCi0JaWYgKChjaGFuZ2UgPT0gS1ZNX01SX0RFTEVURSkgfHwgKGNoYW5n
ZSA9PSBLVk1fTVJfTU9WRSkpIHsKLQkJc2xvdCA9IGlkX3RvX21lbXNsb3Qoc2xvdHMsIGlkKTsK
LQkJc2xvdC0+ZmxhZ3MgfD0gS1ZNX01FTVNMT1RfSU5WQUxJRDsKLQotCQkvKgotCQkgKiBXZSBj
YW4gcmUtdXNlIHRoZSBvbGQgbWVtc2xvdHMsIHRoZSBvbmx5IGRpZmZlcmVuY2UgZnJvbSB0aGUK
LQkJICogbmV3bHkgaW5zdGFsbGVkIG1lbXNsb3RzIGlzIHRoZSBpbnZhbGlkIGZsYWcsIHdoaWNo
IHdpbGwgZ2V0Ci0JCSAqIGRyb3BwZWQgYnkgdXBkYXRlX21lbXNsb3RzIGFueXdheS4gIFdlJ2xs
IGFsc28gcmV2ZXJ0IHRvIHRoZQotCQkgKiBvbGQgbWVtc2xvdHMgaWYgcHJlcGFyaW5nIHRoZSBu
ZXcgbWVtb3J5IHJlZ2lvbiBmYWlscy4KLQkJICovCi0JCXNsb3RzID0gaW5zdGFsbF9uZXdfbWVt
c2xvdHMoa3ZtLCBhc19pZCwgc2xvdHMpOwotCi0JCS8qIEZyb20gdGhpcyBwb2ludCBubyBuZXcg
c2hhZG93IHBhZ2VzIHBvaW50aW5nIHRvIGEgZGVsZXRlZCwKLQkJICogb3IgbW92ZWQsIG1lbXNs
b3Qgd2lsbCBiZSBjcmVhdGVkLgotCQkgKgotCQkgKiB2YWxpZGF0aW9uIG9mIHNwLT5nZm4gaGFw
cGVucyBpbjoKLQkJICoJLSBnZm5fdG9faHZhIChrdm1fcmVhZF9ndWVzdCwgZ2ZuX3RvX3BmbikK
LQkJICoJLSBrdm1faXNfdmlzaWJsZV9nZm4gKG1tdV9jaGVja19yb290cykKLQkJICovCi0JCWt2
bV9hcmNoX2ZsdXNoX3NoYWRvd19tZW1zbG90KGt2bSwgc2xvdCk7Ci0JfQotCi0JciA9IGt2bV9h
cmNoX3ByZXBhcmVfbWVtb3J5X3JlZ2lvbihrdm0sICZuZXcsIG1lbSwgY2hhbmdlKTsKLQlpZiAo
cikKLQkJZ290byBvdXRfc2xvdHM7Ci0KIAkvKiBhY3R1YWwgbWVtb3J5IGlzIGZyZWVkIHZpYSBv
bGQgaW4ga3ZtX2ZyZWVfbWVtc2xvdCBiZWxvdyAqLwogCWlmIChjaGFuZ2UgPT0gS1ZNX01SX0RF
TEVURSkgewogCQluZXcuZGlydHlfYml0bWFwID0gTlVMTDsKIAkJbWVtc2V0KCZuZXcuYXJjaCwg
MCwgc2l6ZW9mKG5ldy5hcmNoKSk7CiAJfQogCi0JdXBkYXRlX21lbXNsb3RzKHNsb3RzLCAmbmV3
LCBjaGFuZ2UpOwotCXNsb3RzID0gaW5zdGFsbF9uZXdfbWVtc2xvdHMoa3ZtLCBhc19pZCwgc2xv
dHMpOwotCi0Ja3ZtX2FyY2hfY29tbWl0X21lbW9yeV9yZWdpb24oa3ZtLCBtZW0sICZvbGQsICZu
ZXcsIGNoYW5nZSk7CisJciA9IGt2bV9zZXRfbWVtc2xvdChrdm0sIG1lbSwgJm9sZCwgJm5ldywg
YXNfaWQsIGNoYW5nZSk7CisJaWYgKHIpCisJCWdvdG8gb3V0X2JpdG1hcDsKIAogCWt2bV9mcmVl
X21lbXNsb3Qoa3ZtLCAmb2xkLCAmbmV3KTsKLQlrdmZyZWUoc2xvdHMpOwogCXJldHVybiAwOwog
Ci1vdXRfc2xvdHM6Ci0JaWYgKGNoYW5nZSA9PSBLVk1fTVJfREVMRVRFIHx8IGNoYW5nZSA9PSBL
Vk1fTVJfTU9WRSkKLQkJc2xvdHMgPSBpbnN0YWxsX25ld19tZW1zbG90cyhrdm0sIGFzX2lkLCBz
bG90cyk7Ci0Ja3ZmcmVlKHNsb3RzKTsKIG91dF9iaXRtYXA6CiAJaWYgKG5ldy5kaXJ0eV9iaXRt
YXAgJiYgIW9sZC5kaXJ0eV9iaXRtYXApCiAJCWt2bV9kZXN0cm95X2RpcnR5X2JpdG1hcCgmbmV3
KTsKLS0gCjIuMjQuMQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0
dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
