Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7353BC34031
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 21:08:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 312132176D
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 21:08:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 312132176D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D32EA4AEFC;
	Tue, 18 Feb 2020 16:08:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id knbRhj2GuXvs; Tue, 18 Feb 2020 16:08:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E23564AF89;
	Tue, 18 Feb 2020 16:07:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E61254AF60
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 16:07:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oVsnprIQS6Pu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 16:07:48 -0500 (EST)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 41FF14AF27
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 16:07:48 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 18 Feb 2020 13:07:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,457,1574150400"; d="scan'208";a="253856422"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by orsmga002.jf.intel.com with ESMTP; 18 Feb 2020 13:07:45 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v6 09/22] KVM: Move setting of memslot into helper routine
Date: Tue, 18 Feb 2020 13:07:23 -0800
Message-Id: <20200218210736.16432-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218210736.16432-1-sean.j.christopherson@intel.com>
References: <20200218210736.16432-1-sean.j.christopherson@intel.com>
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
RGF1ZMOpIDxmNGJ1Z0BhbXNhdC5vcmc+ClJldmlld2VkLWJ5OiBQZXRlciBYdSA8cGV0ZXJ4QHJl
ZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW4uai5jaHJp
c3RvcGhlcnNvbkBpbnRlbC5jb20+Ci0tLQogdmlydC9rdm0va3ZtX21haW4uYyB8IDEwNiArKysr
KysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQs
IDYzIGluc2VydGlvbnMoKyksIDQzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL3ZpcnQva3Zt
L2t2bV9tYWluLmMgYi92aXJ0L2t2bS9rdm1fbWFpbi5jCmluZGV4IGNhMzk3OTkyZTg3OS4uODRj
MDNmYjYwZDQwIDEwMDY0NAotLS0gYS92aXJ0L2t2bS9rdm1fbWFpbi5jCisrKyBiL3ZpcnQva3Zt
L2t2bV9tYWluLmMKQEAgLTk4Myw2ICs5ODMsNjYgQEAgc3RhdGljIHN0cnVjdCBrdm1fbWVtc2xv
dHMgKmluc3RhbGxfbmV3X21lbXNsb3RzKHN0cnVjdCBrdm0gKmt2bSwKIAlyZXR1cm4gb2xkX21l
bXNsb3RzOwogfQogCitzdGF0aWMgaW50IGt2bV9zZXRfbWVtc2xvdChzdHJ1Y3Qga3ZtICprdm0s
CisJCQkgICBjb25zdCBzdHJ1Y3Qga3ZtX3VzZXJzcGFjZV9tZW1vcnlfcmVnaW9uICptZW0sCisJ
CQkgICBjb25zdCBzdHJ1Y3Qga3ZtX21lbW9yeV9zbG90ICpvbGQsCisJCQkgICBzdHJ1Y3Qga3Zt
X21lbW9yeV9zbG90ICpuZXcsIGludCBhc19pZCwKKwkJCSAgIGVudW0ga3ZtX21yX2NoYW5nZSBj
aGFuZ2UpCit7CisJc3RydWN0IGt2bV9tZW1vcnlfc2xvdCAqc2xvdDsKKwlzdHJ1Y3Qga3ZtX21l
bXNsb3RzICpzbG90czsKKwlpbnQgcjsKKworCXNsb3RzID0ga3Z6YWxsb2Moc2l6ZW9mKHN0cnVj
dCBrdm1fbWVtc2xvdHMpLCBHRlBfS0VSTkVMX0FDQ09VTlQpOworCWlmICghc2xvdHMpCisJCXJl
dHVybiAtRU5PTUVNOworCW1lbWNweShzbG90cywgX19rdm1fbWVtc2xvdHMoa3ZtLCBhc19pZCks
IHNpemVvZihzdHJ1Y3Qga3ZtX21lbXNsb3RzKSk7CisKKwlpZiAoY2hhbmdlID09IEtWTV9NUl9E
RUxFVEUgfHwgY2hhbmdlID09IEtWTV9NUl9NT1ZFKSB7CisJCS8qCisJCSAqIE5vdGUsIHRoZSBJ
TlZBTElEIGZsYWcgbmVlZHMgdG8gYmUgaW4gdGhlIGFwcHJvcHJpYXRlIGVudHJ5CisJCSAqIGlu
IHRoZSBmcmVzaGx5IGFsbG9jYXRlZCBtZW1zbG90cywgbm90IGluIEBvbGQgb3IgQG5ldy4KKwkJ
ICovCisJCXNsb3QgPSBpZF90b19tZW1zbG90KHNsb3RzLCBvbGQtPmlkKTsKKwkJc2xvdC0+Zmxh
Z3MgfD0gS1ZNX01FTVNMT1RfSU5WQUxJRDsKKworCQkvKgorCQkgKiBXZSBjYW4gcmUtdXNlIHRo
ZSBvbGQgbWVtc2xvdHMsIHRoZSBvbmx5IGRpZmZlcmVuY2UgZnJvbSB0aGUKKwkJICogbmV3bHkg
aW5zdGFsbGVkIG1lbXNsb3RzIGlzIHRoZSBpbnZhbGlkIGZsYWcsIHdoaWNoIHdpbGwgZ2V0CisJ
CSAqIGRyb3BwZWQgYnkgdXBkYXRlX21lbXNsb3RzIGFueXdheS4gIFdlJ2xsIGFsc28gcmV2ZXJ0
IHRvIHRoZQorCQkgKiBvbGQgbWVtc2xvdHMgaWYgcHJlcGFyaW5nIHRoZSBuZXcgbWVtb3J5IHJl
Z2lvbiBmYWlscy4KKwkJICovCisJCXNsb3RzID0gaW5zdGFsbF9uZXdfbWVtc2xvdHMoa3ZtLCBh
c19pZCwgc2xvdHMpOworCisJCS8qIEZyb20gdGhpcyBwb2ludCBubyBuZXcgc2hhZG93IHBhZ2Vz
IHBvaW50aW5nIHRvIGEgZGVsZXRlZCwKKwkJICogb3IgbW92ZWQsIG1lbXNsb3Qgd2lsbCBiZSBj
cmVhdGVkLgorCQkgKgorCQkgKiB2YWxpZGF0aW9uIG9mIHNwLT5nZm4gaGFwcGVucyBpbjoKKwkJ
ICoJLSBnZm5fdG9faHZhIChrdm1fcmVhZF9ndWVzdCwgZ2ZuX3RvX3BmbikKKwkJICoJLSBrdm1f
aXNfdmlzaWJsZV9nZm4gKG1tdV9jaGVja19yb290KQorCQkgKi8KKwkJa3ZtX2FyY2hfZmx1c2hf
c2hhZG93X21lbXNsb3Qoa3ZtLCBzbG90KTsKKwl9CisKKwlyID0ga3ZtX2FyY2hfcHJlcGFyZV9t
ZW1vcnlfcmVnaW9uKGt2bSwgbmV3LCBtZW0sIGNoYW5nZSk7CisJaWYgKHIpCisJCWdvdG8gb3V0
X3Nsb3RzOworCisJdXBkYXRlX21lbXNsb3RzKHNsb3RzLCBuZXcsIGNoYW5nZSk7CisJc2xvdHMg
PSBpbnN0YWxsX25ld19tZW1zbG90cyhrdm0sIGFzX2lkLCBzbG90cyk7CisKKwlrdm1fYXJjaF9j
b21taXRfbWVtb3J5X3JlZ2lvbihrdm0sIG1lbSwgb2xkLCBuZXcsIGNoYW5nZSk7CisKKwlrdmZy
ZWUoc2xvdHMpOworCXJldHVybiAwOworCitvdXRfc2xvdHM6CisJaWYgKGNoYW5nZSA9PSBLVk1f
TVJfREVMRVRFIHx8IGNoYW5nZSA9PSBLVk1fTVJfTU9WRSkKKwkJc2xvdHMgPSBpbnN0YWxsX25l
d19tZW1zbG90cyhrdm0sIGFzX2lkLCBzbG90cyk7CisJa3ZmcmVlKHNsb3RzKTsKKwlyZXR1cm4g
cjsKK30KKwogLyoKICAqIEFsbG9jYXRlIHNvbWUgbWVtb3J5IGFuZCBnaXZlIGl0IGFuIGFkZHJl
c3MgaW4gdGhlIGd1ZXN0IHBoeXNpY2FsIGFkZHJlc3MKICAqIHNwYWNlLgpAQCAtOTk5LDcgKzEw
NTksNiBAQCBpbnQgX19rdm1fc2V0X21lbW9yeV9yZWdpb24oc3RydWN0IGt2bSAqa3ZtLAogCXVu
c2lnbmVkIGxvbmcgbnBhZ2VzOwogCXN0cnVjdCBrdm1fbWVtb3J5X3Nsb3QgKnNsb3Q7CiAJc3Ry
dWN0IGt2bV9tZW1vcnlfc2xvdCBvbGQsIG5ldzsKLQlzdHJ1Y3Qga3ZtX21lbXNsb3RzICpzbG90
czsKIAlpbnQgYXNfaWQsIGlkOwogCWVudW0ga3ZtX21yX2NoYW5nZSBjaGFuZ2U7CiAKQEAgLTEw
ODYsNTggKzExNDUsMTkgQEAgaW50IF9fa3ZtX3NldF9tZW1vcnlfcmVnaW9uKHN0cnVjdCBrdm0g
Kmt2bSwKIAkJCXJldHVybiByOwogCX0KIAotCXNsb3RzID0ga3Z6YWxsb2Moc2l6ZW9mKHN0cnVj
dCBrdm1fbWVtc2xvdHMpLCBHRlBfS0VSTkVMX0FDQ09VTlQpOwotCWlmICghc2xvdHMpIHsKLQkJ
ciA9IC1FTk9NRU07Ci0JCWdvdG8gb3V0X2JpdG1hcDsKLQl9Ci0JbWVtY3B5KHNsb3RzLCBfX2t2
bV9tZW1zbG90cyhrdm0sIGFzX2lkKSwgc2l6ZW9mKHN0cnVjdCBrdm1fbWVtc2xvdHMpKTsKLQot
CWlmICgoY2hhbmdlID09IEtWTV9NUl9ERUxFVEUpIHx8IChjaGFuZ2UgPT0gS1ZNX01SX01PVkUp
KSB7Ci0JCXNsb3QgPSBpZF90b19tZW1zbG90KHNsb3RzLCBpZCk7Ci0JCXNsb3QtPmZsYWdzIHw9
IEtWTV9NRU1TTE9UX0lOVkFMSUQ7Ci0KLQkJLyoKLQkJICogV2UgY2FuIHJlLXVzZSB0aGUgb2xk
IG1lbXNsb3RzLCB0aGUgb25seSBkaWZmZXJlbmNlIGZyb20gdGhlCi0JCSAqIG5ld2x5IGluc3Rh
bGxlZCBtZW1zbG90cyBpcyB0aGUgaW52YWxpZCBmbGFnLCB3aGljaCB3aWxsIGdldAotCQkgKiBk
cm9wcGVkIGJ5IHVwZGF0ZV9tZW1zbG90cyBhbnl3YXkuICBXZSdsbCBhbHNvIHJldmVydCB0byB0
aGUKLQkJICogb2xkIG1lbXNsb3RzIGlmIHByZXBhcmluZyB0aGUgbmV3IG1lbW9yeSByZWdpb24g
ZmFpbHMuCi0JCSAqLwotCQlzbG90cyA9IGluc3RhbGxfbmV3X21lbXNsb3RzKGt2bSwgYXNfaWQs
IHNsb3RzKTsKLQotCQkvKiBGcm9tIHRoaXMgcG9pbnQgbm8gbmV3IHNoYWRvdyBwYWdlcyBwb2lu
dGluZyB0byBhIGRlbGV0ZWQsCi0JCSAqIG9yIG1vdmVkLCBtZW1zbG90IHdpbGwgYmUgY3JlYXRl
ZC4KLQkJICoKLQkJICogdmFsaWRhdGlvbiBvZiBzcC0+Z2ZuIGhhcHBlbnMgaW46Ci0JCSAqCS0g
Z2ZuX3RvX2h2YSAoa3ZtX3JlYWRfZ3Vlc3QsIGdmbl90b19wZm4pCi0JCSAqCS0ga3ZtX2lzX3Zp
c2libGVfZ2ZuIChtbXVfY2hlY2tfcm9vdCkKLQkJICovCi0JCWt2bV9hcmNoX2ZsdXNoX3NoYWRv
d19tZW1zbG90KGt2bSwgc2xvdCk7Ci0JfQotCi0JciA9IGt2bV9hcmNoX3ByZXBhcmVfbWVtb3J5
X3JlZ2lvbihrdm0sICZuZXcsIG1lbSwgY2hhbmdlKTsKLQlpZiAocikKLQkJZ290byBvdXRfc2xv
dHM7Ci0KIAkvKiBhY3R1YWwgbWVtb3J5IGlzIGZyZWVkIHZpYSBvbGQgaW4ga3ZtX2ZyZWVfbWVt
c2xvdCBiZWxvdyAqLwogCWlmIChjaGFuZ2UgPT0gS1ZNX01SX0RFTEVURSkgewogCQluZXcuZGly
dHlfYml0bWFwID0gTlVMTDsKIAkJbWVtc2V0KCZuZXcuYXJjaCwgMCwgc2l6ZW9mKG5ldy5hcmNo
KSk7CiAJfQogCi0JdXBkYXRlX21lbXNsb3RzKHNsb3RzLCAmbmV3LCBjaGFuZ2UpOwotCXNsb3Rz
ID0gaW5zdGFsbF9uZXdfbWVtc2xvdHMoa3ZtLCBhc19pZCwgc2xvdHMpOwotCi0Ja3ZtX2FyY2hf
Y29tbWl0X21lbW9yeV9yZWdpb24oa3ZtLCBtZW0sICZvbGQsICZuZXcsIGNoYW5nZSk7CisJciA9
IGt2bV9zZXRfbWVtc2xvdChrdm0sIG1lbSwgJm9sZCwgJm5ldywgYXNfaWQsIGNoYW5nZSk7CisJ
aWYgKHIpCisJCWdvdG8gb3V0X2JpdG1hcDsKIAogCWt2bV9mcmVlX21lbXNsb3Qoa3ZtLCAmb2xk
LCAmbmV3KTsKLQlrdmZyZWUoc2xvdHMpOwogCXJldHVybiAwOwogCi1vdXRfc2xvdHM6Ci0JaWYg
KGNoYW5nZSA9PSBLVk1fTVJfREVMRVRFIHx8IGNoYW5nZSA9PSBLVk1fTVJfTU9WRSkKLQkJc2xv
dHMgPSBpbnN0YWxsX25ld19tZW1zbG90cyhrdm0sIGFzX2lkLCBzbG90cyk7Ci0Ja3ZmcmVlKHNs
b3RzKTsKIG91dF9iaXRtYXA6CiAJaWYgKG5ldy5kaXJ0eV9iaXRtYXAgJiYgIW9sZC5kaXJ0eV9i
aXRtYXApCiAJCWt2bV9kZXN0cm95X2RpcnR5X2JpdG1hcCgmbmV3KTsKLS0gCjIuMjQuMQoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxp
bmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29s
dW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
