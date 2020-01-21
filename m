Return-Path: <SRS0=DlSC=3K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B70AC33CB8
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 22:32:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D29F624656
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 22:32:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D29F624656
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C2594AEBC;
	Tue, 21 Jan 2020 17:32:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1OSIBiJ4WqF2; Tue, 21 Jan 2020 17:32:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FD5D4AF14;
	Tue, 21 Jan 2020 17:32:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B4524ACF2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 17:32:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7XqI8zMBFUgA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 17:32:05 -0500 (EST)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A64094A65C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 17:32:05 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 21 Jan 2020 14:32:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,347,1574150400"; d="scan'208";a="244845136"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by orsmga002.jf.intel.com with ESMTP; 21 Jan 2020 14:32:03 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v5 09/19] KVM: Move setting of memslot into helper routine
Date: Tue, 21 Jan 2020 14:31:47 -0800
Message-Id: <20200121223157.15263-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200121223157.15263-1-sean.j.christopherson@intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
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
LWdpdCBhL3ZpcnQva3ZtL2t2bV9tYWluLmMgYi92aXJ0L2t2bS9rdm1fbWFpbi5jCmluZGV4IGZk
ZjA0NWE1ZDI0MC4uNjRmNmM1ZDM1MjYwIDEwMDY0NAotLS0gYS92aXJ0L2t2bS9rdm1fbWFpbi5j
CisrKyBiL3ZpcnQva3ZtL2t2bV9tYWluLmMKQEAgLTk4Miw2ICs5ODIsNjYgQEAgc3RhdGljIHN0
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
bikKKwkJICoJLSBrdm1faXNfdmlzaWJsZV9nZm4gKG1tdV9jaGVja19yb290KQorCQkgKi8KKwkJ
a3ZtX2FyY2hfZmx1c2hfc2hhZG93X21lbXNsb3Qoa3ZtLCBzbG90KTsKKwl9CisKKwlyID0ga3Zt
X2FyY2hfcHJlcGFyZV9tZW1vcnlfcmVnaW9uKGt2bSwgbmV3LCBtZW0sIGNoYW5nZSk7CisJaWYg
KHIpCisJCWdvdG8gb3V0X3Nsb3RzOworCisJdXBkYXRlX21lbXNsb3RzKHNsb3RzLCBuZXcsIGNo
YW5nZSk7CisJc2xvdHMgPSBpbnN0YWxsX25ld19tZW1zbG90cyhrdm0sIGFzX2lkLCBzbG90cyk7
CisKKwlrdm1fYXJjaF9jb21taXRfbWVtb3J5X3JlZ2lvbihrdm0sIG1lbSwgb2xkLCBuZXcsIGNo
YW5nZSk7CisKKwlrdmZyZWUoc2xvdHMpOworCXJldHVybiAwOworCitvdXRfc2xvdHM6CisJaWYg
KGNoYW5nZSA9PSBLVk1fTVJfREVMRVRFIHx8IGNoYW5nZSA9PSBLVk1fTVJfTU9WRSkKKwkJc2xv
dHMgPSBpbnN0YWxsX25ld19tZW1zbG90cyhrdm0sIGFzX2lkLCBzbG90cyk7CisJa3ZmcmVlKHNs
b3RzKTsKKwlyZXR1cm4gcjsKK30KKwogLyoKICAqIEFsbG9jYXRlIHNvbWUgbWVtb3J5IGFuZCBn
aXZlIGl0IGFuIGFkZHJlc3MgaW4gdGhlIGd1ZXN0IHBoeXNpY2FsIGFkZHJlc3MKICAqIHNwYWNl
LgpAQCAtOTk4LDcgKzEwNTgsNiBAQCBpbnQgX19rdm1fc2V0X21lbW9yeV9yZWdpb24oc3RydWN0
IGt2bSAqa3ZtLAogCXVuc2lnbmVkIGxvbmcgbnBhZ2VzOwogCXN0cnVjdCBrdm1fbWVtb3J5X3Ns
b3QgKnNsb3Q7CiAJc3RydWN0IGt2bV9tZW1vcnlfc2xvdCBvbGQsIG5ldzsKLQlzdHJ1Y3Qga3Zt
X21lbXNsb3RzICpzbG90czsKIAlpbnQgYXNfaWQsIGlkOwogCWVudW0ga3ZtX21yX2NoYW5nZSBj
aGFuZ2U7CiAKQEAgLTEwODUsNTggKzExNDQsMTkgQEAgaW50IF9fa3ZtX3NldF9tZW1vcnlfcmVn
aW9uKHN0cnVjdCBrdm0gKmt2bSwKIAkJCXJldHVybiByOwogCX0KIAotCXNsb3RzID0ga3Z6YWxs
b2Moc2l6ZW9mKHN0cnVjdCBrdm1fbWVtc2xvdHMpLCBHRlBfS0VSTkVMX0FDQ09VTlQpOwotCWlm
ICghc2xvdHMpIHsKLQkJciA9IC1FTk9NRU07Ci0JCWdvdG8gb3V0X2JpdG1hcDsKLQl9Ci0JbWVt
Y3B5KHNsb3RzLCBfX2t2bV9tZW1zbG90cyhrdm0sIGFzX2lkKSwgc2l6ZW9mKHN0cnVjdCBrdm1f
bWVtc2xvdHMpKTsKLQotCWlmICgoY2hhbmdlID09IEtWTV9NUl9ERUxFVEUpIHx8IChjaGFuZ2Ug
PT0gS1ZNX01SX01PVkUpKSB7Ci0JCXNsb3QgPSBpZF90b19tZW1zbG90KHNsb3RzLCBpZCk7Ci0J
CXNsb3QtPmZsYWdzIHw9IEtWTV9NRU1TTE9UX0lOVkFMSUQ7Ci0KLQkJLyoKLQkJICogV2UgY2Fu
IHJlLXVzZSB0aGUgb2xkIG1lbXNsb3RzLCB0aGUgb25seSBkaWZmZXJlbmNlIGZyb20gdGhlCi0J
CSAqIG5ld2x5IGluc3RhbGxlZCBtZW1zbG90cyBpcyB0aGUgaW52YWxpZCBmbGFnLCB3aGljaCB3
aWxsIGdldAotCQkgKiBkcm9wcGVkIGJ5IHVwZGF0ZV9tZW1zbG90cyBhbnl3YXkuICBXZSdsbCBh
bHNvIHJldmVydCB0byB0aGUKLQkJICogb2xkIG1lbXNsb3RzIGlmIHByZXBhcmluZyB0aGUgbmV3
IG1lbW9yeSByZWdpb24gZmFpbHMuCi0JCSAqLwotCQlzbG90cyA9IGluc3RhbGxfbmV3X21lbXNs
b3RzKGt2bSwgYXNfaWQsIHNsb3RzKTsKLQotCQkvKiBGcm9tIHRoaXMgcG9pbnQgbm8gbmV3IHNo
YWRvdyBwYWdlcyBwb2ludGluZyB0byBhIGRlbGV0ZWQsCi0JCSAqIG9yIG1vdmVkLCBtZW1zbG90
IHdpbGwgYmUgY3JlYXRlZC4KLQkJICoKLQkJICogdmFsaWRhdGlvbiBvZiBzcC0+Z2ZuIGhhcHBl
bnMgaW46Ci0JCSAqCS0gZ2ZuX3RvX2h2YSAoa3ZtX3JlYWRfZ3Vlc3QsIGdmbl90b19wZm4pCi0J
CSAqCS0ga3ZtX2lzX3Zpc2libGVfZ2ZuIChtbXVfY2hlY2tfcm9vdCkKLQkJICovCi0JCWt2bV9h
cmNoX2ZsdXNoX3NoYWRvd19tZW1zbG90KGt2bSwgc2xvdCk7Ci0JfQotCi0JciA9IGt2bV9hcmNo
X3ByZXBhcmVfbWVtb3J5X3JlZ2lvbihrdm0sICZuZXcsIG1lbSwgY2hhbmdlKTsKLQlpZiAocikK
LQkJZ290byBvdXRfc2xvdHM7Ci0KIAkvKiBhY3R1YWwgbWVtb3J5IGlzIGZyZWVkIHZpYSBvbGQg
aW4ga3ZtX2ZyZWVfbWVtc2xvdCBiZWxvdyAqLwogCWlmIChjaGFuZ2UgPT0gS1ZNX01SX0RFTEVU
RSkgewogCQluZXcuZGlydHlfYml0bWFwID0gTlVMTDsKIAkJbWVtc2V0KCZuZXcuYXJjaCwgMCwg
c2l6ZW9mKG5ldy5hcmNoKSk7CiAJfQogCi0JdXBkYXRlX21lbXNsb3RzKHNsb3RzLCAmbmV3LCBj
aGFuZ2UpOwotCXNsb3RzID0gaW5zdGFsbF9uZXdfbWVtc2xvdHMoa3ZtLCBhc19pZCwgc2xvdHMp
OwotCi0Ja3ZtX2FyY2hfY29tbWl0X21lbW9yeV9yZWdpb24oa3ZtLCBtZW0sICZvbGQsICZuZXcs
IGNoYW5nZSk7CisJciA9IGt2bV9zZXRfbWVtc2xvdChrdm0sIG1lbSwgJm9sZCwgJm5ldywgYXNf
aWQsIGNoYW5nZSk7CisJaWYgKHIpCisJCWdvdG8gb3V0X2JpdG1hcDsKIAogCWt2bV9mcmVlX21l
bXNsb3Qoa3ZtLCAmb2xkLCAmbmV3KTsKLQlrdmZyZWUoc2xvdHMpOwogCXJldHVybiAwOwogCi1v
dXRfc2xvdHM6Ci0JaWYgKGNoYW5nZSA9PSBLVk1fTVJfREVMRVRFIHx8IGNoYW5nZSA9PSBLVk1f
TVJfTU9WRSkKLQkJc2xvdHMgPSBpbnN0YWxsX25ld19tZW1zbG90cyhrdm0sIGFzX2lkLCBzbG90
cyk7Ci0Ja3ZmcmVlKHNsb3RzKTsKIG91dF9iaXRtYXA6CiAJaWYgKG5ldy5kaXJ0eV9iaXRtYXAg
JiYgIW9sZC5kaXJ0eV9iaXRtYXApCiAJCWt2bV9kZXN0cm95X2RpcnR5X2JpdG1hcCgmbmV3KTsK
LS0gCjIuMjQuMQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBz
Oi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
